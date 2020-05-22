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
    var tableItems: [TableSection : [SettingsCell]]?
    let refreshControl = UIRefreshControl()
    
    let profileCellIdentifier = "ProfileCell"
    let profileNibName = "ProfileTableViewCell"
    
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
        title = "Настройки"
        tableView.backgroundColor = .appBackground
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func registerTableCell() {
        tableView.register(UINib(nibName: profileNibName, bundle: nil), forCellReuseIdentifier: profileCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fillTableItems() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.completion = { [weak self] in
            self?.loadProfileAndReloadTableView()
        }
        
        let aboutCircleViewController = ArticleViewController()
        aboutCircleViewController.article = Article(title: GlobalDefiitions.AboutCircle.title,
                                                    text: GlobalDefiitions.AboutCircle.description,
                                                    image: R.image.beach())
        
        let aboutJournalViewController = ArticleViewController()
        aboutJournalViewController.article = Article(title: GlobalDefiitions.AboutJournal.title,
                                                     text: GlobalDefiitions.AboutJournal.description,
                                                     image: R.image.road())
        
        let aboutAppViewController = ArticleViewController()
        aboutAppViewController.article = Article(title: GlobalDefiitions.AboutApp.title,
                                                 text: GlobalDefiitions.AboutApp.description,
                                                 image: R.image.aboutApp())
        
        tableItems = [
            TableSection.profile : [SettingsCell(title: "", viewController: editProfileViewController)],
            TableSection.articles : [
                SettingsCell(title: "Колесо Жизненного Баланса", viewController: aboutCircleViewController),
                SettingsCell(title: "Зачем нужны События?", viewController: aboutJournalViewController),
                SettingsCell(title: "О приложении", viewController: aboutAppViewController)]
        ]
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(loadProfileAndReloadTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func customizeBarButton() {
        let signOutBarButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = signOutBarButton
    }
    
    @objc func logout() {
        NotificationCenter.default.post(name: .logout, object: nil)
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
        let viewController = viewControllers[indexPath.row].viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .tableViewSectionColor
        return view
    }
    
}
