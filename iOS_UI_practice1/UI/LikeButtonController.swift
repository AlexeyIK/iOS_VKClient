//
//  LikeButton.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 06.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class LikeButtonController: UIButton {
    
    @IBInspectable var likeColor : UIColor = UIColor.red
    @IBInspectable var leftLabelMargin: CGFloat = 4
    
    var likeCount = Int.random(in: 0..<1000)
    var likeImageSize : CGFloat = 16.0
    
    var liked: Bool = false {
        didSet {
            if liked {
                likeCount += 1
                needUpdate()
            } else {
                likeCount -= 1
                needUpdate()
            }
        }
    }
    
    func Like() {
        liked = !liked
        needUpdate()
    }
    
    private func needUpdate() {
        setTitle(String(likeCount), for: .normal)
        setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Отступ на размер сердечка для выведения количества лайков
        likeImageSize = frame.height
        titleEdgeInsets.left = likeImageSize + leftLabelMargin
        needUpdate()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        likeImageSize = frame.height
        titleEdgeInsets.left = likeImageSize + leftLabelMargin
        needUpdate()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(likeColor.cgColor)
        context.setFillColor(likeColor.cgColor)
        
        let startX : CGFloat = 0
        let startY : CGFloat = likeImageSize/3
        
        context.move(to: CGPoint(x: startX, y: startY))
        
        context.addQuadCurve(to: CGPoint(x: startX + likeImageSize/2, y: startY), control: CGPoint(x: startX + likeImageSize/4, y: startY - likeImageSize/2))
        context.addQuadCurve(to: CGPoint(x: startX + likeImageSize, y: startY), control: CGPoint(x: startX + likeImageSize/1.25, y: startY - likeImageSize/2))
        context.addQuadCurve(to: CGPoint(x: startX + likeImageSize/2, y: likeImageSize), control: CGPoint(x: startX + likeImageSize, y: likeImageSize/1.5))
        context.addQuadCurve(to: CGPoint(x: startX, y: startY), control: CGPoint(x: startX, y: likeImageSize/1.5))
        
        context.closePath()
        
        if liked {
            context.fillPath()
        }
        else {
            context.strokePath()
        }
    }
}
