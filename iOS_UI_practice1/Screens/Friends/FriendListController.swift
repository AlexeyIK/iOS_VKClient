//
//  FriendList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 29.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit
import Kingfisher

struct Section<T> {
    var title: String
    var items: [T]
}

class FriendListController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func Logout(_ sender: Any) {
        logout()
    }
    
    var vkAPI = VKApi()
    
    // Список тестовых юзеров
//    let testUsersList = UsersFactory.getAllUsers()
    var allFriends = [VKFriend]()
    var friendsSection = [Section<VKFriend>]()
    var friendsToShow = [VKFriend]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        friendsRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        friendsRequest()
    }
    
    private func friendsRequest() {
        vkAPI.getFriendList(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token)
        { (result) in
            switch result {
            case.success(let friends):
                self.allFriends = friends.filter { $0.deactivated == nil }
                self.friendsToShow = self.allFriends
                self.mapToSections()
            case .failure(let error):
                print ("Error requesting friends: \(error)")
            }
            
        }
    }
    
    private func logout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
        loginVC.transitioningDelegate = self
//        loginVC.modalPresentationStyle = .custom
        present(loginVC, animated: true, completion: nil)
    }
    
    private func mapToSections() {
        if friendsToShow.count > 0 {
            let friendsDictionary = Dictionary.init(grouping: friendsToShow) {
                $0.lastName.prefix(1)
            }
            
            friendsSection = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
            friendsSection.sort(by: { $0.title < $1.title })
        }
        
        tableView.reloadData()
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
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let tableViewCell = cell as? FriendCell else { return }
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: // Секция "заявки в друзья". ToDo: попробовать сделать с реальными данными
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTemplate", for: indexPath) as? RequestCell else {
                return UITableViewCell()
            }
            /*let user = requestList[indexPath.section]
            
            cell.userName.text = user.fullName
            cell.num.text = String(requestList.count)
            cell.shadowAvatar.image.image = UIImage(named: user.avatarPath)
            */
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTemplate", for: indexPath) as? FriendCell else {
                return UITableViewCell()
            }
            let user = friendsSection[indexPath.section - 1].items[indexPath.row]

            cell.userName.text = user.firstName + " " + user.lastName
            cell.isOnline.isHidden = user.isOnline == 0 ? true : false
            
            if let imageURL = URL(string: user.avatarPath ?? "") {
                cell.avatar.image.alpha = 0.0
                
                cell.avatar.image.kf.setImage(with: imageURL, placeholder: nil, completionHandler: { (_) in
                    UIView.animate(withDuration: 0.5) {
                        cell.avatar.image.alpha = 1.0
                    }
                })
            }
            
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
        
        let targetRow = friendsSection[indexPath.section - 1].items[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PhotoAlbumController") as! PhotoAlbumController
        
        viewController.username = targetRow.firstName + " " + targetRow.lastName
        viewController.userID = String(targetRow.id)
        print("userID: \(targetRow.id)")
        
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
extension FriendListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchInFriends(searchText: searchText)
        }
        else {
            friendsToShow = allFriends
            view.endEditing(true)
            mapToSections()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func searchInFriends(searchText: String) {
        friendsToShow = allFriends.filter {
            $0.firstName.lowercased().contains(searchText.lowercased()) ||
                $0.lastName.lowercased().contains(searchText.lowercased())
        }
        mapToSections()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        view.endEditing(true)
    }
}

extension FriendListController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardRotateTransitionInverted()
    }
}
