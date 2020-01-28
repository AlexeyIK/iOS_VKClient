//
//  FullScreenPhoto.swift
//  iOS_UI_practice1
//
//  Created by Alex on 22/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class FullScreenPhoto: UIViewController {
    
    var imageScrollView: ScrollablePhoto!
    var imageToShow: UIImage?
    var imageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView = ScrollablePhoto(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupScrollableImage()
        
        if imageToShow != nil {
            self.imageScrollView.set(image: imageToShow!)
        }
    }
    
    func setupScrollableImage() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

class ScrollablePhoto: UIScrollView {

    var scrollableImage: UIImageView!

    func set(image: UIImage) {
        scrollableImage.removeFromSuperview()
        scrollableImage = nil
        
        scrollableImage = UIImageView(image: image)
        self.addSubview(scrollableImage)
    }
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if (imageURL != nil) {
//            imageView.kf.setImage(with: URL(string: imageURL!))
//        }
//        else {
//            imageView.image = imageToShow
//        }
//
//        tabBarController?.tabBar.isHidden = true
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        tabBarController?.tabBar.isHidden = false
//    }
    
}
