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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var likesCount: LikeButtonController!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
//    var photoCollection : [String] = ["photo1", "photo2"]
    
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
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        
        collectionView.register(PostPhotoCell.self, forCellWithReuseIdentifier: "postPhotoCell")
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell
        else {
            return UICollectionViewCell()
        }
        
//        photos.performBatchUpdates({
//            let collectionIndexPath = IndexPath(item: 0, section: 0)
//            photos.dataSource =
//            photos.insertItems(at: [collectionIndexPath])
//
//        }, completion: nil)
        
        cell.photo.image = UIImage(named: "photo2")
        
        return cell
    }*/
}

class PostPhotoCell: UICollectionViewCell {
    let photo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.black
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        photo.frame = self.frame
        let boundsOffset = CGPoint(x: -frame.width/2, y: -frame.height/2)
        photo.bounds = CGRect(origin: boundsOffset, size: CGSize(width: frame.width, height: frame.height))
        photo.contentMode = .scaleAspectFill
        addSubview(photo)
    }
}
