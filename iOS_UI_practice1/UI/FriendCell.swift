//
//  FriendCell.swift
//  iOS_UI_practice1
//
//  Created by Alex on 29.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class FriendCell : UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var shadowAvatar: CircleShadowImage!
}

class RequestCell : UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var shadowAvatar: CircleShadowImage!
}
