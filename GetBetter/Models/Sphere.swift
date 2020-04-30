//
//  Sphere.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 21.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

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
        .health: "🧘‍♀️",
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
}
