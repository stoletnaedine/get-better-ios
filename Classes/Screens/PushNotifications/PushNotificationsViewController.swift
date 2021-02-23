//
//  PushNotificationsViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 08.01.2021.
//  Copyright © 2021 Artur Islamgulov. All rights reserved.
//

import UIKit

class PushNotificationsViewController: UIViewController {
    
    var completion: VoidClosure?
    
    // MARK: — Private properties
    
    private let tableView = UITableView()
    private let userDefaultsService: UserSettingsServiceProtocol = UserSettingsService()
    private let pushService: PushServiceProtocol = PushService()
    private var settings = NotificationSettings(tip: .none, post: .none)
    private var currentTopic: NotificationTopic?
    private var models: [PushNotificationModel] {
        return [
            PushNotificationModel(
                icon: "🤩",
                name: R.string.localizable.pushNotificationsHeaderTip(),
                time: settings.tip.text,
                topic: .tip
            ),
            PushNotificationModel(
                icon: "✍️",
                name: R.string.localizable.pushNotificationsHeaderPost(),
                time: settings.post.text,
                topic: .post
            )
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.pushNotificationsTitle()
        settings = userDefaultsService.getNotificationSettings()
        addSubviews()
        setupTableView()
        makeConstraints()
        customizeBarButton()
    }
    
    // MARK: — Private methods
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Constants.xibName, bundle: nil), forCellReuseIdentifier: Constants.reuseId)
        tableView.backgroundColor = .appBackground
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func customizeBarButton() {
        let saveSettingsBarButton = UIBarButtonItem(
            title: R.string.localizable.pushNotificationsSave(),
            style: .plain,
            target: self,
            action: #selector(saveSettings)
        )
        navigationItem.rightBarButtonItem = saveSettingsBarButton
    }
    
    @objc private func saveSettings() {
        userDefaultsService.saveNotificationSettings(settings)
        pushService.subscribe(to: settings)
        completion?()
    }
    
}

// MARK: — UITableViewDelegate

extension PushNotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseId, for: indexPath)
                as? PushNotificationCell else { fatalError() }
        cell.configure(model: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)
        label.numberOfLines = 0
        label.textColor = .grey
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = R.string.localizable.pushNotificationsDescription()
        label.frame = CGRect(x: 15, y: 5, width: UIScreen.main.bounds.size.width - 30, height: 100)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTopic = models[indexPath.row].topic
        switch currentTopic {
        case .tip:
            let alert = UIAlertController()
            TipTopic.allCases.forEach { topic in
                let action = UIAlertAction(
                    title: topic.text,
                    style: .default,
                    handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.settings.tip = topic
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
        
        case .post:
            let alert = UIAlertController()
            PostTopic.allCases.forEach { topic in
                let action = UIAlertAction(
                    title: topic.text,
                    style: .default,
                    handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.settings.post = topic
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
            
        case .none:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRow
    }
    
}

// MARK: Constants

extension PushNotificationsViewController {
    
    private enum Constants {
        static let xibName = R.nib.pushNotificationCell.name
        static let reuseId = "PushNotificationCell"
        static let heightForRow: CGFloat = 70.0
    }
    
}
