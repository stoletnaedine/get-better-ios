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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.TabBar.journalTitle
        loadUserPosts()
    }
    
    func loadUserPosts() {
        guard let user = Auth.auth().currentUser else { return }
        
        let ref = Database.database().reference()
        
        ref.child("post").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
            
            print("snapshot = \(snapshot)")
            let value = snapshot.value as? NSDictionary
            print("value = \(value)")
            print("post = \(value?["post"] as? String ?? "")")
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
