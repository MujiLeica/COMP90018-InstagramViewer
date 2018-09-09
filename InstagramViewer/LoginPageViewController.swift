//
//  LoginPageViewController.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 8/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // alert message function
    func displayAlertMessage (alertMessage: String) {
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if (username!.isEmpty || password!.isEmpty) {
            displayAlertMessage(alertMessage: "Username or Password can't be empty.")
        }
        else if (username == "admin" && password == "admin") {
            //self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "homePage", sender: self)
        }
        else {
            displayAlertMessage(alertMessage: "Incorrect Username and Password. Try Again.")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
