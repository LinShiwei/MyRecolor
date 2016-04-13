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
let colorCollectionRows = 10
let colorCellPadding : CGFloat = 3

let appFilePath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]) + "/"

let imageSourcePrefix = "test"
let imageSourceIndexStart = 1
let imageSourceIndexEnd = 5


struct theme {
    let backgroundColor : UIColor
    let borderLineColor : UIColor
    
    
}