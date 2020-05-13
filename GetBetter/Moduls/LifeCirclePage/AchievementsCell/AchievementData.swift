//
//  AchievementService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 12.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class AchievementData {
    
    var sphereMetrics: SphereMetrics?
    var maxCountDaysInRow = 0
    
    func getAchievements(from posts: [Post]) -> [Achievement] {
        
        calcMaxCountDaysInRow(from: posts)
        
        let three = 3
        let five = 5
        let seven = 7
        let ten = 10
        
        let regularThree = Achievement(icon: "⚡️", title: "Хороший старт", description: "Добавлять события \(three) дня подряд (\(maxCountDaysInRow)/\(three))", unlocked: isAchievementUnlocked(daysInRowCondition: three))
        let regularFive = Achievement(icon: "🖐", title: "Дай пять!", description: "Добавлять события \(five) дней подряд (\(maxCountDaysInRow)/\(five))", unlocked: isAchievementUnlocked(daysInRowCondition: five))
        let regularSeven = Achievement(icon: "🤘", title: "Эта неделя была ок", description: "Добавлять события \(seven) дней подряд (\(maxCountDaysInRow)/\(seven))", unlocked: isAchievementUnlocked(daysInRowCondition: seven))
        let regularTen = Achievement(icon: "😎", title: "Более лучше стал ты", description: "Добавлять события \(ten) дней подряд (\(maxCountDaysInRow)/\(ten))", unlocked: isAchievementUnlocked(daysInRowCondition: ten))
        
        let plusOne = Achievement(icon: "🌠", title: "Скоростной", description: "Набрать 1 балл в любой Сфере меньше, чем за 10 дней", unlocked: false)
        let finishTen = Achievement(icon: "🏆", title: "Прокачано", description: "Прокачать любую Сферу до 10 баллов", unlocked: false)
        let byeLooser = Achievement(icon: "👻", title: "Прощай, лузер", description: "Выйти в любой Сфере из красной зоны", unlocked: false)
        
        return [regularThree, regularFive, regularSeven, regularTen, plusOne, finishTen, byeLooser]
    }
    
    private func isAchievementUnlocked(daysInRowCondition: Int) -> Bool {
        return maxCountDaysInRow >= daysInRowCondition
    }
    
    private func calcMaxCountDaysInRow(from posts: [Post]) {
        if posts.isEmpty { return }
        
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
        maxCountDaysInRow = countDaysInRowArray.max() ?? 0
    }
}
