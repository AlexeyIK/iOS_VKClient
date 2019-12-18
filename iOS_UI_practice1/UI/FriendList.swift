//
//  FriendList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 29.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

struct Section<T> {
    var title: String
    var items: [T]
}

class FriendList: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Список тестовых юзеров
    let testUsersList = UsersFactory.getAllUsers()
    
    var friendsSection = [Section<User>]()
    
    var friendList = [User]()
    var requestList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        mapToSections()
        
        for nextUser in testUsersList {
            if nextUser.isFriend {
                friendList.append(nextUser)
            }
            else {
                requestList.append(nextUser)
            }
        }
    }
    
    private func mapToSections() {
        let friendsDictionary = Dictionary.init(grouping: testUsersList) {
            $0.familyName!.prefix(1)
        }
        
        friendsSection = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendsSection.sort(by: { $0.title < $1.title })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsSection.count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Заявки в друзья"
        default:
            return String(friendsSection[section - 1].title.prefix(1))
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsSection.map( {$0.title} )
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return friendsSection[section - 1].items.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTemplate", for: indexPath) as? RequestCell else {
                return UITableViewCell()
            }
            let user = requestList[indexPath.section]
            
            cell.userName.text = user.fullName
            cell.num.text = String(requestList.count)
            cell.shadowAvatar.image.image = UIImage(named: user.avatarPath)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTemplate", for: indexPath) as? FriendCell else {
                return UITableViewCell()
            }
            let user = friendsSection[indexPath.section - 1].items[indexPath.row]
            
            cell.userName.text = user.fullName
            cell.avatar.image.image = UIImage(named: user.avatarPath)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
            cell.avatar.addGestureRecognizer(tapGesture)
            
            return cell
        }
    }
    
    @objc func avatarTapped(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view else { return }
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.3,
                       options: [.autoreverse],
                       animations: {
                            imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        },
                       completion: { _ in
                            imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        })
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (indexPath.section != 0) {
            if editingStyle == .delete {
                // удалить друга, если он в списке друзей, а не заявок
                friendsSection[indexPath.section - 1].items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        let username = friendList[indexPath.row].fullName
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PhotoController") as! PhotoController
        viewController.user = username
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: .default, title: "Поделиться") { (action, index) in
            print("Share information by \(index.section) \(index.row)")
        }
        shareAction.backgroundColor = UIColor.blue
        
        let forwardAction = UITableViewRowAction(style: .default, title: "Переслать") { (action, index) in
            print("Forward information by \(index.section) \(index.row)")
        }
        return [shareAction, forwardAction]
    }
}

// MARK: Friend search extension
extension FriendList: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchInFriends(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func searchInFriends(searchText: String) {
        let friendsDictionary = Dictionary.init(grouping: friendList.filter( { (user: User) -> Bool in
            return searchText.isEmpty ? true : user.fullName.lowercased().contains(searchText.lowercased())
        }), by: { $0.familyName!.prefix(1) })
        
        friendsSection = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendsSection.sort(by: { $0.title < $1.title })
        
        tableView.reloadData()
    }
}
