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
    
    init(captionText: String, postUrl: String) {
        caption = captionText
        path = postUrl
        
    }
}
