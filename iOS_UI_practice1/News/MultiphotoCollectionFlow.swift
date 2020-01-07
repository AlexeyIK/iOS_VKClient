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
    
    let maxNumOfRows = 3
    var numOfColumns = 3
    var cellHeight: CGFloat = 100
    var containerHeight: CGFloat = 0
    
    private var totalCellsHeight: CGFloat = 0
    
    override func prepare() {
        self.cacheAttributes = [:]
        
        guard let collectionView = self.collectionView else { return }
        
        let photosCount = collectionView.numberOfItems(inSection: 0)
        guard photosCount > 0 else { return }
        
        if (photosCount <= numOfColumns) {
            cellHeight = collectionView.frame.width
//            cellHeight = collectionView.frame.width / CGFloat(photosCount)
        }
        else if (photosCount > numOfColumns && photosCount <= numOfColumns * 2) {
            cellHeight = collectionView.frame.height / 2
        }
        else if (photosCount > numOfColumns * 2) {
            cellHeight = collectionView.frame.height / 3
        }
        
        var lastX: CGFloat = 0
        var lastY: CGFloat = 0
        let remainValue = photosCount % numOfColumns
        print("remainValue: \(remainValue), photos count: \(photosCount)")
        
        for i in 0..<photosCount {
            var cellWidth: CGFloat = 0
            let indexPath = IndexPath(item: i, section: 0)
            let attributeForIndex = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            if (photosCount - i) >= numOfColumns {
                cellWidth = collectionView.frame.width / CGFloat(numOfColumns)
                attributeForIndex.frame = CGRect(
                    x: lastX,
                    y: lastY,
                    width: cellWidth,
                    height: cellHeight)
                
                if ((i + 1) % (numOfColumns + 1)) == 0 {
                    lastY += cellHeight
                    lastX = 0
                }
                else {
                    lastX += cellWidth
                }
            }
            else {
                cellWidth = collectionView.frame.width / CGFloat(remainValue)
                
                attributeForIndex.frame = CGRect(
                    x: lastX,
                    y: lastY,
                    width: cellWidth,
                    height: cellHeight)
                
                lastX += cellWidth
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
