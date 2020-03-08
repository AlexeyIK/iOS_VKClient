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
    var theme: String?
    var logo: String
    var isMember: Int
    var membersCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case theme = "activity"
        case isMember = "is_member"
        case logo = "photo_100"
        case membersCount = "members_count"
    }
}

struct GroupsArray: Decodable {
    var count: Int
    var items: [VKGroup]
}

struct ResponseGroups : Decodable {
    var response: GroupsArray
}
