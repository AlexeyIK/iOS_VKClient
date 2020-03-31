//
//  CurrentDevice.swift
//  iOS_UI_practice1
//
//  Created by Alex on 21/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class CurrentDevice {
    
    public static func getResolution() -> CGFloat {
        let screenBounds = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        return (screenBounds.width * screenScale) * (screenBounds.height * screenScale)
    }
    
    public static func getPixelSizes() -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        return CGSize(width: screenBounds.width * screenScale, height: screenBounds.height * screenScale)
    }
}
