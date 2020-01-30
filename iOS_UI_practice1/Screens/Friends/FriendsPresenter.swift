//
//  FriendsPresenter.swift
//  iOS_UI_practice1
//
//  Created by Alex on 27/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation

protocol FriendsPresenter {
    func viewDidLoad()
    
    func getUsers()
}
/*
class FriendsPresenterImplementation: FriendsPresenter {
    
    private var vkAPI: VKApi
    private var database: RealmUserRepository
    
    var sortedFriends = [Section<VKFriend>]()
    var friendList: [VKFriend] = []
    
    func viewDidLoad() {
        vkAPI = VKApi()
        database = RealmUserRepository()
    }
    
    func getUsers() {
        <#code#>
    }
    
    private func getUsersFromApi() {
        vkAPI.getFriendList(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token)
        { (result) in
            switch result {
            case.success(let friends):
                self.allFriends = friends.filter { $0.deactivated == nil }
                self.database.addUsers(users: friends)
                self.friendsToShow = self.allFriends
                self.mapToSections()
            case .failure(let error):
                print ("Error requesting friends: \(error)")
            }
            
        }
    }
}*/
