//
//  FBNotificationMapper.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 06.12.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class NotificationMapper {
    
    func map(settings: NotificationSettings) -> [String : Any] {
        return [
            NotificationTopic.daily.rawValue : settings.daily,
            NotificationTopic.tipOfTheDay.rawValue : settings.tipOfTheDay
        ]
    }
    
    func map(entity: NSDictionary?) -> NotificationSettings {
        let dailySubscribe = entity?[NotificationTopic.daily.rawValue] as? Bool ?? false
        let tipOfTheDaySubscribe = entity?[NotificationTopic.tipOfTheDay.rawValue] as? Bool ?? false
        
        return NotificationSettings(
            daily: dailySubscribe,
            tipOfTheDay: tipOfTheDaySubscribe
        )
    }
}
