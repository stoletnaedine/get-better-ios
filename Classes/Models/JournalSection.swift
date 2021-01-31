//
//  JournalSection.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 01.11.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

struct JournalSection {
    let type: SectionType
    let header: Header?
    let posts: [Post]?
    
    init(type: JournalSection.SectionType, header: JournalSection.Header? = nil, posts: [Post]? = nil) {
        self.type = type
        self.header = header
        self.posts = posts
    }
    
    enum SectionType {
        case post
        case empty(info: String)
    }
    
    struct Header {
        let month: String
        let postsCount: String
    }
}

