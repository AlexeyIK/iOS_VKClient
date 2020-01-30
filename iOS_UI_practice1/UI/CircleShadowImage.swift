//
//  CircleShadowImage.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 06.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class CircleShadowImage : UIView {
    
    var image: UIImageView!
    @IBInspectable let shadowColor : UIColor = UIColor.black
    @IBInspectable let shadowOpacity : Float = 0.4
    @IBInspectable let shadowRadius : CGFloat = 4.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addImage()
    }
    
    private func addImage() {
        image = UIImageView(frame: frame)
        addSubview(image)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        image.frame = bounds
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize.zero
        
        image.layer.cornerRadius = bounds.size.height / 2
        image.layer.masksToBounds = true
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view else { return }
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.05,
                       initialSpringVelocity: 0.4,
                       options: [.autoreverse],
                       animations: {
                            imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        },
                       completion: { _ in
                            imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        })
    }
}
