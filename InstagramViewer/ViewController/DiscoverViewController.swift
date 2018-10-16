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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func doSearch(){
        print("jfidjfdjk")
    }

}

extension DiscoverViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
}

extension DiscoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSuggestedCell", for: indexPath) as! UserSuggestedCell
        //let user = usersSeggested[indexPath.row]
        // feed the user to the cell
        //cell.user = user
        return cell
    }
}
