//
//  DAY REPORT WITH DATE RANGE CELL.swift
//  SAN SALES
//
//  Created by Anbu j on 22/10/24.
//

import UIKit
import Charts

// Delegate Protocol to Handle Navigation
protocol DayReportCellDelegate: AnyObject {
    func navigateToDetails(data:DAY_REPORT_WITH_DATE_RANGE.Day_Report_Detils?,id:String)
}


class DAY_REPORT_WITH_DATE_RANGE_CELL: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, ChartViewDelegate {
 
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Date: UILabel!
    
    @IBOutlet weak var Collection_View: UICollectionView!
    
    @IBOutlet weak var Collection_View_Two: UICollectionView!
    
    @IBOutlet weak var Chart_View: BarChartView!
 
    var data:[[String]] = []

    var  BraindList:[AnyObject]=[]
    
    var RangData: DAY_REPORT_WITH_DATE_RANGE.Day_Report_Detils?
    
    
    @IBOutlet weak var Total_lines: UILabel!
    
    @IBOutlet weak var Total_Pro_sol: UILabel!
    
    
    @IBOutlet weak var Total_lbl: UILabel!
    @IBOutlet weak var Effective_lbl: UILabel!
    
    
    // MARK: - Properties
     weak var delegate: DayReportCellDelegate?
    var Tc:Int = 0
    var PC:Int = 0
    
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
       // Chart_View.xAxis.enabled = false
        Chart_View.xAxis.drawLabelsEnabled = false
        
        Chart_View.noDataText = "You need to provide data for the chart."
        
        
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []  
        
        
        
        
        let dataEntry = BarChartDataEntry(x: Double(Tc), y: Double(Tc))
        dataEntries.append(dataEntry)
        let dataEntry1 = BarChartDataEntry(x: Double(PC), y: Double(PC))
        dataEntries1.append(dataEntry1)
        
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Total:\(Tc)")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Effective:\(PC)")
        
        let dataSetColors: [NSUIColor] = [
            NSUIColor(red: 0.06, green: 0.68, blue: 0.76, alpha: 1.00),
            NSUIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.00)
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
        
            return 1
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Collection_View_Two == collectionView{
            return BraindList.count
        }
            return data[section].count
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        if Collection_View == collectionView{
            cell.lblText.text = data[0][indexPath.row]
            cell.Test.text = data[1][indexPath.row]
            
            if data[0][indexPath.row] == "TC" || data[0][indexPath.row] == "PC" || data[0][indexPath.row] == "Pri Ord" {
                cell.lblText.text = data[0][indexPath.row]
                cell.Test.text = data[1][indexPath.row]
    
                let attributedText = NSAttributedString(string: cell.lblText?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                let attributedqty = NSAttributedString(string: cell.Test?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
                cell.lblText?.attributedText = attributedText
                cell.Test?.attributedText = attributedqty
            }else{
                // Set the text properties first
                cell.lblText.text = data[0][indexPath.row]
                cell.Test.text = data[1][indexPath.row]
                // Apply attributed text (font color in this case)
                let attributedText = NSAttributedString(string: cell.lblText?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                let attributedqty = NSAttributedString(string: cell.Test?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                cell.lblText?.attributedText = attributedText
                cell.Test?.attributedText = attributedqty
            }
        }else if Collection_View_Two == collectionView{
            let Item = BraindList[indexPath.row]
            print(Item)
            cell.lblText.text = Item["product_brd_name"] as? String ?? ""
            cell.Test.text =  String(Item["RetailCount"] as? Int ?? 0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Collection_View == collectionView{
         let item = data[0][indexPath.row]
            delegate?.navigateToDetails(data: RangData, id: item)
        }
    }
    
    
    func Reload(){
        if let datas = RangData{
            
            let Disamount:Double = Double(datas.Disamt)!
            
            if UserSetup.shared.Liters_Need == 1{
                
                
                
                if Disamount > 0{
                  
                    data = [
                        ["TC:", "PC:", "O. Value           ","Volumes  ", "Pri Ord", "Pri.Value"],
                        ["\(datas.Tc)","\(datas.pc)","\(datas.Order_Value)  ","\(datas.liters)  ","\(datas.Pri_Ord)","\(datas.Disamt)"]
                    ]
                }else{
                    data = [
                        ["TC:", "PC:", "O. Value           ","Volumes  ", "Pri Ord"],
                        ["\(datas.Tc)","\(datas.pc)","\(datas.Order_Value)  ","\(datas.liters)  ","\(datas.Pri_Ord)"]
                    ]
                    
                }
                
                
                
            }else{
                if Disamount > 0{
                    data = [
                        ["TC:", "PC:", "O. Value           ", "Pri Ord", "Pri.Value"],
                        ["\(datas.Tc)","\(datas.pc)","\(datas.Order_Value)  ","\(datas.Pri_Ord)","\(datas.Disamt)"]
                    ]
                }else{
                   
                    data = [
                        ["TC:", "PC:", "O. Value           ", "Pri Ord"],
                        ["\(datas.Tc)","\(datas.pc)","\(datas.Order_Value)  ","\(datas.Pri_Ord)"]
                    ]
                }
                
                
            }
            Tc = datas.Tc
            PC = datas.pc
        }
        Collection_View.reloadData()
        Collection_View_Two.reloadData()
        Chart_Data()
    }
}
