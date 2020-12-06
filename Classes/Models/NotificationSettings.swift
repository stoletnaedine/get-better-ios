//
//  NotificationSettings.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 06.12.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct NotificationSettings {
    let daily: Bool
    let tipOfTheDay: Bool
}

enum NotificationTopic: String {
    case daily
    case tipOfTheDay
}
