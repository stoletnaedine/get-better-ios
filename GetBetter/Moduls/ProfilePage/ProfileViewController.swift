//
//  ProfileViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadProfileInfoAndReloadView), name: .updateProfile, object: nil)
        customizeView()
        customizeBarButton()
        loadProfileInfoAndReloadView()
    }
    
    @IBAction func signOutButtonDidPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc func loadProfileInfoAndReloadView() {
        loadProfileInfo(completion: { [weak self] (name, email, avatar) in
            self?.nameLabel.text = name
            self?.emailLabel.text = email
            self?.avatarImageView.image = avatar
        })
    }
    
    func loadProfileInfo(completion: @escaping ((_ name: String, _ mail: String, _ avatar: UIImage?) -> Void)) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        var name = ""
        var email = ""
        var avatar: UIImage?
        DispatchQueue.global(qos: .userInteractive).async {
            if let userName = user.displayName {
                name = userName
            }
            if let userEmail = user.email {
                email = userEmail
            }
            if let photoURL = user.photoURL,
                let imageData = try? Data(contentsOf: photoURL),
                let loadedAvatar = UIImage(data: imageData) {
                avatar = loadedAvatar
            }
            DispatchQueue.main.async {
                completion(name, email, avatar)
            }
        }
    }
    
    func customizeView() {
        self.title = Properties.TabBar.profileTitle
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.backgroundColor = .grayEvent
        nameLabel.text = Properties.Profile.nameDefault
        emailLabel.text = ""
        avatarImageView.image = UIImage(named: "defaultAvatar")
        nameLabel.font = UIFont(name: Properties.Font.SFUITextMedium, size: 26)
        signOutButton.setTitle(Properties.Profile.signOut, for: .normal)
        signOutButton.setTitleColor(.sky, for: .normal)
        signOutButton.titleLabel?.font = UIFont(name: Properties.Font.SFUITextRegular, size: 15)
        signOutButton.titleLabel?.underline()
    }
    
    func customizeBarButton() {
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProfile))
        navigationItem.rightBarButtonItem = editBarButton
    }
    
    @objc func editProfile() {
        let editProfileViewController = EditProfileViewController()
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
}
