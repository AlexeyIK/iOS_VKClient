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
    
    public static func getFormattedDate(dateTime: Date) -> String {
        let timeFormat = DateFormatter()
        let dateFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm"
        dateFormat.dateStyle = .full
        dateFormat.locale = Locale.init(identifier: "ru_RU")
        dateFormat.dateFormat = "dd MMM"
        
        if Calendar.current.isDateInToday(dateTime) {
            return "сегодня в \(timeFormat.string(from: dateTime))"
        }
        else if Calendar.current.isDateInYesterday(dateTime) {
            return "вчера в \(timeFormat.string(from: dateTime))"
        }
        else {
            return "\(dateFormat.string(from: dateTime)) в \(timeFormat.string(from: dateTime))"
        }
    }
}
