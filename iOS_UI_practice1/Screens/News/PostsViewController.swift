//
//  PostsViewController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 11.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit
import WebKit

protocol PostsView: class {
    func updateTable()
    func softUpdate()
    func registerTableCells()
    func beginPullToRefresh()
    func endPullToRefresh()
    func insertSections(indexSet: IndexSet, animation: UITableView.RowAnimation)
}

// пока не пригодилось
enum PostCellType: Int {
    case header = 0
    case textBlock = 1
    case mediaBlock = 2
    case footer = 3
}

class PostsViewController: UITableViewController, ImageViewPresenterSource {
    
    var source: UIView?
//    var viewClicked: ((UIView)->())? = nil
//    var imageToShow: UIImage?
//    var fullImageURL: String?
    
    // MVP connections
    var presenter: PostsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PostsPresenterImplementation(view: self)
        presenter?.viewDidLoad()
        
        tableView.prefetchDataSource = self
        setupPullToRefresh()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return presenter?.heightForHeaderInSection(section: section) ?? 0.0001
    }
    
    // размер отступа между постами
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return presenter?.heightForFooterInSection(section: section) ?? 0.0001
    }
    
    // Переопределяем высоту ячеек в зависимости от их роли
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.heightForRowAt(indexPath: indexPath) ?? UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeader", for: indexPath) as! PostHeaderCell
            
            if let (authorName, avatarUrl, time) = presenter?.setupHeader(cellForRowAt: indexPath) {
                if avatarUrl != nil {
                    cell.postAvatar.image.kf.setImage(with: avatarUrl)
                }
                cell.authorName.text = authorName
                cell.timestamp.text = DateTimeHelper.getFormattedDate(from: time)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostBodyText", for: indexPath) as! PostTextCell
            cell.showMoreButton.isHidden = true
            cell.showMoreButton.tag = indexPath.section
            if let model = presenter?.setupTextBlock(cellForRowAt: indexPath) {
                cell.bodyText.text = model.text
                if model.hasBigText {
                    cell.showMoreButton.isHidden = false
                    cell.showMoreButton.addTarget(self, action: #selector(showMorePressed), for: .touchUpInside)
                }
            }
            return cell
            
        case 2:
            let mediaType = presenter?.getPostMediaType(cellForRowAt: indexPath)
                
            switch mediaType {
            case .singlePhoto: // к посту прикреплено одно фото
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostPhoto", for: indexPath) as! PostSinglePhotoCell
                if let photo = presenter?.getPostPhotos(cellForRowAt: indexPath).first,
                    let url = URL(string: photo.url) {
                    cell.photo.kf.setImage(with: url)
                }
                return cell
                
            case .singleVideo: // к посту прикреплено одно видео
                if let video = presenter?.getPostVideos(cellForRowAt: indexPath).first {
                    switch video.platform {
                    case "youtube":
                        let youtubeCell = tableView.dequeueReusableCell(withIdentifier: "PostYoutube", for: indexPath) as! PostYouTubeCell
                        if let previewURL = URL(string: video.preview.first?.url ?? "") {
                            youtubeCell.videoframe.kf.setImage(with: previewURL)
                        }
                        presenter?.loadVideo(video: video)
                            .done { result in
                                guard let url = result else { return }
                                let request = URLRequest(url: url)
                                youtubeCell.wk.navigationDelegate = youtubeCell
                                youtubeCell.wk.load(request)
                        }.catch { error in
                            print("Video request error: \(error)")
                        }
                        
                    case "vimeo":
                        break
                    default:
                        let simpleVideoCell = tableView.dequeueReusableCell(withIdentifier: "PostVideo", for: indexPath) as! PostVideoCell
                        if let previewURL = URL(string: video.preview.first?.url ?? "") {
                            simpleVideoCell.videoframe.kf.setImage(with: previewURL)
                        }
                        return simpleVideoCell
                    }
                }
                
            case .collection: // к посту прикреплено несколько видео или фото или всё вместе
                let collectionTVC = tableView.dequeueReusableCell(withIdentifier: "PostCollection", for: indexPath) as! PostMultiPhotoCell
                return collectionTVC
            default:
                break
            }
            
            return UITableViewCell()
            
        case 3:
            let footerCell = tableView.dequeueReusableCell(withIdentifier: "PostFooter", for: indexPath) as! PostFooterCell
            if let (likes, comments, reposts, views) = presenter?.setupFooter(cellForRowAt: indexPath) {
                footerCell.likeButton.isLiked = likes.myLike == 1 ? true : false
                footerCell.likeButton.likeCount = likes.count
                footerCell.comments.text = comments
                footerCell.reposts.text = reposts
                footerCell.views.text = views
            }
            return footerCell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            if let multiPhotoCell = cell as? PostMultiPhotoCell {
                multiPhotoCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
            }
            if let youtubeCell = cell as? PostYouTubeCell {
                youtubeCell.placeholder.alpha = 1.0
                youtubeCell.placeholder.isHidden = false
            }
        default:
            break
        }
    }
    
    private func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Обновляем...")
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(refreshNewsfeed), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func showMorePressed(sender: UIButton) {
        presenter?.showMorePressed(button: sender)
    }
}

// MARK: Collection with photos
extension PostsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numOfItemsInCollection(forTableCell: collectionView.tag) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postPhotoCell", for: indexPath) as? PostPhotoCell else {
            return PostPhotoCell()
        }
        
        if let image = presenter?.getPhotoForCollectionCell(forTableCell: collectionView.tag, cellForItemAt: indexPath),
            let imageUrl = URL(string: image.url) {
                // ставим фотку на загрузку
                cell.postPhoto.kf.setImage(with: imageUrl)
        }
        return cell
    }
}

// MARK: Pull to refresh & Infinite Scrolling
extension PostsViewController: UITableViewDataSourcePrefetching {
    
    @objc private func refreshNewsfeed() {
        refreshControl?.beginRefreshing()
        presenter?.pullToRefresh()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        presenter?.infiniteScrolling(indexPaths: indexPaths)
    }
}

   

extension PostsViewController: PostsView {
    func registerTableCells() {
        tableView.register(UINib(nibName: "PostHeaderCell", bundle: nil), forCellReuseIdentifier: "PostHeader")
        tableView.register(UINib(nibName: "PostTextCell", bundle: nil), forCellReuseIdentifier: "PostBodyText")
        tableView.register(UINib(nibName: "PostSinglePhotoCell", bundle: nil), forCellReuseIdentifier: "PostPhoto")
        tableView.register(UINib(nibName: "PostVideoCell", bundle: nil), forCellReuseIdentifier: "PostVideo")
        tableView.register(UINib(nibName: "PostYouTubeCell", bundle: nil), forCellReuseIdentifier: "PostYoutube")
        tableView.register(UINib(nibName: "PostMultiPhotoCell", bundle: nil), forCellReuseIdentifier: "PostCollection")
        tableView.register(UINib(nibName: "PostFooterCell", bundle: nil), forCellReuseIdentifier: "PostFooter")
    }
    
    func updateTable() {
        tableView.reloadData()
    }
    
    func softUpdate() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func beginPullToRefresh() {
        refreshControl?.beginRefreshing()
    }
    
    func endPullToRefresh() {
        refreshControl?.endRefreshing()
    }
    
    func insertSections(indexSet: IndexSet, animation: UITableView.RowAnimation) {
        tableView.insertSections(indexSet, with: animation)
    }
}
