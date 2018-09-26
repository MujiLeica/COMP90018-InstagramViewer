//
//  FilterViewController.swift
//  InstagramViewer
//
//  Created by Huiqun Chen on 26/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterPhoto: UIImageView!
    var selectedImage: UIImage!
    var CIFilters = ["CIPhotoEffectMono","CIFalseColor","CIColorMap","CIGaussianBlur"]
    override func viewDidLoad() {
        super.viewDidLoad()
       filterPhoto.image = selectedImage
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButton(_ sender: Any) {
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
}
