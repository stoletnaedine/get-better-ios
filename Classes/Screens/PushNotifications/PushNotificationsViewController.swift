//
//  PushNotificationsViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 08.01.2021.
//  Copyright © 2021 Artur Islamgulov. All rights reserved.
//

import UIKit

class PushNotificationsViewController: UIViewController {
    
    private let tableView = UITableView()
    private let userDefaultsService: UserDefaultsService = UserDefaultsServiceImpl()
    private let notificationService: NotificationService = NotificationServiceDefault()
    private var settings = NotificationSettings(tip: .none, post: .none)
    private var currentTopic: NotificationTopic?
    private var models: [PushNotificationModel] {
        return [
            PushNotificationModel(icon: "🤩", name: R.string.localizable.pushNotificationsHeaderTip(), time: settings.tip.text, topic: .tip),
            PushNotificationModel(icon: "✍️", name: R.string.localizable.pushNotificationsHeaderPost(), time: settings.post.text, topic: .post)
        ]
    }
    private let customTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.pushNotificationsTitle()
        settings = userDefaultsService.getNotificationSettings()
        addSubviews()
        setupTableView()
        makeConstraints()
        customizeBarButton()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(customTextField)
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
        tableView.separatorStyle = .none
    }
    
    private func customizeBarButton() {
        let saveSettingsBarButton = UIBarButtonItem(title: R.string.localizable.pushNotificationsSave(),
                                               style: .plain,
                                               target: self,
                                               action: #selector(saveSettings))
        navigationItem.rightBarButtonItem = saveSettingsBarButton
    }
    
    @objc private func saveSettings() {
        userDefaultsService.saveNotificationSettings(self.settings)
        notificationService.subscribe(to: settings)
    }
    
}

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
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        customTextField.resignFirstResponder()
        currentTopic = models[indexPath.row].topic
        let uiPicker = UIPickerView()
        uiPicker.delegate = self
        uiPicker.dataSource = self
        customTextField.inputView = uiPicker
        customTextField.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

// MARK: Constants

extension PushNotificationsViewController {
    
    private enum Constants {
        static let xibName = R.nib.pushNotificationCell.name
        static let reuseId = "PushNotificationCell"
    }
    
}

// MARK: UIPickerViewDelegate

extension PushNotificationsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let topic = self.currentTopic else { fatalError() }
        switch topic {
        case .tip:
            return TipTopic.allCases.count
        case .post:
            return PostTopic.allCases.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let topic = self.currentTopic else { fatalError() }
        switch topic {
        case .tip:
            return TipTopic.allCases[row].text
        case .post:
            return PostTopic.allCases[row].text
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let topic = self.currentTopic else { fatalError() }
        switch topic {
        case .tip:
            settings.tip = TipTopic.allCases[row]
        case .post:
            settings.post = PostTopic.allCases[row]
        }
        tableView.reloadData()
    }
}


