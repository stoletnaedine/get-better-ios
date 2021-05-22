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
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd MMM YYYY HH:mm"
        return formatter.string(from: date)
    }
    
    static func convertToMonthYear(from timestamp: Int64) -> String {
        let timestampDouble = Double(timestamp)
        let date = Date(timeIntervalSince1970: timestampDouble)
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "LLLL YYYY"
        return formatter.string(from: date)
    }
    
    static func convertToDateWithWeekday(from timestamp: Int64) -> String {
        let timestampDouble = Double(timestamp)
        let date = Date(timeIntervalSince1970: timestampDouble)
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd MMMM, EEEE"
        return formatter.string(from: date)
    }
    
    static func currentDateWithWeekday() -> String {
        return convertToDateWithWeekday(from: Int64(Date().timeIntervalSince1970))
    }
    
    static func diffInDays(from date: Date) -> Int {
        let calendar = Calendar.current
        let fromDate = calendar.startOfDay(for: date)
        let currentDate = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: fromDate, to: currentDate)
        return components.day ?? 0
    }

    
    func diffInDaysSince1970() -> Int {
        return Calendar.current.dateComponents([.day], from: .init(timeIntervalSince1970: .zero), to: self).day ?? 0
    }

}
