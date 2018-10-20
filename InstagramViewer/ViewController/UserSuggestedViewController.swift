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
    var currentUser:UserModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
    }
    
    func loadUser(){
        UserApi().observeUsers { (user) in
            self.isFollowing(userId: user.id!, completed: {
                (value) in
                if(user.id==UserApi().CURRENT_USER?.uid){
                    user.isFollowing = true
                }else{
                    UserApi().observeUser(withId: (UserApi().CURRENT_USER?.uid)!, completion: { (currentUser) in
                        self.currentUser = currentUser
                        
                        guard user.address != nil else{
                            
                            return
                        }
                        
                        print(user.username)
                        print(user.age)
                        print(user.address)
                        print(self.currentUser?.username)
                        print(self.currentUser?.address)
                        print(self.currentUser?.age)
                        
                        if (user.address == self.currentUser?.address){
                            user.isFollowing = value
                            self.usersSeggested.append(user)
                            self.tableView.reloadData()
                            
                        }else if (user.age == self.currentUser?.age){
                            user.isFollowing = value
                            self.usersSeggested.append(user)
                            self.tableView.reloadData()
                            
                        }
                        
                    })
                    
                    
                    }
            })
        }
    }
    
    // check whether the target user is following the current user
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
