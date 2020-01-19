//
//  GroupsCell.swift
//  iOS_UI_practice1
//
//  Created by Alex on 15.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class GroupsCell: UITableViewCell {

    @IBOutlet weak var imageContainer: CircleShadowImage!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var groupType: UILabel!
    @IBOutlet weak var membersCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
