//
//  HelpError.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 02.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import Firebase

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
    
    init(firebaseError: Error) {
        if let errorCode = AuthErrorCode(rawValue: firebaseError._code) {
        switch errorCode {
        case .emailAlreadyInUse:
            self.name = "Этот E-mail уже используется другим пользователем"
        case .wrongPassword:
            self.name = "Неверный пароль"
        case .tooManyRequests:
            self.name = "Слишком много неудачных попыток. Попробуйте позже"
        case .userNotFound:
            self.name = "Пользователь не найден"
        case .networkError:
            self.name = "Нет подключения к интернету"
        default:
            self.name = firebaseError.localizedDescription
            }
        }
    }
}

enum AppErrorCode: String {
    case error = "Ошибка"
    case noInternet = "Нет интернета"
    case unAuthorized = "Вы не авторизованы"
    case serverError = "Ошибка сервера"
    case notFound = "Не удалось обновить данные с сервера"
}
