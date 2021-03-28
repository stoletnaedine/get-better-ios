//
//  SetupSphereValueViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import MaterialShowcase

class SetupSphereValueViewController: UIViewController {
    
    @IBOutlet weak var sphereNameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var setupValueButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var arrowDownImageView: UIImageView!
    @IBOutlet weak var arrowUpImageView: UIImageView!

    var sphere: Sphere?
    var sphereValue: Double = Properties.notValidSphereValue

    private var userSettingsService: UserSettingsServiceProtocol = UserSettingsService()
    private let values = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    private let valuesTitle = [
        R.string.localizable.onboarding10(),
        R.string.localizable.onboarding9(),
        R.string.localizable.onboarding8(),
        R.string.localizable.onboarding7(),
        R.string.localizable.onboarding6(),
        R.string.localizable.onboarding5(),
        R.string.localizable.onboarding4(),
        R.string.localizable.onboarding3(),
        R.string.localizable.onboarding2(),
        R.string.localizable.onboarding1(),
        R.string.localizable.onboarding0()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.hideKeyboardWhenTappedAround()
        
        if let sphere = sphere {
            fillView(from: sphere)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showTutorial()
    }
    
    @IBAction func valueButtonDidTap(_ sender: Any) {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(values.count / 2, inComponent: 0, animated: false)
        
        let customTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.addSubview(customTextField)
        
        customTextField.inputView = picker
        customTextField.becomeFirstResponder()
    }
    
    private func showTutorial() {
        if !userSettingsService.tutorialHasShown {
            let showcase = MaterialShowcase()
            showcase.backgroundRadius = 1000
            showcase.backgroundAlpha = 0.9
            showcase.setTargetView(view: setupValueButton)
            showcase.primaryText = R.string.localizable.onboardingTutorialPrimaryText()
            showcase.secondaryText = R.string.localizable.onboardingTutorialSecondaryText()
            showcase.show(completion: { [weak self] in
                guard let self = self else { return }
                self.userSettingsService.tutorialHasShown = true
            })
        }
    }
    
    private func fillView(from sphere: Sphere) {
        sphereNameLabel.text = sphere.name
        questionLabel.text = sphere.description
        imageView.image = sphere.image
        questionLabel.text = sphere.question
    }
}

// MARK: Setup View

extension SetupSphereValueViewController {
    func setupView() {
        questionLabel.font = UIFont.systemFont(ofSize: 16)
        sphereNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        setupValueButton.setTitle(R.string.localizable.onboardingUnselect(), for: .normal)
        setupValueButton.titleLabel?.font = UIFont.systemFont(ofSize: 70)
        setupValueButton.tintColor =  .violet
        arrowDownImageView.tint(with: .violet)
        arrowUpImageView.tint(with: .violet)
    }
}

// MARK: UIPickerViewDelegate

extension SetupSphereValueViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return valuesTitle[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let value = values[row]
        sphereValue = Double(value)
        setupValueButton.setTitle(String(value), for: .normal)
    }
}
