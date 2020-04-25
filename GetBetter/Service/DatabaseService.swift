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
    let user = Auth.auth().currentUser
    
    func savePost(_ post: Post) -> Bool {
        
        guard let userId = user?.uid else { return false }
        
        ref
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
        
        guard let user = user else { return }
        
        ref
            .child(Properties.Post.Field.post)
            .child(user.uid)
            .observeSingleEvent(of: .value, with: { snapshot in
                
                let value = snapshot.value as? NSDictionary
                
                if let keys = value?.allKeys {
                    var postArray: [Post] = []
                    
                    for key in keys.enumerated() {
                        let entity = value?[key.element] as? NSDictionary
                        
                        var sphere = Sphere.creation
                        if let sphereRawValue = entity?[Properties.Post.Field.sphere] as? String {
                            sphere = Sphere(rawValue: sphereRawValue) ?? Sphere.creation
                        }
                        
                        let post = Post(text: entity?[Properties.Post.Field.text] as? String ?? Properties.Error.loadingError,
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
    
    func saveSphereMetrics(_ sphereMetrics: SphereMetrics) -> Bool {
        
        guard let userId = user?.uid else { return false }
        
        ref
            .child(Properties.SphereMetrics.Field.metrics)
            .child(userId)
            .setValue(sphereMetrics.values)
        
        return true
    }
    
    func getSphereMetrics(completion: @escaping (Result<SphereMetrics, Error>) -> Void) {
        
        guard let userId = user?.uid else { return }
        
        ref
            .child(Properties.SphereMetrics.Field.metrics)
            .child(userId)
            .observeSingleEvent(of: .value, with: { snapshot in
                
                if let value = snapshot.value as? NSDictionary {
                    let sphereMetrics = SphereMetrics(values: value as! [String : Double])
                    completion(.success(sphereMetrics))
                }
            }) { error in
                    completion(.failure(error))
            }
    }
}
