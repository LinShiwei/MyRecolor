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
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentWidth:CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    fileprivate var contentHeight: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.height - (insets.top + insets.bottom)
    }
    
    override func prepare() {
        if cache.isEmpty {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            let rowHeight = contentHeight / CGFloat(numberOfRows)
            
            var row = 0
            var column = 0
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                let xOffset = CGFloat(column) * columnWidth
                let yOffset = CGFloat(row) * rowHeight

                let indexPath = IndexPath(item: item, section: 0)
                
                let frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: rowHeight)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
              
                if column == numberOfColumns - 1 {
                    column = 0
                    row += 1
                }else{
                    column += 1
                }
            }
        }
    }
    override var collectionViewContentSize : CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes  in cache {
            if attributes.frame.intersects(rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
