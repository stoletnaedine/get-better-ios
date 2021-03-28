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
            PostField.previewName.rawValue : post.previewName ?? "",
            PostField.addPhotos.rawValue : self.map(photos: post.addPhotos ?? [])
        ]
    }
    
    func map(id: Any, entity: NSDictionary?) -> Post {
        let sphereRawValue = entity?[PostField.sphere.rawValue] as? String ?? ""

        return Post(
            id: id as? String ?? "",
            text: entity?[PostField.text.rawValue] as? String ?? "",
            sphere: Sphere(rawValue: sphereRawValue),
            timestamp: entity?[PostField.timestamp.rawValue] as? Int64 ?? 0,
            photoUrl: entity?[PostField.photoUrl.rawValue] as? String ?? "",
            photoName: entity?[PostField.photoName.rawValue] as? String ?? "",
            previewUrl: entity?[PostField.previewUrl.rawValue] as? String ?? "",
            previewName: entity?[PostField.previewName.rawValue] as? String ?? "",
            addPhotos: self.map(photosEntity: entity?[PostField.addPhotos.rawValue] as? NSArray))
    }

    func map(photos: [Photo]) -> [String: String] {
        var result: [String: String] = [:]
        photos.enumerated().forEach { index, photo in
            result["\(index)"] = photo.photoUrl ?? ""
        }
        return result
    }

    func map(photosEntity: NSArray?) -> [Photo] {
        var result: [Photo] = []
        photosEntity?.forEach {
            if let url = $0 as? String {
                result.append(
                    Photo(photoUrl: url))
            }
        }
        return result
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
    case addPhotos
}
