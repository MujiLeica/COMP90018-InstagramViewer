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
        // if the current user starts to follow another user, fetch the another user's all post to the current user's feed
        Database.database().reference().child("userPosts").child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    Database.database().reference().child("feed").child(self.currentUser).child(key).setValue(true)
                }
            }
        })
        REF_FOLLOWERS.child(id).child(currentUser).setValue(true)
        REF_FOLLOWING.child(currentUser).child(id).setValue(true)
        
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        
        let newNotificationReference = NotificationApi().REF_NOTIFICATION.child(id).child("\(id)-\(currentUser)")
        newNotificationReference.setValue(["from": currentUser, "objectId": currentUser, "type": "follow", "timestamp": timestamp])
    }
    
    func unFollowAction(withUser id: String){
        Database.database().reference().child("userPosts").child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    Database.database().reference().child("feed").child(self.currentUser).child(key).removeValue()
                }
            }
        })
        
        REF_FOLLOWERS.child(id).child(currentUser).setValue(NSNull())
        REF_FOLLOWING.child(currentUser).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId:String, completed: @escaping(Bool) -> Void){
        REF_FOLLOWERS.child(userId).child(currentUser).observeSingleEvent(of: .value, with: {
            snapshot in
            if let _ = snapshot.value as? NSNull{
                completed(false)
            }else{
                completed(true)
            }
        })
        
    }
    
    
    // count how many people the current user is following
    func fetchCountFollowing(userId: String, completion: @escaping (Int) -> Void) {
        REF_FOLLOWING.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
        
    }
    
    // count the current user has how many followers
    func fetchCountFollowers(userId: String, completion: @escaping (Int) -> Void) {
        REF_FOLLOWERS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    
    
    
    
    
    
}
