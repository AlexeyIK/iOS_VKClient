//
//  PostsViewController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 11.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {

    let usersList = UsersData.getAllUsers()
    
    let postsArray : [Post] = [
        Post(author: User(firstName: "Анна", familyName: "Сорокина"),
                  timestamp: "сегодня в 12:01",
                  postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Feugiat vivamus at augue eget.",
                  photos: [String](),
                  likes: 10,
                  comments: 2,
                  views: 15)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostWithoutPictures")
        
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch postsArray[indexPath.row].photos.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithoutPictures", for: indexPath) as! PostCell
            cell.avatar.image.image = UIImage(named: postsArray[indexPath.row].author.avatarPath)
            cell.username.text = postsArray[indexPath.row].author.fullName
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithoutPictures", for: indexPath) as! PostCell
            cell.avatar.image.image = UIImage(named: postsArray[indexPath.row].author.avatarPath)
            cell.username.text = postsArray[indexPath.row].author.fullName
            
            return cell
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
