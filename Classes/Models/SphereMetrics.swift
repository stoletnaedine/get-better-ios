//
//  SphereMetrics.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 25.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct SphereMetrics {
    
    let values: [String : Double]
    
    func sortedValues() -> [(key: String, value: Double)] {
        return values.sorted(by: { $0.key > $1.key })
    }
    
    func notValid() -> Bool {
        let valuesSpheres = values.map { $0.key }.sorted()
        let spheres = Sphere.allCases.map { $0.rawValue }.sorted()
        let sphereValues = values.map { $0.value }
        
        return spheres != valuesSpheres
            || sphereValues.contains(Properties.notValidSphereValue)
    }
}
