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
    func saveImage(_ image:UIImage,ofIndex index:Int){
        let data = UIImagePNGRepresentation(image)
        try? data!.write(to: URL(fileURLWithPath: picturePathsInUserDomain[index]), options: [.atomic])
    }
    override init() {
        super.init()
        initPicturePaths()
        prepareImageFile()
    }
    fileprivate func prepareImageFile(){
        let manager = FileManager.default
        do{
            let fileName = try manager.contentsOfDirectory(atPath: appFilePath)
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
    fileprivate func copyImageToUserDomainMask(){
        for index in 0...originPicturePaths.count - 1 {
            let data = UIImagePNGRepresentation(UIImage(contentsOfFile: originPicturePaths[index])!)
            try? data!.write(to: URL(fileURLWithPath: picturePathsInUserDomain[index]), options: [.atomic])
        }
    }
    fileprivate func initPicturePaths(){
        for index in imageSourceIndexStart...imageSourceIndexEnd {
            originPicturePaths.append(Bundle.main.path(forResource: imageSourcePrefix + String(index), ofType: "PNG")!)
            picturePathsInUserDomain.append(appFilePath + imageSourcePrefix + String(index) + ".PNG")
        }
    }}
