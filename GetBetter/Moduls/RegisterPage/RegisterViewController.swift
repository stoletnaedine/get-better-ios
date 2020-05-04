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
    @IBOutlet weak var password1Label: UILabel!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2Label: UILabel!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerButtonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        customizeView()
    }

    @IBAction func registerButtonDidPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password1 = password1TextField.text else { return }
        guard let password2 = password2TextField.text else { return }
        
        if FormValidator.isFormValid(email: email, password1: password1, password2: password2) {
            self.showActivityIndicator(onView: self.view)
            Auth.auth().createUser(withEmail: email, password: password1, completion: { [weak self] authResult, error in
                
                self?.removeActivityIndicator()
                if let error = error {
                    Toast(text: "Firebase: \(error.localizedDescription)").show()
                    return
                }
                
                self?.navigationController?.popViewController(animated: true)
                Toast(text: Constants.Auth.successRegister, delay: 1, duration: 3).show()
            })
            
            
        }
    }
    
    func customizeView() {
        self.title = Constants.Auth.register
        emailLabel.text = Constants.Auth.email
        emailLabel.textColor = .gray
        emailLabel.font = UIFont(name: Constants.Font.SFUITextRegular, size: 13)
        emailTextField.borderStyle = .none
        emailTextField.attributedPlaceholder = NSAttributedString(string: Constants.Auth.enterEmail,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderGray,
                                                                               NSAttributedString.Key.font: UIFont(name: Constants.Font.SFUITextRegular, size: 17)!])
        let passLabelArray = [password1Label, password2Label]
        for label in passLabelArray {
            label!.textColor = .gray
            label!.font = UIFont(name: Constants.Font.SFUITextRegular, size: 13)
        }
        password1Label.text = Constants.Auth.password
        password2Label.text = Constants.Auth.password2
        password1TextField.borderStyle = .none
        password1TextField.attributedPlaceholder = NSAttributedString(string: Constants.Auth.enterPassword,
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderGray,
                                                                                   NSAttributedString.Key.font: UIFont(name: Constants.Font.SFUITextRegular, size: 17)!])
        password2TextField.borderStyle = .none
        password2TextField.attributedPlaceholder = NSAttributedString(string: Constants.Auth.enterPassword2,
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderGray,
                                                                                   NSAttributedString.Key.font: UIFont(name: Constants.Font.SFUITextRegular, size: 17)!])
        registerView.backgroundColor = .violet
        registerView.layer.cornerRadius = 5
        registerButton.clipsToBounds = true
        registerButton.setTitle("", for: .normal)
        registerButtonLabel.text = Constants.Auth.doRegister.uppercased()
        registerButtonLabel.textColor = .white
        registerButtonLabel.font = UIFont(name: Constants.Font.SFUITextMedium, size: 15)
    }
}
