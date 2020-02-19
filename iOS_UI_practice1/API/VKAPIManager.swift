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
                
                // TODO проверку на невалидный токен
                // Удалить из Keychain
                // Изменить стартовый вьюконтроллер и перейти на LoginWKViewController
                
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
    func getFriendList(apiVersion: String, token: String, completion: @escaping (Out<[VKFriend], Error>) -> Void) {
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
    
    func fetchNews(apiVersion: String, token: String, userID: Int = Session.shared.userId) {
        let requestURL = vkURL + "newsfood.get"
        
        let params: Parameters = [
            "access_token": token,
            "user_id": String(userID),
            "v": apiVersion,
            "filters": "post",
            "return_banned": 0,
            "count": 50,
            "fields": "nickname, photo_50"
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: params).responseJSON { (response) in
            switch (response.result) {
            case let .success(value):
                let json = JSON(value)
                print(json)
            case let .failure(error):
                print(error)
            }
        }
    }
}
