//
//  RealmGroup.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 22/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation
import RealmSwift

class GroupRealm : Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var theme = ""
    @objc dynamic var logoUrl = ""
}

class GroupsRepositoryRealm {
    func addGroup(id: Int, name: String, theme: String?, imageURL: String) {
        let realm = try! Realm()
        let newGroup = GroupRealm()
        newGroup.id = id
        newGroup.name = name
        newGroup.theme = theme ?? ""
        newGroup.logoUrl = imageURL
        
        try! realm.write {
            realm.add(newGroup)
        }
    }
}
