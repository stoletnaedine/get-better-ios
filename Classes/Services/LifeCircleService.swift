//
//  LifeCirclePresenter.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 04.08.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol LifeCircleService {
    func loadUserData(completion: @escaping (UserData?) -> Void)
    func averageCurrentSphereValue() -> Double
    func daysFromUserCreation() -> Int
    func mostLessPopularSphere() -> (mostPopularSphere: Sphere?, lessPopularSphere: Sphere?)
}

class LifeCircleServiceDefault: LifeCircleService {
    private let database: GBDatabase = FirebaseDatabase()
    private var startSphereMetrics: SphereMetrics?
    private var currentSphereMetrics: SphereMetrics?
    private var posts: [Post] = []
    
    func loadUserData(completion: @escaping (UserData?) -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        database.getPosts { [weak self] result in
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
        database.getStartSphereMetrics { [weak self] result in
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
            guard let self = self else {
                completion(nil)
                return
            }
            let spheresInPosts = self.posts.map { $0.sphere }
            guard let startSphereMetrics = self.startSphereMetrics else {
                completion(nil)
                return
            }
            var currentSphereMetricsValues = startSphereMetrics.values

            // Коэффициент давности. Равен 1,0 и уменьшается на 0,1 каждые 100 дней.
            let basePrescriptionRate: Double = 1.0
            let decrementRate: Double = 0.1
            let daysFromUserCreation = self.daysFromUserCreation()
            let prescriptionRate = basePrescriptionRate - ((Double(daysFromUserCreation) / 100) * decrementRate)
            
            currentSphereMetricsValues.forEach { sphere, value in
                currentSphereMetricsValues[sphere] = value * prescriptionRate
            }
            
            // Прибавляем баллы за посты
            let diffValue: Double = 0.1
            let maxValue: Double = 10.0
            let multiplier: Double = 10.0
            
            spheresInPosts.forEach { sphere in
                if let sphere = sphere?.rawValue,
                    let value = currentSphereMetricsValues[sphere],
                    value < maxValue {
                    let newValue = (value * multiplier + diffValue * multiplier) / multiplier
                    currentSphereMetricsValues[sphere] = newValue
                }
            }
            
            currentSphereMetricsValues.forEach { sphere, value in
                currentSphereMetricsValues[sphere] = value.rounded(toPlaces: 1)
            }
            
            self.currentSphereMetrics = SphereMetrics(values: currentSphereMetricsValues)
            completion((startSphereMetrics, self.currentSphereMetrics, self.posts))
        })
    }
    
    func daysFromUserCreation() -> Int {
        guard let userCreationDate = Auth.auth().currentUser?.metadata.creationDate else { return 0 }
        let daysFromUserCreation = Date.diffInDays(from: userCreationDate)
        return daysFromUserCreation
    }
    
    func averageCurrentSphereValue() -> Double {
        let values = self.currentSphereMetrics?.values.map { $0.value } ?? []
        return values.average().rounded(toPlaces: 2)
    }
    
    func mostLessPopularSphere() -> (mostPopularSphere: Sphere?, lessPopularSphere: Sphere?) {
        if posts.count > 3 {
            let spheres = posts.map { $0.sphere }
            let spheresDict = spheres.map { ($0, 1) }
            let spheresCount = Dictionary(spheresDict, uniquingKeysWith: +)

            let mostPopularSphere = spheresCount.max(by: { $0.value < $1.value })?.key
            let lessPopularSphere = spheresCount.max(by: { $0.value > $1.value })?.key
            
            return (mostPopularSphere, lessPopularSphere)
        } else {
            return (nil, nil)
        }
    }
}
