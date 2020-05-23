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
    
    var completion: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = GlobalDefiitions.Profile.editTitle
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
                    print("url=\(url)")
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.photoURL = url
                    changeRequest.commitChanges(completion: { error in
                        if let error = error {
                            print("Firebase commit changes error = \(error.localizedDescription)")
                            Toast(text: "\(GlobalDefiitions.Error.firebaseError)\(error.localizedDescription)").show()
                        }
                        dispatchGroup.leave()
                    })
                case .failure(let error):
                    Toast(text: "\(GlobalDefiitions.Error.firebaseError)\(String(describing: error.name))").show()
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
                    Toast(text: "\(GlobalDefiitions.Error.firebaseError)\(error.localizedDescription)").show()
                }
                dispatchGroup.leave()
            })
        }
        
        if let newPassword = passwordTextField.text,
            !newPassword.isEmpty {
            
            dispatchGroup.enter()
            
            user.updatePassword(to: newPassword, completion: { error in
                if let error = error {
                    Toast(text: "\(GlobalDefiitions.Error.firebaseError)\(error.localizedDescription)").show()
                } else {
                    Toast(text: "Пароль успешно изменён").show()
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
                    Toast(text: "\(GlobalDefiitions.Error.firebaseError)\(error.localizedDescription)").show()
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
    
        let alert = UIAlertController(title: "Удалить аккаунт?",
                                      message: "Ваш аккаунт и все связанные с ним данные будут безвозвратно удалены",
                                      preferredStyle: .alert)
        
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
        avatarView.backgroundColor = .tableViewSectionColor
        avatarButton.setTitle(GlobalDefiitions.Profile.loadAvatar, for: .normal)
        avatarButton.setTitleColor(.white, for: .normal)
        avatarButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        if let user = user {
            if let name = user.displayName {
                nameTextField.text = name
            } else {
                nameTextField.placeholder = GlobalDefiitions.Profile.enterName
            }
            
            if let email = user.email {
                emailTextField.text = email
            } else {
                emailTextField.placeholder = GlobalDefiitions.Profile.enterEmail
            }
        }
        nameLabel.text = GlobalDefiitions.Profile.enterName
        emailLabel.text = GlobalDefiitions.Profile.enterEmail
        passwordLabel.text = GlobalDefiitions.Profile.enterPassword
        passwordTextField.placeholder = GlobalDefiitions.Profile.enterPassword
        warningLabel.font = UIFont.systemFont(ofSize: 14)
        warningLabel.text = GlobalDefiitions.Profile.warning
        deleteAccountButton.setTitle("Удалить аккаунт", for: .normal)
        deleteAccountButton.setTitleColor(.red, for: .normal)
        deleteAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
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