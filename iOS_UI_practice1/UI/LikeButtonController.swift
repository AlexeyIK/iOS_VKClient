//
//  LikeButton.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 06.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

@IBDesignable class LikeButtonController: UIButton {
    
    @IBInspectable var likeColor : UIColor = UIColor.red
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        
        let likeSize = rect.width
        
        print("Like size is \(likeSize)")
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(likeColor.cgColor)
        context.setFillColor(likeColor.cgColor)
        
        context.move(to: CGPoint(x: 0, y: likeSize/4))
        context.addQuadCurve(to: CGPoint(x: likeSize/2, y: likeSize/4), control: CGPoint(x: likeSize/4, y: -likeSize/4))
        context.addQuadCurve(to: CGPoint(x: likeSize, y: likeSize/4), control: CGPoint(x: likeSize/1.5, y: -likeSize/4))
        context.addLine(to: CGPoint(x: likeSize/2, y: likeSize))
        context.addLine(to: CGPoint(x: 0, y: likeSize/4))
        
        context.closePath()
        context.strokePath()
        context.fillPath()
    }
}
