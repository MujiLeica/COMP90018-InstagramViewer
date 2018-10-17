//
//  FilterViewController.swift
//  InstagramViewer
//
//  Created by Yushan Wang on 26/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate{
    func updateImage(image: UIImage)
}

class FilterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterPhoto: UIImageView!
    var selectedImage: UIImage!
    var delegate: FilterViewControllerDelegate?
    var CIFilters = [
        "CIPhotoEffectMono",
        "CIFalseColor",
        "CIColorMap",
        "CIGaussianBlur"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       filterPhoto.image = selectedImage
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.updateImage(image: self.filterPhoto.image!)
        
    }
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        let ciImage = CIImage(image: selectedImage)
        let filter = CIFilter(name: CIFilters[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
        cell.filterPhoto.image = UIImage(ciImage: filteredImage)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CIFilters.count
}
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ciImage = CIImage(image: selectedImage)
        let filter = CIFilter(name: CIFilters[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            self.filterPhoto.image = UIImage(ciImage: filteredImage)
        }
    }
}
