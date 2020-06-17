//
//  SetupSphereValueViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class SetupSphereValueViewController: UIViewController {
    
    @IBOutlet weak var sphereNameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var valueForSphereLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var sphereValue: Double? = GlobalDefinitions.notValidSphereValue
    var sphere: Sphere?
    let values = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    let valuesTitle = [R.string.localizable.onboarding10(),
                       R.string.localizable.onboarding9(),
                       R.string.localizable.onboarding8(),
                       R.string.localizable.onboarding7(),
                       R.string.localizable.onboarding6(),
                       R.string.localizable.onboarding5(),
                       R.string.localizable.onboarding4(),
                       R.string.localizable.onboarding3(),
                       R.string.localizable.onboarding2(),
                       R.string.localizable.onboarding1(),
                       R.string.localizable.onboarding0()]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.hideKeyboardWhenTappedAround()
        
        if let sphere = sphere {
            fillView(from: sphere)
        }
        registerTapForSelectedSphereLabel()
    }
    
    func fillView(from sphere: Sphere) {
        self.sphereNameLabel.text = sphere.name
        self.questionLabel.text = sphere.description
        self.imageView.image = sphere.image
        questionLabel.text = sphere.question
    }
    
    func registerTapForSelectedSphereLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPicker))
        valueForSphereLabel.isUserInteractionEnabled = true
        valueForSphereLabel.addGestureRecognizer(tap)
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
    
    func setupView() {
        questionLabel.font = UIFont.systemFont(ofSize: 16)
        sphereNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        valueForSphereLabel.font = UIFont.systemFont(ofSize: 70)
        valueForSphereLabel.textColor = .violet
        valueForSphereLabel.text = "0"
    }
}

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
        valueForSphereLabel.text = String(value)
    }
}
