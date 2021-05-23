//
//  SearchViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Lottie

class JournalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private enum Constants {
        static let cellId = R.reuseIdentifier.journalCell.identifier
        static let cellXibName = R.nib.journalTableViewCell.name
        static let sectionHeaderHeight: CGFloat = 30
    }
    
    private let database: DatabaseProtocol = FirebaseDatabase()
    private let alertService: AlertServiceProtocol = AlertService()
    private let connectionHelper = ConnectionHelper()
    private var posts: [Post] = []
    private var postSections: [JournalSection] = []
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController()
    private let emptyPostsAnimateView = AnimationView(name: AnimationName.yoga.value)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        removeBackButtonTitle()
        setupTableView()
        setupNavigationBar()
        setupRefreshControl()
        setupAnimateView()
        title = R.string.localizable.tabBarJournal()
        updatePostsInTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !emptyPostsAnimateView.isHidden {
            emptyPostsAnimateView.play()
        }
    }
    
    @objc func updatePostsInTableView() {
        getPosts { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    // MARK: — Private methods

    private func setupAnimateView() {
        tableView.addSubview(emptyPostsAnimateView)
        emptyPostsAnimateView.frame = tableView.frame
        emptyPostsAnimateView.contentMode = .scaleAspectFit
        emptyPostsAnimateView.loopMode = .loop
        emptyPostsAnimateView.animationSpeed = 1
        emptyPostsAnimateView.isHidden = true
    }
    
    @objc private func addPost() {
        guard connectionHelper.isConnect() else { return }
        let addPostViewController = AddPostViewController()
        addPostViewController.addedPostCompletion = { [weak self] in
            guard let self = self else { return }
            self.updatePostsInTableView()
        }
        present(addPostViewController, animated: true, completion: nil)
    }
    
    @objc private func getPosts(completion: @escaping VoidClosure) {
        database.getPosts(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                completion()
                break
                
            case let .success(posts):
                if posts.isEmpty {
                    self.emptyPostsAnimateView.isHidden = false
                    self.emptyPostsAnimateView.play()
                    self.postSections = [JournalSection(type: .empty(info: R.string.localizable.journalPlaceholder()))]
                } else {
                    self.emptyPostsAnimateView.isHidden = true
                    self.emptyPostsAnimateView.stop()
                    self.posts = posts
                    self.convertPostsToSections(posts)
                }
                completion()
            }
        })
    }
    
    private func convertPostsToSections(_ posts: [Post]) {
        let months = posts.map { Date.convertToMonthYear(from: $0.timestamp ?? 0) }
        let uniqueMonths = Array(Set(months))
        var postSections: [JournalSection] = []

        for month in uniqueMonths {
            let postsByDate = posts
                .filter { Date.convertToMonthYear(from: $0.timestamp ?? 0) == month }
                .sorted(by: { $0.timestamp ?? 0 > $1.timestamp ?? 0 })
            
            postSections.append(
                JournalSection(
                    type: .post,
                    header: JournalSection.Header(
                        month: month,
                        postsCount: "\(postsByDate.count)"),
                    posts: postsByDate))
        }
        
        postSections = postSections.sorted(by: { first, second in
            first.posts?.first?.timestamp ?? 0 > second.posts?.first?.timestamp ?? 0
        })
        self.postSections = postSections
    }

    private func setupSearchBar() {
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.placeholder = R.string.localizable.journalSearch()
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addPost))

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: R.image.info(),
            style: .plain,
            target: self,
            action: #selector(showJournalTutorial))

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(updatePostsInTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func showJournalTutorial() {
        let vc = ArticleViewController()
        vc.article = Article(
            title: R.string.localizable.aboutJournalTitle(),
            text: R.string.localizable.aboutJournalDescription(),
            image: R.image.aboutEvents())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .appBackground
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: Constants.cellXibName, bundle: nil),
            forCellReuseIdentifier: Constants.cellId)
        tableView.showsVerticalScrollIndicator = false
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
            cell.backgroundColor = .appBackground
            return cell

        case .post:
            guard let post = section.posts?[indexPath.row] else { return UITableViewCell() }
            let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellId,
                                                          for: indexPath) as! JournalTableViewCell
            cell.fillCell(from: post)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = postSections[indexPath.section].posts?[indexPath.row] else { return }
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.post = post
        postDetailViewController.editPostCompletion = { [weak self] in
            guard let self = self else { return }
            self.updatePostsInTableView()
        }
        navigationController?.pushViewController(postDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, complete in
            guard let self = self,
                  let post = self.postSections[indexPath.section].posts?[indexPath.row] else { return }
            let editPostVC = EditPostViewController()
            editPostVC.post = post
            editPostVC.editPostCompletion = { [weak self] _ in
                guard let self = self else { return }
                self.updatePostsInTableView()
                editPostVC.dismiss(animated: true, completion: nil)
            }
            self.present(editPostVC, animated: true, completion: nil)
            complete(true)
        }
        editAction.image = R.image.edit()
        editAction.backgroundColor = .darkGray

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, complete in
            guard let self = self,
                  let post = self.postSections[indexPath.section].posts?[indexPath.row] else { return }
            let alert = UIAlertController(
                title: R.string.localizable.journalAlertDeletePost(),
                message: nil,
                preferredStyle: .alert
            )
            let deleteAction = UIAlertAction(
                title: R.string.localizable.journalAlertDelete(),
                style: .destructive,
                handler: { _ in
                    self.database.deletePost(post) { [weak self] in
                        guard let self = self else { return }
                        self.alertService.showSuccessMessage(R.string.localizable.journalDeletedPost())
                        self.updatePostsInTableView()
                    }
                })
            let cancelAction = UIAlertAction(
                title: R.string.localizable.cancel(),
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                })
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            complete(true)
        }
        deleteAction.image = R.image.delete()
        deleteAction.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = postSections[section].posts else { return .zero }
        return Constants.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let _ = postSections[section].posts else { return UIView() }
        
        let view = UIView(frame: CGRect(x: .zero, y: .zero,
                                        width: tableView.bounds.width,
                                        height: Constants.sectionHeaderHeight))
        view.backgroundColor = .tableViewSectionColor
        let boundsWidth = tableView.bounds.width
        
        let monthLabel = UILabel()
        view.addSubview(monthLabel)
        monthLabel.frame = CGRect(
            x: 15,
            y: .zero,
            width: boundsWidth * 2 / 3,
            height: Constants.sectionHeaderHeight)
        monthLabel.font = UIFont.systemFont(ofSize: 12)
        monthLabel.textColor = .white
        monthLabel.text = postSections[section].header?.month
        
        let countLabel = UILabel()
        view.addSubview(countLabel)
        countLabel.frame = CGRect(
            x: boundsWidth - 40,
            y: .zero,
            width: 25,
            height: Constants.sectionHeaderHeight)
        countLabel.font = UIFont.systemFont(ofSize: 12)
        countLabel.textColor = .white
        countLabel.textAlignment = .right
        countLabel.text = postSections[section].header?.postsCount
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

// MARK: — UISearchBarDelegate

extension JournalViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !posts.isEmpty else { return }
        if let searchText = searchController.searchBar.text,
           searchText.count > 1 {
            let searchLowercasedText = searchText.lowercased()
            let filteredPosts = posts.filter {
                $0.text?.lowercased().contains(searchLowercasedText) ?? false
                    || $0.sphere?.name.lowercased().contains(searchLowercasedText) ?? false
                    || Date.convertToMonthYear(from: $0.timestamp ?? 0).lowercased().contains(searchLowercasedText)
            }
            convertPostsToSections(filteredPosts)
            tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard !posts.isEmpty else { return }
        convertPostsToSections(posts)
        tableView.reloadData()
    }

}
