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
    @IBOutlet weak var detailsView: PieChartView!
    
    var sphereValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.TabBar.lifeCircleTitle
        setupSegmentedControl()
        setupChartView()
        
        DatabaseService().getSphereMetrics(completion: { [weak self] result in
            switch result {
            case .success(let sphereMetrics):
                self?.sphereValues = sphereMetrics.values.map { $0.value }
                self?.setupChartView()
            case .failure(_):
                NotificationCenter.default.post(name: .showPageViewController, object: nil)
            }
        })
        
        chartView.isHidden = false
        detailsView.isHidden = true
    }
    
    func setupChartView() {
        
        chartView.webLineWidth = 1.5
        chartView.innerWebLineWidth = 1.5
        chartView.webColor = .lightGray
        chartView.innerWebColor = .lightGray
        chartView.rotationEnabled = false
        chartView.legend.enabled = false
        
        var dataEntries: [RadarChartDataEntry] = []
        var dataEntries2: [RadarChartDataEntry] = []
        
        for i in 0..<sphereValues.count {
            dataEntries.append(RadarChartDataEntry(value: sphereValues[i]))
        }
        dataEntries2.append(RadarChartDataEntry(value: 0.0))
        
        let dataSet = RadarChartDataSet(entries: dataEntries, label: "Текущий уровень")
        let dataSet2 = RadarChartDataSet(entries: dataEntries2, label: "Текущий уровень")
        
        let data = RadarChartData(dataSets: [dataSet, dataSet2])
        
        dataSet.lineWidth = 4
        dataSet2.lineWidth = 0
        
        let redColor = UIColor(red: 247/255, green: 67/255, blue: 115/255, alpha: 1)
        let redFillColor = UIColor(red: 247/255, green: 67/255, blue: 115/255, alpha: 0.6)
        dataSet.colors = [redColor]
        dataSet.fillColor = redFillColor
        dataSet.drawFilledEnabled = true
        
        chartView.data = data
        chartView.webLineWidth = 0
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
