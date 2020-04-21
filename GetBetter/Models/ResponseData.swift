//
//  ResponseData.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 30.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class ResponseData {
    
    var data: Data? = nil
    var error: AppError?
    
    init(data: Data?, error: AppError?) {
        self.data = data
        self.error = error
    }
}
