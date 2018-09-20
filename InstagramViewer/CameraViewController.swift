//
//  CameraViewController.swift
//  InstagramViewer
//
//  Created by CHONG LIU on 20/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CropViewController

class CameraViewController: UIViewController, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    var selectedImage: UIImage?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.photoClick))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
    }

    @objc func photoClick() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else
            {
                print("Camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Liabrary", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            presentCropViewController(input: image)
        }
    }

    @IBAction func shareButtonClicked(_ sender: Any) {
        if let uploadPhoto = self.selectedImage, let imageData = UIImageJPEGRepresentation(uploadPhoto, 0.1) {
            let photoIDString = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: "gs://comp90018instagramviewer.appspot.com").child("Posts").child(photoIDString)
            storageRef.putData(imageData, metadata: nil, completion: { (uploadMetadata, error) in
                if error != nil {
                    return
                }
                print("success")
                let path = uploadMetadata!.path
                print(path!)
                
                let caption = self.captionTextView.text
                let currentUser = Auth.auth().currentUser?.uid
                
                let DBref = Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("users").child(currentUser!)
                DBref.setValue(["User": currentUser, "Path": path, "Caption": caption])
         
                self.clean()
                self.tabBarController?.selectedIndex = 0
                
            })
        }
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.clean()
        self.tabBarController?.selectedIndex = 0
    }
    
    func clean() {
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "Placeholder-image")
        self.selectedImage = nil
    }
    
    
    //TOCropViewController
    func presentCropViewController(input: UIImage) {
        let image: UIImage = input //Load an image
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        let top = topMostController()
        top.present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        selectedImage = image
        photo.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
}

