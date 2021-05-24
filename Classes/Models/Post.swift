//
//  Post.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 21.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct Post {
    init(id: String?,
         text: String?,
         sphere: Sphere?,
         timestamp: Int64?,
         // Deprecated (с версии 2.0 это поле содержится в массиве 'photos')
         photoUrl: String? = nil,
         // Deprecated (с версии 2.0 это поле содержится в массиве 'photos')
         photoName: String? = nil,
         previewUrl: String?,
         previewName: String?,
         photos: [PhotoNameURL]?,
         notAddSphereValue: Bool) {
        self.id = id
        self.text = text
        self.sphere = sphere
        self.timestamp = timestamp
        self.photoUrl = photoUrl
        self.photoName = photoName
        self.previewUrl = previewUrl
        self.previewName = previewName
        self.photos = photos
        self.notAddSphereValue = notAddSphereValue
    }

    let id: String?
    let text: String?
    let sphere: Sphere?
    let timestamp: Int64?
    let photoUrl: String?
    let photoName: String?
    let previewUrl: String?
    let previewName: String?
    let photos: [PhotoNameURL]?
    let notAddSphereValue: Bool
}
