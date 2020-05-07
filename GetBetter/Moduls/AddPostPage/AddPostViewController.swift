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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var attachButton: UIButton!
    @IBOutlet weak var attachImageView: UIImageView!
    @IBOutlet weak var symbolsCountLabel: UILabel!
    @IBOutlet weak var sphereView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let firebaseDataBaseService = FirebaseDatabaseService()
    
    var selectedSphere: Sphere?
    let maxSymbolsCount: Int = 300
    
    var completion: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.Post.postTitle
        self.hideKeyboardWhenTappedAround()
        registerTapForSelectedSphereLabel()
        customizeView()
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func attachButtonDidTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // TODO уточнить
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        guard let text = postTextView.text, !text.isEmpty else {
            Toast(text: "Поле текста пустое").show()
            return
        }
        guard let sphere = selectedSphere else {
            Toast(text: "Выберите сферу").show()
            return
        }
        
        var photoUrlString: String?
        var photoName: String?
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        if let photo = photoImageView.image {
            
            self.showActivityIndicator(onView: self.view)
            
            FirebaseStorageService().upload(photo: photo, completion: { result in
                switch result {
                case .success(let photo):
                    photoUrlString = photo.url
                    photoName = photo.name
                    dispatchGroup.leave()
                default:
                    dispatchGroup.leave()
                }
            })
        } else {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global(), execute: { [weak self] in
            
            let post = Post(id: nil, text: text, sphere: sphere, timestamp: Date.currentTimestamp, photoUrl: photoUrlString, photoName: photoName)
            _ = self?.firebaseDataBaseService.savePost(post)
            
            DispatchQueue.main.async { [weak self] in
                self?.removeActivityIndicator()
                Toast(text: "\(Constants.Post.postSavedSuccess)\n\(sphere.icon) \(sphere.name) +0,1 балла!", delay: 0, duration: 5).show()
                self?.completion()
                self?.dismiss(animated: true, completion: nil)
            }
        })
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
        postTextView.delegate = self
        postTextView.becomeFirstResponder()
        postTextView.font = postTextView.font?.withSize(18)
        //postTextView.placeholder = "Опишите событие, которое сегодня сделало вас лучше. Например: сделал зарядку, прочитал несколько глав книги, выучил несколько иностранных слов..."
        
        photoImageView.isHidden = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .violet
        titleLabel.text = "Добавить запись"
        selectedSphereLabel.textColor = .violet
        selectedSphereLabel.text = Constants.Post.sphereDefault
        selectedSphereLabel.font = UIFont.boldSystemFont(ofSize: 18)
        saveButtonView.backgroundColor = .violet
        saveButtonView.layer.cornerRadius = 20
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cancelButton.setTitle("", for: .normal)
        attachButton.setTitle("", for: .normal)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        dateLabel.text = Date.currentDateWithWeekday()
        symbolsCountLabel.font = UIFont.systemFont(ofSize: 14)
        symbolsCountLabel.textColor = .gray
        symbolsCountLabel.text = "\(postTextView.text.count)/\(maxSymbolsCount)"
        sphereView.layer.cornerRadius = 20
        sphereView.layer.borderWidth = 3
        sphereView.layer.borderColor = UIColor.violet.cgColor
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

extension AddPostViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let currentTextCount = postTextView.text.count
        symbolsCountLabel.text = "\(currentTextCount)/\(maxSymbolsCount)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        if text.count > maxSymbolsCount {
            Toast(text: "Не более \(maxSymbolsCount) символов").show()
        }
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= maxSymbolsCount
    }
}

extension AddPostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        photoImageView.image = image
        photoImageView.isHidden = false
        attachImageView.isHidden = true
    }
}
