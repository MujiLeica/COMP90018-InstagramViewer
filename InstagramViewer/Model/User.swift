//
//  User.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/9/26.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import Foundation

class UserModel {
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var id: String?
    var isFollowing: Bool?
    var numberOfPosts:Int?
    
    var age:String?
    var address:String?
    
    // static var blockList: [UserModel] = []
}

extension UserModel {
    static func transformUser(dict: [String: Any],key: String) -> UserModel {
        let user = UserModel()
        user.email = dict["username"] as? String
        user.profileImageUrl = dict["profileImageURL"] as? String
        // user.username = dict["username"] as? String
        user.username = user.email?.dropLast(10).lowercased()
        user.id = key
        user.numberOfPosts = dict["numberOfPosts"] as? Int
        user.age = dict["age"] as? String
        user.address = dict["address"] as? String
        return user
    }
}
