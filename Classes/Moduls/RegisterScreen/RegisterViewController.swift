//
//  RegisterViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 15.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase
import Toaster

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerButtonLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelImageView: UIImageView!
    
    var completion: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        customizeView()
    }

    @IBAction func registerButtonDidPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if FormValidator.isFormValid(email: email, password: password) {
            self.showActivityIndicator(onView: self.view)
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] authResult, error in
                self?.removeActivityIndicator()
                
                if let error = error {
                    Toast(text: "\(error.localizedDescription)").show()
                    return
                }
                
                if let _ = Auth.auth().currentUser {
                    Toast(text: R.string.localizable.registerSuccessAlert(),
                          delay: 0,
                          duration: 3)
                        .show()
                    self?.completion()
                } else {
                    self?.dismiss(animated: true, completion: nil)
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
        emailLabel.textColor = .gray
        emailLabel.font = .formLabelFieldFont
        
        emailTextField.borderStyle = .none
        emailTextField.font = .formFieldFont
        emailTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.authEnterEmail(),
                                                                  attributes: NSAttributedString.formFieldPlaceholderAttributes)
        passwordLabel.textColor = .gray
        passwordLabel.font = .formLabelFieldFont
        passwordLabel.text = R.string.localizable.authPassword()
        
        passwordTextField.borderStyle = .none
        passwordTextField.font = .formFieldFont
        passwordTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.authEnterPassword(),
                                                                     attributes: NSAttributedString.formFieldPlaceholderAttributes)
        registerView.backgroundColor = .violet
        registerView.layer.cornerRadius = 5
        
        registerButton.clipsToBounds = true
        registerButton.setTitle("", for: .normal)
        registerButtonLabel.text = R.string.localizable.authDoRegister().uppercased()
        registerButtonLabel.textColor = .white
        registerButtonLabel.font = .formButtonFont
        
        cancelButton.setTitle("", for: .normal)
        cancelImageView.image = cancelImageView.image?.withRenderingMode(.alwaysTemplate)
        cancelImageView.tintColor = .violet
    }
}
