//
//  PaletteView.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/9.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
class PaletteView: UIView {
    
    
    
    weak var imageView : UIImageView!
    var currentColor = UIColor.whiteColor() {
        didSet{
            hideViewButton.currentColor = currentColor
        }
    }
    
    private var isHidden = false
    
    @IBOutlet weak var brightnessView: BrightnessView!
    @IBOutlet weak var colorCollectionView: ColorCollectionView!
    @IBOutlet weak var hideViewButton: PaletteViewHeadButton!
    @IBAction func hideView(sender: UIButton) {
        if isHidden {
            isHidden = !isHidden
            showPalette()
        }else{
            isHidden = !isHidden
            hidePalette()
        }
    }

    //MARK: init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
        configureLayer()
    }
    private func configureView(){
        self.bounds.size = CGSize(width: paletteViewWidth, height: paletteViewHeight)
        self.center = CGPoint(x: windowBounds.width/2, y: windowBounds.height-paletteViewHeight/2 + paletteViewInvisableHeight)
        self.backgroundColor = UIColor.whiteColor()
        
    }
    private func configureLayer(){
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }    
    func refreshCurrentColor(){
        if let indexPath = colorCollectionView.indexPathsForSelectedItems() where indexPath.count > 0 ,let cell = colorCollectionView.cellForItemAtIndexPath(indexPath[0]){
            currentColor = cell.backgroundColor!
        }else{
            currentColor = UIColor(hue: 1, saturation: 0, brightness: brightnessView.brightness, alpha: 1)
        }
    }
    private func hidePalette(){
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() -> Void in
            self.center.y = windowBounds.height + paletteViewHeight/2 - self.hideViewButton.frame.height
            }, completion: nil)
    }
    private func showPalette(){
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() -> Void in
            self.center.y = windowBounds.height - paletteViewHeight/2 + paletteViewInvisableHeight
            }, completion: nil)
    }
}
//MARK: CollectionView DataSource
extension PaletteView:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorCollectionRows * colorCollectionColumns
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCollectionViewCell", forIndexPath: indexPath)
        cell.backgroundColor = initCellColorAtIndexPath(indexPath)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.grayColor().CGColor
        return cell
    }
    func initCellColorAtIndexPath(indexPath:NSIndexPath)->UIColor{
        let hue = CGFloat((indexPath.item%colorCollectionColumns)+1)/CGFloat(colorCollectionColumns)
        let saturation = CGFloat((indexPath.item/colorCollectionColumns)+1)/CGFloat(colorCollectionRows)
        return UIColor(hue: hue, saturation: saturation, brightness: brightnessView.brightness, alpha: 1)
    }
}
//MARK: CollectionView Delegate
extension PaletteView:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        refreshCurrentColor()
    }
}
