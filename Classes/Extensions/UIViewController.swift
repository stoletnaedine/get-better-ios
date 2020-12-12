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
    
    // MARK: — Dismiss keyboard
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: — Activity indicator
    
//    func showActivityIndicator(onView : UIView) {
//        let aiView = UIView.init(frame: UIScreen.main.bounds)
//        aiView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
//        var ai = UIActivityIndicatorView()
//        if #available(iOS 13.0, *) {
//            ai = UIActivityIndicatorView.init(style: .large)
//        }
//        ai.color = .white
//        ai.startAnimating()
//        ai.center = aiView.center
//        
//        DispatchQueue.main.async {
//            aiView.addSubview(ai)
//            onView.addSubview(aiView)
//        }
//        
//        activityIndicatoriView = aiView
//    }
//    
//    func removeActivityIndicator() {
//        DispatchQueue.main.async {
//            activityIndicatoriView?.removeFromSuperview()
//            activityIndicatoriView = nil
//        }
//    }
    
    // MARK: — Animations
    
    func showAnimation(name: AnimationName,
                       on view: UIView,
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
        animationView.loopMode = .loop
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
        guard let animationView = animationView else { return }
        animationView.stop()
        animationView.removeFromSuperview()
        
        guard let animationScreenView = animationScreenView else { return }
        animationScreenView.removeFromSuperview()
    }
    
    func showLoadingAnimation(on view: UIView) {
        showAnimation(
            name: .loadingSuccess,
            on: view,
            whiteScreen: true,
            size: .init(width: 75, height: 75)
        )
    }
    
}
