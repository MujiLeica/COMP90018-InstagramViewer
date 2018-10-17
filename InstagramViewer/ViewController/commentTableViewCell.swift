//
//  commentTableViewCell.swift
//  InstagramViewer
//
//  Created by Huiqun Chen on 17/10/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit

class commentTableViewCell: UITableViewCell {

    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
