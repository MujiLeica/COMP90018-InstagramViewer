//
//  FilterViewController.swift
//  InstagramViewer
//
//  Created by Huiqun Chen on 25/9/18.
//  Copyright © 2018 CHONG LIU. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButton(_ sender: Any) {
    }
    
    @IBAction func cancelButton(_ sender: Any) {
    }

}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}
