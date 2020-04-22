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
    
    struct Json {
        static let categoryFileName = "Categories"
        static let eventFileName = "CharityEvents"
    }
    
    struct SegmentedControl {
        static let currentEvents = "Текущие"
        static let completedEvents = "Завершённые"
    }
    
    struct Font {
        static let OfficinaSansExtraBoldC = "OfficinaSansExtraBoldC"
        static let OfficinaSansExtraBoldSCC = "OfficinaSansExtraBoldSCC"
        static let SFUITextRegular = "SFUIText-Regular"
        static let SFUITextMedium = "SFUIText-Medium"
        static let Ubuntu = "Ubuntu"
    }
    
    struct TabBar {
        static let lifeCircleTitle = "Круг жизни"
        static let journalTitle = "Дневник"
        static let postTitle = "Добавить"
        static let profileTitle = "Профиль"
    }
    
    struct CoreData {
        static let category = "CategoryData"
        static let event = "EventData"
    }
    
    struct EventDetailVC {
        static let hasQuestions = "У вас есть вопросы?"
        static let writeUs = "Напишите нам"
        static let goSite = "Перейти на сайт организации"
        static let helpClothes = "Помочь вещами"
        static let volunteer = "Стать волонтёром"
        static let professionalHelp = "Проф. помощь"
        static let moneyHelp = "Помочь деньгами"
    }
    
    struct Auth {
        static let authTitleVC = "Авторизация"
        static let description1 = "Для участия в мероприятиях войдите в приложение через социальные сети"
        static let description2 = "Или авторизуйтесь через приложение"
        static let email = "E-mail"
        static let enterEmail = "Введите e-mail"
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
        static let emailIsEmpty = "Введите email"
        static let emailIsNotValid = "Введите корректный email"
        static let passwordIsEmpty = "Введите пароль"
        static let passwordsNotEquals = "Пароли не совпадают"
    }
    
    struct Profile {
        static let editTitle = "Редактировать профиль"
        static let signOut = "Выйти"
        static let name = "Имя"
        static let enterName = "Введите имя"
        static let email = "E-mail"
        static let enterEmail = "Введите новый e-mail"
        static let password = "Пароль"
        static let password2 = "Еще раз"
        static let enterPassword = "Введите новый пароль"
        static let enterPassword2 = "Повторите новый пароль"
        static let loadAvatar = "Загрузить аватар"
        static let avatarsDirectory = "avatars"
    }
    
    struct Write {
        static let sphere = "Выберите сферу для события"
    }
}
