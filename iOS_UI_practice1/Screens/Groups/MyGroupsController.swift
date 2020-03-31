//
//  MyGroupsList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 02.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var customRefreshControl = UIRefreshControl()
    
    var groupsResult: Results<GroupRealm>?
    var notificationToken: NotificationToken?
    
    var vkAPI = VKApi()
    var database = RealmGroupRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.register(UINib(nibName: "GroupsCell", bundle: nil), forCellReuseIdentifier: "GroupsTemplate")
        tableView.estimatedRowHeight = 75
    
        addRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadGroupsFromDB()
        requestGroupList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }
    
    /// Get groups from database and add observer to collection
    private func loadGroupsFromDB() {
        do {
            groupsResult = try database.getAllGroups()
            
            notificationToken = groupsResult?.observe { [weak self] results in
                switch results {
                case .error(let error):
                    print("Groups observer error: \(error)")
                case .initial(_):
                    self?.tableView.reloadData()
                case let .update(_, deletions, insertions, modifications):
                    self?.tableView.beginUpdates()
                    self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .left)
                    self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .fade)
                    self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .none)
                    self?.tableView.endUpdates()
                }
            }
        }
        catch {
            print("Error getting user's groups from DB: \(error)")
        }
    }
    
    /// Request groups from API
    func requestGroupList(completion: @escaping (Bool) -> () = { _ in }) {
        vkAPI.getUsersGroups(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token)
            .done { groups in
                self.database.addGroups(groups: groups)
                completion(true)
            }.catch { error in
                print("Error requesting user's groups: \(error)")
            }
    }
    
    func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Обновление списка...")
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
    }
    
    @objc func refreshTable() {
        self.requestGroupList { (isCompleted) in
            self.customRefreshControl.endRefreshing()
        }
    }
}

// MARK: - Search
extension MyGroupsController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchInGroups(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func searchInGroups(searchText: String) {
//        groupsToShow = groupsList.filter( { (group) in
//            searchText.count > 0 ? group.name.lowercased().contains(searchText.lowercased()) : true
//        })
        
        tableView.reloadData()
    }
}

// MARK: - Table and cell settings
extension MyGroupsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsResult?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTemplate", for: indexPath) as? GroupsCell,
            let group = groupsResult?[indexPath.row] else {
                return UITableViewCell()
        }
        
        cell.caption.text = group.name
        cell.groupType.text = group.theme
        cell.membersCount.isHidden = true
        
        if let imageURL = URL(string: group.logoUrl) {
            cell.imageContainer.image.alpha = 0
            
            cell.imageContainer.image.kf.setImage(with: imageURL, placeholder: nil, completionHandler: { (_) in
                UIView.animate(withDuration: 0.5) {
                    cell.imageContainer.image.alpha = 1.0
                }
            })
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let targetGroup = groupsResult?[indexPath.row] else {
            return
        }
        
        if editingStyle == .delete {
            database.deleteGroup(group: targetGroup)
        }
    }
}
