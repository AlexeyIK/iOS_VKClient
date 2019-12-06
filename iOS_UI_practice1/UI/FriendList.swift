//
//  FriendList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 29.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class FriendList: UITableViewController {
    
    // Список тестовых юзеров
    let testUsersList : [User] = [
        User(firstName: "Василий", familyName: "Комаров", isFriend: false, gender: GenderType.Male),
        User(firstName: "Евгений", familyName: "Григорьев", isFriend: false, gender: GenderType.Male),
        User(firstName: "Ирина", familyName: "Лаврентьева", isFriend: true, gender: GenderType.Female),
        User(firstName: "Анна", familyName: "Кузнецова", isFriend: true, gender: GenderType.Female),
        User(firstName: "Михаил", familyName: "Пирогов", isFriend: true, gender: GenderType.Male),
        User(firstName: "Олег", familyName: "Смирнов", isFriend: true, gender: GenderType.Male),
        User(firstName: "Анонимус", familyName: "Анонимович", isFriend: true),
        User(firstName: "Кара", familyName: "Небесная", isFriend: true),
        User(firstName: "Ольга", familyName: "Ковальчук", isFriend: true, gender: GenderType.Female),
        User(firstName: "Максим", familyName: "Сухой", isFriend: true, gender: GenderType.Male)
    ]

    // Названия секций
    let sectionsCaption = ["Заявки в друзья", "Важные"]
    
    var friendList = [User]()
    var requestList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for nextUser in testUsersList {
            if nextUser.isFriend {
                friendList.append(nextUser)
            }
            else {
                requestList.append(nextUser)
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsCaption[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTemplate", for: indexPath) as? RequestCell else {
                return UITableViewCell()
            }
            let user = requestList[indexPath.row]
            
            cell.userName.text = user.fullName
            cell.num.text = String(requestList.count)
            cell.avatar.image = UIImage(named: user.avatar)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTemplate", for: indexPath) as? FriendCell else {
                return UITableViewCell()
            }
            let user = friendList[indexPath.row]
            
            cell.userName.text = user.fullName
            cell.avatar.image = UIImage(named: user.avatar)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // удалить друга
            friendList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
