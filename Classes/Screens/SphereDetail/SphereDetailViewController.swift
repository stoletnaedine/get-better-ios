//
//  SphereDetailViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 10.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class SphereDetailViewController: UIViewController {
    
    @IBOutlet weak var sphereLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var sphereValue: SphereValue?
    var userData: UserData?
    
    let sphereMetricsService: SphereMetricsService = SphereMetricsServiceDefault()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        guard let sphereValue = sphereValue,
              let sphere = sphereValue.sphere,
              let userData = userData else { return }
        let text = sphereMetricsService.text(for: sphere, userData: userData)
        configure(by: sphereValue, text: text)
    }
    
    private func configure(by sphereValue: SphereValue, text: String) {
        guard let sphere = sphereValue.sphere else { return }
        guard let value = sphereValue.value else { return }
        sphereLabel.text = sphere.name
        valueLabel.text = value.stringWithComma()
        textView.text = text
    }
    
    private func setupView() {
        sphereLabel.font = UIFont.boldSystemFont(ofSize: 24)
        sphereLabel.textColor = .violet
        valueLabel.textColor = .violet
        valueLabel.font = UIFont.systemFont(ofSize: 60)
    }
    
    @IBAction private func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
