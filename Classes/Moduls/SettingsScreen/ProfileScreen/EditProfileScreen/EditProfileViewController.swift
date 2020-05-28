//
//  EditProfileViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 21.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import Toaster

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    let user = Auth.auth().currentUser
    let storageService = FirebaseStorageService()
    
    var completion: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = R.string.localizable.profileEditTitle()
        customizeBarButon()
        customizeView()
    }

    @IBAction func avatarButtonDidTap(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func saveProfile() {
        guard let user = user else { return }
        
        let dispatchGroup = DispatchGroup()
        
        if let newAvatar = avatarImageView.image {
            
            dispatchGroup.enter()
            self.showActivityIndicator(onView: self.view)
            
            storageService.uploadAvatar(photo: newAvatar, completion: { result in
                switch result {
                case .success(let url):
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.photoURL = url
                    changeRequest.commitChanges(completion: { error in
                        if let error = error {
                            print("Firebase commit changes error = \(error.localizedDescription)")
                            Toast(text: "\(error.localizedDescription)").show()
                        }
                        dispatchGroup.leave()
                    })
                case .failure(let error):
                    Toast(text: "\(String(describing: error.name))").show()
                    dispatchGroup.leave()
                }
            })
        }
        
        if let newName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !newName.isEmpty,
            newName != user.displayName {
            
            dispatchGroup.enter()
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = newName
            changeRequest.commitChanges(completion: { error in
                if let error = error {
                    Toast(text: "\(error.localizedDescription)").show()
                }
                dispatchGroup.leave()
            })
        }
        
        if let newPassword = passwordTextField.text,
            !newPassword.isEmpty {
            
            dispatchGroup.enter()
            
            user.updatePassword(to: newPassword, completion: { error in
                if let error = error {
                    Toast(text: "\(error.localizedDescription)").show()
                } else {
                    Toast(text: R.string.localizable.editProfileSuccessPassChanged()).show()
                }
                dispatchGroup.leave()
            })
        }
        
        if let newEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !newEmail.isEmpty,
            newEmail != user.email {
            
            dispatchGroup.enter()
            
            user.updateEmail(to: newEmail, completion: { error in
                
                dispatchGroup.leave()
                
                if let error = error {
                    Toast(text: "\(error.localizedDescription)").show()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            self?.removeActivityIndicator()
            self?.navigationController?.popViewController(animated: true)
            self?.completion()
        })
    }
    
    @IBAction func deleteAccountButtonDidTap(_ sender: UIButton) {
        guard let user = user else { return }
    
        let alert = UIAlertController(title: R.string.localizable.editProfileDelAccountAlertTitle(),
                                      message: R.string.localizable.editProfileDelAccountAlertMessage(),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: R.string.localizable.editProfileDelAccountAlertYesButton(),
                                      style: .destructive, handler: { _ in
            user.delete(completion: { error in
                if let error = error {
                    Toast(text: error.localizedDescription,
                          delay: 0,
                          duration: 5)
                        .show()
                } else {
                    Toast(text: R.string.localizable.editProfileDelAccountSuccessMessage(),
                          delay: 0,
                          duration: 5)
                        .show()
                    NotificationCenter.default.post(name: .logout, object: nil)
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: R.string.localizable.editProfileDelAccountAlertNoButton(),
                                      style: .default,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func customizeView() {
        avatarView.backgroundColor = .tableViewSectionColor
        avatarButton.setTitle(R.string.localizable.profileLoadAvatar(), for: .normal)
        avatarButton.setTitleColor(.white, for: .normal)
        avatarButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        if let user = user {
            if let name = user.displayName {
                nameTextField.text = name
            } else {
                nameTextField.placeholder = R.string.localizable.profileEnterName()
            }
            
            if let email = user.email {
                emailTextField.text = email
            } else {
                emailTextField.placeholder = R.string.localizable.profileEnterEmail()
            }
        }
        
        nameLabel.text = R.string.localizable.profileName()
        nameLabel.textColor = .gray
        nameLabel.font = .formLabelFieldFont
        
        nameTextField.borderStyle = .none
        nameTextField.font = .formFieldFont
        nameTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.profileEnterName(),
                                                                 attributes: NSAttributedString.formFieldPlaceholderAttributes)
        emailLabel.text = R.string.localizable.profileEmail()
        emailLabel.textColor = .gray
        emailLabel.font = .formLabelFieldFont
        
        emailTextField.borderStyle = .none
        emailTextField.font = .formFieldFont
        emailTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.profileEnterEmail(),
                                                                  attributes: NSAttributedString.formFieldPlaceholderAttributes)
        
        passwordLabel.text = R.string.localizable.profilePassword()
        passwordLabel.textColor = .gray
        passwordLabel.font = .formLabelFieldFont
        
        passwordTextField.placeholder = R.string.localizable.profileEnterPassword()
        passwordTextField.borderStyle = .none
        passwordTextField.font = .formFieldFont
        passwordTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.profileEnterPassword(),
                                                                     attributes: NSAttributedString.formFieldPlaceholderAttributes)
        noticeLabel.font = .formNoticeFont
        noticeLabel.textColor = .gray
        noticeLabel.text = R.string.localizable.profileWarning()
        
        deleteAccountButton.setTitle(R.string.localizable.editProfileDelAccount(), for: .normal)
        deleteAccountButton.setTitleColor(.red, for: .normal)
        deleteAccountButton.titleLabel?.font = .formButtonFont
        deleteAccountButton.titleLabel?.underline()
    }
    
    func customizeBarButon() {
        let saveBarButtom = UIBarButtonItem(title: R.string.localizable.editProfileSave(),
                                            style: .plain,
                                            target: self,
                                            action: #selector(saveProfile))
        navigationItem.rightBarButtonItem = saveBarButtom
    }
}

extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        avatarImageView.image = image
    }
}
