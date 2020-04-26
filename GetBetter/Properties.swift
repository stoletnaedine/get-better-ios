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
        static let loading = "Подождите, идет загрузка"
        
        struct SegmentedControl {
            static let circle = "Колесо"
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
        static let lifeCircleTitle = "Колесо жизни"
        static let journalTitle = "События"
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
        static let loadingError = "Не удалось загрузить"
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
        static let update = "Обновить"
        static let name = "Имя"
        static let enterName = "Введите имя"
        static let email = "Email"
        static let enterEmail = "Введите новый Email"
        static let password = "Пароль"
        static let enterPassword = "Введите новый пароль"
        static let loadAvatar = "Загрузить аватар"
        static let avatarsDirectory = "avatars"
        static let warning = "При смене Email необходимо заново войти в приложение"
        static let nameDefault = "..."
        static let editSuccess = "Профиль успешно обновлен.\nЧтобы увидеть изменения, обновите профиль"
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
            static let text = "text"
            static let sphere = "sphere"
            static let timestamp = "timestamp"
        }
    }
    
    struct SphereMetrics {
        static let sphereLevel = "sphere_level"
    }
    
    struct SetupSphere {
        static let question = "На сколько баллов (0-10) вы удовлетворены этой сферой в своей жизни?"
        static let setupTitle = "Welcome"
        static let notValidValue = -1.0
    }
    
    struct Welcome {
        static let title = "Что такое GetBetter?"
        static let description = "Это приложение, которое поможет тебе определить, какие сферы жизни нужно прокачать, чтобы добиться гармонии. \n\nПриготовься, перемены начинаются сегодня! \n\nДля начала давай определим твой текущий уровень.\n\nНе торопись отвечать, будь честен с собой."
    }
    
    struct AboutApp {
        static let about = "About"
        static let title = "Что такое GetBetter?"
        static let description = "Это приложение, которое помогает тебе определить, какие сферы жизни нужно прокачать, чтобы добиться гармонии. \n\nПриготовься, перемены начинаются сегодня! \n\nИдея и разработка приложения:\nИсламгулов Артур (github.com/stoletnaedine)\n\nИконки и изображения: icons8.com"
    }
    
    struct AboutCircle {
        static let button = "Что это?"
        static let title = "Это ваше Колесо Жизненного Баланса"
        static let viewTitle = "Что это?"
        static let description = "Суть в том, что колесо должно катиться! Чтобы ваше колесо стало круглым, нужно выровнять значения - уменьшить важность одного или сделать, что-то для выравнивания других сфер.\n\nТеперь нужно проанализировать, что можно сделать в той или иной сфере для гармонизации жизни. Здесь всё индивидуально. Может вы придете к выводу, что какая-то деятельность не эффективна и ее можно упразднить, в пользу других сфер.\n\nНачинайте следовать своему замыслу, согласно плану. Для начала выберите самую отстающую сферу. Результаты в каких-то областях можно увидеть уже через месяц, а на что-то потребуется год и более.Сохраните свои записи и сделайте упражнение снова через определенный вами период. Так вы наглядно увидите результаты. Продолжайте следить за динамикой!"
    }
}
