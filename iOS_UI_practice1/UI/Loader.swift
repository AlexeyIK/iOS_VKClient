//
//  Loader.swift
//  iOS_UI_practice1
//
//  Created by Alex on 16.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class Loader: UIView {

    @IBInspectable let loaderColor : UIColor = UIColor.gray
    @IBInspectable let rectsSizeProportion : CGFloat = 0.25
    @IBInspectable let animationTime : Double = 1.5
    @IBInspectable let boxesCount : Int = 3
    
    public func playAnimation() {
        isHidden = false
        
        for i in 0..<boxesCount {
            UIView.animate(withDuration: animationTime / Double(boxesCount), delay: (animationTime / Double(boxesCount) / 2) * Double(i), options: [.repeat, .autoreverse], animations: {
                self.subviews[i].alpha = 1.0
                self.setNeedsDisplay()
            }, completion: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubviews()
    }
    
    private func makeSubviews() {
        let rect = self.bounds
        backgroundColor = UIColor.clear // делаем фон прозрачным, даже если он был непрозрачный
        let rectSize = rect.height * rectsSizeProportion
        
        for i in 0..<boxesCount {
            let subView = UIView(frame: frame(forAlignmentRect: CGRect(x: rect.width/(CGFloat(boxesCount) - 1) * CGFloat(i), y: rect.height/2, width: rectSize, height: rectSize)))
            subView.backgroundColor = loaderColor
            subView.alpha = 0
            addSubview(subView)
        }
        isHidden = true
    }
}
