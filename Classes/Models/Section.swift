//
//  Section.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 29.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

struct Section {
    let type: SectionType
    let cells: [Cell]
}

enum SectionType: Int {
    case profile
    case articles
    case notifications
    case version
}

struct Cell {
    let title: String?
    let subTitle: String?
    let action: (() -> Void)?
    
    init(title: String? = nil, subTitle: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.action = action
    }
}
