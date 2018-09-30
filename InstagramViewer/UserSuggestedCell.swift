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
        
    func updateView(){
        nameLabel.text = user?.email
        if let photoURLString = user?.profileImageUrl{
            let photoURL = URL(string:photoURLString)
            profileImg.sd_setImage(with: photoURL, placeholderImage:UIImage(named: "placeholderImg"))
        }
        
        // check whether the current user is following a specific user
        if user!.isFollowing == true{
            clickFollowBtn()
        }else{
            clickUnFollowBtn()
        }
    }
    
    func clickFollowBtn(){
        // set the style of the button
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor.gray.cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.layer.backgroundColor = UIColor.white.cgColor
        followBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        //followBtn.clipsToBounds = true
        self.followBtn.setTitle("Following", for: UIControlState.normal)
        // when click the follow button, enable follow action
        followBtn.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    func clickUnFollowBtn(){
        followBtn.layer.borderWidth = 1
        followBtn.layer.cornerRadius = 5
        followBtn.layer.backgroundColor = UIColor(red: 60/255, green: 90/255, blue: 255/255, alpha: 1).cgColor
        followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        //followBtn.clipsToBounds = true
        
        self.followBtn.setTitle("Follow", for: UIControlState.normal)
        // when click the un-follow button, enable un-follow action
        followBtn.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
    }
    
    @objc func followAction(){
        FollowApi().followAction(withUser: user!.id!)
        clickUnFollowBtn()
    }
    
    @objc func unFollowAction(){
        FollowApi().unFollowAction(withUser: user!.id!)
        clickFollowBtn()
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
