//
//  ZoomDismissAnimationController.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/16.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class ZoomDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var cell: ImageCollectionViewCell!

    var originFrame, finalFrame : CGRect!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? PaintingViewController,
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? MainViewController else {
                return
        }
        let snapshot = fromVC.imageView.snapshotViewAfterScreenUpdates(true)
        snapshot.frame.origin = originFrame.origin
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.alpha = 0
        UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {() -> Void in
            snapshot.frame = self.finalFrame
            }, completion:  nil)
        
        UIView.animateWithDuration(0.8, delay: 0.03, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {() -> Void in
            toVC.view.alpha = 1
            }, completion: { _ in
                snapshot.removeFromSuperview()
                self.cell.alpha = 1
                toVC.albumCollectionView.reloadData()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })

    }
}
