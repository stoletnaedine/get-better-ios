//
//  LifeCircleViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Charts
import Toaster

class LifeCircleViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var chartView: RadarChartView!
    @IBOutlet weak var metricsTableView: UITableView!
    @IBOutlet weak var achievementsTableView: UITableView!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    
    let refreshControl = UIRefreshControl()
    let databaseService: DatabaseService = FirebaseDatabaseService()
    let viewModel = AchievementViewModel()
    
    var startSphereMetrics: SphereMetrics?
    var currentSphereMetrics: SphereMetrics?
    var posts: [Post] = []
    var achievements: [Achievement] = []
    let sphereMetricsXibName = R.nib.sphereMetricsTableViewCell.name
    let sphereMetricsReuseCellIdentifier = R.reuseIdentifier.sphereMetricsCell.identifier
    let achievementsXibName = R.nib.achievementsTableViewCell.name
    let achievementsReuseCellIdentifier = R.reuseIdentifier.achievementsCell.identifier
    let sphereIconSize: CGFloat = 30
    
    var setupSphereCompletion: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCircleLabels()
        setupSegmentedControl()
        setupTableViews()
        setupRefreshControl()
        loadAndShowData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAndShowData()
    }
    
    private func setupView() {
        title = R.string.localizable.tabBarLifeCircle()
        view.backgroundColor = .appBackground
        chartView.noDataText = R.string.localizable.lifeCircleLoading()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(loadAndShowData), for: .valueChanged)
        metricsTableView.addSubview(refreshControl)
    }
    
    @objc func loadAndShowData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            self?.databaseService.getSphereMetrics(from: GlobalDefiitions.SphereMetrics.start,
                                                   completion: { [weak self] result in
                switch result {
                case .success(let sphereMetrics):
                    self?.startSphereMetrics = sphereMetrics
                    dispatchGroup.leave()
                case .failure(_):
                    self?.setupSphereCompletion()
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            self?.databaseService.getSphereMetrics(from: GlobalDefiitions.SphereMetrics.current,
                                                   completion: { [weak self] result in
                switch result {
                case .success(let sphereMetrics):
                    self?.currentSphereMetrics = sphereMetrics
                    dispatchGroup.leave()
                case .failure(_):
                    self?.setupSphereCompletion()
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            self?.databaseService.getPosts(completion: { [weak self] result in
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    dispatchGroup.leave()
                case .failure(_):
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            if let startSphereMetrics = self?.startSphereMetrics,
                let currentSphereMetrics = self?.currentSphereMetrics,
                let posts = self?.posts,
                let achievements = self?.viewModel.getAchievements(posts: posts,
                                                                   startSphereMetrics: startSphereMetrics,
                                                                   currentSphereMetrics: currentSphereMetrics) {
                self?.achievements = achievements
            }
            self?.setupChartView()
            self?.metricsTableView.reloadData()
            self?.achievementsTableView.reloadData()
            self?.refreshControl.endRefreshing()
        })
    }
    
    func setupCircleLabels() {
        currentLabel.text = R.string.localizable.lifeCircleCurrent()
        currentLabel.font = UIFont.boldSystemFont(ofSize: 14)
        currentLabel.textColor = .lifeCircleLineCurrent
        startLabel.text = R.string.localizable.lifeCircleStart()
        startLabel.font = UIFont.boldSystemFont(ofSize: 14)
        startLabel.textColor = .lifeCircleLineStart
    }
    
    func setupChartView() {
        chartView.backgroundColor = .appBackground
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
        
        let dataSetStart = RadarChartDataSet(entries: dataEntriesStart, label: "")
        let dataSetCurrent = RadarChartDataSet(entries: dataEntriesCurrent, label: "")
        
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
        chartView.legend.enabled = false
    }
    
    func setupTableViews() {
        achievementsTableView.dataSource = self
        achievementsTableView.delegate = self
        achievementsTableView.register(UINib(nibName: achievementsXibName, bundle: nil),
                                       forCellReuseIdentifier: achievementsReuseCellIdentifier)
        achievementsTableView.backgroundColor = .appBackground
        achievementsTableView.separatorInset = UIEdgeInsets.zero
        
        metricsTableView.dataSource = self
        metricsTableView.delegate = self
        metricsTableView.register(UINib(nibName: sphereMetricsXibName, bundle: nil),
                                  forCellReuseIdentifier: sphereMetricsReuseCellIdentifier)
        metricsTableView.backgroundColor = .appBackground
        metricsTableView.separatorInset = UIEdgeInsets.zero
    }
    
    func setupSegmentedControl() {
        chartView.isHidden = false
        metricsTableView.isHidden = true
        achievementsTableView.isHidden = true
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.darkGray,
                                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)
        segmentedControl.setTitle(R.string.localizable.lifeCircleCircle(), forSegmentAt: 0)
        segmentedControl.setTitle(R.string.localizable.lifeCircleMetrics(), forSegmentAt: 1)
        segmentedControl.setTitle(R.string.localizable.lifeCircleAchievements(), forSegmentAt: 2)
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
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
//        let dataSetCurrentIndex = 1
//        if dataSetIndex == dataSetCurrentIndex {
//            return value.convertToRusString()
//        }
        return ""
    }
}

extension LifeCircleViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func getSphereValue(by indexPath: IndexPath) -> SphereValue? {
        
        let sphereValueDict = currentSphereMetrics?.sortedValues()[indexPath.row]
        let value = sphereValueDict?.value ?? 0
        let sphereRawValue = sphereValueDict?.key ?? ""
        guard let sphere = Sphere(rawValue: sphereRawValue) else { return nil }
        let sphereValue = SphereValue(sphere: sphere, value: value)
        
        return sphereValue
    }
    
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: sphereMetricsReuseCellIdentifier,
                                                     for: indexPath) as! SphereMetricsTableViewCell
            cell.selectionStyle = .default
            guard let sphereValue = getSphereValue(by: indexPath) else { return cell }
            cell.fillCell(from: sphereValue)
            
            return cell
            
        case achievementsTableView:
            
            let achievement = achievements[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: achievementsReuseCellIdentifier,
                                                     for: indexPath) as! AchievementsTableViewCell
            cell.selectionStyle = .none
            if !achievement.unlocked {
                cell.backgroundColor = .lighterGray
            }
            cell.fillCell(from: achievement)
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
            
        case metricsTableView:
            guard let sphereValue = getSphereValue(by: indexPath) else { return }
            let sphereDetailViewController = SphereDetailViewController()
            sphereDetailViewController.sphereValue = sphereValue
            present(sphereDetailViewController, animated: true, completion: nil)
            
        default:
            print("Error: Default case in didSelectRowAt method!")
        }
    }
}
