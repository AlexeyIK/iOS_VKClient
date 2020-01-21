//
//  RealmDatabase.swift
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
    @objc dynamic var isOnline: Bool = false
}

class UsersArrayRealm : Object {
    @objc dynamic var count = 0
    var items = List<UserRealm>()
}

class UsersRepositoryRealm {
    
}
