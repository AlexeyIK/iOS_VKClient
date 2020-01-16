//
//  VKAPIManager.swift
//  iOS_UI_practice1
//
//  Created by Alex on 16/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation
import Alamofire

struct VKGroup: Decodable {
    var id: Int
    var name: String
    var isMember: Int
    var photo: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isMember = "is_admin"
        case photo = "photo_50"
    }
}

struct ResponseData: Decodable {
    var count: Int
    var items: [VKGroup]
}

struct Response: Decodable {
    var response: ResponseData
    
}

class VKApi {
    let vkURL = "https://api.vk.com/method/"
    
    func getFriendList(apiVersion: String, token: String) {
        let requestURL = vkURL + "friends.get"
        let params = ["access_token": token,
                      "order": "name",
                      "count": "3",
                      "fields": "photo_50",
                      "v": apiVersion]
        
        Alamofire.request(requestURL, method: .post, parameters: params).responseJSON(completionHandler: { (response) in
            print("Друзья: \n \(response)")
        })
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
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
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
