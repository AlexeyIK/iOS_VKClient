//
//  MultiphotoPostTableCell.swift
//  iOS_UI_practice1
//
//  Created by Alex on 25.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class MultiphotoPostTableCell: UITableViewCell {
    
    @IBOutlet weak var avatar: CircleShadowImage!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var postBodyText: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var likesCount: LikeButton!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var respostsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    var viewClicked: ((UIView)->())? = nil
    
    @IBAction func likeOnClick(_ sender: Any) {
        guard let likeButton = (sender as? LikeButton) else { return }
        likeButton.Like()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow postNum: Int) {
        collectionView.register(UINib(nibName: "PostPhotoCell", bundle: nil), forCellWithReuseIdentifier: "postPhotoCell")
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = postNum
        collectionView.reloadData()
    }
}
