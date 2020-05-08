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
    @IBOutlet weak var metricsTableView: UITableView!
    @IBOutlet weak var achievementsTableView: UITableView!
    let refreshControl = UIRefreshControl()
    let firebaseDatabaseService = FirebaseDatabaseService()
    
    var startSphereMetrics: SphereMetrics?
    var currentSphereMetrics: SphereMetrics?
    var achievements: [Achievement] = []
    let sphereMetricsXibName = String(describing: SphereMetricsTableViewCell.self)
    let sphereMetricsReuseCellIdentifier = "SphereMetricsCell"
    let achievementsXibName = String(describing: AchievementsTableViewCell.self)
    let achievementsReuseCellIdentifier = "AchievementsCell"
    let sphereIconSize: CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.noDataText = Constants.LifeCircle.loading
        loadAndShowData()
        
        self.title = Constants.TabBar.lifeCircleTitle
        view.backgroundColor = .appBackground
        setupSegmentedControl()
        setupTableView()
        setupRefreshControl()
        
        chartView.isHidden = false
        metricsTableView.isHidden = true
        achievementsTableView.isHidden = true
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(loadAndShowData), for: .valueChanged)
        metricsTableView.addSubview(refreshControl)
    }
    
    @objc func loadAndShowData() {
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
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            self?.firebaseDatabaseService.getAchievements(completion: { [weak self] result in
                switch result {
                case .success(let achievements):
                    self?.achievements = achievements
                    dispatchGroup.leave()
                    
                default:
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            self?.setupChartView()
            self?.metricsTableView.reloadData()
            self?.achievementsTableView.reloadData()
            self?.refreshControl.endRefreshing()
        })
    }
    
    func setupTableView() {
        achievementsTableView.dataSource = self
        achievementsTableView.delegate = self
        achievementsTableView.register(UINib(nibName: achievementsXibName, bundle: nil), forCellReuseIdentifier: achievementsReuseCellIdentifier)
        achievementsTableView.backgroundColor = .appBackground
        
        metricsTableView.dataSource = self
        metricsTableView.delegate = self
        metricsTableView.register(UINib(nibName: sphereMetricsXibName, bundle: nil), forCellReuseIdentifier: sphereMetricsReuseCellIdentifier)
        metricsTableView.backgroundColor = .appBackground
    }
    
    func setupSegmentedControl() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.darkGray,
                                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)
        segmentedControl.setTitle(Constants.LifeCircle.SegmentedControl.circle, forSegmentAt: 0)
        segmentedControl.setTitle(Constants.LifeCircle.SegmentedControl.metrics, forSegmentAt: 1)
        segmentedControl.setTitle(Constants.LifeCircle.SegmentedControl.achievments, forSegmentAt: 2)
    }
    
    @IBAction func segmentedActionDidSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chartView.isHidden = false
            metricsTableView.isHidden = true
            achievementsTableView.isHidden = true
        case 1:
            chartView.isHidden = true
            metricsTableView.isHidden = false
            achievementsTableView.isHidden = true
        default:
            chartView.isHidden = true
            metricsTableView.isHidden = true
            achievementsTableView.isHidden = false
        }
    }
    
    func setupChartView() {
        chartView.webLineWidth = 2
        chartView.innerWebLineWidth = 2
        chartView.webColor = .lifeCircleLineBack
        chartView.innerWebColor = .lifeCircleLineBack
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
        dataSetStart.colors = [.lifeCircleLineStart]
        dataSetStart.valueFormatter = DataSetValueFormatter()
        
        dataSetCurrent.lineWidth = 2
        dataSetCurrent.colors = [.lifeCircleLineCurrent]
        dataSetCurrent.fillColor = .lifeCircleFillCurrent
        dataSetCurrent.fillAlpha = 0.75
        dataSetCurrent.drawFilledEnabled = true
        dataSetCurrent.valueFormatter = DataSetValueFormatter()
        
        chartView.data = RadarChartData(dataSets: [dataSetStart, dataSetCurrent])
        chartView.animate(xAxisDuration: 0.6, easingOption: .easeInOutCirc)
        chartView.backgroundColor = .appBackground
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
        switch tableView {
        case metricsTableView:
            return currentSphereMetrics?.values.count ?? 0
        case achievementsTableView:
            return achievements.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case metricsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: sphereMetricsReuseCellIdentifier, for: indexPath) as! SphereMetricsTableViewCell
            
            let sphereRawValue = currentSphereMetrics?
                .sortedValues()
                .map { $0.key }[indexPath.row] ?? ""
            
            guard let value = currentSphereMetrics?.values[sphereRawValue] else { return cell }
            guard let sphere = Sphere(rawValue: sphereRawValue) else { return cell }
            
            let sphereValue = SphereValue(sphere: sphere, value: value)
            cell.fillCell(from: sphereValue)
            
            return cell
            
        case achievementsTableView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: achievementsReuseCellIdentifier, for: indexPath) as! AchievementsTableViewCell

            let achievement = achievements[indexPath.row]
            cell.fillCell(from: achievement)
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
}
