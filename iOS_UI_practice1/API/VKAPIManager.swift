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
    func getFriendList(apiVersion: String, token: String, completion: @escaping (Out<[VKFriend], Error>) -> Void) {
        let requestURL = vkURL + "friends.get"
        let params = ["access_token": token,
                      "order": "name",
//                      "count": "50",
                    "fields": "photo_50, photo_100",
                    "v": apiVersion]
          
        sendRequest(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    func getUsersGroups(apiVersion: String, token: String, userID: String = Session.shared.userId, completion: @escaping (Out<[VKGroup], Error>)  -> Void ) {
        let requestURL = vkURL + "groups.get"
        let params = ["access_token": token,
                      "user_id": userID,
                      "v": apiVersion,
                      "fields": "activity",
//                      "count": "30",
            "extended": "1"] // чтобы узнать больше информации
        
        sendRequest(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    func getUsersPhotos(apiVersion: String, token: String, userID: String, completion: @escaping (Out<[VKPhoto], Error>)  -> Void) {
        let requestURL = vkURL + "photos.get"
        let params = ["access_token": token,
                      "user_id": userID,
                      "v": apiVersion,
                      "album_id": "profile",
//                      "count": "50",
            "rev": "1",
            "owner_id": userID,
            "extended": "1"] // чтобы узнать количество лайков
        
        sendRequest(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    func searchGroups(apiVersion: String, token: String, searchText: String, userID: String = Session.shared.userId, completion: @escaping (Out<[VKGroup], Error>)  -> Void) {
        let requestURL = vkURL + "groups.search"
        let params = ["access_token": token,
                      "user_id": userID,
                      "v": apiVersion,
                      "fields": "activity",
                      "extended": "1",
                      "q": searchText]
        
        sendRequest(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
}
