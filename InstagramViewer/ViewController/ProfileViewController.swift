//
//  ProfileViewController.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 24/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

import CoreLocation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myLocation: CLLocation?
    var user: UserModel!
    var posts: [PostCell] = []
    var post:PostCell?
    
    var REF_USER_POSTS = Database.database().reference().child("userPosts")
    var REF_POSTS = Database.database().reference().child("posts")


    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchUser()
        fetchMyPosts()
    }
    
  
    func fetchUser() {
        UserApi().observeCurrentUser { (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
        }
    }
    
    func fetchMyPosts() {
        guard let currentUser = UserApi().CURRENT_USER else {
            return
        }
        
       REF_USER_POSTS.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
      
        PostApi().observePost(withId: snapshot.key, completion: { (post) in
            self.posts.append(post)
            self.collectionView.reloadData()
        })
        
        })
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    func observePost(withId id: String, completion: @escaping (PostCell) -> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = self.loadPostView(postID: snapshot.key)
                completion(post)
            }
        })
    }
    
    
    
    
    // load post to user profile page
    func loadPostView(postID: String) -> PostCell{
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
                
                // load post location into CLLocation
                let postLocation = CLLocation(latitude: latitude, longitude: longitude)
                print ("Post Location:")
                // calculate the distance between user location and post location
                let distance = self.myLocation!.distance(from: postLocation)
                let post = PostCell(UserID: userID, captionText: captionText, postUrl: postUrlString, Latitude: postLatitude, Longitude: postLongitude, Timestamp: timestamp, PostDistance: distance, CellId: snapshot.key)
            
                self.post = post
                
                return
            }
        })
        return self.post!
    }

}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    // reusable code
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
      headerViewCell.updateView()
        return headerViewCell
    }
    
    
    
}








