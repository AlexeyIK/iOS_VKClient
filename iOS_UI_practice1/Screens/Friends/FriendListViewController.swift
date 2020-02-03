//
//  FriendListViewController.swift
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

protocol FriendsListView: class {
    func updateTable()
//    func showAlert(alert: UIAlertController)
}

class FriendListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func Logout(_ sender: Any) {
        logout()
    }
    
    // MVP connections
    var presenter: FriendsPresenter?
    var configurator: FriendsConfigurator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        presenter?.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator = FriendsConfiguratorImpl()
        configurator?.configure(view: self)
        searchBar.delegate = self
        
        presenter?.viewDidLoad()
    }
    
    private func logout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
        loginVC.transitioningDelegate = self
//        loginVC.modalPresentationStyle = .custom
        present(loginVC, animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.getTitleForSection(section: section)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return presenter?.getSectionIndexTitles()
    }

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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTemplate", for: indexPath) as? FriendCell,
                let user = presenter?.getModelAtIndex(indexPath: indexPath)
            else {
                return UITableViewCell()
            }
            
            cell.prepareCell(model: user)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (indexPath.section != 0) {
//            if editingStyle == .delete {
//                // удалить друга, если он в списке друзей, а не заявок
//                friendsSection[indexPath.section - 1].items.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        /*let targetRow = friendsSection[indexPath.section - 1].items[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PhotoAlbumController") as! PhotoAlbumController
        
        viewController.username = targetRow.firstName + " " + targetRow.lastName
        viewController.userID = targetRow.id
        print("userID: \(targetRow.id)")
        
        self.navigationController?.pushViewController(viewController, animated: true)*/
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
extension FriendListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchInFriends(name: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    } 
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        view.endEditing(true)
    }
}

extension FriendListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardRotateTransitionInverted()
    }
}

extension FriendListViewController : FriendsListView {
    func updateTable() {
        tableView.reloadData()
    }
    
//    func showAlert(alert: UIAlertController) {
//        view.present(alert, animated: true, completion: nil)
//    }
}
