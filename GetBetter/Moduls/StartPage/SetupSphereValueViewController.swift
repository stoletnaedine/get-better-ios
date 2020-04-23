//
//  SetupSphereValueViewController.swift
//  GetBetter
//
//  Created by Исламгулова Лариса on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class SetupSphereValueViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var sphereNameLabel: UILabel!
    @IBOutlet weak var sphereDescriptionLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func valueSliderDidChanged(_ sender: UISlider) {
    }
    
}
