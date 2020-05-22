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
    }
    
    struct Font {
        static let mabryProRegular = "MabryPro-Regular"
    }
    
    struct TabBar {
        static let lifeCircleTitle = "Колесо жизни"
        static let journalTitle = "Дневник"
        static let settingsTitle = "Настройки"
    }
    
    struct Auth {
        static let authTitleVC = "Авторизация"
        static let description1 = "Войдите в приложение через социальные сети"
        static let description2 = "или авторизуйтесь ниже"
        static let email = "Email"
        static let enterEmail = "Введите Email"
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
        static let editTitle = "Редактировать профиль"
        static let signOut = "Выйти"
        static let update = "Обновить"
        static let name = "Имя"
        static let enterName = "Введите имя"
        static let email = "Email"
        static let enterEmail = "Изменить Email"
        static let password = "Пароль"
        static let enterPassword = "Изменить пароль"
        static let loadAvatar = "Загрузить аватар"
        static let warning = "После смены Email необходимо заново войти в приложение"
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
        static let setupTitle = "Welcome"
        static let notValidValue = -1.0
    }
    
    struct Welcome {
        static let title = "Что такое GetBetter?"
        static let description = "Это приложение, которое поможет тебе определить, какие сферы жизни нужно прокачать, чтобы добиться гармонии.\n\nДля начала давай определим твой текущий уровень.\n\nНе торопись отвечать, будь честен с собой."
    }
    
    struct AboutApp {
        static let title = "Что такое GetBetter?"
        static let description = "Это приложение, которое помогает тебе определить, какие сферы жизни нужно прокачать, чтобы добиться гармонии.\n\nНад приложением работали:\n\nИдея и разработка:\nИсламгулов Артур (github.com/stoletnaedine)\n\nИконки и визуальный стиль:\nАлексей Бусыгин (alekseybusygin.com)"
    }
    
    struct AboutCircle {
        static let title = "Колесо Жизненного Баланса"
        static let viewTitle = "Колесо Жизненного Баланса"
        static let description = "В разделе Колесо Жизни показано ваше Колесо Жизненного Баланса. Смысл в том, что колесо должно катиться!\nЧтобы ваше колесо стало круглым, нужно выровнять значения — уменьшить важность одного или сделать что-то для выравнивания других сфер.\n\nНужно проанализировать, что можно сделать в той или иной сфере для гармонизации жизни. Здесь всё индивидуально. Может вы придёте к выводу, что какая-то деятельность не эффективна и её можно упразднить в пользу других сфер.\n\nНачинайте следовать своему замыслу согласно плану. Для начала выберите самую отстающую сферу. Результаты в каких-то областях можно увидеть уже через месяц, а на что-то потребуется год и более. Регулярно ведите записи в разделе Дневник. Так вы наглядно увидите результаты.\n\nПродолжайте следить за динамикой!"
    }
    
    struct AboutJournal {
        static let title = "События дня"
        static let viewTitle = "Правила игры"
        static let description = "Каждый раз, когда вы добавляете событие дня, вы получаете за него 0,1 балла к текущему уровню Колеса Жизненного Баланса.\nС каждым днем, при должных усилиях, Колесо будет все больше выпрямлять свои грани.\n\nВ этом и смысл — GetBetter.\n\nЕсли вам кажется, что в вашей жизни ничего не меняется, просто взгляните на эти записи и вспомните события, которые сделали вас лучше.\n\nНе забывайте регулярно множить яркие события и не забрасывать Сферы, которые требуют внимания.\n\nЛюбой путь начинается с первого шага."
    }
}
