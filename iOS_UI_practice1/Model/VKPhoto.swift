//
//  VKPhoto.swift
//  iOS_UI_practice1
//
//  Created by Alex on 16/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation

struct VKImage: Decodable {
    var type: String
    var url: String
    var width: Int
    var height: Int
}

struct VKLike: Decodable {
    var myLike: Int
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case myLike = "user_likes"
        case count
    }
}

struct VKPhoto: Decodable {
    var id: Int
    var albumID: Int
    var userID: Int?
    var imageSizes: [VKImage]
    var text: String?
    var likes: VKLike?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageSizes = "sizes"
        case text
        case likes
        case albumID = "album_id"
        case userID = "user_id"
    }
}

struct PhotosArray: Decodable {
    var count: Int
    var items: [VKPhoto]
}

struct ResponsePhotos: Decodable {
    var response: PhotosArray
}
