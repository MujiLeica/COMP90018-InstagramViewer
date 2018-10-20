//
//  PhotoCollectionViewCell.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/10/19.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    var post: PostCell?{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        if let photoUrlString = post?.path{
            let photoUrl = URL(string: photoUrlString)
            photo.sd_setImage(with: photoUrl)
        }
    }
}
