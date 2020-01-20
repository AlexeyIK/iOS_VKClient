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
        
        requestGroupList()
        addRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
//        requestGroupList()
    }
    
    func requestGroupList() {
        vkAPI.getUsersGroups(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token) { (receivedGroups) in
            self.groupsList = receivedGroups
            self.groupsToShow = receivedGroups
            self.tableView.reloadData()
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
        })
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
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
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let tableViewCell = cell as? GroupsCell else { return }
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTemplate", for: indexPath) as! GroupsCell
        
        cell.caption.text = groupsToShow[indexPath.row].name
        cell.groupType.text = groupsToShow[indexPath.row].theme
        cell.membersCount.isHidden = true
        
        DispatchQueue.global().async {
            if let imageURL = URL(string: self.groupsToShow[indexPath.row].logo ?? "") {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        cell.imageContainer.image.image = UIImage(data: imageData)
                        cell.imageContainer.image.alpha = 0.0
                        UIView.animate(withDuration: 0.3) {
                            cell.imageContainer.image.alpha = 1.0
                        }
                    }
                }
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.imageContainer.addGestureRecognizer(tapGesture)
        
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
