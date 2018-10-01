//
//  UserSuggestedCell.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/9/28.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserSuggestedCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user:UserModel?{
        didSet{
            updateView()
        }
    }
    func updateView() {
        nameLabel.text = user?.email
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImg.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        FollowApi().isFollowing(userId: user!.id!) { (value) in
            if value  {
                self.configureUnFollowButton()
            } else {
                self.configureFollowButton()
            }
        }
    }
    
    func configureFollowButton() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true
        
        followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        followBtn.setTitle("Follow", for: UIControlState.normal)
        followBtn.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func configureUnFollowButton() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true
        
        followBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor.clear
        followBtn.setTitle("Following", for: UIControlState.normal)
        followBtn.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
    }
    
    @objc func followAction() {
        FollowApi().followAction(withUser: user!.id!)
        configureUnFollowButton()
    }
    
    @objc func unFollowAction() {
        FollowApi().unFollowAction(withUser: user!.id!)
        configureFollowButton()
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
