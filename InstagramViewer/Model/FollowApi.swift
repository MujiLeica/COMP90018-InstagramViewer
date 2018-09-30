//
//  FollowApi.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/9/30.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FollowApi{
    // create two chile under the database: followers and following
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    var currentUser = Auth.auth().currentUser!.uid

    func followAction(withUser id: String){
        FollowApi().REF_FOLLOWERS.child(id).child(currentUser).setValue(true)
        FollowApi().REF_FOLLOWING.child(currentUser).child(id).setValue(true)
    }
    
    func unFollowAction(withUser id: String){
        FollowApi().REF_FOLLOWERS.child(id).child(currentUser).setValue(NSNull())
        FollowApi().REF_FOLLOWING.child(currentUser).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId:String, completed: @escaping(Bool) -> Void){
        //REF_FOLLOWERS.child(userId).child(UserApi().REF_CURRENT_USER)
        REF_FOLLOWERS.child(userId).child(currentUser).observeSingleEvent(of: .value, with: {
            snapshot in
            if let _ = snapshot.value as? NSNull{
                completed(false)
            }else{
                completed(true)
            }
        })
        
    }
}
