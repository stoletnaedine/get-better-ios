//
//  SettingsSection.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 29.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

struct SettingsSection {
    let type: SettingsSectionType
    let cells: [SettingsCell]
}

enum SettingsSectionType {
    case profile
    case tips
    case articles
    case notifications
    case aboutApp
}

struct SettingsCell {
    let title: String?
    let subTitle: String?
    let action: VoidClosure?
    
    init(title: String? = nil, subTitle: String? = nil, action: VoidClosure? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.action = action
    }
}
