//
//  DateTimeHelper.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 12.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import Foundation

class DateTimeHelper {
    
    public static func getDateTimeString(dateTime : Date?, format : String) -> String {
        let dateTime = dateTime ?? Date();
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: dateTime)
    }
}
