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

class HomeViewController: UIViewController { 
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [PostCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()

        
//        var post = PostCell(captionText: "wahaha", postUrl: "abcdefg")
//        print(post.caption)
//        print(post.path)
    }
    
    func loadPosts() {
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).observe(.childAdded) { (snapshot) in
            //print(snapshot.value!)
            
            if let dict = snapshot.value as? [String: Any] {
                print(snapshot)
                let captionText = dict["Caption"] as! String
                let postUrlString = dict["Path"] as! String
                let post = PostCell(captionText: captionText, postUrl: postUrlString)
                self.posts.append(post)
                self.tableView.reloadData()
            }
        }
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.backgroundColor = UIColor.red
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
}
