//
//  AchievementService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 12.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class AchievementService {
    
    let firebaseDatabaseService = FirebaseDatabaseService()
    var posts: [Post] = []
    
    func check() {
        
    }
    
    func saveStartAchievements() {
        let regularThree = Achievement(id: "regular3", icon: "⚡️", title: "Хороший старт", description: "Добавлять по 1 событию 3 дня подряд", unlocked: false)
        let regularFive = Achievement(id: "regular5", icon: "🖐", title: "Дай пять!", description: "Добавлять по 1 событию 5 дней подряд", unlocked: false)
        let regularSeven = Achievement(id: "regular7", icon: "🤘", title: "Эта неделя была ок", description: "Добавлять по 1 событию 7 дней подряд", unlocked: false)
        let regularTen = Achievement(id: "regular10", icon: "😎", title: "Более лучше стал ты", description: "Добавлять по 1 событию 10 дней подряд", unlocked: false)
        let plusOne = Achievement(id: "plus1", icon: "🌠", title: "Скоростной", description: "Набрать 1 балл в Сфере меньше, чем за 10 дней", unlocked: false)
        let finishTen = Achievement(id: "finish10", icon: "🏆", title: "Прокачано", description: "Прокачать любую Сферу до 10 баллов", unlocked: false)
        let byeLooser = Achievement(id: "byeLooser", icon: "👻", title: "Прощай, лузер", description: "Выйти в любой Сфере из красной зоны", unlocked: false)
        
        let achievements = [regularThree, regularFive, regularSeven, regularTen, plusOne, finishTen, byeLooser]
        for achievement in achievements {
            firebaseDatabaseService.saveAchievement(achievement)
        }
    }
}
