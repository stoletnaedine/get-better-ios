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
    var posts: [Post] = []
    let cellIdentifier = "JournalCell"
    let cellXibName = "JournalTableViewCell"
    let databaseService = DatabaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.TabBar.journalTitle
        setupRefreshControl()
        setupBarButton()
        registerCell()
        customizeBarButton()
        getPosts()
    }
    
    func setupRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        self.tableView.refreshControl = refresh
    }
    
    func registerCell() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.register(UINib(nibName: cellXibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @objc func refreshTableView() {
        getPosts()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func getPosts() {
        databaseService.getPosts(completion: { [weak self] result in
            switch result {
                
            case .failure(let error):
                Toast(text: "\(Properties.Error.firebaseError)\(String(describing: error.name))").show()
                print(error.localizedDescription)
                
            case .success(let postArray):
                self?.posts = postArray.sorted(by: { $0.timestamp ?? 0 > $1.timestamp ?? 0 })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        })
    }
    
    func customizeBarButton() {
        let addPostBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
        navigationItem.rightBarButtonItem = addPostBarButton
    }
    
    @objc func addPost() {
        let postViewController = AddPostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    func setupBarButton() {
        let aboutJournalBarButton = UIBarButtonItem(title: Properties.AboutJournal.button, style: .plain, target: self, action: #selector(showAboutJournalViewController))
        navigationItem.leftBarButtonItem = aboutJournalBarButton
    }
    
    @objc func showAboutJournalViewController() {
        let aboutJournalViewController = AboutJournalViewController()
        navigationController?.pushViewController(aboutJournalViewController, animated: true)
    }
}

extension JournalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts.isEmpty {
            return 1
        }
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! JournalTableViewCell
        
        if posts.isEmpty {
            cell.textLabel?.text = "Чтобы добавить событие, нажмите +"
            return cell
        }
        
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.text ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if posts.isEmpty {
            return
        }
        
        let postDetailViewController = PostDetailViewController()
        let post = self.posts[indexPath.row]
        postDetailViewController.post = post
        navigationController?.pushViewController(postDetailViewController, animated: true)
    }
}
