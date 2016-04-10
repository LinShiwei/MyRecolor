//
//  ColorCollectionView.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/10.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class ColorCollectionView: UICollectionView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    //MARK: init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureView()
    }
    private func configureView(){
        registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCollectionViewCell")
    }
}
