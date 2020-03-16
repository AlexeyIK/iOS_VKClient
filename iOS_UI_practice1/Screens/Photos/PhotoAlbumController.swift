//
//  PhotoController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 29.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoAlbumController: UICollectionViewController {

    @IBAction func onClick(_ sender: Any) {
        guard let button = (sender as? LikeButton) else { return }
        button.Like()
    }
    
    var username: String?
    var userID: Int = 0
    
    var photosResult: Results<PhotoRealm>?
    var notificationToken: NotificationToken?
    
    var vkAPI = VKApi()
    var database = RealmPhotoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.username
        updateNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        restoreFromDB()
        requestPhotos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }
    
    private func restoreFromDB() {
        do {
            self.photosResult = try database.getProfilePhotosForUser(userID: Int(userID))
            
            notificationToken = photosResult?.observe { [weak self] results in
                switch results {
                case .error(let error):
                    print("Photo album observer error: \(error)")
                case .initial(_):
                    self?.collectionView.reloadData()
                case let .update(_, deletions, insertions, modifications):
                    self?.collectionView.performBatchUpdates({
                        self?.collectionView.deleteItems(at: deletions.map { IndexPath(item: $0, section: 0) })
                        self?.collectionView.insertItems(at: insertions.map { IndexPath(item: $0, section: 0) })
                        self?.collectionView.reloadItems(at: modifications.map { IndexPath(item: $0, section: 0) })
                    })
                }
            }
        } catch {
            print("Error getting user's photos from DB: \(error)")
        }
    }
    
    private func requestPhotos() {
        vkAPI.getUsersPhotos(apiVersion: Session.shared.actualAPIVersion,
                             token: Session.shared.token,
                             userID: userID)
            .done { photos in
                self.database.addPhotos(userID: self.userID, albumID: -6, photos: photos) // не забыть избавиться здесь от хардкода, когда будет более одного альбома
            }.catch { error in
                print("Error requesting photos of the user_id \(self.userID): \(error)")
            }
    }
    
    func updateNavigationItem() {
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosResult?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath) as? PhotoCell
        else {
            return UICollectionViewCell()
        }
        
        // Нам нужен Size типа "p" для красивого корректного превью
        let imageSizeType = "p"
        
        cell.likes.likeCount = photosResult?[indexPath.item].likes?.count ?? 0
        cell.likes.isLiked = photosResult?[indexPath.item].likes?.myLike ?? false
        
        if let imageUrl = URL(string: self.photosResult?[indexPath.item]
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
