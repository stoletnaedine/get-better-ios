//
//  SettingsCellViewModel.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 29.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

struct SettingsCellViewModel {
    let type: SettingsCellType
    let cell: SettingsCell
}

enum SettingsCellType {
    case profile
    case tips
    case push
    case difficultyLevel
    case aboutApp
    case version
}

struct SettingsCell {
    let title: String?
    let subtitle: String?
    let action: VoidClosure?
    
    init(title: String? = nil,
         subTitle: String? = nil,
         action: VoidClosure? = nil) {
        self.title = title
        self.subtitle = subTitle
        self.action = action
    }
}
