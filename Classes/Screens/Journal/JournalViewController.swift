//
//  SearchViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private enum Constants {
        static let cellId = R.reuseIdentifier.journalCell.identifier
        static let cellXibName = R.nib.journalTableViewCell.name
        static let sectionHeaderHeight: CGFloat = 30
    }
    
    private let database: GBDatabase = FirebaseDatabase()
    private let alertService: AlertService = AlertServiceDefault()
    private let activityIndicator = UIActivityIndicatorView()
    private let connectionHelper = ConnectionHelper()
    private var postSections: [JournalSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupTableView()
        setupBarButton()
        updatePostsInTableView()
    }
    
    @objc private func addPost() {
        guard connectionHelper.connectionAvailable() else { return }
        let addPostViewController = AddPostViewController()
        addPostViewController.addedPostCompletion = { [weak self] in
            self?.updatePostsInTableView()
        }
        present(addPostViewController, animated: true, completion: nil)
    }
    
    @objc public func updatePostsInTableView() {
        title = R.string.localizable.journalLoading()
        getPosts { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
            self?.title = R.string.localizable.tabBarJournal()
        }
    }
    
    @objc private func getPosts(completion: @escaping VoidClosure) {
        database.getPosts(completion: { [weak self] result in
            switch result {
            case .failure:
                break
                
            case .success(let posts):
                if posts.isEmpty {
                    self?.postSections = [
                        JournalSection(
                            type: .empty(info: R.string.localizable.journalPlaceholder())
                        )
                    ]
                } else {
                    self?.convertPostsToSections(posts)
                }
            }
            completion()
        })
    }
    
    private func convertPostsToSections(_ posts: [Post]) {
        let months = posts.map {
            Date.convertToMonthYear(from: $0.timestamp ?? 0)
        }
        let uniqueMonths = Array(Set(months))
        var postSections: [JournalSection] = []

        for month in uniqueMonths {
            let postsByDate = posts
                .filter { Date.convertToMonthYear(from: $0.timestamp ?? 0) == month }
                .sorted(by: { $0.timestamp ?? 0 > $1.timestamp ?? 0 })
            
            postSections.append(
                JournalSection(
                    type: .post,
                    header: month,
                    posts: postsByDate
                )
            )
        }
        
        postSections = postSections.sorted(by: { first, second in
            first.posts?.first?.timestamp ?? 0 > second.posts?.first?.timestamp ?? 0
        })
        
        self.postSections = postSections
    }
    
    func setupBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addPost))
    }
    
    private func setupRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updatePostsInTableView), for: .valueChanged)
        tableView.refreshControl = refresh
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .appBackground
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Constants.cellXibName, bundle: nil),
                           forCellReuseIdentifier: Constants.cellId)
    }
}

// MARK: UITableViewDelegate

extension JournalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return postSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postSections[section].posts?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < postSections.count else { return UITableViewCell() }
        let section = postSections[indexPath.section]
        switch section.type {
        case .empty(let info):
            let cell = UITableViewCell()
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = info
            return cell
        
        case .post:
            guard let post = postSections[indexPath.section].posts?[indexPath.row] else { return UITableViewCell() }
            let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellId,
                                                          for: indexPath) as! JournalTableViewCell
            cell.fillCell(from: post)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = postSections[indexPath.section].posts?[indexPath.row] else { return }
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.post = post
        postDetailViewController.editPostCompletion = { [weak self] in
            self?.updatePostsInTableView()
            self?.navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(postDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let post = postSections[indexPath.section].posts?[indexPath.row] else { return }
            database.deletePost(post) { [weak self] in
                guard let self = self else { return }
                self.alertService.showSuccessMessage(desc: R.string.localizable.journalDeletedPost())
                self.updatePostsInTableView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = postSections[section].posts else { return .zero }
        return Constants.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let _ = postSections[section].posts else {
            return UIView()
        }
        
        let view = UIView(frame: CGRect(x: .zero, y: .zero,
                                        width: tableView.bounds.width,
                                        height: Constants.sectionHeaderHeight))
        view.backgroundColor = .tableViewSectionColor
        
        let label = UILabel()
        view.addSubview(label)
        label.frame = CGRect(x: 15, y: .zero,
                             width: tableView.bounds.width - 30,
                             height: Constants.sectionHeaderHeight)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.text = postSections[section].header
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
