//
//  Properties.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 16.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

struct GlobalDefiitions {
    
    struct Keychain {
        static let emailKey = "com.stoletnaedine.GetBetter.UserEmail"
        static let isShowedTutorialKey = "com.stoletnaedine.GetBetter.isShowedTutorialKey"
    }
    
    struct TabBar {
        static let lifeCircleTitle = "Колесо жизни"
        static let journalTitle = "Дневник"
        static let settingsTitle = "Настройки"
    }
    
    struct Auth {
        static let authTitleVC = "Авторизация"
        static let email = "E-mail"
        static let enterEmail = "Введите E-mail"
        static let password = "Пароль"
        static let enterPassword = "Введите пароль"
        static let enter = "Войти"
        static let doRegister = "Зарегистрироваться"
        static let forgotPassword = "Забыли пароль?"
        static let register = "Регистрация"
        static let successRegister = "Вы успешно зарегистрировались"
    }
    
    struct Error {
        static let firebaseError = "FirebaseError: "
        static let loadingError = "Не удалось загрузить"
    }
    
    struct RegisterValidate {
        static let emailIsEmpty = "Введите Email"
        static let emailIsNotValid = "Введите корректный Email"
        static let passwordIsEmpty = "Введите пароль"
    }
    
    struct Profile {
        static let editTitle = "Редактировать"
        static let signOut = "Выйти"
        static let update = "Обновить"
        static let name = "Имя"
        static let enterName = "Введите имя"
        static let email = "E-mail"
        static let enterEmail = "Введите E-mail"
        static let password = "Пароль"
        static let enterPassword = "Введите новый пароль"
        static let loadAvatar = "Загрузить аватар"
        static let warning = "После смены E-mail необходимо заново войти в приложение"
        static let loading = "Подождите, идет загрузка"
    }
    
    struct Post {
        static let postTitle = "Добавить событие"
        static let sphere = "Выберите сферу для события"
        static let sphereDefault = "Выберите сферу"
        static let titleDefault = "Событие"
        static let postSavedSuccess = "Отлично!"
        static let emptyFieldsWarning = "Заполните все поля"
        
        struct Field {
            static let text = "text"
            static let sphere = "sphere"
            static let timestamp = "timestamp"
            static let photoUrl = "photoUrl"
            static let photoName = "photoName"
            static let previewUrl = "previewUrl"
            static let previewName = "previewName"
        }
    }
    
    struct SphereMetrics {
        static let start = "start_sphere_level"
        static let current = "current_sphere_level"
    }
    
    struct SetupSphere {
        static let question = "На сколько баллов (0-10) вы удовлетворены этой сферой в своей жизни?"
        static let setupTitle = "Привет"
        static let notValidValue = -1.0
    }
    
    struct Welcome {
        static let title = "Что такое GetBetter?"
        static let description = "Это приложение, которое поможет тебе определить, какие сферы жизни нужно прокачать, чтобы добиться гармонии.\n\nДля начала давай определим твой текущий уровень.\n\nНе торопись отвечать, будь честен с собой."
    }
    
    struct AboutApp {
        static let title = "Что такое GetBetter?"
        static let description = "Это приложение, которое помогает тебе определить, какие сферы жизни нужно прокачать, чтобы добиться гармонии.\n\nНаша команда:\n\nИдея и разработка\nИсламгулов Артур\ngithub.com/stoletnaedine\n\nВизуальный стиль\nАлексей Бусыгин\nalekseybusygin.com"
    }
    
    struct AboutCircle {
        static let title = "Колесо Жизненного Баланса"
        static let viewTitle = "Это твоё колесо жизненного баланса"
        static let description = "Смысл в том, что колесо должно катиться.\nЧтобы колесо стало круглым, нужно выровнить значения — уменьшить важность одного или сделать что-то в других сферах. Регулярно веди записи в разделе Дневник. Так ты наглядно увидишь результаты."
    }
    
    struct AboutJournal {
        static let title = "Правила игры"
        static let viewTitle = "Правила игры"
        static let description = "Каждый раз, когда ты добавляешь событие дня, ты получаешь за него 0,1 балла к текущему уровню в этой сфере. Например, сделал зарядку — плюс 0,1 к здоровью.\n\nС каждым днем при должных усилиях колесо будет всё больше выпрямлять свои грани. В этом и смысл GetBetter.\n\nЕсли тебе кажется, что в жизни ничего не меняется, просто взгляни на эти записи и вспомни события, которые сделали тебя лучше.\n\nНе забывай регулярно множить яркие события и не забрасывать сферы, которые требуют внимания."
    }
}
