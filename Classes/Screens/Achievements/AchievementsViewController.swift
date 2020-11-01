//
//  AchievementsViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 24.10.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

final class AchievementsViewController: UIViewController {
    
    private let presenter: AchievementPresenter = AchievementPresenterDefault()
    private let lifeCircleService: LifeCircleService = LifeCircleServiceDefault()
    private let tableView = UITableView()
    private var achievements: [Achievement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupTableView()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = R.string.localizable.achievementsLoading()
        loadData(completion: { [weak self] in
            DispatchQueue.main.async {
                self?.title = R.string.localizable.achievementsTitle()
                self?.tableView.reloadData()
            }
        })
    }
    
    private func loadData(completion: @escaping VoidClosure) {
        lifeCircleService.loadUserData { [weak self] userData in
            guard let userData = userData,
                  let startSphereMetrics = userData.start,
                  let currentSphereMetrics = userData.current else {
                completion()
                return
            }
            if let achievements = self?.presenter.calcAchievements(
                posts: userData.posts,
                startSphereMetrics: startSphereMetrics,
                currentSphereMetrics: currentSphereMetrics
            ) {
                self?.achievements = achievements
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseId,
                                                 for: indexPath) as! AchievementsTableViewCell
        cell.selectionStyle = .none
        cell.fillCell(from: achievement)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

extension AchievementsViewController {
    
    private enum Constants {
        static let xibName = R.nib.achievementsTableViewCell.name
        static let reuseId = R.reuseIdentifier.achievementsCell.identifier
    }
    
}
