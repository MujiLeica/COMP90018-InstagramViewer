//
//  FirstViewController.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 8/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func viewDidAppear(_ animated: Bool) {
//            self.performSegue(withIdentifier: "loginView", sender: self)
//    }
    
    
    // The number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Title for section's header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
        return "UserName"
    }
    
    // The number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 3
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

