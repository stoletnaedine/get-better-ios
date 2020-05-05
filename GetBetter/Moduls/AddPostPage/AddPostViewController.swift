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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var selectedSphereLabel: UILabel!
    @IBOutlet weak var saveButtonView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var selectedSphere: Sphere?
    let databaseService = FirebaseDatabaseService()
    
    var completion: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.Post.postTitle
        self.hideKeyboardWhenTappedAround()
        registerTapForSelectedSphereLabel()
        customizeView()
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        guard let text = postTextView.text,
            !text.isEmpty,
            let sphere = selectedSphere else {
                Toast(text: Constants.Post.emptyFieldsWarning).show()
                return
        }
        
        let post = Post(id: nil, text: text, sphere: sphere, timestamp: Date.currentTimestamp, picUrl: nil)
        
        if databaseService.savePost(post) {
            databaseService.incrementSphereValue(for: sphere)
            Toast(text: "\(Constants.Post.postSavedSuccess)\nСфера \(sphere.icon) \(sphere.name) увеличилась на 0,1 балла!", delay: 0, duration: 3).show()
        }
        
        completion()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
    
    func customizeView() {
        postTextView.becomeFirstResponder()
        postTextView.font = postTextView.font?.withSize(18)
        postTextView.placeholder = "Опишите событие, которое сегодня сделало вас лучше. Например: сделал зарядку, прочитал несколько глав книги, выучил несколько иностранных слов..."
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .violet
        titleLabel.text = "Дневник"
        selectedSphereLabel.text = Constants.Post.sphereDefault
        selectedSphereLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 20)
        saveButtonView.backgroundColor = .violet
        saveButtonView.layer.cornerRadius = 10
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 20)
        cancelButton.setTitle("", for: .normal)
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
