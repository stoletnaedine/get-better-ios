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
        self.title = Properties.Post.postTitle
        spherePickerView.delegate = self
        customizeView()
        customizeBarButton()
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        let dummy = UITextField(frame: CGRect(x: 0, y: 0, width: 40, height: 0))
        view.addSubview(dummy)
        
        dummy.inputView = picker
        dummy.becomeFirstResponder()
        
        spherePickerView.isHidden = true
    }
    
    func customizeView() {
        postTextView.text = ""
        postTextView.backgroundColor = .grayEvent
        sphereLabel.text = Properties.Post.sphere
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
            
            ref.child("post").child(user.uid).childByAutoId().setValue([
                    "post": post,
                    "sphere": sphere,
                    "timestamp": String(Date.currentTimeStamp)
                ])
            Toast(text: "Пост сохранен!").show()
        }
        
        navigationController?.popViewController(animated: true)
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
        let sphere = Sphere.allCases[row]
        return sphere.string
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sphere = Sphere.allCases[row]
        self.selectedSphere = sphere.rawValue
    }
}
