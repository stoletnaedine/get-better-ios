//
//  Double.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 12.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

extension Double {
    
    func convertToRusString() -> String {
        return String(self).replacingOccurrences(of: ".", with: ",")
    }
}
