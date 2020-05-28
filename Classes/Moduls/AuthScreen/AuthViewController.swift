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
                    Toast(text: "\(error.localizedDescription)").show()
                } else {
                    KeychainHelper.saveUserEmail(email)
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
    
    @IBAction func anonymousRegisterButtonDidTap(_ sender: UIButton) {
        
        Auth.auth().signInAnonymously(completion: { [weak self] authResult, error in
            
            if let error = error {
                Toast(text: "\(error.localizedDescription)").show()
            } else {
                self?.registerCompletion()
            }
        })
    }
    
    func customizeView() {
        self.title = R.string.localizable.authTitle()
        
        emailLabel.text = R.string.localizable.authEmail()
        emailLabel.textColor = .gray
        emailLabel.font = .formLabelFieldFont
        
        emailTextField.borderStyle = .none
        emailTextField.font = .formFieldFont
        emailTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.authEnterEmail(),
                                                                  attributes: NSAttributedString.formFieldPlaceholderAttributes)
        if let email = KeychainHelper.getUserEmail() {
            emailTextField.text = email
        }

        passwordLabel.text = R.string.localizable.authPassword()
        passwordLabel.textColor = .gray
        passwordLabel.font = .formLabelFieldFont
        
        passwordTextField.borderStyle = .none
        passwordTextField.font = .formFieldFont
        passwordTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.authEnterPassword(),
                                                                     attributes: NSAttributedString.formFieldPlaceholderAttributes)
        passwordTextField.isSecureTextEntry = true
        eyeImageView.image = R.image.combinedShape()
        eyeButton.setTitle("", for: .normal)
        
        enterView.backgroundColor = .violet
        enterView.layer.cornerRadius = 5
        enterView.clipsToBounds = true
        enterButton.setTitle("", for: .normal)
        enterLabel.text = R.string.localizable.authEnter().uppercased()
        enterLabel.textColor = .white
        enterLabel.font = .formButtonFont
        
        forgotButton.setTitle(R.string.localizable.authForgotPassword(), for: .normal)
        forgotButton.setTitleColor(.violet, for: .normal)
        forgotButton.titleLabel?.font = .formButtonFont
        forgotButton.titleLabel?.underline()
        
        registrationButton.setTitle(R.string.localizable.authRegister(), for: .normal)
        registrationButton.setTitleColor(.violet, for: .normal)
        registrationButton.titleLabel?.font = .formButtonFont
        registrationButton.titleLabel?.underline()
        
        anonymButton.setTitle(R.string.localizable.authAnonymButton(), for: .normal)
        anonymButton.setTitleColor(.violet, for: .normal)
        anonymButton.titleLabel?.font = .formButtonFont
        anonymButton.titleLabel?.underline()
        
        logoImageView.image = logoImageView.image?.withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = .violet
        
        eyeImageView.image = eyeImageView.image?.withRenderingMode(.alwaysTemplate)
        eyeImageView.tintColor = .gray
    }
}
