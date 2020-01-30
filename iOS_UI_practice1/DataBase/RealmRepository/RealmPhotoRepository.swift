//
//  RealmPhotoRepository.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 29/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import RealmSwift

class RealmPhotoRepository {
    
    func getProfilePhotosForUser(userID: Int) throws -> Results<PhotoRealm> {
        do {
            let realm = try Realm()
            return realm.objects(PhotoRealm.self).filter("userID == %@", userID)
        }
        catch {
            throw error
        }
    }
    
    func addPhotos(userID: Int, albumID: Int, photos: [VKPhoto]) {
        let realm = try! Realm()
        
        try! realm.write {
            var photosToAdd = [PhotoRealm]()
            
            photos.forEach { (photo) in
                let newPhoto = PhotoRealm()
                newPhoto.id = photo.id
                newPhoto.caption = photo.text
                newPhoto.albumID = photo.albumID
                newPhoto.userID = userID
                
                let photoLikes = PhotoLikesRealm()
                photoLikes.count = photo.likes.count
                photoLikes.myLike = photo.likes.myLike == 1 ? true : false
                newPhoto.likes = photoLikes
                
                photo.imageSizes.forEach { (size) in
                    let photoSize = PhotoSizeItem()
                    photoSize.type = size.type
                    photoSize.width = size.width
                    photoSize.height = size.height
                    photoSize.url = size.url
                    newPhoto.imageSizes.append(photoSize)
                }
                
                photosToAdd.append(newPhoto)
            }
            realm.add(photosToAdd, update: .modified)
        }
    }
}
