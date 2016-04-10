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
    
    var currentColor = UIColor.redColor() {
        didSet{
            self.hideViewButton.backgroundColor = currentColor
        }
    }
    
    weak var imageView : UIImageView!
    
    private let windowBounds = UIScreen.mainScreen().bounds
    private var originSize : CGSize?
    private var isHidden = false
    //MARK: init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureView()
    }
   
    private func configureView(){
        originSize = CGSize(width: paletteViewWidth, height: paletteViewHeight)
        self.bounds = CGRect(origin: CGPoint(x: 0,y: 0), size: originSize!)
        self.center = CGPoint(x: windowBounds.width/2, y: windowBounds.height-originSize!.height/2 + paletteViewInvisableHeight)
        
        self.backgroundColor = UIColor.greenColor()
        
        configureLayer()
    }
    
    private func refreshCurrentColor(){
        if let indexPath = colorCollectionView.indexPathsForSelectedItems(),let cell = colorCollectionView.cellForItemAtIndexPath(indexPath[0]){
                currentColor = cell.backgroundColor!
        }
    }
    private func configureLayer(){
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.cornerRadius = 10
    }
    private func hidePalette(){
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() -> Void in
            self.center.y = self.windowBounds.height+self.originSize!.height/2 - self.hideViewButton.frame.height
            }, completion: nil)
    }
    private func showPalette(){
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() -> Void in
            self.center.y = self.windowBounds.height - self.originSize!.height/2 + self.paletteViewInvisableHeight
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
        let saturation = CGFloat((indexPath.item/colorCollectionColumns)+1)/CGFloat(colorCollectionRows)
        let hue = CGFloat((indexPath.item%colorCollectionColumns)+1)/CGFloat(colorCollectionColumns)
        return UIColor(hue: hue, saturation: saturation, brightness: brightnessView.brightness, alpha: 1)
        
    }
}
//MARK: CollectionView Delegate
extension PaletteView:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        refreshCurrentColor()
    }
}
