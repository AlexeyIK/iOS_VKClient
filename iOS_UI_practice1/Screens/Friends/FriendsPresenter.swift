//
//  FriendsPresenter.swift
//  iOS_UI_practice1
//
//  Created by Alex on 27/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit
import RealmSwift

protocol FriendsPresenter {
    func viewDidLoad()
    func searchInFriends(name: String)
    func findUsersAlbum(indexPath: IndexPath, albumControllerName: String) -> UIViewController?
    
    func getSectionIndexTitles() -> [String]?
    func getTitleForSection(section: Int) -> String?
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func getModelAtIndex(indexPath: IndexPath) -> UserRealm?
    
//    func getCellForEditing(indexPath: IndexPath) -> UserRealm?
}

class FriendsPresenterImplementation: FriendsPresenter {
    
    private var vkAPI: VKApi
    private var database: UsersSource
    private weak var view: FriendsListView?
    
    private var sortedFriendsResults = [Section<UserRealm>]()
    private var friendsResults: Results<UserRealm>!
    
    // ToDo: дописать
    init(database: UsersSource, view: FriendsListView) {
        vkAPI = VKApi()
        self.database = database
        self.view = view
    }
    
    func viewDidLoad() {
        getUsersFromDB()
        getUsersFromApi()
    }
    
    private func getUsersFromDB() {
       do {
            self.friendsResults = try database.getAllUsers()
            self.mapToSections()
        } catch {
            print(error)
        }
    }
    
    private func getUsersFromApi() {
        vkAPI.getFriendList(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token)
            .done { friends in
                self.database.addUsers(users: friends.filter { $0.deactivated == nil })
                self.getUsersFromDB()
                self.mapToSections()
        }.catch { error in
            print ("Error requesting friends: \(error)")
            let alert = UIAlertController(title: "Ошибка загрузки данных", message: "Не удается загрузить список друзей", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            //                view?.showAlert(alert: alert, view: view)
        }
    }
    
    private func mapToSections() {
        if friendsResults.count > 0 {
            let friendsDictionary = Dictionary.init(grouping: friendsResults) {
                $0.lastName.prefix(1)
            }
            
            sortedFriendsResults = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
            sortedFriendsResults.sort(by: { $0.title < $1.title })
        }
        view?.updateTable()
    }
    
    func searchInFriends(name: String) {
        do {
            friendsResults = name.isEmpty ? try database.getAllUsers() : try database.searchUsers(name: name)
            mapToSections()
        } catch {
            print("Search: \(error)")
        }
    }
}

extension FriendsPresenterImplementation {
    
    func getSectionIndexTitles() -> [String]? {
        return sortedFriendsResults.map( {$0.title} )
    }
    
    func getTitleForSection(section: Int) -> String? {
        switch section {
        case 0:
            return "Заявки в друзья"
        default:
            return String(sortedFriendsResults[section - 1].title.prefix(1))
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return sortedFriendsResults[section - 1].items.count
        }
    }
    
    func numberOfSections() -> Int {
        return sortedFriendsResults.count + 1
    }
    
    func getModelAtIndex(indexPath: IndexPath) -> UserRealm? {
        return sortedFriendsResults[indexPath.section - 1].items[indexPath.row]
    }
    
    func findUsersAlbum(indexPath: IndexPath, albumControllerName: String) -> UIViewController? {
        
        if let selectedUser = getModelAtIndex(indexPath: indexPath) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: albumControllerName) as! PhotoAlbumController
            viewController.username = selectedUser.firstName + " " + selectedUser.lastName
            viewController.userID = selectedUser.id
            print("userID: \(selectedUser.id)")
            
            return viewController
        }
        
        return nil
    }
    
//    func getCellForEditing(indexPath: IndexPath) -> UserRealm? {
//
//    }
}
