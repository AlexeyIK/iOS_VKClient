//
//  CustomNavigationController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 24.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    let swipeTransition = SwipeTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeTransition
    }
    
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if operation == .push {
//            self.swipeTransition.viewController = toVC
//        } else if operation == .pop {
//            if navigationController.viewControllers.first != toVC {
//                self.swipeTransition.viewController = toVC
//            }
//        }
//        return nil
//    }
}
