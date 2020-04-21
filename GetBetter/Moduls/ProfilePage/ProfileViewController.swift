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
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileInfo), name: .updateProfile, object: nil)
        customizeView()
        customizeBarButton()
        loadProfileInfo()
    }
    
    @IBAction func signOutButtonDidPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc func updateProfileInfo() {
        loadProfileInfo()
    }
    
    func loadProfileInfo() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        if let userName = user.displayName {
            nameLabel.text = userName
        } else {
            nameLabel.text = "Неизвестный Кот"
        }
        if let userEmail = user.email {
            emailLabel.text = userEmail
        }
        if let photoURL = user.photoURL,
            let imageData = try? Data(contentsOf: photoURL) {
            print(imageData)
            print(photoURL.absoluteString)
            avatarImageView.image = UIImage(data: imageData)
        }
    }
    
    func customizeView() {
        self.title = Properties.TabBar.profileTitle
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.backgroundColor = .grayEvent
        
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
