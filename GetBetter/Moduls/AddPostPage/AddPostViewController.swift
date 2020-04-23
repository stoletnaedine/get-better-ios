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
        self.hideKeyboardWhenTappedAround()
        registerTapForSelectedSphereLabel()
        customizeView()
        customizeBarButton()
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
            
                Database.database().reference()
                    .child(Properties.Post.Field.post)
                    .child(user.uid)
                    .childByAutoId()
                    .setValue([
                        Properties.Post.Field.post: post,
                        Properties.Post.Field.sphere: sphere,
                        Properties.Post.Field.timestamp: Date.currentTimestampString
                    ])
            
                Toast(text: Properties.Post.postSavedSuccess).show()
        } else {
            Toast(text: Properties.Post.emptyFieldsWarning).show()
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func customizeView() {
        addPostLabel.font = UIFont(name: Properties.Font.Ubuntu, size: 12)
        addPostLabel.text = Properties.Post.addPost
        postTextView.backgroundColor = .lightGrey
        sphereLabel.text = Properties.Post.sphere
        sphereLabel.font = UIFont(name: Properties.Font.Ubuntu, size: 12)
        selectedSphereLabel.text = Properties.Post.sphereDefault
        selectedSphereLabel.font = UIFont(name: Properties.Font.OfficinaSansExtraBold, size: 30)
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
        selectedSphereLabel.text = sphere.name
        return sphere.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sphere = Sphere.allCases[row]
        self.selectedSphere = sphere.rawValue
    }
}