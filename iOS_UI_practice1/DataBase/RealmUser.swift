//
//  RealmUser.swift
//  iOS_UI_practice1
//
//  Created by Alex on 20/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import RealmSwift

class UserRealm : Object {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var avatarPath: String = ""
    @objc dynamic var deactivated: String? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["name", "deactivated"]
    }
    
    func toModel() -> VKFriend {
        return VKFriend(id: id,
                        firstName: firstName,
                        lastName: lastName,
                        avatarPath: avatarPath,
                        deactivated: deactivated)
    }
}
