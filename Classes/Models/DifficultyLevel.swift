//
//  DifficultyLevel.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 30.01.2021.
//  Copyright © 2021 Artur Islamgulov. All rights reserved.
//

import Foundation

enum DifficultyLevel: String, CaseIterable {
    case easy
    case medium
    case hard
    case hardcore
}

extension DifficultyLevel {
    
    static let nameMapper: [DifficultyLevel: String] = [
        .easy: R.string.localizable.settingsDiffLevelEasy(),
        .medium: R.string.localizable.settingsDiffLevelMedium(),
        .hard: R.string.localizable.settingsDiffLevelHard(),
        .hardcore: R.string.localizable.settingsDiffLevelHardcore()
    ]

    var name: String {
        return DifficultyLevel.nameMapper[self]!
    }
    
    static let daysMapper: [DifficultyLevel: Double] = [
        .easy: 300,
        .medium: 200,
        .hard: 100,
        .hardcore: 50
    ]

    var daysForDecrement: Double {
        return DifficultyLevel.daysMapper[self]!
    }
}
