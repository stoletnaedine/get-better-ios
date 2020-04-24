//
//  CircleController.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 22.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Charts

class LifeCircleController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var chartView: RadarChartView!
    @IBOutlet weak var detailsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Properties.TabBar.lifeCircleTitle
        setupSegmentedControl()
        setupChartView()
    }
    
    func setupChartView() {
        
        // 2
        chartView.webLineWidth = 1.5
        chartView.innerWebLineWidth = 1.5
        chartView.webColor = .lightGray
        chartView.innerWebColor = .lightGray
        
        
        chartView.rotationEnabled = false
        chartView.legend.enabled = false
        
        let sphereValues = [6.0, 10.0, 4.0, 6.0, 9.0, 8.0, 6.0, 4.0]
        let sphereValues2 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        var dataEntries: [RadarChartDataEntry] = []
        var dataEntries2: [RadarChartDataEntry] = []
        
        for i in 0..<sphereValues.count {
            dataEntries.append(RadarChartDataEntry(value: sphereValues[i]))
            dataEntries2.append(RadarChartDataEntry(value: sphereValues2[i]))
        }
        
        let dataSet = RadarChartDataSet(entries: dataEntries, label: "Текущий уровень")
        let dataSet2 = RadarChartDataSet(entries: dataEntries2, label: "Текущий уровень")
        let data = RadarChartData(dataSets: [dataSet, dataSet2])
        
        dataSet.lineWidth = 3
        
        let redColor = UIColor(red: 247/255, green: 67/255, blue: 115/255, alpha: 1)
        let redFillColor = UIColor(red: 247/255, green: 67/255, blue: 115/255, alpha: 0.6)
        dataSet.colors = [redColor]
        dataSet.fillColor = redFillColor
        dataSet.drawFilledEnabled = true
        
        chartView.data = data
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
