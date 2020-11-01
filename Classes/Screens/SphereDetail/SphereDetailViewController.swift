//
//  SphereDetailViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 10.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class SphereDetailViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var sphereLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var sphereValue: SphereValue?
    
    let alertService: AlertService = AlertServiceDefault()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        guard let sphereValue = sphereValue else { return }
        configure(by: sphereValue)
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func configure(by sphereValue: SphereValue) {
        guard let sphere = sphereValue.sphere else { return }
        guard let value = sphereValue.value else { return }
        sphereLabel.text = sphere.name
        valueLabel.text = value.stringWithComma()
        photoImageView.image = sphere.image
        textLabel.text = sphere.description
    }
    
    func setupView() {
        textLabel.font = UIFont.systemFont(ofSize: 16)
        sphereLabel.font = UIFont.boldSystemFont(ofSize: 24)
        sphereLabel.textColor = .violet
        valueLabel.textColor = .violet
        valueLabel.font = UIFont.systemFont(ofSize: 80)
    }
}
