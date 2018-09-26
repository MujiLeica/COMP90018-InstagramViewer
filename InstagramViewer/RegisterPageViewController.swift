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
import FirebaseStorage
class RegisterPageViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
        var selectedImage: UIImage?
    @IBOutlet weak var profileImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the profile clickable
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        profileImg.addGestureRecognizer(tapGesture)
        profileImg.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfileImageView(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(pickerController, animated: true, completion: nil)
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
                if error == nil && user != nil {let userID = user?.user.uid
                    
                    
                    
                    
                    
                    
                    
                    
                    // generate the node of profile image in storage. forURL is another way to get root location;
                    let storageRef = Storage.storage().reference(forURL: "gs://comp90018instagramviewer.appspot.com").child("profile_image").child(userID!) //在这一步，我们把头像的照片存储在storage中
                    if let profileImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1){
                        storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                            if error != nil{
                                return
                            }
                            
                            _ = storageRef.downloadURL(completion: { (url, error) in
                                let profileImageURL = url?.absoluteString
                                
                                // generate the father node of database
                                let ref = Database.database().reference()
                                let usersReference = ref.child("users")
                                let newUserReference = usersReference.child(userID!)
                                newUserReference.setValue(["username": username,"profileImageURL":profileImageURL])
                                //self.displayAlertMessage(alertMessage: "User Created")
                                self.dismiss(animated: true, completion: nil)
                                
                            })
                        })
                    }
                

                
            
            
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

// 使可以从相册中选择一个照片上传做头像
extension RegisterPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profileImg.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}


