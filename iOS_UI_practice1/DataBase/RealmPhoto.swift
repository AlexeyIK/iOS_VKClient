//
//  RealmPhoto.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 22/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation
import RealmSwift

class PhotoSizeItem : Object {
    @objc dynamic var url = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
}

class PhotoRealm : Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var caption = ""
    
    var imageSizes = Dictionary<String, PhotoSizeItem>() // словарь вариантов картинки разного размера
}

class PhotoRepositoryRealm {
    func addPhoto(id: Int, caption: String, imageSizes: [String: PhotoSizeItem]) {
        let realm = try! Realm()
        let newPhoto = PhotoRealm()
        newPhoto.id = id
        newPhoto.caption = caption
        newPhoto.imageSizes = imageSizes
        
        try! realm.write {
            realm.add(newPhoto)
        }
    }
}
