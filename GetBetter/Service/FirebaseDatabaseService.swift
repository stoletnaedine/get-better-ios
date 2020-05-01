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

class FirebaseDatabaseService {
    
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    func savePost(_ post: Post) -> Bool {
        
        guard let userId = user?.uid else { return false }
        
        ref
            .child(Constants.Post.Field.post)
            .child(userId)
            .childByAutoId()
            .setValue([
                Constants.Post.Field.text: post.text ?? "" as Any,
                Constants.Post.Field.sphere: post.sphere?.rawValue ?? "",
                Constants.Post.Field.timestamp: post.timestamp ?? ""
            ])
        
        return true
    }
    
    func deletePost(_ post: Post) -> Bool {
        
        guard let userId = user?.uid else { return false }
        
        ref
            .child(Constants.Post.Field.post)
            .child(userId)
            .child(post.id ?? "")
            .removeValue()
        
        return true
    }
    
    
    func getPosts(completion: @escaping (Result<[Post], AppError>) -> Void) {
        
        guard let user = user else { return }
        
        ref
            .child(Constants.Post.Field.post)
            .child(user.uid)
            .observeSingleEvent(of: .value, with: { snapshot in
                
                let value = snapshot.value as? NSDictionary
                
                if let keys = value?.allKeys {
                    var postArray: [Post] = []
                    
                    for key in keys.enumerated() {
                        let id = key.element
                        let entity = value?[id] as? NSDictionary
                        
                        var maybeSphere: Sphere?
                        if let sphereRawValue = entity?[Constants.Post.Field.sphere] as? String,
                            let sphere = Sphere(rawValue: sphereRawValue) {
                             maybeSphere = sphere
                        }
                        
                        let post = Post(id: id as? String ?? "",
                                        text: entity?[Constants.Post.Field.text] as? String ?? Constants.Error.loadingError,
                                        sphere: maybeSphere,
                                        timestamp: entity?[Constants.Post.Field.timestamp] as? Int64 ?? 0)
                        
                        postArray.append(post)
                    }
                    completion(.success(postArray))
                } else {
                    completion(.success([]))
                }
            }) { error in
                completion(.failure(AppError(error: error)!))
        }
    }
    
    func saveSphereMetrics(_ sphereMetrics: SphereMetrics, pathToSave: String) -> Bool {
        
        guard let userId = user?.uid else { return false }
        
        ref
        .child(pathToSave)
        .child(userId)
            .removeValue()
        
        ref
            .child(pathToSave)
            .child(userId)
            .setValue(sphereMetrics.values)
        
        return true
    }
    
    func getSphereMetrics(from path: String, completion: @escaping (Result<SphereMetrics, AppError>) -> Void) {
        
        guard let userId = user?.uid else { return }
        
        ref
            .child(path)
            .child(userId)
            .observeSingleEvent(of: .value, with: { snapshot in
                
                if let value = snapshot.value as? NSDictionary {
                    let sphereMetrics = SphereMetrics(values: value as! [String : Double])
                    completion(.success(sphereMetrics))
                } else {
                    completion(.failure(AppError(errorCode: .notFound)))
                }
            }) { error in
                    completion(.failure(AppError(error: error)!))
            }
    }
    
    func incrementSphereMetrics(for sphere: Sphere) {
        
        getSphereMetrics(from: Constants.SphereMetrics.current, completion: { [weak self] result in
            
            let incrementValue = 0.1
            let maxValue = 10.0
                            
            switch result {
            case .success(let sphereMetrics):
                
                var newValues = sphereMetrics.values
                
                if let currentValue = newValues[sphere.rawValue],
                    currentValue < maxValue {
                    newValues[sphere.rawValue] = (currentValue * 10 + incrementValue * 10) / 10
                    let newSphereMetrics = SphereMetrics(values: newValues)
                    
                    let saveResult = self?.saveSphereMetrics(newSphereMetrics, pathToSave: Constants.SphereMetrics.current)
                    print("saveResult for \(sphere.rawValue)=\(String(describing: saveResult))")
                }
            case .failure(let error):
                print("error=\(error)")
                return
            }
        })
    }
}
