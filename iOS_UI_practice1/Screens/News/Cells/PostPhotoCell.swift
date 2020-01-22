//
//  PostPhotoCell.swift
//  iOS_UI_practice1
//
//  Created by Alex on 12/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PostPhotoCell: UICollectionViewCell {
    @IBOutlet weak var postPhoto: UIImageView!

    var imageClicked: ((UIView) -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postPhoto.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickOnImage))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func clickOnImage() {
        imageClicked?(postPhoto)
    }
}
