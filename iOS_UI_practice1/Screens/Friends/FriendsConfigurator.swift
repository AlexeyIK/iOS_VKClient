//
//  FriendsConfigurator.swift
//  iOS_UI_practice1
//
//  Created by Alex on 27/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation

protocol FriendsConfigurator {
    func configure(view: FriendListViewController)
}

class FriendsConfiguratorImpl: FriendsConfigurator {
    func configure(view: FriendListViewController) {
        view.presenter = FriendsPresenterImplementation(database: RealmUserRepository(), view: view)
    }
}
