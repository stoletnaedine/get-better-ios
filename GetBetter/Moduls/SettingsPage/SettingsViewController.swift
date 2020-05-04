//
//  SettingsViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 27.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var profile: Profile?
    
    let SectionHeaderHeight: CGFloat = 35
    var tableItems: [TableSection : [SettingsCell]]?
    let refreshControl = UIRefreshControl()
    
    let profileCellIdentifier = "ProfileCell"
    let profileNibName = "ProfileTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        
        tableView.register(UINib(nibName: profileNibName, bundle: nil), forCellReuseIdentifier: profileCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        fillTableItems()
        customizeBarButton()
        setupRefreshControl()
        loadProfileAndReloadTableView()
    }
    
    @objc func loadProfileAndReloadTableView() {
        loadProfileInfo(completion: { [weak self] profile in
            self?.profile = profile
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        })
    }
    
    func fillTableItems() {
         tableItems = [
            TableSection.profile : [SettingsCell(title: nil, viewController: EditProfileViewController())],
            TableSection.articles : [
                SettingsCell(title: "Колесо Жизненного Баланса", viewController: AboutCircleViewController()),
                SettingsCell(title: "Зачем нужны События?", viewController: AboutJournalViewController()),
                SettingsCell(title: "Что такое GetBetter", viewController: AboutAppViewController())]
        ]
    }
    
    func loadProfileInfo(completion: @escaping (_ profile: Profile) -> Void) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        DispatchQueue.global().async {
            var name = "Анонимный пользователь"
            var email = "Email не указан"
            var avatar: UIImage?
            
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
                completion(Profile(avatar: avatar, name: name, email: email))
            }
        }
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(loadProfileAndReloadTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func customizeBarButton() {
        let signOutBarButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = signOutBarButton
    }
    
    @objc func signOut() {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
}

enum TableSection: Int {
    case profile = 0, articles, settings
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
            cell.textLabel?.text = items[tableSection]?[indexPath.row].title
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
        case .articles, .settings:
            return defaultHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let items = tableItems else { return }
        guard let tableSection = TableSection(rawValue: indexPath.section) else { return }
        guard let viewControllers = items[tableSection] else { return }
        guard let viewController = viewControllers[indexPath.row].viewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lighterGray
        return view
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
}
