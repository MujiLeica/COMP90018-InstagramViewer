//
//  PostCell.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 25/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import Foundation
import FirebaseAuth

import CoreLocation

class PostCell {
    var postId: String
    var userID: String
    var caption: String
    var path: String
    var latitude: Double
    var longitude: Double
    var distance: Double
    var timestamp: Int?
    var PostCellId: String
    var myLocation: CLLocation?
//    var likeCount: Int?
//    var likes: Dictionary<String, Any>?
    
    var isLiked: Bool? = false
    
    init(UserID: String, captionText: String, postUrl: String, Latitude: Double, Longitude: Double, Timestamp: Int, PostDistance: Double, CellId: String) {
        userID = UserID
        caption = captionText
        path = postUrl
        latitude = Latitude
        longitude = Longitude
        timestamp = Timestamp
        distance = PostDistance
        PostCellId = CellId
        postId = ""
    }
}

extension PostCell{
    static func transformPostPhoto(dict: [String: Any], key: String) -> PostCell {
        let id = key
        
        let userID = dict["UserID"] as! String
        let captionText = dict["Caption"] as! String
        let postUrlString = dict["Path"] as! String
        let postLatitude = dict["Latitude"] as! Double
        let postLongitude = dict["Longitude"] as! Double
        let timestamp = dict["Timestamp"] as! Int
//
//        let likeCount = dict["likeCount"] as? Int
//        let likes = dict["likes"] as? Dictionary<String, Any>
        let latitude: CLLocationDegrees = postLatitude
        let longitude: CLLocationDegrees = postLongitude
        
        let post = PostCell(UserID: userID, captionText: captionText, postUrl: postUrlString, Latitude: postLatitude, Longitude: postLongitude, Timestamp: timestamp, PostDistance: 1.0, CellId: "1")
//        
//        if let currentUserId = Auth.auth().currentUser?.uid {
//            if post.likes != nil {
//                post.isLiked = post.likes![currentUserId] != nil
//            }
//        }
        return post
    }
}
