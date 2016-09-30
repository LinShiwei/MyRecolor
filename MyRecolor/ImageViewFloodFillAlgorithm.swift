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
    func buckerFill(_ touchPoint:CGPoint, replacementColor:UIColor){

        guard let _ = self.image else {
            print("image no found")
            return
        }
        guard let bitmapContext = createARGBBitmapContext() else{
            print("fail to create context")
            return
        }
        let touchPointInImage = convertPointToImage(touchPoint)
        let width = self.image!.cgImage?.width
        let height = self.image!.cgImage?.height
        bitmapContext.clear(CGRect(x: 0, y: 0, width: width!, height: height!))
        bitmapContext.draw(self.image!.cgImage!, in: CGRect(x: 0, y: 0, width: width!, height: height!))
        let data = bitmapContext.data!.assumingMemoryBound(to: UInt8.self)
        let targetColorRGBComponent  = rgbComponentsAtPoint(touchPointInImage, inData: data)
        guard !targetColorRGBComponent.equalToComponent(RGBComponent(red: 0, green: 0, blue: 0)) else{return}
 
        self.image = OpenCVWrapper.floodFill(self.image, point: touchPointInImage, replacementColor: replacementColor)
    }
    fileprivate func createARGBBitmapContext()->CGContext?{
        let pixelsWide = self.image!.cgImage?.width
        let pixelsHigh = self.image!.cgImage?.height
        let bitmapBytesPerRow = pixelsWide! * 4
        let bitmapByteCount = bitmapBytesPerRow * pixelsHigh!
        guard let colorSpace = CGColorSpace(name: CGColorSpace.genericRGBLinear) else{
            print("Error allocating color space")
            return nil
        }
        let bitmapData = malloc(bitmapByteCount)
        guard let context = CGContext(data: bitmapData, width: pixelsWide!, height: pixelsHigh!, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            print("Context not create")
            return nil
        }
        return context
    }
    fileprivate func rgbComponentsAtPoint(_ point:CGPoint,inData data:UnsafeMutablePointer<UInt8>)->RGBComponent{
        let pixelInfo = Int((self.image!.size.width * point.y) + point.x) * 4
        return RGBComponent(red: data[pixelInfo+1], green: data[pixelInfo+2], blue: data[pixelInfo+3])
    }
    
    fileprivate func convertPointToImage(_ imageViewPoint:CGPoint)->CGPoint{
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
