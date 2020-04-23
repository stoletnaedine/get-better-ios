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
    
    @IBOutlet weak var description1Label: UILabel!
    @IBOutlet weak var icon1ImageView: UIImageView!
    @IBOutlet weak var icon2ImageView: UIImageView!
    @IBOutlet weak var icon3ImageView: UIImageView!
    @IBOutlet weak var description2Label: UILabel!
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
    
    var completion: (() -> ()) = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        customizeView()
    }
    
    @IBAction func eyeButtonDidPressed(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func enterButtonDidPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if FormValidator.isFormValid(email: email, password: password) {

            Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in

                if let error = error {
                    Toast(text: "\(Properties.Error.firebaseError)\(error.localizedDescription)").show()
                    return
                }
                
                if KeychainHelper.saveCredentials(email: email) {
                    Toast(text: Properties.Keychain.emailSuccessSaved).show()
                }
                
                guard let self = self else { return }
                self.completion()
            })
        }
    }
    
    @IBAction func forgotPasswordDidPressed(_ sender: UIButton) {
        print("forgotPasswordDidPressed")
    }
    
    @IBAction func registerButtonDidPressed(_ sender: UIButton) {
        let registerViewController = RegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func customizeView() {
        self.title = Properties.Auth.authTitleVC
        description1Label.text = Properties.Auth.description1
        description1Label.font = UIFont(name: Properties.Font.SFUITextRegular, size: 15)
        description1Label.textColor = .darkGrey
        
        icon1ImageView.image = UIImage(named: "vk")
        icon2ImageView.image = UIImage(named: "fb")
        icon3ImageView.image = UIImage(named: "ok")
        description2Label.text = Properties.Auth.description2
        description2Label.font = UIFont(name: Properties.Font.SFUITextRegular, size: 15)
        description2Label.textColor = .darkGrey
        
        emailLabel.text = Properties.Auth.email
        emailLabel.textColor = .grayEvent
        emailLabel.font = UIFont(name: Properties.Font.SFUITextRegular, size: 13)
        
        emailTextField.borderStyle = .none
        emailTextField.attributedPlaceholder = NSAttributedString(string: Properties.Auth.enterEmail,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderGrey,
                                                                               NSAttributedString.Key.font: UIFont(name: Properties.Font.SFUITextRegular, size: 17)!])

        passwordLabel.text = Properties.Auth.password
        passwordLabel.textColor = .grayEvent
        passwordLabel.font = UIFont(name: Properties.Font.SFUITextRegular, size: 13)
        
        passwordTextField.borderStyle = .none
        passwordTextField.attributedPlaceholder = NSAttributedString(string: Properties.Auth.enterPassword,
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderGrey,
                                                                                  NSAttributedString.Key.font: UIFont(name: Properties.Font.SFUITextRegular, size: 17)!])
        passwordTextField.isSecureTextEntry = true
        eyeImageView.image = UIImage(named: "combinedShape")
        eyeButton.setTitle("", for: .normal)
        
        enterView.backgroundColor = .sky
        enterView.layer.cornerRadius = 5
        enterView.clipsToBounds = true
        enterButton.setTitle("", for: .normal)
        enterLabel.text = Properties.Auth.enter.uppercased()
        enterLabel.textColor = .white
        enterLabel.font = UIFont(name: Properties.Font.SFUITextMedium, size: 15)
        
        forgotButton.setTitle(Properties.Auth.forgotPassword, for: .normal)
        forgotButton.setTitleColor(.sky, for: .normal)
        forgotButton.titleLabel?.font = UIFont(name: Properties.Font.SFUITextRegular, size: 15)
        forgotButton.titleLabel?.underline()
        
        registrationButton.setTitle(Properties.Auth.register, for: .normal)
        registrationButton.setTitleColor(.sky, for: .normal)
        registrationButton.titleLabel?.font = UIFont(name: Properties.Font.SFUITextRegular, size: 15)
        registrationButton.titleLabel?.underline()
    }
}
