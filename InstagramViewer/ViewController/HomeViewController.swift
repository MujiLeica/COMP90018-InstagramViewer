//
//  HomeViewController.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 25/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    var postsId = [String]()
    var postId:String?
    var post:PostCell?
    var posts = [PostCell]()
    var RemovedPostUrl: String!
    var myLocation: CLLocation?
    var sortByTime = true
    var postUserId:String?
    

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Request location permission from user
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        //Load posts into table view
        //tableView.estimatedRowHeight = 300
        tableView.estimatedRowHeight = 450
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadPosts()
    }
    
    
    //Get user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            myLocation = location
//            print ("My Location: ")
//            print (myLocation!)
        }
    }
    
    //Show setting pop ups if user denied our location permission request
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Location Access Denied", message: "Need Location for Sorting Posts.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Sort posts by location and time
    @IBAction func SortFunction(_ sender: Any) {
        // By default, posts are sorted by time in reverse order
        // if sortByTime == true: sort by location
        if self.sortByTime {
            // sort posts by distance in ascending order
            self.posts = self.posts.sorted(by: {$0.distance < $1.distance})
            // change the button name to SortByTime
            sortButton.title = "SortByTime"
            // reload table view and flip the flag variable
            self.tableView.reloadData()
            self.sortByTime = false
        }
        // if sortByTime == false: sort by time
        else {
            // sort posts by timestamp; change button name and flip flag variable
            self.posts = self.posts.sorted(by: {$0.timestamp! > $1.timestamp!})
            sortButton.title = "SortByLocation"
            self.tableView.reloadData()
            self.sortByTime = true
        }
    }
    
    //Load posts from firebase
    func loadPosts() {
        let userID = Auth.auth().currentUser?.uid
        // executed once when initiating and then executed when a new child added to the user's feed
        FeedApi().REF_FEED.child(userID!).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            self.loadPostView(postID: postId)
            
        }
        // called when a child is removed from the user's feed
        FeedApi().observeFeedRemoved(withId: userID!) { (key) in
            self.posts = self.posts.filter { $0.PostCellId != key }
            self.tableView.reloadData()
        }
    }
    
    
    // fetch the post info by using a given id
    func loadPostView(postID: String){
        Database.database().reference().child("posts").child(postID).observeSingleEvent(of: .value, with:{
    snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let userID = dict["UserID"] as! String
                let captionText = dict["Caption"] as! String
                let postUrlString = dict["Path"] as! String
                let postLatitude = dict["Latitude"] as! Double
                let postLongitude = dict["Longitude"] as! Double
                let timestamp = dict["Timestamp"] as! Int
                let latitude: CLLocationDegrees = postLatitude
                let longitude: CLLocationDegrees = postLongitude
                
                self.postId = postID
                
                // load post location into CLLocation
                let postLocation = CLLocation(latitude: latitude, longitude: longitude)
                print ("Post Location:")
                // calculate the distance between user location and post location
                let distance = self.myLocation!.distance(from: postLocation)
                let post = PostCell(UserID: userID, captionText: captionText, postUrl: postUrlString, Latitude: postLatitude, Longitude: postLongitude, Timestamp: timestamp, PostDistance: distance, CellId: snapshot.key)
                self.post = post
                self.posts.insert(post, at: 0)
                self.tableView.reloadData()
                return
            }
        })
    }
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "CommentSegue" {
        let commentVC = segue.destination as! CommentViewController
        let postCommentId = sender  as! String
        commentVC.postId = postCommentId
    }
    
    }
    
    
    @IBAction func commentButton() {
        if let id = postId {
            self.performSegue(withIdentifier: "CommentSegue", sender: id)    }
    
}
}

// extension for table view
extension HomeViewController: UITableViewDataSource {
    // return the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // load data in posts array to table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        cell.captionLabel.text = post.caption
        let postURLString = post.path
        let postURL = URL(string: postURLString)
        cell.postImageView.sd_setImage(with: postURL, completed: nil)
        
        // workout the time difference between posts and current time
        let timestamp = post.timestamp
        let timestampDate = Date(timeIntervalSince1970: Double(timestamp!))
        let now = Date()
        let componments = Set<Calendar.Component>([.second,.minute,.hour,.day,.weekOfMonth])
        let diff = Calendar.current.dateComponents(componments, from: timestampDate, to: now)
        var timeText = ""
        if diff.second! <= 0 {
            timeText = "Now"
        }
        else if diff.second! > 0 && diff.minute! == 0 {
            timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
        }
        else if diff.minute! > 0 && diff.hour! == 0 {
            timeText = (diff.minute == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
        }
        else if diff.hour! > 0 && diff.day! == 0 {
            timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
        }
        else if diff.day! > 0 && diff.weekOfMonth! == 0 {
            timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
        }
        else if diff.weekOfMonth! > 0 {
            timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
        }
        
        cell.timestampLabel.text = timeText
        
        cell.postId = self.postId
        cell.post = self.post
        cell.post?.postId = self.postId!

        
//        cell.post?.likeCount = 0
        
        // load user name and profile image
        postUserId = post.userID
        UserApi().REF_USERS.child(postUserId!).observeSingleEvent(of: .value, with:{
            snapshot in
            if let dict = snapshot.value as? [String:Any]{
                let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                cell.userNameLabel.text = user.username
                if let photoUrlString = user.profileImageUrl{
                    let photoUrl = URL(string: photoUrlString)
                    cell.userPhotoImgView.sd_setImage(with: photoUrl)
                    //self.profileImg.sd_setImage(with: photoUrl)
                }
            }
        })

        
        return cell
    }
    
    
    
}




