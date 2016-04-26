//
//  ImageSource.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/13.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
class ImageSource: NSObject {
    var picturePathsInUserDomain = [String]()
    var originPicturePaths = [String]()
    func saveImage(image:UIImage,ofIndex index:Int){
        let data = UIImagePNGRepresentation(image)
        data!.writeToFile(picturePathsInUserDomain[index], atomically: true)
    }
    override init() {
        super.init()
        initPicturePaths()
        prepareImageFile()
    }
    private func prepareImageFile(){
        let manager = NSFileManager.defaultManager()
        do{
            let fileName = try manager.contentsOfDirectoryAtPath(appFilePath)
            var count = 0
            for name in fileName where name.hasPrefix(imageSourcePrefix){
                count += 1
            }
            if count < imageSourceIndexEnd - imageSourceIndexStart + 1 {
                copyImageToUserDomainMask()
            }
        }catch{
            print("failed to get fileNames")
        }
    }
    private func copyImageToUserDomainMask(){
        for index in 0...originPicturePaths.count - 1 {
            let data = UIImagePNGRepresentation(UIImage(contentsOfFile: originPicturePaths[index])!)
            data!.writeToFile(picturePathsInUserDomain[index], atomically: true)
        }
    }
    private func initPicturePaths(){
        for index in imageSourceIndexStart...imageSourceIndexEnd {
            originPicturePaths.append(NSBundle.mainBundle().pathForResource(imageSourcePrefix + String(index), ofType: "PNG")!)
            picturePathsInUserDomain.append(appFilePath + imageSourcePrefix + String(index) + ".PNG")
        }
    }}
