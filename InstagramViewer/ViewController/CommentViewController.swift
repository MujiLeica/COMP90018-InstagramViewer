//
//  CommentViewController.swift
//  InstagramViewer
//
//  Created by Huiqun Chen on 18/10/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class CommentViewController: UIViewController {

    var comments = [Comment]()
    var users = [UserModel]()
    let postID = NSUUID().uuidString
    
    @IBOutlet weak var sendButtonControl: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottonConstrain: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        loadComments()
        }
    
   
    
    func loadComments()
    {
        let postCommentRef = Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("post-comments").child(self.postID)
        postCommentRef.observe(.childAdded, with: {
            snapshot in
            print("key obervating")
            print(snapshot.key)
            Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("Comments").child(snapshot.key).observeSingleEvent(of: .value, with: {
                snapshotComments in
                if let dict = snapshotComments.value as? [String: Any] {
                    let newComment = Comment.transformComment(dict: dict)
                    self.getUser(uid: newComment.uid!, completed: {
                        self.comments.append(newComment)
                        self.tableView.reloadData()
                    })
                }
            })
        })
    }
    
    func getUser(uid: String, completed:  @escaping () -> Void ) {
        Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict, key: uid)
                self.users.append(user)
                completed()
            }
        })
    }
    
    
    
    
    
    @IBAction func sendButton(_ sender: Any) {
            let dbRef = Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/")
            let commentReference = dbRef.child("Comments")
            let commentID = commentReference.childByAutoId().key
            let newCommentReference = commentReference.child(commentID)
            let currentUser = Auth.auth().currentUser?.uid
            newCommentReference.setValue(["UserID":  currentUser!, "CommentText": commentTextField.text!])
            let postCommentRef = Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("post-comments").child(self.postID).child(commentID)
            postCommentRef.setValue(true)
    }
}

extension CommentViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return comments.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
            let comment = comments[indexPath.row]
            let user = users[indexPath.row]
            cell.comment = comment
            cell.user = user
            return cell
        }

    
}

