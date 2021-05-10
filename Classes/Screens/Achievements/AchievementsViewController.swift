//
//  AchievementsViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 24.10.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

final class AchievementsViewController: UIViewController {
    
    private let achievementService: AchievementServiceProtocol = AchievementService()
    private let lifeCircleService: LifeCircleServiceProtocol = LifeCircleService()
    private let tableView = UITableView()
    private var achievements: [Achievement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.achievementsTitle()
        addSubviews()
        setupTableView()
        makeConstraints()
        view.backgroundColor = .appBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.alpha = 0
        loadData(completion: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.5, animations: { self.tableView.alpha = 1 })
            }
        })
    }
    
    private func loadData(completion: @escaping VoidClosure) {
        lifeCircleService.loadUserData { [weak self] userData in
            guard let self = self else { return }
            guard let userData = userData else { return }
            self.achievements = self.achievementService.calcAchievements(userData: userData)
            completion()
        }
    }
    
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
        tableView.register(UINib(nibName: Constants.xibName, bundle: nil),
                           forCellReuseIdentifier: Constants.reuseId)
        tableView.backgroundColor = .appBackground
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
}

extension AchievementsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let achievement = achievements[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.reuseId,
                for: indexPath) as? AchievementCell else { fatalError("AchievementCell not found") }
        cell.fillCell(from: achievement)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

extension AchievementsViewController {
    
    private enum Constants {
        static let xibName = R.nib.achievementCell.name
        static let reuseId = R.reuseIdentifier.achievementsCell.identifier
    }
    
}
