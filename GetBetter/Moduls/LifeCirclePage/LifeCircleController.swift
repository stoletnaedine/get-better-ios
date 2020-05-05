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
    @IBOutlet weak var fakeChartView: RadarChartView!
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    let firebaseDatabaseService = FirebaseDatabaseService()
    
    var startSphereMetrics: SphereMetrics?
    var currentSphereMetrics: SphereMetrics?
    let sphereMetricsXibName = String(describing: SphereMetricsTableViewCell.self)
    let reuseCellIdentifier = "SphereMetricsCell"
    let sphereIconSize: CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.noDataText = Constants.LifeCircle.loading
        loadAndShowMetrics()
        setupFakeChartView()
        
        self.title = Constants.TabBar.lifeCircleTitle
        setupSegmentedControl()
        setupTableView()
        setupRefreshControl()
        
        chartView.isHidden = false
        tableView.isHidden = true
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(loadAndShowMetrics), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func loadAndShowMetrics() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            self?.firebaseDatabaseService.getSphereMetrics(from: Constants.SphereMetrics.start, completion: { [weak self] result in
                switch result {
                case .success(let sphereMetrics):
                    self?.startSphereMetrics = sphereMetrics
                    dispatchGroup.leave()
                    
                case .failure(_):
                    NotificationCenter.default.post(name: .showPageViewController, object: nil)
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            self?.firebaseDatabaseService.getSphereMetrics(from: Constants.SphereMetrics.current, completion: { [weak self] result in
                switch result {
                case .success(let sphereMetrics):
                    self?.currentSphereMetrics = sphereMetrics
                    dispatchGroup.leave()
                    
                case .failure(_):
                    NotificationCenter.default.post(name: .showPageViewController, object: nil)
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            self?.setupChartView()
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        })
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: sphereMetricsXibName, bundle: nil), forCellReuseIdentifier: reuseCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupSegmentedControl() {
        segmentedControl.backgroundColor = .violet
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.darkGray,
                                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)
        segmentedControl.setTitle(Constants.LifeCircle.SegmentedControl.circle, forSegmentAt: 0)
        segmentedControl.setTitle(Constants.LifeCircle.SegmentedControl.details, forSegmentAt: 1)
    }
    
    @IBAction func segmentedActionDidSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chartView.isHidden = false
            fakeChartView.isHidden = false
            tableView.isHidden = true
        case 1:
            chartView.isHidden = true
            fakeChartView.isHidden = true
            tableView.isHidden = false
        default:
            print("default")
        }
    }
    
    func setupFakeChartView() {
        
        let dataEntriesFake = Array(repeating: 10.0, count: 64).map { RadarChartDataEntry(value: $0) }
        let dataSetFake = RadarChartDataSet(entries: dataEntriesFake, label: "")
        dataSetFake.lineWidth = 0
        dataSetFake.fillColor = .violet
        dataSetFake.fillAlpha = 0.1
        dataSetFake.drawFilledEnabled = true
        dataSetFake.valueFormatter = DataSetValueFormatter()
        
        fakeChartView.data = RadarChartData(dataSets: [dataSetFake])
        
        fakeChartView.noDataText = ""
        fakeChartView.webLineWidth = 0
        fakeChartView.innerWebLineWidth = 0
        fakeChartView.legend.enabled = true
        
        let xAxis = fakeChartView.xAxis
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 9
        xAxis.labelFont = .systemFont(ofSize: sphereIconSize)
        xAxis.labelTextColor = .clear
        xAxis.valueFormatter = XAxisFormatter(titles: Array(repeating: "⬜️", count: 64))
        
        let yAxis = fakeChartView.yAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 9
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.enabled = false
    }
    
    func setupChartView() {
        chartView.webLineWidth = 1
        chartView.innerWebLineWidth = 0
        chartView.webColor = .lightGray
        chartView.rotationEnabled = true
        chartView.legend.enabled = true
        
        let xAxis = chartView.xAxis
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 9
        xAxis.labelFont = .systemFont(ofSize: sphereIconSize)
        if let sphereMetrics = startSphereMetrics {
            let titles = sphereMetrics.sortedValues()
                .map { Sphere(rawValue: $0.key)?.icon ?? "" }
            xAxis.valueFormatter = XAxisFormatter(titles: titles)
        }
        
        let yAxis = chartView.yAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 9
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.enabled = false
        
        var dataEntriesStart: [RadarChartDataEntry] = []
        var dataEntriesCurrent: [RadarChartDataEntry] = []
        
        if let startSphereMetrics = startSphereMetrics,
            let currentSphereMetrics = currentSphereMetrics {
            
            dataEntriesStart = startSphereMetrics.sortedValues()
                .map { RadarChartDataEntry(value: $0.value) }
            dataEntriesCurrent = currentSphereMetrics.sortedValues()
                .map { RadarChartDataEntry(value: $0.value) }
        }
        
        let dataSetStart = RadarChartDataSet(entries: dataEntriesStart, label: Constants.LifeCircle.startLevelLegend)
        let dataSetCurrent = RadarChartDataSet(entries: dataEntriesCurrent, label: Constants.LifeCircle.currentLevelLegend)
        
        dataSetStart.lineWidth = 2
        dataSetStart.colors = [.white]
        dataSetStart.fillColor = .white
        dataSetStart.fillAlpha = 0.3
        dataSetStart.drawFilledEnabled = true
        dataSetStart.valueFormatter = DataSetValueFormatter()
        
        dataSetCurrent.lineWidth = 2
        dataSetCurrent.colors = [.violet]
        dataSetCurrent.fillColor = .violet
        dataSetCurrent.fillAlpha = 0.5
        dataSetCurrent.drawFilledEnabled = true
        dataSetCurrent.valueFormatter = DataSetValueFormatter()
        
        chartView.data = RadarChartData(dataSets: [dataSetCurrent, dataSetStart])
        chartView.animate(xAxisDuration: 0.6, easingOption: .easeInOutCirc)
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
        let dataSetCurrentIndex = 1
        if dataSetIndex == dataSetCurrentIndex {
            return "\(value)"
        }
        return ""
    }
}

extension LifeCircleController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSphereMetrics?.values.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as! SphereMetricsTableViewCell
        
        let sphereRawValue = currentSphereMetrics?
            .sortedValues()
            .map { $0.key }[indexPath.row] ?? ""
        
        guard let value = currentSphereMetrics?.values[sphereRawValue] else { return cell }
        guard let sphere = Sphere(rawValue: sphereRawValue) else { return cell }
        
        let sphereValue = SphereValue(sphere: sphere, value: value)
        cell.fillCell(from: sphereValue)
        
        return cell
    }
}
