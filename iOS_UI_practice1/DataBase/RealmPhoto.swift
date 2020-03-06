//
//  RealmPhoto.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 22/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import RealmSwift

class PhotoSizeItem : Object {
    @objc dynamic var type = ""
    @objc dynamic var url = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
}

class PhotoLikesRealm : Object {
    @objc dynamic var myLike: Bool = false
    @objc dynamic var count: Int = 0
}

class PhotoRealm : Object {
    @objc dynamic var id = 0
    @objc dynamic var caption: String? = nil
    @objc dynamic var albumID = 0
    @objc dynamic var userID = 0
    @objc dynamic var likes: PhotoLikesRealm?
    
    let imageSizes = List<PhotoSizeItem>() // словарь вариантов картинки разного размера
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["id", "userID", "albumID"]
    }
    
    func toModel() -> VKPhoto {
        var sizes = [VKImage]()
        
        imageSizes.forEach { (size) in
            let modelSize = VKImage(type: size.type,
                                    url: size.url,
                                    width: size.width,
                                    height: size.height)
            sizes.append(modelSize)
        }
        
        return VKPhoto(id: id,
                       albumID: albumID,
                       userID: userID,
                       imageSizes: sizes,
                       text: caption,
                       likes: VKLike(myLike: (likes?.myLike ?? false) ? 1 : 0, count: likes?.count ?? 0))
    }
}
