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

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordView: UIView!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var resetPasswordButtonLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        customizeView()
    }

    @IBAction func resetPasswordButtonDidPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !email.isEmpty else {
                Toast(text: "Введите email").show()
                return
        }
        
        self.showActivityIndicator(onView: self.view)
        Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            
            self.removeActivityIndicator()
            
            if let error = error {
                Toast(text: error.localizedDescription).show()
            } else {
                Toast(text: "Письмо отправлено на ваш email. Проверьте почту", delay: 1, duration: 5).show()
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func customizeView() {
        self.title = "Сбросить пароль"
        emailLabel.text = Constants.Auth.email
        emailLabel.textColor = .gray
        emailLabel.font = UIFont.systemFont(ofSize: 13)
        emailTextField.borderStyle = .none
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: Constants.Auth.enterEmail,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderGray,
                                                                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        
        resetPasswordView.backgroundColor = .violet
        resetPasswordView.layer.cornerRadius = 5
        resetPasswordButton.clipsToBounds = true
        resetPasswordButton.setTitle("", for: .normal)
        resetPasswordButtonLabel.text = "Сбросить пароль".uppercased()
        resetPasswordButtonLabel.textColor = .white
        resetPasswordButtonLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.text = "На указанный email придёт ссылка, пройдя по которой вы сможете изменить пароль."
        cancelButton.setTitle("", for: .normal)
    }
}
