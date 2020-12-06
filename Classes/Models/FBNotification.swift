//
//  FBNotification.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 06.12.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct FBNotification {
    let topic: NotificationTopic
    let isSubscribe: Bool
}

enum NotificationTopic: String {
    case daily
    case tipOfTheDay
}
