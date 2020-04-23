//
//  SearchViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Toaster

class JournalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var posts: [Post] = []
    let cellIdentifier = "JournalCell"
    let cellXibName = "JournalTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.TabBar.journalTitle
        setupRefreshControl()
        registerCell()
        customizeBarButton()
        updatePosts()
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
        updatePosts()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func updatePosts() {
        loadUserPosts(completion: { [weak self] postArray in
            self?.posts = postArray
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    func loadUserPosts(completion: @escaping ([Post]) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        Database.database().reference()
            .child(Properties.Post.Field.post)
            .child(user.uid)
            .observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            let keys = value?.allKeys
            
            if let keys = keys {
                var postArray: [Post] = []
    
                for key in keys.enumerated() {
                    let entity = value?[key.element] as? NSDictionary
                    
                    let post = Post(text: entity?[Properties.Post.Field.post] as? String ?? "",
                                    sphere: entity?[Properties.Post.Field.sphere] as? String ?? "",
                                    timestamp: entity?[Properties.Post.Field.timestamp] as? String ?? "")
                    
                    postArray.append(post)
                }
                completion(postArray)
            }
        }) { error in
            Toast(text: "\(Properties.Error.firebaseError)\(error.localizedDescription)").show()
            print(error.localizedDescription)
        }
    }
    
    func customizeBarButton() {
        let addPostBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
        navigationItem.rightBarButtonItem = addPostBarButton
    }
    
    @objc func addPost() {
        let postViewController = AddPostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
    }
}

extension JournalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! JournalTableViewCell
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.text ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetailViewController = PostDetailViewController()
        let post = self.posts[indexPath.row]
        postDetailViewController.post = post
        
        navigationController?.pushViewController(postDetailViewController, animated: true)
    }
}
