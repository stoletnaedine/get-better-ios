//
//  Date.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 21.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

extension Date {
    static var currentTimestampString: Int64 {
        return Int64(Date().timeIntervalSince1970)
    }
    
    static func convertToDate(from timestamp: Int64) -> String {
        let timestampDouble = Double(timestamp)
        let date = Date(timeIntervalSince1970: timestampDouble)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd/MM/YY HH:mm"
        return dayTimePeriodFormatter.string(from: date as Date)
    }
}
