//
//  SettingsViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 27.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var profile: Profile?
    
    let SectionHeaderHeight: CGFloat = 35
    var tableItems: [TableSection : [UIViewController]]?
    
    let profileCellIdentifier = "ProfileCell"
    let profileNibName = "ProfileTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        fillTableItems()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: profileNibName, bundle: nil), forCellReuseIdentifier: profileCellIdentifier)
        
        loadProfileAndReloadTableView()
    }
    
    func loadProfileAndReloadTableView() {
        loadProfileInfo(completion: { [weak self] name, email, avatar in
            self?.profile = Profile(avatar: avatar, name: name, email: email)
            self?.tableView.reloadData()
        })
    }
    
    func fillTableItems() {
         tableItems = [
            TableSection.profile : [EditProfileViewController()],
            TableSection.articles : [AboutCircleViewController(), AboutJournalViewController(), AboutAppViewController()]
        ]
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
    
}

enum TableSection: Int {
    case profile = 0, articles, settings
    
    var title: String {
        switch self {
        case .profile:
            return "Профиль"
        case .articles:
            return "Статьи"
        case .settings:
            return "Настройки"
        }
    }
}

struct Profile {
    let avatar: UIImage?
    let name: String?
    let email: String?
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let items = tableItems else { return 0 }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = tableItems else { return 0 }
        guard let tableSection = TableSection(rawValue: section) else { return 0 }
        guard let viewControllers = items[tableSection] else { return 0 }
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = tableItems else { return UITableViewCell() }
        guard let tableSection = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch tableSection {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCellIdentifier) as! ProfileTableViewCell
            if let profile = profile {
                cell.fillCell(profile: profile)
            }
            return cell
        case .articles:
            let cell = UITableViewCell()
            let viewController = items[tableSection]?[indexPath.row]
            cell.textLabel?.text = "статья"
            return cell
        case .settings:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight = UITableViewCell().frame.height
        guard let tableSection = TableSection(rawValue: indexPath.section) else { return defaultHeight }
        switch tableSection {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCellIdentifier) as! ProfileTableViewCell
            return cell.frame.height
        case .articles:
            return defaultHeight
        case .settings:
            return defaultHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let items = tableItems else { return }
        guard let tableSection = TableSection(rawValue: indexPath.section) else { return }
        guard let viewControllers = items[tableSection] else { return }
        let viewController = viewControllers[indexPath.row]
        if tableSection == .profile {
            let editProfileViewController = viewController as! EditProfileViewController
            editProfileViewController.completion = { [weak self] in
                self?.loadProfileAndReloadTableView()
            }
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let tableSection = TableSection(rawValue: section) else { return "" }
        return tableSection.title
    }
    
}
