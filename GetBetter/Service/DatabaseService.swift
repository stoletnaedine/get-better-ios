//
//  DatabaseService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 24.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class DatabaseService {
    
    let ref = Database.database().reference()
    let userId = Auth.auth().currentUser?.uid
    
    func savePost(_ post: Post) -> Bool {
        
        guard let userId = userId else {
            return false
        }
        
        Database.database().reference()
            .child(Properties.Post.Field.post)
            .child(userId)
            .childByAutoId()
            .setValue([
                Properties.Post.Field.text: post.text ?? "" as Any,
                Properties.Post.Field.sphere: post.sphere?.rawValue ?? "",
                Properties.Post.Field.timestamp: post.timestamp ?? ""
            ])
        
        return true
    }
    
    
    func getPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        Database.database().reference()
            .child(Properties.Post.Field.post)
            .child(user.uid)
            .observeSingleEvent(of: .value, with: { snapshot in
                
                let value = snapshot.value as? NSDictionary
                let keys = value?.allKeys
                
                if let keys = keys {
                    var postArray: [Post] = []
                    
                    for key in keys.enumerated() {
                        let entity = value?[key.element] as? NSDictionary
                        
                        var sphere = Sphere.creation
                        if let sphereRawValue = entity?[Properties.Post.Field.sphere] as? String {
                            sphere = Sphere(rawValue: sphereRawValue) ?? Sphere.creation
                        }
                        
                        let post = Post(text: entity?[Properties.Post.Field.text] as? String ?? "Не удалось загрузить",
                                        sphere: sphere,
                                        timestamp: entity?[Properties.Post.Field.timestamp] as? Int64 ?? 0)
                        
                        postArray.append(post)
                    }
                    completion(.success(postArray))
                }
            }) { error in
                completion(.failure(error))
        }
    }
}
