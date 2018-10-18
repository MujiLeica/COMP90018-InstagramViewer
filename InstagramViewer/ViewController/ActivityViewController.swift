//
//  ActivityViewController.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/10/18.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var notifications = [Notification]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotificatoins()
    }
    
    func loadNotificatoins(){
        guard let currentUser = UserApi().CURRENT_USER else{
            return
        }
        NotificationApi().observeNotification(withId: currentUser.uid) { (notification) in
            guard let uid = notification.from else{
                return
            }
            self.fetchUser(uid: uid, comleted: {
                self.notifications.insert(notification, at: 0)
                self.tableView.reloadData()
            })
            
            
        }
    }
    
    func fetchUser(uid:String, comleted: @escaping() -> Void){
        UserApi().observeUser(withId: uid) { (user) in
            self.users.insert(user, at: 0)
            comleted()
        }
    }
    
    
}

// extension for table view
extension ActivityViewController: UITableViewDataSource {
    // return the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    // load data in posts array to table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        let notification = notifications[indexPath.row]
        let user = users[indexPath.row]
        cell.notification = notification
        cell.user = user
        cell.delegate = self
        return cell
    }
}

// transfer to activity detail
extension ActivityViewController: ActivityTableViewCellDelegate {
    
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "Activity_DetailSegue", sender: postId)
    }
    
}
