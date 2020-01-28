//
//  MyGroupsList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 02.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var customRefreshControl = UIRefreshControl()
//    var groupsToShow = [Group]()
    var groupsToShow = [VKGroup]()
    var groupsList = [VKGroup]()
    
    var vkAPI = VKApi()
    var database = RealmGroupRepository()
    
    override func loadView() {
        super.loadView()
        // Инициализируем списки групп
//        GroupsFactory.updateList()
//        groupsToShow = GroupsFactory.myGroups
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.register(UINib(nibName: "GroupsCell", bundle: nil), forCellReuseIdentifier: "GroupsTemplate")
        tableView.estimatedRowHeight = 75
        
        loadGroupsFromDB()
        requestGroupList()
        addRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
//        requestGroupList()
    }
    
    private func loadGroupsFromDB() {
        do {
            self.groupsToShow = Array(try database.getAllGroups().map { $0.toModel() })
            self.tableView.reloadData()
        }
        catch {
            print("Error getting user's groups from DB: \(error)")
        }
    }
    
    func requestGroupList() {
        vkAPI.getUsersGroups(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token)
        { (result) in
            switch result {
            case .success(let groups):
                self.groupsList = groups
                self.database.addGroups(groups: groups)
                self.groupsToShow = groups
                self.tableView.reloadData()
            case .failure(let error):
                print("Error requesting user's groups: \(error)")
            }
        }
    }
    
    func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Обновление списка...")
        tableView.addSubview(customRefreshControl)
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    @objc func refreshTable() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.customRefreshControl.endRefreshing()
            self.requestGroupList()
        })
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
        groupsToShow = groupsList.filter( { (group) in
            searchText.count > 0 ? group.name.lowercased().contains(searchText.lowercased()) : true
        })
        
        tableView.reloadData()
    }
}

// MARK: - Table and cell settings
extension MyGroupsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsToShow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTemplate", for: indexPath) as! GroupsCell
        
        cell.caption.text = groupsToShow[indexPath.row].name
        cell.groupType.text = groupsToShow[indexPath.row].theme
        cell.membersCount.isHidden = true
        
        if let imageURL = URL(string: self.groupsToShow[indexPath.row].logo) {
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
        
        let targetGroup = groupsToShow[indexPath.row]
        let index = GroupsFactory.allGroupsList.firstIndex(where: {$0.id == targetGroup.id} )
        
        if editingStyle == .delete && index != nil {
            GroupsFactory.allGroupsList[index!].isMeInGroup = false
            GroupsFactory.updateList()
            groupsToShow = groupsList
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
