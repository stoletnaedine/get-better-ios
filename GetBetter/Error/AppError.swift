//
//  HelpError.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 02.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import RxSwift

class AppError: Error {
    
    var name: String?
    
    init?(error: Error?) {
        if let error = error {
            self.name = error.localizedDescription
        } else {
            return nil
        }
    }
    
    init(errorCode: AppErrorCode) {
        self.name = errorCode.rawValue
    }
}

enum AppErrorCode: String {
    case error = "Ошибка"
    case noInternet = "Нет интернета"
    case unAuthorized = "Вы не авторизованы"
    case serverError = "Ошибка сервера"
    case notFound = "Не удалось обновить данные с сервера"
}
