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
             photos: [String](),
             likes: 3,
             comments: 0,
             views: 15),
        
        Post(author: UsersFactory.getAllUsers()[Int.random(in: 0..<UsersFactory.usersList.count)],
             timestamp: DateTimeHelper.getFormattedDate(dateTime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
                  postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Feugiat vivamus at augue eget. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Feugiat vivamus at augue eget. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Feugiat vivamus at augue eget.",
                  photos: ["photo2"],
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
             photos: [String](),
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
        
//        let postPhoto = postsArray[indexPath.row].photos.count > 0 ? postsArray[indexPath.row].photos[0] : nil
//        if postPhoto != nil {
//            cell.picture.image = UIImage(named: postPhoto!)
//        }
//        else {
//            cell.picture.isHidden = true
//        }
        if postsArray[indexPath.row].photos.count > 0 {
//            cell.photosCollection.insertItems(at: ) = postsArray[indexPath.row].photos
            cell.photosCollection.dataSource = postsArray[indexPath.row].photos as? UICollectionViewDataSource
        }
        else {
            cell.photosCollection.isHidden = true
        }
        
        cell.likesCount.likeCount = postsArray[indexPath.row].likes
        cell.commentsLabel.text = String(postsArray[indexPath.row].comments)
        cell.viewsLabel.text = String(postsArray[indexPath.row].likes)
        
        cell.layoutMargins.bottom = 15
        return cell
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

class MultiPhotoCollectionLayout: UICollectionViewLayout {
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    let maxNumOfRows = 3
    var numOfColumns = 3
    var cellHeight: CGFloat = 100
    
    private var totalCellsHeight: CGFloat = 0
    
    override func prepare() {
        self.cacheAttributes = [:]
        
        guard let collectionView = self.collectionView else { return }
        
        let photosCount = collectionView.numberOfItems(inSection: 0)
        guard photosCount > 0 else { return }
        
        if (photosCount <= numOfColumns) {
            cellHeight = collectionView.frame.height
        }
        else if (photosCount > numOfColumns && photosCount <= numOfColumns * 2) {
            cellHeight = collectionView.frame.height / 2
        }
        else if (photosCount > numOfColumns * 2) {
            cellHeight = collectionView.frame.height / 3
        }
        
        print("Остаток от деления: \(photosCount % numOfColumns)")
        
//        numOfRows = Float(photosCount / numOfColumns).rounded(_:)
        var lastX: CGFloat = 0
        var lastY: CGFloat = 0
        
        for i in 0..<photosCount {
            var cellWidth: CGFloat = 0
            let indexPath = IndexPath(item: i, section: 0)
            let attributeForIndex = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let remainValue = photosCount % numOfColumns
            
            if (photosCount - i) >= numOfColumns {
                cellWidth = collectionView.frame.width / CGFloat(numOfColumns)
                attributeForIndex.frame = CGRect(
                    x: lastX,
                    y: lastY,
                    width: cellWidth,
                    height: cellHeight)
                
                if ((i + 1) % (numOfColumns + 1)) == 0 {
                    lastY += cellHeight
                    lastX = 0
                }
                else {
                   lastX += cellWidth
                }
            }
            else {
                cellWidth = collectionView.frame.width / CGFloat(remainValue)
                
                attributeForIndex.frame = CGRect(
                    x: lastX,
                    y: lastY,
                    width: cellWidth,
                    height: cellHeight)
                
                lastX += cellWidth
            }
            
            cacheAttributes[indexPath] = attributeForIndex
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter {
            rect.intersects($0.frame)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.width, height: collectionView!.frame.height)
    }
}
