//
//  ImageViewFloodFillAlgorithm.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/9.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
import UIKit
class Stack {
    var count: Int = 0
    var head: Node = Node()
    
    init() {
    }
    
    func isEmpty() -> Bool {
        return self.count == 0
    }
    
    func push(value: CGPoint) {
        if isEmpty() {
            self.head = Node()
        }
        
        let node = Node(value: value)
        node.next = self.head
        self.head = node
        self.count++
    }
    
    func pop() -> CGPoint? {
        if isEmpty() {
            return nil
        }
        
        let node = self.head
        self.head = node.next!
        self.count--
        
        return node.value
    }
}

class Node {
    var value = CGPoint()
    var next : Node?
    init(){
    }
    init(value:CGPoint){
        self.value = value
    }
}
extension UInt8 {
    
    func absoluteDifference(subtrahend: UInt8) -> Bool {
        let difference : UInt8
        if (self > subtrahend) {
            difference = self - subtrahend;
        } else {
            difference = subtrahend - self;
        }
        if difference < 4 {
            return false
        }else{
            return true
        }
    }
}
extension UIImageView {
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
        
        let targetColor = colorAtPoint(touchPointInImage, inData: dataType)
        guard targetColor != UIColor(red: 0, green: 0, blue: 0, alpha: 1) else{return}
        let targetColorRed, targetColorGreen, targetColorBlue : UInt8
        let targetColorColorRef = CGColorGetComponents(targetColor.CGColor)
        if(CGColorGetNumberOfComponents(targetColor.CGColor) == 2) {
            targetColorRed = UInt8(targetColorColorRef[0] * 255) // UInt8
            targetColorGreen = UInt8(targetColorColorRef[0] * 255)
            targetColorBlue = UInt8(targetColorColorRef[0] * 255)
//            targetColorAlpha = UInt8(targetColorColorRef[1])
        } else {
            targetColorRed = UInt8(targetColorColorRef[0] * 255)
            targetColorGreen = UInt8(targetColorColorRef[1] * 255)
            targetColorBlue = UInt8(targetColorColorRef[2] * 255)
//            targetColorAlpha = UInt8(targetColorColorRef[3])
        }
        let replacementRed, replacementGreen, replacementBlue : UInt8
        let replacementColorRef = CGColorGetComponents(replacementColor.CGColor)
        if(CGColorGetNumberOfComponents(replacementColor.CGColor) == 2) {
            replacementRed = UInt8(replacementColorRef[0] * 255) // UInt8
            replacementGreen = UInt8(replacementColorRef[0] * 255)
            replacementBlue = UInt8(replacementColorRef[0] * 255)
//            replacementAlpha = UInt8(replacementColorRef[1])
        } else {
            replacementRed = UInt8(replacementColorRef[0] * 255)
            replacementGreen = UInt8(replacementColorRef[1] * 255)
            replacementBlue = UInt8(replacementColorRef[2] * 255)
//            replacementAlpha = UInt8(replacementColorRef[3])
        }
        
        let stack = Stack()
        stack.push(touchPointInImage)
        while(!stack.isEmpty()){
            let point = stack.pop()!
            
            if !targetColorRed.absoluteDifference(replacementRed) && !targetColorBlue.absoluteDifference(replacementBlue) && !targetColorGreen.absoluteDifference(replacementGreen) {
                continue
            }else if colorAtPoint(point, inData: dataType) != targetColor{
                continue
            }else{
                replaceColorAtPoint(point, inData: dataType, withColorRed: replacementRed, Green: replacementGreen, Blue: replacementBlue)
                if (point.x > 0) {
                    stack.push(CGPoint(x: point.x - 1, y: point.y))
                }
                if (point.x < CGFloat(width)) {
                    stack.push(CGPoint(x: point.x + 1, y: point.y))
                }
                
                if (point.y > 0) {
                    stack.push(CGPoint(x: point.x, y: point.y - 1))
                }
                
                if (point.y < CGFloat(height)) {
                    stack.push(CGPoint(x: point.x, y: point.y + 1))
                }
            }
            
        }//end while
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let finalContext = CGBitmapContextCreate(data, width, height, CLong(8), CLong(width*4), colorSpace, CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        let imageRef = CGBitmapContextCreateImage(finalContext)
        self.image = UIImage(CGImage: imageRef!, scale: self.image!.scale,orientation: self.image!.imageOrientation)
        
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
    private func colorAtPoint(point:CGPoint,inData dataType:UnsafeMutablePointer<UInt8>)->UIColor{
        let pixelInfo = Int((self.image!.size.width * point.y) + point.x) * 4
        let red = CGFloat(dataType[pixelInfo+1])/CGFloat(255)
        let green = CGFloat(dataType[pixelInfo+2])/CGFloat(255)
        let blue = CGFloat(dataType[pixelInfo+3])/CGFloat(255)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    private func replaceColorAtPoint(point:CGPoint,inData dataType:UnsafeMutablePointer<UInt8>,withColorRed red:UInt8,Green green:UInt8,Blue blue:UInt8){
        let pixelInfo = Int((self.image!.size.width * point.y) + point.x) * 4
        dataType[pixelInfo+0] = 255
        dataType[pixelInfo+1] = red
        dataType[pixelInfo+2] = green
        dataType[pixelInfo+3] = blue
    }
    private func convertPointToImage(imageViewPoint:CGPoint)->CGPoint{
        var scale : CGFloat = 1
        if let superView = self.superview as? UIScrollView{
            scale = superView.zoomScale
        }
        let x = Int(self.image!.size.width * imageViewPoint.x * scale / self.frame.size.width)
        let y = Int(self.image!.size.height * imageViewPoint.y * scale / self.frame.size.height)
        
        print("before convert \(imageViewPoint)")
        print("imageViewFrame \(self.frame.size)")
        print("after convert  \(CGPoint(x:x,y:y))")
        
        return CGPoint(x: x, y: y)
        
    }
}
