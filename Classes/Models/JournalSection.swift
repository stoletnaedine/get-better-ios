//
//  JournalSection.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 01.11.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

struct JournalSection {
    let type: JournalSectionType
    let header: String?
    let posts: [Post]?
    
    init(type: JournalSectionType, header: String? = nil, posts: [Post]? = nil) {
        self.type = type
        self.header = header
        self.posts = posts
    }
}

enum JournalSectionType {
    case post
    case empty(info: String)
}
