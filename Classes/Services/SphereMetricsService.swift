//
//  SphereMetricsService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 05.12.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

protocol SphereMetricsService {
    func text(for sphere: Sphere, userData: UserData) -> String
}

class SphereMetricsServiceDefault: SphereMetricsService {
    
    let lifeCircleService: LifeCircleService = LifeCircleServiceDefault()
    
    func text(for sphere: Sphere, userData: UserData) -> String {
        guard let startAll = userData.start,
              let startValue = startAll.values[sphere.rawValue],
              let currentAll = userData.current,
              let currentValue = currentAll.values[sphere.rawValue],
              !userData.posts.isEmpty else { return "" }
        
        let spherePosts = userData.posts
            .filter({ $0.sphere == sphere })
            .sorted(by: { $0.timestamp ?? 0 < $1.timestamp ?? 0 })
        
        var maxValuePredictionDate = ""
        if currentValue < Properties.maxSphereValue {
            let date = getMaxValuePredictionDate(spherePosts: spherePosts, startValue: startValue)
            maxValuePredictionDate = "\n\n💻 Суперкомпьютер даёт прогноз: при том же темпе ты достигнешь десяти баллов \(date).\n\n"
        }
        
        let postsCount = spherePosts.count
        
        let rating = mostLessPopularSphere(posts: userData.posts)
        var isPopularOrNot = ""
        
        if currentValue == Properties.maxSphereValue {
            isPopularOrNot = "💜 Невероятно!\nСфера \(sphere.icon)\(sphere.name) проработана на максимум.\nТеперь можешь обратить внимание на другие сферы.\n\n"
        } else if currentValue > startValue {
            isPopularOrNot = "🚀 Отлично!\nТы прокачиваешь \(sphere.icon)\(sphere.name) и это заметно.\n\n"
        } else {
            isPopularOrNot = "😔 Ой! Если ты не фиксируешь события, значение сферы будет понемногу уменьшаться.\n\n"
        }
        if sphere == rating.mostPopularSphere {
            isPopularOrNot = "🤩 Потрясающе! Ты уделяешь сфере \(sphere.icon)\(sphere.name) больше всего внимания!\n\n"
        }
        if sphere == rating.lessPopularSphere {
            isPopularOrNot = "❗️ Обрати внимание. Ты совсем не занимаешься этой сферой (или забываешь писать о ней).\n\n"
        }
        
        let text = "\(isPopularOrNot)📈 Немного статистики:\n🌘 Начальное значение — \(startValue)\n🌖 Текущее значение — \(currentValue)\n\n✍️ Написано постов — \(postsCount)\(maxValuePredictionDate)"
        
        return text
    }
    
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
    
    private func getMaxValuePredictionDate(spherePosts: [Post], startValue: Double) -> String {
        guard let userCreationDate = lifeCircleService.userCreationDate() else { return "" }
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
