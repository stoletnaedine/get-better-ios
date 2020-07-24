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

typealias UserData = (start: SphereMetrics?, current: SphereMetrics?, posts: [Post])

protocol DatabaseService {

    @discardableResult
    func savePost(_ post: Post) -> Bool
    func deletePost(_ post: Post) -> Bool
    func getPosts(completion: @escaping (Result<[Post], AppError>) -> Void)
    func saveStartSphereMetrics(_ sphereMetrics: SphereMetrics) -> Bool
    func getStartSphereMetrics(completion: @escaping (Result<SphereMetrics, AppError>) -> Void)
    func getUserData(completion: @escaping (UserData) -> Void)
}

class FirebaseDatabaseService: DatabaseService {
    
    enum Constants {
        static let startMetricsPath = "start_sphere_level"
    }
    
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
        
        return true
    }
    
    func deletePost(_ post: Post) -> Bool {
        guard let ref = currentUserPath() else { return false }
        
        ref
            .child(postsPath)
            .child(post.id ?? "")
            .removeValue()
        
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
    
    func saveStartSphereMetrics(_ sphereMetrics: SphereMetrics) -> Bool {
        guard let ref = currentUserPath() else { return false }
        
        ref
            .child(Constants.startMetricsPath)
            .setValue(sphereMetrics.values)
        
        return true
    }
    
    func getStartSphereMetrics(completion: @escaping (Result<SphereMetrics, AppError>) -> Void) {
        guard let ref = currentUserPath() else { return }
        
        ref
            .child(Constants.startMetricsPath)
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
    
    func getUserData(completion: @escaping (UserData) -> Void) {
        
        var posts: [Post] = []
        var startSphereMetrics: SphereMetrics?
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getPosts(completion: { result in
            switch result {
            case .success(let postsFromDB):
                posts = postsFromDB
                dispatchGroup.leave()
            default:
                dispatchGroup.leave()
                break
            }
        })
        
        dispatchGroup.enter()
        getStartSphereMetrics(completion: { result in
            switch result {
            case .success(let sphereMetrics):
                startSphereMetrics = sphereMetrics
                dispatchGroup.leave()
            default:
                dispatchGroup.leave()
                break
            }
        })
        
        dispatchGroup.notify(queue: .global(), execute: {
            let spheresInPosts = posts.map { $0.sphere }
            guard let startSphereMetrics = startSphereMetrics else { return }
            var currentSphereMetricsValues = startSphereMetrics.values
            
            let diffValue = 0.1
            let maxValue = 10.0

            spheresInPosts.forEach { sphere in
                if let sphereString = sphere?.rawValue,
                    let sphereValue = currentSphereMetricsValues[sphereString],
                    sphereValue < maxValue {
                    let newValue = (sphereValue * 10 + diffValue * 10) / 10
                    currentSphereMetricsValues[sphereString] = newValue
                }
            }

            let currentSphereMetrics = SphereMetrics(values: currentSphereMetricsValues)
            completion((startSphereMetrics, currentSphereMetrics, posts))
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
