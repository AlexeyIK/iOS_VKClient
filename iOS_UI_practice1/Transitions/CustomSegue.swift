//
//  CustomSegue.swift
//  iOS_UI_practice1
//
//  Created by Alex on 22.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    override func perform() {
        guard let container = source.view.superview else { return }
        
        container.addSubview(destination.view)
        destination.view.alpha = 0
        
        UIView.animate(withDuration: 1.5, animations: {
            self.destination.view.alpha = 1.0
        }) { (complete) in
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }
}
