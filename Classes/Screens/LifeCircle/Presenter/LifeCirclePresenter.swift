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
    func averageCurrentSphereValue() -> Double
    func averageStartSphereValue() -> Double
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
            guard let self = self else { return }
            let spheresInPosts = self.posts.map { $0.sphere }
            
            // Посты с фото получают больше?
//            let spheresInPostsWithPhoto = posts
//                .filter { !($0.photoName ?? "").isEmpty }
//                .map { $0.sphere }
            guard let startSphereMetrics = self.startSphereMetrics else { return }
            var currentSphereMetricsValues = startSphereMetrics.values
            
            let diffValue = 0.1
            let maxValue = 10.0

            // Calc values
//            let spheres = spheresInPosts + spheresInPostsWithPhoto
            spheresInPosts.forEach { sphere in
                if let sphereString = sphere?.rawValue,
                    let sphereValue = currentSphereMetricsValues[sphereString],
                    sphereValue < maxValue {
                    let newValue = (sphereValue * 10 + diffValue * 10) / 10
                    currentSphereMetricsValues[sphereString] = newValue
                }
            }
            
            guard let userCreationDate = Auth.auth().currentUser?.metadata.creationDate else { return }
            let daysFromUserCreation = Date.diffInDays(from: userCreationDate)
            // Минус 1 балл за 300 дней. Нужна аналитика.
            let reductionValue: Double = Double(daysFromUserCreation / 30).rounded(toPlaces: 1)
            
            currentSphereMetricsValues.forEach { key, value in
                let decreaseValue = (value * 10 - reductionValue) / 10
                currentSphereMetricsValues[key] = decreaseValue
            }

            self.currentSphereMetrics = SphereMetrics(values: currentSphereMetricsValues)
            completion((startSphereMetrics, self.currentSphereMetrics, self.posts))
        })
    }
    
    func averageCurrentSphereValue() -> Double {
        let values = self.currentSphereMetrics?.values.map { $0.value } ?? []
        return values.average().rounded(toPlaces: 2)
    }
    
    func averageStartSphereValue() -> Double {
        let values = self.startSphereMetrics?.values.map { $0.value } ?? []
        return values.average().rounded(toPlaces: 2)
    }
}
