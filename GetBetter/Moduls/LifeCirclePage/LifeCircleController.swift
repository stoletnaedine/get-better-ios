//
//  CircleController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Charts
import Toaster

class LifeCircleController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var chartView: RadarChartView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sphereValuesIdeal = Array(repeating: 10.0, count: 8)
    var sphereMetrics: SphereMetrics?
    let sphereMetricsXibName = String(describing: SphereMetricsCollectionViewCell.self)
    let reuseCellIdentifier = "SphereMetricsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.TabBar.lifeCircleTitle
        setupSegmentedControl()
        setupCollectionView()
        setupBarButton()
        
        chartView.noDataText = Properties.LifeCircle.loading
        
        DispatchQueue.global(qos: .userInteractive).async {
            DatabaseService().getSphereMetrics(completion: { [weak self] result in
                switch result {
                case .success(let sphereMetrics):
                    DispatchQueue.main.async {
                        self?.sphereMetrics = sphereMetrics
                        self?.setupChartView()
                        self?.collectionView.reloadData()
                    }
                case .failure(_):
                    NotificationCenter.default.post(name: .showPageViewController, object: nil)
                }
            })
        }
        
        chartView.isHidden = false
        collectionView.isHidden = true
    }
    
    func setupCollectionView() {
        collectionView.register(UINib(nibName: sphereMetricsXibName, bundle: nil), forCellWithReuseIdentifier: reuseCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width, height: 100)
        collectionView.collectionViewLayout = layout
    }
    
    func setupChartView() {
        chartView.webLineWidth = 1
        chartView.innerWebLineWidth = 0
        chartView.webColor = .darkGray
        chartView.rotationEnabled = true
        chartView.legend.enabled = true
        
        let xAxis = chartView.xAxis
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 9
        if let sphereMetrics = sphereMetrics {
            let titles = sphereMetrics.values.map { Sphere(rawValue: $0.key)?.name ?? "" }
            xAxis.valueFormatter = XAxisFormatter(titles: titles)
        }
        
        let yAxis = chartView.yAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 9
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.enabled = false
        
        var dataEntries: [RadarChartDataEntry] = []
        var dataEntriesIdeal: [RadarChartDataEntry] = []
        
        for i in 0..<sphereValuesIdeal.count {
            dataEntriesIdeal.append(RadarChartDataEntry(value: sphereValuesIdeal[i]))
        }
        
        if let sphereMetrics = sphereMetrics {
            let userSphereValues = sphereMetrics.values.map { $0.value }
            for i in 0..<sphereValuesIdeal.count {
                dataEntries.append(RadarChartDataEntry(value: userSphereValues[i]))
            }
        }
        
        let dataSetUser = RadarChartDataSet(entries: dataEntries, label: "Твой текущий уровень")
        let dataSetIdeal = RadarChartDataSet(entries: dataEntriesIdeal, label: "К чему можно стремиться")
        
        dataSetIdeal.lineWidth = 1
        dataSetIdeal.colors = [.sky]
        dataSetIdeal.fillColor = .skyFill
        dataSetIdeal.drawFilledEnabled = true
        dataSetIdeal.valueFormatter = DataSetValueFormatter()
        
        dataSetUser.lineWidth = 2
        dataSetUser.colors = [.red]
        dataSetUser.fillColor = .redFill
        dataSetUser.drawFilledEnabled = true
        
        chartView.data = RadarChartData(dataSets: [dataSetUser, dataSetIdeal])
    }
    
    func setupBarButton() {
        let aboutCircleBarButton = UIBarButtonItem(title: Properties.AboutCircle.button, style: .plain, target: self, action: #selector(showAboutCircleViewController))
        navigationItem.leftBarButtonItem = aboutCircleBarButton
    }
    
    @objc func showAboutCircleViewController() {
        let aboutCircleViewController = AboutCircleViewController()
        navigationController?.pushViewController(aboutCircleViewController, animated: true)
    }
    
    func setupSegmentedControl() {
        segmentedControl.tintColor = .sky
        segmentedControl.setTitle(Properties.LifeCircle.SegmentedControl.circle, forSegmentAt: 0)
        segmentedControl.setTitle(Properties.LifeCircle.SegmentedControl.details, forSegmentAt: 1)
    }
    
    @IBAction func segmentedActionDidSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chartView.isHidden = false
            collectionView.isHidden = true
        case 1:
            chartView.isHidden = true
            collectionView.isHidden = false
        default:
            print("default")
        }
    }
}

class XAxisFormatter: IAxisValueFormatter {
    
    let titles: [String]
    
    init(titles: [String]) {
        self.titles = titles
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return titles[Int(value) % titles.count]
    }
}

class DataSetValueFormatter: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
    }
}

extension LifeCircleController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sphereMetrics?.values.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! SphereMetricsCollectionViewCell
        
        let sphereRawValue = sphereMetrics?.values.map { $0.key }[indexPath.row] ?? ""
        guard let sphere = Sphere(rawValue: sphereRawValue) else { return cell }
        guard let sphereValue = sphereMetrics?.values[sphereRawValue] else { return cell }
        
        cell.fillCell(sphere: sphere.name, value: sphereValue, description: sphere.description)
        return cell
    }
}
