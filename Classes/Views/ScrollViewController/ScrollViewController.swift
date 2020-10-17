//
//  ScrollViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 17.10.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    private(set) var scrollView: UIScrollView!
    
    var contentView: UIView {
        fatalError("Override this property")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
        
        self.scrollView = UIScrollView()
        self.scrollView.delaysContentTouches = false
        
        self.addScrollView()
        self.addContentView()
    }
    
    func addScrollView() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let bottom = self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let left = self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let right = self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        
        NSLayoutConstraint.activate([top, bottom, left, right])
    }
    
    func addContentView() {
        self.contentView.removeFromSuperview()
        self.scrollView.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = self.contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        let bottom = self.contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        let left = self.contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor)
        let right = self.contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor)
        let width = self.contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        
        NSLayoutConstraint.activate([top, bottom, left, right, width])
    }

}
