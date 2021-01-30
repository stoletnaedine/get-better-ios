//
//  HistoryViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

enum PostType {
    case add
    case edit
}

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var saveButtonView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var attachButton: UIButton!
    @IBOutlet weak var symbolsCountLabel: UILabel!
    @IBOutlet weak var sphereView: UIView!
    @IBOutlet weak var selectSphereButton: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var selectedSphere: Sphere?
    let database: GBDatabase = FirebaseDatabase()
    let alertService: AlertService = AlertServiceDefault()
    let userService: UserDefaultsService = UserDefaultsServiceImpl()
    var addedPostCompletion: VoidClosure?
    var postType: PostType = .add
    
    private let storage: GBStorage = FirebaseStorage()
    private let maxSymbolsCount: Int = 300
    private var isPhotoSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupTextView()
        setupSelectSphereButtonTapHandler()
        setupView()
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func attachButtonDidTap(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        guard let text = postTextView.text, !text.isEmpty else {
            alertService.showErrorMessage(desc: R.string.localizable.postEmptyText())
            return
        }
        guard let sphere = selectedSphere else {
            alertService.showErrorMessage(desc: R.string.localizable.postEmptySphere())
            return
        }
        
        var photoResult: Photo = Photo(photoUrl: nil, photoName: nil, previewUrl: nil, previewName: nil)
        let dispatchGroup = DispatchGroup()
        
        if let photo = attachButton.imageView?.image, isPhotoSelected {
            dispatchGroup.enter()
            self.showLoadingAnimation(on: self.view)
            
            storage.uploadPhoto(photo: photo, completion: { [weak self] result in
                switch result {
                case .success(let photo):
                    photoResult = photo
                    dispatchGroup.leave()
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        self?.stopAnimation()
                    }
                    self?.alertService.showErrorMessage(desc: error.localizedDescription)
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .global(), execute: { [weak self] in
            self?.savePost(text: text, sphere: sphere, photoResult: photoResult)
        })
    }
    
    func savePost(text: String, sphere: Sphere, photoResult: Photo) {
        let post = Post(id: nil,
                        text: text,
                        sphere: sphere,
                        timestamp: Date.currentTimestamp,
                        photoUrl: photoResult.photoUrl,
                        photoName: photoResult.photoName,
                        previewUrl: photoResult.previewUrl,
                        previewName: photoResult.previewName)
        
        database.savePost(post) { [weak self] in
            guard let self = self else { return }
            self.userService.clearDraft()
            self.stopAnimation()
            let description = "\(sphere.name) \(R.string.localizable.postSuccessValue())"
            self.alertService.showSuccessMessage(desc: description)
            self.addedPostCompletion?()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupSelectSphereButtonTapHandler() {
        selectSphereButton.addTarget(self, action: #selector(showPicker), for: .allTouchEvents)
    }
    
    private func setupTextView() {
        postTextView.delegate = self
        postTextView.becomeFirstResponder()
        let draftText = userService.getDraft()
        postTextView.text = draftText
        placeholderLabel.isHidden = !draftText.isEmpty
    }
    
    @objc private func showPicker() {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        let customTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.addSubview(customTextField)
        
        customTextField.inputView = picker
        customTextField.becomeFirstResponder()
    }
    
    // MARK: Setup View
    
    func setupView() {
        postTextView.font = postTextView.font?.withSize(16)
        titleLabel.font = .journalTitleFont
        titleLabel.textColor = .violet
        titleLabel.text = R.string.localizable.addPostTitle()
        saveButtonView.backgroundColor = .grey
        saveButtonView.layer.cornerRadius = 20
        saveButton.setTitle(R.string.localizable.addPostSave(), for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .journalButtonFont
        attachButton.setTitle("", for: .normal)
        attachButton.tintColor = .violet
        attachButton.imageView?.contentMode = .scaleAspectFill
        dateLabel.font = .journalDateFont
        dateLabel.textColor = .grey
        dateLabel.text = Date.currentDateWithWeekday()
        symbolsCountLabel.font = .journalDateFont
        symbolsCountLabel.textColor = .grey
        symbolsCountLabel.text = "\(postTextView.text.count)/\(maxSymbolsCount)"
        sphereView.layer.cornerRadius = 20
        sphereView.layer.borderWidth = 3
        sphereView.layer.borderColor = UIColor.violet.cgColor
        selectSphereButton.setTitle(R.string.localizable.postChooseSphere(), for: .normal)
        selectSphereButton.titleLabel?.font = .journalButtonFont
        selectSphereButton.setImage(R.image.arrowDownSmall(), for: .normal)
        selectSphereButton.tintColor = .violet
        selectSphereButton.setImageRightToText()
        selectSphereButton.centerTextAndImage(spacing: -5)
        placeholderLabel.text = R.string.localizable.postPlaceholder()
        placeholderLabel.font = postTextView.font?.withSize(16)
        placeholderLabel.textColor = .lightGrey
    }
}

// MARK: UIPickerViewDelegate

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
        selectSphereButton.setTitle(sphere.name, for: .normal)
        saveButtonView.backgroundColor = .violet
    }
}

// MARK: UITextViewDelegate

extension AddPostViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if postType == .add {
            userService.saveDraft(text: postTextView.text)
        }
        let currentTextCount = postTextView.text.count
        symbolsCountLabel.text = "\(currentTextCount)/\(maxSymbolsCount)"
        placeholderLabel.isHidden = currentTextCount != 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        placeholderLabel.isHidden = !currentText.isEmpty
        if text.count > maxSymbolsCount {
            alertService.showErrorMessage(
                desc: R.string.localizable.addPostMaxSymbolAlert(String(maxSymbolsCount))
            )
        }
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= maxSymbolsCount
    }
}

// MARK: UIImagePickerControllerDelegate

extension AddPostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        attachButton.setImage(image, for: .normal)
        isPhotoSelected = true
    }
}
