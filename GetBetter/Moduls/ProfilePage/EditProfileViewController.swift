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
    @IBOutlet weak var password2Label: UILabel!
    @IBOutlet weak var password2TextField: UITextField!
    
    let user = Auth.auth().currentUser
    
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
        guard let user = user else {
            return
        }
        
        if let avatar = avatarImageView.image {
            upload(currentUserId: user.uid, photo: avatar, completion: { result in
                switch result {
                case .success(let url):
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.photoURL = url
                    changeRequest.commitChanges(completion: { error in
                        if let error = error {
                            print("changeRequest.commitChanges = \(error.localizedDescription)")
                            Toast(text: "\(Properties.Error.firebaseError) \(error.localizedDescription)").show()
                            return
                        }
                    })
                case .failure(let error):
                    Toast(text: "\(Properties.Error.firebaseError) \(error.localizedDescription)").show()
                    return
                }
            })
        }
        
        if let name = nameTextField.text, !name.isEmpty {
            print("!!!!!!!! nameTextField.text = \(name)")
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges(completion: { error in
                if let error = error {
                    Toast(text: "\(Properties.Error.firebaseError) \(error.localizedDescription)").show()
                    return
                }
            })
        }
        
        if let email = emailTextField.text {
            user.updateEmail(to: email, completion: { error in
                if let error = error {
                    Toast(text: "\(Properties.Error.firebaseError) \(error.localizedDescription)").show()
                    return
                }
            })
        }
        
        if let password1 = passwordTextField.text, !password1.isEmpty,
            let password2 = password2TextField.text, !password2.isEmpty,
            password1 == password2 {
            user.updatePassword(to: password1, completion: { error in
                if let error = error {
                    Toast(text: "\(Properties.Error.firebaseError) \(error.localizedDescription)").show()
                    return
                }
            })
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func upload(currentUserId: String, photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = Storage.storage().reference().child(Properties.Profile.avatarsDirectory).child(currentUserId)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        guard let imageData = avatarImageView.image?.jpegData(compressionQuality: 0.2) else {
            return
        }
        
        ref.putData(imageData, metadata: metadata, completion: { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL(completion: { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            })
        })
    }
    
    func customizeView() {
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        avatarView.backgroundColor = .gray
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarButton.setTitle(Properties.Profile.loadAvatar, for: .normal)
        avatarButton.setTitleColor(.white, for: .normal)
        avatarButton.titleLabel?.font = UIFont(name: Properties.Font.Ubuntu, size: 12)
        nameLabel.text = Properties.Profile.name
        nameTextField.placeholder = Properties.Profile.enterName
        emailLabel.text = Properties.Profile.email
        emailTextField.placeholder = Properties.Profile.enterEmail
        passwordLabel.text = Properties.Profile.password
        passwordTextField.placeholder = Properties.Profile.enterPassword
        password2Label.text = Properties.Profile.password2
        password2TextField.placeholder = Properties.Profile.enterPassword2
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
