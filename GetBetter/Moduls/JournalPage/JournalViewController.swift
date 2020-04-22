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

class JournalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var posts: [Post] = []
    let cellIdentifier = "JournalCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.TabBar.journalTitle
        
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Загрузка")
        refresh.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        self.tableView.refreshControl = refresh
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.register(UINib(nibName: "JournalTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        customizeBarButton()
        
        updatePosts()
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
        
        let ref = Database.database().reference()
        
        ref.child("post").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            let keys = value?.allKeys
            
            if let keys = keys {
                var postArray: [Post] = []
                for key in keys.enumerated() {
                    print("key = \(key.element)")
                    
                    let entity = value?[key.element] as? NSDictionary
                    let post = Post(text: entity?["post"] as? String ?? "",
                                    sphere: entity?["sphere"] as? String ?? "",
                                    timestamp: entity?["timestamp"] as? String ?? "")
                    print("post = \(post)")
                    postArray.append(post)
                }
                completion(postArray)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func customizeBarButton() {
        let addPostBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
        navigationItem.rightBarButtonItem = addPostBarButton
    }
    
    @objc func addPost() {
        let postViewController = PostViewController()
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
