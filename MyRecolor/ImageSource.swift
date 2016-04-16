//
//  ImageSource.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/13.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import CoreData
class ImageSource: NSObject {
    var picturePaths = [String]()
    func saveImage(image:UIImage,ofIndex index:Int){
        let data = UIImagePNGRepresentation(image)
        data!.writeToFile(picturePaths[index], atomically: true)
    }
    override init() {
        super.init()
        let imageObjects = initImageObjects()
        for object in imageObjects {
            picturePaths.append(appFilePath + (object.valueForKey("name") as! String))
        }
    }
    private func initImageObjects()->[NSManagedObject]{
        let managedContext = getManagedContext()
        let fetchRequest = NSFetchRequest(entityName: "Picture")
        var objects = [NSManagedObject]()
        do {
            objects = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if objects.count > 0 {
            return objects
        }else{
            copyImageToUserDomainMask()
            
            let entity = NSEntityDescription.entityForName("Picture", inManagedObjectContext:managedContext)
            var newObjects = [NSManagedObject]()
            for index in imageSourceIndexStart...imageSourceIndexEnd {
                newObjects.append(NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext))
                newObjects.last!.setValue(imageSourcePrefix + String(index) + ".png", forKey: "name")
            }
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            return newObjects
        }
        
    }
    private func getManagedContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
    private func copyImageToUserDomainMask(){
        for index in imageSourceIndexStart...imageSourceIndexEnd {
            
            let sourcePath = NSBundle.mainBundle().pathForResource(imageSourcePrefix + String(index), ofType: "png")
            let destinationPath = appFilePath + imageSourcePrefix + String(index) + ".png"
            let data = UIImagePNGRepresentation(UIImage(contentsOfFile: sourcePath!)!)
            data!.writeToFile(destinationPath, atomically: true)
        }
    }
}
