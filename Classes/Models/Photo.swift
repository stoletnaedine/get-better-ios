//
//  Photo.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 06.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct Photo {
    let photoUrl: String?
    let photoName: String?
    let previewUrl: String?
    let previewName: String?

    init(photoUrl: String? = nil, photoName: String? = nil, previewUrl: String? = nil, previewName: String? = nil) {
        self.photoUrl = photoUrl
        self.photoName = photoName
        self.previewUrl = previewUrl
        self.previewName = previewName
    }
}
