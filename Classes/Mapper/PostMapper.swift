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
        var entity: [String : Any] = [
            PostField.text: post.text ?? "",
            PostField.sphere: post.sphere?.rawValue ?? "",
            PostField.timestamp: post.timestamp ?? "",
            PostField.notAddSphereValue: post.notAddSphereValue
        ]
        if let previewName = post.previewName,
           let previewUrl = post.previewUrl {
            entity[PostField.previewName] = previewName
            entity[PostField.previewUrl] = previewUrl
        }
        if let photoName = post.photoName,
           let photoUrl = post.photoUrl {
            entity[PostField.photoName] = photoName
            entity[PostField.photoUrl] = photoUrl
        }
        if let photos = post.photos {
            entity[PostField.photos] = self.map(photos: photos)
        }
        return entity
    }
    
    func map(id: Any, entity: NSDictionary?) -> Post {
        let sphereRawValue = entity?[PostField.sphere] as? String ?? ""

        return Post(
            id: id as? String ?? "",
            text: entity?[PostField.text] as? String ?? "",
            sphere: Sphere(rawValue: sphereRawValue),
            timestamp: entity?[PostField.timestamp] as? Int64 ?? 0,
            // Для поддержки постов, написанных до версии 2.0
            photoUrl: entity?[PostField.photoUrl] as? String ?? "",
            // Для поддержки постов, написанных до версии 2.0
            photoName: entity?[PostField.photoName] as? String ?? "",
            previewUrl: entity?[PostField.previewUrl] as? String ?? "",
            previewName: entity?[PostField.previewName] as? String ?? "",
            photos: self.map(photosEntity: entity?[PostField.photos] as? NSArray),
            notAddSphereValue: entity?[PostField.notAddSphereValue] as? Bool ?? false)
    }

    func map(photos: [PhotoNameURL]) -> [String: [String: String]] {
        var result = [String: [String: String]]()
        photos.enumerated().forEach { index, photo in
            var object = [String: String]()
            object[PhotoField.name] = photo.name
            object[PhotoField.url] = photo.url
            result["\(index)"] = object
        }
        return result
    }

    func map(photosEntity: NSArray?) -> [PhotoNameURL] {
        var result: [PhotoNameURL] = []
        photosEntity?.forEach {
            guard let entity = $0 as? NSDictionary else { return }
            result.append(
                PhotoNameURL(
                    name: entity[PhotoField.name] as? String ?? "",
                    url: entity[PhotoField.url] as? String ?? ""))
        }
        return result
    }
}

private enum PostField {
    static let text = "text"
    static let sphere = "sphere"
    static let timestamp = "timestamp"
    static let photoUrl = "photoUrl"
    static let photoName = "photoName"
    static let previewUrl = "previewUrl"
    static let previewName = "previewName"
    static let photos = "photos"
    static let notAddSphereValue = "notAddSphereValue"
}

private enum PhotoField {
    static let name = "name"
    static let url = "url"
}
