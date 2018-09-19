//
//  RegisterPageViewController.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 8/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
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
    
    @IBAction func registerButton(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let repeatPassword = repeatPasswordTextField.text
        
        // check for empty field
        if (username!.isEmpty || password!.isEmpty || repeatPassword!.isEmpty){
            displayAlertMessage(alertMessage: "Fields can't be empty.")
        }
        // check if passwords matches
        else if (password != repeatPassword) {
            displayAlertMessage(alertMessage: "Password not match.")
        }
        // save username and password
        else {
            Auth.auth().createUser(withEmail: username!, password: password!) { (user, error) in
                if error == nil && user != nil {
                    let ref = Database.database().reference()
                    print(ref.description())
                    let usersReference = ref.child("users")
                    print(usersReference.description())
                    let userID = user?.user.uid
                    print(userID!)
                    let newUserReference = usersReference.child(userID!)
                    newUserReference.setValue(["username": username])
                    //self.displayAlertMessage(alertMessage: "User Created")
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.displayAlertMessage(alertMessage: "Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    
    // already have an account? go back to login page
    @IBAction func alreadyHaveAccount(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
