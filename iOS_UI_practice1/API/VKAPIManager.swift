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

class VKApi {
    let vkURL = "https://api.vk.com/method/"
    
    var window: UIWindow?
    
    typealias Out = Swift.Result
    
    func sendRequest<T: Decodable>(requestURL: String, method: HTTPMethod = .get, params: Parameters, completion: @escaping (Out<[T], Error>) -> Void) {
        Alamofire.request(requestURL, method: method, parameters: params)
            .responseData { (result) in
                guard let data = result.value else { return }
                
                do {
                    let result = try JSONDecoder().decode(CommonResponse<T>.self, from: data)
                    completion(.success(result.response.items))
                } catch {
                    completion(.failure(error))
                    KeychainWrapper.standard.removeObject(forKey: "access_token")
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "APILoginScreen")
                    self.window?.rootViewController = loginVC
                    self.window?.makeKeyAndVisible()
                }
        }
    }
    
    // ToDo: переписать на Result-функции
    func getFriendList(apiVersion: String, token: String, completion: @escaping (Out<[VKUser], Error>) -> Void) {
        let requestURL = vkURL + "friends.get"
        let params = ["access_token": token,
                      "order": "name",
                      "fields": "photo_50, photo_100",
                      "v": apiVersion]
          
        sendRequest(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    func getUsersGroups(apiVersion: String, token: String, userID: Int = Session.shared.userId, completion: @escaping (Out<[VKGroup], Error>)  -> Void ) {
        let requestURL = vkURL + "groups.get"
        let params = ["access_token": token,
                      "user_id": String(userID),
                      "v": apiVersion,
                      "fields": "activity",
                      "extended": "1"] // чтобы узнать больше информации
        
        sendRequest(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    // MARK: user's photos request
    func getUsersPhotos(apiVersion: String, token: String, userID: Int, completion: @escaping (Out<[VKPhoto], Error>)  -> Void) {
        let requestURL = vkURL + "photos.get"
        let params = ["access_token": token,
                      "user_id": String(userID),
                      "v": apiVersion,
                      "album_id": "profile",
                      "rev": "1",
                      "owner_id": String(userID),
                      "extended": "1"] // чтобы узнать количество лайков
        
        sendRequest(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    // MARK: groups search request
    func searchGroups(apiVersion: String, token: String, searchText: String, userID: Int = Session.shared.userId, completion: @escaping (Out<[VKGroup], Error>)  -> Void) {
        let requestURL = vkURL + "groups.search"
        let params = ["access_token": token,
                      "user_id": String(userID),
                      "v": apiVersion,
                      "fields": "activity",
                      "extended": "1",
                      "q": searchText]
        
        sendRequest(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    // MARK: newsfeed request
    func getNewsFeed(apiVersion: String, token: String, userID: Int = Session.shared.userId, completion: @escaping (Out<[VKPost], Error>) -> Void) {
        let requestURL = vkURL + "newsfeed.get"
        let params = ["access_token": token,
                      "user_id": String(userID),
                      "v": apiVersion,
                      "filters": "post,photo,wall_photo",
                      "count": "30"]
        
        Alamofire.request(requestURL, method: .post, parameters: params)
            .responseData { (result) in
                guard let data = result.value else { return }
                
                do {
                    let response = JSON(data)["response"]
                    var postsResult = [VKPost]()
                    var usersResult = [VKUser]()
                    var groupsResult = [VKGroup]()
                    
                    let items = response["items"].arrayValue
                    let profiles = response["profiles"].arrayValue
                    let groups = response["groups"].arrayValue
                    
                    // парсим профили юзеров
                    profiles.forEach { profileItem in
                        print("profile: \(profileItem)")
                        
                        let user = VKUser(id: profileItem["id"].intValue, firstName: profileItem["first_name"].stringValue, lastName: profileItem["last_name"].stringValue, avatarPath: profileItem["photo_100"].stringValue, isOnline: profileItem["online"].intValue)
                        usersResult.append(user)
                    }
                    
                    // парсим группы
                    groups.forEach { groupItem in
                        print("group: \(groupItem)")
                        
                        let group = VKGroup(id: groupItem["id"].intValue, name: groupItem["name"].stringValue, logo: groupItem["photo_100"].stringValue, isMember: groupItem["is_member"].intValue)
                        groupsResult.append(group)
                    }
                    
                    // парсим посты и сопоставляем группы и юзеров к постам
                    items.forEach { item in
                        if let postType = PostType(rawValue: item["type"].stringValue) {
                            let sourceID = item["source_id"].intValue
                            var bodyText: String? = nil
                            var postPhotos = [VKPhoto]()
                            var postAttachments = [VKAttachment]()
                            var user: VKUser? = nil
                            var group: VKGroup? = nil
                            
                            if sourceID > 0 {
                                user = usersResult.first { $0.id == sourceID }
                            } else {
                                group = groupsResult.first { $0.id == abs(sourceID) }
                            }
                            
                            switch postType {
                            case .post:
                                // Attachments parser
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
                                            
                                            let newAttachment = VKNewsPhoto(type: attachmentType,
                                                                       id: attachedData["id"].intValue,
                                                                       albumID: attachedData["album_id"].intValue,
                                                                       userID: attachedData["user_id"].intValue,
                                                                       imageSizes: photoSizes,
                                                                       text: attachedData["text"].stringValue)
                                            
                                            postAttachments.append(newAttachment)
                                        case .link:
                                            break
                                        case .audio:
                                            break
                                        case .video:
                                            break
                                        }
                                    }
                                }
                            case .wall_photo:
                                let photosNode = item["photos"]
                                let photosCount = photosNode["count"].intValue
                                let photoItems = photosNode["items"].arrayValue
                                
                                photoItems.forEach { photoItem in
                                    let sizesNode = photoItem["sizes"].arrayValue
                                    var photoSizes = [VKImage]()
                                    
                                    sizesNode.forEach { size in
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
                                
                            case .photo:
                                // ToDo: разобрать пост с просто фотками, у него другая логика лайков и комментариев и существенно проще структура. Также понадобится создать новый xib
                                break
                            case .photo_tag:
                                break
                            case .friend:
                                break
                            case .note:
                                break
                            case .audio:
                                break
                            case .video:
                                break
                            }
                            
                            let post = VKPost(type: postType,
                                              postId: item["post_id"].intValue,
                                              sourceId: sourceID,
                                              date: Date(timeIntervalSince1970: item["date"].doubleValue),
                                              text: bodyText,
                                              photos: postPhotos,
                                              attachments: postAttachments,
                                              likes: VKLike(myLike: item["likes"]["user_likes"].intValue, count: item["likes"]["count"].intValue),
                                              comments: item["comments"]["count"].intValue,
                                              reposts: item["reposts"]["count"].intValue,
                                              views: item["views"]["count"].intValue,
                                              byUser: user,
                                              byGroup: group)
                            
                            postsResult.append(post)
                        }
                    }
                    
//                    print("NewsFeed: \(response)")
                    completion(.success(postsResult))
                } catch {
                    completion(.failure(error))
                }
        }
    }
}
