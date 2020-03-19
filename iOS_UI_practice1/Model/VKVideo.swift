//
//  VKVideo.swift
//  iOS_UI_practice1
//
//  Created by Alex on 20/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

struct VKVideo {
    let id: Int
    let width: Int
    let height: Int
    let duration: Int
    let title: String
    let ownerId: Int? // пока не интересует
    let userId: Int? // пока не интересует
    
    var accessKey: String
    var image: [VKImage]
    var firstFrame: [VKImage]
    var views: Int
    
    var aspectRatio: CGFloat? {
        guard width != 0 else { return nil }
        return CGFloat(height) / CGFloat(width)
    }
}
