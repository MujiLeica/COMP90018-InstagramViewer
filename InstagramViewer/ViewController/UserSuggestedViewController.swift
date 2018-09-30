//
//  UserSuggestedViewController.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/9/28.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import UIKit

class UserSuggestedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var usersSeggested:[UserModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
    }
    
    func loadUser(){
        UserApi().observeUsers { (user) in
            self.isFollowing(userId: user.id!, completed: {
                (value) in
                user.isFollowing = value
                self.usersSeggested.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    func isFollowing(userId: String,completed: @escaping(Bool)->Void){
        FollowApi().isFollowing(userId: userId, completed: completed)
    }
}



extension UserSuggestedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersSeggested.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSuggestedCell", for: indexPath) as! UserSuggestedCell
        let user = usersSeggested[indexPath.row]
        // feed the user to the cell
        cell.user = user
        return cell
    }
}
