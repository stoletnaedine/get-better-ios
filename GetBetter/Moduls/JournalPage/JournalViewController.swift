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
    
    var uniqueDates: [String] = []
    var postsBySections: [String : [Post]]?
    
    let SectionHeaderHeight: CGFloat = 30
    let cellIdentifier = "JournalCell"
    let cellXibName = "JournalTableViewCell"
    let firebaseDataBaseService = FirebaseDatabaseService()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        registerCell()
        setupBarButton()
        
        tableView.backgroundColor = .appBackground
        
        self.title = "Загрузка"
        getPosts { [weak self] in
            self?.title = Constants.TabBar.journalTitle
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
    
    @objc func updatePostsInTableView() {
        getPosts { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func getPosts(completion: @escaping () -> Void) {
        
        firebaseDataBaseService.getPosts(completion: { [weak self] result in
            switch result {
                
            case .failure(let error):
                Toast(text: "\(Constants.Error.firebaseError)\(String(describing: error.name))").show()
                completion()
                
            case .success(let postArray):
                
                let allDates = postArray.map {
                    Date.convertToMonthYear(from: $0.timestamp ?? 0)
                }
                
                let uniqueDates = Array(Set(allDates))
                let sortedUniqueDates = uniqueDates.sorted(by: { $0 > $1 })
                self?.uniqueDates = sortedUniqueDates
                
                var postsBySections = [String : [Post]]()
                
                for date in uniqueDates {
                    postsBySections[date] = postArray
                        .filter { Date.convertToMonthYear(from: $0.timestamp ?? 0) == date }
                        .sorted(by: { $0.timestamp ?? 0 > $1.timestamp ?? 0 })
                }
                self?.postsBySections = postsBySections
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
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
}

extension JournalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return uniqueDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let date = uniqueDates[section]
        if let postsBySections = postsBySections,
            let postsByDate = postsBySections[date] {
            return postsByDate.count
        }
        
        return 0
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
        
//        if postsCount == 0 {
//            let cell = UITableViewCell()
//            cell.textLabel?.text = "Чтобы добавить событие, нажмите +"
//            return cell
//        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! JournalTableViewCell
        
        let date = uniqueDates[indexPath.section]
        if let postsBySections = postsBySections,
            let posts = postsBySections[date] {
            let post = posts[indexPath.row]
            cell.fillCell(from: post)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if postsCount == 0 {
//            return
//        }
        
        let postDetailViewController = PostDetailViewController()
        let date = uniqueDates[indexPath.section]
        if let postsBySections = postsBySections,
            let posts = postsBySections[date] {
            let post = posts[indexPath.row]
            postDetailViewController.post = post
            present(postDetailViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let date = uniqueDates[indexPath.section]
            if let postsBySections = postsBySections,
                let posts = postsBySections[date] {
                let post = posts[indexPath.row]
                if firebaseDataBaseService.deletePost(post) {
                    self.updatePostsInTableView()
                }
            }
        }
    }
}
