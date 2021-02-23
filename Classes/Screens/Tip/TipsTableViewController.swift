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
    private var tips: [TipEntity] = []
    private let tipStorage = TipStorage()
    private enum Constants {
        static let xibName = "TipCell"
        static let reuseId = "TipCellId"
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
        loadData(completion: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    // MARK: — Private methods
    
    private func loadData(completion: @escaping VoidClosure) {
        database.getTipLikeIds(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ids):
                var tips: [TipEntity]
                if ids.isEmpty {
                    self.showAnimation(name: .yoga, on: self.view, loopMode: .loop)
                    tips = [
                        TipEntity(
                            id: Constants.placeholderTipId,
                            tip: Tip(title: R.string.localizable.tipsIfEmpty(), text: ""))
                    ]
                } else {
                    self.stopAnimation()
                    tips = ids.map { self.tipStorage.tipEntities()[$0] }
                }
                self.tips = tips
                completion()
            case .failure:
                break
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
        tableView.register(UINib(nibName: Constants.xibName, bundle: nil),
                           forCellReuseIdentifier: Constants.reuseId)
        tableView.backgroundColor = .appBackground
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
}

// MARK: — UITableViewDelegate

extension TipsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tipEntity = tips[indexPath.row]
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        if tipEntity.id == Constants.placeholderTipId {
            cell.textLabel?.numberOfLines = 0
        }
        cell.textLabel?.text = tipEntity.tip.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tipEntity = tips[indexPath.row]
        guard tipEntity.id != Constants.placeholderTipId else { return }
        let tipVC = TipViewController()
        tipVC.modalPresentationStyle = .overFullScreen
        tipVC.tipEntity = tipEntity
        present(tipVC, animated: true, completion: nil)
    }
    
}

