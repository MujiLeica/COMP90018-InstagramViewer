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
    // var username: String?
    var id: String?
    // var isFollowing: Bool?
    
    // static var blockList: [UserModel] = []
}

extension UserModel {
    static func transformUser(dict: [String: Any]) -> UserModel {
        let user = UserModel()
        user.email = dict["username"] as? String
        user.profileImageUrl = dict["profileImageURL"] as? String
        // user.username = dict["username"] as? String
        // user.id = key
        return user
    }
}
