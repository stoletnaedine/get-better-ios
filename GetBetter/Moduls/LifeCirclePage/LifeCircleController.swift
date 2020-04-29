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
    let refreshControl = UIRefreshControl()
    
    var startSphereMetrics: SphereMetrics?
    var currentSphereMetrics: SphereMetrics?
    let sphereMetricsXibName = String(describing: SphereMetricsCollectionViewCell.self)
    let reuseCellIdentifier = "SphereMetricsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.TabBar.lifeCircleTitle
        setupSegmentedControl()
        setupCollectionView()
        setupRefreshControl()
        chartView.noDataText = Constants.LifeCircle.loading
        loadAndShowMetrics()
        
        chartView.isHidden = false
        collectionView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAndShowMetrics()
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(loadAndShowMetrics), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @objc func loadAndShowMetrics() {
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .userInitiated).async {
            dispatchGroup.enter()
            FirebaseDatabaseService().getSphereMetrics(from: Constants.SphereMetrics.start, completion: { [weak self] result in
                switch result {
                case .success(let sphereMetrics):
                    self?.startSphereMetrics = sphereMetrics
                    
                    DispatchQueue.main.async {
                        self?.setupChartView()
                        dispatchGroup.leave()
                    }
                case .failure(_):
                    NotificationCenter.default.post(name: .showPageViewController, object: nil)
                    dispatchGroup.leave()
                }
            })
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            dispatchGroup.enter()
            FirebaseDatabaseService().getSphereMetrics(from: Constants.SphereMetrics.current, completion: { [weak self] result in
                switch result {
                case .success(let sphereMetrics):
                    self?.currentSphereMetrics = sphereMetrics
                    
                    DispatchQueue.main.async {
                        self?.setupChartView()
                        dispatchGroup.leave()
                    }
                case .failure(_):
                    NotificationCenter.default.post(name: .showPageViewController, object: nil)
                    dispatchGroup.leave()
                }
            })
        }
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        })
    }
    
    func setupCollectionView() {
        collectionView.register(UINib(nibName: sphereMetricsXibName, bundle: nil), forCellWithReuseIdentifier: reuseCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width, height: 80)
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
        if let sphereMetrics = startSphereMetrics {
            let titles = sphereMetrics.sortedValues()
                .map { Sphere(rawValue: $0.key)?.name ?? "" }
            xAxis.valueFormatter = XAxisFormatter(titles: titles)
        }
        
        let yAxis = chartView.yAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 9
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.enabled = false
        
        var dataEntriesStart: [RadarChartDataEntry] = []
        var dataEntriesCurrent: [RadarChartDataEntry] = []
        let dataEntriesIdeal = Array(repeating: 10.0, count: 8).map { RadarChartDataEntry(value: $0) }
        
        if let startSphereMetrics = startSphereMetrics,
            let currentSphereMetrics = currentSphereMetrics {
            
            dataEntriesStart = startSphereMetrics.sortedValues()
                .map { RadarChartDataEntry(value: $0.value) }
            dataEntriesCurrent = currentSphereMetrics.sortedValues()
                .map { RadarChartDataEntry(value: $0.value) }
        }
        
        let dataSetStart = RadarChartDataSet(entries: dataEntriesStart, label: Constants.LifeCircle.startLevelLegend)
        let dataSetCurrent = RadarChartDataSet(entries: dataEntriesCurrent, label: Constants.LifeCircle.currentLevelLegend)
        let dataSetIdeal = RadarChartDataSet(entries: dataEntriesIdeal, label: Constants.LifeCircle.idealLeveleLegend)
        
        dataSetIdeal.lineWidth = 1
        dataSetIdeal.colors = [.sky]
        dataSetIdeal.fillColor = .skyFill
        dataSetIdeal.drawFilledEnabled = true
        dataSetIdeal.valueFormatter = DataSetValueFormatter()
        
        dataSetStart.lineWidth = 1
        dataSetStart.colors = [.green]
        dataSetStart.fillColor = .green
        dataSetStart.drawFilledEnabled = true
        dataSetStart.valueFormatter = DataSetValueFormatter()
        
        dataSetCurrent.lineWidth = 1
        dataSetCurrent.colors = [.red]
        dataSetCurrent.fillColor = .redFill
        dataSetCurrent.drawFilledEnabled = true
        
        chartView.data = RadarChartData(dataSets: [dataSetStart, dataSetCurrent, dataSetIdeal])
        chartView.animate(xAxisDuration: 0.5, easingOption: .easeInExpo)
    }
    
    func setupSegmentedControl() {
        segmentedControl.tintColor = .sky
        segmentedControl.setTitle(Constants.LifeCircle.SegmentedControl.circle, forSegmentAt: 0)
        segmentedControl.setTitle(Constants.LifeCircle.SegmentedControl.details, forSegmentAt: 1)
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
        return currentSphereMetrics?.values.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier,
                                                      for: indexPath) as! SphereMetricsCollectionViewCell
        
        let sphereRawValue = currentSphereMetrics?
            .sortedValues()
            .map { $0.key }[indexPath.row] ?? ""
        
        guard let sphereValue = currentSphereMetrics?.values[sphereRawValue] else { return cell }
        guard let sphere = Sphere(rawValue: sphereRawValue) else { return cell }
        
        cell.fillCell(sphere: sphere.name, value: sphereValue, description: sphere.description)
        return cell
    }
}
