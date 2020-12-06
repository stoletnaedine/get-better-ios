//
//  FBNotificationMapper.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 06.12.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class NotificationMapper {
    
    func map(notification: FBNotification) -> [String : Any] {
        return [
            FBNotificationField.topic.rawValue : notification.topic.rawValue,
            FBNotificationField.isSubscribe.rawValue : notification.isSubscribe
        ]
    }
    
    func map(entity: NSDictionary?) -> FBNotification? {
        guard let topicName = entity?[FBNotificationField.topic.rawValue] as? String,
              let topic = NotificationTopic(rawValue: topicName) else { return nil }
        
        return FBNotification(
            topic: topic,
            isSubscribe: entity?[FBNotificationField.isSubscribe.rawValue] as? Bool ?? false
        )
    }
}

enum FBNotificationField: String {
    case topic
    case isSubscribe
}
