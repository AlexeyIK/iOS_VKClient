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
    
    var photoCollection = [VKPhoto]()
    var photosCount: Int = 0
    var username: String?
    var userID: String?
    
    var vkAPI = VKApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (userID != nil) {
            vkAPI.getUsersPhotos(apiVersion: Session.shared.actualAPIVersion,
                                 token: Session.shared.token,
                                 userID: userID!)
            { (photos) in
                print("User photos:\n \(photos)")
                                    
                self.photoCollection = photos
//                self.photosCount = photos.count
            }
        }
        
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath) as? PhotoCell
        else {
            return UICollectionViewCell()
        }
        
        // Нам нужен Size типа "m" для красивого корректного превью
        let imageSizeType = "m"
        
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: self.photoCollection[indexPath.item].imageSizes.first(where: { $0.type == imageSizeType })?.url ?? "") else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.photo.image = UIImage(data: imageData)
            }
        }
        
//        cell.photo.image = UIImage(named: "photo\(Int.random(in: 1...6))")
        
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
