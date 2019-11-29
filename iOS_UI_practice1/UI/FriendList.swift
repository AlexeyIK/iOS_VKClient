//
//  FriendList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 29.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class FriendList: UITableViewController {
    
    // MARK: - Table view data source
    var friendList = ["Василий Комаров", "Ирина Лаврентьева", "Анна Кузнецова", "Михаил Пирогов"]
    var sectionsCaption = ["Заявки в друзья", "Важные"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsCaption[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return friendList.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTemplate", for: indexPath) as! RequestCell
            cell.userName.text = friendList[indexPath.row]
            cell.num.text = "10"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTemplate", for: indexPath) as! FriendCell
            cell.userName.text = friendList[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // удалить
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        let username = friendList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PhotoController") as! PhotoController
        viewController.user = username
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
