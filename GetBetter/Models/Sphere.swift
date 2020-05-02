//
//  Sphere.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 21.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
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
    
    static let iconMapper: [Sphere: String] = [
        .relations: "😍",
        .health: "💪",
        .environment: "👨‍👩‍👧‍👦",
        .finance: "💵",
        .work: "👨‍💻",
        .relax: "🏖",
        .creation: "👨‍🎨",
        .spirit: "🌀"
    ]
    
    var icon: String {
        return Sphere.iconMapper[self]!
    }
    
    static let colorMapper: [Sphere: UIColor] = [
        .relations: #colorLiteral(red: 0.8856292963, green: 0.3189524412, blue: 0.6729699969, alpha: 1),
        .health: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),
        .environment: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1),
        .finance: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
        .work: #colorLiteral(red: 0, green: 0.5607146621, blue: 0.3763182163, alpha: 1),
        .relax: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),
        .creation: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1),
        .spirit: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    ]
    
    var color: UIColor {
        return Sphere.colorMapper[self]!
    }
}
