//
//  FirstViewController.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 8/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SwiftyJSON

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var imagePath: String!
    var caption: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // download the post
        let uid = Auth.auth().currentUser?.uid
        // 1. create a ref to the post in database
        Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("users").child(uid!).observe(.childAdded) { (snapshot) in
            print(snapshot.value!)
            let json = JSON(snapshot.value!)
            let imagePath = json["Path"].stringValue
            let caption = json["Caption"].stringValue
            
            print(imagePath)
            print(caption)
            
            let pathRef = Storage.storage().reference(withPath: imagePath)
            pathRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    return
                }
                else{
                    print(url)
                }
            })
            print (pathRef)
            
        }
        // 2. parse each of the post
        
        // 3. update table view
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func viewDidAppear(_ animated: Bool) {
//            self.performSegue(withIdentifier: "loginView", sender: self)
//    }
    
    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // The number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Title for section's header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
        return "UserName"
    }
    
    // The number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
 
    // A Table View cell to present in a specified row of a section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "sampleCell") {
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    

}

