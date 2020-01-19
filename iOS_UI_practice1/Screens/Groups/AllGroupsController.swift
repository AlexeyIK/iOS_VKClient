//
//  AllGroupsList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 03.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class AllGroupsController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var groupsToShow = [Group]()
    
    override func loadView() {
        super.loadView()
        GroupsFactory.updateList()
        groupsToShow = GroupsFactory.otherGroups
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.register(UINib(nibName: "GroupsCell", bundle: nil), forCellReuseIdentifier: "GroupsTemplate")
        tableView.estimatedRowHeight = 75
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Functions
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
extension AllGroupsController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInGroups(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func searchInGroups(searchText: String) {
        groupsToShow = GroupsFactory.otherGroups.filter( { (group) in
            searchText.count > 0 ? group.groupName!.lowercased().contains(searchText.lowercased()) : true
        })
        
        tableView.reloadData()
    }
}

// MARK: - Table and cell settings
extension AllGroupsController {
    
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
        let membersCount = groupsToShow[indexPath.row].numOfMembers
        if membersCount != nil {
            cell.membersCount.text = "\(membersCount!) чел"
        }
        else {
            cell.membersCount.text = ""
            cell.membersCount.isHidden = true
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.imageContainer.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetGroup = groupsToShow[indexPath.row]
        let index = GroupsFactory.allGroupsList.firstIndex(where: {$0.id == targetGroup.id})
        
        if index != nil {
            GroupsFactory.allGroupsList[index!].isMeInGroup = true
            GroupsFactory.updateList()
            groupsToShow = GroupsFactory.otherGroups
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}
