//
//  ZoomPresentAnimationController.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/16.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
class ZoomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var cell: ImageCollectionViewCell!
    var originFrame, finalFrame: CGRect!
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? PaintingViewController else {return}
        let containerView = transitionContext.containerView
        
        let imageView = UIImageView(image: cell.imageView.image)

        let snapshot = imageView.snapshotView(afterScreenUpdates: true)
        snapshot?.frame = originFrame
        snapshot?.layer.borderColor = UIColor.gray.cgColor
        snapshot?.layer.cornerRadius = 10
        snapshot?.layer.borderWidth = 5
        snapshot?.layer.masksToBounds = true

        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot!)
        toVC.view.alpha = 0
        cell.alpha = 0
        
        let scale = toVC.imageScrollView.zoomScale

        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.beginFromCurrentState, animations: {() -> Void in
            snapshot?.frame = self.finalFrame
            snapshot?.layer.borderWidth = 10/scale
            snapshot?.layer.cornerRadius = 0
            }, completion:  nil)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {() -> Void in
            toVC.view.alpha = 1
            }, completion: { _ in
                snapshot?.removeFromSuperview()
                toVC.paletteView.showPalette()
                toVC.imageView.alpha = 1
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }

}
