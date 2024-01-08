//
//  Performance.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//
import Alamofire
import UIKit
import Charts
struct Achieved:Codable{
    let Order_Value:String
    let Reporting_Code:String
    let SF_Code:String
}
struct Field_Force:Codable{
    let Name:String
    let id:String
    let dsg:String
    let Sf_id:String
}
struct Target:Codable{
    let target_val:String
    let Sf_Code:String
    let reporting_code:String
}

struct ChartName:Codable{
    var Target:String
    var Achievement:String
    let BarName:String
    let Id:String
}

class Performance: IViewController,ChartViewDelegate, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var OrderTyp: UIView!
    @IBOutlet weak var All_Field_Force: UIView!
    @IBOutlet weak var Chart_View: BarChartView!
    let LocalStoreage = UserDefaults.standard
    @IBOutlet weak var Summary_Table: UITableView!
    @IBOutlet weak var All_Field_table: UITableView!
    @IBOutlet weak var All_Field: UIView!
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    var OrderTys = ["Secondary","Primary"]
    var Achieved_data:[Achieved] = []
    var Field_Force_data:[Field_Force] = []
    var Target_Data:[Target] = []
    var lAllObjSel: [Field_Force] = []
    var BarsName:[ChartName] = []
    var lAllObjSelNmae: [ChartName] = []
    @IBOutlet weak var Select_Ord: UILabel!
    @IBOutlet weak var SelectField: UILabel!
    @IBOutlet weak var TargetVal: UILabel!
    @IBOutlet weak var OrderVal: UILabel!
    @IBOutlet weak var OrdrTyp: UIView!
    
    @IBOutlet weak var Secondry_Oredr: UILabel!
    @IBOutlet weak var Primary_Ordr: UILabel!
    @IBOutlet weak var Search: UIView!
    
    @IBOutlet weak var txSearchSel: UITextField!
    
    @IBOutlet weak var BalToDo: UILabel!
    @IBOutlet weak var Ache: UILabel!
    
    var VrfCount = 0
    var dsgMod:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Chart_View.delegate = self
        
        Summary_Table.delegate=self
        Summary_Table.dataSource=self
        
        All_Field_table.delegate=self
        All_Field_table.dataSource=self
        
        OrderTyp.addTarget(target: self, action: #selector(OrderTyps))
        All_Field_Force.addTarget(target: self, action: #selector(Viewopen))
        Secondry_Oredr.addTarget(target: self, action: #selector(SecData))
        Primary_Ordr.addTarget(target: self, action: #selector(PriData))
        
        OrderTyp.backgroundColor = .white
        OrderTyp.layer.cornerRadius = 10.0
        OrderTyp.layer.shadowColor = UIColor.gray.cgColor
        OrderTyp.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        OrderTyp.layer.shadowRadius = 3.0
        OrderTyp.layer.shadowOpacity = 0.7
        
        Search.backgroundColor = .white
        Search.layer.cornerRadius = 10.0
        Search.layer.shadowColor = UIColor.gray.cgColor
        Search.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Search.layer.shadowRadius = 3.0
        Search.layer.shadowOpacity = 0.5
        
        
        All_Field_Force.backgroundColor = .white
        All_Field_Force.layer.cornerRadius = 10.0
        All_Field_Force.layer.shadowColor = UIColor.gray.cgColor
        All_Field_Force.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        All_Field_Force.layer.shadowRadius = 3.0
        All_Field_Force.layer.shadowOpacity = 0.7
        // Do any additional setup after loading the view.
        // Set up the bar chart appearance
   
        getUserDetails()
        Get_All_Field_Force(Ored_Typ:0)
    }

    
    @objc func SecData(){
        Select_Ord.text = "Secondary"
        //manager_performance(sec_or_pri:0)
        Get_All_Field_Force(Ored_Typ: 0)
        OrdrTyp.isHidden = true
    }
    
    @objc func PriData(){
        Select_Ord.text = "Primary"
       //manager_performance(sec_or_pri:1)
        Get_All_Field_Force(Ored_Typ: 1)
        OrdrTyp.isHidden = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Summary_Table == tableView{
            return Field_Force_data.count
        }
        if All_Field_table == tableView {
            return Field_Force_data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if (Summary_Table == tableView) {
            if (Field_Force_data[indexPath.row].Sf_id == ""){
                cell.lblText?.text = ""
            }else{
                cell.lblText?.text = Field_Force_data[indexPath.row].Sf_id+"-"+Field_Force_data[indexPath.row].Name
            }
            
               // cell.lblText2?.text = Field_Force_data[indexPath.row].Sf_id+"-"+Field_Force_data[indexPath.row].Name
            
            return cell
        }
        if (All_Field_table == tableView){
            cell.lblText?.text = Field_Force_data[indexPath.row].Name
            return cell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (All_Field_table == tableView){
        let id = Field_Force_data[indexPath.row].id
        SelectField.text = Field_Force_data[indexPath.row].Name
        
        if (id == ""){
            
            print(lAllObjSelNmae)
            self.BarsName = lAllObjSelNmae
            print(BarsName)
            VrfCount = 0
            demoBar()
            self.BarsName = lAllObjSelNmae
            print(VrfCount)
            print(Target_Data)
            print(Achieved_data)
            var totalTargetValue: Double = 0.0
            var totalOrderValue: Double = 0.0
            
            // Calculate total target value
            for target in Target_Data {
                let targetValue = Double(target.target_val)!
                totalTargetValue = totalTargetValue + targetValue
            }
            
            // Calculate total achieved value
            for achieved in Achieved_data {
                let achievedValue = Double(achieved.Order_Value)!
                totalOrderValue = totalOrderValue + achievedValue
            }
            
            print("Total Target Value: \(totalTargetValue)")
            print("Total Achieved Value: \(totalOrderValue)")
            TargetVal.text = String(format:"%.2f",totalTargetValue)
            OrderVal.text = String(format:"%.2f",totalOrderValue)
            let bal = totalTargetValue  - totalOrderValue
            let Ach_Percent = totalOrderValue / totalTargetValue * 100
            if (bal < 0){
                BalToDo.text = "0.00"
            }else{
                BalToDo.text = String(format:"%.2f",bal)
            }
            if (Ach_Percent < 0){
                Ache.text = "0.00"
            }else if(Ach_Percent.isNaN){
                Ache.text = "0.00"
            }else if(Ach_Percent > bal){
                Ache.text = "100.00"
            }else{
                Ache.text = String(format:"%.2f",Ach_Percent)
            }
            print(BarsName)
        }else{
            VrfCount = 0
            self.BarsName = lAllObjSelNmae
            print(id)
            print(BarsName)
            print(Target_Data)
            print(Achieved_data)
            var filteredData: [Achieved]
            if (dsgMod == "ASM"){
                filteredData = Achieved_data.filter { $0.SF_Code == id }
            }else{
                filteredData = Achieved_data.filter { $0.Reporting_Code == id }
            }
            
            let Targetdata = Target_Data.filter{ $0.reporting_code == id }
            print(Targetdata)
            print(filteredData)
            var totalTargetValue: Double = 0.0
            var totalOrderValue: Double = 0.0
            if let firstMatch = filteredData.first {
                var Toatla_Order = 0.0
                for item in filteredData{
                    let individualTarget = Double(item.Order_Value) ?? 0.0
                    Toatla_Order += individualTarget
                }
                print(Toatla_Order)
                OrderVal.text = String(format:"%.2f",Toatla_Order)
                totalOrderValue = Toatla_Order
            } else {
                print("No match found for SF_Code = MR4126")
                OrderVal.text = "0.00"
                totalOrderValue = 0.0
            }
            
            if let targetMatch = Targetdata.first {
                var Toatla_Tar = 0.0
                for item in Targetdata{
                    let individualTarget = Double(item.target_val) ?? 0.0
                    Toatla_Tar += individualTarget
                }
                print(Toatla_Tar)
                
                TargetVal.text = String(format:"%.2f",Toatla_Tar)
                totalTargetValue = Toatla_Tar
            } else {
                print("No match found for SF_Code = MR4126")
                TargetVal.text = "0.00"
                totalTargetValue = 0.0
            }
            let bal = totalTargetValue  - totalOrderValue
            let Ach_Percent = totalOrderValue / totalTargetValue * 100
            if (bal < 0){
                BalToDo.text = "0.00"
            }else{
                BalToDo.text = String(format:"%.2f",bal)
            }
            
            if (Ach_Percent < 0){
                Ache.text = "0.00"
            }else if(Ach_Percent.isNaN) {
                Ache.text = "0.00"
            }else if(Ach_Percent > bal){
                Ache.text = "100.00"
            }else{
                Ache.text = String(format:"%.2f",Ach_Percent)
            }
            print(BarsName)
        }
        self.BarsName = BarsName.filter { $0.Id == id }
        demoBar()
        txSearchSel.text = ""
        All_Field.isHidden = true
    }
    }
    func demoBar() {
        
        //legend
        VrfCount = VrfCount+1
        print(VrfCount)
        print(BarsName)
        if (VrfCount == 2){
            self.BarsName = lAllObjSelNmae
        }
        if (VrfCount == 2){
            VrfCount = 0
        }
       print(BarsName)
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
        let values = self.BarsName.map { $0.BarName }
        xaxis.valueFormatter = IndexAxisValueFormatter(values: values)
        xaxis.granularity = 1


        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1

        let yaxis = Chart_View.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = true

        Chart_View.rightAxis.enabled = false
       //axisFormatDelegate = self
        
        Chart_View.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        print(dataEntries)
        for i in 0..<self.BarsName.count {
            print(i)
                 let dataEntry = BarChartDataEntry(x: Double(i), y: Double(self.BarsName[i].Target) ?? 0.0)
                 dataEntries.append(dataEntry)
                 let dataEntry1 = BarChartDataEntry(x: Double(i), y: Double(self.BarsName[i].Achievement) ?? 0.0)
                 dataEntries1.append(dataEntry1)
             }
        print(dataEntries)

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Target")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Achievement")

        let dataSetColors: [NSUIColor] = [
            NSUIColor(red: 0.06, green: 0.68, blue: 0.76, alpha: 1.00),
            NSUIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
        ]

        let dataSets: [BarChartDataSet] = [chartDataSet, chartDataSet1]
        print(dataSets)

        for (index, dataSet) in dataSets.enumerated() {
            dataSet.colors = [dataSetColors[index]]
        }
        //chartDataSet.colors = ChartColorTemplates.colorful()
        //let chartData = BarChartData(dataSet: chartDataSet)

        let chartData = BarChartData(dataSets: dataSets)


        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"

        let groupCount = self.BarsName.count
        let startYear = 0


        chartData.barWidth = barWidth;
        Chart_View.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        Chart_View.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)

        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        Chart_View.notifyDataSetChanged()

        Chart_View.data = chartData

        //background color
       // Chart_View.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        Chart_View.backgroundColor = .white

        //chart animation
        Chart_View.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
        // Enable zooming
           Chart_View.setScaleEnabled(true)
           
           // Set the minimum and maximum visible range on the x-axis
           Chart_View.setVisibleXRangeMinimum(1)  // Minimum number of bars visible at once
           Chart_View.setVisibleXRangeMaximum(5)  // Maximum number of bars visible at once

           // Limit the zoom out
           Chart_View.setScaleMinima(1.0, scaleY: 1.0)
        }
    

    func getUserDetails(){
        BarsName.removeAll()
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        StateCode = prettyJsonData["State_Code"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        Desig=prettyJsonData["desigCode"] as? String ?? ""
    }
    func Get_All_Field_Force(Ored_Typ:Int){
        BarsName.removeAll()
        Field_Force_data.removeAll()
        let apiKey1: String = "get/submgr&divisionCode=\(DivCode)&rSF=\(SFCode)&sfcode=\(SFCode)&stateCode=\(StateCode)&desig=\(Desig)"
        let apiKeyWithoutCommas = apiKey1.replacingOccurrences(of: ",&", with: "&")
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
                
            case .success(let value):
               // print(value)
                if let json = value as? [AnyObject]{
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    var Count = 0
                        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []),
                           let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
                            Field_Force_data.append(Field_Force(Name: "ALL FIELD FORCE", id: "", dsg: "", Sf_id: ""))
                           
                            for item in jsonArray{
                                Count = Count+1
                                let name = item["name"] as? String
                                let id = item["rtoSF"] as? String
                                let dsg = item["dsg"] as? String
                                let ID =  item["id"] as? String
                                 let Countdata = "E"+String(Count)
                                
                                if (ID == SFCode){
                                    dsgMod = dsg!
                                }
                                print(dsgMod)
                                if (dsgMod=="ASM"){
                        
                                if (ID == SFCode){
                                    Field_Force_data.append(Field_Force(Name: name!, id: ID!, dsg: dsg!, Sf_id: Countdata))
                                    BarsName.append(ChartName(Target: "", Achievement: "", BarName: "E\(Count)", Id: ID!))
                                }else if (id == SFCode){
                                    Field_Force_data.append(Field_Force(Name: name!, id: ID!, dsg: dsg!, Sf_id: Countdata))
                                    BarsName.append(ChartName(Target: "", Achievement: "", BarName: "E\(Count)", Id: ID!))
                                }
                                }else{
                                    let filteredData = jsonArray.filter { $0["rtoSF"] as? String == SFCode}
                                    print(filteredData)
                                    if let firstItem = filteredData.first, let idValue = firstItem["id"] as? String {
                                        print("ID: \(idValue)")
                                    } else {
                                        print("No exact matches found.")
                                    }
                                   
                                    if (ID == SFCode){
                                        Field_Force_data.append(Field_Force(Name: name!, id: ID!, dsg: dsg!, Sf_id: Countdata))
                                        BarsName.append(ChartName(Target: "", Achievement: "", BarName: "E\(Count)", Id: ID!))
                                    }else if (id == SFCode){
                                        Field_Force_data.append(Field_Force(Name: name!, id: ID!, dsg: dsg!, Sf_id: Countdata))
                                        BarsName.append(ChartName(Target: "", Achievement: "", BarName: "E\(Count)", Id: ID!))
                                    }
                                }
                            }
                           // print(Field_Force_data)
                            print(BarsName)
                            self.lAllObjSel = Field_Force_data
                            Summary_Table.reloadData()
                            All_Field_table.reloadData()
                            manager_performance(sec_or_pri:Ored_Typ)
                        }else{
                            print("Error: Unable to parse JSON")
                        }
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }

    
    func manager_performance(sec_or_pri:Int){
        Target_Data.removeAll()
        Achieved_data.removeAll()
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        let apiKey1: String = "get/manager_performance&date=\(formatters.string(from: Date()))&desig=\(Desig)&divisionCode=\(DivCode)&Type=\(dsgMod)&rSF=\(SFCode)&sec_or_pri=\(sec_or_pri)&Div_code=\(DivCode)&sfcode=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
        let apiKeyWithoutCommas = apiKey1.replacingOccurrences(of: ",&", with: "&")
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
                
            case .success(let value):
                if let json = value as? [String: Any] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = try? JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any] else {
                        print("Error: Could not parse JSON data")
                        return
                    }
                    
                    print(prettyPrintedJson)
                    
                    
                    var Total_Target = 0.0
                    var Totatal_Order = 0.0
                    if let TargetArray = prettyPrintedJson["Target"] as? [[String: Any]] {
                     
                        
                        for item in TargetArray {
                            let orderValue = item["target_val"] as? String ?? "0.0"
                            let reportingCode = item["reporting_code"] as? String ?? ""
                            let sfCode = item["Sf_Code"] as? String ?? ""
                           
                            
                            let Change_Double = Double(orderValue)
//                            if (sfCode == SFCode){
                                Total_Target = Total_Target + Change_Double!
                                Target_Data.append(Target(target_val: String(orderValue), Sf_Code: sfCode, reporting_code: reportingCode))
                                
//                            }else if (reportingCode == SFCode){
//                                Total_Target = Total_Target + Change_Double!
//                                Target_Data.append(Target(target_val: String(orderValue), Sf_Code: sfCode, reporting_code: reportingCode))
//                                }
                        }
                        TargetVal.text = String(format:"%.2f",Total_Target)
                    }
                    
                    if let achievedArray = prettyPrintedJson["Achieved"] as? [[String: Any]] {
                       
                        for item in achievedArray {
                            print(item)
                            let sfCode = item["Sf_Code"] as? String ?? ""
                            let orderValue = item["order_value"] as? Double ?? 0.0
                            let reportingCode = item["reporting_code"] as? String ?? ""
                          
                     
                            
                            if(dsgMod == "ASM" || dsgMod == "ZSM"){
                                if (sfCode == SFCode){
                                    Totatal_Order = Totatal_Order+orderValue
                                    Achieved_data.append(Achieved(Order_Value: String(orderValue), Reporting_Code: sfCode, SF_Code: sfCode))
                                }else if (reportingCode == SFCode){
                                    Totatal_Order = Totatal_Order+orderValue
                                    Achieved_data.append(Achieved(Order_Value: String(orderValue), Reporting_Code: reportingCode, SF_Code: sfCode))
                                }
                                
                            }else{
                                print(BarsName)
                                
                                for item in BarsName{
                                    let Iddata = item.Id
                                    print( SFCode)
                                    print( Iddata)
                                    if (sfCode == SFCode){
                                        Totatal_Order = Totatal_Order+orderValue
                                        Achieved_data.append(Achieved(Order_Value: String(orderValue), Reporting_Code: sfCode, SF_Code: sfCode))
                                    }else if (reportingCode == Iddata){
                                        Totatal_Order = Totatal_Order+orderValue
                                        Achieved_data.append(Achieved(Order_Value: String(orderValue), Reporting_Code: Iddata, SF_Code: Iddata))
                                    }
                                }
                            }
                            
                        }
                        print(Achieved_data)
                        print(SFCode)
                        OrderVal.text = String(format:"%.2f",Totatal_Order)
                    }
                    let bal = Total_Target  - Totatal_Order
                    let Ach_Percent = Totatal_Order / Total_Target * 100
                    if (bal < 0){
                        BalToDo.text = "0.00"
                    }else{
                        BalToDo.text = String(format:"%.2f",bal)
                    }
                    if (Ach_Percent < 0){
                        Ache.text = "0.00"
                    }else if(Ach_Percent.isNaN){
                        Ache.text = "0.00"
                    }else if(Ach_Percent > bal){
                        Ache.text = "100.00"
                    }else{
                        Ache.text = String(format:"%.2f",Ach_Percent)
                    }
                    
                    SelectField.text = "ALL FIELD FORCE"
               
                    for index in BarsName.indices {
                        if (dsgMod == "ASM"){
                            if SFCode == BarsName[index].Id {
                                if let achievedEntry = Achieved_data.first(where: { $0.SF_Code == SFCode }) {
                                    let filteredTargets = Achieved_data.filter { $0.SF_Code == SFCode}
                                    var Total_Achieved = 0.0
                                    for filterdata in filteredTargets{
                                        let individualTarget = Double(filterdata.Order_Value) ?? 0.0
                                        Total_Achieved += individualTarget
                                    }
                                    BarsName[index].Achievement = String(format: "%.2f", Total_Achieved)
                                    print("Total")
                                } else {
                                    BarsName[index].Achievement = "0.0"
                                }
                            }else{
                                if let achievedEntry = Achieved_data.first(where: { $0.SF_Code == BarsName[index].Id }) {
                                    let filteredTargets = Achieved_data.filter { $0.SF_Code == BarsName[index].Id}
                                    var Total_Achieved = 0.0
                                    for filterdata in filteredTargets{
                                        let individualTarget = Double(filterdata.Order_Value) ?? 0.0
                                        Total_Achieved += individualTarget
                                    }
                                    BarsName[index].Achievement = String(format: "%.2f", Total_Achieved)
                                } else {
                                    BarsName[index].Achievement = "0.0"
                                }
                            }
                        }else{
                            if SFCode == BarsName[index].Id {
                                if let achievedEntry = Achieved_data.first(where: { $0.Reporting_Code == SFCode }) {
                                    let filteredTargets = Achieved_data.filter { $0.Reporting_Code == SFCode}
                                    var Total_Achieved = 0.0
                                    for filterdata in filteredTargets{
                                        let individualTarget = Double(filterdata.Order_Value) ?? 0.0
                                        Total_Achieved += individualTarget
                                    }
                                    BarsName[index].Achievement = String(format: "%.2f", Total_Achieved)
                                    print("Total")
                                } else {
                                    BarsName[index].Achievement = "0.0"
                                }
                            }else{
                                if let achievedEntry = Achieved_data.first(where: { $0.Reporting_Code == BarsName[index].Id }) {
                                    let filteredTargets = Achieved_data.filter { $0.Reporting_Code == BarsName[index].Id}
                                    var Total_Achieved = 0.0
                                    for filterdata in filteredTargets{
                                        let individualTarget = Double(filterdata.Order_Value) ?? 0.0
                                        Total_Achieved += individualTarget
                                    }
                                    BarsName[index].Achievement = String(format: "%.2f", Total_Achieved)
                                } else {
                                    BarsName[index].Achievement = "0.0"
                                }
                            }
                        }
                    }

                    print(Achieved_data)
                    for index in BarsName.indices {
                        if SFCode == BarsName[index].Id {
                            if let targetEntry = Target_Data.first(where: { $0.reporting_code == SFCode }) {
                                print(targetEntry)
                                let filteredTargets = Target_Data.filter { $0.reporting_code == SFCode}
                                var Total_Target = 0.0
                                for filterdata in filteredTargets{
                                    let individualTarget = Double(filterdata.target_val) ?? 0.0
                                    Total_Target += individualTarget
                                }
                              
                                BarsName[index].Target = String(format: "%.2f", Total_Target)
                            } else {
                                BarsName[index].Target = "0.0"
                            }
                        } else {
                          
                            if let targetEntry = Target_Data.first(where: { $0.reporting_code == BarsName[index].Id }) {
                                let filteredTargets = Target_Data.filter { $0.reporting_code == BarsName[index].Id}
                                var Total_Target = 0.0
                                for filterdata in filteredTargets{
                                    let individualTarget = Double(filterdata.target_val) ?? 0.0
                                    Total_Target += individualTarget
                                }
                              
                                BarsName[index].Target = String(format: "%.2f", Total_Target)
                            } else {
                                BarsName[index].Target = "0.0"
                            }
                        }
                    }
                    

                    for barsName in BarsName {
                        print(barsName)
                    }
                    print(BarsName)
                    self.lAllObjSelNmae = BarsName
                    demoBar()
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    @objc func Viewopen(){
        Field_Force_data = lAllObjSel
        All_Field_table.reloadData()
        All_Field.isHidden = false
    }
    @objc func OrderTyps(){
        OrdrTyp.isHidden = false
    }
    @IBAction func Close_BT(_ sender: Any) {
        txSearchSel.text = ""
        All_Field.isHidden = true
    }
    @IBAction func CloseOredtyp(_ sender: Any) {
        OrdrTyp.isHidden = true
    }
    
    
    @IBAction func searchBytext(_ sender: Any) {
        
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            Field_Force_data = lAllObjSel
        }else{
            Field_Force_data = lAllObjSel.filter({(product) in
                let name: String = product.Name
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        All_Field_table.reloadData()
    }
    }
    
