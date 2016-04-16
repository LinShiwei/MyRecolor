//
//  PaintingImageView.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/14.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class PaintingImageView: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureLayer()
//        configureBorderLayer()
    }
    private func configureLayer(){
        layer.borderColor = UIColor.grayColor().CGColor
        layer.borderWidth = 10
//        layer.cornerRadius = 20
    }
    func configureBorderLayer(){
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        borderLayer.borderColor = UIColor.redColor().CGColor
        borderLayer.borderWidth = 10
        layer.addSublayer(borderLayer)
    }
}
