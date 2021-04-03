//
//  Photo.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 06.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct Photo {
    let main: PhotoNameURL
    var preview: PhotoNameURL?
}

struct PhotoNameURL {
    let name: String?
    let url: String
}
