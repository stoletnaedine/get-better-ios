//
//  HistoryViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Toaster

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var addPostLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var sphereLabel: UILabel!
    @IBOutlet weak var selectedSphereLabel: UILabel!
    
    var selectedSphere: Sphere?
    let databaseService = FirebaseDatabaseService()
    
    var completion: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.Post.postTitle
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
        
        let customtTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.addSubview(customtTextField)
        
        customtTextField.inputView = picker
        customtTextField.becomeFirstResponder()
    }
    
    func customizeBarButton() {
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePost))
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    @objc func savePost() {
        
        guard let text = postTextView.text,
            !text.isEmpty,
            let sphere = selectedSphere else {
                Toast(text: Constants.Post.emptyFieldsWarning).show()
                return
        }
        
        let post = Post(text: text, sphere: sphere, timestamp: Date.currentTimestamp)
        
        if databaseService.savePost(post) {
            databaseService.incrementSphereMetrics(for: sphere)
            Toast(text: Constants.Post.postSavedSuccess).show()
        }
        
        completion()
        navigationController?.popViewController(animated: true)
    }
    
    func customizeView() {
        postTextView.becomeFirstResponder()
        addPostLabel.font = UIFont(name: Constants.Font.Ubuntu, size: 12)
        addPostLabel.text = Constants.Post.addPost
        sphereLabel.text = Constants.Post.sphere
        sphereLabel.font = UIFont(name: Constants.Font.Ubuntu, size: 12)
        selectedSphereLabel.text = Constants.Post.sphereDefault
        selectedSphereLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 30)
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
        return "\(sphere.icon) \(sphere.name)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sphere = Sphere.allCases[row]
        selectedSphere = sphere
        selectedSphereLabel.text = sphere.name
    }
}
