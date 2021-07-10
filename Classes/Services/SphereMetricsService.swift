//
//  SphereMetricsService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 05.12.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol SphereMetricsServiceProtocol {
    func text(for sphere: Sphere, userData: UserData) -> String
}

class SphereMetricsService: SphereMetricsServiceProtocol {
    
    let lifeCircleService: LifeCircleServiceProtocol = LifeCircleService()
    
    func text(for sphere: Sphere, userData: UserData) -> String {
        guard let startAll = userData.start,
              let startValue = startAll.values[sphere.rawValue],
              let currentAll = userData.current,
              let currentValue = currentAll.values[sphere.rawValue] else { return "" }
        
        let spherePosts = userData.posts
            .filter { $0.sphere == sphere }
            .sorted(by: { $0.timestamp ?? 0 < $1.timestamp ?? 0 })
        
        var isPopularOrNot = ""
        var warning = ""
        let postsCount = spherePosts.count
        let postCountResult = postsCount == .zero
            ? R.string.localizable.sphereDetailPostsEmpty()
            : R.string.localizable.sphereDetailPostsNotEmpty("\(postsCount)")

        let values = R.string.localizable.sphereDetailStartValue(startValue.toString(), currentValue.toString())

        let sphereString = "\(sphere.icon)\u{00a0}\(sphere.name)"
        var userNameString = ""
        if let userName = Auth.auth().currentUser?.displayName {
            userNameString = ", \(userName)"
        }
        if currentValue == Properties.maxSphereValue {
            isPopularOrNot = R.string.localizable.sphereDetailMax(userNameString, sphereString)
        } else if currentValue > startValue {
            isPopularOrNot = R.string.localizable.sphereDetailGood(userNameString, sphereString)
        } else if currentValue < startValue {
            warning = R.string.localizable.sphereDetailWarning()
        }
        
        let rating = mostLessPopularSphere(posts: userData.posts)
        if sphere == rating.mostPopularSphere {
            isPopularOrNot = R.string.localizable.sphereDetailMaxAttention(userNameString, sphereString)
        }
        if sphere == rating.lessPopularSphere {
            isPopularOrNot = R.string.localizable.sphereDetailMinAttention(userNameString)
        }
        
        var maxValuePredictionDate = ""
        if currentValue < Properties.maxSphereValue && postsCount > 2,
           let date = getMaxValuePredictionDate(spherePosts: spherePosts, startValue: startValue) {
            maxValuePredictionDate = R.string.localizable.sphereDetailSuperComputer(date)
        }
        
        return "\(isPopularOrNot)\(postCountResult)\(values)\(warning)\(maxValuePredictionDate)"
    }

    // MARK: — Private methods
    
    private func mostLessPopularSphere(posts: [Post]) -> (mostPopularSphere: Sphere?, lessPopularSphere: Sphere?) {
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
    
    private func getMaxValuePredictionDate(spherePosts: [Post], startValue: Double) -> String? {
        guard !spherePosts.isEmpty,
              let userCreationDate = lifeCircleService.userCreationDate() else { return nil }
        let userCreationTimestamp = Int64(userCreationDate.timeIntervalSince1970)
        let currentTimestamp = Date.currentTimestamp
        let diffTimestamp = currentTimestamp - userCreationTimestamp
        let prescriptionRate = lifeCircleService.calcPrescriptionRate()
        let averagePostTime = diffTimestamp / Int64(spherePosts.count)
        let diffSphereValue = Properties.maxSphereValue - (startValue * prescriptionRate)
        let needPostsCount: Int = Int(diffSphereValue * 10)
        let predictionTimestamp = userCreationTimestamp + (averagePostTime * Int64(needPostsCount))
        
        return Date.convertToFullDate(from: predictionTimestamp)
    }
}
