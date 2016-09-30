//
//  AlbumCollectionViewLayout.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/9.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import AVFoundation
protocol AlbumCollectionViewLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize
}
class AlbumCollectionViewLayout: UICollectionViewFlowLayout {
    
    let numberOfColumns = 2
    let numberOfRows = 2
    var cellPadding: CGFloat = 6.0
    
    fileprivate var delegate : AlbumCollectionViewLayoutDelegate {
        get {
            return collectionView!.delegate as! AlbumCollectionViewLayoutDelegate
        }
    }
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
   
    fileprivate var contentWidth:CGFloat  = 0.0
    fileprivate var contentHeight: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.height - (insets.top + insets.bottom)
    }
    
    override func prepare() {
        scrollDirection = .horizontal
        if cache.isEmpty {
            let insets = collectionView!.contentInset
            let columnWidth = (collectionView!.bounds.width - (insets.left + insets.right)) / CGFloat(numberOfRows)
            let rowHeight = contentHeight / CGFloat(numberOfRows)

            var yOffset = [CGFloat]()
            for row in 0 ..< numberOfRows {
                yOffset.append(CGFloat(row) * rowHeight )
            }
            var row = 0

            var xOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            
                let indexPath = IndexPath(item: item, section: 0)
    
                let rect = CGRect(x: xOffset[row], y: yOffset[row], width: columnWidth, height: rowHeight)
                
                var frame = rect.insetBy(dx: cellPadding, dy: cellPadding)
                if item % 4 < 2{
                    frame.origin.x += 40
                    frame.size.width -= 40
                }else{
                    frame.size.width -= 40
                }
                let imageSize = delegate.collectionView(collectionView!, sizeForPhotoAtIndexPath: indexPath)
                let insetFrame  = AVMakeRect(aspectRatio: imageSize, insideRect: frame)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentWidth = max(contentWidth, rect.maxX)
                xOffset[row] = xOffset[row] + columnWidth
                
                if row >= numberOfRows - 1 {
                    row = 0
                }else{
                    row += 1
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
