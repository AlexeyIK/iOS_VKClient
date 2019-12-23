//
//  CardRotateTransitionInverted.swift
//  iOS_UI_practice1
//
//  Created by Alex on 23.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

// Inverted variation of card rotate transition
class CardRotateTransitionInverted: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
            let destinationVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        transitionContext.containerView.addSubview(destinationVC.view)
        destinationVC.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        destinationVC.view.frame = source.view.frame
        destinationVC.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            destinationVC.view.transform = CGAffineTransform(rotationAngle: 0)
        }) { animationFinished in
            if animationFinished && !transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(true)
            }
        }
    }
}
