//
//  PostsViewController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 11.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController, ImageViewPresenterSource {
    
    let postsBottomMargin: CGFloat = 15.0
    var source: UIView?
    var viewClicked: ((UIView)->())? = nil
    var imageToShow: UIImage?
    var fullImageURL: String?
    
    var imageLoadQueue = DispatchQueue(label: "ru.geekbrains.images.posts", attributes: .concurrent)
    
    var vkAPI = VKApi()
    var postsArray = [VKPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MultiphotoPostTableCell", bundle: nil), forCellReuseIdentifier: "PostTemplate")
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableView.automaticDimension
        
        getNewsFeed()
    }
    
    private func getNewsFeed() {
        vkAPI.getNewsFeed(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token) { result in
            switch result {
            case .success(let posts):
                self.postsArray = posts
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTemplate", for: indexPath) as! MultiphotoPostTableCell
        
        let post = postsArray[indexPath.row]
        var imageUrl: URL?
        
        if post.byUser != nil {
            cell.authorName.text = (post.byUser?.firstName ?? "") + " " + (post.byUser?.lastName ?? "")
            imageUrl = URL(string: post.byUser?.avatarPath ?? "")
        }
        else if post.byGroup != nil {
            cell.authorName.text = post.byGroup?.name ?? "-"
            imageUrl = URL(string: post.byGroup?.logo ?? "")
        }
        
        if imageUrl != nil {
            imageLoadQueue.async {
                if let imageData = try? Data(contentsOf: imageUrl!) {
                    DispatchQueue.main.async {
                        cell.avatar.image.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        cell.timestamp.text = DateTimeHelper.getFormattedDate(from: post.date)
        cell.postBodyText.text = post.text
        
        if postsArray[indexPath.row].photos.count == 0 {
            cell.collectionView.isHidden = true
        }
        
        cell.likesCount.isLiked = post.likes.myLike == 1 ? true : false
        cell.likesCount.likeCount = post.likes.count
        cell.commentsLabel.text = String(post.comments)
        cell.viewsLabel.text = String(post.views)
        
        viewClicked = { view in
            self.source = view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let fullScreenVC = storyboard.instantiateViewController(withIdentifier: "FullScreenPopup") as! FullScreenPhoto
            fullScreenVC.imageToShow = self.imageToShow
            fullScreenVC.imageURL = self.fullImageURL
            let delegate = ImageViewerPresenter(delegate: self)
            self.navigationController?.delegate = delegate
            self.navigationController?.pushViewController(fullScreenVC, animated: true)
        }
        
        cell.layoutMargins.bottom = postsBottomMargin
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? MultiphotoPostTableCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
}

extension PostsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray[collectionView.tag].photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postPhotoCell", for: indexPath) as? PostPhotoCell else {
            return PostPhotoCell()
        }
        
        let photosForPost = postsArray[collectionView.tag].photos
        if (photosForPost.count > 0) {
//            cell.postPhoto.image = UIImage(named: photosForPost[indexPath.item])
        }
        
        cell.imageClicked = { image in
            self.imageToShow = cell.postPhoto.image
            self.viewClicked?(image)
        }
        
        return cell
    }
}
