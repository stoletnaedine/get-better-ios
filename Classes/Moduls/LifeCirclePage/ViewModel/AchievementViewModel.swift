//
//  AchievementService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 12.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class AchievementViewModel {
    
    func getAchievements(posts: [Post], startSphereMetrics: SphereMetrics, currentSphereMetrics: SphereMetrics) -> [Achievement] {
        let daysAchievements = getDaysAchievements(posts: posts)
        let maxValueAchievements = getMaxValueAchievements(currentSphereMetrics: currentSphereMetrics)
        let fromRedZoneAchievements = getFromRedZoneAchievements(startSphereMetrics: startSphereMetrics, currentSphereMetrics: currentSphereMetrics)
        let plusOne = Achievement(icon: "🌠", title: "Скоростной", description: "Набрать 1 балл в любой Сфере меньше, чем за 10 дней", unlocked: false)
        
        let achievements = daysAchievements + maxValueAchievements + fromRedZoneAchievements + [plusOne]
        let sortedAchievemenets = achievements.sorted(by: { $0.unlocked && !$1.unlocked })
        return sortedAchievemenets
    }
    
    private func getDaysAchievements(posts: [Post]) -> [Achievement] {
        let three = 3
        let five = 5
        let seven = 7
        let ten = 10
        let maxCountDaysInRow = calcMaxCountDaysInRow(from: posts)
        
        let regularThree = Achievement(icon: "⚡️", title: "Not bad", description: "Добавлять события \(three) дня подряд (\(maxCountDaysInRow)/\(three))", unlocked: maxCountDaysInRow >= three)
        let regularFive = Achievement(icon: "🖐", title: "Дай пять!", description: "Добавлять события \(five) дней подряд (\(maxCountDaysInRow)/\(five))", unlocked: maxCountDaysInRow >= five)
        let regularSeven = Achievement(icon: "🤘", title: "Эта неделя была ок", description: "Добавлять события \(seven) дней подряд (\(maxCountDaysInRow)/\(seven))", unlocked: maxCountDaysInRow >= seven)
        let regularTen = Achievement(icon: "😎", title: "Более лучше стал ты", description: "Добавлять события \(ten) дней подряд (\(maxCountDaysInRow)/\(ten))", unlocked: maxCountDaysInRow >= ten)
        return [regularThree, regularFive, regularSeven, regularTen]
    }
    
    private func calcMaxCountDaysInRow(from posts: [Post]) -> Int {
        let days = posts
            .map { Date(timeIntervalSince1970: Double($0.timestamp ?? 0)) }
            .map { $0.diffInDays() }
        
        let daysSet = Set(days).sorted()
        var countDaysInRowArray: [Int] = []
        var daysInRowCounter = 1
        var prevDay = daysSet.first ?? 0
        
        for day in daysSet {
            if day == prevDay {
                continue
            }
            if day - prevDay != 1
                || day == daysSet.last {
                if day - prevDay == 1 {
                    daysInRowCounter += 1
                }
                countDaysInRowArray.append(daysInRowCounter)
                daysInRowCounter = 1
                prevDay = day
                continue
            }
            if day - prevDay == 1 {
                daysInRowCounter += 1
                prevDay = day
            }
        }
        return countDaysInRowArray.max() ?? 0
    }
    
    private func getMaxValueAchievements(currentSphereMetrics: SphereMetrics) -> [Achievement] {
        let maxValueSphereRawValues = currentSphereMetrics.values
            .filter { $0.value == 10.0 }
            .map { $0.key }
        
        if maxValueSphereRawValues.isEmpty {
            return []
        }
        
        let spheres = maxValueSphereRawValues.map { Sphere(rawValue: $0)?.name ?? "" }
        
        var spheresAchievements: [Achievement] = []
        if spheres.isEmpty {
            spheresAchievements = [Achievement(icon: "🏆", title: "Прокачано", description: "Прокачать любую Сферу до 10 баллов", unlocked: false)]
        } else {
            for sphere in spheres {
                spheresAchievements.append(Achievement(icon: "🏆", title: "\(sphere) на максимум", description: "Отличная работа! Сфера \(sphere) прокачена до 10 баллов", unlocked: true))
            }
        }

        return spheresAchievements
    }
    
    private func getFromRedZoneAchievements(startSphereMetrics: SphereMetrics, currentSphereMetrics: SphereMetrics) -> [Achievement] {
        let redZoneValue = 3.5
        let redZoneSpheresStart = startSphereMetrics.values
            .filter { $0.value < redZoneValue }
            .map { $0.key }
        
        if redZoneSpheresStart.isEmpty {
            return []
        }
        
        var resultSpheres: [String] = []
        
        let notRedZoneSpheresCurrent = currentSphereMetrics.values
            .filter { $0.value >= redZoneValue }
            .map { $0.key }
        
        for sphere in notRedZoneSpheresCurrent {
            if redZoneSpheresStart.contains(sphere) {
                resultSpheres.append(sphere)
            }
        }
        
        let fromRedZoneSpheres = resultSpheres.map { Sphere(rawValue: $0)?.name ?? "" }
        var byeLooser = Achievement(icon: "👻", title: "Прощай, лузер", description: "Выйти в любой Сфере из красной зоны", unlocked: false)
        if !fromRedZoneSpheres.isEmpty {
            let spheresString = fromRedZoneSpheres.joined(separator: ", ")
            byeLooser = Achievement(icon: "👻", title: "Прощай, лузер", description: "\(spheresString) теперь не в красной зоне (а вначале были)", unlocked: true)
        }
        
        return [byeLooser]
    }
}
