//
//  RegisterViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 15.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordView: UIView!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var resetPasswordButtonLabel: UILabel!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelImageView: UIImageView!
    
    let alertService: AlertService = AppAlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        customizeView()
    }

    @IBAction func resetPasswordButtonDidPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !email.isEmpty else {
                alertService.showErrorMessage(desc: R.string.localizable.emailIsEmpty())
                return
        }
        
        self.showActivityIndicator(onView: self.view)
        Auth.auth().sendPasswordReset(withEmail: email, completion: { [weak self] error in
            
            self?.removeActivityIndicator()
            
            if let error = error {
                self?.alertService.showErrorMessage(desc: error.localizedDescription)
            } else {
                self?.alertService.showSuccessMessage(desc: R.string.localizable.resetPasswordAlertEmail())
                self?.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func customizeView() {
        title = R.string.localizable.resetPasswordTitle()
        emailLabel.text = R.string.localizable.authEmail()
        emailLabel.textColor = .gray
        emailLabel.font = .formLabelFieldFont
        emailTextField.borderStyle = .none
        emailTextField.font = .formFieldFont
        emailTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.authEnterEmail(),
                                                                  attributes: NSAttributedString.formFieldPlaceholderAttributes)
        resetPasswordView.backgroundColor = .violet
        resetPasswordView.layer.cornerRadius = 5
        resetPasswordButton.clipsToBounds = true
        resetPasswordButton.setTitle("", for: .normal)
        resetPasswordButtonLabel.text = R.string.localizable.resetPasswordButton().uppercased()
        resetPasswordButtonLabel.textColor = .white
        resetPasswordButtonLabel.font = .formButtonFont
        
        noticeLabel.font = .formNoticeFont
        noticeLabel.text = R.string.localizable.resetPasswordNoticeLabel()
        
        cancelButton.setTitle("", for: .normal)
        cancelImageView.image = cancelImageView.image?.withRenderingMode(.alwaysTemplate)
        cancelImageView.tintColor = .violet
    }
}
