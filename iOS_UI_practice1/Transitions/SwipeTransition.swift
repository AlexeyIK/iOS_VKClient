//
//  SwipeTransition.swift
//  iOS_UI_practice1
//
//  Created by Alex on 23.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class SwipeTransition: UIPercentDrivenInteractiveTransition {
    
    var transitionInteraction: UIPercentDrivenInteractiveTransition?
    
    var viewController: UIViewController? {
        didSet {
            let edgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeRecognize(_:)))
            
            edgeRecognizer.edges = .left
            viewController?.view.addGestureRecognizer(edgeRecognizer)
        }
    }
    
    @objc func edgeRecognize(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view)
        let percentComplete = translation.x / (recognizer.view?.bounds.size.width ?? 1)
        
        switch recognizer.state {
        case .began:
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            self.update(percentComplete)
        case .ended:
            let velocity = recognizer.velocity(in: recognizer.view)

            if velocity.x > 0 || percentComplete > 0.5 {
                self.finish()
            }
            else {
                self.cancel()
            }
        default:
            break
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transitionInteraction
    }
}
