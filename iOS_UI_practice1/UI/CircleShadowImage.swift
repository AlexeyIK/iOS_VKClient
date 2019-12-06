//
//  CircleShadowImage.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 06.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

@IBDesignable class CircleShadowImage : UIView {
    
    var image: UIImageView!
    @IBInspectable let shadowColor : UIColor = UIColor.black
    @IBInspectable let shadowOpacity : Float = 1.0
    @IBInspectable let shadowRadius : CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addImage()
    }
    
    func addImage() {
        image = UIImageView(frame: frame)
        addSubview(image)
    }
    
    override func layoutSubviews() {
        image.frame = bounds
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize.zero
        
        image.layer.cornerRadius = bounds.size.height / 2
    }
}
