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
    
    func text(for sphere: Sphere, userData: UserData) -> String {
        guard let startAll = userData.start,
              let startValue = startAll.values[sphere.rawValue],
              let currentAll = userData.current,
              let currentValue = currentAll.values[sphere.rawValue],
              !userData.posts.isEmpty else { return "" }
        
        let postsSphere = userData.posts.filter({ $0.sphere == sphere })
        let postsCount = postsSphere.count
        
        let maxValuePredictionDate = "13.05.21"
        
        let rating = mostLessPopularSphere(posts: userData.posts)
        var isPopularOrNot = ""
        
        if currentValue > startValue {
            isPopularOrNot = "Хорошая работа!\nТы прокачиваешь \(sphere.icon)\(sphere.name) и это заметно.\n\n"
        } else {
            isPopularOrNot = "Ой! Если ты не фиксируешь события, значение сферы будет понемногу уменьшаться.\n\n"
        }
        if sphere == rating.mostPopularSphere {
            isPopularOrNot = "Потрясающе! Ты уделяешь сфере \(sphere.icon)\(sphere.name) больше всего внимания!\n\n"
        }
        if sphere == rating.lessPopularSphere {
            isPopularOrNot = "Обрати внимание! Ты совсем не занимаешься этой сферой.\n\n"
        }
        
        let text = "\(isPopularOrNot)Начальное значение — \(startValue)\nТекущее значение — \(currentValue)\n\nНаписано постов — \(postsCount)\n\nПри том же темпе ты достигнешь 10 баллов — \(maxValuePredictionDate)\n"
        
        return text
    }
    
    func mostLessPopularSphere(posts: [Post]) -> (mostPopularSphere: Sphere?, lessPopularSphere: Sphere?) {
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
