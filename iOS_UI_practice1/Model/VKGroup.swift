//
//  VKGroup.swift
//  iOS_UI_practice1
//
//  Created by Alex on 16/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation

struct VKGroup: Decodable {
    var id: Int
    var name: String
    var isMember: Int
    var photo: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isMember = "is_admin"
        case photo = "photo_50"
    }
}

struct ResponseGroups: Decodable {
    var count: Int
    var items: [VKGroup]
}
