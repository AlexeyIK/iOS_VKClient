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

class UsersRepositoryRealm {
    
    func getAllUsers() throws -> Results<UserRealm> {
        do {
            let realm = try Realm()
            return realm.objects(UserRealm.self)
        } catch {
            throw error
        }
    }
    
    func addUser(user: VKFriend) {
        let realm = try! Realm()
        let newUser = UserRealm()
        newUser.id = user.id
        newUser.firstName = user.firstName
        newUser.lastName = user.lastName
        
        try! realm.write {
            realm.add(newUser)
        }
        
        print(realm.objects(UserRealm.self))
    }
    
    func addUsers(users: [VKFriend]) {
        let realm = try! Realm()
        try! realm.write {
            var usersToAdd = [UserRealm]()
            users.forEach { (user) in
                let newUser = UserRealm()
                newUser.id = user.id
                newUser.firstName = user.firstName
                newUser.lastName = user.lastName
                usersToAdd.append(newUser)
            }
            
            realm.add(usersToAdd, update: .modified)
        }
        print(realm.objects(UserRealm.self))
    }
    
    func searchUsers(name: String) throws -> Results<UserRealm> {
        do {
            let realm = try Realm()
            return realm.objects(UserRealm.self).filter("name CONTAINS[c] %@", name)
        }
        catch {
            throw error
        }
    }
}
