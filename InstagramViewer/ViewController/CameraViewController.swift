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
import CoreLocation

class CameraViewController: UIViewController, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    var selectedImage: UIImage?
    var textViewPlaceHolderMessage = "What's on your mind?"
    var latitude: Double?
    var longitude: Double?
//    var timestamp: NSDate!
//    var timestampString: String!
    
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextView.text = textViewPlaceHolderMessage
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.photoClick))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        shareButton.isEnabled = false
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

//        self.timestamp = NSDate()
//        let dateFormatter = DateFormatter()
//        self.timestampString = dateFormatter.string(from: timestamp as Date)
//        print("Camera View TimeStamp: " + timestampString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Location Access Denied", message: "Need Location for Sorting Posts.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
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
        //var postURL: String?
        if let imageData = UIImageJPEGRepresentation(self.selectedImage!, 0.05) {
            let postID = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: "gs://comp90018instagramviewer.appspot.com").child("Posts").child(postID)
            storageRef.putData(imageData, metadata: nil, completion: { (uploadMetadata, error) in
                if error != nil {
                    return
                }
                print("Post Upload Success")
                
                //push post data in database
                let caption = self.captionTextView.text
                
                
                let currentUser = Auth.auth().currentUser?.uid
                // put the posts to a new database tree
                let DBref = Database.database().reference(fromURL: "https://comp90018instagramviewer.firebaseio.com/").child("posts")
                let newPostId = DBref.childByAutoId().key
                let newPostRef = DBref.child(newPostId)
                
                // then put the posts under "userPosts" child where includes this user's posts only
                let UserPostRef = Database.database().reference().child("userPosts")
                let UserNewPostRef = UserPostRef.child(currentUser!).child(newPostId)
                UserNewPostRef.setValue(true)
                
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        return
                    }
                    else {
                        let postURL = url!.absoluteString
                        
                       
                        let timestamp = Int(Date().timeIntervalSince1970)
                        print (timestamp)
                        
                        
                        newPostRef.setValue(["Path": postURL, "Caption": caption!, "Latitude": self.latitude!, "Longitude": self.longitude!, "Timestamp": timestamp])
                        
                        // update the "feed" database after successfully upload the image url to the storage
                        FeedApi().REF_FEED.child(currentUser!).child(newPostId).setValue(true)
                        
                        // update the "feed" database under the current user's followers' node
                        FollowApi().REF_FOLLOWERS.child(currentUser!).observeSingleEvent(of: .value, with: {
                            snapshot in
                            if let dict = snapshot.value as? [String: Any] {
                                for key in dict.keys {
                                    FeedApi().REF_FEED.child(key).child(newPostId).setValue(true)
                                }
                            }
                        })
                    }
                })
                
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
        self.shareButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filter_segue" {
            let filterVC = segue.destination as! FilterViewController
            filterVC.selectedImage = self.selectedImage
            filterVC.delegate = self
        }
        
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
        shareButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
        }    

    @IBAction func filterButton(_ sender: Any) {
        self.performSegue(withIdentifier: "filter_segue", sender: nil)
        }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
}

extension CameraViewController: FilterViewControllerDelegate{
    func updateImage(image: UIImage) {
        self.photo.image = image
    }
}
