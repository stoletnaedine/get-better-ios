//
//  AnimationName.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 07.11.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

enum AnimationName {
    case spark
    case confetti
    case yoga
    case loadingSuccess
    case loadingError
    case travel

    static let mapper: [AnimationName: String] = [
        .spark: "15046-spark-animation",
        .confetti: "37723-confetti-partyyy",
        .yoga: "28592-yoga-nature",
        .loadingSuccess: "35255-from-loading-to-success",
        .loadingError: "35256-from-loading-to-error",
        .travel: "19904-ski-touring-backcountry-skiing"
    ]

    var value: String {
        return AnimationName.mapper[self]!
    }
}
