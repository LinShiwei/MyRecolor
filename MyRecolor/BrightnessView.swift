//
//  BrightnessView.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/10.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
class BrightnessView: UIView {

    let indicatorHeight = 16
    let indicatorWidth = 24
    var brightness : CGFloat = 1 {
        didSet{
            if let views = self.superview?.subviews{
                for view in views where view is ColorCollectionView {
                    (view as! ColorCollectionView).reloadData()
                }
            }
        }
    }
    
    private let indicator = UIView(frame: CGRect(x: -5, y: -16, width: 30, height: 32))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradientLayer()
        configureIndicator()
    }
    private func configureGradientLayer(){
        let colors = [UIColor.whiteColor().CGColor as AnyObject,UIColor.blackColor().CGColor as AnyObject]
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 30, height: 400-28-38)
        gradientLayer.colors = colors
        layer.addSublayer(gradientLayer)
    }
    private func configureIndicator(){
        let indicatorLayer = CAShapeLayer()
        indicatorLayer.position = CGPoint(x: 0, y: indicatorHeight/2)
        indicatorLayer.path = drawIndicatorPath().CGPath
        indicatorLayer.fillColor = UIColor.whiteColor().CGColor
        indicatorLayer.lineJoin = kCALineJoinRound
        indicatorLayer.lineWidth = CGFloat(2)
        indicatorLayer.strokeColor = UIColor.grayColor().CGColor
        indicator.layer.addSublayer(indicatorLayer)
        let recognizer = UIPanGestureRecognizer(target: self, action: "didPan:")
        indicator.addGestureRecognizer(recognizer)
    
        addSubview(indicator)
    }
    private func drawIndicatorPath()->UIBezierPath{
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: indicatorWidth - 8, y: 0))
        path.addLineToPoint(CGPoint(x: indicatorWidth, y: indicatorHeight/2))
        path.addLineToPoint(CGPoint(x: indicatorWidth - 8, y: indicatorHeight))
        path.addLineToPoint(CGPoint(x: 0, y: indicatorHeight))
        path.addLineToPoint(CGPoint(x: 0, y: 0))
        path.closePath()
        return path
    }
    func didPan(sender:UIPanGestureRecognizer){
        let point = sender.locationInView(self)
        if point.y >= 0 && point.y < self.bounds.height {
            indicator.center.y = point.y
            brightness = 1 - point.y / self.bounds.height
        }
    }
}
