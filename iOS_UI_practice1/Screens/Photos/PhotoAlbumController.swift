//
//  PhotoController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 29.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PhotoAlbumController: UICollectionViewController {

    @IBAction func onClick(_ sender: Any) {
        guard let button = (sender as? LikeButton) else { return }
        button.Like()
    }
    
    var photoCollection = [VKPhoto]()
    var photosCount: Int = 0
    var username: String?
    var userID: Int = 0
    
    var vkAPI = VKApi()
    var database = RealmPhotoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.username
        updateNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.photoCollection = [VKPhoto]()
        restoreFromDB()
        requestPhotos()
    }
    
    private func restoreFromDB() {
        do {
            self.photoCollection = Array(try database.getProfilePhotosForUser(userID: Int(userID))).map { $0.toModel() }
        } catch {
            print(error)
        }
    }
    
    private func requestPhotos() {
        vkAPI.getUsersPhotos(apiVersion: Session.shared.actualAPIVersion,
                             token: Session.shared.token,
                             userID: userID)
        { (result) in
            switch result {
            case .success(let photos):
                self.photoCollection = photos
                self.database.addPhotos(userID: self.userID, albumID: -6, photos: photos) // не забыть избавиться здесь от хардкода, когда будет более одного альбома
                self.collectionView.reloadData()
            case.failure(let error):
                print("Error requesting photos of the user_id \(self.userID): \(error)")
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
        
        // Нам нужен Size типа "p" для красивого корректного превью
        let imageSizeType = "p"
        
        cell.likes.likeCount = photoCollection[indexPath.item].likes.count
        cell.likes.isLiked = photoCollection[indexPath.item].likes.myLike == 1 ? true : false
        
        if let imageUrl = URL(string: self.photoCollection[indexPath.item]
            .imageSizes.first(where: { $0.type == imageSizeType })?.url ?? "") {
            cell.loader.startAnimating()
            cell.photo?.kf.setImage(with: imageUrl,
                                    placeholder: nil,
                                    completionHandler: { (_) in
                                        cell.loader.stopAnimating()
                                    })
        }
        
        return cell
    }
}

class PhotoCell : UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var likes: LikeButton!
}