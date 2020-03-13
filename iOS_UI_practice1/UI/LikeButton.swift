//
//  LikeButton.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 06.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class LikeButton: UIButton {
    
    @IBInspectable var likeColor : UIColor = UIColor.red
    @IBInspectable var standardColor : UIColor = UIColor.gray
    @IBInspectable var leftLabelMargin: CGFloat = 4
    
    var likeCount : Int = 0 {
        didSet {
            needUpdate()
        }
    }
    
    var likeImageSize : CGFloat = 16.0
    
    var isLiked: Bool = false
    
    func Like() {
        isLiked = !isLiked
        
        if isLiked {
            likeCount += 1
        } else {
            likeCount -= 1
        }
        
        needUpdate()
        animation()
    }
    
    // Changing Like status animation
    func animation() {
        UIView.transition(
            with: self.titleLabel!,
            duration: 0.5,
            options: .transitionFlipFromTop,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            })
    }
    
    private func needUpdate() {
        setTitle(String(CountsFormatter.ToString(value: likeCount, threshold: 1000, devide: 3, format: "%.1f")), for: .normal)
        setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        likeImageSize = frame.height // margin from "heart" for button label
        contentHorizontalAlignment = .left
        titleEdgeInsets.left = likeImageSize + leftLabelMargin
        needUpdate()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        likeImageSize = frame.height
        contentHorizontalAlignment = .left
        titleEdgeInsets.left = likeImageSize + leftLabelMargin
        needUpdate()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let startX : CGFloat = 0
        let startY : CGFloat = likeImageSize/3
        
        context.move(to: CGPoint(x: startX, y: startY))
        
        context.addQuadCurve(to: CGPoint(x: startX + likeImageSize/2, y: startY), control: CGPoint(x: startX + likeImageSize/4, y: startY - likeImageSize/2))
        context.addQuadCurve(to: CGPoint(x: startX + likeImageSize, y: startY), control: CGPoint(x: startX + likeImageSize/1.25, y: startY - likeImageSize/2))
        context.addQuadCurve(to: CGPoint(x: startX + likeImageSize/2, y: likeImageSize), control: CGPoint(x: startX + likeImageSize, y: likeImageSize/1.5))
        context.addQuadCurve(to: CGPoint(x: startX, y: startY), control: CGPoint(x: startX, y: likeImageSize/1.5))
        context.closePath()
        
        if isLiked {
            context.setFillColor(likeColor.cgColor)
            context.fillPath()
        }
        else {
            context.setStrokeColor(standardColor.cgColor)
            context.strokePath()
        }
    }
}
