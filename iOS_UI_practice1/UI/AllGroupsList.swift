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
        
        GroupsData.updateList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return GroupsData.otherGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTemplate", for: indexPath) as! GroupCell
        
        cell.caption.text = GroupsData.otherGroups[indexPath.row].groupName
        cell.subTitle.text = GroupsData.otherGroups[indexPath.row].groupSubstring
        cell.groupImage.image = UIImage(named: GroupsData.otherGroups[indexPath.row].imagePath!)
        
        let membersCount = GroupsData.otherGroups[indexPath.row].numOfMembers
        if membersCount != nil {
            cell.numOfMembers.text = "\(membersCount!) чел"
        }
        else {
            cell.numOfMembers.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var targetGroup = GroupsData.otherGroups[indexPath.row]
        let index = GroupsData.getGroups().firstIndex(where: {$0.id == targetGroup.id})
        if index != nil {
//            GroupsData.getGroups()[index!].isMeInGroup = true
            targetGroup.isMeInGroup = true
            GroupsData.updateList()
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
