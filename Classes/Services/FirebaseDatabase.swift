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

protocol GBDatabase {
    func savePost(_ post: Post, completion: VoidClosure?)
    func deletePost(_ post: Post, completion: VoidClosure?)
    func getPosts(completion: @escaping (Result<[Post], AppError>) -> Void)
    func saveStartSphereMetrics(_ sphereMetrics: SphereMetrics, completion: VoidClosure?)
    func getStartSphereMetrics(completion: @escaping (Result<SphereMetrics, AppError>) -> Void)
    func saveNotificationSetting(topic: NotificationTopic, subscribe: Bool)
    func getNotificationSettings(topic: NotificationTopic, completion: @escaping (Bool?) -> Void)
    func getTipLikeIds(completion: @escaping (Result<[Int], AppError>) -> Void)
    func saveTipLike(id: Int)
    func deleteTipLike(id: Int)
    func getTipLikesCount(for id: Int, completion: @escaping (Result<Int, AppError>) -> Void)
}

class FirebaseDatabase: GBDatabase {
    
    private enum Constants {
        static let startMetricsPath = "start_sphere_level"
        static let usersPath = "users"
        static let postsPath = "post"
        static let notificationsPath = "notifications"
        static let tipLikesPath = "tip_likes"
    }
    
    private let connectionHelper = ConnectionHelper()
    private let ref = Database.database().reference()
    private let storage: GBStorage = FirebaseStorage()
    private let user = Auth.auth().currentUser
    
    func savePost(_ post: Post, completion: VoidClosure? = nil) {
        guard let ref = currentUserPath() else { return }
        let mapper = PostMapper()
        
        if let postId = post.id {
            ref
                .child(Constants.postsPath)
                .child(postId)
                .setValue(
                    mapper.map(post: post),
                    withCompletionBlock: { _, _ in
                        completion?()
                    }
                )
        } else {
            ref
                .child(Constants.postsPath)
                .childByAutoId()
                .setValue(
                    mapper.map(post: post),
                    withCompletionBlock: { _, _ in
                        completion?()
                    }
                )
        }
    }
    
    func deletePost(_ post: Post, completion: VoidClosure? = nil) {
        guard let ref = currentUserPath(),
              let postId = post.id else { return }
        
        ref
            .child(Constants.postsPath)
            .child(postId)
            .removeValue(completionBlock: { [weak self] _, _ in
                completion?()
                guard let self = self else { return }
                self.storage.deletePhoto(name: post.photoName)
                self.storage.deletePreview(name: post.previewName)
            })
    }
    
    
    func getPosts(completion: @escaping (Result<[Post], AppError>) -> Void) {
        guard let ref = currentUserPath() else {
            completion(.failure(AppError(errorCode: .noInternet)))
            return
        }
        
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
                completion(.failure(AppError(errorCode: .unexpected)))
        }
    }
    
    func saveStartSphereMetrics(_ sphereMetrics: SphereMetrics, completion: VoidClosure? = nil) {
        guard let ref = currentUserPath() else { return }
        
        ref
            .child(Constants.startMetricsPath)
            .setValue(
                sphereMetrics.values,
                withCompletionBlock: { _, _ in
                    completion?()
                }
            )
    }
    
    func getStartSphereMetrics(completion: @escaping (Result<SphereMetrics, AppError>) -> Void) {
        guard let ref = currentUserPath() else {
            completion(.failure(AppError(errorCode: .noInternet)))
            return
        }
        
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
    
    func getTipLikeIds(completion: @escaping (Result<[Int], AppError>) -> Void) {
        guard connectionHelper.connectionAvailable() else {
            completion(.failure(AppError(errorCode: .noInternet)))
            return
        }
        guard let userId = user?.uid else {
            completion(.failure(AppError(errorCode: .unexpected)))
            return
        }
        
        ref
            .child(Constants.tipLikesPath)
            .child(userId)
            .observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSArray
                if let likeIds = value as? [Int] {
                    completion(.success(likeIds))
                } else {
                    completion(.success([]))
                }
            })
    }
    
    func getTipLikesCount(for id: Int, completion: @escaping (Result<Int, AppError>) -> Void) {
        guard connectionHelper.connectionAvailable() else {
            completion(.failure(AppError(errorCode: .noInternet)))
            return
        }
        
        ref
            .child(Constants.tipLikesPath)
            .observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                if let keys = value?.allKeys {
                    var count = 0
                    keys.enumerated().forEach { key in
                        let userId = key.element
                        if let ids = value?[userId] as? [Int], ids.contains(id) {
                            count += 1
                        }
                    }
                    completion(.success(count))
                } else {
                    completion(.success(.zero))
                }
            })
    }
    
    func saveTipLike(id: Int) {
        guard connectionHelper.connectionAvailable() else { return }
        guard let userId = user?.uid else { return }
        
        self.getTipLikeIds(completion: { [weak self] likeIds in
            switch likeIds {
            case .success(let ids):
                if !ids.contains(id) {
                    var newIds = ids
                    newIds.append(id)
                    
                    self?.ref
                        .child(Constants.tipLikesPath)
                        .child(userId)
                        .setValue(newIds)
                }
            case .failure:
                break
            }
        })
    }
    
    func deleteTipLike(id: Int) {
        guard connectionHelper.connectionAvailable() else { return }
        guard let userId = user?.uid else { return }
        
        self.getTipLikeIds(completion: { [weak self] likeIds in
            switch likeIds {
            case .success(let ids):
                if ids.contains(id) {
                    var newIds = ids
                    guard let idIndex = newIds.firstIndex(of: id) else { return }
                    newIds.remove(at: idIndex)
                    
                    self?.ref
                        .child(Constants.tipLikesPath)
                        .child(userId)
                        .setValue(newIds)
                }
            case .failure:
                break
            }
        })
    }
    
    private func currentUserPath() -> DatabaseReference? {
        guard connectionHelper.connectionAvailable() else { return nil }
        
        guard let userId = user?.uid else { return nil }
        print("Request. UserId = \(userId)")
        
        return ref
            .child(Constants.usersPath)
            .child(userId)
    }
}
