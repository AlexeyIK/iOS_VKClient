//
//  PostFooter.swift
//  iOS_UI_practice1
//
//  Created by Alex on 12/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PostFooterCell: UITableViewCell {

    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var reposts: UILabel!
    @IBOutlet weak var views: UILabel!
    
    @IBAction func likeOnClick(_ sender: Any) {
        guard let likeButton = (sender as? LikeButton) else { return }
        likeButton.Like()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
