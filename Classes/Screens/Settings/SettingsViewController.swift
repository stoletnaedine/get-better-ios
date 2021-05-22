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
        static let profileCell = R.reuseIdentifier.profileCell.identifier
        static let notificationCell = R.nib.notificationCell.name
        static let titleSubtitleCell = R.nib.titleSubtitleCell.name
    }
    
    private let pushService: PushServiceProtocol = PushService()
    private let userSettingsService: UserSettingsServiceProtocol = UserSettingsService()
    private let alertService: AlertServiceProtocol = AlertService()
    
    private var profile: Profile?
    private var notificationSettings: NotificationSettings?
    private var difficultyLevel: DifficultyLevel?
    private var models: [SettingsCellViewModel] = []
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeBackButtonTitle()
        notificationSettings = userSettingsService.getNotificationSettings()
        difficultyLevel = userSettingsService.getDifficultyLevel()
        setupNavigationBar()
        setupView()
        setupRefreshControl()
        setupTableView()
        fetchModels()
        loadProfileAndReloadTableView()
    }
    
    // MARK: — Private methods
    
    @objc private func loadProfileAndReloadTableView() {
        loadProfileInfo(completion: { [weak self] profile in
            guard let self = self else { return }
            self.profile = profile
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    private func setupView() {
        title = R.string.localizable.settingsTitle()
        tableView.backgroundColor = .appBackground
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: Constants.profileCell, bundle: nil),
                           forCellReuseIdentifier: Constants.profileCell)
        tableView.register(UINib(nibName: Constants.notificationCell, bundle: nil),
                           forCellReuseIdentifier: Constants.notificationCell)
        tableView.register(UINib(nibName: Constants.titleSubtitleCell, bundle: nil),
                           forCellReuseIdentifier: Constants.titleSubtitleCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(loadProfileAndReloadTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupNavigationBar() {
        let signOutBarButton = UIBarButtonItem(
            title: R.string.localizable.settingsExit(),
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = models[indexPath.row].type
        let item = models[indexPath.row].cell
        
        switch type {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.profileCell) as? ProfileCell,
                  let profile = self.profile else {
                return UITableViewCell()
            }
            cell.backgroundColor = .appBackground
            cell.configure(model: profile)
            return cell
            
        case .tips:
            let cell = UITableViewCell()
            cell.backgroundColor = .appBackground
            cell.textLabel?.text = item.title
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case .push:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.titleSubtitleCell) as? TitleSubtitleCell,
                  let notificationSettings = self.notificationSettings else { return UITableViewCell() }
            cell.backgroundColor = .appBackground
            var subtitle = R.string.localizable.settingsPushNone()
            let tip: String? = notificationSettings.tip != .none ? notificationSettings.tip.text : nil
            let post: String? = notificationSettings.post != .none ? notificationSettings.post.text : nil
            let array: [String] = [tip, post].compactMap { $0 }
            if !array.isEmpty {
                subtitle = array.joined(separator: ", ")
            }
            let model  = TitleSubtitleCellViewModel(
                title: item.title ?? "",
                subtitle: subtitle
            )
            cell.configure(model: model)
            return cell
            
        case .difficultyLevel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.titleSubtitleCell)
                    as? TitleSubtitleCell else { return UITableViewCell() }
            cell.backgroundColor = .appBackground
            cell.accessoryType = .detailButton
            let model  = TitleSubtitleCellViewModel(
                title: item.title ?? "",
                subtitle: difficultyLevel?.name ?? ""
            )
            cell.configure(model: model)
            return cell
            
        case .aboutApp, .version:
            let cell = UITableViewCell()
            cell.backgroundColor = .appBackground
            cell.textLabel?.text = item.title
            cell.textLabel?.textColor = .gray
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = models[indexPath.row].type
        switch type {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.profileCell) as? ProfileCell else { return .zero }
            return cell.frame.height
        case .push, .difficultyLevel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.titleSubtitleCell) as? TitleSubtitleCell else { return .zero }
            return cell.frame.height
        default:
            return UITableViewCell().frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        models[indexPath.row].cell.action?()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        switch models[indexPath.row].type {
        case .difficultyLevel:
            alertService.showPopUpMessage(
                title: R.string.localizable.settingsDiffLevelInfoTitle(),
                description: R.string.localizable.settingsDiffLevelInfoDescription(),
                buttonText: R.string.localizable.oK())
        default:
            break
        }
    }
    
}

// MARK: — Models

extension SettingsViewController {
    
    private func fetchModels() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.completion = { [weak self] in
            self?.loadProfileAndReloadTableView()
        }
        
        let aboutAppVC = ArticleViewController()
        aboutAppVC.article = Article(
            title: R.string.localizable.aboutAppTitle(),
            titleView: UIView.appLogo(),
            text: R.string.localizable.aboutAppDescription(),
            image: R.image.aboutTeam())
        
        let pushNotificationsVC = PushNotificationsViewController()
        pushNotificationsVC.completion = { [weak self] in
            self?.notificationSettings = self?.userSettingsService.getNotificationSettings()
            self?.tableView.reloadData()
            pushNotificationsVC.navigationController?.popViewController(animated: true)
        }
        
        let appVersionVC = TextViewViewController()
        appVersionVC.title = R.string.localizable.appVersionsTitle()
        appVersionVC.text = R.string.localizable.appVersions()
        
        models = [
            SettingsCellViewModel(
                type: .profile,
                cell: SettingsCell(
                    action: { [weak self] in
                        self?.navigationController?.pushViewController(editProfileViewController, animated: true)
                    })
            ),
            SettingsCellViewModel(
                type: .tips,
                cell: SettingsCell(
                    title: R.string.localizable.tipsTitle(),
                    action: { [weak self] in
                        self?.navigationController?.pushViewController(TipsTableViewController(), animated: true)
                    })
            ),
            SettingsCellViewModel(
                type: .push,
                cell: SettingsCell(
                    title: R.string.localizable.settingsPushTitle(),
                    action: { [weak self] in
                        self?.navigationController?.pushViewController(pushNotificationsVC, animated: true)
                    })
            ),
            SettingsCellViewModel(
                type: .difficultyLevel,
                cell: SettingsCell(
                    title: R.string.localizable.settingsDiffLevelTitle(),
                    action: difficultyLevelClosure())
            ),
            SettingsCellViewModel(
                type: .version,
                cell: SettingsCell(
                    title: R.string.localizable.settingsVersionIs(Properties.appVersion),
                    action: { [weak self] in
                        self?.navigationController?.pushViewController(appVersionVC, animated: true)
                    })
            ),
            SettingsCellViewModel(
                type: .aboutApp,
                cell: SettingsCell(
                    title: R.string.localizable.aboutAppTitle(),
                    action: { [weak self] in
                        self?.navigationController?.pushViewController(aboutAppVC, animated: true)
                    })
            ),
            SettingsCellViewModel(
                type: .aboutApp,
                cell: SettingsCell(
                    title: R.string.localizable.settingsAboutAppPostReview(),
                    action: {
                        UIApplication.shared.open(Properties.appStoreUrl, options: [:], completionHandler: nil)
                    })
            )
        ]
    }
    
    private func difficultyLevelClosure() -> VoidClosure {
        return { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController()
            DifficultyLevel.allCases.forEach { level in
                let action = UIAlertAction(
                    title: level.name,
                    style: .default,
                    handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.userSettingsService.setDifficultyLevel(level)
                        self.alertService.showSuccessMessage(R.string.localizable.settingsDiffLevelSave())
                        self.difficultyLevel = self.userSettingsService.getDifficultyLevel()
                        self.tableView.reloadData()
                    })
                alert.addAction(action)
            }
            let cancelAction = UIAlertAction(
                title: R.string.localizable.cancel(),
                style: .cancel,
                handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                })
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

// MARK: — LoadProfileInfo

private extension SettingsViewController {
    
    func loadProfileInfo(completion: @escaping (_ profile: Profile) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        DispatchQueue.main.async {
            completion(
                Profile(
                    avatarURL: user.photoURL,
                    name: user.displayName ?? R.string.localizable.settingsDefaultName(),
                    email: user.email ?? R.string.localizable.settingsDefaultEmail()))
        }
    }
    
}
