//
//  PostMapper.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 28.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

class PostMapper {
    
    func map(post: Post) -> [String : Any] {
        return [
            PostField.text.rawValue : post.text ?? "",
            PostField.sphere.rawValue : post.sphere?.rawValue ?? "",
            PostField.timestamp.rawValue : post.timestamp ?? "",
            PostField.photoUrl.rawValue : post.photoUrl ?? "",
            PostField.photoName.rawValue : post.photoName ?? "",
            PostField.previewUrl.rawValue : post.previewUrl ?? "",
            PostField.previewName.rawValue : post.previewName ?? ""
        ]
    }
    
    func map(id: Any, entity: NSDictionary?) -> Post {
        var maybeSphere: Sphere?
        if let sphereRawValue = entity?[PostField.sphere.rawValue] as? String,
            let sphere = Sphere(rawValue: sphereRawValue) {
             maybeSphere = sphere
        }
        
        return Post(id: id as? String ?? "",
                    text: entity?[PostField.text.rawValue] as? String ?? R.string.localizable.errorNotLoading(),
                    sphere: maybeSphere,
                    timestamp: entity?[PostField.timestamp.rawValue] as? Int64 ?? 0,
                    photoUrl: entity?[PostField.photoUrl.rawValue] as? String ?? "",
                    photoName: entity?[PostField.photoName.rawValue] as? String ?? "",
                    previewUrl: entity?[PostField.previewUrl.rawValue] as? String ?? "",
                    previewName: entity?[PostField.previewName.rawValue] as? String ?? "")
    }
}

enum PostField: String {
    case text
    case sphere
    case timestamp
    case photoUrl
    case photoName
    case previewUrl
    case previewName
}
