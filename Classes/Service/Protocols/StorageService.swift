//
//  StorageService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 15.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import UIKit

protocol StorageService {
    func uploadAvatar(photo: UIImage, completion: @escaping (Result<URL, AppError>) -> Void)
    func uploadPhoto(photo: UIImage, completion: @escaping (Result<Photo, AppError>) -> Void)
    func deletePreview(name: String)
    func deletePhoto(name: String)
}
