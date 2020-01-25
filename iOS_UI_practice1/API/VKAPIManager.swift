//
//  VKAPIManager.swift
//  iOS_UI_practice1
//
//  Created by Alex on 16/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation
import Alamofire

class VKApi {
    let vkURL = "https://api.vk.com/method/"
    
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
                }
        }
    }
    
    // ToDo: переписать на Result-функции
    func getFriendList(apiVersion: String, token: String, completion: @escaping ([VKFriend]) -> Void) {
        let requestURL = vkURL + "friends.get"
        let params = ["access_token": token,
                      "order": "name",
                      //                      "count": "50",
                    "fields": "photo_50, photo_100",
                    "v": apiVersion]
          
        Alamofire.request(requestURL, method: .post, parameters: params)
            .responseData { (result) in
                guard let data = result.value else { return }
                
                do {
                    let result = try JSONDecoder().decode(ResponseFriends.self, from: data)
                    //                    print("Друзья: \n \(result)")
                    completion(result.response.items)
                } catch {
                    print(error)
                }
        }
    }
    
    func getUsersGroups(apiVersion: String, token: String, userID: String = Session.shared.userId, completion: @escaping ([VKGroup]) -> Void ) {
        let requestURL = vkURL + "groups.get"
        let params = ["access_token": token,
                      "user_id": userID,
                      "v": apiVersion,
                      "fields": "activity",
                      //                      "count": "30",
            "extended": "1"] // чтобы узнать больше информации
        
        Alamofire.request(requestURL, method: .post, parameters: params)
            .responseData(completionHandler: { (result) in
                guard let data = result.value else { return }
                
                do {
                    let result = try JSONDecoder().decode(ResponseGroups.self, from: data )
                    print("Мои группы: \n\(result.response)")
                    completion(result.response.items)
                } catch {
                    print(error)
                }
            })
    }
    
    //    typealias Completion = (Result<VKPhoto, Error>) -> Void
    
    func getUsersPhotos(apiVersion: String, token: String, userID: String, when completed: @escaping ([VKPhoto]) -> Void) {
        let requestURL = vkURL + "photos.get"
        let params = ["access_token": token,
                      "user_id": userID,
                      "v": apiVersion,
                      "album_id": "profile",
                      //                      "count": "50",
            "rev": "1",
            "owner_id": userID,
            "extended": "1"] // чтобы узнать количество лайков
        
        Alamofire.request(requestURL, method: .post, parameters: params)
            .responseData(completionHandler: { (result) in
                //            print("Фотографии: \n \(response)")
                guard let data = result.value else { return }
                
                do {
                    let result = try JSONDecoder().decode(ResponsePhotos.self, from: data)
                    completed(result.response.items)
                } catch {
                    print(error)
                }
            })
    }
    
    func findGroupBySearch(apiVersion: String, token: String, searchText: String, userID: String = Session.shared.userId) {
        let requestURL = vkURL + "groups.search"
        let params = ["access_token": token,
                      "user_id": userID,
                      "v": apiVersion,
                      "q": searchText,
                      "count": "5"]
        
        Alamofire.request(requestURL, method: .post, parameters: params).responseJSON(completionHandler: { (response) in
            print("Поиск по группам, по сочетанию \"\(searchText)\": \n \(response)")
        })
    }
}
