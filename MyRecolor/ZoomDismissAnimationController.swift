//
//  ZoomDismissAnimationController.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/16.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class ZoomDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var cell : ImageCollectionViewCell?
    var destinationFrame = CGRectZero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        let finalFrame = destinationFrame
        
        let snapshot = fromVC.view.snapshotViewAfterScreenUpdates(false)
        
        snapshot.layer.cornerRadius = 25
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        print(fromVC)
        print(toVC)
        fromVC.view.hidden = true
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {() -> Void in
            snapshot.frame = finalFrame
            }, completion:  { _ in
//                fromVC.view.hidden = false
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })

    }
}
