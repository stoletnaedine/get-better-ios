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
        dayTimePeriodFormatter.dateFormat = "YYYY/MM/dd HH:mm"
        return dayTimePeriodFormatter.string(from: date as Date)
    }
    
    static func convertToDate(from timestamp: Int64) -> String {
        let timestampDouble = Double(timestamp)
        let date = Date(timeIntervalSince1970: timestampDouble)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "YYYY/MM/dd"
        return dayTimePeriodFormatter.string(from: date as Date)
    }
}
