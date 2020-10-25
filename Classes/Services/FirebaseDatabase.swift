//
//  FirebaseDatabase.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 24.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

typealias UserData = (start: SphereMetrics?, current: SphereMetrics?, posts: [Post])

enum NotificationTopic: String {
    case daily
    case tipOfTheDay
}

protocol GBDatabase {
    @discardableResult
    func savePost(_ post: Post) -> Bool
    func deletePost(_ post: Post) -> Bool
    func getPosts(completion: @escaping (Result<[Post], AppError>) -> Void)
    func saveStartSphereMetrics(_ sphereMetrics: SphereMetrics) -> Bool
    func getStartSphereMetrics(completion: @escaping (Result<SphereMetrics, AppError>) -> Void)
    func getTips(completion: @escaping ([Tip]?) -> Void)
    func saveNotificationSetting(topic: NotificationTopic, subscribe: Bool)
    func getNotificationSettings(topic: NotificationTopic, completion: @escaping (Bool?) -> Void)
}

class FirebaseDatabase: GBDatabase {
    
    private enum Constants {
        static let startMetricsPath = "start_sphere_level"
        static let usersPath = "users"
        static let postsPath = "post"
        static let tipsPath = "tips"
        static let notificationsPath = "notifications"
    }
    
    private let connectionHelper = ConnectionHelper()
    private let ref = Database.database().reference()
    private let storage: GBStorage = FirebaseStorage()
    private let user = Auth.auth().currentUser
    
    func savePost(_ post: Post) -> Bool {
        guard let ref = currentUserPath() else { return false }
        let mapper = PostMapper()
        
        if let postId = post.id {
            ref
                .child(Constants.postsPath)
                .child(postId)
                .setValue(
                    mapper.map(post: post)
            )
        } else {
            ref
                .child(Constants.postsPath)
                .childByAutoId()
                .setValue(
                    mapper.map(post: post)
            )
        }
        
        return true
    }
    
    func deletePost(_ post: Post) -> Bool {
        guard let ref = currentUserPath() else { return false }
        
        ref
            .child(Constants.postsPath)
            .child(post.id ?? "")
            .removeValue()
        
        if let photoName = post.photoName, !photoName.isEmpty {
            storage.deletePhoto(name: photoName)
        }
        if let previewName = post.previewName, !previewName.isEmpty {
            storage.deletePreview(name: previewName)
        }
        
        return true
    }
    
    
    func getPosts(completion: @escaping (Result<[Post], AppError>) -> Void) {
        guard let ref = currentUserPath() else { return }
        
        ref
            .child(Constants.postsPath)
            .observeSingleEvent(of: .value, with: { snapshot in
                
                let value = snapshot.value as? NSDictionary
                
                if let keys = value?.allKeys {
                    var posts: [Post] = []
                    
                    for key in keys.enumerated() {
                        let id = key.element
                        let entity = value?[id] as? NSDictionary
                        
                        let mapper = PostMapper()
                        let post = mapper.map(id: id, entity: entity)
                        posts.append(post)
                    }
                    completion(.success(posts))
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
 
    func getTips(completion: @escaping ([Tip]?) -> Void) {
        let mapper = TipMapper()
        
        ref
            .child(Constants.tipsPath)
            .observeSingleEvent(of: .value, with: { snapshot in
                
                let value = snapshot.value as? NSDictionary
                
                if let keys = value?.allKeys {
                    var tips: [Tip] = []
                    
                    for key in keys.enumerated() {
                        let id = key.element
                        let entity = value?[id] as? NSDictionary
                        
                        let tip = mapper.map(entity: entity)
                        tips.append(tip)
                    }
                    completion(tips)
                } else {
                    completion(nil)
                }
            }) { error in
                completion(nil)
        }
    }
    
    func saveNotificationSetting(topic: NotificationTopic, subscribe: Bool) {
        guard let ref = currentUserPath() else { return }
        
        ref
            .child(Constants.notificationsPath)
            .setValue([topic.rawValue : subscribe])
    }
    
    func getNotificationSettings(topic: NotificationTopic, completion: @escaping (Bool?) -> Void) {
        guard let ref = currentUserPath() else { return }
        
        ref
            .child(Constants.notificationsPath)
            .observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                if let isSubscribe = value?[topic.rawValue] as? Bool {
                    completion(isSubscribe)
                } else {
                    completion(nil)
                }
            })
    }
    
    private func currentUserPath() -> DatabaseReference? {
        connectionHelper.checkConnect()
        
        guard let userId = user?.uid else { return nil }
        print("Request. UserId = \(userId)")
        
        return ref
            .child(Constants.usersPath)
            .child(userId)
    }
}