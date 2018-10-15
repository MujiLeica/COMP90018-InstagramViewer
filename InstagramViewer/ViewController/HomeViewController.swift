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
    var posts = [PostCell]()
    var RemovedPostUrl: String!
    var myLocation: CLLocation?
    var sortByTime = true
    

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadPosts()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            myLocation = location
            print (myLocation)
//            myLocation.distance(from: <#T##CLLocation#>)
            
            
//            //My location
//            let myLocation = CLLocation(latitude: 59.244696, longitude: 17.813868)
//
//            //My buddy's location
//            let myBuddysLocation = CLLocation(latitude: 59.326354, longitude: 18.072310)
            
            //Measuring my distance to my buddy's (in km)
//            let distance = myLocation.distance(from: myBuddysLocation)
//
//            print(distance)

            
        }
    }
    
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
    
    
    @IBAction func SortFunction(_ sender: Any) {
        if self.sortByTime {
            let newPosts = self.posts.sorted(by: {$0.distance < $1.distance})
            print (newPosts)
            sortButton.title = "SortByTime"
            self.sortByTime = false
        }
        else {
            let newPosts = posts
            sortButton.title = "SortByLocation"
            self.sortByTime = true
            print (newPosts)
        }
        
        
    }
    
    
    
    func loadPosts() {
        let userID = Auth.auth().currentUser?.uid
        
        // executed once when initiating and then executed when a new child added to the user's feed
        FeedApi().REF_FEED.child(userID!).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            print(snapshot)
            print(postId)
            // grap the new post id and use it to fetch post info
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
                let captionText = dict["Caption"] as! String
                let postUrlString = dict["Path"] as! String
                let postLatitude = dict["Latitude"] as! Double
                let postLongitude = dict["Longitude"] as! Double
                let timestamp = dict["Timestamp"] as! Int
                let latitude: CLLocationDegrees = postLatitude
                let longitude: CLLocationDegrees = postLongitude
                //let longitude: CLLocationDegrees = -122.406500
                
                
                print(latitude, longitude)
                
                print (postLatitude, postLongitude)
                //let postLocation = CLLocation(latitude: postLatitude, longitude: postLongitude)
                let postLocation = CLLocation(latitude: latitude, longitude: longitude)
                print ("Location:")
                print (postLocation)
                print (self.myLocation!)
                let distance = self.myLocation!.distance(from: postLocation)
                print (distance)
                let post = PostCell(captionText: captionText, postUrl: postUrlString, Latitude: postLatitude, Longitude: postLongitude, Timestamp: timestamp, PostDistance: distance, CellId: snapshot.key)
                
                self.posts.insert(post, at: 0)
                self.tableView.reloadData()
                print(snapshot)
                return
            }
            print(snapshot)
        })
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        cell.captionLabel.text = post.caption
        //cell.timestampLabel.text = post.timestamp
        //cell.timestampLabel.text = String(format: "%.2f", post.distance)
        let postURLString = post.path
        let postURL = URL(string: postURLString)
        cell.postImageView.sd_setImage(with: postURL, completed: nil)
        
        let timestamp = post.timestamp
        
        let timestampDate = Date(timeIntervalSince1970: Double(timestamp!))
        let now = Date()
        let componments = Set<Calendar.Component>([.second,.minute,.hour,.day,.weekOfMonth])
        let diff = Calendar.current.dateComponents(componments, from: timestampDate, to: now)
        var timeText = ""
        if diff.second! <= 0 {
            timeText = "Now"
        }
        if diff.second! > 0 && diff.minute! == 0 {
            timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
        }
        if diff.minute! > 0 && diff.hour! == 0 {
            timeText = (diff.minute == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
        }
        if diff.hour! > 0 && diff.day! == 0 {
            timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
        }
        if diff.day! > 0 && diff.weekOfMonth! == 0 {
            timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
        }
        if diff.weekOfMonth! > 0 {
            timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
        }
        
        cell.timestampLabel.text = timeText

        return cell
    }
    
}




