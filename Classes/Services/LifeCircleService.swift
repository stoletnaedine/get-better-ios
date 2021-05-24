//
//  LifeCirclePresenter.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 04.08.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol LifeCircleServiceProtocol {
    func loadUserData(completion: @escaping (UserData?) -> Void)
    func averageCurrentSphereValue() -> Double
    func daysFromUserCreation() -> Int
    func calcPrescriptionRate() -> Double
    func userCreationDate() -> Date?
}

class LifeCircleService: LifeCircleServiceProtocol {
    
    private let database: DatabaseProtocol = FirebaseDatabase()
    private let userSettingsService: UserSettingsServiceProtocol = UserSettingsService()
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
            let spheresInPosts = self.posts
                .filter { $0.notAddSphereValue == false }
                .map { $0.sphere }
            guard let startSphereMetrics = self.startSphereMetrics else {
                completion(nil)
                return
            }
            var currentSphereMetricsValues = startSphereMetrics.values

            let prescriptionRate = self.calcPrescriptionRate()
            
            currentSphereMetricsValues.forEach { sphere, value in
                currentSphereMetricsValues[sphere] = value * prescriptionRate
            }
            
            // Прибавляем баллы за посты
            let diffValue: Double = 0.1
            let maxValue: Double = Properties.maxSphereValue
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
                let newValue = value.rounded(toPlaces: 1) > maxValue
                    ? maxValue
                    : value.rounded(toPlaces: 1)
                currentSphereMetricsValues[sphere] = newValue
            }
            
            self.currentSphereMetrics = SphereMetrics(values: currentSphereMetricsValues)
            completion((startSphereMetrics, self.currentSphereMetrics, self.posts))
        })
    }
    
    /// Коэффициент давности. Равен 1,0 и уменьшается на 0,1 каждые daysForDecrement дней.
    /// - Returns: Коэффициент давности
    func calcPrescriptionRate() -> Double {
        let basePrescriptionRate: Double = 1.0
        let decrementRate: Double = 0.1
        let daysForDecrement: Double = userSettingsService.getDifficultyLevel().daysForDecrement
        let daysFromUserCreation = self.daysFromUserCreation()
        let prescriptionRate = basePrescriptionRate - ((Double(daysFromUserCreation) / daysForDecrement) * decrementRate)
        return prescriptionRate
    }
    
    func userCreationDate() -> Date? {
        return Auth.auth().currentUser?.metadata.creationDate
    }
    
    func daysFromUserCreation() -> Int {
        guard let userCreationDate = self.userCreationDate() else { return 0 }
        let daysFromUserCreation = Date.diffInDays(from: userCreationDate)
        return daysFromUserCreation
    }
    
    func averageCurrentSphereValue() -> Double {
        let values = self.currentSphereMetrics?.values.map { $0.value } ?? []
        return values.average().rounded(toPlaces: 2)
    }
}
