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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.TabBar.journalTitle
        self.tableView.delegate = self
        loadUserPosts(completion: { [weak self] postArray in
            self?.posts = postArray
        })
        print("loaded posts = \(posts.count)")
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
                    let post = Post(post: entity?["post"] as? String ?? "",
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
}

extension JournalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JournalCellTableViewCell(style: .default, reuseIdentifier: "journalCell")
        let post = posts[indexPath.row]
        cell.fillCell(sphere: post.sphere, post: post.post, timestamp: post.timestamp)
        return cell
    }
}
