//
//  Properties.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 16.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct Properties {
    
    struct Keychain {
        static let emailKey = "com.stoletnaedine.GetBetter.UserEmail"
        static let emailSuccessSaved = "Email успешно сохранен в Keychain"
    }
    
    struct LifeCircle {
        struct SegmentedControl {
            static let circle = "Круг"
            static let details = "Подробнее"
        }
    }
    
    struct Font {
        static let OfficinaSansExtraBold = "OfficinaSansExtraBoldC"
        static let SFUITextRegular = "SFUIText-Regular"
        static let SFUITextMedium = "SFUIText-Medium"
        static let Ubuntu = "Ubuntu"
    }
    
    struct TabBar {
        static let lifeCircleTitle = "Круг жизни"
        static let journalTitle = "Дневник"
        static let profileTitle = "Профиль"
    }
    
    struct Auth {
        static let authTitleVC = "Авторизация"
        static let description1 = "Войдите в приложение через социальные сети (пока не доступно)"
        static let description2 = "или авторизуйтесь ниже"
        static let email = "Email"
        static let enterEmail = "Введите Email"
        static let password = "Пароль"
        static let password2 = "Еще раз"
        static let enterPassword = "Введите пароль"
        static let enterPassword2 = "Повторите пароль"
        static let enter = "Войти"
        static let doRegister = "Зарегистрироваться"
        static let forgotPassword = "Забыли пароль?"
        static let register = "Регистрация"
        static let successRegister = "Вы успешно зарегистрировались"
    }
    
    struct Error {
        static let firebaseError = "FirebaseError: "
    }
    
    struct RegisterValidate {
        static let emailIsEmpty = "Введите Email"
        static let emailIsNotValid = "Введите корректный Email"
        static let passwordIsEmpty = "Введите пароль"
        static let passwordsNotEquals = "Пароли не совпадают"
    }
    
    struct Profile {
        static let editTitle = "Редактировать профиль"
        static let signOut = "Выйти"
        static let name = "Имя"
        static let enterName = "Введите имя"
        static let email = "Email"
        static let enterEmail = "Введите новый Email"
        static let password = "Пароль"
        static let password2 = "Еще раз"
        static let enterPassword = "Введите новый пароль"
        static let enterPassword2 = "Повторите новый пароль"
        static let loadAvatar = "Загрузить аватар"
        static let avatarsDirectory = "avatars"
        static let warning = "При смене Email необходимо заново войти в приложение"
        static let nameDefault = "Неизвестный Кот"
    }
    
    struct Post {
        static let postTitle = "Добавить событие"
        static let sphere = "Выберите сферу для события"
        static let addPost = "Опишите событие, которое сегодня сделало вас лучше"
        static let sphereDefault = "Нажмите здесь"
        static let titleDefault = "Событие"
        static let postSavedSuccess = "Пост сохранен!"
        static let emptyFieldsWarning = "Заполните все поля"
        
        struct Field {
            static let post = "post"
            static let sphere = "sphere"
            static let timestamp = "timestamp"
        }
    }
}
