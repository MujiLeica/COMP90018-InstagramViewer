//
//  CommentTableViewCell.swift
//  InstagramViewer
//
//  Created by Huiqun Chen on 18/10/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var profifeImageView: UIImageView!
    var comment: Comment? {
        didSet {
            updateView()
        }
    }
    
    var user: UserModel? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateView() {
        commentLabel.text = comment?.commentText
    }
    
    func setupUserInfo() {
        nameLable.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profifeImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLable.text = ""
        commentLabel.text = ""
    }
    
    }
    

