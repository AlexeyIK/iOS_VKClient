//
//  CustomCollectionUILayout.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 10.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

enum CollectionCustomSize {
    case small
    case wide
}

class CustomCollectionUILayout : UICollectionViewLayout {
    
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    var columns = 2
    var cellHeight = 150
    var containerHeight : CGFloat = 0
    
    override func prepare() {
        guard let collection = collectionView else {
            return
        }
        
        let itemsCount = collection.numberOfItems(inSection: 0)
        let commonWidth = collection.frame.width
        let smallWidth = collection.frame.width / CGFloat(columns)
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for element in 0..<itemsCount {
            let indexPath = IndexPath(item: element, section: 0)
            let attributeForIndex = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let wideType : CollectionCustomSize = (element + 1) % (columns + 1) == 0 ? .wide : .small
            
            switch wideType {
            case .wide:
                attributeForIndex.frame = CGRect(x: x,
                                                 y: y,
                                                 width: commonWidth,
                                                 height: CGFloat(cellHeight))
                y += CGFloat(cellHeight)
                break;
            case .small:
                attributeForIndex.frame = CGRect(x: x,
                                                 y: y,
                                                 width: smallWidth,
                                                 height: CGFloat(cellHeight))
                if (element + 1) % (columns + 1) == 0 {
                    y += CGFloat(cellHeight)
                    x = CGFloat(0)
                }
                else {
                    x += smallWidth
                }
                break;
            }
            
            cacheAttributes[indexPath] = attributeForIndex
        }
        
        containerHeight = y
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter {
            rect.intersects($0.frame)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.width, height: containerHeight)
    }
}
