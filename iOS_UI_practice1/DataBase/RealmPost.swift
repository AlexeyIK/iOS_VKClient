//
//  RealmPost.swift
//  iOS_UI_practice1
//
//  Created by Alex on 06/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import RealmSwift

class AttachmentRealm : Object {
    // ToDo: описать аттачменты
}

class PostRealm : Object {
    @objc dynamic var id = 0
    @objc dynamic var type: String? = nil
    @objc dynamic var date = Date()
    @objc dynamic var text: String? = nil
    let photosList = List<PhotoRealm>()
    let attachmentsList = List<AttachmentRealm>()
    
    @objc dynamic var byUser: UserRealm?
    @objc dynamic var byGroup: GroupRealm?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
