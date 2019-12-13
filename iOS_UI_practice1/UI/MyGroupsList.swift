//
//  MyGroupsList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 02.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class MyGroupsList: UITableViewController {
    
    var customRefreshControl = UIRefreshControl()
    
    override func loadView() {
        super.loadView()
        
        // Инициализируем списки групп
        GroupsFactory.updateList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Обновление списка...")
        tableView.addSubview(customRefreshControl)
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    @objc func refreshTable() {
        print("Start refreshing")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.customRefreshControl.endRefreshing()
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GroupsFactory.myGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTemplate", for: indexPath) as! GroupCell
        
        cell.caption.text = GroupsFactory.myGroups[indexPath.row].groupName
        cell.subTitle.text = GroupsFactory.myGroups[indexPath.row].groupSubstring
        cell.groupImage.image = UIImage(named: GroupsFactory.myGroups[indexPath.row].imagePath!)
        cell.numOfMembers.text = "" // пустой текст, чтобы не отображать количество людей в группах, в которых мы состоим

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let targetGroup = GroupsFactory.myGroups[indexPath.row]
        let index = GroupsFactory.allGroupsList.firstIndex(where: {$0.id == targetGroup.id} )
        
        if editingStyle == .delete && index != nil {
            GroupsFactory.allGroupsList[index!].isMeInGroup = false
            GroupsFactory.updateList()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {

    }
}
