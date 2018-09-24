//
//  CustomCell.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 24/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    var postImage: UIImage?
    var caption: String?
    
    var captionTextView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var postImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(postImageView)
        self.addSubview(captionTextView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
