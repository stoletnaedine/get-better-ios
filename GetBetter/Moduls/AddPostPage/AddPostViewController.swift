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

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var addPostLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var sphereLabel: UILabel!
    @IBOutlet weak var selectedSphereLabel: UILabel!
    
    var selectedSphere: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.Post.postTitle
        registerTapForSelectedSphereLabel()
        customizeView()
        customizeBarButton()
    }
    
    func customizeView() {
        addPostLabel.font = UIFont(name: Properties.Font.Ubuntu, size: 12)
        addPostLabel.text = Properties.Post.addPost
        postTextView.backgroundColor = .lightGrey
        sphereLabel.text = Properties.Post.sphere
        sphereLabel.font = UIFont(name: Properties.Font.Ubuntu, size: 12)
        selectedSphereLabel.text = Properties.Post.sphereDefault
        selectedSphereLabel.font = UIFont(name: Properties.Font.OfficinaSansExtraBoldC, size: 30)
    }
    
    func registerTapForSelectedSphereLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPicker))
        selectedSphereLabel.isUserInteractionEnabled = true
        selectedSphereLabel.addGestureRecognizer(tap)
    }
    
    @objc func showPicker() {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        let customtTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 40, height: 0))
        view.addSubview(customtTextField)
        
        customtTextField.inputView = picker
        customtTextField.becomeFirstResponder()
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

extension AddPostViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Sphere.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let sphere = Sphere.allCases[row]
        selectedSphereLabel.text = sphere.string
        return sphere.string
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sphere = Sphere.allCases[row]
        self.selectedSphere = sphere.rawValue
    }
}
