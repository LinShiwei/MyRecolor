//
//  ImageCollectionViewCell.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/8.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.redColor()
        
    }
    override func awakeFromNib() {
        configureLayer()

    }
    func configureLayer(){
        layer.borderColor = UIColor.grayColor().CGColor
        layer.borderWidth = 5
        layer.cornerRadius = 10
        layer.masksToBounds = true
//        layer.addSublayer(configureBorderLayer())
    }
    func configureBorderLayer()->CALayer{
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 10, y: 10, width: self.frame.width - 4, height: self.frame.height - 4)
        borderLayer.borderColor = UIColor.redColor().CGColor
        borderLayer.borderWidth = 10
        borderLayer.cornerRadius = 20
//        borderLayer.delegate = self
        return borderLayer
    }
}
