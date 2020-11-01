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
    
    private enum Constants {
        static let sectionHeaderHeight: CGFloat = 35
        static let profileCellId = R.reuseIdentifier.profileCell.identifier
        static let profileNibName = R.nib.profileCell.name
    }
    
    let presenter: SettingsPresenter = SettingsPresenterDefault()
    var profile: Profile?
    var tableSections: [SettingsSection] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBarButton()
        setupView()
        setupRefreshControl()
        setupTableView()
        fillCells()
        loadProfileAndReloadTableView()
    }
    
    // MARK: — Private methods
    
    @objc private func loadProfileAndReloadTableView() {
        loadProfileInfo(completion: { [weak self] profile in
            self?.profile = profile
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        })
    }
    
    private func setupView() {
        title = R.string.localizable.settingsTitle()
        tableView.backgroundColor = .lifeCircleLineBack
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: Constants.profileNibName, bundle: nil),
                           forCellReuseIdentifier: Constants.profileCellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(loadProfileAndReloadTableView),
                                 for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func customizeBarButton() {
        let signOutBarButton = UIBarButtonItem(title: R.string.localizable.settingsExit(),
                                               style: .plain,
                                               target: self,
                                               action: #selector(logoutButtonDidTap))
        navigationItem.rightBarButtonItem = signOutBarButton
    }
    
    @objc private func logoutButtonDidTap() {
        let message = (profile?.email == R.string.localizable.settingsDefaultEmail())
            ? R.string.localizable.settingsLogoutAlertNoEmail() : ""
        let alert = UIAlertController(title: R.string.localizable.settingsLogoutAlertQuestion(),
                                      message: message,
                                      preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: R.string.localizable.settingsLogoutAlertYes(),
                                         style: .destructive,
                                         handler: { _ in
                                            NotificationCenter.default.post(name: .logout, object: nil)})
        let cancelAction = UIAlertAction(title: R.string.localizable.settingsLogoutAlertNo(),
                                         style: .cancel,
                                         handler: nil)        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: — UITableViewDelegate

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = tableSections[indexPath.section]
        switch section.type {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.profileCellId) as? ProfileCell
                else { return UITableViewCell() }
            guard let profile = self.profile else { return UITableViewCell() }
            cell.fillCell(profile: profile)
            cell.selectionStyle = .none
            return cell
        case .articles:
            let cell = UITableViewCell()
            cell.textLabel?.text = section.cells[indexPath.row].title ?? ""
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        case .notifications:
            // TODO: сделать нормально
            guard let topic = NotificationTopic(rawValue: section.cells[indexPath.row].title ?? "")
                else { return UITableViewCell() }
            return presenter.createPushNotifyCell(topic: topic)
        case .aboutApp:
            let cell = UITableViewCell()
            cell.textLabel?.text = section.cells[indexPath.row].title
            cell.textLabel?.textColor = .grey
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight = UITableViewCell().frame.height
        let section = tableSections[indexPath.section]
        switch section.type {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.profileCellId) as? ProfileCell else { return 0 }
            return cell.frame.height
        default:
            return defaultHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableSections[indexPath.section].cells[indexPath.row]
        cell.action?()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lifeCircleLineBack
        return view
    }
    
}

// MARK: — Fill Cells

extension SettingsViewController {
    
    private func fillCells() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.editProfileCompletion = { [weak self] in
            self?.loadProfileAndReloadTableView()
        }
        
        let aboutCircleVC = ArticleViewController()
        aboutCircleVC.article = Article(title: R.string.localizable.aboutCircleTitle(),
                                        text: R.string.localizable.aboutCircleDescription(),
                                        image: R.image.lifeCircleExample())
        
        let aboutJournalVC = ArticleViewController()
        aboutJournalVC.article = Article(title: R.string.localizable.aboutJournalTitle(),
                                         text: R.string.localizable.aboutJournalDescription(),
                                         image: R.image.aboutEvents())
        
        let aboutAppVC = ArticleViewController()
        aboutAppVC.article = Article(title: R.string.localizable.aboutAppTitle(),
                                     titleView: UIImageView(image: R.image.titleViewLogo()),
                                     text: R.string.localizable.aboutAppDescription(),
                                     image: R.image.aboutTeam())
        
        let appVersionVC = TextViewViewController()
        appVersionVC.text = R.string.localizable.appVersions()
        
        tableSections = [
            SettingsSection(type: .profile,
                    cells: [
                        SettingsCell(action: { [weak self] in
                            self?.navigationController?.pushViewController(editProfileViewController, animated: true)
                        })
                    ]),
            SettingsSection(type: .articles,
                    cells: [
                        SettingsCell(title: R.string.localizable.aboutCircleTableTitle(),
                             action: { [weak self] in
                                self?.navigationController?.pushViewController(aboutCircleVC, animated: true)
                             }),
                        SettingsCell(title: R.string.localizable.aboutJournalTitle(),
                             action: { [weak self] in
                                self?.navigationController?.pushViewController(aboutJournalVC, animated: true)
                             }),
                        SettingsCell(title: R.string.localizable.aboutAppTitle(),
                             action: { [weak self] in
                                self?.navigationController?.pushViewController(aboutAppVC, animated: true)
                             })
                         ]),
            SettingsSection(type: .notifications,
                    cells: [
                        SettingsCell(title: NotificationTopic.daily.rawValue)
                    ]),
            SettingsSection(type: .aboutApp,
                    cells: [
                        SettingsCell(title: R.string.localizable.settingsVersionIs(Properties.appVersion),
                             action: { [weak self] in
                                self?.navigationController?.pushViewController(appVersionVC, animated: true)
                             }),
                        SettingsCell(title: R.string.localizable.settingsAboutAppPostReview(), action: {
                            UIApplication.shared.open(Properties.appStoreUrl,
                                                      options: [:], completionHandler: nil)
                        })
                    ])
        ]
    }
    
}

// MARK: — LoadProfileInfo

extension SettingsViewController {
    
    func loadProfileInfo(completion: @escaping (_ profile: Profile) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        DispatchQueue.main.async {
            completion(
                Profile(avatarURL: user.photoURL,
                        name: user.displayName ?? R.string.localizable.settingsDefaultName(),
                        email: user.email ?? R.string.localizable.settingsDefaultEmail())
            )
        }
    }
    
}
