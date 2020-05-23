//
//  SphereDetailViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 10.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Toaster

class SphereDetailViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var sphereLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var cancelImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var sphereValue: SphereValue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sphereValue = sphereValue {
            fillViewController(sphereValue)
        }
        registerGestureCopyLabelText()
        customizeView()
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func registerGestureCopyLabelText() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(copyLabelText))
        textLabel.isUserInteractionEnabled = true
        textLabel.addGestureRecognizer(tap)
    }
    
    @objc func copyLabelText(_ sender: UITapGestureRecognizer) {
        if let copyText = textLabel.text {
            UIPasteboard.general.string = copyText
            Toast(text: "Скопировано", delay: 0, duration: 0.5).show()
        }
    }

    func fillViewController(_ sphereValue: SphereValue) {
        guard let sphere = sphereValue.sphere else { return }
        guard let value = sphereValue.value else { return }
        sphereLabel.text = sphere.name
        valueLabel.text = String(value)
        photoImageView.image = sphere.image
        textLabel.text = sphere.description
    }
    
    func customizeView() {
        textLabel.font = UIFont.systemFont(ofSize: 16)
        sphereLabel.font = UIFont.boldSystemFont(ofSize: 24)
        sphereLabel.textColor = .violet
        valueLabel.textColor = .violet
        valueLabel.font = UIFont.systemFont(ofSize: 80)
        cancelButton.setTitle("", for: .normal)
        cancelImageView.image = cancelImageView.image?.withRenderingMode(.alwaysTemplate)
        cancelImageView.tintColor = .violet
    }
}
