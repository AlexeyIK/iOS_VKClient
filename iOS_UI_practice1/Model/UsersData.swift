//
//  UsersData.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 10.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import Foundation

class UsersData {
    
    static func getFriends() -> [User] {
        let friends = [
            User(firstName: "Василий", familyName: "Комаров", isFriend: false, gender: GenderType.Male),
            User(firstName: "Евгений", familyName: "Григорьев", isFriend: false, gender: GenderType.Male),
            User(firstName: "Ирина", familyName: "Лаврентьева", isFriend: true, gender: GenderType.Female),
            User(firstName: "Анна", familyName: "Кузнецова", isFriend: true, gender: GenderType.Female),
            User(firstName: "Михаил", familyName: "Пирогов", isFriend: true, gender: GenderType.Male),
            User(firstName: "Олег", familyName: "Смирнов", isFriend: true, gender: GenderType.Male),
            User(firstName: "Анонимус", familyName: "Анонимович", isFriend: true),
            User(firstName: "Кара", familyName: "Небесная", isFriend: true),
            User(firstName: "Ольга", familyName: "Ковальчук", isFriend: true, gender: GenderType.Female),
            User(firstName: "Максим", familyName: "Сухой", isFriend: true, gender: GenderType.Male)
        ]
        
        return friends
    }
}
