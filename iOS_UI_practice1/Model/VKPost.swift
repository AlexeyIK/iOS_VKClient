//
//  VKPost.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 25/02/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation

// Типы постов
enum PostType: String {
    case post
    case wall_photo
    case photo
    case photo_tag
    case friend
    case note
    case audio
    case video
}

// Типы вложений в пост
enum AttachmentType: String {
    case photo
    case link
    case audio
    case video
}

struct VKPost {
    let type: PostType
    let postId: Int
    let sourceId: Int // если положительный - новость пользователя, отрицательный - новость группы
    let date: Date
    let text: String? // текст поста
    
    var photos: [VKPhoto]
    var attachments: [VKAttachment]
    
    let user: VKFriend
    let group: VKGroup
}

struct PostsArray {
    var items: [VKPost]
    var profiles: [VKFriend] // вероятно заменить на VKUser
    var groups: [VKGroup]
}

struct NewsResponse {
    var response: PostsArray
}

struct VKLink {
    let url: String
    let title: String
    let descr: String
    let target: String // пока строка, но нужен enum
}

// Базовый класс для аттачмента новости
class VKAttachment {
    let type: AttachmentType?
    
    init(typeStr: String) {
        self.type = AttachmentType(rawValue: typeStr)
    }
}

// Аттачмент типа "ссылка"
class VKNewsLink: VKAttachment {
    let link: VKLink
    
    init(typeStr: String, url: String, title: String, description: String, target: String) {
        self.link = VKLink(url: url, title: title, descr: description, target: target)
        super.init(typeStr: typeStr)
    }
}

// Аттачмент типа "фото"
class VKNewsPhoto: VKAttachment {
    let photo: VKPhoto
    
    init(typeStr: String, id: Int, albumID: Int, userID: Int?, imageSizes: [VKImage], text: String) {
        self.photo = VKPhoto(id: id, albumID: albumID, userID: userID, imageSizes: imageSizes, text: text)
        super.init(typeStr: typeStr)
    }
}
