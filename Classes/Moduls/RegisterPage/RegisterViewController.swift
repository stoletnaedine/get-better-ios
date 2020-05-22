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
                    Toast(text: "Firebase: \(error.localizedDescription)").show()
                    return
                }
                
                if let _ = Auth.auth().currentUser {
                    Toast(text: "Вы успешно зарегистрировались", delay: 0, duration: 3).show()
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
        self.title = GlobalDefiitions.Auth.register
        emailLabel.text = GlobalDefiitions.Auth.email
        emailLabel.textColor = .gray
        emailLabel.font = UIFont.systemFont(ofSize: 13)
        emailTextField.borderStyle = .none
        
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.placeholderGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: GlobalDefiitions.Auth.enterEmail, attributes: stringAttributes)
        
        passwordLabel.textColor = .gray
        passwordLabel.font = UIFont.systemFont(ofSize: 13)
        passwordLabel.text = GlobalDefiitions.Auth.password
        
        passwordTextField.borderStyle = .none
        passwordTextField.attributedPlaceholder = NSAttributedString(string: GlobalDefiitions.Auth.enterPassword, attributes: stringAttributes)
        
        registerView.backgroundColor = .violet
        registerView.layer.cornerRadius = 5
        registerButton.clipsToBounds = true
        registerButton.setTitle("", for: .normal)
        registerButtonLabel.text = GlobalDefiitions.Auth.doRegister.uppercased()
        registerButtonLabel.textColor = .white
        registerButtonLabel.font = UIFont.systemFont(ofSize: 15)
        cancelButton.setTitle("", for: .normal)
    }
}
