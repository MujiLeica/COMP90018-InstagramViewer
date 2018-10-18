//
//  DiscoverViewController.swift
//  InstagramViewer
//
//  Created by 祝赫 on 2018/9/25.
//  Copyright © 2018年 CHONG LIU. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController,UINavigationControllerDelegate  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var allUsers:[UserModel] = []
    var users:[UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadAllUsers()

        // Do any additional setup after loading the view.
    }
    
    func loadAllUsers(){
        let elementCount = UserApi().REF_USERS.accessibilityElementCount()
        print("there are ")
        print(elementCount)
        print(" users in the database")

    }

    func doSearch(){
        print("jfidjfdjk")
        
        if let searchText = searchBar.text?.lowercased(){
            self.users.removeAll()
            self.tableView.reloadData()
            
            UserApi().queryUsers(withText: searchText) { (user) in
                self.isFollowing(userId: user.id!, completed: { (value) in
                    user.isFollowing = value
                    
                    if(self.users.contains(where: { (userIncluded) -> Bool in
                        userIncluded.username == user.username
                    })){
                        
                    }else if(user.id != UserApi().CURRENT_USER?.uid){
                        self.users.append(user)
                        self.tableView.reloadData()
                    }
                    
                })
            }
        }
    }
    
    func isFollowing(userId:String,completed:@escaping (Bool) -> Void){
        FollowApi().isFollowing(userId: userId, completed: completed)
    }

}

extension DiscoverViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // no search button
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         print("jfidjfdjk2222")
        self.users.removeAll()
        self.tableView.reloadData()
        if(searchBar.text == ""){
           
        }else{
            doSearch()
        }
        
    }
}

extension DiscoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSuggestedCell", for: indexPath) as! UserSuggestedCell
        let user = users[indexPath.row]
        // feed the user to the cell
        cell.user = user
        return cell
    }
}
