//
//  CommonResponse.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 25/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation

struct CommonResponse<T: Decodable>: Decodable {
    var response: ResponseArray<T>
}

struct ResponseArray<T: Decodable>: Decodable {
    var count: Int
    var items: [T]
}

struct ArrayResponse<T: Decodable>: Decodable {
    var response: [T]
}
