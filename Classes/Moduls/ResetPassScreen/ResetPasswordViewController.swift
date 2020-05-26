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
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        customizeView()
    }

    @IBAction func resetPasswordButtonDidPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !email.isEmpty else {
                Toast(text: "Введите E-mail").show()
                return
        }
        
        self.showActivityIndicator(onView: self.view)
        Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            
            self.removeActivityIndicator()
            
            if let error = error {
                Toast(text: error.localizedDescription).show()
            } else {
                Toast(text: "Письмо отправлено на ваш E-mail. Проверьте почту", delay: 1, duration: 5).show()
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func customizeView() {
        self.title = "Сбросить пароль"
        emailLabel.text = GlobalDefiitions.Auth.email
        emailLabel.textColor = .gray
        emailLabel.font = .formLabelFieldFont
        emailTextField.borderStyle = .none
        emailTextField.font = .formFieldFont
        emailTextField.attributedPlaceholder = NSAttributedString(string: GlobalDefiitions.Auth.enterEmail,
                                                                  attributes: NSAttributedString.formFieldPlaceholderAttributes)
        resetPasswordView.backgroundColor = .violet
        resetPasswordView.layer.cornerRadius = 5
        resetPasswordButton.clipsToBounds = true
        resetPasswordButton.setTitle("", for: .normal)
        resetPasswordButtonLabel.text = "Сбросить пароль".uppercased()
        resetPasswordButtonLabel.textColor = .white
        resetPasswordButtonLabel.font = .formButtonFont
        
        noticeLabel.font = .formNoticeFont
        noticeLabel.text = "На указанный E-mail придёт ссылка, пройдя по которой вы сможете изменить пароль."
        
        cancelButton.setTitle("", for: .normal)
        cancelImageView.image = cancelImageView.image?.withRenderingMode(.alwaysTemplate)
        cancelImageView.tintColor = .violet
    }
}
