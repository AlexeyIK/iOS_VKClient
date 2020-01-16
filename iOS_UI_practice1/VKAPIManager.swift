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
    
    func getFriendList(apiVersion: String, token: String, completion: @escaping ([VKFriend]) -> Void) {
        let requestURL = vkURL + "friends.get"
        let params = ["access_token": token,
                      "order": "name",
                      "count": "20",
                      "fields": "photo_50",
                      "v": apiVersion]
        
        Alamofire.request(requestURL, method: .post, parameters: params)
            .responseData { (result) in
                guard let data = result.value else { return }
                
                do {
                    let result = try JSONDecoder().decode(ResponseFriends.self, from: data)
                    print("Друзья: \n \(result)")
                    completion(result.response.items)
                } catch {
                    print(error)
                }
        }
    }
    
    func getUsersGroups(apiVersion: String, token: String, userID: String = Session.shared.userId) {
        let requestURL = vkURL + "groups.get"
        let params = ["access_token": token,
                      "user_id": userID,
                      "v": apiVersion,
                      "count": "3",
                      "extended": "1"] // чтобы узнать больше информации
        
        Alamofire.request(requestURL, method: .post, parameters: params)
            .responseData(completionHandler: { (response) in
//            print("Группы: \n \(response)")
//                print(String(bytes: response.valыue!, encoding: .utf8))
                
                guard let data = response.value else { return }
//                guard let dataResponse = data["response"] else { return }
                do {
                    let response = try JSONDecoder().decode([ResponseGroups].self,
                                                            from: data )
                    print(response)
                } catch {
                    print(error)
                }
        })
    }
    
    func getUsersPhotos(apiVersion: String, token: String, userID: String = Session.shared.userId) {
        let requestURL = vkURL + "photos.get"
        let params = ["access_token": token,
                      "user_id": userID,
                      "v": apiVersion,
                      "album_id": "wall",
                      "count": "5",
                      "rev": "0",
                      "owner_id": userID,
                      "extended": "1"] // чтобы узнать количество лайков
        
        Alamofire.request(requestURL, method: .post, parameters: params).responseJSON(completionHandler: { (response) in
            print("Фотографии: \n \(response)")
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
