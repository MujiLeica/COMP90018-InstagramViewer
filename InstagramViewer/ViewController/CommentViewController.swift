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

    var postId: String!
    var comments = [Comment]()
    var users = [UserModel]()
   // let postID = NSUUID().uuidString
    
    @IBOutlet weak var sendButtonControl: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comment"
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        empty()
        handleTextField()
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {
        print(notification)
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.4) {
            self.bottomConstrain.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
            
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.4) {
            self.bottomConstrain.constant = 0
            self.view.layoutIfNeeded()
            
        }
    }
    func loadComments()
    {
        let postCommentRef = Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("post-comments").child(self.postId)
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
            let postCommentRef = Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("post-comments").child(self.postId).child(commentID)
            postCommentRef.setValue(true)
            self.empty()
            self.view.endEditing(true)
        
    }
    func empty() {
        self.commentTextField.text = ""
        self.sendButtonControl.isEnabled = false
        sendButtonControl.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
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

