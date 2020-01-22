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
    var imageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (imageURL != nil) {
            imageView.kf.setImage(with: URL(string: imageURL!))
        }
        else {
            imageView.image = imageToShow
        }
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
}
