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

protocol DatabaseProtocol {
    func savePost(_ post: Post, completion: VoidClosure?)
    func deletePost(_ post: Post, completion: VoidClosure?)
    func getPosts(completion: @escaping (Result<[Post], AppError>) -> Void)
    func saveStartSphereMetrics(_ sphereMetrics: SphereMetrics, completion: VoidClosure?)
    func getStartSphereMetrics(completion: @escaping (Result<SphereMetrics, AppError>) -> Void)
    func getTipLikeIds(completion: @escaping (Result<[Int], AppError>) -> Void)
    func saveTipLike(id: Int)
    func deleteTipLike(id: Int)
    func getTipLikesCount(for id: Int, completion: @escaping (Result<Int, AppError>) -> Void)
    func userTipsLikes(completion: @escaping (Result<[TipLikesViewModel], AppError>) -> Void)
}

class FirebaseDatabase: DatabaseProtocol {
    
    private enum Constants {
        static let startMetricsPath = "start_sphere_level"
        static let usersPath = "users"
        static let postsPath = "post"
        static let notificationsPath = "notifications"
        static let tipLikesPath = "tip_likes"
    }
    
    private let connectionHelper = ConnectionHelper()
    private let dbRef = Database.database().reference()
    private let storage: FileStorageProtocol = FirebaseStorage()
    
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
                    })
        }
    }
    
    func deletePost(_ post: Post, completion: VoidClosure? = nil) {
        guard let ref = currentUserPath(),
              let postId = post.id else { return }
        
        ref
            .child(Constants.postsPath)
            .child(postId)
            .removeValue(completionBlock: { [weak self] _, _ in
                guard let self = self else { return }
                self.storage.deletePhoto(name: post.photoName)
                self.storage.deletePreview(name: post.previewName)
                completion?()
            })
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
    
    func getTipLikeIds(completion: @escaping (Result<[Int], AppError>) -> Void) {
        connectionHelper.checkConnect()
        guard let userId = Auth.auth().currentUser?.uid else { return }

        dbRef
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
        connectionHelper.checkConnect()

        dbRef
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
        connectionHelper.checkConnect()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        self.getTipLikeIds(completion: { [weak self] likeIds in
            switch likeIds {
            case .success(let ids):
                if !ids.contains(id) {
                    var newIds = ids
                    newIds.append(id)
                    
                    self?.dbRef
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
        connectionHelper.checkConnect()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        self.getTipLikeIds(completion: { [weak self] likeIds in
            switch likeIds {
            case .success(let ids):
                if ids.contains(id) {
                    var newIds = ids
                    guard let idIndex = newIds.firstIndex(of: id) else { return }
                    newIds.remove(at: idIndex)
                    
                    self?.dbRef
                        .child(Constants.tipLikesPath)
                        .child(userId)
                        .setValue(newIds)
                }
            case .failure:
                break
            }
        })
    }

    func userTipsLikes(completion: @escaping (Result<[TipLikesViewModel], AppError>) -> Void) {
        connectionHelper.checkConnect()
        guard let userId = Auth.auth().currentUser?.uid else { return }

        dbRef
            .child(Constants.tipLikesPath)
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let dict = snapshot.value as? NSDictionary,
                      let array = dict.allValues as? [[Int]] else {
                    completion(.failure(.init(errorCode: .serverError)))
                    return
                }
                guard let userTipIds = dict[userId] as? [Int] else {
                    completion(.success([]))
                    return
                }
                let allTipIds = array.reduce([], +)
                let result = userTipIds.map { tipId -> TipLikesViewModel in
                    let likeCount = allTipIds.filter { $0 == tipId }.count
                    return TipLikesViewModel(tipId: tipId, likeCount: likeCount)
                }
                completion(.success(result))
            })
    }

    // MARK: — Private methods
    
    private func currentUserPath() -> DatabaseReference? {
        connectionHelper.checkConnect()
        
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        print("Request. UserId = \(userId)")
        
        return dbRef
            .child(Constants.usersPath)
            .child(userId)
    }
}
