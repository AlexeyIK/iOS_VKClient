//
//  PostTextCell.swift
//  iOS_UI_practice1
//
//  Created by Alex on 12/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PostTextCell: UITableViewCell {
    
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
