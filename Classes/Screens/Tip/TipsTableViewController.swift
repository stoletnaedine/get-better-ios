//
//  TipsTableViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 05.11.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

final class TipsTableViewController: UIViewController {
    
    private let database: GBDatabase = FirebaseDatabase()
    private let tableView = UITableView()
    private var tips: [TipEntity] = []
    private let tipStorage = TipStorage()
    
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
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    private func loadData(completion: @escaping VoidClosure) {
        database.getTipLikeIds(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ids):
                if ids.isEmpty {
                    self.showAnimation(name: .japan, on: self.view, loopMode: .loop)
                } else {
                    self.stopAnimation()
                }
                var tips: [TipEntity] = []
                ids.forEach { id in
                    let tip = self.tipStorage.tipEntities()[id]
                    tips.append(tip)
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

extension TipsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tipEntity = tips[indexPath.row]
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = tipEntity.tip.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tipEntity = tips[indexPath.row]
        let tipVC = TipViewController()
        tipVC.modalPresentationStyle = .overFullScreen
        tipVC.tipEntity = tipEntity
        present(tipVC, animated: true, completion: nil)
    }
    
}

extension TipsTableViewController {
    
    private enum Constants {
        static let xibName = "TipCell"
        static let reuseId = "TipCellId"
    }
    
}

