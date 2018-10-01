//
//  FeedApi.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/10/1.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import Foundation
import FirebaseDatabase
class FeedApi {
    var REF_FEED = Database.database().reference().child("feed")
    
    // while a new child is added to feed, return the new child's key
    func observeFeed(withId id: String, completion: @escaping (String) -> Void) {
        REF_FEED.child(id).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            completion(postId)
        }

    }
    
    // while a new child is removed from feed, return the child's key
    func observeFeedRemoved(withId id: String, completion: @escaping (String) -> Void) {
        REF_FEED.child(id).observe(.childRemoved, with: {
            snapshot in
            let key = snapshot.key
            completion(key)
        })
    }
}
