//
//  ParsingService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 16.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class ParsingService {

    func parse<T: Decodable>(type: T.Type, from data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let jsonContent = try decoder.decode(type.self, from: data)
            return jsonContent
        } catch {
            print("Error: Cannot parse JSON type: \(type)")
            return nil
        }
    }
}
