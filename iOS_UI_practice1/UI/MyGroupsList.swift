//
//  MyGroupsList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 02.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class MyGroupsList: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var customRefreshControl = UIRefreshControl()
    var groupsToShow = [Group]()
    
    override func loadView() {
        super.loadView()
        // Инициализируем списки групп
        GroupsFactory.updateList()
        groupsToShow = GroupsFactory.myGroups
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.register(UINib(nibName: "GroupsCell", bundle: nil), forCellReuseIdentifier: "GroupsTemplate")
        tableView.estimatedRowHeight = 75
        addRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        groupsToShow = GroupsFactory.myGroups
        tableView.reloadData()
    }
    
    func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Обновление списка...")
        tableView.addSubview(customRefreshControl)
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    @objc func refreshTable() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
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
extension MyGroupsList : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchInGroups(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func searchInGroups(searchText: String) {
        groupsToShow = GroupsFactory.myGroups.filter( { (group) in
            searchText.count > 0 ? group.groupName!.lowercased().contains(searchText.lowercased()) : true
        })
        
        tableView.reloadData()
    }
}

// MARK: - Table and cell settings
extension MyGroupsList {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsToShow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTemplate", for: indexPath) as! GroupsCell
        
        cell.caption.text = groupsToShow[indexPath.row].groupName
        cell.groupType.text = groupsToShow[indexPath.row].groupSubstring
        cell.imageContainer.image.image = UIImage(named: groupsToShow[indexPath.row].imagePath!)
        cell.membersCount.isHidden = true
        
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
            groupsToShow = GroupsFactory.myGroups
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
