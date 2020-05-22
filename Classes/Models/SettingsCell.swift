//
//  SettingsCell.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 29.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import UIKit

struct SettingsCell {
    let title: String
    let viewController: UIViewController
}

enum TableSection: Int {
    case profile = 0, articles, settings
}
