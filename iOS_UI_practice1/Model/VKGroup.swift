//
//  VKGroup.swift
//  iOS_UI_practice1
//
//  Created by Alex on 16/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct VKGroup: Decodable {
    let id: Int
    let name: String
    let theme: String
    let logo: String
    let isMember: Int
    let membersCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case theme = "activity"
        case isMember = "is_member"
        case logo = "photo_100"
        case membersCount = "members_count"
    }
    
//    init(json: JSON) {
//        self.id = json["id"].intValue
//        self.name = json["name"].stringValue
//        self.logo = json["photo_100"].string ?? json["photo_50"].stringValue
//        self.isMember = 1
//        self.theme = ""
//        self.membersCount = nil
//    }
}

struct GroupsArray: Decodable {
    var count: Int
    var items: [VKGroup]
}

struct ResponseGroups : Decodable {
    var response: GroupsArray
}
