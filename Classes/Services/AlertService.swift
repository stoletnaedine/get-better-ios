//
// Created by Artur Islamgulov on 07.06.2020.
// Copyright (c) 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol AlertServiceProtocol {
    func showPopUpMessage(title: String, description: String, buttonText: String)
    func showErrorMessage(_ message: String)
    func showSuccessMessage(_ message: String)
}

class AlertService: UIViewController, AlertServiceProtocol {

    func showPopUpMessage(title: String, description: String, buttonText: String) {
        let attributes = setupPopUpAttributes(duration: .infinity)
        let message = setupPopUpMessage(title: title, description: description, buttonText: buttonText)
        SwiftEntryKit.display(entry: CustomPopUpView(with: message), using: attributes)
    }

    func showErrorMessage(_ message: String) {
        showNotificationMessage(
            title: R.string.localizable.error(),
            desc: message,
            textColor: .white,
            colors: [EKColor(.coral), EKColor(.violet)],
            image: R.image.error())
    }

    func showSuccessMessage(_ message: String) {
        showNotificationMessage(
            title: R.string.localizable.success(),
            desc: message,
            textColor: .white,
            colors: [EKColor(.violet), EKColor(.coral)],
            image: R.image.success())
    }
}

// MARK: — Private methods

extension AlertService {

    private func showNotificationMessage(
        title: String,
        desc: String,
        textColor: EKColor,
        colors: [EKColor],
        image: UIImage? = nil) {
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: UIFont.systemFont(ofSize: 16),
                color: textColor,
                displayMode: .inferred
            ),
            accessibilityIdentifier: "title"
        )
        let description = EKProperty.LabelContent(
            text: desc,
            style: .init(
                font: UIFont.systemFont(ofSize: 14),
                color: textColor,
                displayMode: .inferred
            ),
            accessibilityIdentifier: "description"
        )
        var imageContent: EKProperty.ImageContent?
        if let image = image {
            imageContent = EKProperty.ImageContent(
                image: image.withRenderingMode(.alwaysTemplate),
                displayMode: .inferred,
                size: CGSize(width: 35, height: 35),
                tint: textColor,
                accessibilityIdentifier: "thumbnail"
            )
        }
        let simpleMessage = EKSimpleMessage(
            image: imageContent,
            title: title,
            description: description
        )
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        let attributes = setupTopFloatAttributes(colors: colors)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }

    private func setupTopFloatAttributes(colors: [EKColor]) -> EKAttributes {
        var attributes: EKAttributes
        attributes = .topFloat
        attributes.displayMode = .inferred
        attributes.hapticFeedbackType = .success
        attributes.entryBackground = .gradient(
            gradient: .init(
                colors: colors,
                startPoint: .zero,
                endPoint: CGPoint(x: 1, y: 1)
            )
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.3),
                scale: .init(from: 1, to: 0.7, duration: 1.0)
            )
        )
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.5,
                radius: 10
            )
        )
        attributes.statusBar = .dark
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .easeOut
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.minEdge),
            height: .intrinsic
        )
        return attributes
    }

    private func setupPopUpMessage(title: String, description: String, buttonText: String) -> EKPopUpMessage {
        let image = R.image.gPoint()!

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
                text: buttonText,
                style: .init(
                    font: UIFont.systemFont(ofSize: 16),
                    color: .white
                )
            ),
            backgroundColor: .init(.violet),
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

    private func setupPopUpAttributes(duration: EKAttributes.DisplayDuration) -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = duration
        attributes.screenBackground = .color(color: .init(
                                                light: UIColor(white: 100.0 / 255.0, alpha: 0.3),
                                                dark: UIColor(white: 50.0 / 255.0, alpha: 0.3))
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
