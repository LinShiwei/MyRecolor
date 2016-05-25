//
//  floodFillAlgorithmHelper.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/26.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
import UIKit
class RGBComponent {
    let red,green,blue : UInt8
    init(red:UInt8, green:UInt8, blue:UInt8){
        self.red = red
        self.green = green
        self.blue = blue
    }
    func equalToComponent(component:RGBComponent)->Bool{
        if red == component.red && green == component.green && blue == component.blue {
            return true
        }else{
            return false
        }
    }
}