//
//  DAY REPORT WITH DATE RANGE CELL.swift
//  SAN SALES
//
//  Created by Anbu j on 22/10/24.
//

import UIKit
import Charts

class DAY_REPORT_WITH_DATE_RANGE_CELL: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, ChartViewDelegate {
 
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Date: UILabel!
    
    @IBOutlet weak var Collection_View: UICollectionView!
    
    @IBOutlet weak var Collection_View_Two: UICollectionView!
    
    @IBOutlet weak var Chart_View: BarChartView!
    
    
    let data = [
            ["TC:", "PC:", "O. Value", "Pri Ord", "Pri. Value"],
            ["1", "1", "   50.09  ", "0", "0"]
        ]
    
    let test1 =  ["TC:", "PC:", "O. Value", "Pri Ord", "Pri. Value", "PC:", "O. Value", "Pri Ord", "Pri. Value"]
    let test2 =  ["1", "1", "   50.09  ", "0", "0", "1", "50.09", "0", "0"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Chart_View.delegate = self
        Collection_View.dataSource = self
        Collection_View.delegate = self
        Collection_View_Two.dataSource = self
        Collection_View_Two.delegate = self
        
        Chart_Data()
    }
    
    func Chart_Data(){
        let legend = Chart_View.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;


        let xaxis = Chart_View.xAxis
        //xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true


        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1

        let yaxis = Chart_View.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = true

        Chart_View.rightAxis.enabled = false
        
        Chart_View.noDataText = "You need to provide data for the chart."
        
        
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []  
        
        let dataEntry = BarChartDataEntry(x: Double(10), y: Double(10))
        dataEntries.append(dataEntry)
        let dataEntry1 = BarChartDataEntry(x: Double(10), y: Double(10))
        dataEntries1.append(dataEntry1)
        
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Target")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Achievement")
        
        let dataSetColors: [NSUIColor] = [
            NSUIColor(red: 0.06, green: 0.68, blue: 0.76, alpha: 1.00),
            NSUIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
        ]
        
        let dataSets: [BarChartDataSet] = [chartDataSet, chartDataSet1]
        
        for (index, dataSet) in dataSets.enumerated() {
            dataSet.colors = [dataSetColors[index]]
        }
        
        let chartData = BarChartData(dataSets: dataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.2
        
        let groupCount = 1
        let startYear = 0
        
        chartData.barWidth = barWidth;
        Chart_View.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        Chart_View.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)

        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        Chart_View.notifyDataSetChanged()

        Chart_View.data = chartData

        Chart_View.backgroundColor = .white
        Chart_View.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
           Chart_View.setScaleEnabled(true)
           Chart_View.setVisibleXRangeMinimum(1)
           Chart_View.setVisibleXRangeMaximum(5)
           Chart_View.setScaleMinima(1.0, scaleY: 1.0)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if Collection_View_Two == collectionView{
            return 1
        }
        
            return data.count
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Collection_View_Two == collectionView{
            return test1.count
        }
            return data[section].count
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        if Collection_View == collectionView{
            cell.lblText.text = data[indexPath.section][indexPath.item]
        }else if Collection_View_Two == collectionView{
            cell.lblText.text = test1[indexPath.row]
            cell.Test.text = test2[indexPath.row]
        }
        return cell
    }
}
