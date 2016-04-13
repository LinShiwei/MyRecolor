//
//  MainViewController.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/8.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import CoreData
class MainViewController: UIViewController {

    let source = ImageSource()
    var pictures = [UIImage]()
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initPictures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage", let destinationViewController = segue.destinationViewController as? PaintingViewController,let cell = sender as? ImageCollectionViewCell {
            destinationViewController.paintingImage = cell.imageView.image
            destinationViewController.delegate = self
        }
    }
    func initPictures(){
        for path in source.picturePaths {
            pictures.append(UIImage(contentsOfFile: path)!)
        }
    }
}
//MARK: CollectionView DataSource
extension MainViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionViewCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = pictures[indexPath.row]
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
}
//MARK: CollectionView Delegate
extension MainViewController: UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}
//MARK: SaveImage Delegate
extension MainViewController: SaveImageDelegate{
    func saveImage(image : UIImage){
        guard let indexPath = albumCollectionView.indexPathsForSelectedItems() else{
            print("No seleted cell")
            return
        }
        pictures[indexPath[0].row] = image
        albumCollectionView.reloadData()
        source.saveImage(image, ofIndex: indexPath[0].row)
    }
}
