//
//  RealmGroupRepository.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 28/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import RealmSwift

class RealmGroupRepository {
    
    func getAllGroups() throws -> Results<GroupRealm> {
        do {
            let realm = try Realm()
            return realm.objects(GroupRealm.self)
        }
        catch {
            throw error
        }
    }
    
    func addGroup(group: VKGroup) {
        let realm = try! Realm()
        
        try! realm.write {
            let newGroup = GroupRealm()
            newGroup.id = group.id
            newGroup.name = group.name
            newGroup.logoUrl = group.logo
            newGroup.theme = group.theme
            realm.add(newGroup)
        }
    }
    
    func addGroups(groups: [VKGroup]) {
        let realm = try! Realm()
        
        try! realm.write {
            var groupsToAdd = [GroupRealm]()
            
            groups.forEach { (group) in
                let newGroup = GroupRealm()
                newGroup.id = group.id
                newGroup.name = group.name
                newGroup.logoUrl = group.logo
                newGroup.theme = group.theme
                groupsToAdd.append(newGroup)
            }
            realm.add(groupsToAdd, update: .modified)
        }
    }
    
    func searchGroups(name: String) throws -> Results<GroupRealm> {
        do {
            let realm = try Realm()
            return realm.objects(GroupRealm.self).filter("name CONTAINS[c] %@", name)
        }
        catch {
            throw error
        }
    }
}
