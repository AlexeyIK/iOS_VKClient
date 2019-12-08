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

class User {
    
    let femaleAvatars : [String] = [ "user_ava_female1", "user_ava_female2", "user_ava_female3", "user_ava_female4" ]
    let maleAvatars : [String] = [ "user_ava_male1", "user_ava_male2", "user_ava_male3", "user_ava_male4" ]
    let unisexAvatars : [String] = ["user_ava_unisex1", "user_ava_unisex2" ]
    
    var isOnline : Bool?
    var isFriend : Bool = true
    var firstName : String?
    var familyName : String?
    var fullName : String = "-"
    let gender : GenderType = GenderType.Unknown
//    var avatar : UIImage?
    var avatarPath : String = ""
    
    init(firstName : String, familyName : String) {
        self.firstName = firstName
        self.familyName = familyName
        self.fullName = firstName + " " + familyName
        self.avatarPath = getRandomAvatar(gender: self.gender)
    }

    init(firstName : String, familyName : String, isFriend : Bool) {
        self.firstName = firstName
        self.familyName = familyName
        self.fullName = firstName + " " + familyName
        self.avatarPath = getRandomAvatar(gender: gender)
    }
    
    init(firstName : String, familyName : String, isFriend : Bool, gender: GenderType) {
        self.firstName = firstName
        self.familyName = familyName
        self.fullName = firstName + " " + familyName
        self.isFriend = isFriend
        self.avatarPath = getRandomAvatar(gender: gender)
    }
    
    private func getRandomAvatar(gender: GenderType) -> String {
        switch gender {
        case .Male:
            return maleAvatars[Int.random(in: 0..<maleAvatars.count)]
        case .Female:
            return femaleAvatars[Int.random(in: 0..<femaleAvatars.count)]
        default:
            return unisexAvatars[Int.random(in: 0..<unisexAvatars.count)]
        }
    }
}
