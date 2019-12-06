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
    
    var liked: Bool = false {
        didSet {
            if liked {
                setLike()
            } else {
                unsetLike()
            }
        }
    }
    
    var likeCount = 0
    
    private func setLike() {
        likeCount += 1
        setImage(UIImage(named: "like"), for: .normal)
        setTitle(String(describing: likeCount), for: .normal)
    }
    
    private func unsetLike() {
        likeCount -= 1
        setImage(UIImage(named: "dislike"), for: .normal)
        setTitle(String(describing: likeCount), for: .normal)
    }
    
    private func like() {
        liked = !liked
    }
    
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
