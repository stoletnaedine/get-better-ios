//
//  HelpViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HelpViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let reuseIdentifier = "HelpCategoryCell"
    let parsingService = ParsingService()
    var categories: [CategoryStruct] = []
    var activityIndicatorView: UIActivityIndicatorView?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.TabBar.postTitle
        bindCollectionViewWithData()
        checkItemSelected()
        customizeCollectionView()
        setupActivityIndicator()
    }
    
    func bindCollectionViewWithData() {
        DataSource().getData(coreDataType: CategoryData.self, plainType: CategoryStruct.self)
            .do(onNext : {
                if $0.isEmpty {
                    self.activityIndicatorView?.isHidden = true
                }
            })
            .map {
                $0.sorted { Int($0.id ?? 0) < Int($1.id ?? 0) }
            }
            .bind(to: self.collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: HelpCell.self)) {
                (index, category: CategoryStruct, cell) in
                 cell.fillCell(category: category)
                 cell.backgroundColor = .beige
                 self.activityIndicatorView?.isHidden = true
            }
            .disposed(by: disposeBag)
    }
    
    func checkItemSelected() {
        collectionView
            .rx
            .modelSelected(CategoryStruct.self)
            .subscribe { model in
                if let category = model.element {
                    let charityEventsViewController = CharityEventsViewController()
                    charityEventsViewController.categoryName = category.name
                    charityEventsViewController.title = category.title
                    self.navigationController?.pushViewController(charityEventsViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func customizeCollectionView() {
        collectionView.register(UINib(nibName: "HelpCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        let width = UIScreen.main.bounds.width
        let cellWidth = (width - (9 * 3)) / 2
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: cellWidth, height: 160)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 9, left: 8, bottom: 9, right: 8)
        guard let collectionView = collectionView else { return }
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    func setupActivityIndicator() {
        guard let bounds = UIApplication.shared.keyWindow?.bounds else { return }
        activityIndicatorView = UIActivityIndicatorView(frame: bounds)
        guard let activityIndicatorView = activityIndicatorView else { return }
        activityIndicatorView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        activityIndicatorView.color = .gray
        guard let tabBarController = self.tabBarController else { return }
        tabBarController.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
}
