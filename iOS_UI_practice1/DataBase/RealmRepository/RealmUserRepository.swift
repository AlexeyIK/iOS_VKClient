//
//  RealmUserRepository.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 28/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import RealmSwift

protocol UsersSource {
    func getAllUsers() throws -> Results<UserRealm>
    func addUser(user: VKFriend)
    func addUsers(users: [VKFriend])
    func searchUsers(name: String) throws -> Results<UserRealm>
}

class RealmUserRepository: UsersSource {
    
    func getAllUsers() throws -> Results<UserRealm> {
        do {
            let realm = try Realm()
            return realm.objects(UserRealm.self)
        }
        catch {
            throw error
        }
    }
    
    func addUser(user: VKFriend) {
        let realm = try! Realm()
        let newUser = UserRealm()
        newUser.id = user.id
        newUser.firstName = user.firstName
        newUser.lastName = user.lastName
        newUser.isOnline = user.isOnline == 1 ? true : false
        newUser.avatarPath = user.avatarPath
        try! realm.write {
            realm.add(newUser)
        }
        
//        print(realm.objects(UserRealm.self))
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
                newUser.isOnline = user.isOnline == 1 ? true : false
                newUser.avatarPath = user.avatarPath
                usersToAdd.append(newUser)
            }
            
            realm.add(usersToAdd, update: .modified)
        }
//        print(realm.objects(UserRealm.self))
    }
    
    func searchUsers(name: String) throws -> Results<UserRealm> {
        do {
            let realm = try Realm()
            return realm.objects(UserRealm.self).filter("firstName CONTAINS[c] %@", name) // TODO: add "or lastName"
        }
        catch {
            throw error
        }
    }
}
