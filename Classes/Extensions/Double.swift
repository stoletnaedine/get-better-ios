//
//  Double.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 12.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

extension Double {

    func toString() -> String {
        return Locale.current.languageCode == "ru"
            ? String(self).replacingOccurrences(of: ".", with: ",")
            : String(self)
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
