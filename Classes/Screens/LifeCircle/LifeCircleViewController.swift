//
//  LifeCircleViewController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Charts

class LifeCircleViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chartView: RadarChartView!
    @IBOutlet weak var circleLegendView: UIView!
    @IBOutlet weak var metricsTableView: UITableView!
    @IBOutlet weak var currentLevelButton: UIButton!
    @IBOutlet weak var startLevelButton: UIButton!
    @IBOutlet weak var currentLevelView: UIView!
    @IBOutlet weak var startLevelView: UIView!
    
    private enum Constants {
        static let sphereIconSize: CGFloat = 30
    }
    
    private let refreshControl = UIRefreshControl()
    private let lifeCircleService: LifeCircleServiceProtocol = LifeCircleService()
    private let database: DatabaseProtocol = FirebaseDatabase()
    private let alertService: AlertServiceProtocol = AlertService()
    private var userDefaultsService: UserSettingsServiceProtocol = UserSettingsService()
    private let tipStorage = TipStorage()
    private var userData: UserData?
    private var isCurrentDataVisible = true
    private var isValuesVisible = false
    private var isCurrentButtonSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLevelButtons()
        setupSegmentedControl()
        setupTableViews()
        setupRefreshControl()
        setupChartViewTap()
        setupBarButton()
        loadAndShowData(animate: true)
        if !userDefaultsService.tipOfTheDayHasShown {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                guard let self = self else { return }
                self.showTipOfTheDay()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAndShowData(animate: false)
    }
    
    @IBAction func currentLevelButtonDidTap(_ sender: UIButton) {
        isCurrentDataVisible = true
        setupChartView(animate: false)
        
        startLevelView.backgroundColor = .white
        startLevelButton.setTitleColor(.violet, for: .normal)
        currentLevelView.backgroundColor = .violet
        currentLevelButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func startLevelButtonDidTap(_ sender: UIButton) {
        isCurrentDataVisible = false
        setupChartView(animate: false)
        
        startLevelView.backgroundColor = .violet
        startLevelButton.setTitleColor(.white, for: .normal)
        currentLevelView.backgroundColor = .white
        currentLevelButton.setTitleColor(.violet, for: .normal)
    }
    
    private func setupLevelButtons() {
        currentLevelButton.setTitle(R.string.localizable.lifeCircleCurrent(), for: .normal)
        currentLevelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        currentLevelButton.setTitleColor(.white, for: .normal)
        currentLevelView.layer.cornerRadius = 8
        currentLevelView.backgroundColor = .violet
        
        startLevelButton.setTitle(R.string.localizable.lifeCircleStart(), for: .normal)
        startLevelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        startLevelButton.setTitleColor(.violet, for: .normal)
        startLevelView.layer.cornerRadius = 8
        startLevelView.backgroundColor = .white
    }
    
    @objc func showTipOfTheDay() {
        let tipEntityOfTheDay = tipStorage.currentTip
        
        let tipVC = TipViewController()
        tipVC.modalPresentationStyle = .overFullScreen
        tipVC.tipEntity = tipEntityOfTheDay
        present(tipVC, animated: true, completion: nil)
        userDefaultsService.tipOfTheDayHasShown = true
    }
    
    private func setupBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: R.string.localizable.journalTipOfTheDay(),
            style: .plain,
            target: self,
            action: #selector(showTipOfTheDay))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: R.image.info(),
            style: .plain,
            target: self,
            action: #selector(showLifeCircleTutorial))
    }

    @objc private func showLifeCircleTutorial() {
        let vc = ArticleViewController()
        var exampleImage: UIImage?
        switch Locale.current.languageCode {
        case "ru":
            exampleImage = R.image.lifeCircleExampleRus()
        default:
            exampleImage = R.image.lifeCircleExampleEng()
        }
        vc.article = Article(
            title: R.string.localizable.aboutCircleTitle(),
            text: R.string.localizable.aboutCircleDescription(),
            image: exampleImage)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupChartViewTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showValues))
        chartView.addGestureRecognizer(tap)
    }
    
    @objc private func showValues() {
        isValuesVisible.toggle()
        setupChartView(animate: false)
    }
    
    private func setupView() {
        title = R.string.localizable.tabBarLifeCircle()
        view.backgroundColor = .appBackground
        chartView.noDataText = R.string.localizable.lifeCircleLoading()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(loadAndShowData), for: .valueChanged)
        metricsTableView.refreshControl = refreshControl
    }
    
    @objc private func loadAndShowData(animate: Bool = false) {
        lifeCircleService.loadUserData(completion: { [weak self] userData in
            guard let self = self,
                  let userData = userData else { return }
            self.userData = userData
            
            DispatchQueue.main.async { [weak self] in
                self?.reloadViews(animate: animate)
                self?.refreshControl.endRefreshing()
            }
        })
    }
    
    private func reloadViews(animate: Bool) {
        setupChartView(animate: animate)
        metricsTableView.reloadData()
    }
    
    private func setupChartView(animate: Bool) {
        chartView.backgroundColor = .appBackground
        chartView.webLineWidth = 2
        chartView.innerWebLineWidth = 2
        chartView.webColor = .lifeCircleLineBack
        chartView.innerWebColor = .lifeCircleLineBack
        chartView.legend.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 9
        xAxis.labelFont = .systemFont(ofSize: Constants.sphereIconSize)
        
        guard let startSphereMetrics = userData?.start else { return }
        guard let currentSphereMetrics = userData?.current else { return }
        
        let titles = startSphereMetrics.sortedValues()
            .map { Sphere(rawValue: $0.key)?.icon ?? "" }
        xAxis.valueFormatter = XAxisFormatter(titles: titles)
        
        let yAxis = chartView.yAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 9
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.enabled = false

        let dataEntriesStart = startSphereMetrics.sortedValues()
            .map { RadarChartDataEntry(value: $0.value) }
        let dataEntriesCurrent = currentSphereMetrics.sortedValues()
            .map { RadarChartDataEntry(value: $0.value) }
        
        let dataSetStart = RadarChartDataSet(entries: dataEntriesStart, label: "")
        dataSetStart.lineWidth = 2
        dataSetStart.colors = [.lifeCircleLineStart]
        dataSetStart.valueFormatter = DataSetValueFormatter(isCurrentDataVisible: isCurrentDataVisible,
                                                            isValuesVisible: isValuesVisible)
        
        let dataSetCurrent = RadarChartDataSet(entries: dataEntriesCurrent, label: "")
        dataSetCurrent.visible = isCurrentDataVisible
        dataSetCurrent.lineWidth = 2
        dataSetCurrent.colors = [.lifeCircleLineCurrent]
        dataSetCurrent.fillColor = .lifeCircleFillCurrent
        dataSetCurrent.fillAlpha = 0.5
        dataSetCurrent.drawFilledEnabled = true
        dataSetCurrent.valueFormatter = DataSetValueFormatter(isCurrentDataVisible: isCurrentDataVisible,
                                                              isValuesVisible: isValuesVisible)
        
        chartView.data = RadarChartData(dataSets: [dataSetStart, dataSetCurrent])
        
        if animate {
            chartView.animate(xAxisDuration: 0.8, easingOption: .easeInOutQuad)
        }
    }
    
    private func setupTableViews() {
        metricsTableView.dataSource = self
        metricsTableView.delegate = self
        metricsTableView.register(R.nib.sphereMetricsTableViewCell)
        metricsTableView.register(R.nib.commonMetricsTableViewCell)
        metricsTableView.backgroundColor = .appBackground
        metricsTableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func setupSegmentedControl() {
        chartView.isHidden = false
        metricsTableView.isHidden = true
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor : UIColor.darkGray,
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
            for: .normal
        )
        segmentedControl.tintColor = .violet
        segmentedControl.setTitle(R.string.localizable.lifeCircleCircle(), forSegmentAt: 0)
        segmentedControl.setTitle(R.string.localizable.lifeCircleMetrics(), forSegmentAt: 1)
    }
    
    @IBAction func segmentedActionDidSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chartView.isHidden = false
            containerView.isHidden = false
            circleLegendView.isHidden = false
            metricsTableView.isHidden = true
        case 1:
            chartView.isHidden = true
            containerView.isHidden = true
            circleLegendView.isHidden = true
            metricsTableView.isHidden = false
        default:
            chartView.isHidden = true
            containerView.isHidden = true
            circleLegendView.isHidden = true
            metricsTableView.isHidden = true
        }
    }
}

class XAxisFormatter: IAxisValueFormatter {
    private let titles: [String]
    
    init(titles: [String]) {
        self.titles = titles
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return titles[Int(value) % titles.count]
    }
}

class DataSetValueFormatter: IValueFormatter {
    private var isCurrentDataVisible: Bool
    private var isValuesVisible: Bool
    
    init(isCurrentDataVisible: Bool, isValuesVisible: Bool) {
        self.isCurrentDataVisible = isCurrentDataVisible
        self.isValuesVisible = isValuesVisible
    }
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let startDataSetIndex = 0
        let currentDataSetIndex = 1
        if dataSetIndex == currentDataSetIndex
            && isCurrentDataVisible
            && isValuesVisible {
            return value.toString()
        }
        if dataSetIndex == startDataSetIndex
            && !isCurrentDataVisible
            && isValuesVisible {
            return value.toString()
        }
        return ""
    }
}

extension LifeCircleViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func getSphereValue(index: Int) -> SphereValue? {
        let sphereValueDict = userData?.current?.sortedValues()[index]
        let sphereRawValue = sphereValueDict?.key ?? ""
        guard let sphere = Sphere(rawValue: sphereRawValue) else { return nil }
        let value = sphereValueDict?.value ?? 0
        return SphereValue(sphere: sphere, value: value)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowsCount = userData?.current?.values.count {
            return rowsCount + 1 // Для ячейки Common Metrics
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0,
           let cell = tableView.dequeueReusableCell(
            withIdentifier: R.nib.commonMetricsTableViewCell.identifier,
            for: indexPath) as? CommonMetricsTableViewCell {
            let average = lifeCircleService.averageCurrentSphereValue()
            let daysFromUserCreation = lifeCircleService.daysFromUserCreation()
            cell.fillCell(viewModel: CommonMetricsViewModel(posts: userData?.posts.count ?? .zero,
                                                            average: average,
                                                            days: daysFromUserCreation))
            return cell
        }
        
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: R.nib.sphereMetricsTableViewCell.identifier,
            for: indexPath) as? SphereMetricsTableViewCell {
            // indexPath.row - 1 для ячейки Common Metrics
            let sphereIndex = indexPath.row - 1
            guard let sphereValue = getSphereValue(index: sphereIndex) else { return cell }
            cell.configure(from: sphereValue)
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return }
        // indexPath.row - 1 для ячейки Common Metrics
        let sphereIndex = indexPath.row - 1
        guard let sphereValue = getSphereValue(index: sphereIndex) else { return }
        let sphereDetailViewController = SphereDetailViewController()
        sphereDetailViewController.sphereValue = sphereValue
        sphereDetailViewController.userData = userData
        present(sphereDetailViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
