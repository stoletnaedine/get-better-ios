//
//  SetupSphereValueViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class SetupSphereValueViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var sphereNameLabel: UILabel!
    @IBOutlet weak var sphereDescriptionLabel: UILabel!
    @IBOutlet weak var valueForSphereLabel: UILabel!
    
    var sphereValue: Double? = Constants.SetupSphere.notValidValue
    var sphere: Sphere?
    let values = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    let valuesTitle = ["10 — идеально",
                       "9 — прекрасно",
                       "8 — отлично",
                       "7 — хорошо",
                       "6 — неплохо",
                       "5 — средне",
                       "4 — так себе",
                       "3 — могло быть и лучше",
                       "2 — плохо",
                       "1 — ужасно",
                       "0 — у меня нет этого"]

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
        self.sphereDescriptionLabel.text = sphere.description
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
        questionLabel.text = Constants.SetupSphere.question
        questionLabel.font = UIFont(name: Constants.Font.SFUITextMedium, size: 16)
        sphereNameLabel.font = UIFont(name: Constants.Font.OfficinaSansExtraBold, size: 50)
        sphereDescriptionLabel.font = UIFont(name: Constants.Font.SFUITextRegular, size: 16)
        valueForSphereLabel.font = UIFont(name: Constants.Font.SFUITextMedium, size: 60)
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
