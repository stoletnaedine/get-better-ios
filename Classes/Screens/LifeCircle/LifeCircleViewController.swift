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
    @IBOutlet weak var achievementsTableView: UITableView!
    @IBOutlet weak var currentLevelButton: UIButton!
    @IBOutlet weak var startLevelButton: UIButton!
    
    let refreshControl = UIRefreshControl()
    
    let achievementPresenter: AchievementPresenter = AchievementPresenterDefault()
    let lifeCirclePresenter: LifeCirclePresenter = LifeCirclePresenterDefault()
    
    var startSphereMetrics: SphereMetrics?
    var currentSphereMetrics: SphereMetrics?
    var posts: [Post] = []
    var achievements: [Achievement] = []
    let sphereMetricsXibName = R.nib.sphereMetricsTableViewCell.name
    let sphereMetricsReuseCellIdentifier = R.reuseIdentifier.sphereMetricsCell.identifier
    let achievementsXibName = R.nib.achievementsTableViewCell.name
    let achievementsReuseCellIdentifier = R.reuseIdentifier.achievementsCell.identifier
    let sphereIconSize: CGFloat = 30
    private let underlineAttribute: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
    
    private var isCurrentDataVisible = true
    private var isValuesVisible = false
    private var isCurrentButtonSelected = true
    
    var showOnboardingCompletion: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLevelButtons()
        setupSegmentedControl()
        setupTableViews()
        setupRefreshControl()
        setupTapChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAndShowData()
    }
    
    @IBAction func currentLevelButtonDidTap(_ sender: UIButton) {
        isCurrentDataVisible = true
        setupChartView(animate: false)
        if !isCurrentButtonSelected {
            isCurrentButtonSelected.toggle()
            currentLevelButton.isSelected.toggle()
            startLevelButton.isSelected.toggle()
        }
    }
    
    @IBAction func startLevelButtonDidTap(_ sender: UIButton) {
        isCurrentDataVisible = false
        setupChartView(animate: false)
        if isCurrentButtonSelected {
            isCurrentButtonSelected.toggle()
            currentLevelButton.isSelected.toggle()
            startLevelButton.isSelected.toggle()
        }
    }
    
    private func setupLevelButtons() {
        currentLevelButton.isSelected = isCurrentButtonSelected
        startLevelButton.isSelected = !isCurrentButtonSelected
        
        currentLevelButton.setTitle(R.string.localizable.lifeCircleCurrent(), for: .normal)
        currentLevelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        currentLevelButton.setTitleColor(.lifeCircleLineCurrent, for: .normal)
        currentLevelButton.setBackgroundColor(color: .violet, forState: .selected)
        
        startLevelButton.setTitle(R.string.localizable.lifeCircleStart(), for: .normal)
        startLevelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        startLevelButton.setTitleColor(.lifeCircleLineCurrent, for: .normal)
        startLevelButton.setBackgroundColor(color: .violet, forState: .selected)
    }
    
    private func setupTapChartView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showValues))
        chartView.addGestureRecognizer(tap)
    }
    
    @objc func showValues() {
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
        metricsTableView.addSubview(refreshControl)
    }
    
    @objc private func loadAndShowData() {
        lifeCirclePresenter.loadUserData(completion: { [weak self] (startSphereMetrics, currentSphereMetrics, posts) in
            guard let startSphereMetrics = startSphereMetrics else { return }
            guard let currentSphereMetrics = currentSphereMetrics else { return }
            self?.startSphereMetrics = startSphereMetrics
            self?.currentSphereMetrics = currentSphereMetrics
            self?.posts = posts
            if let achievements = self?.achievementPresenter.calcAchievements(
                posts: posts,
                startSphereMetrics: startSphereMetrics,
                currentSphereMetrics: currentSphereMetrics
                ) {
                self?.achievements = achievements
            }
            DispatchQueue.main.async { [weak self] in
                self?.reloadViews()
                self?.refreshControl.endRefreshing()
            }
        })
    }
    
    private func reloadViews() {
        setupChartView(animate: true)
        metricsTableView.reloadData()
        achievementsTableView.reloadData()
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
        xAxis.labelFont = .systemFont(ofSize: sphereIconSize)
        
        guard let startSphereMetrics = startSphereMetrics else { return }
        guard let currentSphereMetrics = currentSphereMetrics else { return }
        
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
    
    private func setupSegmentedControl() {
        chartView.isHidden = false
        metricsTableView.isHidden = true
        achievementsTableView.isHidden = true
        segmentedControl.setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor : UIColor.darkGray,
                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
                for: .normal
        )
        segmentedControl.tintColor = .violet
        segmentedControl.setTitle(R.string.localizable.lifeCircleCircle(), forSegmentAt: 0)
        segmentedControl.setTitle(R.string.localizable.lifeCircleMetrics(), forSegmentAt: 1)
        segmentedControl.setTitle(R.string.localizable.lifeCircleAchievements(), forSegmentAt: 2)
    }
    
    @IBAction func segmentedActionDidSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chartView.isHidden = false
            containerView.isHidden = false
            circleLegendView.isHidden = false
            metricsTableView.isHidden = true
            achievementsTableView.isHidden = true
        case 1:
            chartView.isHidden = true
            containerView.isHidden = true
            circleLegendView.isHidden = true
            metricsTableView.isHidden = false
            achievementsTableView.isHidden = true
        default:
            chartView.isHidden = true
            containerView.isHidden = true
            circleLegendView.isHidden = true
            metricsTableView.isHidden = true
            achievementsTableView.isHidden = false
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
            return value.stringWithComma()
        }
        if dataSetIndex == startDataSetIndex
            && !isCurrentDataVisible
            && isValuesVisible {
            return value.stringWithComma()
        }
        return ""
    }
}

extension LifeCircleViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func getSphereValue(index: Int) -> SphereValue? {
        let sphereValueDict = currentSphereMetrics?.sortedValues()[index]
        let sphereRawValue = sphereValueDict?.key ?? ""
        guard let sphere = Sphere(rawValue: sphereRawValue) else { return nil }
        let value = sphereValueDict?.value ?? 0
        return SphereValue(sphere: sphere, value: value)
    }
    
    private func commonMetricsCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .appBackground
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        cell.textLabel?.font = .journalDateFont
        
        let averageCurrentSphereValue = lifeCirclePresenter.averageCurrentSphereValue().stringWithComma()
        let averageCurrentSphereValueString = R.string.localizable.lifeCircleAverageCurrent(averageCurrentSphereValue)
        let averageStartSphereValue = lifeCirclePresenter.averageStartSphereValue().stringWithComma()
        let averageStartSphereValueString = R.string.localizable.lifeCircleAverageStart(averageStartSphereValue)
        
        let countPosts = posts.count
        // TODO: вынести в ресурсы
        let countPostsString = "\nЗаписей в дневнике: \(posts.count)"
        
        var mostPopularSphereString = ""
        var lessPopularSphereString = ""
        if countPosts > 3 {
            let spheres = posts.map { $0.sphere }
            let spheresDict = spheres.map { ($0, 1) }
            let spheresCount = Dictionary(spheresDict, uniquingKeysWith: +)
            
            let mostPopularSphere = spheresCount.max(by: { $0.value < $1.value })
            mostPopularSphereString = "\nБольше всего внимания ты уделяешь сфере \(mostPopularSphere?.key?.name ?? ""), записей: \(spheresCount[mostPopularSphere?.key] ?? 0)"
            
            let lessPopularSphere = spheresCount.max(by: { $0.value > $1.value })
            lessPopularSphereString = "\nМеньше всего записей в сфере \(lessPopularSphere?.key?.name ?? ""): \(spheresCount[lessPopularSphere?.key] ?? 0)"
        }
        cell.textLabel?.text = "\(averageStartSphereValueString)\n\(averageCurrentSphereValueString)\(countPostsString)\(mostPopularSphereString)\(lessPopularSphereString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case metricsTableView:
            if let rowsCount = currentSphereMetrics?.values.count {
                return rowsCount + 1 // Для ячейки индекс счастья
            } else {
                return 0
            }
        case achievementsTableView:
            return achievements.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case metricsTableView:
            if indexPath.row == 0 {
                return commonMetricsCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: sphereMetricsReuseCellIdentifier,
                                                     for: indexPath) as! SphereMetricsTableViewCell
            cell.selectionStyle = .none
             // indexPath.row - 1 для ячейки метрик
            guard let sphereValue = getSphereValue(index: indexPath.row - 1) else { return cell }
            cell.fillCell(from: sphereValue)
            return cell
        case achievementsTableView:
            let achievement = achievements[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: achievementsReuseCellIdentifier,
                                                     for: indexPath) as! AchievementsTableViewCell
            cell.selectionStyle = .none
            cell.fillCell(from: achievement)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case metricsTableView:
            if indexPath.row == 0 {
                return
            }
            // indexPath.row - 1 для ячейки индекс счастья
            guard let sphereValue = getSphereValue(index: indexPath.row - 1) else { return }
            let sphereDetailViewController = SphereDetailViewController()
            sphereDetailViewController.sphereValue = sphereValue
            present(sphereDetailViewController, animated: true, completion: nil)
        default:
            print("Not metricsTableView tapped in didSelectRowAt method!")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
