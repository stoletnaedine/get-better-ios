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
    
    let user = Auth.auth().currentUser
    let storageService = FirebaseStorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.Profile.editTitle
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
            storageService.upload(currentUserId: user.uid, photo: avatar, completion: { result in
                switch result {
                case .success(let url):
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.photoURL = url
                    changeRequest.commitChanges(completion: { error in
                        if let error = error {
                            print("Firebase commit changes error = \(error.localizedDescription)")
                            Toast(text: "\(Properties.Error.firebaseError)\(error.localizedDescription)").show()
                            return
                        }
                    })
                case .failure(let error):
                    Toast(text: "\(Properties.Error.firebaseError)\(String(describing: error.name))").show()
                    return
                }
            })
        }
        
        if let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !name.isEmpty, name != user.displayName {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges(completion: { error in
                if let error = error {
                    Toast(text: "\(Properties.Error.firebaseError)\(error.localizedDescription)").show()
                    return
                }
            })
        }
        
        if let password = passwordTextField.text, !password.isEmpty {
            user.updatePassword(to: password, completion: { error in
                if let error = error {
                    Toast(text: "\(Properties.Error.firebaseError)\(error.localizedDescription)").show()
                    return
                }
            })
        }
        
        if let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !email.isEmpty, email != user.email {
            user.updateEmail(to: email, completion: { error in
                if let error = error {
                    print("\(error.localizedDescription)")
                    Toast(text: "\(Properties.Error.firebaseError)\(error.localizedDescription)").show()
                    return
                }
                NotificationCenter.default.post(name: .logout, object: nil)
            })
        }
        
        navigationController?.popViewController(animated: true)
        Toast(text: Properties.Profile.editSuccess, delay: 0.5, duration: 1).show()
    }
    
    func customizeView() {
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        avatarView.backgroundColor = .gray
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarButton.setTitle(Properties.Profile.loadAvatar, for: .normal)
        avatarButton.setTitleColor(.white, for: .normal)
        avatarButton.titleLabel?.font = UIFont(name: Properties.Font.Ubuntu, size: 12)
        
        if let user = user {
            if let name = user.displayName {
                nameTextField.text = name
            } else {
                nameTextField.placeholder = Properties.Profile.enterName
            }
            
            if let email = user.email {
                emailTextField.text = email
            } else {
                emailTextField.placeholder = Properties.Profile.enterEmail
            }
        }
        nameLabel.text = Properties.Profile.enterName
        emailLabel.text = Properties.Profile.enterEmail
        passwordLabel.text = Properties.Profile.enterPassword
        passwordTextField.placeholder = Properties.Profile.enterPassword
        warningLabel.font = UIFont(name: Properties.Font.Ubuntu, size: 14)
        warningLabel.text = Properties.Profile.warning
    }
    
    func customizeBarButon() {
        let saveBarButtom = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProfile))
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
