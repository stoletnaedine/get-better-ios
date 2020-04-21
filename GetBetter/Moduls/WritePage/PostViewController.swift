//
//  HistoryViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Toaster

class PostViewController: UIViewController {
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var sphereLabel: UILabel!
    @IBOutlet weak var spherePickerView: UIPickerView!
    
    var selectedSphere: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.TabBar.postTitle
        spherePickerView.delegate = self
        customizeView()
        customizeBarButton()
    }
    
    func customizeView() {
        postTextView.text = ""
        postTextView.backgroundColor = .grayEvent
        sphereLabel.text = Properties.Write.sphere
    }
    
    func customizeBarButton() {
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePost))
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    @objc func savePost() {
        guard let user = Auth.auth().currentUser else { return }
        
        if let post = postTextView.text, !post.isEmpty,
            let sphere = selectedSphere {
                let ref = Database.database().reference()
            ref.child("post").child(user.uid).setValue(["post": post])
//                ref.child("post").child(user.uid).setValue([
//                    "post": post,
//                    "sphere": sphere,
//                    "timestamp": String(NSDate().timeIntervalSince1970)
//                ])
            Toast(text: "Пост сохранен!").show()
        }
    }
}

extension PostViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Sphere.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Sphere(rawValue: row)?.string
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedSphere = Sphere(rawValue: row)?.string
    }
}
