//
//  TipMapper.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 12.09.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class TipMapper {
    
    func map(tip: Tip) -> [String : Any] {
        return [
            TipField.id.rawValue : tip.id,
            TipField.title.rawValue : tip.title,
            TipField.text.rawValue : tip.text
        ]
    }
    
    func map(entity: NSDictionary?) -> Tip {
        return Tip(id: entity?[TipField.id.rawValue] as? Int ?? 0,
                   title: entity?[TipField.title.rawValue] as? String ?? "",
                   text: entity?[TipField.text.rawValue] as? String ?? "")
    }
}

enum TipField: String {
    case id
    case title
    case text
}
