//
//  NotificationApi.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/10/18.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NotificationApi{
    var REF_NOTIFICATION = Database.database().reference().child("notification")
    
    // while a new child is added to feed, return the new child's key
    func observeNotification(withId id: String, completion: @escaping (Notification) -> Void) {
        REF_NOTIFICATION.child(id).observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let newNoti = Notification.transform(dict: dict, key: snapshot.key)
                completion(newNoti)
            }
        }
        
    }
}
