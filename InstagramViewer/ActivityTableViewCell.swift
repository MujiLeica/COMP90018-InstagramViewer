//
//  ActivityTableViewCell.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/10/18.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import CoreLocation

protocol ActivityTableViewCellDelegate {
    func goToDetailVC(postId: String)
}

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    
    var delegate: ActivityTableViewCellDelegate?
    
    var myLocation: CLLocation?
    
    var notification:Notification?{
        didSet{
            updateView()
        }
    }
    
    var user:UserModel?{
        didSet{
            setupUserInfo()
        }
    }
    
    func updateView(){
        switch notification!.type! {
        case "feed":
            descriptionLabel.text = "added a new post"
            let objectId = notification!.objectId!
            
            Database.database().reference().child("posts").child(objectId).observeSingleEvent(of: .value, with:{
                snapshot in
                if let dict = snapshot.value as? [String: Any] {
                    let postUrlString = dict["Path"] as? String
                    
                    let photoUrl = URL(string: postUrlString!)
                    self.photo.sd_setImage(with: photoUrl)
                }
            })
            
        case "follow":
            descriptionLabel.text = "started following you"
            
            let objectId = notification!.objectId!
            Database.database().reference().child("posts").child(objectId).observeSingleEvent(of: .value, with:{
                snapshot in
                if let dict = snapshot.value as? [String: Any] {
                    let postUrlString = dict["Path"] as? String
                    
                    let photoUrl = URL(string: postUrlString!)
                    self.photo.sd_setImage(with: photoUrl)
                }
            })

        default:
            print("t")
        }
        
        if let timestamp = notification?.timestamp {
            print(timestamp)
            let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
            
            var timeText = ""
            if diff.second! <= 0 {
                timeText = "Now"
            }
            if diff.second! > 0 && diff.minute! == 0 {
                timeText = "\(diff.second!)s"
            }
            if diff.minute! > 0 && diff.hour! == 0 {
                timeText = "\(diff.minute!)m"
            }
            if diff.hour! > 0 && diff.day! == 0 {
                timeText = "\(diff.hour!)h"
            }
            if diff.day! > 0 && diff.weekOfMonth! == 0 {
                timeText = "\(diff.day!)d"
            }
            if diff.weekOfMonth! > 0 {
                timeText = "\(diff.weekOfMonth!)w"
            }
            
            timeLabel.text = timeText
        }
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.cell_TouchUpInside))
        addGestureRecognizer(tapGestureForPhoto)
        isUserInteractionEnabled = true
    }
    
    
    @objc func cell_TouchUpInside() {
        if let id = notification?.objectId {
            if notification!.type! == "follow" {
            }else {
                delegate?.goToDetailVC(postId: id)
            }
            
        }
    }
    
    func setupUserInfo(){
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl{
            let photoUrl = URL(string: photoUrlString)
            profileImage.sd_setImage(with: photoUrl)
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
