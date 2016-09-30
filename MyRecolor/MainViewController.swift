//
//  MainViewController.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/8.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
class MainViewController: UIViewController {

    let source = ImageSource()
    var pictures = [UIImage]()
    
    fileprivate let zoomPresentAnimationController = ZoomPresentAnimationController()
    fileprivate let zoomDismissAnimationController = ZoomDismissAnimationController()

    @IBOutlet weak var albumCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initPictures()
//        albumCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage", let destinationViewController = segue.destination as? PaintingViewController,let cell = sender as? ImageCollectionViewCell {
            let indexPath = albumCollectionView.indexPath(for: cell)
            destinationViewController.originImage = UIImage(contentsOfFile: source.originPicturePaths[(indexPath! as NSIndexPath).row])
            destinationViewController.paintingImage = cell.imageView.image
            destinationViewController.delegate = self
            destinationViewController.transitioningDelegate = self
        }
    }
    func initPictures(){
        for path in source.picturePathsInUserDomain {
            pictures.append(UIImage(contentsOfFile: path)!)
        }
    }
}
//MARK: CollectionView DataSource
extension MainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = pictures[(indexPath as NSIndexPath).row]
        
        return cell
    }
}
////MARK: CollectionView Delegate
//extension MainViewController: UICollectionViewDelegate{
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//    }
//}
//MARK: SaveImage Delegate
extension MainViewController: SaveImageDelegate{
    func saveImage(_ image : UIImage){
        guard let indexPath = albumCollectionView.indexPathsForSelectedItems else{
            print("No seleted cell")
            return
        }
        pictures[(indexPath[0] as NSIndexPath).row] = image
//        albumCollectionView.reloadData()
        source.saveImage(image, ofIndex: (indexPath[0] as NSIndexPath).row)
    }
}
//MARK: Transition Delegate
extension MainViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let indexPaths = albumCollectionView.indexPathsForSelectedItems , indexPaths.count > 0,let cell = albumCollectionView.cellForItem(at: indexPaths[0]) as? ImageCollectionViewCell else{
            print("cell no found")
            return zoomPresentAnimationController
        }
        zoomPresentAnimationController.cell = cell
        zoomPresentAnimationController.originFrame = CGRect(origin: cell.convert(CGPoint(x: 0, y: 0), to: nil), size: cell.frame.size)
        zoomPresentAnimationController.finalFrame = AVMakeRect(aspectRatio: cell.frame.size, insideRect: windowBounds)
        zoomDismissAnimationController.cell = cell
        zoomDismissAnimationController.originFrame = zoomPresentAnimationController.finalFrame
        zoomDismissAnimationController.finalFrame = zoomPresentAnimationController.originFrame
        
        return zoomPresentAnimationController
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return zoomDismissAnimationController
    }
}
//MARK: AlbumCollectionViewLayout Delegate
extension MainViewController: AlbumCollectionViewLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        return pictures[(indexPath as NSIndexPath).row].size
    }
}
