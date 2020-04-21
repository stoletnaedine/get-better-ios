//
//  LocalDataService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 02.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class LocalDataService {
    
    func getDataFromLocalJson(from jsonName: String) -> Data? {
        if let url = Bundle.main.url(forResource: jsonName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                print("Error with getting data from local JSON")
            }
        }
        return nil
    }
}
