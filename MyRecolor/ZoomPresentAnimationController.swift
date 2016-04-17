//
//  ZoomPresentAnimationController.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/16.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import AVFoundation
class ZoomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var cell: ImageCollectionViewCell!
    var originFrame, finalFrame: CGRect!
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        let imageView = cell!.snapshotViewAfterScreenUpdates(true)
        imageView.frame.origin = originFrame.origin
        containerView.addSubview(toVC.view)
        containerView.addSubview(imageView)
        toVC.view.alpha = 0
        cell.alpha = 0
        
        UIView.animateWithDuration(1.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {() -> Void in
            imageView.frame = self.finalFrame
            }, completion:  nil)
        
        UIView.animateWithDuration(0.8, delay: 0.03, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {() -> Void in
            toVC.view.alpha = 1
            }, completion: { _ in
                imageView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
        
    }

}
