//
//  Date.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 21.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

extension Date {
    static var currentTimestampString: String {
        return String(Int64(Date().timeIntervalSince1970 * 1000))
    }
    
    static func convertToDate(from timestampString: String) -> String {
        var dateString = ""
        if let timestampNumber = Double(timestampString) {
            let date = Date(timeIntervalSince1970: timestampNumber / 1000)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "dd/MM/YY HH:mm"
            dateString = dayTimePeriodFormatter.string(from: date as Date)
        }
        return dateString
    }
}
