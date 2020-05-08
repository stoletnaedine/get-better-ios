//
//  SearchViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Toaster

class JournalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicator = UIActivityIndicatorView()
    let firebaseDataBaseService = FirebaseDatabaseService()
    
    var uniqueDates: [String] = []
    var postsDateSection: [PostsDateSection] = []
    let SectionHeaderHeight: CGFloat = 30
    let cellIdentifier = "JournalCell"
    let cellXibName = "JournalTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .appBackground
        
        setupRefreshControl()
        registerCell()
        setupBarButton()
        updatePostsInTableView()
    }
    
    @objc func updatePostsInTableView() {
        self.title = "Загрузка"
        getPosts { [weak self] in
            self?.title = Constants.TabBar.journalTitle
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    func setupRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updatePostsInTableView), for: .valueChanged)
        self.tableView.refreshControl = refresh
    }
    
    func registerCell() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.register(UINib(nibName: cellXibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @objc func getPosts(completion: @escaping () -> Void) {
        
        firebaseDataBaseService.getPosts(completion: { [weak self] result in
            switch result {
                
            case .failure(let error):
                Toast(text: "\(Constants.Error.firebaseError)\(String(describing: error.name))").show()
                completion()
                
            case .success(let postArray):
                
                if postArray.isEmpty {
                    completion()
                    return
                }
                
                let allDates = postArray.map {
                    Date.convertToMonthYear(from: $0.timestamp ?? 0)
                }
                let uniqueDates = Array(Set(allDates))
                
                var postsDateSection: [PostsDateSection] = []
                
                for date in uniqueDates {
                    let postsByDate = postArray
                        .filter { Date.convertToMonthYear(from: $0.timestamp ?? 0) == date }
                        .sorted(by: { $0.timestamp ?? 0 > $1.timestamp ?? 0 })
                    
                    var timestamp = 0
                    if !postsByDate.isEmpty{
                        timestamp = Int(postsByDate[0].timestamp ?? 0)
                    }
                    
                    let section = PostsDateSection(sectionTimestamp: timestamp, sectionName: date, posts: postsByDate)
                    postsDateSection.append(section)
                }
                self?.postsDateSection = postsDateSection
                
                let sortedUniqueDates = self?.postsDateSection
                    .sorted(by: { $0.sectionTimestamp ?? 0 > $1.sectionTimestamp ?? 0 })
                    .map { $0.sectionName ?? "" }
                
                self?.uniqueDates = sortedUniqueDates ?? []
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        })
    }
    
    func setupBarButton() {
        let addPostBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
        navigationItem.rightBarButtonItem = addPostBarButton
    }
    
    @objc func addPost() {
        let postViewController = AddPostViewController()
        postViewController.completion = { [weak self] in
            self?.updatePostsInTableView()
        }
        present(postViewController, animated: true, completion: nil)
    }
    
    fileprivate func getPost(indexPath: IndexPath) -> Post? {
        let date = self.uniqueDates[indexPath.section]
        let postsDateInSection = self.postsDateSection.filter { $0.sectionName == date }
        
        if postsDateInSection.isEmpty { return nil }
        
        let posts = postsDateInSection[0].posts
        let post = posts[indexPath.row]
        return post
    }
}

extension JournalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return uniqueDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let date = uniqueDates[section]
        let postsInSectionByDate = postsDateSection.filter { $0.sectionName == date }
        
        if postsInSectionByDate.isEmpty || postsInSectionByDate.count != 1 {
            return 0
        }
        
        return postsInSectionByDate[0].posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        
        let date = uniqueDates[section]
        label.text = date
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        view.backgroundColor = .tableViewSectionColor
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let post = getPost(indexPath: indexPath) else { return UITableViewCell() }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! JournalTableViewCell
        cell.fillCell(from: post)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let post = getPost(indexPath: indexPath) else { return }
        
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.post = post
        present(postDetailViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            guard let post = getPost(indexPath: indexPath) else { return }
            
                if firebaseDataBaseService.deletePost(post) {
                    self.updatePostsInTableView()
                }
            }
    }
    

}
