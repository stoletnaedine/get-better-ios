//
//  DatabaseService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 15.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

protocol DatabaseService {
    
    @discardableResult
    func savePost(_ post: Post) -> Bool
    
    func deletePost(_ post: Post) -> Bool
    func getPosts(completion: @escaping (Result<[Post], AppError>) -> Void)
    func saveSphereMetrics(_ sphereMetrics: SphereMetrics, pathToSave: String) -> Bool
    func getSphereMetrics(from path: String, completion: @escaping (Result<SphereMetrics, AppError>) -> Void)
}
