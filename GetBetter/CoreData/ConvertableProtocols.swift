//
//  ConvertableProtocols.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 12.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

protocol PlainConvertable {
    func convertToCoreData() -> CoreDataConvertable?
}

protocol CoreDataConvertable {
    func convertToPlain() -> PlainConvertable
}
