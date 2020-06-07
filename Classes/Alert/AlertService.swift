//
// Created by Artur Islamgulov on 07.06.2020.
// Copyright (c) 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import SwiftEntryKit

class AlertService: UIViewController, AppAlert {
    func showPopUp(icon: String, title: String, description: String) {
        let attributes = setupAttributes()
        let message = setupMessage(icon: icon, title: title, description: description)
        SwiftEntryKit.display(entry: MyPopUpView(with: message), using: attributes)
    }

    private func setupMessage(icon: String, title: String, description: String) -> EKPopUpMessage {
        let image = R.image.attach()!.withRenderingMode(.alwaysTemplate)

        let themeImage = EKPopUpMessage.ThemeImage(
                image: EKProperty.ImageContent(
                        image: image,
                        size: CGSize(width: 60, height: 60),
                        tint: .black,
                        contentMode: .scaleAspectFit
                )
        )

        let titleLabel = EKProperty.LabelContent(
                text: title,
                style: .init(font: UIFont.systemFont(ofSize: 24),
                color: .black,
                alignment: .center)
        )

        let descriptionLabel = EKProperty.LabelContent(
                text: description,
                style: .init(
                        font: UIFont.systemFont(ofSize: 16),
                        color: .black,
                        alignment: .center
                )
        )

        let button = EKProperty.ButtonContent(
                label: .init(
                        text: "Хорошо",
                        style: .init(
                                font: UIFont.systemFont(ofSize: 16),
                                color: .black
                        )
                ),
                backgroundColor: .init(UIColor.systemOrange),
                highlightedBackgroundColor: .clear
        )

        let message = EKPopUpMessage(
                themeImage: themeImage,
                title: titleLabel,
                description: descriptionLabel,
                button: button
        ) {
            SwiftEntryKit.dismiss()
        }
        return message
    }

    private func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: .init(
                light: UIColor(white: 100.0/255.0, alpha: 0.3),
                dark: UIColor(white: 50.0/255.0, alpha: 0.3))
        )
        attributes.shadow = .active(
                with: .init(
                        color: .black,
                        opacity: 0.3,
                        radius: 8
                )
        )

        attributes.entryBackground = .color(color: .standardBackground)
        attributes.roundCorners = .all(radius: 25)

        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
                swipeable: true,
                pullbackAnimation: .jolt
        )

        attributes.entranceAnimation = .init(
                translate: .init(
                        duration: 0.7,
                        spring: .init(damping: 1, initialVelocity: 0)
                ),
                scale: .init(
                        from: 1.05,
                        to: 1,
                        duration: 0.4,
                        spring: .init(damping: 1, initialVelocity: 0)
                )
        )

        attributes.exitAnimation = .init(
                translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
                animation: .init(
                        translate: .init(duration: 0.2)
                )
        )

        attributes.positionConstraints.verticalOffset = 10
        attributes.statusBar = .dark
        return attributes
    }
}
