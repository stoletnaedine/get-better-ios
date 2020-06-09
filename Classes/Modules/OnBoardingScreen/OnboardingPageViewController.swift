//
//  OnboardingPageViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIViewController {

    var viewControllers: [UIViewController] = []
    let databaseService: DatabaseService = FirebaseDatabaseService()
    let alertService: AlertService = AppAlertService()
    
    var completion: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.onboardingTitle()

        fillViewControllers()
        setupPageControl()
        setupBarButton()
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
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        pageViewController.delegate = self
        
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = .thirtyGray
        appearance.currentPageIndicatorTintColor = .violet
        
        pageViewController.setViewControllers([firstViewController],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        pageViewController.dataSource = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.backgroundColor = .white
    }
    
    func setupBarButton() {
        let saveBarButton = UIBarButtonItem(title: R.string.localizable.onboardingSave(),
                                            style: .plain,
                                            target: self,
                                            action: #selector(saveSphereValues))
        navigationItem.rightBarButtonItem = saveBarButton
        
        let exitBarButton = UIBarButtonItem(title: R.string.localizable.onboardingExit(),
                                            style: .plain,
                                            target: self,
                                            action: #selector(exit))
        navigationItem.leftBarButtonItem = exitBarButton
    }
    
    @objc func exit() {
        NotificationCenter.default.post(name: .logout, object: nil)
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
            alertService.showSuccessMessage(desc: R.string.localizable.onboardingEmptyValuesWarning())
            return
        }
        
        if databaseService.saveSphereMetrics(sphereMetrics, pathToSave: GlobalDefiitions.SphereMetrics.start)
            && databaseService.saveSphereMetrics(sphereMetrics, pathToSave: GlobalDefiitions.SphereMetrics.current) {
            self.completion()
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewControllers.count > previousIndex else { return nil }
        
        return viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
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
