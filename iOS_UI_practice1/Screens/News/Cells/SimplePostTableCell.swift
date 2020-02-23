//
//  SimplePostTableCell.swift
//  iOS_UI_practice1
//
//  Created by Alex on 23/02/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class SimplePostTableCell: UITableViewCell {
    
    @IBOutlet weak var avatar: CircleShadowImage!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var postBodyText: UILabel!
    @IBOutlet weak var likesCount: LikeButton!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
