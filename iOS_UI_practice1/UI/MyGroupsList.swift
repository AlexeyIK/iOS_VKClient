//
//  MyGroupsList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 02.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class MyGroupsList: UITableViewController {

    // Тестовые группы для отображения в таблице
    let testGroupsList : [Group] =
    [
        Group(name: "Музыка на каждый день", type: GroupType.Music, membersCount: 10521, isAMember: true, image: UIImage(named: "group_ava_music")!),
        Group(name: "Мемасики", type: GroupType.Humor, membersCount: 152438, isAMember: true, image: UIImage(named: "group_ava_memes")!),
        Group(name: "Все о фотографии", type: GroupType.Photography, membersCount: 2598, isAMember: true, image: UIImage(named: "group_ava_photo")!),
        Group(name: "Фильмотека", type: GroupType.Movies, membersCount: 21103, isAMember: true, image: UIImage(named: "group_ava_movies")!),
        Group(name: "Гифки 2.0", type: GroupType.Humor, membersCount: 13328, isAMember: false)
    ]
    
    var myGroups : [Group] = []
    var otherGroups : [Group] = []
    
    override func loadView() {
        super.loadView()
        
        for group in testGroupsList {
            if group.isMeInGroup {
                myGroups.append(group)
            }
            else {
                otherGroups.append(group)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTemplate", for: indexPath) as! GroupCell
        
        cell.caption.text = myGroups[indexPath.row].groupName
        cell.subTitle.text = myGroups[indexPath.row].groupSubstring
        cell.groupImage.image = myGroups[indexPath.row].image

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        
    }
}
