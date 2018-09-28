//
//  UserSuggestedCell.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/9/28.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import UIKit

class UserSuggestedCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
        var user:UserModel?{
            didSet{
                updateView()
            }
        }
        
        func updateView(){
            nameLabel.text = user?.email
            if let photoURLString = user?.profileImageUrl{
                let photoURL = URL(string:photoURLString)
                profileImg.sd_setImage(with: photoURL, placeholderImage:UIImage(named: "placeholderImg"))
            }
            
        }
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
        
}
