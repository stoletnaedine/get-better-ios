//
//  AuthViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 10.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase

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
    @IBOutlet weak var needHelpButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var signInCompletion: VoidClosure?
    private let alertService: AlertServiceProtocol = AlertService()
    private var userDataService: UserDataServiceProtocol = UserDataService()
    private let connectionHelper = ConnectionHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupView()
    }
    
    @IBAction func eyeButtonDidPressed(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        if eyeImageView.tintColor == .grey {
            eyeImageView.image = R.image.openEye()
            eyeImageView.tint(with: .violet)
        } else {
            eyeImageView.image = R.image.closedEye()
            eyeImageView.tint(with: .grey)
        }
    }
    
    @IBAction func enterButtonDidPressed(_ sender: UIButton) {
        guard connectionHelper.isConnect() else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard FormValidator.isFormValid(email: email, password: password) else { return }

        self.showLoadingAnimation(on: self.view)
        Auth.auth().signIn(withEmail: email,
                           password: password,
                           completion: { [weak self] authResult, error in
            guard let self = self else { return }
            self.stopAnimation()

            if let error = error, let appError = AppError(firebaseError: error).name {
                self.alertService.showErrorMessage(appError)
            } else {
                self.userDataService.email = email
                self.signInCompletion?()
            }
        })
    }
    
    @IBAction func forgotPasswordDidPressed(_ sender: UIButton) {
        guard connectionHelper.isConnect() else { return }
        present(ResetPasswordViewController(), animated: true, completion: nil)
    }
    
    @IBAction func registerButtonDidPressed(_ sender: UIButton) {
        guard connectionHelper.isConnect() else { return }
        let registerViewController = RegisterViewController()
        registerViewController.completion = { [weak self] in
            self?.signInCompletion?()
        }
        present(registerViewController, animated: true, completion: nil)
    }
    
    @IBAction func anonymousRegisterButtonDidTap(_ sender: UIButton) {
        guard connectionHelper.isConnect() else { return }
        self.showLoadingAnimation(on: self.view)
        Auth.auth().signInAnonymously(completion: { [weak self] authResult, error in
            guard let self = self else { return }
            self.stopAnimation()
            
            if let error = error,
                let appError = AppError(firebaseError: error).name {
                self.alertService.showErrorMessage(appError)
            } else {
                self.signInCompletion?()
            }
        })
    }

    @IBAction func needHelpButtonDidTap(_ sender: UIButton) {
        UIApplication.shared.open(Properties.stoletnaedineTelegram, options: [:], completionHandler: nil)
    }
}

// MARK: Setup View
extension AuthViewController {
    
    func setupView() {
        emailLabel.text = R.string.localizable.authEmail()
        emailLabel.textColor = .grey
        emailLabel.font = .formLabelFieldFont
        
        emailTextField.borderStyle = .none
        emailTextField.font = .formFieldFont
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.authEnterEmail(),
            attributes: NSAttributedString.formFieldPlaceholderAttributes
        )
        if let email = userDataService.email {
            emailTextField.text = email
        }

        passwordLabel.text = R.string.localizable.authPassword()
        passwordLabel.textColor = .grey
        passwordLabel.font = .formLabelFieldFont
        
        passwordTextField.borderStyle = .none
        passwordTextField.font = .formFieldFont
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.authEnterPassword(),
            attributes: NSAttributedString.formFieldPlaceholderAttributes
        )
        passwordTextField.isSecureTextEntry = true
        eyeImageView.image = R.image.closedEye()
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

        needHelpButton.setTitle(R.string.localizable.settingsAboutAppNeedHelp(), for: .normal)
        needHelpButton.setTitleColor(.violet, for: .normal)
        needHelpButton.titleLabel?.font = .formButtonFont
        needHelpButton.titleLabel?.underline()
        
        logoImageView.tint(with: .violet)
        eyeImageView.tint(with: .grey)
    }
}
