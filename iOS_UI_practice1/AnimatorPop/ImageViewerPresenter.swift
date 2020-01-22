//
//  ImageViewerPresenter.swift
//  iOS_UI_practice1
//
//  Created by Alex on 24.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

protocol ImageViewPresenterSource: UIViewController {
    var source: UIView? { get }
}

class ImageViewerPresenter: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    var animatorSource: ImageViewPresenterSource?
    var animator = PopupAnimator()
    
    init(delegate: ImageViewPresenterSource) {
        animatorSource = delegate
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let sourceView = animatorSource?.source,
              let origin = sourceView.superview?.convert(sourceView.frame,
                                                         to: UIApplication.topViewController()!.navigationController!.view) else {
              return nil
        }
        
        animator.originFrame = CGRect(x: origin.minX,
                                      y: origin.minY,
                                      width: origin.size.width,
                                      height: origin.size.height)
        return animator
    }
    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        <#code#>
//    }
}
