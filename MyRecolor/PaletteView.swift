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
    var currentColor = UIColor.white {
        didSet{
            hideViewButton.currentColor = currentColor
        }
    }
    internal var paletteIsHidden = true
    
    @IBOutlet weak var brightnessView: BrightnessView!
    @IBOutlet weak var colorCollectionView: ColorCollectionView!
    @IBOutlet weak var hideViewButton: PaletteViewHeadButton!
    @IBAction func hideView(_ sender: UIButton) {
        if paletteIsHidden {
            showPalette()
        }else{
            hidePalette()
        }
    }

    //MARK: init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
        configureLayer()
    }
    fileprivate func configureView(){
        self.bounds.size = CGSize(width: paletteViewWidth, height: paletteViewHeight)
        self.center = CGPoint(x: windowBounds.width/2, y:  windowBounds.height + paletteViewHeight/2 - 30)
        self.backgroundColor = UIColor.white
    }
    fileprivate func configureLayer(){
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }    
    func refreshCurrentColor(){
        if let indexPath = colorCollectionView.indexPathsForSelectedItems , indexPath.count > 0 ,let cell = colorCollectionView.cellForItem(at: indexPath[0]){
            currentColor = cell.backgroundColor!
        }else{
            currentColor = UIColor(hue: 1, saturation: 0, brightness: brightnessView.brightness, alpha: 1)
        }
    }
    func hidePalette(){
        paletteIsHidden = !paletteIsHidden
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.beginFromCurrentState, animations: {[unowned self]() -> Void in
            self.center.y = windowBounds.height + paletteViewHeight/2 - self.hideViewButton.frame.height
            }, completion: nil)
    }
    func showPalette(){
        paletteIsHidden = !paletteIsHidden
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.beginFromCurrentState, animations: {[unowned self]() -> Void in
            self.center.y = windowBounds.height - paletteViewHeight/2 + paletteViewInvisableHeight
            }, completion: nil)
    }
}
//MARK: CollectionView DataSource
extension PaletteView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorCollectionRows * colorCollectionColumns
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath)
        cell.backgroundColor = initCellColorAtIndexPath(indexPath)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        return cell
    }
    func initCellColorAtIndexPath(_ indexPath:IndexPath)->UIColor{
        let hue = CGFloat(((indexPath as NSIndexPath).item%colorCollectionColumns)+1)/CGFloat(colorCollectionColumns)
        let saturation = CGFloat(((indexPath as NSIndexPath).item/colorCollectionColumns)+1)/CGFloat(colorCollectionRows)
        return UIColor(hue: hue, saturation: saturation, brightness: brightnessView.brightness, alpha: 1)
    }
}
//MARK: CollectionView Delegate
extension PaletteView:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        refreshCurrentColor()
    }
}
