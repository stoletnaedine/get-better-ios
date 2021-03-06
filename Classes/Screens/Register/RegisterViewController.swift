//
//  RegisterViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 15.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerButtonLabel: UILabel!
    
    var completion: VoidClosure?

    private let alertService: AlertServiceProtocol = AlertService()
    private var userDataService: UserDataServiceProtocol = UserDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        customizeView()
    }

    @IBAction func registerButtonDidPressed(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if FormValidator.isFormValid(email: email, password: password) {
            self.showLoadingAnimation(on: self.view)
            
            Auth.auth().createUser(withEmail: email,
                                   password: password,
                                   completion: { [weak self] authResult, error in
                guard let self = self else { return }
                self.stopAnimation()
                
                if let error = error,
                    let appError = AppError(firebaseError: error).name {
                    self.alertService.showErrorMessage(appError)
                } else {
                    if let _ = Auth.auth().currentUser {
                        self.userDataService.email = email
                        self.alertService.showSuccessMessage(R.string.localizable.registerSuccessAlert())
                        self.completion?()
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func customizeView() {
        title = R.string.localizable.authRegister()
        emailLabel.text = R.string.localizable.authEmail()
        emailLabel.textColor = .grey
        emailLabel.font = .formLabelFieldFont
        
        emailTextField.borderStyle = .none
        emailTextField.font = .formFieldFont
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.authEnterEmail(),
            attributes: NSAttributedString.formFieldPlaceholderAttributes
        )
        passwordLabel.textColor = .grey
        passwordLabel.font = .formLabelFieldFont
        passwordLabel.text = R.string.localizable.authPassword()
        
        passwordTextField.borderStyle = .none
        passwordTextField.font = .formFieldFont
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.authEnterPassword(),
            attributes: NSAttributedString.formFieldPlaceholderAttributes
        )
        registerView.backgroundColor = .violet
        registerView.layer.cornerRadius = 5
        
        registerButton.clipsToBounds = true
        registerButton.setTitle("", for: .normal)
        registerButtonLabel.text = R.string.localizable.authDoRegister().uppercased()
        registerButtonLabel.textColor = .white
        registerButtonLabel.font = .formButtonFont
    }
}
