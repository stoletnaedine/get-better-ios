//
//  TipsTableViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 05.11.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

final class TipsTableViewController: UIViewController {
    
    private let database: DatabaseProtocol = FirebaseDatabase()
    private let tableView = UITableView()
    private let alertService: AlertServiceProtocol = AlertService()
    private var tips: [TipEntity] = []
    private var tipLikes: [TipLikesViewModel] = []
    private let tipStorage = TipStorage()
    private enum Constants {
        static let tipCell = R.nib.tipCell.name
        static let placeholderTipId = -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.tipsTitle()
        addSubviews()
        setupTableView()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingAnimation(on: self.view)
        loadData { [weak self] in
            guard let self = self else { return }
            self.stopAnimation()
            self.tableView.reloadData()
        }
    }

    // MARK: — Private methods

    private func loadData(completion: @escaping VoidClosure) {
        database.userTipsLikes(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(models):
                guard !models.isEmpty else {
                    self.showAnimation(name: .yoga, on: self.view, loopMode: .loop)
                    self.tips = [
                        TipEntity(
                            id: Constants.placeholderTipId,
                            tip: Tip(title: R.string.localizable.tipsIfEmpty(), text: ""))
                    ]
                    completion()
                    return
                }

                self.stopAnimation()
                self.tipLikes = models
                self.tips = models.map { self.tipStorage.tipEntities[$0.tipId] }
                completion()
            case let .failure(error):
                guard let errorName = error.name else { return }
                self.alertService.showErrorMessage(desc: errorName)
            }
        })
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
        tableView.register(UINib(nibName: Constants.tipCell, bundle: nil), forCellReuseIdentifier: Constants.tipCell)
        tableView.backgroundColor = .appBackground
        tableView.separatorStyle = .none
    }
    
}

// MARK: — UITableViewDelegate

extension TipsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tipEntity = tips[indexPath.row]
        guard tipEntity.id != Constants.placeholderTipId else {
            let cell = UITableViewCell()
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = tipEntity.tip.title
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tipCell) as? TipCell else {
            return UITableViewCell()
        }
        let cellTitle = tipEntity.tip.title
        let likeCount = self.tipLikes[indexPath.row].likeCount
        let model = TipLikeCellViewModel(tipId: tipEntity.id, title: cellTitle, likeCount: likeCount)
        cell.configure(from: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tipEntity = tips[indexPath.row]
        guard tipEntity.id != Constants.placeholderTipId else { return }
        let tipVC = TipViewController()
        tipVC.modalPresentationStyle = .overFullScreen
        tipVC.tipEntity = tipEntity
        present(tipVC, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tipEntity = tips[indexPath.row]
        guard tipEntity.id != Constants.placeholderTipId else {
            return 80
        }
        return 60
    }
    
}

