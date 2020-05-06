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
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    let user = Auth.auth().currentUser
    let storageService = FirebaseStorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = Constants.Profile.editTitle
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
        
        if let avatar = avatarImageView.image {
            storageService.uploadAvatar(photo: avatar, completion: { result in
                switch result {
                case .success(let url):
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.photoURL = url
                    changeRequest.commitChanges(completion: { error in
                        if let error = error {
                            print("Firebase commit changes error = \(error.localizedDescription)")
                            Toast(text: "\(Constants.Error.firebaseError)\(error.localizedDescription)").show()
                        }
                    })
                case .failure(let error):
                    Toast(text: "\(Constants.Error.firebaseError)\(String(describing: error.name))").show()
                }
            })
        }
        
        if let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !name.isEmpty,
            name != user.displayName {
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges(completion: { error in
                if let error = error {
                    Toast(text: "\(Constants.Error.firebaseError)\(error.localizedDescription)").show()
                }
            })
        }
        
        if let password = passwordTextField.text,
            !password.isEmpty {
            
            user.updatePassword(to: password, completion: { error in
                if let error = error {
                    Toast(text: "\(Constants.Error.firebaseError)\(error.localizedDescription)").show()
                }
            })
        }
        
        if let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !email.isEmpty,
            email != user.email {
            
            user.updateEmail(to: email, completion: { error in
                if let error = error {
                    Toast(text: "\(Constants.Error.firebaseError)\(error.localizedDescription)").show()
                } else {
                    NotificationCenter.default.post(name: .logout, object: nil)
                }
            })
        }
        
        Toast(text: Constants.Profile.editSuccess, delay: 0.5, duration: 1).show()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAccountButtonDidTap(_ sender: UIButton) {
        guard let user = user else { return }
    
        let alert = UIAlertController(title: "Удалить аккаунт?", message: "Ваш аккаунт и все связанные с ним данные будут безвозвратно удалены", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Да, удалить", style: .destructive, handler: { _ in
            user.delete(completion: { error in
                if let error = error {
                    Toast(text: error.localizedDescription, delay: 0, duration: 5).show()
                } else {
                    Toast(text: "Аккаунт успешно удалён. До новых встреч!", delay: 0, duration: 5).show()
                    NotificationCenter.default.post(name: .logout, object: nil)
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func customizeView() {
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        avatarView.backgroundColor = .gray
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarButton.setTitle(Constants.Profile.loadAvatar, for: .normal)
        avatarButton.setTitleColor(.white, for: .normal)
        avatarButton.titleLabel?.font = UIFont(name: Constants.Font.Ubuntu, size: 12)
        
        if let user = user {
            if let name = user.displayName {
                nameTextField.text = name
            } else {
                nameTextField.placeholder = Constants.Profile.enterName
            }
            
            if let email = user.email {
                emailTextField.text = email
            } else {
                emailTextField.placeholder = Constants.Profile.enterEmail
            }
        }
        nameLabel.text = Constants.Profile.enterName
        emailLabel.text = Constants.Profile.enterEmail
        passwordLabel.text = Constants.Profile.enterPassword
        passwordTextField.placeholder = Constants.Profile.enterPassword
        warningLabel.font = UIFont(name: Constants.Font.Ubuntu, size: 14)
        warningLabel.text = Constants.Profile.warning
        deleteAccountButton.setTitle("Удалить аккаунт", for: .normal)
        deleteAccountButton.setTitleColor(.red, for: .normal)
        deleteAccountButton.titleLabel?.font = UIFont(name: Constants.Font.SFUITextRegular, size: 15)
        deleteAccountButton.titleLabel?.underline()
    }
    
    func customizeBarButon() {
        let saveBarButtom = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProfile))
        navigationItem.rightBarButtonItem = saveBarButtom
    }
}

extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        avatarImageView.image = image
    }
}
