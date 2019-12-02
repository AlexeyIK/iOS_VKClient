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
    let testUsersList = ["Василий Комаров": false, "Евгений Григорьев": false, "Ирина Лаврентьева": true, "Анна Кузнецова": true, "Михаил Пирогов": true, "Олег Смирнов" : true]
    let sectionsCaption = ["Заявки в друзья", "Важные"]
    
    var friendList = [User]()
    var requestList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for user in testUsersList {
            let name = String(user.key.split(separator: " ")[0])
            let family = String(user.key.split(separator: " ")[1])
            
            if user.value {
                friendList.append(User(firstName: name, familyName: family))
            }
            else {
                requestList.append(User(firstName: name, familyName: family, isFriend: user.value))
            }
        }
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
            cell.userName.text = requestList[indexPath.row].fullName
            cell.num.text = String(requestList.count)
            // Как-то надо подцеплять картинку для аватара
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTemplate", for: indexPath) as! FriendCell
            cell.userName.text = friendList[indexPath.row].fullName
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
        
        let username = friendList[indexPath.row].fullName
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PhotoController") as! PhotoController
        viewController.user = username
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
