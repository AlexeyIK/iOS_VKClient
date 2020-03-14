//
//  PostCollectionView.swift
//  iOS_UI_practice1
//
//  Created by Alex on 14/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PostCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }

    // Сбрасываем собственные размеры на правильные, исходя из контента, который нам посчитал MultiphotoCollectionFlow
    override var intrinsicContentSize: CGSize {
        return contentSize
    }

}
