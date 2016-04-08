//
//  tempCode.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/8.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
/*
private func drawImage(){
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 220, height: 220), false, 0)
    let context = UIGraphicsGetCurrentContext()
    guard let image = UIImage(named: "frame.jpg")?.CGImage else{return}
    CGContextDrawImage(context, CGRect(x: 0, y: 0, width: 220, height: 220), image)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    imageView.image = img
}

private func manipulateImagePixelData(inImage:CGImageRef){
    guard let bitmapContext = createARGBBitmapContext(inImage) else{
        print("fail to create context")
        return
    }
    let width = CGImageGetWidth(inImage)
    let height = CGImageGetHeight(inImage)
    let rect = CGRect(x: 0, y: 0, width: width, height: height)
    CGContextDrawImage(bitmapContext, rect, inImage)
    let data = CGBitmapContextGetData(bitmapContext)
    let dataType = UnsafeMutablePointer<UInt8>(data)
    let pixelInfo = Int((width  * 900) + 100 ) * 4
    let red = CGFloat(dataType[pixelInfo+1])/CGFloat(255)
    let green = CGFloat(dataType[pixelInfo+2])/CGFloat(255)
    let blue = CGFloat(dataType[pixelInfo+3])/CGFloat(255)
    let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
    view.backgroundColor = color
    
}

private func createARGBBitmapContext(inImage: CGImageRef)->CGContextRef?{
    let pixelsWide = CGImageGetWidth(inImage)
    let pixelsHigh = CGImageGetHeight(inImage)
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

*/

/*
extension UIImageView {

func bucketFill(startPoint: CGPoint, newColor: UIColor) {
var newRed, newGreen, newBlue, newAlpha: CUnsignedChar

let pixelsWide = CGImageGetWidth(self.image!.CGImage)
let pixelsHigh = CGImageGetHeight(self.image!.CGImage)
let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))

let bitmapBytesPerRow = Int(pixelsWide) * 4


var context = self.image!.createARGBBitmapContext()

//Clear the context
CGContextClearRect(context, rect)

// Draw the image to the bitmap context. Once we draw, the memory
// allocated for the context for rendering will then contain the
// raw image data in the specified color space.
CGContextDrawImage(context, rect, self.image!.CGImage)

var data = CGBitmapContextGetData(context)
var dataType = UnsafeMutablePointer<UInt8>(data)

let newColorRef = CGColorGetComponents(newColor.CGColor)
if(CGColorGetNumberOfComponents(newColor.CGColor) == 2) {
newRed = CUnsignedChar(newColorRef[0] * 255) // CUnsignedChar
newGreen = CUnsignedChar(newColorRef[0] * 255)
newBlue = CUnsignedChar(newColorRef[0] * 255)
newAlpha = CUnsignedChar(newColorRef[1])
} else {
newRed = CUnsignedChar(newColorRef[0] * 255)
newGreen = CUnsignedChar(newColorRef[1] * 255)
newBlue = CUnsignedChar(newColorRef[2] * 255)
newAlpha = CUnsignedChar(newColorRef[3])
}
let newColorStr = ColorRGB(red: newRed, green: newGreen, blue: newBlue)

var stack = Stack()

let offset = 4*((Int(pixelsWide) * Int(startPoint.y)) + Int(startPoint.x))
//let alpha = dataType[offset]
let startRed: UInt8 = dataType[offset+1]
let startGreen: UInt8 = dataType[offset+2]
let startBlue: UInt8 = dataType[offset+3]

stack.push(startPoint)

while(!stack.isEmpty()) {

let point: CGPoint = stack.pop() as! CGPoint

let offset = 4*((Int(pixelsWide) * Int(point.y)) + Int(point.x))
let alpha = dataType[offset]
let red: UInt8 = dataType[offset+1]
let green: UInt8 = dataType[offset+2]
let blue: UInt8 = dataType[offset+3]

if (red == newRed && green == newGreen && blue == newBlue) {
continue
}

if (red.absoluteDifference(startRed) < 4 && green.absoluteDifference(startGreen) < 4 && blue.absoluteDifference(startBlue) < 4) {

dataType[offset] = 255
dataType[offset + 1] = newRed
dataType[offset + 2] = newGreen
dataType[offset + 3] = newBlue

if (point.x > 0) {
stack.push(CGPoint(x: point.x - 1, y: point.y))
}

if (point.x < CGFloat(pixelsWide)) {
stack.push(CGPoint(x: point.x + 1, y: point.y))
}

if (point.y > 0) {
stack.push(CGPoint(x: point.x, y: point.y - 1))
}

if (point.y < CGFloat(pixelsHigh)) {
stack.push(CGPoint(x: point.x, y: point.y + 1))
}
} else {

}
}

let colorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
let finalContext = CGBitmapContextCreate(data, pixelsWide, pixelsHigh, CLong(8), CLong(bitmapBytesPerRow), colorSpace, bitmapInfo)

let imageRef = CGBitmapContextCreateImage(finalContext)
self.image = UIImage(CGImage: imageRef, scale: self.image!.scale,orientation: self.image!.imageOrientation)
}
}

extension UInt8 {

func absoluteDifference(subtrahend: UInt8) -> UInt8 {
if (self > subtrahend) {
return self - subtrahend;
} else {
return subtrahend - self;
}
}
}
class Stack {
var count: Int = 0
var head: Node = Node()

init() {
}

func isEmpty() -> Bool {
return self.count == 0
}

func push(value: Any) {
if isEmpty() {
self.head = Node()
}

var node = Node(value: value)
node.next = self.head
self.head = node
self.count++
}

func pop() -> Any? {
if isEmpty() {
return nil
}

var node = self.head
self.head = node.next!
self.count--

return node.value
}
}

*/