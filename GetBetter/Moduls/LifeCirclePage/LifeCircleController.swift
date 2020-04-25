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
    @IBOutlet weak var detailsView: HorizontalBarChartView!
    
    var sphereValuesIdeal = [10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0]
    var sphereMetrics: SphereMetrics?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.TabBar.lifeCircleTitle
        setupSegmentedControl()
        
        chartView.noDataText = Properties.LifeCircle.loading
        
        setDataCount(count: 8, range: 10)
        
        DatabaseService().getSphereMetrics(completion: { [weak self] result in
            switch result {
            case .success(let sphereMetrics):
                self?.sphereMetrics = sphereMetrics
                self?.setupChartView()
            case .failure(_):
                NotificationCenter.default.post(name: .showPageViewController, object: nil)
            }
        })
        
        chartView.isHidden = false
        detailsView.isHidden = true
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
    
    func setDataCount(count: Int, range: Double){
        
        let barWidth = 9.0
        let spaceForBar =  10.0;
        
        var yVals = [BarChartDataEntry]()
        
        for i in 0..<count{
            let mult = (range + 1)
            let val = (Double)(arc4random_uniform(UInt32(mult)))
            
            yVals.append(BarChartDataEntry(x: Double(i) * spaceForBar, y: val))
        }
        
        var set1 : BarChartDataSet!
        set1 = BarChartDataSet(entries: yVals, label: "DataSet")
        
        var dataSets = [BarChartDataSet]()
        dataSets.append(set1)
        
        let data = BarChartData(dataSets: dataSets)
        
        data.barWidth =  barWidth;
        
        detailsView.data = data
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
            detailsView.isHidden = true
        case 1:
            chartView.isHidden = true
            detailsView.isHidden = false
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
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        return ""
    }
}
