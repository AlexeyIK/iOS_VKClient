//
//  RealmGroup.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 22/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import RealmSwift

class GroupRealm : Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var theme: String? = nil
    @objc dynamic var logoUrl = ""
    @objc dynamic var isMember = 0
    let membersCount = RealmOptional<Int>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["name", "isMember"]
    }
    
    func toModel() -> VKGroup {
        return VKGroup(id: id,
                       name: name,
                       theme: theme,
                       logo: logoUrl,
                       isMember: isMember,
                       membersCount: membersCount.value)
    }
}
