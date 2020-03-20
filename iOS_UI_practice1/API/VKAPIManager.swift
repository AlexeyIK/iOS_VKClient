//
//  VKAPIManager.swift
//  iOS_UI_practice1
//
//  Created by Alex on 16/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON
import PromiseKit

class VKApi {
    let vkURL = "https://api.vk.com/method/"
    
    var window: UIWindow?
    
    typealias Out = Swift.Result
    
    // MARK: generic request
    func sendRequest<T: Decodable>(requestURL: String, method: HTTPMethod = .get, params: Parameters) -> Promise<[T]> {
        return Promise<[T]> { resolver in
            AF.request(requestURL, method: method, parameters: params)
                .responseData { result in
                    
                    switch result.result {
                    case let .failure(error):
                        resolver.reject(error)
                    case let .success(data):
                        do {
                            let result = try JSONDecoder().decode(CommonResponse<T>.self, from: data)
                            resolver.fulfill(result.response.items)
                        } catch {
                            resolver.reject(error)
                            KeychainWrapper.standard.removeObject(forKey: "access_token")
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginVC = storyboard.instantiateViewController(withIdentifier: "APILoginScreen")
                            self.window?.rootViewController = loginVC
                            self.window?.makeKeyAndVisible()
                        }
                    }
            }
        }
    }
    
    // MARK: friends list request
    func getFriendList(apiVersion: String, token: String) -> Promise<[VKUser]> {
        let requestURL = vkURL + "friends.get"
        let params = ["access_token": token,
                      "order": "name",
                      "fields": "photo_50, photo_100",
                      "v": apiVersion]
        
        return sendRequest(requestURL: requestURL, method: .post, params: params)
    }
    
    // MARK: groups list request
    func getUsersGroups(apiVersion: String, token: String, userID: Int = Session.shared.userId) -> Promise<[VKGroup]> {
        let requestURL = vkURL + "groups.get"
        let params = ["access_token": token,
                      "user_id": String(userID),
                      "v": apiVersion,
                      "fields": "activity",
                      "extended": "1"] // чтобы узнать больше информации
        
        return sendRequest(requestURL: requestURL, method: .post, params: params)
    }
    
    // MARK: user's photos request
    func getUsersPhotos(apiVersion: String, token: String, userID: Int) -> Promise<[VKPhoto]> {
        let requestURL = vkURL + "photos.get"
        let params = ["access_token": token,
                      "user_id": String(userID),
                      "v": apiVersion,
                      "album_id": "profile",
                      "rev": "1",
                      "owner_id": String(userID),
                      "extended": "1"] // чтобы узнать количество лайков
        
        return sendRequest(requestURL: requestURL, method: .post, params: params)
    }
    
    // MARK: groups search request
    func searchGroups(apiVersion: String, token: String, searchText: String, userID: Int = Session.shared.userId) -> Promise<[VKGroup]> {
        let requestURL = vkURL + "groups.search"
        let params = ["access_token": token,
                      "user_id": String(userID),
                      "v": apiVersion,
                      "fields": "activity",
                      "extended": "1",
                      "q": searchText]
        
        return sendRequest(requestURL: requestURL, method: .post, params: params)
    }
    
    // MARK: newsfeed request
    func getNewsFeed(apiVersion: String,
                     token: String,
                     userID: Int = Session.shared.userId,
                     nextFrom: String?,
                     startFrom: String?,
                     completion: @escaping (Out<([VKPost], String?), Error>) -> Void) {
        
        let requestURL = vkURL + "newsfeed.get"
        let params = ["access_token": token,
                      "user_id": String(userID),
                      "v": apiVersion,
                      "filters": "post,photo",
                      "start_from": nextFrom ?? "",
                      "start_time": startFrom ?? "",
                      "count": "10"]
        
        AF.request(requestURL, method: .post, parameters: params)
            .responseData { result in
                guard let data = result.value else { return }
                
                do {
                    let response = JSON(data)["response"]
                    
                    var postsResult = [VKPost]()
                    var usersResult = [VKUser]()
                    var groupsResult = [VKGroup]()
                    
                    let items = response["items"].arrayValue
                    let profiles = response["profiles"].arrayValue
                    let groups = response["groups"].arrayValue
                    
                    let dispatchGroup = DispatchGroup()
                    
                    DispatchQueue.global().async(group: dispatchGroup) {
                        // парсим профили юзеров
                        profiles.forEach { profileItem in
                            let user = VKUser(id: profileItem["id"].intValue, firstName: profileItem["first_name"].stringValue, lastName: profileItem["last_name"].stringValue, avatarPath: profileItem["photo_100"].stringValue, isOnline: profileItem["online"].intValue)
                            usersResult.append(user)
                        }
                    }
                    
                    DispatchQueue.global().async(group: dispatchGroup) {
                        // парсим группы
                        groups.forEach { groupItem in
                            let group = VKGroup(id: groupItem["id"].intValue, name: groupItem["name"].stringValue, logo: groupItem["photo_100"].stringValue, isMember: groupItem["is_member"].intValue)
                            groupsResult.append(group)
                        }
                    }
                    
                    // начинаем парсить посты только, когда закончим с группами и юзерами
                    dispatchGroup.notify(queue: DispatchQueue.global()) {
                        // парсим посты и сопоставляем группы и юзеров к постам
                        items.forEach { item in
                            if let postType = PostType(rawValue: item["type"].stringValue) {
                                //                            print("post: \n\(item)")

                                if item["copy_history"].array == nil {
                                    let sourceID = item["source_id"].intValue
                                    var bodyText: String? = nil
                                    var postPhotos = [VKPhoto]()
                                    var postAttachments = [VKAttachment]()
                                    var user: VKUser? = nil
                                    var group: VKGroup? = nil
                                    var likes = VKLike(myLike: 0, count: 0)
                                    
                                    if sourceID > 0 {
                                        user = usersResult.first { $0.id == sourceID }
                                    } else {
                                        group = groupsResult.first { $0.id == abs(sourceID) }
                                    }
                                    
                                    switch postType {
                                    case .post:
                                        // парсим аттачменты
                                        let attachments = item["attachments"].arrayValue
                                        bodyText = item["text"].stringValue
                                        
                                        attachments.forEach { (attachment) in
                                            if let attachmentType = AttachmentType(rawValue: attachment["type"].stringValue) {
                                                let attachedData = attachment[attachment["type"].stringValue]
                                                
                                                switch attachmentType {
                                                case .photo:
                                                    let sizesNode = attachedData["sizes"].arrayValue
                                                    var photoSizes = [VKImage]()
                                                    
                                                    sizesNode.forEach { size in
                                                        photoSizes.append(
                                                            VKImage(type: size["type"].stringValue,
                                                                    url: size["url"].stringValue,
                                                                    width: size["width"].intValue,
                                                                    height: size["height"].intValue))
                                                    }
                                                    
                                                    let photoAttachment = VKPhoto(id: attachedData["id"].intValue,
                                                                                  albumID: attachedData["album_id"].intValue,
                                                                                  userID: attachedData["user_id"].intValue,
                                                                                  imageSizes: photoSizes,
                                                                                  text: attachedData["text"].stringValue)
                                                    
                                                    postPhotos.append(photoAttachment)
                                                case .link:
                                                    // ToDo: разобрать ссылки, выводить в каком-то виде
                                                    break
                                                case .audio:
                                                    break
                                                case .video:
                                                    // сначала соберем все превью
                                                    let previewsArray = attachedData["image"].arrayValue
                                                    var photoSizes = [VKImage]()
                                                    
                                                    previewsArray.forEach { size in
                                                        photoSizes.append(
                                                            VKImage(type: size["type"].stringValue,
                                                                    url: size["url"].stringValue,
                                                                    width: size["width"].intValue,
                                                                    height: size["height"].intValue))
                                                    }
                                                    
                                                    // теперь уже можем создать видео
                                                    let video = VKVideo(id: attachedData["id"].intValue,
                                                                        width: attachedData["width"].int ?? 1280,
                                                                        height: attachedData["height"].int ?? 720,
                                                                        duration: attachedData["duration"].intValue,
                                                                        title: attachedData["title"].stringValue,
                                                                        ownerId: attachedData["owner_id"].intValue,
                                                                        userId: attachedData["user_id"].intValue,
                                                                        accessKey: attachedData["access_key"].stringValue,
                                                                        image: photoSizes,
                                                                        firstFrame: [VKImage](),
                                                                        views: attachedData["views"].intValue)
                                                    
                                                    postAttachments.append(
                                                        VKNewsVideo(type: .video,
                                                                    title: attachedData["title"].stringValue,
                                                                    description: attachedData["description"].stringValue,
                                                                    video: video)
                                                    )
                                                }
                                            }
                                        }
                                        
                                        likes = VKLike(myLike: item["likes"]["user_likes"].intValue, count: item["likes"]["count"].intValue)
                                        
                                    case .wall_photo:
                                        let photosNode = item["photos"]
                                        
                                        photosNode["items"].arrayValue.forEach { photoItem in
                                            var photoSizes = [VKImage]()
                                            
                                            photoItem["sizes"].arrayValue.forEach { size in
                                                photoSizes.append(VKImage(type: size["type"].stringValue,
                                                                          url: size["url"].stringValue,
                                                                          width: size["width"].intValue,
                                                                          height: size["height"].intValue))
                                            }
                                            
                                            let newPhoto = VKPhoto(id: photoItem["id"].intValue,
                                                                   albumID: photoItem["album_id"].intValue,
                                                                   userID: photoItem["user_id"].intValue,
                                                                   imageSizes: photoSizes,
                                                                   text: photoItem["text"].stringValue,
                                                                   likes: VKLike(myLike: photoItem["likes"]["user_likes"].intValue, count: photoItem["likes"]["count"].intValue))
                                            
                                            postPhotos.append(newPhoto)
                                        }
                                        
                                        likes = VKLike(myLike: postPhotos[0].likes?.myLike ?? 0, count: postPhotos[0].likes?.count ?? 0)
                                        
                                    case .photo:
                                        // ToDo: разобрать пост с просто фотками, у него другая логика лайков и комментариев и существенно проще структура.
                                        let photosNode = item["photos"]
                                        
                                        photosNode["items"].arrayValue.forEach { photoItem in
                                            var photoSizes = [VKImage]()
                                            
                                            photoItem["sizes"].arrayValue.forEach { size in
                                                photoSizes.append(VKImage(type: size["type"].stringValue,
                                                                          url: size["url"].stringValue,
                                                                          width: size["width"].intValue,
                                                                          height: size["height"].intValue))
                                            }
                                            
                                            let newPhoto = VKPhoto(id: photoItem["id"].intValue,
                                                                   albumID: photoItem["album_id"].intValue,
                                                                   userID: photoItem["user_id"].intValue,
                                                                   imageSizes: photoSizes,
                                                                   text: photoItem["text"].stringValue,
                                                                   likes: VKLike(myLike: photoItem["likes"]["user_likes"].intValue, count: photoItem["likes"]["count"].intValue))
                                            
                                            postPhotos.append(newPhoto)
                                        }
                                        
                                        likes = VKLike(myLike: postPhotos[0].likes?.myLike ?? 0, count: postPhotos[0].likes?.count ?? 0)
                                        
                                    case .photo_tag:
                                        break
                                    case .friend:
                                        break
                                    case .note:
                                        break
                                    case .audio:
                                        break
                                    case .video:
                                        // ToDo: выводить превью от видео
                                        break
                                    }
                                    
                                    let post = VKPost(type: postType,
                                                      postId: item["post_id"].intValue,
                                                      sourceId: sourceID,
                                                      date: Date(timeIntervalSince1970: item["date"].doubleValue),
                                                      text: bodyText,
                                                      photos: postPhotos,
                                                      attachments: postAttachments,
                                                      likes: likes,
                                                      comments: item["comments"]["count"].intValue,
                                                      reposts: item["reposts"]["count"].intValue,
                                                      views: item["views"]["count"].intValue,
                                                      byUser: user,
                                                      byGroup: group)
                                    
                                    postsResult.append(post)
                                }
                            }
                        }
                        
                        let nextFrom = response["next_from"].stringValue
                        
                        DispatchQueue.main.sync {
                            completion(.success((postsResult, nextFrom)))
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
        }
    }
}
