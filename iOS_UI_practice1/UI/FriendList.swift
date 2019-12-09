//
//  FriendList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 29.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

struct Section<T> {
    var title: String
    var items: [T]
}

class FriendList: UITableViewController {
    
    // Список тестовых юзеров
    let testUsersList = [
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
    
    var friendsSection = [Section<User>]()
    
    var friendList = [User]()
    var requestList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let friendsDictionary = Dictionary.init(grouping: testUsersList) {
            $0.firstName!.prefix(1)
        }
        
        friendsSection = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendsSection.sort(by: { $0.title < $1.title })
        
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
        return friendsSection.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Заявки в друзья"
        default:
            return String(friendsSection[section - 1].title.prefix(1))
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsSection.map( {$0.title} )
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return friendsSection[section - 1].items.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTemplate", for: indexPath) as? RequestCell else {
                return UITableViewCell()
            }
            let user = requestList[indexPath.section]
            
            cell.userName.text = user.fullName
            cell.num.text = String(requestList.count)
            cell.shadowAvatar.image.image = UIImage(named: user.avatarPath)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTemplate", for: indexPath) as? FriendCell else {
                return UITableViewCell()
            }
            let user = friendsSection[indexPath.section - 1].items[indexPath.row]
            
            cell.userName.text = user.fullName
            cell.shadowAvatar.image.image = UIImage(named: user.avatarPath)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (indexPath.section != 0) {
            if editingStyle == .delete {
                // удалить друга, если он в списке друзей, а не заявок
                friendsSection[indexPath.section - 1].items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
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
