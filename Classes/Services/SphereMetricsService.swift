//
//  SphereMetricsService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.07.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

typealias UserData = (start: SphereMetrics?, current: SphereMetrics?, posts: [Post])

protocol SphereMetricsService {
    func calcMetrics(completion: @escaping (UserData) -> Void)
}

class SphereMetricsServiceDefault: SphereMetricsService {
    
    private let databaseSevice: DatabaseService = FirebaseDatabaseService()
    
    func calcMetrics(completion: @escaping (UserData) -> Void) {
        
        var posts: [Post] = []
        var startSphereMetrics: SphereMetrics?
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        databaseSevice.getPosts(completion: { result in
            switch result {
            case .success(let postsFromDB):
                posts = postsFromDB
                dispatchGroup.leave()
            default:
                dispatchGroup.leave()
                break
            }
        })
        
        dispatchGroup.enter()
        databaseSevice.getSphereMetrics(from: GlobalDefinitions.SphereMetrics.start, completion: { result in
            switch result {
            case .success(let sphereMetrics):
                startSphereMetrics = sphereMetrics
                dispatchGroup.leave()
            default:
                dispatchGroup.leave()
                break
            }
        })
        
        dispatchGroup.notify(queue: .global(), execute: {
            let spheresInPosts = posts.map { $0.sphere }
            guard let startSphereMetrics = startSphereMetrics else { return }
            var currentSphereMetricsValues = startSphereMetrics.values
            
            let diffValue = 0.1
            let maxValue = 10.0

            spheresInPosts.forEach { sphere in
                if let sphereString = sphere?.rawValue,
                    let sphereValue = currentSphereMetricsValues[sphereString],
                    sphereValue < maxValue {
                    let newValue = (sphereValue * 10 + diffValue * 10) / 10
                    currentSphereMetricsValues[sphereString] = newValue
                }
            }

            let currentSphereMetrics = SphereMetrics(values: currentSphereMetricsValues)
            completion((startSphereMetrics, currentSphereMetrics, posts))
        })
    }
}
