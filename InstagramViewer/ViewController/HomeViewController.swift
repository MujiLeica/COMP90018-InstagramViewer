//
//  HomeViewController.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 25/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController { 
    @IBOutlet weak var tableView: UITableView!
    var posts = [PostCell]()
    let options = ["Sort by Time","Sort by Location"]
    var sort: String?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadPosts()
    }
    
    
    @IBAction func sortButton(_ sender: Any) {
        sortOptionPicker()
    }
    
    func sortOptionPicker() {
        let sortOption = UIPickerView()
        sortOption.delegate = self
        sortOption.isHidden = false
        //self.view.addSubview(sortOption)
    }
    
    
    func loadPosts() {
        // let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
            //print(snapshot.value!)
            
            if let dict = snapshot.value as? [String: Any] {
                print(snapshot)
                let captionText = dict["Caption"] as! String
                let postUrlString = dict["Path"] as! String
                let post = PostCell(captionText: captionText, postUrl: postUrlString)
                self.posts.append(post)
                self.tableView.reloadData()
            }
        }
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        cell.captionLabel.text = post.caption
        let postURLString = post.path
        let postURL = URL(string: postURLString)
        cell.postImageView.sd_setImage(with: postURL, completed: nil)

        return cell
    }
    
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sort = options[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}
