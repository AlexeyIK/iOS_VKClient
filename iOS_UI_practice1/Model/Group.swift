//
//  Group.swift
//  iOS_UI_practice1
//
//  Created by Alex on 02.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

// Типы групп, что могут быть
enum GroupType {
    case Photography
    case Music
    case Humor
    case Interests
    case Movies
    case Games
    case Public
}

struct Group {
    
    var id : Int
    var groupName : String?
    var groupType : GroupType
    lazy var groupSubstring : String = GroupTypeToText(groupType: groupType)
    var numOfMembers : Int?
    var isMeInGroup : Bool
//    var image : UIImage?
    var imagePath : String?
    
    init(id: Int, name: String, type: GroupType, membersCount: Int?, isAMember: Bool) {
        self.id = id
        self.groupName = name
        self.groupType = type
        self.isMeInGroup = isAMember
        self.numOfMembers = membersCount
    }
    
    init(id: Int, name: String, type: GroupType, membersCount: Int?, isAMember: Bool, imagePath: String) {
        self.id = id
        self.groupName = name
        self.groupType = type
        self.isMeInGroup = isAMember
        self.imagePath = imagePath
        self.numOfMembers = membersCount
    }
    
    func GroupTypeToText(groupType: GroupType) -> String {
        switch groupType {
        case .Humor:
            return "Юмор"
        case .Interests:
            return "Сообщество по интересам"
        case .Movies:
            return "Кино"
        case .Music:
            return "Музыка"
        case .Photography:
            return "Фотография"
        case .Games:
            return "Игры"
        default:
            return "Сообщество"
        }
    }
}
