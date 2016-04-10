//
//  BrightnessView.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/10.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
class BrightnessView: UIView {

    var brightness = CGFloat(1)
    
    private let indicator = UIView(frame: CGRect(x: -5, y: -7, width: 15, height: 15))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradientLayer()
        configureIndicator()
    }
    private func configureGradientLayer(){
        let colors = [UIColor.whiteColor().CGColor as AnyObject,UIColor.blackColor().CGColor as AnyObject]
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30, height: 400-28-38))
        gradientLayer.colors = colors
        layer.addSublayer(gradientLayer)
    }
    private func configureIndicator(){
        let indicatorLayer = CAShapeLayer()
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
        path.moveToPoint(CGPoint(x: 1, y: 1))
        path.addLineToPoint(CGPoint(x: 15, y: 1))
        path.addLineToPoint(CGPoint(x: 22, y: 8))
        path.addLineToPoint(CGPoint(x: 15, y: 15))
        path.addLineToPoint(CGPoint(x: 1, y: 15))
        path.addLineToPoint(CGPoint(x: 1, y: 1))
        path.closePath()
        return path
    }
    func didPan(sender:UIPanGestureRecognizer){
        let point = sender.locationInView(self)
        if point.y >= 0 && point.y < self.bounds.height {
            indicator.center.y = point.y
            brightness = 1 - point.y / self.bounds.height
            if let views = self.superview?.subviews{
                for view in views where view is ColorCollectionView {
                    (view as! ColorCollectionView).reloadData()
                }
            }
        }
    }
}
