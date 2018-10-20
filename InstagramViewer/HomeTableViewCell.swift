//
//  HomeTableViewCell.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 25/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userPhotoImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    var REF_POSTS = Database.database().reference().child("posts")
    var REF_USER = Database.database().reference().child("user")
    
    var post: PostCell?
    var postId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
        likeImg.addGestureRecognizer(tapGestureForLikeImageView)
        likeImg.isUserInteractionEnabled = true
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // update the like info in feed
    func updateLike(post: PostCell) {
        
        // change the image view of the like image
        if let currentUser = Auth.auth().currentUser{
            REF_USER.child(currentUser.uid).child("likes").child(postId!).observeSingleEvent(of: .value) { (snapshot) in
                if let _ = snapshot.value as? NSNull{
                    self.likeImg.image = UIImage(named: "like")
                    self.likeCountLabel.text = "Be the first one likes this post"

                }else{
                    self.likeImg.image = UIImage(named: "likeSelected")
                    self.likeCountLabel.text = (UserApi().CURRENT_USER?.email?.dropLast(10))! + " like this post"

                }
            }
        }
        
    }
    
    @objc func likeImageView_TouchUpInside() {
        // if the user clicks the like button, change the value in database
        if let currentUser = Auth.auth().currentUser{
            print(post?.postId)
            guard post?.postId != nil else{
                return
            }
            REF_USER.child(currentUser.uid).child("likes").child(postId!).setValue(true)
            self.updateLike(post: post!)
        }
        
    }
    
 
    
//    func incrementLikes(postId: String, onSucess: @escaping (PostCell) -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
//        let postRef = REF_POSTS.child(postId)
//        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
//            if var post = currentData.value as? [String : AnyObject], let uid = UserApi().CURRENT_USER?.uid {
//                var likes: Dictionary<String, Bool>
//                likes = post["likes"] as? [String : Bool] ?? [:]
//                var likeCount = post["likeCount"] as? Int ?? 0
//                if let _ = likes[uid] {
//                    likeCount -= 1
//                    likes.removeValue(forKey: uid)
//                } else {
//                    likeCount += 1
//                    likes[uid] = true
//                }
//                post["likeCount"] = likeCount as AnyObject?
//                post["likes"] = likes as AnyObject?
//                
//                currentData.value = post
//                
//                return TransactionResult.success(withValue: currentData)
//            }
//            return TransactionResult.success(withValue: currentData)
//        }) { (error, committed, snapshot) in
//            if let error = error {
//                onError(error.localizedDescription)
//            }
//            if let dict = snapshot?.value as? [String: Any] {
//                let post = PostCell.transformPostPhoto(dict: dict, key: snapshot!.key)
//                onSucess(post)
//            }
//        }
//    }
    
    
  
    

}
