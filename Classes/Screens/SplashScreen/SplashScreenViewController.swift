//
//  SplashScreenViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.05.2021.
//  Copyright © 2021 Artur Islamgulov. All rights reserved.
//

import UIKit
import Lottie

final class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .violet
        showAnimation()
    }

    private func showAnimation() {
        let animationView = AnimationView(name: AnimationName.loginFace.value)
        var bounds: CGRect = .zero
        let origin = CGPoint(x: view.frame.width * 0.14, y: .zero)
        bounds = CGRect(origin: origin, size: view.frame.size)
        animationView.frame = bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        view.addSubview(animationView)
        animationView.play()
    }

}
