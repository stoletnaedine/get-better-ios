//
//  Sphere.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 21.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

enum Sphere: String, CaseIterable {
    case relations
    case health
    case environment
    case finance
    case work
    case relax
    case creation
    case spirit
}

// MARK: Additional fields

extension Sphere {

    static let nameMapper: [Sphere: String] = [
        .relations: "Отношения",
        .health: "Здоровье",
        .environment: "Окружение",
        .finance: "Финансы",
        .work: "Работа",
        .relax: "Отдых",
        .creation: "Творчество",
        .spirit: "Духовность"
    ]

    var name: String {
        return Sphere.nameMapper[self]!
    }

    static let descriptionMapper: [Sphere: String] = [
        .relations: "Взаимоотношения с партнером, любовь",
        .health: "Энергия, оздоровление, самочувствие",
        .environment: "Дети, родители, родственники, близкие друзья",
        .finance: "Доходы, расходы, пассивы, активы",
        .work: "Место работы, профессиональные навыки, карьерный рост",
        .relax: "Яркость жизни, общение, путешествия, развлечения, сон",
        .creation: "Реализация потенциала, хобби, личностное развитие",
        .spirit: "Эмоции, душевное состояние, медитации"
    ]
    
    var description: String {
        return Sphere.descriptionMapper[self]!
    }

    static let questionMapper: [Sphere: String] = [
        .relations: "На сколько баллов ты бы оценил свои отношения с любимым человеком, близкими людьми внутри семьи?",
        .health: "На сколько баллов ты бы оценил своё самочувствие? Занимаешься ли спортом? Какое у тебя отношение к здоровью?",
        .environment: "На сколько баллов ты бы оценил свои отношения с родителями, детьми, родственниками, близкими друзьями?",
        .finance: "На сколько баллов ты бы оценил свои доходы, активы? Насколько хорошо ты разбираешься в финансах?",
        .work: "На сколько баллов ты бы оценил своё место работы, профессиональные навыки, карьерный рост?",
        .relax: "На сколько баллов ты бы оценил яркость своей жизни, общение, путешествия, развлечения, качество сна?",
        .creation: "На сколько баллов ты бы оценил реализацию своего потенциала, занятия хобби, личностное развитие?",
        .spirit: "На сколько баллов ты бы оценил свои эмоции, душевное состояние? Практикуешь ли медитации?\nПосле всех оценок нажми Сохранить."
    ]

    var question: String {
        return Sphere.questionMapper[self]!
    }

    static let iconMapper: [Sphere: String] = [
        .relations: "😍",
        .health: "💪",
        .environment: "👨‍👩‍👧‍👦",
        .finance: "💵",
        .work: "👨‍💻",
        .relax: "🏖",
        .creation: "👨‍🎨",
        .spirit: "🧘‍♀️"
    ]

    var icon: String {
        return Sphere.iconMapper[self]!
    }

    static let imageMapper: [Sphere: UIImage?] = [
        .relations: R.image.sphereRelations(),
        .health: R.image.sphereHealth(),
        .environment: R.image.sphereEnvironment(),
        .finance: R.image.sphereFinance(),
        .work: R.image.sphereWork(),
        .relax: R.image.sphereRelax(),
        .creation: R.image.sphereCreation(),
        .spirit: R.image.sphereSpirit()
    ]

    var image: UIImage? {
        return Sphere.imageMapper[self]!
    }

    static let colorMapper: [Sphere: UIColor] = [
        .relations: #colorLiteral(red: 1, green: 0.7960784314, blue: 0.7960784314, alpha: 1),
        .health: #colorLiteral(red: 0.7137254902, green: 0.9450980392, blue: 1, alpha: 1),
        .environment: #colorLiteral(red: 0.7607843137, green: 1, blue: 0.9529411765, alpha: 1),
        .finance: #colorLiteral(red: 1, green: 0.9607843137, blue: 0.2235294118, alpha: 1),
        .work: #colorLiteral(red: 1, green: 0.4, blue: 0.4, alpha: 1),
        .relax: #colorLiteral(red: 0.2, green: 0.8784313725, blue: 0.631372549, alpha: 1),
        .creation: #colorLiteral(red: 0.5137254902, green: 0.1725490196, blue: 1, alpha: 1),
        .spirit: #colorLiteral(red: 0.8039215686, green: 0.5333333333, blue: 0.9490196078, alpha: 1)
    ]

    var color: UIColor {
        return Sphere.colorMapper[self]!
    }

    static let titleColorMapper: [Sphere: UIColor] = [
        .relations: #colorLiteral(red: 0.4862745098, green: 0, blue: 0.4509803922, alpha: 1),
        .health: #colorLiteral(red: 0, green: 0.4549019608, blue: 0.5764705882, alpha: 1),
        .environment: #colorLiteral(red: 0, green: 0.5176470588, blue: 0.3568627451, alpha: 1),
        .finance: #colorLiteral(red: 0.3450980392, green: 0, blue: 0.8862745098, alpha: 1),
        .work: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        .relax: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        .creation: #colorLiteral(red: 1, green: 0.8666666667, blue: 0.8235294118, alpha: 1),
        .spirit: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    ]

    var titleColor: UIColor {
        return Sphere.titleColorMapper[self]!
    }
}
