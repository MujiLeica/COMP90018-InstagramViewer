//
//  PostApi.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/10/19.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class PostApi {
    var REF_POSTS = Database.database().reference().child("posts")
    
    func observePost(withId id: String, completion: @escaping (PostCell) -> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = PostCell.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(post)
            }
        })
    }
   
}
