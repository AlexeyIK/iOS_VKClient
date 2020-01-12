//
//  MultiphotoCollectionFlow.swift
//  iOS_UI_practice1
//
//  Created by Alex on 07.01.2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class MultiPhotoCollectionLayout: UICollectionViewLayout {
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    @IBInspectable var cellsMarginX: CGFloat = 2.0
    @IBInspectable var cellsMarginY: CGFloat = 2.0
    var maxNumOfColumns = 3
    var cellHeight: CGFloat = 100
    var containerHeight: CGFloat = 0
    
    private var totalCellsHeight: CGFloat = 0
    
    override func prepare() {
        self.cacheAttributes = [:]
        
        guard let collectionView = self.collectionView else { return }
        
        let photosCount = collectionView.numberOfItems(inSection: 0)
        guard photosCount > 0 else { return }
        
        if (photosCount <= maxNumOfColumns) {
            cellHeight = collectionView.frame.width
        }
        else if (photosCount > maxNumOfColumns && photosCount <= maxNumOfColumns * 2) {
            cellHeight = collectionView.frame.height / 2
        }
        else if (photosCount > maxNumOfColumns * 2) {
            cellHeight = collectionView.frame.height / 3
        }
        
        var lastX: CGFloat = 0
        var lastY: CGFloat = 0
        
        for i in 0..<photosCount {
            var cellWidth: CGFloat = 0
            let indexPath = IndexPath(item: i, section: 0)
            let attributeForIndex = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            if (photosCount - i) >= maxNumOfColumns {
                cellWidth = collectionView.frame.width / CGFloat(maxNumOfColumns)
                attributeForIndex.frame = CGRect(
                    x: lastX,
                    y: lastY,
                    width: cellWidth,
                    height: cellHeight)

                if ((i + 1) % maxNumOfColumns) == 0 {
                    lastY += cellHeight + cellsMarginY
                    lastX = 0
                }
                else {
                    lastX += cellWidth + cellsMarginX
                }
            }
            else {
                cellWidth = collectionView.frame.width / CGFloat((photosCount + 2) % maxNumOfColumns + 1)
                attributeForIndex.frame = CGRect(
                    x: lastX,
                    y: lastY,
                    width: cellWidth,
                    height: cellHeight)
                
                lastX += cellWidth + cellsMarginX
            }
            cacheAttributes[indexPath] = attributeForIndex
        }
        containerHeight = lastY
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
        return CGSize(width: collectionView?.frame.width ?? 0,
                      height: containerHeight)
        
    }
}
