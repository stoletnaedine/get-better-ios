//
//  TipsTableViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 05.11.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Lottie

final class TipsTableViewController: UIViewController {
    
    private let database: DatabaseProtocol = FirebaseDatabase()
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let alertService: AlertServiceProtocol = AlertService()
    private var tips: [TipEntity] = []
    private var tipLikes: [TipLikesViewModel] = []
    private let tipStorage = TipStorage()
    private let emptyPostsAnimateView = AnimationView(name: AnimationName.yoga.value)

    private enum Constants {
        static let tipCell = R.nib.tipCell.name
        static let placeholderTipId = -1
        static let backgroundImageWidth: CGFloat = 30
    }

    private lazy var backgroundImages: [UIImage?] = {
        return tipStorage.backgroundNames.map {
            UIImage(named: $0)?.resized(toWidth: Constants.backgroundImageWidth)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.tipsTitle()
        addSubviews()
        setupTableView()
        makeConstraints()
        setupRefreshControl()
        setupAnimateView()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !emptyPostsAnimateView.isHidden {
            emptyPostsAnimateView.play()
        }
    }

    // MARK: — Private methods

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupAnimateView() {
        emptyPostsAnimateView.frame = view.bounds
        emptyPostsAnimateView.contentMode = .scaleAspectFit
        emptyPostsAnimateView.loopMode = .loop
        emptyPostsAnimateView.animationSpeed = 1
        emptyPostsAnimateView.isHidden = true
    }

    @objc private func loadData() {
        database.userTipsLikes(completion: { [weak self] result in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()

            switch result {
            case let .success(models):
                if models.isEmpty {
                    self.emptyPostsAnimateView.isHidden = false
                    self.emptyPostsAnimateView.play()
                    self.tips = [
                        TipEntity(
                            id: Constants.placeholderTipId,
                            tip: Tip(title: R.string.localizable.tipsIfEmpty(), text: ""))
                    ]
                    self.tableView.reloadData()
                } else {
                    self.emptyPostsAnimateView.isHidden = true
                    self.emptyPostsAnimateView.stop()
                    guard self.tipLikes != models else { return }
                    let sortedModels = models
                        .sorted(by: {
                                    $0.tipId == self.tipStorage.currentTipId
                                        && $1.tipId != self.tipStorage.currentTipId
                        })
                    self.tipLikes = sortedModels
                    self.tips = sortedModels.map { self.tipStorage.tipEntities[$0.tipId] }
                    self.tableView.reloadData()
                }
            case let .failure(error):
                guard let errorName = error.name else { return }
                self.alertService.showErrorMessage(errorName)
            }
        })
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        tableView.addSubview(emptyPostsAnimateView)
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
        let tipId = tipEntity.id
        let imageIndex = tipStorage.index(for: tipId)
        let model = TipLikeCellViewModel(
            tipId: tipId,
            title: cellTitle,
            likeCount: likeCount,
            backgroundImage: backgroundImages[imageIndex])
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

