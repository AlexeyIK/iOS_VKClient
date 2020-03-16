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
    @IBInspectable var maxNumOfColumns = 3
    var containerHeight: CGFloat = 0
    
    override func prepare() {
        self.cacheAttributes = [:]
        guard let collectionView = self.collectionView as? PostCollectionView else { return }
        let photosCount = collectionView.numberOfItems(inSection: 0)
        guard photosCount > 0 else { return }
        
        // получаем необходимое количество строк при известном максимальном значении колонок
        let numOfRows = ceil(CGFloat(photosCount) / CGFloat(maxNumOfColumns))
        let cellHeight = numOfRows == 1 ? collectionView.frame.width / 1.5 : collectionView.frame.width / numOfRows
        
        var lastX: CGFloat = 0
        var lastY: CGFloat = 0
        
        for i in 0..<photosCount {
            var cellWidth: CGFloat = 0
            let indexPath = IndexPath(item: i, section: 0)
            let attributeForIndex = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // еслим строка еще не последняя, то делим на количество столбцов, если последняя, то на оставшиеся количество фотографий
            if ceil(CGFloat(i + 1) / CGFloat(maxNumOfColumns)) < numOfRows || photosCount % maxNumOfColumns == 0 {
                cellWidth = collectionView.frame.width / CGFloat(maxNumOfColumns)
            }
            else {
                cellWidth = collectionView.frame.width / CGFloat(photosCount % maxNumOfColumns)
            }
            
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
            
            cacheAttributes[indexPath] = attributeForIndex
        }
        containerHeight = lastY == 0 ? cellHeight : lastY
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
