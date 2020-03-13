//
//  CountsFormatter.swift
//  iOS_UI_practice1
//
//  Created by Alex on 13/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation

class CountsFormatter {
    
    public static func ToString(value: Float, threshold : Int, devide rank: Int, format: String) -> String {
        return value >= Float(threshold) ? String(format: format, value / (10 * Float(rank))) : String(value)
    }
    
    public static func ToString(value: Double, threshold: Int, devide rank: Int, format: String) -> String {
        return value >= Double(threshold) ? String(format: format, value / (10 * Double(rank))) : String(value)
    }
    
    public static func ToString(value: Int, threshold: Int, devide rank: Int, format: String) -> String {
        return value >= threshold ? String(format: format, Float(value) / (10 * Float(rank))) : String(value)
    }
}
