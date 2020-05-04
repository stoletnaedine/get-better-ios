//
//  UIViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 17.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

var activityIndicatoriView: UIView?
 
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    
    func showActivityIndicator(onView : UIView) {
        let aiView = UIView.init(frame: UIScreen.main.bounds)
        aiView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = aiView.center
        
        DispatchQueue.main.async {
            aiView.addSubview(ai)
            onView.addSubview(aiView)
        }
        
        activityIndicatoriView = aiView
    }
    
    func removeActivityIndicator() {
        DispatchQueue.main.async {
            activityIndicatoriView?.removeFromSuperview()
            activityIndicatoriView = nil
        }
    }
}
