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
            if let superView = self.superview {
                for view in superView.subviews where view is ColorCollectionView {
                    (view as! ColorCollectionView).reloadData()
                }
                (superView as! PaletteView).refreshCurrentColor()

            }
        }
    }
    
    fileprivate let indicator = UIView(frame: CGRect(x: -5, y: -16, width: 30, height: 32))
    //MARK: Init View
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradientLayer()
        configureIndicator()
    }
    fileprivate func configureGradientLayer(){
        let colors = [UIColor.white.cgColor as AnyObject,UIColor.black.cgColor as AnyObject]
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 8, y: 0, width: 30, height: paletteViewHeight-28-38)
        gradientLayer.borderColor = UIColor.gray.cgColor
        gradientLayer.borderWidth = 2
        gradientLayer.colors = colors
        layer.addSublayer(gradientLayer)
    }
    fileprivate func configureIndicator(){
        let indicatorLayer = CAShapeLayer()
        indicatorLayer.position = CGPoint(x: 8, y: indicatorHeight/2)
        indicatorLayer.path = drawIndicatorPath().cgPath
        indicatorLayer.fillColor = UIColor.white.cgColor
        indicatorLayer.lineJoin = kCALineJoinRound
        indicatorLayer.lineWidth = CGFloat(2)
        indicatorLayer.strokeColor = UIColor.gray.cgColor
        indicator.layer.addSublayer(indicatorLayer)
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(BrightnessView.didPan(_:)))
        indicator.addGestureRecognizer(recognizer)
    
        addSubview(indicator)
    }
    fileprivate func drawIndicatorPath()->UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: indicatorWidth - 8, y: 0))
        path.addLine(to: CGPoint(x: indicatorWidth, y: indicatorHeight/2))
        path.addLine(to: CGPoint(x: indicatorWidth - 8, y: indicatorHeight))
        path.addLine(to: CGPoint(x: 0, y: indicatorHeight))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        return path
    }
    //MARK: PanGesture Action
    func didPan(_ sender:UIPanGestureRecognizer){
        let point = sender.location(in: self)
        if point.y >= 0 && point.y < self.bounds.height {
            indicator.center.y = point.y
            brightness = 1 - point.y / self.bounds.height
        }
    }
}
