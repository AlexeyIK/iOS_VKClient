//
//  CustomView.swift
//  iOS_UI_practice1
//
//  Created by Alex on 05.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ImageWithShadowView : UIView {
    
    @IBInspectable var mainColor : UIColor = UIColor.white
    @IBInspectable var shadowColor : UIColor = UIColor.black
    @IBInspectable var shadowOpacity : Float = 0.2
    @IBInspectable var cornerRadius : CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat = 10
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let shadowView = self.subviews[0]
        let imageView = self.subviews[1]
        
        shadowView.layer.masksToBounds = false
        shadowView.layer.cornerRadius = cornerRadius
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.backgroundColor = UIColor.black.cgColor
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOffset = CGSize.zero
        
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        
        setNeedsDisplay()
    }
}
