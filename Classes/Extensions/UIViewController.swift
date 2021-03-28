//
//  UIViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 17.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Lottie

var activityIndicatoriView: UIView?
var animationView: AnimationView?
var animationScreenView: UIView?

extension UIViewController {

    // MARK: — Remove back button title

    func removeBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: — Dismiss keyboard
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: — Animations
    
    func showAnimation(name: AnimationName,
                       on view: UIView,
                       loopMode: LottieLoopMode = .repeat(5),
                       whiteScreen: Bool = false,
                       size: CGSize? = nil,
                       speed: CGFloat = 1) {
        animationView = AnimationView(name: name.value)
        guard let animationView = animationView else { return }
        var bounds: CGRect = .zero
        if let size = size {
            let origin = CGPoint(x: (view.frame.width - size.width) / 2,
                                 y: (view.frame.height - size.height) / 2)
            bounds = CGRect(origin: origin, size: size)
        } else {
            bounds = view.bounds
        }
        animationView.frame = bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = speed
        
        if whiteScreen {
            animationScreenView = UIView.init(frame: UIScreen.main.bounds)
            guard let animationScreenView = animationScreenView else { return }
            animationScreenView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            animationScreenView.addSubview(animationView)
            view.addSubview(animationScreenView)
        } else {
            view.addSubview(animationView)
        }
        animationView.play(completion: { _ in
            animationView.removeFromSuperview()
            animationScreenView?.removeFromSuperview()
        })
    }
    
    func stopAnimation() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.5,
            execute: { [weak animationView, animationScreenView] in
                guard let animationView = animationView else { return }
                animationView.removeFromSuperview()

                guard let animationScreenView = animationScreenView else { return }
                animationScreenView.removeFromSuperview()
            })
    }
    
    func showLoadingAnimation(on view: UIView, whiteScreen: Bool = true) {
        showAnimation(
            name: .loading,
            on: view,
            whiteScreen: whiteScreen,
            size: .init(width: 150, height: 150))
    }
    
}
