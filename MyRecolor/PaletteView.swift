//
//  PaletteView.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/9.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
class PaletteView: UIView {
    
    let paletteViewWidth :CGFloat = 600
    let paletteViewHeight:CGFloat = 400
    let paletteViewInvisableHeight:CGFloat = 20
    
    weak var imageView : UIImageView!
    var currentColor = UIColor.whiteColor() {
        didSet{
            self.hideViewButton.backgroundColor = currentColor
        }
    }
    private let windowBounds = UIScreen.mainScreen().bounds
    
    private var isHidden = false
    
    @IBOutlet weak var brightnessView: BrightnessView!
    @IBOutlet weak var colorCollectionView: ColorCollectionView!
    @IBOutlet weak var hideViewButton: UIButton!
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
        self.backgroundColor = UIColor.greenColor()
    }
    private func configureLayer(){
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.cornerRadius = 10
    }    
    private func refreshCurrentColor(){
        if let indexPath = colorCollectionView.indexPathsForSelectedItems(),let cell = colorCollectionView.cellForItemAtIndexPath(indexPath[0]){
                currentColor = cell.backgroundColor!
        }
    }
    private func hidePalette(){
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() -> Void in
            self.center.y = self.windowBounds.height + self.paletteViewHeight/2 - self.hideViewButton.frame.height
            }, completion: nil)
    }
    private func showPalette(){
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() -> Void in
            self.center.y = self.windowBounds.height - self.paletteViewHeight/2 + self.paletteViewInvisableHeight
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
