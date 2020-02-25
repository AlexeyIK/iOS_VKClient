//
//  VKPost.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 25/02/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation

class VKPost: Decodable {
    
}

class PostsArray: Decodable {
    var items: [VKPost]
    var profiles: [VKFriend] // вероятно заменить на VKUser
    var groups: [VKGroup]
}

class NewsResponse: Decodable {
    var response: PostsArray
}
