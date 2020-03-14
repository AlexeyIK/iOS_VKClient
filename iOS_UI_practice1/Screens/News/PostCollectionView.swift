//
//  PostCollectionView.swift
//  iOS_UI_practice1
//
//  Created by Alex on 14/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PostCollectionView: UICollectionView {

    var photosSizes : [VKImage]?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }

    // Сбрасываем собственные размеры на правильные, исходя из контента, который нам посчитал MultiphotoCollectionFlow
    override var intrinsicContentSize: CGSize {
        var contentSize = self.contentSize
        // адский костыль, чтобы коллекция не схлопывалась при первом просчете размеров (хрен знает почему она это делает)
        if contentSize.height == 0 {
            contentSize.height = self.bounds.width
        }
        return contentSize
    }

}
