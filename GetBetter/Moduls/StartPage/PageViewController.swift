//
//  PageViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Toaster

class PageViewController: UIViewController {

    var viewControllers: [UIViewController] = []
    let databaseService = DatabaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Properties.SetupSphere.setupTitle

        fillViewControllers()
        setupPageControl()
        setupSaveBarButton()
    }
    
    func fillViewControllers() {
        viewControllers.append(WelcomeViewController())
        
        for sphere in Sphere.allCases {
            let viewController = SetupSphereValueViewController()
            viewController.sphere = sphere
            viewControllers.append(viewController)
        }
    }
    
    func setupPageControl() {
        guard let firstViewController = viewControllers.first else { return }
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        
        pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
    }
    
    func setupSaveBarButton() {
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSphereValues))
        navigationItem.rightBarButtonItem = saveBarButton
    
        // TODO потом выпилить
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "RANDOM", style: .plain, target: self, action: #selector(randomValues))
    }
    
    // TODO потом выпилить
    @objc func randomValues() {
        let metricsArray = Sphere.allCases.reduce(into: [String: Double]()) {
            $0[$1.rawValue ] = Double(Int.random(in: 3...10))
        }
        let sphereMetrics = SphereMetrics(values: metricsArray)
        let _ = databaseService.saveSphereMetrics(sphereMetrics, pathToSave: Properties.SphereMetrics.start)
        let _ = databaseService.saveSphereMetrics(sphereMetrics, pathToSave: Properties.SphereMetrics.current)
        NotificationCenter.default.post(name: .showTabBarController, object: nil)
    }
    
    @objc func saveSphereValues() {
        
        let setupSphereValueViewControllers = viewControllers
            .filter { !($0 is WelcomeViewController) }
            .map { $0 as! SetupSphereValueViewController }
        
        let metricsArray = setupSphereValueViewControllers.reduce(into: [String: Double]()) {
            $0[$1.sphere?.rawValue ?? "Optional sphere couldn't be unwrapped"] = $1.sphereValue
        }
        let sphereMetrics = SphereMetrics(values: metricsArray)
        
        if sphereMetrics.notValid() {
            Toast(text: "Введите все значения").show()
            return
        }
        if databaseService.saveSphereMetrics(sphereMetrics, pathToSave: Properties.SphereMetrics.start) {
            Toast(text: "Сохранено!").show()
            NotificationCenter.default.post(name: .showTabBarController, object: nil)
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewControllers.count > previousIndex else { return nil }
        
        return viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard viewControllers.count > nextIndex else { return nil }
        
        return viewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
