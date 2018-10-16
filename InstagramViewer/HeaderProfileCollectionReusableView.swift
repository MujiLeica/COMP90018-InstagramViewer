//
//  HeaderProfileCollectionReusableView.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/9/25.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostsCountLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    // display the "header" info corespond to the current user
    func updateView(){
        
        
        UserApi().REF_CURRENT_USER?.observeSingleEvent(of: .value, with:{
            snapshot in
            if let dict = snapshot.value as? [String:Any]{
                let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                self.nameLabel.text = user.username
                if let photoUrlString = user.profileImageUrl{
                    let photoUrl = URL(string: photoUrlString)
                    self.profileImg.sd_setImage(with: photoUrl)
                }
            }
            })
        
        
        
    }



}
