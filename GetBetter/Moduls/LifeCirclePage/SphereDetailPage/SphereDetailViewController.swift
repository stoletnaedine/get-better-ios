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
    @IBOutlet weak var photoImageView: UIImageView!
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
        sphereLabel.text = sphereValue.sphere?.name
        if let value = sphereValue.value {
            self.textLabel.text = "В этой сфере жизни вы прокачены на \(value) баллов."
        }
    }
    
    func customizeView() {
        textLabel.font = UIFont.systemFont(ofSize: 18)
        sphereLabel.font = UIFont.boldSystemFont(ofSize: 24)
        sphereLabel.textColor = .violet
        cancelButton.setTitle("", for: .normal)
        photoImageView.isHidden = true
    }
}
