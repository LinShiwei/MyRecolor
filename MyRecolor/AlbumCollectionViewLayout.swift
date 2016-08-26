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
    func collectionView(collectionView:UICollectionView, sizeForPhotoAtIndexPath indexPath:NSIndexPath) -> CGSize
}
class AlbumCollectionViewLayout: UICollectionViewFlowLayout {
    
    let numberOfColumns = 2
    let numberOfRows = 2
    var cellPadding: CGFloat = 6.0
    
    private var delegate : AlbumCollectionViewLayoutDelegate {
        get {
            return collectionView!.delegate as! AlbumCollectionViewLayoutDelegate
        }
    }
    private var cache = [UICollectionViewLayoutAttributes]()
   
    private var contentWidth:CGFloat  = 0.0
    private var contentHeight: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetHeight(collectionView!.bounds) - (insets.top + insets.bottom)
    }
    
    override func prepareLayout() {
        scrollDirection = .Horizontal
        if cache.isEmpty {
            let insets = collectionView!.contentInset
            let columnWidth = (CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)) / CGFloat(numberOfRows)
            let rowHeight = contentHeight / CGFloat(numberOfRows)

            var yOffset = [CGFloat]()
            for row in 0 ..< numberOfRows {
                yOffset.append(CGFloat(row) * rowHeight )
            }
            var row = 0

            var xOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
            
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
    
                let rect = CGRect(x: xOffset[row], y: yOffset[row], width: columnWidth, height: rowHeight)
                
                var frame = CGRectInset(rect, cellPadding, cellPadding)
                if item % 4 < 2{
                    frame.origin.x += 40
                    frame.size.width -= 40
                }else{
                    frame.size.width -= 40
                }
                let imageSize = delegate.collectionView(collectionView!, sizeForPhotoAtIndexPath: indexPath)
                let insetFrame  = AVMakeRectWithAspectRatioInsideRect(imageSize, frame)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentWidth = max(contentWidth, CGRectGetMaxX(rect))
                xOffset[row] = xOffset[row] + columnWidth
                
                if row >= numberOfRows - 1 {
                    row = 0
                }else{
                    row += 1
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
