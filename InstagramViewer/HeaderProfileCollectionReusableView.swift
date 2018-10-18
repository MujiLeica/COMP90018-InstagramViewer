//
//  HeaderProfileCollectionReusableView.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/9/25.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostsCountLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    var REF_USER_POSTS = Database.database().reference().child("userPosts")
    let currentUserId = UserApi().CURRENT_USER?.uid
    var noOfPosts:Int = 0
    
    // display the "header" info corespond to the current user
    func updateView(){
        UserApi().REF_CURRENT_USER?.observeSingleEvent(of: .value, with:{
            snapshot in
            if let dict = snapshot.value as? [String:Any]{
                let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                self.nameLabel.text = user.username
                if let photoUrlString = user.profileImageUrl{
                    let photoUrl = URL(string: photoUrlString)
                    self.profileImg.sd_setImage(with: photoUrl)
                }
            }
            })
        
        // make the myPostsCountLabel label displays the number of posts of the current user
        UserApi().fetchCountMyPosts(userId: currentUserId!) { (count) in
            self.myPostsCountLabel.text = "\(count)"
        }
        
        // make the followingCountLabel label displays the number of people the user follows
        FollowApi().fetchCountFollowing(userId: currentUserId!) { (count) in
            self.followingCountLabel.text = "\(count)"
        }
        
        // make the followersCountLabel label displays the number of people follows the user
        FollowApi().fetchCountFollowers(userId: currentUserId!) { (count) in
            self.followersCountLabel.text = "\(count)"
        }
        
        
    }
    

}
