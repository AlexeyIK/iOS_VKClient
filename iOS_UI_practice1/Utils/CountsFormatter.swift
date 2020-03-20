//
//  CountsFormatter.swift
//  iOS_UI_practice1
//
//  Created by Alex on 13/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation

class CountsFormatter {
    
    static let thousands = "K"
    static let millions = "M"
    
    public static func ToString(value: Double, format: String, threshold: Double = 1000.0) -> String {
        var str = String(value)
        
        if value >= threshold * threshold {
            str = String(format: format + millions, Double(value) / (threshold * threshold))
        } else if value >= threshold {
            str = String(format: format + thousands, Double(value) / (threshold))
        }
        return str
    }
    
    public static func ToString(value: Float, format: String, threshold: Float = 1000.0) -> String {
        var str = String(value)
        
        if value >= threshold * threshold {
            str = String(format: format + millions, Float(value) / (threshold * threshold))
        } else if value >= threshold {
            str = String(format: format + thousands, Float(value) / (threshold))
        }
        return str
    }
    
    public static func ToString(value: Int, format: String, threshold: Int = 1000) -> String {
        var str = String(value)
        
        if value >= threshold * threshold {
            str = String(format: format + millions, Float(value) / (Float(threshold * threshold)))
        } else if value >= threshold {
            str = String(format: format + thousands, Float(value) / (Float(threshold)))
        }
        return str
    }
}
