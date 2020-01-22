//
//  PopupAnimator.swift
//  iOS_UI_practice1
//
//  Created by Alex on 24.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class PopupAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 1.0
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let recipeView = toView
        
        let finalFrame = recipeView.frame
        
        let xScaleFactor = originFrame.width / finalFrame.width
        let yScaleFactor = originFrame.height / finalFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        recipeView.transform = scaleTransform
        recipeView.center = CGPoint(x: originFrame.midX, y: originFrame.midY)
        recipeView.backgroundColor = UIColor.black.withAlphaComponent(0)
        recipeView.clipsToBounds = true
        
        container.addSubview(toView)
        container.bringSubviewToFront(toView)
        
        UIView.animate(withDuration: duration, animations: {
            recipeView.transform = .identity
            recipeView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            recipeView.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        }) { (isCompleted) in
            transitionContext.completeTransition(isCompleted)
        }
    }
}
