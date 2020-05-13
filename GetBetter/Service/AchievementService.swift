//
//  AchievementService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 12.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class AchievementService {
    
    var posts: [Post] = []
    var sphereMetrics: SphereMetrics?
    
    func getAchievements() -> [Achievement] {
        let regularThree = Achievement(icon: "⚡️", title: "Хороший старт", description: "Добавлять по 1 событию 3 дня подряд", unlocked: isAchievementUnlocked(daysInRowCondition: 3))
        let regularFive = Achievement(icon: "🖐", title: "Дай пять!", description: "Добавлять по 1 событию 5 дней подряд", unlocked: isAchievementUnlocked(daysInRowCondition: 5))
        let regularSeven = Achievement(icon: "🤘", title: "Эта неделя была ок", description: "Добавлять по 1 событию 7 дней подряд", unlocked: isAchievementUnlocked(daysInRowCondition: 7))
        let regularTen = Achievement(icon: "😎", title: "Более лучше стал ты", description: "Добавлять по 1 событию 10 дней подряд", unlocked: isAchievementUnlocked(daysInRowCondition: 10))
        let plusOne = Achievement(icon: "🌠", title: "Скоростной", description: "Набрать 1 балл в Сфере меньше, чем за 10 дней", unlocked: false)
        let finishTen = Achievement(icon: "🏆", title: "Прокачано", description: "Прокачать любую Сферу до 10 баллов", unlocked: false)
        let byeLooser = Achievement(icon: "👻", title: "Прощай, лузер", description: "Выйти в любой Сфере из красной зоны", unlocked: false)
        
        return [regularThree, regularFive, regularSeven, regularTen, plusOne, finishTen, byeLooser]
    }
    
    func isAchievementUnlocked(daysInRowCondition: Int) -> Bool {
        if posts.isEmpty { return false }
        
        let days = posts
            .map { Date(timeIntervalSince1970: Double($0.timestamp ?? 0)) }
            .map { $0.diffInDays() }
        
        let daysSet = Set(days).sorted()
        print("daysSet=\(daysSet)")
        
        var countDaysInRowArray: [Int] = []
        var daysInRowCounter = 1
        var prevDay = daysSet.first ?? 0
        
        for day in daysSet {
            print("- day=\(day)")
            print("- prevDay=\(prevDay)")
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
                print("iter \(day)")
                daysInRowCounter += 1
                prevDay = day
            }
        }
        
        let maxCountDaysInRow = countDaysInRowArray.max() ?? 0
        
        print("daysInRowCondition=\(daysInRowCondition)")
        print("countDaysInRowArray=\(countDaysInRowArray)")
        print("maxCountDaysInRow=\(maxCountDaysInRow)")
        print("________________________")
        
        return maxCountDaysInRow >= daysInRowCondition
    }
}
