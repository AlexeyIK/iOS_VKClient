//
//  CustomView.swift
//  iOS_UI_practice1
//
//  Created by Alex on 05.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class AvatarView : UIView {
    
    @IBInspectable var mainColor : UIColor = UIColor.white
    @IBInspectable var cornerRadius : CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat = 10
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let newLayer = CALayer()
        
        layer.cornerRadius = cornerRadius
        newLayer.shadowRadius = shadowRadius;
        newLayer.shadowColor = UIColor.black.cgColor
        newLayer.shadowOpacity = 0.1
        setNeedsDisplay()
    }
}
