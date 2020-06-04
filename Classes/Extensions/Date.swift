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
    
    static func convertToMonthYear(from timestamp: Int64) -> String {
        let timestampDouble = Double(timestamp)
        let date = Date(timeIntervalSince1970: timestampDouble)
        let calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        return "\(monthRus(monthIndex: month)) \(year)"
    }
    
    static func convertToDateWithWeekday(from timestamp: Int64) -> String {
        let timestampDouble = Double(timestamp)
        let date = Date(timeIntervalSince1970: timestampDouble)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMMM, EEEE"
        dayTimePeriodFormatter.locale = Locale(identifier: "ru_RU")
        return dayTimePeriodFormatter.string(from: date as Date)
    }
    
    static func currentDateWithWeekday() -> String {
        return convertToDateWithWeekday(from: Int64(Date().timeIntervalSince1970))
    }
    
    func diffInDays() -> Int {
        return Calendar.current.dateComponents([.day], from: .init(timeIntervalSince1970: 0), to: self).day ?? 0
    }
    
    private static func monthRus(monthIndex: Int) -> String {
        switch monthIndex {
        case 1:
            return "Январь"
        case 2:
            return "Февраль"
        case 3:
            return "Март"
        case 4:
            return "Апрель"
        case 5:
            return "Май"
        case 6:
            return "Июнь"
        case 7:
            return "Июль"
        case 8:
            return "Август"
        case 9:
            return "Сентябрь"
        case 10:
            return "Октябрь"
        case 11:
            return "Ноябрь"
        case 12:
            return "Декабрь"
        default:
            return "Хм, какой это месяц?"
        }
    }
}
