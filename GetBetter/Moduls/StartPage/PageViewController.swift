//
//  PageViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 23.04.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    var viewControllers: [UIViewController] = []
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настроим круг"

        fillViewControllers()
        
        if let firstViewController = viewControllers.first {
            pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            pageViewController.delegate = self
            
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            pageViewController.dataSource = self
            addChild(pageViewController)
            view.addSubview(pageViewController.view)
        }
        
        pageViewController!.view.frame = view.bounds
        pageViewController.didMove(toParent: self)

        // Add the page view controller's gesture recognizers to the view controller's view so that the gestures are started more easily.
        view.gestureRecognizers = pageViewController.gestureRecognizers
    }
    
    func fillViewControllers() {
        let relaxViewController = SetupSphereValueViewController()
        relaxViewController.sphereSetupPage = SphereSetupPage(name: Sphere.relax.string, description: "О́тдых — состояние покоя, либо времяпрепровождение, целью которого является восстановление сил, достижение работоспособного состояния организма (рекреация)[1]; время, свободное от работы[2]. Вынужденное бездействие — такое, как ожидание или отбывание наказания, — отдыхом не является.")
        
        let workViewController = SetupSphereValueViewController()
        workViewController.sphereSetupPage = SphereSetupPage(name: Sphere.work.string, description: "Труд — целесообразная, сознательная деятельность человека, направленная на удовлетворение потребностей индивида и общества. В процессе этой деятельности человек при помощи орудий труда осваивает, изменяет и приспосабливает к своим целям предметы природы, использует механические, физические и химические свойства предметов и явлений природы и заставляет их взаимно влиять друг на друга для достижения заранее намеченной цели.[1]")
        
        let environmentViewController = SetupSphereValueViewController()
        environmentViewController.sphereSetupPage = SphereSetupPage(name: Sphere.environment.string, description: "Попадание в окружение крайне опасно для окружаемых войск. На тактическом уровне войска, находящиеся в окружении, подвержены атакам фактически со всех сторон и вынуждены перейти к круговой обороне. На стратегическом уровне окружение приводит к изоляции войск от линий снабжения и обеспечения, лишает их возможности подхода войсковых подкреплений и резервов, вывоза раненых и больных. Подобная ситуация ставит командование окруженными войсками в ситуацию очень ограниченного выбора — либо сражение насмерть, либо капитуляция.")
        
        viewControllers.append(workViewController)
        viewControllers.append(relaxViewController)
        viewControllers.append(environmentViewController)
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else {
            return viewControllers.last
        }
        
        guard viewControllers.count > previousIndex else {
            return nil
        }
        
        return viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = currentIndex + 1
        
        guard viewControllers.count != nextIndex else {
            return viewControllers.first
        }
        
        guard viewControllers.count > nextIndex else {
            return nil
        }
        
        return viewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
