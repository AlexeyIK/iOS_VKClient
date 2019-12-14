//
//  PhotoController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 29.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoController: UICollectionViewController {

    @IBAction func onClick(_ sender: Any) {
        guard let button = (sender as? LikeButtonController) else { return }
        button.Like()
    }
    
    var photoCollection = [1,2,3,4,5,6,7,8]
    var user: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationItem()
    }
    
    func updateNavigationItem() {
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollection.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.alpha = 0.0
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.5, delay: Double(indexPath.row + 1) * 0.25, options: [], animations: {
            cell.alpha = 1.0
            cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
        return cell
    }
}

class PhotoCell : UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
}
