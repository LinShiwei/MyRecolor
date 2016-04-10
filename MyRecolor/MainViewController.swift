//
//  MainViewController.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/8.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage", let destinationViewController = segue.destinationViewController as? PaintingViewController,let cell = sender as? ImageCollectionViewCell {
            destinationViewController.paintingImage = cell.imageView.image
        }
    }


}
//MARK: CollectionView DataSource
extension MainViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionViewCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        cell.backgroundColor = UIColor.redColor()
        return cell
    }

}
//MARK: CollectionView Delegate
extension MainViewController: UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
}
