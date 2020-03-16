//
//  PostSinglePhotoCell.swift
//  iOS_UI_practice1
//
//  Created by Alex on 12/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PostSinglePhotoCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView! {
        didSet {
            calculateHeight()
        }
    }
    
    var cellHeight : Int = 200
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func calculateHeight() {
        layoutIfNeeded()
    }
}
