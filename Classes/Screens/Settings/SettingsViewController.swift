//
//  SettingsViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 27.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SettingsViewModel()
    var profile: Profile?
    
    let SectionHeaderHeight: CGFloat = 35
    var tableItems: [TableSection : [CommonSettingsCell]]?
    let refreshControl = UIRefreshControl()
    
    let profileCellIdentifier = R.reuseIdentifier.profileCell.identifier
    let profileNibName = R.nib.profileTableViewCell.name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerTableCell()
        fillTableItems()
        customizeBarButton()
        setupRefreshControl()
        loadProfileAndReloadTableView()
    }
    
    @objc func loadProfileAndReloadTableView() {
        viewModel.loadProfileInfo(completion: { [weak self] profile in
            self?.profile = profile
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        })
    }
    
    private func setupView() {
        title = R.string.localizable.settingsTitle()
        tableView.backgroundColor = .appBackground
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func registerTableCell() {
        tableView.register(UINib(nibName: profileNibName, bundle: nil),
                           forCellReuseIdentifier: profileCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func fillTableItems() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.completion = { [weak self] in
            self?.loadProfileAndReloadTableView()
        }
        
        tableItems = [
            TableSection.profile : [CommonSettingsCell(title: "", viewController: editProfileViewController)],
            TableSection.articles : viewModel.fillArticles(),
            TableSection.config : [
                CommonSettingsCell(
                        title: R.string.localizable.settingsVersionIs(GlobalDefinitions.appVersion),
                        viewController: viewModel.changeLog()
                )
            ]
        ]
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(loadProfileAndReloadTableView),
                                 for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func customizeBarButton() {
        let signOutBarButton = UIBarButtonItem(title: R.string.localizable.settingsExit(),
                                               style: .plain,
                                               target: self,
                                               action: #selector(logoutButtonDidTap))
        navigationItem.rightBarButtonItem = signOutBarButton
    }
    
    @objc func logoutButtonDidTap() {
        let alert = UIAlertController(title: R.string.localizable.settingsLogoutAlertQuestion(),
                                      message: "",
                                      preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: R.string.localizable.settingsLogoutAlertYes(),
                                         style: .destructive,
                                         handler: { (alertAction: UIAlertAction) in
                                            NotificationCenter.default.post(name: .logout, object: nil)})
        let cancelAction = UIAlertAction(title: R.string.localizable.settingsLogoutAlertNo(),
                                         style: .cancel,
                                         handler: nil)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
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
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        case .articles:
            let cell = UITableViewCell()
            cell.textLabel?.text = items[tableSection]?[indexPath.row].title
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        case .config:
            let cell = UITableViewCell()
            cell.textLabel?.text = items[tableSection]?[indexPath.row].title
            cell.textLabel?.textColor = .gray
            cell.selectionStyle = .none
            cell.accessoryType = .detailButton
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight = UITableViewCell().frame.height
        guard let tableSection = TableSection(rawValue: indexPath.section) else { return defaultHeight }
        switch tableSection {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCellIdentifier) as! ProfileTableViewCell
            return cell.frame.height
        default:
            return defaultHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let items = tableItems else { return }
        guard let tableSection = TableSection(rawValue: indexPath.section) else { return }
        guard let viewControllers = items[tableSection] else { return }
        if let viewController = viewControllers[indexPath.row].viewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return SectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .tableViewSectionColor
        return view
    }
    
}
