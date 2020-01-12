//
//  PostsViewController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 11.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {
    
    let postsArray : [Post] = [
        Post(author: UsersFactory.getAllUsers()[Int.random(in: 0..<UsersFactory.usersList.count)],
             timestamp: DateTimeHelper.getFormattedDate(dateTime: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
             postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Feugiat vivamus at augue eget. ",
             photos: ["photo1"],
             likes: 3,
             comments: 0,
             views: 15),
        
        Post(author: UsersFactory.getAllUsers()[Int.random(in: 0..<UsersFactory.usersList.count)],
             timestamp: DateTimeHelper.getFormattedDate(dateTime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
                  postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Feugiat vivamus at augue eget. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Feugiat vivamus at augue eget. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Feugiat vivamus at augue eget.",
                  photos: ["photo3", "photo2"],
                  likes: 10,
                  comments: 2,
                  views: 15),
        
        Post(author: UsersFactory.getAllUsers()[Int.random(in: 0..<UsersFactory.usersList.count)],
             timestamp: DateTimeHelper.getFormattedDate(dateTime: Calendar.current.date(byAdding: .hour, value: -12, to: Date())!),
             postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Feugiat vivamus at augue eget. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
             photos: [String](),
             likes: 22,
             comments: 4,
             views: 40),
        
        Post(author: UsersFactory.getAllUsers()[Int.random(in: 0..<UsersFactory.usersList.count)],
             timestamp: DateTimeHelper.getFormattedDate(dateTime: Calendar.current.date(byAdding: .hour, value: -1, to: Date())!),
             postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
             photos: ["photo2", "photo5", "photo3", "photo6", "photo4"],
             likes: 14,
             comments: 1,
             views: 26)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostTemplate")
        tableView.register(UINib(nibName: "MultiphotoPostCell", bundle: nil), forCellReuseIdentifier: "PostTemplate")
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
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTemplate", for: indexPath) as! PostCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTemplate", for: indexPath) as! MultiphotoPostCell
        cell.avatar.image.image = UIImage(named: postsArray[indexPath.row].author.avatarPath)
        cell.username.text = postsArray[indexPath.row].author.fullName
        cell.timestamp.text = postsArray[indexPath.row].timestamp
        cell.postBodyText.text = postsArray[indexPath.row].postText
        
        if postsArray[indexPath.row].photos.count == 0 {
            cell.collectionView.isHidden = true
        }
        
        cell.likesCount.likeCount = postsArray[indexPath.row].likes
        cell.commentsLabel.text = String(postsArray[indexPath.row].comments)
        cell.viewsLabel.text = String(postsArray[indexPath.row].likes)
        
        cell.layoutMargins.bottom = 15
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? MultiphotoPostCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
}

extension PostsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray[collectionView.tag].photos.count
//        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postPhotoCell", for: indexPath) as? PostPhotoCell else {
            return PostPhotoCell()
        }
        
        let photosForPost = postsArray[collectionView.tag].photos
        
        if (photosForPost.count > 0) {
            cell.photo.image = UIImage(named: photosForPost[indexPath.item])
        }
        
        return cell
    }
}
