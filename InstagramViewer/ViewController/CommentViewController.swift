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
    var users = [User]()
    let postID = NSUUID().uuidString
    @IBOutlet weak var sendButtonControl: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var bottonConstrain: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButtonControl.isEnabled = false
        handleTextField()
        loadComments()
        }
    
   
    
    func loadComments()
    {
        let postCommentRef = Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("post-comments").child(self.postID)
        postCommentRef.observe(.childAdded, with: {
            snapshot in
            print("Observe Key")
            print(snapshot.key)
            Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("Comments").child(snapshot.key).observeSingleEvent(of: .value, with: {
                snapshotComments in
                if let dict = snapshotComments.value as? [String: Any] {
                    let newComment = Comment.transformComment(dict: dict)
                    self.fetchUser(uid: newComment.uid!, completed: {
                        self.comments.append(newComment)
                        self.tableView.reloadData()
                    })
                }
            })
        })
    }
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        if let commentText = commentTextField.text, !commentText.isEmpty {
            sendButtonControl.setTitleColor(UIColor.blue, for: UIControlState.normal)
            sendButtonControl.isEnabled = true
            return
        }
        sendButtonControl.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sendButtonControl.isEnabled = false
    }
    
    
    
    @IBAction func sendButton(_ sender: Any) {
            let dbRef = Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/")
            let commentReference = dbRef.child("Comments")
            let commentID = commentReference.childByAutoId().key
            let newCommentReference = commentReference.child(commentID)
            let currentUser = Auth.auth().currentUser?.uid
            newCommentReference.setValue(["UserID":  currentUser!, "CommentText": commentTextField.text!])
            let postCommentRef = Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("post-comments").child(postID).child(commentID)
            postCommentRef.setValue(true)
    }


    

    

}
