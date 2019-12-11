//
//  PostCell.swift
//  iOS_UI_practice1
//
//  Created by Alex on 11.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var avatar: CircleShadowImage!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var postBodyText: UILabel!
    @IBOutlet weak var likes: LikeButtonController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
