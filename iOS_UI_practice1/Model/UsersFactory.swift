//
//  UsersFactory.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 10.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import Foundation

class UsersFactory {
    
    static let femaleAvatars : [String] = [ "user_ava_female1", "user_ava_female2", "user_ava_female3", "user_ava_female4" ]
    static let maleAvatars : [String] = [ "user_ava_male1", "user_ava_male2", "user_ava_male3", "user_ava_male4" ]
    static let unisexAvatars : [String] = ["user_ava_unisex1", "user_ava_unisex2" ]
    
    static var usersList : [User] = [
        User(id: 1, firstName: "Василий", familyName: "Комаров", isFriend: false, gender: GenderType.Male),
        User(id: 2, firstName: "Евгений", familyName: "Григорьев", isFriend: false, gender: GenderType.Male),
        User(id: 3, firstName: "Ирина", familyName: "Лаврентьева", isFriend: true, gender: GenderType.Female),
        User(id: 4, firstName: "Анна", familyName: "Кузнецова", isFriend: true, gender: GenderType.Female),
        User(id: 5, firstName: "Михаил", familyName: "Пирогов", isFriend: true, gender: GenderType.Male),
        User(id: 6, firstName: "Олег", familyName: "Смирнов", isFriend: true, gender: GenderType.Male),
        User(id: 7, firstName: "Анонимус", familyName: "Анонимович", isFriend: true),
        User(id: 8, firstName: "Кара", familyName: "Небесная", isFriend: true),
        User(id: 9, firstName: "Ольга", familyName: "Ковальчук", isFriend: true, gender: GenderType.Female),
        User(id: 10, firstName: "Максим", familyName: "Сухой", isFriend: true, gender: GenderType.Male)
    ]
    
    public static func getAllUsers() -> [User] {
        return usersList
    }
    
    public static func getRandomAvatar(gender: GenderType) -> String {
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
