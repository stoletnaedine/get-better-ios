//
//  RestService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 27.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class URLSessionService {
    
    func responseData(from url: String, completion: @escaping ((Data?, AppError?) -> ())) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                completion(data, AppError(error: error))
            }.resume()
        }
    }
}
