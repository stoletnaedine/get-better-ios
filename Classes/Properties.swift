//
//  Properties.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 16.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

enum Properties {
    static let notValidSphereValue = -1.0
    static let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let appStoreUrl = URL(string: "https://apps.apple.com/us/app/getbetter/id1522666671?uo=4")!
    static let stoletnaedineTelegram = URL(string: "https://t.me/stoletnaedine")!
    static let maxSphereValue: Double = 10.0
}
