//
//  PostPhotos.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 06.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct PostPhotos {
    let photos: [PhotoNameURL]
    var preview: PhotoNameURL?
}

struct PhotoNameURL {
    let order: Int?
    let name: String
    let url: String

    init(order: Int? = nil, name: String, url: String) {
        self.order = order
        self.name = name
        self.url = url
    }
}
