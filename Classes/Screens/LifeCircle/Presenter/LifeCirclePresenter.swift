//
//  LifeCirclePresenter.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 04.08.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol LifeCirclePresenter {
    func loadUserData(completion: @escaping (UserData) -> Void)
    func averageSphereValue() -> Double
}

class LifeCirclePresenterDefault: LifeCirclePresenter {
    
    private let databaseService: DatabaseService = FirebaseDatabaseService()
    private var startSphereMetrics: SphereMetrics?
    private var currentSphereMetrics: SphereMetrics?
    private var posts: [Post] = []
    
    func loadUserData(completion: @escaping (UserData) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        databaseService.getPosts { [weak self] result in
            switch result {
            case .success(let postsFromDB):
                self?.posts = postsFromDB
                dispatchGroup.leave()
            default:
                dispatchGroup.leave()
                break
            }
        }
        
        dispatchGroup.enter()
        databaseService.getStartSphereMetrics { [weak self] result in
            switch result {
            case .success(let sphereMetrics):
                self?.startSphereMetrics = sphereMetrics
                dispatchGroup.leave()
            default:
                dispatchGroup.leave()
                break
            }
        }
        
        dispatchGroup.notify(queue: .global(), execute: { [weak self] in
            let spheresInPosts = self?.posts.map { $0.sphere }
            guard let startSphereMetrics = self?.startSphereMetrics else { return }
            var currentSphereMetricsValues = startSphereMetrics.values
            
            let diffValue = 0.1
            let maxValue = 10.0

            // Calc values
            spheresInPosts?.forEach { sphere in
                if let sphereString = sphere?.rawValue,
                    let sphereValue = currentSphereMetricsValues[sphereString],
                    sphereValue < maxValue {
                    let newValue = (sphereValue * 10 + diffValue * 10) / 10
                    currentSphereMetricsValues[sphereString] = newValue
                }
            }
            
            guard let userCreationDate = Auth.auth().currentUser?.metadata.creationDate else { return }
            let daysFromUserCreation = Date.diffInDays(from: userCreationDate)
            // 1 балл за 200 дней
            let reductionValue: Double = Double(daysFromUserCreation / 20).rounded(toPlaces: 1)
            
            currentSphereMetricsValues.forEach { key, value in
                let decreaseValue = (value * 10 - reductionValue) / 10
                currentSphereMetricsValues[key] = decreaseValue
            }

            self?.currentSphereMetrics = SphereMetrics(values: currentSphereMetricsValues)
            guard let currentSphereMetrics = self?.currentSphereMetrics else { return }
            guard let posts = self?.posts else { return }
            completion((startSphereMetrics,
                        currentSphereMetrics,
                        posts))
        })
    }
    
    func averageSphereValue() -> Double {
        let values = self.currentSphereMetrics?.values.map { $0.value } ?? []
        return values.average().rounded(toPlaces: 2)
    }
}
