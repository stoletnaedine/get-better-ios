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
    let usersPath = "users"
    
    func currentUserPath() -> DatabaseReference? {
        guard let userId = user?.uid else { return nil }
        
        return ref
            .child(usersPath)
            .child(userId)
    }
    
    func savePost(_ post: Post) -> Bool {
        
        guard let ref = currentUserPath() else { return false }
        
        ref
            .child(Constants.Post.Field.post)
            .childByAutoId()
            .setValue([
                Constants.Post.Field.text: post.text ?? "" as Any,
                Constants.Post.Field.sphere: post.sphere?.rawValue ?? "",
                Constants.Post.Field.timestamp: post.timestamp ?? ""
            ])
        
        return true
    }
    
    func deletePost(_ post: Post) -> Bool {
        
        guard let ref = currentUserPath() else { return false }
        
        ref
            .child(Constants.Post.Field.post)
            .child(post.id ?? "")
            .removeValue()
        
        if let sphere = post.sphere {
            decrementSphereValue(for: sphere)
        }
        
        return true
    }
    
    
    func getPosts(completion: @escaping (Result<[Post], AppError>) -> Void) {
        
        guard let ref = currentUserPath() else { return }
        
        ref
            .child(Constants.Post.Field.post)
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
                                        timestamp: entity?[Constants.Post.Field.timestamp] as? Int64 ?? 0,
                                        picUrl: entity?["picUrl"] as? String ?? "")
                        
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
        
        guard let ref = currentUserPath() else { return false }
        
        ref
            .child(pathToSave)
            .setValue(sphereMetrics.values)
        
        return true
    }
    
    func updateSphereMetrics(_ sphereMetrics: SphereMetrics, pathToSave: String) -> Bool {
            
            guard let ref = currentUserPath() else { return false }
            
            ref
                .child(pathToSave)
                .updateChildValues(sphereMetrics.values)
            
            return true
        }
    
    func getSphereMetrics(from path: String, completion: @escaping (Result<SphereMetrics, AppError>) -> Void) {
        
        guard let ref = currentUserPath() else { return }
        
        ref
            .child(path)
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
    
    func incrementSphereValue(for sphere: Sphere) {
        
        getSphereMetrics(from: Constants.SphereMetrics.current, completion: { [weak self] result in
            
            let diffValue = 0.1
            let maxValue = 10.0
                            
            switch result {
            case .success(let sphereMetrics):
                
                var newValues = sphereMetrics.values
                
                if let currentValue = newValues[sphere.rawValue],
                    currentValue < maxValue {
                    newValues[sphere.rawValue] = (currentValue * 10 + diffValue * 10) / 10
                    let newSphereMetrics = SphereMetrics(values: newValues)
                    
                    let saveResult = self?.updateSphereMetrics(newSphereMetrics, pathToSave: Constants.SphereMetrics.current)
                    print("incrementSphereValue for \(sphere.rawValue)=\(String(describing: saveResult))")
                }
                
            case .failure(let error):
                print("incrementSphereValue error=\(error)")
            }
        })
    }
    
    func decrementSphereValue(for sphere: Sphere) {
        
        let dispatchGroup = DispatchGroup()
        var startSphereMetrics: SphereMetrics?
        
        dispatchGroup.enter()
        getSphereMetrics(from: Constants.SphereMetrics.start, completion: { result in
                            
            switch result {
            case .success(let sphereMetrics):
                
                startSphereMetrics = sphereMetrics
                dispatchGroup.leave()
                
            case .failure(let error):
                print("Get start metrics error=\(error)")
                dispatchGroup.leave()
            }
        })
        
        dispatchGroup.notify(queue: .global(), execute: { [weak self] in
            
            self?.getSphereMetrics(from: Constants.SphereMetrics.current, completion: { result in
                
                let diffValue = 0.1
                let minValue = 0.0
                                
                switch result {
                case .success(let sphereMetrics):
                    
                    var newValues = sphereMetrics.values
                    
                    guard let startSphereMetrics = startSphereMetrics else { return }
                    guard let startValue = startSphereMetrics.values[sphere.rawValue] else { return }
                    
                    if let currentValue = newValues[sphere.rawValue],
                        currentValue > minValue,
                        currentValue > startValue {
                        newValues[sphere.rawValue] = (currentValue * 10 - diffValue * 10) / 10
                        let newSphereMetrics = SphereMetrics(values: newValues)
                        
                        let saveResult = self?.updateSphereMetrics(newSphereMetrics, pathToSave: Constants.SphereMetrics.current)
                        print("decrementSphereValue for \(sphere.rawValue)=\(String(describing: saveResult))")
                    }
                    
                case .failure(let error):
                    print("decrementSphereValue error=\(error)")
                }
            })
        })
    }
}
