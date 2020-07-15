//
//  FirebaseDatabaseService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 24.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

protocol DatabaseService {

    @discardableResult
    func savePost(_ post: Post) -> Bool

    func deletePost(_ post: Post) -> Bool
    func getPosts(completion: @escaping (Result<[Post], AppError>) -> Void)
    func saveSphereMetrics(_ sphereMetrics: SphereMetrics, pathToSave: String) -> Bool
    func getSphereMetrics(from path: String, completion: @escaping (Result<SphereMetrics, AppError>) -> Void)
}

class FirebaseDatabaseService: DatabaseService {
    
    let ref = Database.database().reference()
    let storageService: StorageService = FirebaseStorageService()
    let user = Auth.auth().currentUser
    let usersPath = "users"
    let postsPath = "post"
    
    func savePost(_ post: Post) -> Bool {
        guard let ref = currentUserPath() else { return false }
        let mapper = PostMapper()
        
        ref
            .child(postsPath)
            .childByAutoId()
            .setValue(
                mapper.map(post: post)
        )
        
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
                        
                        let mapper = PostMapper()
                        let post = mapper.map(id: id, entity: entity)
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
    
    private func updateSphereValue(_ sphereValue: SphereValue, pathToSave: String) -> Bool {
        guard let ref = currentUserPath() else { return false }
        guard let sphereField = sphereValue.sphere?.rawValue else { return false }
        guard let value = sphereValue.value else { return false }
        
        ref
            .child(pathToSave)
            .updateChildValues([sphereField: value])
        
        return true
    }
    
    private func incrementSphereValue(for sphere: Sphere) {
        var currentSphereMetrics: SphereMetrics?
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getSphereMetrics(from: GlobalDefinitions.SphereMetrics.current,
                         dispatchGroup: dispatchGroup,
                         completion: { sphereMetrics in
            currentSphereMetrics = sphereMetrics
        })
        
        dispatchGroup.notify(queue: .global(), execute: { [weak self] in
            
            let diffValue = 0.1
            let maxValue = 10.0
            
            guard let currentSphereMetrics = currentSphereMetrics else { return }
            
            if let currentValue = currentSphereMetrics.values[sphere.rawValue],
                currentValue < maxValue {
                let newValue = (currentValue * 10 + diffValue * 10) / 10
                let sphereValue = SphereValue(sphere: sphere, value: newValue)
                let saveResult = self?.updateSphereValue(sphereValue,
                                                         pathToSave: GlobalDefinitions.SphereMetrics.current)
                print("Increment SphereValue for \(sphere.rawValue)=\(String(describing: saveResult))")
            }
        })
    }
    
    private func decrementSphereValue(for sphere: Sphere) {
        var startSphereMetrics: SphereMetrics?
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getSphereMetrics(from: GlobalDefinitions.SphereMetrics.start,
                         dispatchGroup: dispatchGroup,
                         completion: { sphereMetrics in
            startSphereMetrics = sphereMetrics
        })
        
        dispatchGroup.notify(queue: .global(), execute: { [weak self] in
            self?.getSphereMetrics(from: GlobalDefinitions.SphereMetrics.current, completion: { result in
                
                let diffValue = 0.1
                let minValue = 0.0
                                
                switch result {
                case .success(let sphereMetrics):
                    guard let startSphereMetrics = startSphereMetrics else { return }
                    guard let startValue = startSphereMetrics.values[sphere.rawValue] else { return }
                    
                    if let currentValue = sphereMetrics.values[sphere.rawValue],
                        currentValue > minValue,
                        currentValue > startValue {
                        
                        let newValue = (currentValue * 10 - diffValue * 10) / 10
                        let sphereValue = SphereValue(sphere: sphere, value: newValue)
                        let saveResult = self?.updateSphereValue(sphereValue,
                                                                 pathToSave: GlobalDefinitions.SphereMetrics.current)
                        print("Decrement SphereValue for \(sphere.rawValue)=\(String(describing: saveResult))")
                    }
                case .failure(let error):
                    print("Decrement SphereValue error=\(error)")
                }
            })
        })
    }
    
    private func getSphereMetrics(from path: String,
                                  dispatchGroup: DispatchGroup,
                                  completion: @escaping (SphereMetrics) -> Void) {
        getSphereMetrics(from: path, completion: { result in
            
            switch result {
            case .success(let sphereMetrics):
                completion(sphereMetrics)
                dispatchGroup.leave()

            case .failure(let error):
                print("Getting sphere metrics error=\(error)")
                dispatchGroup.leave()
            }
        })
    }
    
    private func currentUserPath() -> DatabaseReference? {
        guard let userId = user?.uid else { return nil }
        
        print("Current userId = \(userId)")
        
        return ref
            .child(usersPath)
            .child(userId)
    }
}
