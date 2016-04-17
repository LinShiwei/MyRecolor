//
//  PaletteViewHeadButton.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/15.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class PaletteViewHeadButton: UIButton {
    var currentColor = UIColor.whiteColor(){
        didSet{
            backgroundColor = currentColor
            var white : CGFloat = 0
            var alpha : CGFloat = 0
            if currentColor.getWhite(&white, alpha: &alpha) {
                if white > 0.5 {
                    titleLabel!.textColor = UIColor.blackColor()
                }else{
                    titleLabel!.textColor = UIColor.whiteColor()
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureLayer()
    }
    func configureLayer(){
        layer.borderColor = UIColor.grayColor().CGColor
        layer.borderWidth = 4
    }
}
