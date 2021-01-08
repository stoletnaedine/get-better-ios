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
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        cell.backgroundColor = .appBackground
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = settings.tip.text
        case 1:
            cell.textLabel?.text = settings.post.text
        default:
            cell.textLabel?.text = "Выбери подходящее время и нажми Сохранить."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        customTextField.resignFirstResponder()
        switch indexPath.section {
        case 0:
            currentTopic = .tip
        case 1:
            currentTopic = .post
        default:
            return
        }
        let uiPicker = UIPickerView()
        uiPicker.delegate = self
        uiPicker.dataSource = self
        customTextField.inputView = uiPicker
        customTextField.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return R.string.localizable.pushNotificationsHeaderTip()
        case 1:
            return R.string.localizable.pushNotificationsHeaderPost()
        default:
            return nil
        }
    }
    
}

// MARK: Constants

extension PushNotificationsViewController {
    
    private enum Constants {
        static let xibName = "PushCell"
        static let reuseId = "PushCellId"
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


