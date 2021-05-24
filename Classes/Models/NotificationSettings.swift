//
//  NotificationSettings.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 06.12.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct NotificationSettings {
    var tip: TipTopic
    var post: PostTopic
}

enum NotificationTopic: String {
    case tip
    case post
}

enum TipTopic: String, CaseIterable {
    /// tip6 — push "Совет дня" в 6 МСК и тд
    case none
    case tip6
    case tip8
    case tip10
    case tip12
    
    init(_ rawValue: String) {
        switch rawValue {
        case "tip6":
            self = .tip6
        case "tip8":
            self = .tip8
        case "tip10":
            self = .tip10
        case "tip12":
            self = .tip12
        default:
            self = .none
        }
    }
    
    var text: String {
        switch self {
        case .none:
            return R.string.localizable.pushNotificationsNotSelect()
        case .tip6:
            return R.string.localizable.pushNotificationsTip6()
        case .tip8:
            return R.string.localizable.pushNotificationsTip8()
        case .tip10 :
            return R.string.localizable.pushNotificationsTip10()
        case .tip12:
            return R.string.localizable.pushNotificationsTip12()
        }
    }
}

enum PostTopic: String, CaseIterable {
    /// tip16 — push "Итоги дня" в 16 МСК и тд
    case none
    case post16
    case post18
    case post20
    case post22
    
    init(_ rawValue: String) {
        switch rawValue {
        case "post16":
            self = .post16
        case "post18":
            self = .post18
        case "post20":
            self = .post20
        case "post22":
            self = .post22
        default:
            self = .none
        }
    }
    
    var text: String {
        switch self {
        case .none:
            return R.string.localizable.pushNotificationsNotSelect()
        case .post16:
            return R.string.localizable.pushNotificationsPost16()
        case .post18:
            return R.string.localizable.pushNotificationsPost18()
        case .post20 :
            return R.string.localizable.pushNotificationsPost20()
        case .post22:
            return R.string.localizable.pushNotificationsPost22()
        }
    }
}
