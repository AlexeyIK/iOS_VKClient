//
//  RealmUser.swift
//  iOS_UI_practice1
//
//  Created by Alex on 20/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation
import RealmSwift

class UserRealm : Object {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var avatarPath: String = ""
    @objc dynamic var deactivated: String = ""
}

class UsersRepositoryRealm {
    func addUser(id: Int, firstname: String, lastname: String, imageURL: String) {
        let realm = try! Realm()
        let newUser = UserRealm()
        newUser.id = id
        newUser.firstName = firstname
        newUser.lastName = lastname
        
        try! realm.write {
            realm.add(newUser)
        }
    }
}
