//
//  Collection+Extension.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 04.08.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

extension Sequence where Element: AdditiveArithmetic {

    func sum() -> Element { reduce(.zero, +) }

}

extension Collection where Element: BinaryInteger {

    func average() -> Element {
        isEmpty ? .zero : sum() / Element(count)
    }

    func average<T: FloatingPoint>() -> T {
        isEmpty ? .zero : T(sum()) / T(count)
    }

}

extension Collection where Element: BinaryFloatingPoint {

    func average() -> Element {
        isEmpty ? .zero : Element(sum()) / Element(count)
    }

}
