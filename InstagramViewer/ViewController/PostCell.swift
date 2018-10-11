//
//  PostCell.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 25/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import Foundation

class PostCell {
    var caption: String
    var path: String
    var latitude: Double
    var longitude: Double
    var distance: Double
    var timestamp: String
    var PostCellId: String
    
    init(captionText: String, postUrl: String, Latitude: Double, Longitude: Double, Timestamp: String, PostDistance: Double, CellId: String) {
        caption = captionText
        path = postUrl
        latitude = Latitude
        longitude = Longitude
        timestamp = Timestamp
        distance = PostDistance
        PostCellId = CellId
    }
}
