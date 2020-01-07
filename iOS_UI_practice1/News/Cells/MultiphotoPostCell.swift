//
//  MultiphotoPostCell.swift
//  iOS_UI_practice1
//
//  Created by Alex on 25.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class MultiphotoPostCell: UITableViewCell {
    
    @IBOutlet weak var avatar: CircleShadowImage!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var postBodyText: UILabel!
    @IBOutlet weak var photosCollection: UICollectionView!
    @IBOutlet weak var likesCount: LikeButtonController!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    @IBAction func likeOnClick(_ sender: Any) {
        guard let likeButton = (sender as? LikeButtonController) else { return }
        likeButton.Like()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
