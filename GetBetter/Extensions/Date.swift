//
//  Date.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 21.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

extension Date {
    
    static var currentTimestamp: Int64 {
        return Int64(Date().timeIntervalSince1970)
    }
    
    static func convertToFullDate(from timestamp: Int64) -> String {
        let timestampDouble = Double(timestamp)
        let date = Date(timeIntervalSince1970: timestampDouble)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale(identifier: "ru_RU")
        dayTimePeriodFormatter.dateFormat = "dd MMM YYYY HH:mm"
        return dayTimePeriodFormatter.string(from: date as Date)
    }
    
    static func convertToDate(from timestamp: Int64) -> String {
        let timestampDouble = Double(timestamp)
        let date = Date(timeIntervalSince1970: timestampDouble)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "YYYY/MM/dd"
        return dayTimePeriodFormatter.string(from: date as Date)
    }
    
    static func convertToDateWithWeekday(from timestamp: Int64) -> String {
        let timestampDouble = Double(timestamp)
        let date = Date(timeIntervalSince1970: timestampDouble)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM"
        dayTimePeriodFormatter.locale = Locale(identifier: "ru_RU")
        let dateFormat = dayTimePeriodFormatter.string(from: date as Date)
        let calendar = Calendar(identifier: .gregorian)
        let weekdayIndex = calendar.component(.weekday, from: date)
        return "\(dateFormat), \(weekdayRus(dayIndex: weekdayIndex))"
    }
    
    static func currentDateWithWeekday() -> String {
        return convertToDateWithWeekday(from: Int64(Date().timeIntervalSince1970))
    }
    
    private static func weekdayRus(dayIndex: Int) -> String {
        switch dayIndex {
        case 1:
            return "воскресенье"
        case 2:
            return "понедельник"
        case 3:
            return "вторник"
        case 4:
            return "среда"
        case 5:
            return "четверг"
        case 6:
            return "пятница"
        default:
            return "суббота"
        }
    }
}
