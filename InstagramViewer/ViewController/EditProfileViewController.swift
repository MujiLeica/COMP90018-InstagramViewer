//
//  EditProfileViewController.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 17/10/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditProfileViewController: UIViewController {

    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveBtn_Touch(_ sender: Any) {
        UserApi().REF_USERS.child((UserApi().CURRENT_USER?.uid)!).child("age").setValue(ageLabel.text)
        UserApi().REF_USERS.child((UserApi().CURRENT_USER?.uid)!).child("address").setValue(addressLabel.text)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
