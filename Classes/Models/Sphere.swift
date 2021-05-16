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

    var name: String {
        return Sphere.nameMapper[self]!
    }

    var description: String {
        return Sphere.descriptionMapper[self]!
    }

    var question: String {
        return Sphere.questionMapper[self]!
    }

    var icon: String {
        return Sphere.iconMapper[self]!
    }

    var image: UIImage? {
        return Sphere.imageMapper[self]!
    }

    var color: UIColor {
        return Sphere.colorMapper[self]!
    }

    var titleColor: UIColor {
        return Sphere.titleColorMapper[self]!
    }

    // MARK: — Private properties

    private static let nameMapper: [Sphere: String] = [
        .relations: R.string.localizable.sphereRelations(),
        .health: R.string.localizable.sphereHealth(),
        .environment: R.string.localizable.sphereEnvironment(),
        .finance: R.string.localizable.sphereFinance(),
        .work: R.string.localizable.sphereWork(),
        .relax: R.string.localizable.sphereRelax(),
        .creation: R.string.localizable.sphereCreation(),
        .spirit: R.string.localizable.sphereSpirit()
    ]

    private static let descriptionMapper: [Sphere: String] = [
        .relations: R.string.localizable.sphereRelationsDesc(),
        .health: R.string.localizable.sphereHealthDesc(),
        .environment: R.string.localizable.sphereEnvironmentDesc(),
        .finance: R.string.localizable.sphereFinanceDesc(),
        .work: R.string.localizable.sphereWorkDesc(),
        .relax: R.string.localizable.sphereRelaxDesc(),
        .creation: R.string.localizable.sphereCreationDesc(),
        .spirit: R.string.localizable.sphereSpiritDesc()
    ]

    private static let questionMapper: [Sphere: String] = [
        .relations: R.string.localizable.sphereRelationsQuestion(),
        .health: R.string.localizable.sphereHealthQuestion(),
        .environment: R.string.localizable.sphereEnvironmentQuestion(),
        .finance: R.string.localizable.sphereFinanceQuestion(),
        .work: R.string.localizable.sphereWorkQuestion(),
        .relax: R.string.localizable.sphereRelaxQuestion(),
        .creation: R.string.localizable.sphereCreationQuestion(),
        .spirit: R.string.localizable.sphereSpiritQuestion()
    ]

    private static let iconMapper: [Sphere: String] = [
        .relations: "😍",
        .health: "💪",
        .environment: "👨‍👩‍👧‍👦",
        .finance: "💵",
        .work: "👨‍💻",
        .relax: "🏖",
        .creation: "👨‍🎨",
        .spirit: "🧘‍♀️"
    ]

    private static let imageMapper: [Sphere: UIImage?] = [
        .relations: R.image.sphereRelations(),
        .health: R.image.sphereHealth(),
        .environment: R.image.sphereEnvironment(),
        .finance: R.image.sphereFinance(),
        .work: R.image.sphereWork(),
        .relax: R.image.sphereRelax(),
        .creation: R.image.sphereCreation(),
        .spirit: R.image.sphereSpirit()
    ]

    private static let colorMapper: [Sphere: UIColor] = [
        .relations: #colorLiteral(red: 1, green: 0.7960784314, blue: 0.7960784314, alpha: 1),
        .health: #colorLiteral(red: 0.7137254902, green: 0.9450980392, blue: 1, alpha: 1),
        .environment: #colorLiteral(red: 0.7607843137, green: 1, blue: 0.9529411765, alpha: 1),
        .finance: #colorLiteral(red: 1, green: 0.9607843137, blue: 0.2235294118, alpha: 1),
        .work: #colorLiteral(red: 1, green: 0.4, blue: 0.4, alpha: 1),
        .relax: #colorLiteral(red: 0.2, green: 0.8784313725, blue: 0.631372549, alpha: 1),
        .creation: #colorLiteral(red: 0.5137254902, green: 0.1725490196, blue: 1, alpha: 1),
        .spirit: #colorLiteral(red: 0.8039215686, green: 0.5333333333, blue: 0.9490196078, alpha: 1)
    ]

    private static let titleColorMapper: [Sphere: UIColor] = [
        .relations: #colorLiteral(red: 0.4862745098, green: 0, blue: 0.4509803922, alpha: 1),
        .health: #colorLiteral(red: 0, green: 0.4549019608, blue: 0.5764705882, alpha: 1),
        .environment: #colorLiteral(red: 0, green: 0.5176470588, blue: 0.3568627451, alpha: 1),
        .finance: #colorLiteral(red: 0.3450980392, green: 0, blue: 0.8862745098, alpha: 1),
        .work: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        .relax: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        .creation: #colorLiteral(red: 1, green: 0.8666666667, blue: 0.8235294118, alpha: 1),
        .spirit: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    ]

}
