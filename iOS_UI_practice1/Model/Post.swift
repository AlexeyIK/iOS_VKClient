//
//  Post.swift
//  iOS_UI_practice1
//
//  Created by Alex on 11.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import Foundation

struct Post {
    let author : User
    var timestamp : String
    var postText : String = ""
    var photos : [String]
    var likes : Int
    var comments : Int
    var views : Int
}
