//
//  HistoryViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import YPImagePicker

enum PostType {
    case add
    case edit
}

enum ImageViewState {
    case empty
    case fill
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
    @IBOutlet weak var photoCounterLabel: UILabel!

    enum Constants {
        static let maxSymbolsCount: Int = 2000
    }

    let database: DatabaseProtocol = FirebaseDatabase()
    let storage: FileStorageProtocol = FirebaseStorage()
    let alertService: AlertServiceProtocol = AlertService()
    let userService: UserSettingsServiceProtocol = UserSettingsService()
    var selectedSphere: Sphere?
    var addedPostCompletion: VoidClosure?
    var postType: PostType = .add
    var isClearedPhotos = false
    var imagesToUpload: [UIImage] = [] {
        didSet {
            imageView.image = imagesToUpload.first
            photoCounterLabel.text = self.imagesToUpload.count > 1
                ? "+\(self.imagesToUpload.count - 1)"
                : nil
        }
    }

    // MARK: — Private properties

    private var selectedItems: [YPMediaItem]?
    
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
        imagesToUpload = []
        selectedItems = nil
        isClearedPhotos = true
        setupImageView(.empty)
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        self.configurePost() { [weak self] post in
            guard let self = self else { return }
            self.savePost(post)
        }
    }

    func configurePost(completion: @escaping (Post) -> Void) {
        guard let text = postTextView.text, !text.isEmpty else {
            alertService.showErrorMessage(R.string.localizable.postEmptyText())
            return
        }
        guard let sphere = selectedSphere else {
            alertService.showErrorMessage(R.string.localizable.postEmptySphere())
            return
        }
        guard self.postType == .add else { return }

        if !imagesToUpload.isEmpty {
            self.showLoadingAnimation(on: self.view)
            self.selectSphereButton.isEnabled = false
            self.saveButton.isEnabled = false
            if #available(iOS 13.0, *) {
                self.isModalInPresentation = true
            }

            self.storage.uploadPhotos(imagesToUpload, needFirstPhotoPreview: true) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(postPhotos):
                    let post = Post(
                        id: nil,
                        text: text,
                        sphere: sphere,
                        timestamp: Date.currentTimestamp,
                        previewUrl: postPhotos.preview?.url,
                        previewName: postPhotos.preview?.name,
                        photos: postPhotos.photos)
                    completion(post)
                case let .failure(error):
                    DispatchQueue.main.async {
                        self.stopAnimation()
                        self.selectSphereButton.isEnabled = true
                        self.saveButton.isEnabled = true
                    }
                    self.alertService.showErrorMessage(error.localizedDescription)
                }
            }
        } else {
            let post = Post(
                id: nil,
                text: text,
                sphere: sphere,
                timestamp: Date.currentTimestamp,
                previewUrl: nil,
                previewName: nil,
                photos: nil)
            completion(post)
        }
    }
    
    func savePost(_ post: Post) {
        database.savePost(post) { [weak self] in
            guard let self = self else { return }
            self.userService.clearDraft()
            self.stopAnimation()
            let description = "\(post.sphere?.name ?? "") \(R.string.localizable.postSuccessValue())"
            self.alertService.showSuccessMessage(description)
            self.addedPostCompletion?()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupSelectSphereButtonTapHandler() {
        selectSphereButton.addTarget(self, action: #selector(showSpherePicker), for: .allTouchEvents)
    }

    func setupImageView(_ state: ImageViewState) {
        switch state {
        case .empty:
            photoCounterLabel.isHidden = true
            cancelLoadButton.isHidden = true
            loadImageButton.isHidden = false
            bigLoadImageButton.isHidden = false
            loadImageButton.alpha = 0
            UIView.animate(
                withDuration: 0.6,
                animations: {
                    self.imageView.alpha = 0
                    self.loadImageButton.alpha = 1
                },
                completion: { _ in
                    self.imageView.alpha = 1
                    self.imageView.image = nil
                })
        case .fill:
            loadImageButton.isHidden = true
            cancelLoadButton.isHidden = false
            photoCounterLabel.isHidden = false
        }
    }

    // MARK: — Private methods
    
    private func setupTextView() {
        postTextView.delegate = self
        postTextView.becomeFirstResponder()
        let draftText = userService.getDraft()
        postTextView.text = draftText
        placeholderLabel.isHidden = !draftText.isEmpty
    }
    
    @objc private func showSpherePicker() {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        let hiddenTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.addSubview(hiddenTextField)
        
        hiddenTextField.inputView = picker
        hiddenTextField.becomeFirstResponder()
    }

    private func openImagePickerController() {
        var config = YPImagePickerConfiguration()
        config.onlySquareImagesFromCamera = false
        config.albumName = "GetBetter"
        config.startOnScreen = .library
        config.targetImageSize = .cappedTo(size: 1200)
        config.hidesStatusBar = true
        config.gallery.hidesRemoveButton = false
        config.colors.tintColor = .violet
        config.library.maxNumberOfItems = 5
        config.library.mediaType = .photo
        config.library.preselectedItems = selectedItems
        let picker = YPImagePicker(configuration: config)
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        picker.didFinishPicking { [weak self, picker] items, isCancelled in
            UINavigationBar.appearance().barTintColor = .violet
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            guard let self = self else { return }
            if isCancelled {
                if self.selectedItems == nil && self.postType == .add {
                    self.setupImageView(.empty)
                    self.imagesToUpload = []
                }
                picker.dismiss(animated: true, completion: nil)
                return
            }
            self.setupImageView(.fill)
            let images = items.compactMap { item -> UIImage? in
                guard case .photo(let photo) = item else { return nil }
                return photo.image
            }
            self.imagesToUpload = images
            self.selectedItems = items
            picker.dismiss(animated: true, completion: nil)
        }
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
        symbolsCountLabel.text = "\(postTextView.text.count)/\(Constants.maxSymbolsCount)"
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
        photoCounterLabel.textColor = .white
        photoCounterLabel.font = .journalButtonFont
        photoCounterLabel.text = nil
        photoCounterLabel.addShadow(shadowRadius: 2)
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
        symbolsCountLabel.text = "\(currentTextCount)/\(Constants.maxSymbolsCount)"
        placeholderLabel.isHidden = currentTextCount != 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        placeholderLabel.isHidden = !currentText.isEmpty
        if text.count > Constants.maxSymbolsCount {
            alertService.showErrorMessage(
                R.string.localizable.addPostMaxSymbolAlert(String(Constants.maxSymbolsCount))
            )
        }
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= Constants.maxSymbolsCount
    }
}
