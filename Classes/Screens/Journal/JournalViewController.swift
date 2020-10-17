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
    
    private var monthYearSection: [String] = []
    private var postsSection: [PostsDateSection] = []
    private let SectionHeaderHeight: CGFloat = 30
    
    private let cellIdentifier = R.reuseIdentifier.journalCell.identifier
    private let cellXibName = R.nib.journalTableViewCell.name
    
    private let database: GBDatabase = FirebaseDatabase()
    private let alertService: AlertService = AlertServiceDefault()
    private let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupTableView()
        setupBarButton()
        updatePostsInTableView()
    }
    
    @objc func updatePostsInTableView() {
        title = R.string.localizable.journalLoading()
        getPosts { [weak self] in
            self?.title = R.string.localizable.tabBarJournal()
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    private func setupRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self,
                          action: #selector(updatePostsInTableView),
                          for: .valueChanged)
        tableView.refreshControl = refresh
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .appBackground
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: cellXibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @objc private func getPosts(completion: @escaping () -> Void) {
        postsSection = []
        monthYearSection = []
        
        database.getPosts(completion: { [weak self] result in
            switch result {
                
            case .failure(let error):
                if let errorName = error.name {
                    self?.alertService.showErrorMessage(desc: errorName)
                }
                completion()
                
            case .success(let posts):
                if posts.isEmpty {
                    completion()
                    return
                }
                
                self?.calcPostDatesToSections(posts: posts)
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        })
    }
    
    private func calcPostDatesToSections(posts: [Post]) {
        let allDates = posts
            .map { Date.convertToMonthYear(from: $0.timestamp ?? 0) }
        
        let uniqueDates = Array(Set(allDates))
        var postsDateSection: [PostsDateSection] = []

        for date in uniqueDates {
            let postsByDate = posts
                .filter { Date.convertToMonthYear(from: $0.timestamp ?? 0) == date }
                .sorted(by: { $0.timestamp ?? 0 > $1.timestamp ?? 0 })
            
            var timestamp = 0
            if !postsByDate.isEmpty{
                timestamp = Int(postsByDate[0].timestamp ?? 0)
            }
            
            let section = PostsDateSection(
                sectionTimestamp: timestamp,
                sectionName: date,
                posts: postsByDate
            )
            postsDateSection.append(section)
        }
                       
        let sortedUniqueDates = postsDateSection
            .sorted(by: { $0.sectionTimestamp ?? 0 > $1.sectionTimestamp ?? 0 })
            .map { $0.sectionName ?? "" }
        
        postsSection = postsDateSection
        monthYearSection = sortedUniqueDates
    }
    
    func setupBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addPost))
    }
    
    @objc private func addPost() {
        let addPostViewController = AddPostViewController()
        addPostViewController.addedPostCompletion = { [weak self] in
            self?.updatePostsInTableView()
        }
        present(addPostViewController, animated: true, completion: nil)
    }
}

// MARK: TableView Delegate
extension JournalViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func getPost(by indexPath: IndexPath) -> Post? {
        if monthYearSection.isEmpty {
            return nil
        }
        
        let date = self.monthYearSection[indexPath.section]
        let postsDateInSection = self.postsSection.filter { $0.sectionName == date }
        
        if postsDateInSection.isEmpty { return nil }
        
        let posts = postsDateInSection[0].posts
        let post = posts[indexPath.row]
        
        return post
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return monthYearSection.isEmpty ? 1 : monthYearSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if monthYearSection.isEmpty {
            return 1
        }
        
        let sectionDate = monthYearSection[section]
        if let postsInSectionByDate = postsSection
            .filter({ $0.sectionName == sectionDate }).first {
            return postsInSectionByDate.posts.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if monthYearSection.isEmpty {
            return 0
        }
        
        return SectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if monthYearSection.isEmpty {
            return UIView()
        }
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        
        let date = monthYearSection[section]
        label.text = date
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        view.backgroundColor = .tableViewSectionColor
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = getPost(by: indexPath) else {
            let cell = UITableViewCell()
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = R.string.localizable.journalPlaceholder()
            return cell
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                      for: indexPath) as! JournalTableViewCell
        cell.fillCell(from: post)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = getPost(by: indexPath) else { return }
        
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.post = post
        postDetailViewController.editPostCompletion = { [weak self] in
            guard let self = self else { return }
            self.updatePostsInTableView()
            self.navigationController?.popToRootViewController(animated: true)
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
            guard let post = getPost(by: indexPath) else { return }
            if database.deletePost(post) {
                alertService.showSuccessMessage(desc: R.string.localizable.journalDeletedPost())
                updatePostsInTableView()
            }
        }
    }
}
