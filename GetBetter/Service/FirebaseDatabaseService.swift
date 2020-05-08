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
    let storageService = FirebaseStorageService()
    let user = Auth.auth().currentUser
    let usersPath = "users"
    let postsPath = "post"
    let achievemenetsPath = "achievement"
    
    func currentUserPath() -> DatabaseReference? {
        guard let userId = user?.uid else { return nil }
        
        print("userId=\(userId)")
        
        return ref
            .child(usersPath)
            .child(userId)
    }
    
    func savePost(_ post: Post) -> Bool {
        
        guard let ref = currentUserPath() else { return false }
        
        ref
            .child(postsPath)
            .childByAutoId()
            .setValue([
                Constants.Post.Field.text: post.text ?? "" as Any,
                Constants.Post.Field.sphere: post.sphere?.rawValue ?? "",
                Constants.Post.Field.timestamp: post.timestamp ?? "",
                Constants.Post.Field.photoUrl: post.photoUrl ?? "",
                Constants.Post.Field.photoName: post.photoName ?? "",
                Constants.Post.Field.previewUrl: post.previewUrl ?? "",
                Constants.Post.Field.previewName: post.previewName ?? ""
            ])
        
        print("Firebase saved post \(post)")
        
        guard let sphere = post.sphere else { return false }
        incrementSphereValue(for: sphere)
        
        return true
    }
    
    func deletePost(_ post: Post) -> Bool {
        
        guard let ref = currentUserPath() else { return false }
        
        ref
            .child(postsPath)
            .child(post.id ?? "")
            .removeValue()
        
        guard let sphere = post.sphere else { return false }
        decrementSphereValue(for: sphere)
        
        if let photoName = post.photoName, !photoName.isEmpty {
            storageService.deletePhoto(name: photoName)
        }
        if let previewName = post.previewName, !previewName.isEmpty {
            storageService.deletePreview(name: previewName)
        }
        
        print("Firebase deleted post \(post)")
        
        return true
    }
    
    
    func getPosts(completion: @escaping (Result<[Post], AppError>) -> Void) {
        
        guard let ref = currentUserPath() else { return }
        
        ref
            .child(postsPath)
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
                                        photoUrl: entity?[Constants.Post.Field.photoUrl] as? String ?? "",
                                        photoName: entity?[Constants.Post.Field.photoName] as? String ?? "",
                                        previewUrl: entity?[Constants.Post.Field.photoName] as? String ?? "",
                                        previewName: entity?[Constants.Post.Field.photoName] as? String ?? "")
                        
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
        
        var currentSphereMetrics: SphereMetrics?
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getSphereMetrics(from: Constants.SphereMetrics.current, dispatchGroup: dispatchGroup, completion: { sphereMetrics in
            currentSphereMetrics = sphereMetrics
        })
        
        dispatchGroup.notify(queue: .global(), execute: { [weak self] in
            
            let diffValue = 0.1
            let maxValue = 10.0
            
            guard let currentSphereMetrics = currentSphereMetrics else { return }
            
            var newValues = currentSphereMetrics.values
            
            if let currentValue = newValues[sphere.rawValue],
                currentValue < maxValue {
                newValues[sphere.rawValue] = (currentValue * 10 + diffValue * 10) / 10
                let newSphereMetrics = SphereMetrics(values: newValues)
                
                let saveResult = self?.updateSphereMetrics(newSphereMetrics, pathToSave: Constants.SphereMetrics.current)
                print("Increment SphereValue for \(sphere.rawValue)=\(String(describing: saveResult))")
            }
        })
    }
    
    func decrementSphereValue(for sphere: Sphere) {
        
        var startSphereMetrics: SphereMetrics?
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getSphereMetrics(from: Constants.SphereMetrics.start, dispatchGroup: dispatchGroup, completion: { sphereMetrics in
            startSphereMetrics = sphereMetrics
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
                        print("Decrement SphereValue for \(sphere.rawValue)=\(String(describing: saveResult))")
                    }
                    
                case .failure(let error):
                    print("Decrement SphereValue error=\(error)")
                }
            })
        })
    }
    
    private func getSphereMetrics(from path: String, dispatchGroup: DispatchGroup, completion: @escaping (SphereMetrics) -> Void) {
        getSphereMetrics(from: path, completion: { result in
            
            switch result {
            case .success(let sphereMetrics):
                completion(sphereMetrics)
                dispatchGroup.leave()
                
            case .failure(let error):
                print("Getting start metrics error=\(error)")
                dispatchGroup.leave()
            }
        })
    }
    
    func getAchievements(completion: @escaping (Result<[Achievement], AppError>) -> Void) {
        
        guard let ref = currentUserPath() else { return }
        
        ref
            .child(achievemenetsPath)
            .observeSingleEvent(of: .value, with: { snapshot in
                
                let value = snapshot.value as? NSDictionary
                var array: [Achievement] = []
                
                if let keys = value?.allKeys {
                    
                    for key in keys.enumerated() {
                        let id = key.element
                        let entity = value?[id] as? NSDictionary
                        
                        let post = Achievement(icon: entity?[Constants.Achievement.Field.icon] as? String ?? "",
                                               title: entity?[Constants.Achievement.Field.title] as? String ?? "",
                                               description: entity?[Constants.Achievement.Field.description] as? String ?? "")
                        array.append(post)
                    }
                    completion(.success(array))
                } else {
                    completion(.success(array))
                }
            }) { error in
                completion(.failure(AppError(error: error)!))
        }
    }
    
    func saveAchievement(_ achievement: Achievement) {
        
        guard let ref = currentUserPath() else { return }
        
        ref
            .child(achievemenetsPath)
            .childByAutoId()
            .setValue([
                Constants.Achievement.Field.icon: achievement.icon ?? "",
                Constants.Achievement.Field.title: achievement.title ?? "",
                Constants.Achievement.Field.description: achievement.description ?? ""
            ])
        
        print("Firebase saved achievement \(achievement)")
    }
}
