//
//  AllGroupsList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 03.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class AllGroupsList: UITableViewController {

    override func loadView() {
        super.loadView()
        GroupsFactory.updateList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GroupsCell", bundle: nil), forCellReuseIdentifier: "GroupsTemplate")
        tableView.estimatedRowHeight = 75
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GroupsFactory.otherGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTemplate", for: indexPath) as! GroupsCell
        
        cell.caption.text = GroupsFactory.otherGroups[indexPath.row].groupName
        cell.groupType.text = GroupsFactory.otherGroups[indexPath.row].groupSubstring
        cell.imageContainer.image.image = UIImage(named: GroupsFactory.otherGroups[indexPath.row].imagePath!)
        
        let membersCount = GroupsFactory.otherGroups[indexPath.row].numOfMembers
        if membersCount != nil {
            cell.membersCount.text = "\(membersCount!) чел"
        }
        else {
            cell.membersCount.text = ""
            cell.membersCount.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let targetGroup = GroupsFactory.otherGroups[indexPath.row]
        let index = GroupsFactory.allGroupsList.firstIndex(where: {$0.id == targetGroup.id})
        
        if index != nil {
            GroupsFactory.allGroupsList[index!].isMeInGroup = true
            GroupsFactory.updateList()
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
}
