//
//  UserApi.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/9/26.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//


import Foundation
import FirebaseDatabase
import FirebaseAuth
class UserApi {
    var numberOfPosts = 0
    var REF_USERS = Database.database().reference().child("users")
    var REF_USER_POSTS = Database.database().reference().child("userPosts")
    
    // observe User by Username, the leaf node is "username_lowercase"
    func observeUserByUsername(username: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryEqual(toValue: username).observeSingleEvent(of: .childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict,key: snapshot.key)
                completion(user)
            }
        })
    }
    
    // observe User by user id
    func observeUser(withId userId: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.child(userId).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict,key: snapshot.key)
                completion(user)
            }
        })
    }
    
    // observe current user by user id
    func observeCurrentUser(completion: @escaping (UserModel) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict,key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeUsers(completion: @escaping (UserModel) -> Void) {
        REF_USERS.observe(.childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict,key: snapshot.key)
                completion(user)
            }
        })
    }
    
    // search for users based on the keywords typed in the search bar
    func queryUsers(withText text: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.queryOrdered(byChild: "username").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: {
            snapshot in
            snapshot.children.forEach({ (s) in
                let child = s as! DataSnapshot
                if let dict = child.value as? [String: Any] {
                    let user = UserModel.transformUser(dict: dict,key: snapshot.key)
                    if user.id != UserApi().CURRENT_USER?.uid {
                        completion(user)
                    }
                }
            })
        })
    }
    
    
    func funct(o: String) -> Int{
        var numbr:Int?
        numbr = 9
        return numbr!
    }
    
     // fetch users post
    func fetchMyPosts(userId: String, completion: @escaping (String) -> Void) {
        REF_USER_POSTS.child(userId).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
    }
    
    // fetch the number of posts
    func fetchCountMyPosts(userId: String, completion: @escaping (Int) -> Void) {
        REF_USER_POSTS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    
    
    var CURRENT_USER: User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        
        return nil
    }
    
    var REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        return REF_USERS.child(currentUser.uid)
    }
}
