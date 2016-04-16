//
//  Define.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/10.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
import UIKit

let colorCollectionColumns = 16
let colorCollectionRows = 6
let colorCellPadding : CGFloat = 3

let appFilePath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]) + "/"

let imageSourcePrefix = "test"
let imageSourceIndexStart = 1
let imageSourceIndexEnd = 6

let paletteViewWidth :CGFloat = 600
let paletteViewHeight:CGFloat = 300
let paletteViewInvisableHeight:CGFloat = 20

struct theme {
    let backgroundColor : UIColor
    let borderLineColor : UIColor
    
    
}