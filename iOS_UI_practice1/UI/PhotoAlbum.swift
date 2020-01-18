//
//  PhotoController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 29.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoAlbumController: UICollectionViewController {

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
        updateNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.photoCollection = [VKPhoto]()
        
         if (userID != nil) {
            vkAPI.getUsersPhotos(apiVersion: Session.shared.actualAPIVersion,
                                 token: Session.shared.token,
                                 userID: userID!)
            { (photos) in
//                print("User photos:\n \(photos)")
                self.photoCollection = photos
                self.title = self.username
                self.collectionView.reloadData()
            }
        }
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
        let imageSizeType = "p"
        
        cell.likes.likeCount = photoCollection[indexPath.item].likes.count
//        cell.likes.isLiked = photoCollection[indexPath.item].likes.isLiked ?? false
        cell.likes.isLiked = photoCollection[indexPath.item].likes.myLike == 1 ? true : false
        
        cell.loader.startAnimating()
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: self.photoCollection[indexPath.item].imageSizes.first(where: { $0.type == imageSizeType })?.url ?? "") else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.photo.image = UIImage(data: imageData)
                cell.loader.stopAnimating()
            }
        }
        
        return cell
    }
}

class PhotoCell : UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var likes: LikeButtonController!
}
