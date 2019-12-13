//
//  User.swift
//  iOS_UI_practice1
//
//  Created by Alex on 30.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

enum GenderType {
    case Male
    case Female
    case Unknown
}

struct User {
    
    var id : Int?
    var isOnline : Bool?
    var isFriend : Bool = true
    var firstName : String?
    var familyName : String?
    var fullName : String = "-"
    let gender : GenderType = GenderType.Unknown
    var avatarPath : String = ""
    
    init(id: Int, firstName : String, familyName : String) {
        self.firstName = firstName
        self.familyName = familyName
        self.fullName = firstName + " " + familyName
        self.avatarPath = UsersFactory.getRandomAvatar(gender: self.gender)
    }

    init(id: Int, firstName : String, familyName : String, isFriend : Bool) {
        self.firstName = firstName
        self.familyName = familyName
        self.fullName = firstName + " " + familyName
        self.avatarPath = UsersFactory.getRandomAvatar(gender: gender)
    }
    
    init(id: Int, firstName : String, familyName : String, isFriend : Bool, gender: GenderType) {
        self.firstName = firstName
        self.familyName = familyName
        self.fullName = firstName + " " + familyName
        self.isFriend = isFriend
        self.avatarPath = UsersFactory.getRandomAvatar(gender: gender)
    }
}
