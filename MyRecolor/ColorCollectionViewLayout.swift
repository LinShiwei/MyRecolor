//
//  ColorCollectionViewLayout.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/10.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class ColorCollectionViewLayout: UICollectionViewLayout {
    let numberOfColumns = colorCollectionColumns
    let numberOfRows = colorCollectionRows
    var cellPadding = colorCellPadding
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentWidth:CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    private var contentHeight: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetHeight(collectionView!.bounds) - (insets.top + insets.bottom)
    }
    
    override func prepareLayout() {
        if cache.isEmpty {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            let rowHeight = contentHeight / CGFloat(numberOfRows)
            
            var row = 0
            var column = 0
            
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                let xOffset = CGFloat(column) * columnWidth
                let yOffset = CGFloat(row) * rowHeight

                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                let frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: rowHeight)
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
              
                if column == numberOfColumns - 1 {
                    column = 0
                    row++
                }else{
                    column++
                }
            }
        }
    }
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes  in cache {
            if CGRectIntersectsRect(attributes.frame, rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
