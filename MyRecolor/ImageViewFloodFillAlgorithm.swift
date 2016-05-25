//
//  ImageViewFloodFillAlgorithm.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/9.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
import UIKit
extension PaintingImageView {
    func buckerFill(touchPoint:CGPoint, replacementColor:UIColor){

        guard let _ = self.image else {
            print("image no found")
            return
        }
        guard let bitmapContext = createARGBBitmapContext() else{
            print("fail to create context")
            return
        }
        let touchPointInImage = convertPointToImage(touchPoint)
        let width = CGImageGetWidth(self.image!.CGImage)
        let height = CGImageGetHeight(self.image!.CGImage)
        CGContextClearRect(bitmapContext, CGRect(x: 0, y: 0, width: width, height: height))
        CGContextDrawImage(bitmapContext, CGRect(x: 0, y: 0, width: width, height: height), self.image!.CGImage)
        let data = CGBitmapContextGetData(bitmapContext)
        let dataType = UnsafeMutablePointer<UInt8>(data)
        
        let targetColorRGBComponent  = rgbComponentsAtPoint(touchPointInImage, inData: dataType)
        guard !targetColorRGBComponent.equalToComponent(RGBComponent(red: 0, green: 0, blue: 0)) else{return}
 
        self.image = OpenCVWrapper.floodFill(self.image, point: touchPointInImage, replacementColor: replacementColor)
    }
    private func createARGBBitmapContext()->CGContextRef?{
        let pixelsWide = CGImageGetWidth(self.image!.CGImage)
        let pixelsHigh = CGImageGetHeight(self.image!.CGImage)
        let bitmapBytesPerRow = pixelsWide * 4
        let bitmapByteCount = bitmapBytesPerRow * pixelsHigh
        guard let colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB) else{
            print("Error allocating color space")
            return nil
        }
        let bitmapData = malloc(bitmapByteCount)
        guard let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, CGImageAlphaInfo.PremultipliedFirst.rawValue) else {
            print("Context not create")
            return nil
        }
        return context
    }
    private func rgbComponentsAtPoint(point:CGPoint,inData dataType:UnsafeMutablePointer<UInt8>)->RGBComponent{
        let pixelInfo = Int((self.image!.size.width * point.y) + point.x) * 4
        return RGBComponent(red: dataType[pixelInfo+1], green: dataType[pixelInfo+2], blue: dataType[pixelInfo+3])
    }
    
    private func convertPointToImage(imageViewPoint:CGPoint)->CGPoint{
        var scale : CGFloat = 1
        if let superView = self.superview as? UIScrollView{
            scale = superView.zoomScale
        }
        let x = Int(self.image!.size.width * imageViewPoint.x * scale / self.frame.size.width)
        let y = Int(self.image!.size.height * imageViewPoint.y * scale / self.frame.size.height)
        
        //        print("before convert \(imageViewPoint)")
        //        print("imageViewFrame \(self.frame.size)")
        //        print("after convert  \(CGPoint(x:x,y:y))")
        
        return CGPoint(x: x, y: y)
        
    }
}