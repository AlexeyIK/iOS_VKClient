//
//  FullScreenPhoto.swift
//  iOS_UI_practice1
//
//  Created by Alex on 22/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class FullScreenPhoto: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imageToShow: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = imageToShow
    }
    
}
