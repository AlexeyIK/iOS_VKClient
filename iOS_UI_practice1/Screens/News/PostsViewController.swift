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
    
    var isFetchingMoreNews = false
    var nextFrom: String?
    
    var imageLoadQueue = DispatchQueue(label: "ru.geekbrains.images.posts", attributes: .concurrent)
    
    var vkAPI = VKApi()
    var postsArray = [VKPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MultiphotoPostTableCell", bundle: nil), forCellReuseIdentifier: "PostTemplate")
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.prefetchDataSource = self
        
        getNewsFeed()
    }
    
    private func getNewsFeed() {
        isFetchingMoreNews = true
        
        vkAPI.getNewsFeed(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token, nextFrom: nil) { result in
            switch result {
            case .success(let posts, let nextFrom):
                self.postsArray = posts
                self.nextFrom = nextFrom
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            self.isFetchingMoreNews = false
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

        switch post.type {
        case .post:
            if post.attachments is [VKNewsPhoto] {
                cell.collectionView.isHidden = false
            }
        case .wall_photo:
            cell.collectionView.isHidden = false
        case .photo:
            cell.collectionView.isHidden = false
        default:
            cell.collectionView.isHidden = true
        }
        
        cell.likesCount.isLiked = post.likes.myLike == 1 ? true : false
        cell.likesCount.likeCount = post.likes.count
        cell.commentsLabel.text = String(post.comments)
        cell.respostsLabel.text = String(post.reposts)
        cell.viewsLabel.text = String(post.views > 1000 ? post.views / 1000 : post.views)
        
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
        let post = postsArray[collectionView.tag]
        
        switch post.type {
        case .post:
            if post.attachments is [VKNewsPhoto] {
                return post.attachments.count
            }
        case .wall_photo:
            return postsArray[collectionView.tag].photos.count
        default:
            break
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postPhotoCell", for: indexPath) as? PostPhotoCell else {
            return PostPhotoCell()
        }
        
        let post = postsArray[collectionView.tag]
        var photosForPost = [VKPhoto]()
        
        switch post.type {
        case .post:
            if let attachedPhotos = post.attachments as? [VKNewsPhoto] {
                photosForPost = attachedPhotos.map { $0.photo }
            }
        case .wall_photo:
            photosForPost = post.photos
        default:
            return cell
        }
        
        if (photosForPost.count > 0) {
            var photoSize = "x"
            
            if photosForPost.count > 1 && photosForPost.count <= 3 {
                photoSize = "r"
            } else if photosForPost.count > 3 && photosForPost.count <= 6 {
                photoSize = "q"
            } else if photosForPost.count > 6 && photosForPost.count <= 9 {
                photoSize = "p"
            } else if photosForPost.count > 9 {
                photoSize = "m"
            }
        
            if let photo = photosForPost[indexPath.item].imageSizes.first(where: { $0.type == photoSize }),
                let photoUrl = URL(string: photo.url) {
                imageLoadQueue.async {
                    if let imageData = try? Data(contentsOf: photoUrl) {
                        DispatchQueue.main.async {
                            cell.postPhoto.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
        /*
        cell.imageClicked = { image in
            self.imageToShow = cell.postPhoto.image
            self.viewClicked?(image)
        }
        */
        
        return cell
    }
}

extension PostsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard !isFetchingMoreNews,
            let maxRow = indexPaths.map({ $0.row }).max(),
            postsArray.count <= maxRow + 2 else { return }
        
        isFetchingMoreNews = true
        vkAPI.getNewsFeed(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token, nextFrom: nextFrom) { result in
            switch result {
            case .success(let posts, let nextFrom):
                self.postsArray.append(contentsOf: posts)
                self.nextFrom = nextFrom
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            self.isFetchingMoreNews = false
        }
    }
}
