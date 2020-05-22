//
//  AuthViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 10.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase
import Toaster

class AuthViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeImageView: UIImageView!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var enterView: UIView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var enterLabel: UILabel!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var anonymButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var signInCompletion: () -> () = {}
    var registerCompletion: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        customizeView()
    }
    
    @IBAction func eyeButtonDidPressed(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if eyeImageView.tintColor == .gray {
            eyeImageView.tintColor = .violet
        } else {
            eyeImageView.tintColor = .gray
        }
    }
    
    @IBAction func enterButtonDidPressed(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if FormValidator.isFormValid(email: email, password: password) {
            
            self.showActivityIndicator(onView: self.view)

            Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
                
                self?.removeActivityIndicator()

                if let error = error {
                    Toast(text: "\(Constants.Error.firebaseError)\(error.localizedDescription)").show()
                } else {
                    let _ = KeychainHelper.saveCredentials(email: email)
                    self?.signInCompletion()
                }
            })
        }
    }
    
    @IBAction func forgotPasswordDidPressed(_ sender: UIButton) {
        let resetPasswordViewController = ResetPasswordViewController()
        present(resetPasswordViewController, animated: true, completion: nil)
    }
    
    @IBAction func registerButtonDidPressed(_ sender: UIButton) {
        let registerViewController = RegisterViewController()
        registerViewController.completion = { [weak self] in
            self?.registerCompletion()
        }
        present(registerViewController, animated: true, completion: nil)
    }
    
    @IBAction func anonymRegisterButtonDidTapped(_ sender: UIButton) {
        
        Auth.auth().signInAnonymously(completion: { [weak self] authResult, error in
            
            if let error = error {
                Toast(text: "\(Constants.Error.firebaseError)\(error.localizedDescription)").show()
            } else {
                self?.registerCompletion()
            }
        })
    }
    
    func customizeView() {
        self.title = Constants.Auth.authTitleVC
        
        emailLabel.text = Constants.Auth.email
        emailLabel.textColor = .gray
        emailLabel.font = UIFont.systemFont(ofSize: 13)
        
        emailTextField.borderStyle = .none
        emailTextField.attributedPlaceholder = NSAttributedString(string: Constants.Auth.enterEmail,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderGray,
                                                                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        if let email = KeychainHelper.getUserEmail() {
            emailTextField.text = email
        }

        passwordLabel.text = Constants.Auth.password
        passwordLabel.textColor = .gray
        passwordLabel.font = UIFont.systemFont(ofSize: 13)
        
        passwordTextField.borderStyle = .none
        passwordTextField.attributedPlaceholder = NSAttributedString(string: Constants.Auth.enterPassword,
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderGray,
                                                                                  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        passwordTextField.isSecureTextEntry = true
        eyeImageView.image = UIImage(named: "combinedShape")
        eyeButton.setTitle("", for: .normal)
        
        enterView.backgroundColor = .violet
        enterView.layer.cornerRadius = 5
        enterView.clipsToBounds = true
        enterButton.setTitle("", for: .normal)
        enterLabel.text = Constants.Auth.enter.uppercased()
        enterLabel.textColor = .white
        enterLabel.font = UIFont.systemFont(ofSize: 15)
        
        forgotButton.setTitle(Constants.Auth.forgotPassword, for: .normal)
        forgotButton.setTitleColor(.violet, for: .normal)
        forgotButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        forgotButton.titleLabel?.underline()
        
        registrationButton.setTitle(Constants.Auth.register, for: .normal)
        registrationButton.setTitleColor(.violet, for: .normal)
        registrationButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        registrationButton.titleLabel?.underline()
        
        anonymButton.setTitle("Продолжить без регистрации", for: .normal)
        anonymButton.setTitleColor(.violet, for: .normal)
        anonymButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        anonymButton.titleLabel?.underline()
        
        logoImageView.image = logoImageView.image?.withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = .violet
        
        eyeImageView.image = eyeImageView.image?.withRenderingMode(.alwaysTemplate)
        eyeImageView.tintColor = .gray
    }
}