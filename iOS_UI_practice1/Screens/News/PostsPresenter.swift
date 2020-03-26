//
//  PostsPresenter.swift
//  iOS_UI_practice1
//
//  Created by Alex on 22/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit
import PromiseKit

protocol PostsPresenter {
    init(view: PostsView)
    
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func willDisplayCell(cell: UITableViewCell, indexPath: IndexPath)
    func heightForRowAt(indexPath: IndexPath) -> CGFloat?
    func heightForHeaderInSection(section: Int) -> CGFloat
    func heightForFooterInSection(section: Int) -> CGFloat
    
    func setupHeader(cellForRowAt indexPath: IndexPath) -> (String, URL?, Date)
    func setupTextBlock(cellForRowAt indexPath: IndexPath) -> VKPost
    func setupFooter(cellForRowAt indexPath: IndexPath) -> (VKLike, String, String, String)
    
    func getPostPhotos(cellForRowAt indexPath: IndexPath) -> [VKImage]
    func getPostVideos(cellForRowAt indexPath: IndexPath) -> [VKVideo]
    
    func numOfItemsInCollection(forTableCell tag: Int) -> Int
    func getPhotoForCollectionCell(forTableCell tag: Int, cellForItemAt indexPath: IndexPath) -> VKImage?
    
    func loadVideo(video: VKVideo) -> Promise<URL?>
    
    func getPostMediaType(cellForRowAt indexPath: IndexPath) -> PostMediaType
    
    func pullToRefresh()
    func infiniteScrolling(indexPaths: [IndexPath])
    
    func showMorePressed(button: UIButton)
}

class PostsPresenterImplementation: PostsPresenter {
    
    // constants
    let postsBottomMargin: CGFloat = 8.0
    let maxHeightOfTextBlock: CGFloat = 200.0
    let postLeftRightPadding: CGFloat = 10.0
    
    let showMoreLabel = "Показать полностью"
    let showLessLabel = "Показать меньше"
    
    let imageSizeKeyForBig = "x"
    let imageSizeKeyForMedium = "q"
    let imageSizeKeyForSmall = "p"
    
    // local varibles
    var isFetchingMoreNews = false
    var nextFrom: String?
    
    private var vkAPI: VKApi
//    private var database: PostsSource
    private weak var view: PostsView?
    
    private var postsArray = [VKPost]()
    
    var videoLoadQueue = DispatchQueue(label: "ru.geekbrains.videoload", attributes: .concurrent)
    
    required init(view: PostsView) {
        vkAPI = VKApi()
//        self.database = database
        self.view = view
    }
    
    func viewDidLoad() {
        view?.registerTableCells()
        getNewsFeed()
    }
    
    private func getNewsFeed() {
        isFetchingMoreNews = true
        
        vkAPI.getNewsFeed(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token) { result in
            switch result {
            case let .success(posts, nextFrom):
                self.postsArray = posts
                self.nextFrom = nextFrom
                self.view?.updateTable()
            case .failure(let error):
                print(error)
            }
            self.isFetchingMoreNews = false
        }
    }

    
    func numberOfSections() -> Int {
        return postsArray.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return 4
    }
    
    func willDisplayCell(cell: UITableViewCell, indexPath: IndexPath) {
        
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat? {
        let post = postsArray[indexPath.section]
        let deviceSizes = UIScreen.main.bounds
        
        switch indexPath.row {
        case 1:
            // если в посте есть текст
            if let text = post.text, !text.isEmpty {
                // если расчетный размер текста больше допустимого максимального размера
                if post.textHeight > maxHeightOfTextBlock {
                    if post.showFullText {
                        break
                    } else {
                        return maxHeightOfTextBlock
                    }
                } else {
                    break
                }
            } else {
                return 0
            }
            
        case 2:
            if post.photos.count == 1 { // если одно фото
                if let image = (post.photos.first)?.imageSizes.first(where: { $0.width >= Int(deviceSizes.width) }) {
                    let aspectRatio = image.aspectRatio ?? 1
                    return deviceSizes.width * aspectRatio
                } else {
                    return 0
                }
            } else if post.photos.count > 1 { // если коллекция фоток
                return deviceSizes.width
            } else { // если фоток нет, но есть видео в аттачментах
                if post.attachments.count > 0, let videos = post.attachments as? [VKNewsVideo] {
                    let aspectRatio = videos.first?.video.aspectRatio ?? 0.5625
                    return deviceSizes.width * aspectRatio
                }
                return 0
            }
            
        case 3:
            break
            
        default:
            break
        }
        
        return nil
    }
    
    func heightForHeaderInSection(section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func heightForFooterInSection(section: Int) -> CGFloat {
        return postsBottomMargin
    }
    
    func getPostMediaType(cellForRowAt indexPath: IndexPath) -> PostMediaType {
        return postsArray[indexPath.section].mediaType
    }
    
    func loadVideo(video: VKVideo) -> Promise<URL?> {
        return vkAPI.getVideo(apiVersion: Session.shared.actualAPIVersion,
                              token: Session.shared.token,
                              videoID: video.id,
                              ownerID: video.ownerId,
                              accessKey: video.accessKey)
    }
    
    func setupHeader(cellForRowAt indexPath: IndexPath) -> (String, URL?, Date) {
        let post = postsArray[indexPath.section]
        var authorName = ""
        var avatarURL: URL?

        if post.byUser != nil {
            authorName = (post.byUser?.firstName ?? "") + " " + (post.byUser?.lastName ?? "")
            avatarURL = URL(string: post.byUser?.avatarPath ?? "")
        }
        else if post.byGroup != nil {
            authorName = post.byGroup?.name ?? "-"
            avatarURL = URL(string: post.byGroup?.logo ?? "")
        }
        
        return (authorName, avatarURL, post.date)
    }
    
    func setupTextBlock(cellForRowAt indexPath: IndexPath) -> VKPost {
        let deviceSizes = UIScreen.main.bounds
        let post = postsArray[indexPath.section]
        
        if let text = post.text, !text.isEmpty {
            // вычислим высоту текста
            let textHeight = text.getHeight(constraintedWidth: deviceSizes.width - postLeftRightPadding * 2, font: UIFont(name: "Helvetica Neue", size: 14.0)!)
            postsArray[indexPath.section].textHeight = textHeight
            
            if textHeight > maxHeightOfTextBlock {
                postsArray[indexPath.section].hasBigText = true
            }
        }
        return postsArray[indexPath.section]
    }
    
    func getPostPhotos(cellForRowAt indexPath: IndexPath) -> [VKImage] {
        let post = postsArray[indexPath.section]
        let deviceSize = CurrentDevice.getPixelSizes()
        var postPhotos = [VKImage]()
        
        if post.photos.count > 0 {
            post.photos.forEach { photo in
                var sizedImage = photo.imageSizes.first(where: { $0.width >= Int(deviceSize.width) })
                if sizedImage == nil {
                    sizedImage = photo.imageSizes.max(by: { (s1, s2) -> Bool in
                        s1.resolution < s2.resolution
                    })
                }
                postPhotos.append(sizedImage!)
            }
        }
        
        return postPhotos
    }
    
    func getPostVideos(cellForRowAt indexPath: IndexPath) -> [VKVideo] {
        let post = postsArray[indexPath.section]
        let deviceSize = UIScreen.main.bounds
        var postVideos = [VKVideo]()
        
        if post.attachments.count > 0 {
            post.attachments.forEach { attachment in
                guard var video = (attachment as? VKNewsVideo)?.video else { return }
                
                if let preview = video.preview.first(where: { $0.width >= Int(deviceSize.width) }) {
                    video.preview = [ preview ]
                }
                
                postVideos.append(video)
            }
        }
        
        return postVideos
    }
    
    func setupFooter(cellForRowAt indexPath: IndexPath) -> (VKLike, String, String, String) {
        let post = postsArray[indexPath.section]
        return (post.likes,
                CounterFormatter.toString(value: post.comments, format: "%.1f"),
                CounterFormatter.toString(value: post.reposts, format: "%.1f"),
                CounterFormatter.toString(value: post.views, format: "%.1f"))
    }
    
    func numOfItemsInCollection(forTableCell tag: Int) -> Int {
        return postsArray[tag].photos.count
    }
    
    func getPhotoForCollectionCell(forTableCell tag: Int, cellForItemAt indexPath: IndexPath) -> VKImage? {
        let post = postsArray[tag]
        let photosForPost = post.photos
        
        // позже отдадим этот выбор в класс для лейаута
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
        
            if let photo = photosForPost[indexPath.item].imageSizes.first(where: { $0.type == photoSize }) {
                return VKImage(type: photoSize, url: photo.url, width: photo.width, height: photo.height)
            }
        }
        /*
        cell.imageClicked = { image in
            self.imageToShow = cell.postPhoto.image
            self.viewClicked?(image)
        }
        */
        return nil
    }
    
    // MARK: Pull to refresh
    func pullToRefresh() {
        let lastPost = self.postsArray.first
        let lastNewsDateTime = lastPost != nil ? lastPost!.date.timeIntervalSince1970 : Date().timeIntervalSince1970
        
        vkAPI.getNewsFeed(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token, startFrom: String(lastNewsDateTime + 1)) { result in
            switch result {
            case .success(let newPosts, _):
                if newPosts.count > 0 {
                    self.postsArray = newPosts + self.postsArray
                    let indexSet = IndexSet(integersIn: 0..<newPosts.count)
                    self.view?.insertSections(indexSet: indexSet, animation: .fade)
                }
                self.view?.endPullToRefresh()
            case .failure(let error):
                print(error)
                self.view?.endPullToRefresh()
            }
        }
    }
    
    // MARK: Infinite Scrolling
    func infiniteScrolling(indexPaths: [IndexPath]) {
        guard !isFetchingMoreNews,
            let maxSection = indexPaths.map({ $0.section }).max(),
            postsArray.count <= maxSection + 2 else { return }
        
        isFetchingMoreNews = true
        vkAPI.getNewsFeed(apiVersion: Session.shared.actualAPIVersion, token: Session.shared.token, nextFrom: nextFrom ?? "") { result in
            switch result {
            case .success(let posts, let nextFrom):
                let postsCountBefore = self.postsArray.count
                self.postsArray.append(contentsOf: posts)
                self.nextFrom = nextFrom
                let indexSet = IndexSet(integersIn: postsCountBefore..<self.postsArray.count)
                self.view?.insertSections(indexSet: indexSet, animation: .none)
            case .failure(let error):
                print(error)
            }
            self.isFetchingMoreNews = false
        }
    }
    
    /// обработчик кнопки "показать полностью"
    func showMorePressed(button: UIButton) {
        postsArray[button.tag].showFullText = !postsArray[button.tag].showFullText
        
        if postsArray[button.tag].showFullText {
            button.setTitle(showLessLabel, for: .normal)
        } else {
            button.setTitle(showMoreLabel, for: .normal)
        }
        
        view?.softUpdate()
    }
}
