//
// Created by Artur Islamgulov on 08.06.2020.
// Copyright (c) 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}