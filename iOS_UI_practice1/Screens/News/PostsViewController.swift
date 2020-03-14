//
//  PostsViewController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 11.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController, ImageViewPresenterSource {
    
    let postsBottomMargin: CGFloat = 10.0
    let maxHeightOfTextBlock: CGFloat = 200.0
    let postLeftRightPadding: CGFloat = 15.0
    
    let imageSizeKeyForBig = "x"
    let imageSizeKeyForMedium = "q"
    let imageSizeKeyForSmall = "p"
    
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
//        tableView.register(UINib(nibName: "MultiphotoPostTableCell", bundle: nil), forCellReuseIdentifier: "PostTemplate")
        tableView.register(UINib(nibName: "PostHeaderCell", bundle: nil), forCellReuseIdentifier: "PostHeader")
        tableView.register(UINib(nibName: "PostTextCell", bundle: nil), forCellReuseIdentifier: "PostBodyText")
        tableView.register(UINib(nibName: "PostSinglePhotoCell", bundle: nil), forCellReuseIdentifier: "PostPhoto")
        tableView.register(UINib(nibName: "PostMultiPhotoCell", bundle: nil), forCellReuseIdentifier: "PostCollection")
        tableView.register(UINib(nibName: "PostFooterCell", bundle: nil), forCellReuseIdentifier: "PostFooter")
        
        tableView.estimatedRowHeight = 200.0
//        tableView.rowHeight = UITableView.automaticDimension
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
        return postsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return postsArray.count
        // ToDo: if post has photos or videos or links, there is 4 rows, otherwise - 3
        switch postsArray[section].photos.count {
        case 0:
            return 3
        default:
            return 4
        }
    }
    
    // размер отступа между постами
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return postsBottomMargin
    }
    
    // Переопределяем высоту ячеек в зависимости от их роли
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = postsArray[indexPath.section]
        
        switch indexPath.row {
        case 1:
            if let textBlock = post.text, !textBlock.isEmpty {
                let autoSize = UITableView.automaticDimension
                if autoSize > maxHeightOfTextBlock {
                    return maxHeightOfTextBlock
                }
                return autoSize
            } else {
                return 0
            }
        case 2:
            if post.photos.count == 1 {
                if let image = (post.photos.first)?.imageSizes.first(where: { $0.type == imageSizeKeyForBig }) {
                    let aspectRatio = image.aspectRatio ?? 1
                    return (tableView.bounds.width - postLeftRightPadding * 2) * aspectRatio
                } else {
                    return 0
                }
            } else if post.photos.count > 1 {
                return tableView.bounds.width - postLeftRightPadding * 2
            } else {
                return 0
            }
        case 3:
            break
        default:
            break
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = postsArray[indexPath.section]
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeader", for: indexPath) as! PostHeaderCell
            var avatarURL: URL?

            if post.byUser != nil {
                cell.authorName.text = (post.byUser?.firstName ?? "") + " " + (post.byUser?.lastName ?? "")
                avatarURL = URL(string: post.byUser?.avatarPath ?? "")
            }
            else if post.byGroup != nil {
                cell.authorName.text = post.byGroup?.name ?? "-"
                avatarURL = URL(string: post.byGroup?.logo ?? "")
            }
            
            imageLoadQueue.async {
                if avatarURL != nil, let imageData = try? Data(contentsOf: avatarURL!) {
                    DispatchQueue.main.async {
                        cell.postAvatar.image.image = UIImage(data: imageData)
                    }
                }
            }
            
            cell.timestamp.text = DateTimeHelper.getFormattedDate(from: post.date)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostBodyText", for: indexPath) as! PostTextCell
            cell.bodyText.text = post.text
            return cell
        case 2:
            if post.photos.count == 0 {
                break
            }
            else if post.photos.count == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostPhoto", for: indexPath) as! PostSinglePhotoCell
                
                if let photo = (post.photos.first)?.imageSizes.first(where: { $0.type == imageSizeKeyForBig }),
                    let photoUrl = URL(string: photo.url) {
                    cell.photo.kf.setImage(with: photoUrl)
                }
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostCollection", for: indexPath) as! PostMultiPhotoCell
                return cell
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostFooter", for: indexPath) as! PostFooterCell
            cell.likeButton.isLiked = post.likes.myLike == 1 ? true : false
            cell.likeButton.likeCount = post.likes.count
            cell.comments.text = CountsFormatter.ToString(value: post.comments, threshold: 1000, devide: 3, format: "%.1fk")
            cell.reposts.text = CountsFormatter.ToString(value: post.reposts, threshold: 1000, devide: 3, format: "%.1fk")
            cell.views.text = CountsFormatter.ToString(value: post.views, threshold: 1000, devide: 3, format: "%.1fk")
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? PostMultiPhotoCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
    }
}

extension PostsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let post = postsArray[collectionView.tag]
        return postsArray[collectionView.tag].photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postPhotoCell", for: indexPath) as? PostPhotoCell else {
            return PostPhotoCell()
        }
        
        let post = postsArray[collectionView.tag]
        let photosForPost = post.photos
        
        if (photosForPost.count > 1) {
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
                cell.postPhoto.kf.setImage(with: photoUrl)
            }
            else {
                return PostPhotoCell()
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

// MARK: Infinite Scrolling
extension PostsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard !isFetchingMoreNews,
            let maxSection = indexPaths.map({ $0.section }).max(),
            postsArray.count <= maxSection + 2 else { return }
        
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
