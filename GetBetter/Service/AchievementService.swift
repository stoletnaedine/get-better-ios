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
    
    func getAchievements() -> [Achievement] {
        let regularThree = Achievement(icon: "⚡️", title: "Хороший старт", description: "Добавлять по 1 событию 3 дня подряд", unlocked: false)
        let regularFive = Achievement(icon: "🖐", title: "Дай пять!", description: "Добавлять по 1 событию 5 дней подряд", unlocked: false)
        let regularSeven = Achievement(icon: "🤘", title: "Эта неделя была ок", description: "Добавлять по 1 событию 7 дней подряд", unlocked: false)
        let regularTen = Achievement(icon: "😎", title: "Более лучше стал ты", description: "Добавлять по 1 событию 10 дней подряд", unlocked: false)
        let plusOne = Achievement(icon: "🌠", title: "Скоростной", description: "Набрать 1 балл в Сфере меньше, чем за 10 дней", unlocked: false)
        let finishTen = Achievement(icon: "🏆", title: "Прокачано", description: "Прокачать любую Сферу до 10 баллов", unlocked: false)
        let byeLooser = Achievement(icon: "👻", title: "Прощай, лузер", description: "Выйти в любой Сфере из красной зоны", unlocked: false)
        
        return [regularThree, regularFive, regularSeven, regularTen, plusOne, finishTen, byeLooser]
    }
}
