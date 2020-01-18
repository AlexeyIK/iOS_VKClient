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
    var theme: String
    var isMember: Int
    var logo: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case theme = "activity"
        case isMember = "is_admin"
        case logo = "photo_100"
    }
}

struct GroupsArray: Decodable {
    var count: Int
    var items: [VKGroup]
}

struct ResponseGroups : Decodable {
    var response: GroupsArray
}
