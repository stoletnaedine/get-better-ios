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
    @IBOutlet weak var loadImageButton: UIButton!
    @IBOutlet weak var bigLoadImageButton: UIButton!
    @IBOutlet weak var symbolsCountLabel: UILabel!
    @IBOutlet weak var sphereView: UIView!
    @IBOutlet weak var selectSphereButton: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelLoadButton: UIButton!
    
    var selectedSphere: Sphere?
    let database: GBDatabase = FirebaseDatabase()
    let alertService: AlertService = AlertServiceDefault()
    let userService: UserSettingsServiceProtocol = UserSettingsService()
    var addedPostCompletion: VoidClosure?
    var postType: PostType = .add
    var isOldPhoto: Bool = true
    let maxSymbolsCount: Int = 300
    
    private let storage: GBStorage = FirebaseStorage()
    private var imageToUpload: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupTextView()
        setupSelectSphereButtonTapHandler()
        setupView()
        cancelLoadButton.isHidden = true
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadImageButtonDidTap(_ sender: UIButton) {
        openImagePickerController()
    }

    @IBAction func bigLoadImageButtonDidTap(_ sender: UIButton) {
        openImagePickerController()
    }

    @IBAction func cancelLoadButtonDidTap(_ sender: Any) {
        imageToUpload = nil
        isOldPhoto = false
        cancelLoadButton.isHidden = true
        loadImageButton.isHidden = false
        bigLoadImageButton.isHidden = false
        loadImageButton.alpha = 0
        UIView.animate(withDuration: 0.8,
                       animations: {
                        self.imageView.alpha = 0
                        self.loadImageButton.alpha = 1
                       },
                       completion: { _ in
                        self.imageView.alpha = 1
                        self.imageView.image = nil
                       })
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
        
        var photoResult = Photo()
        let dispatchGroup = DispatchGroup()
        
        if let photo = imageToUpload {
            guard !(postType == .edit && isOldPhoto) else {
                savePost(text: text, sphere: sphere, photoResult: photoResult)
                return
            }
            
            dispatchGroup.enter()
            self.showLoadingAnimation(on: self.view)
            self.selectSphereButton.isEnabled = false
            self.saveButton.isEnabled = false
            
            storage.uploadPhoto(photo: photo, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let photo):
                    photoResult = photo
                    dispatchGroup.leave()
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.stopAnimation()
                        self.selectSphereButton.isEnabled = true
                        self.saveButton.isEnabled = true
                    }
                    self.alertService.showErrorMessage(desc: error.localizedDescription)
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .global(), execute: { [weak self] in
            guard let self = self else { return }
            self.savePost(text: text, sphere: sphere, photoResult: photoResult)
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
    
    // MARK: — Private methods

    private func openImagePickerController() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.navigationBar.tintColor = .white
        picker.navigationBar.barTintColor = .violet
        present(picker, animated: true, completion: nil)
    }
    
    private func setupView() {
        postTextView.font = postTextView.font?.withSize(16)
        titleLabel.font = .journalTitleFont
        titleLabel.textColor = .violet
        titleLabel.text = R.string.localizable.addPostTitle()
        saveButtonView.backgroundColor = .grey
        saveButtonView.layer.cornerRadius = 20
        saveButton.setTitle(R.string.localizable.addPostSave(), for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .journalButtonFont
        loadImageButton.tintColor = .violet
        loadImageButton.imageView?.contentMode = .scaleAspectFill
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
        loadImageButton.isHidden = true
        bigLoadImageButton.isHidden = true
        cancelLoadButton.isHidden = false
        imageView.image = image
        imageToUpload = image
        isOldPhoto = false
    }
}
