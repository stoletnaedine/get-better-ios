//
//  SetupSphereValueViewController.swift
//  GetBetter
//
//  Created by Исламгулова Лариса on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class SetupSphereValueViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var sphereNameLabel: UILabel!
    @IBOutlet weak var sphereDescriptionLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    var sphereValue = 0
    var sphereSetupPage: SphereSetupPage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        if let sphere = sphereSetupPage {
            fillView(from: sphere)
        }
    }
    
    func fillView(from sphere: SphereSetupPage) {
        self.sphereNameLabel.text = sphere.name
        self.sphereDescriptionLabel.text = sphere.description
    }
    
    func setupView() {
        questionLabel.text = "На сколько вы бы оценили эту сферу в своей жизни?"
        questionLabel.font = UIFont(name: Properties.Font.SFUITextMedium, size: 16)
        sphereNameLabel.font = UIFont(name: Properties.Font.OfficinaSansExtraBold, size: 60)
        sphereDescriptionLabel.font = UIFont(name: Properties.Font.SFUITextRegular, size: 14)
        valueTextField.font = UIFont(name: Properties.Font.SFUITextMedium, size: 40)
    }
}
