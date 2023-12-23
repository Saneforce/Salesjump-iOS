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

class Performance: UIViewController,ChartViewDelegate, UITableViewDelegate, UITableViewDataSource{
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
    @IBOutlet weak var Select_Ord: UILabel!
    @IBOutlet weak var SelectField: UILabel!
    @IBOutlet weak var TargetVal: UILabel!
    @IBOutlet weak var OrderVal: UILabel!
    @IBOutlet weak var OrdrTyp: UIView!
    
    @IBOutlet weak var Secondry_Oredr: UILabel!
    @IBOutlet weak var Primary_Ordr: UILabel!
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
        
        
        All_Field_Force.backgroundColor = .white
        All_Field_Force.layer.cornerRadius = 10.0
        All_Field_Force.layer.shadowColor = UIColor.gray.cgColor
        All_Field_Force.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        All_Field_Force.layer.shadowRadius = 3.0
        All_Field_Force.layer.shadowOpacity = 0.7
        // Do any additional setup after loading the view.
        // Set up the bar chart appearance
           Chart_View.backgroundColor = .white
           Chart_View.layer.cornerRadius = 10.0
           Chart_View.layer.shadowColor = UIColor.gray.cgColor
           Chart_View.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
           Chart_View.layer.shadowRadius = 3.0
           Chart_View.layer.shadowOpacity = 0.7

           // Call a function to set up and display data
        getUserDetails()
        Get_All_Field_Force()
        //manager_performance()
      //  setupBarChartData()
       
    }
    @objc func SecData(){
        Select_Ord.text = "Secondary"
        manager_performance(sec_or_pri:0)
        OrdrTyp.isHidden = true
    }
    
    @objc func PriData(){
        Select_Ord.text = "Primary"
        manager_performance(sec_or_pri:1)
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
        let id = Field_Force_data[indexPath.row].id
        SelectField.text = Field_Force_data[indexPath.row].Name
        
        if (id == ""){
            var totalOrderValue: Double = 0.0
            var totalTarget:Double = 0.0
               for achievement in Achieved_data {
                   if let orderValue = Double(achievement.Order_Value) {
                       totalOrderValue += orderValue
                   }
               }
            print(Target_Data)
            print(Achieved_data)
            for achievement in Target_Data {
                if let orderValue = Double(achievement.target_val) {
                    totalTarget += orderValue
                }
            }
            print(totalTarget)
            OrderVal.text = String(totalOrderValue)
            TargetVal.text = String(totalTarget)
           // String(format: "%.2f",Coverage)
            setupBarChartData(targetValues: Target_Data, achievementValues: Achieved_data)
        }else{
            print(id)
            print(Target_Data)
            let filteredData = Achieved_data.filter { $0.SF_Code == id }
            let Targetdata = Target_Data.filter{ $0.Sf_Code == id }
            print(filteredData)
            if let firstMatch = filteredData.first {
                let orderValue = firstMatch.Order_Value
                print("Order Value: \(orderValue)")
                OrderVal.text = orderValue
            } else {
                print("No match found for SF_Code = MR4126")
                OrderVal.text = "0.00"
            }
            
            if let targetMatch = Targetdata.first {
                let orderValue = targetMatch.target_val
                print("Order Value: \(orderValue)")
                TargetVal.text = orderValue
            } else {
                print("No match found for SF_Code = MR4126")
                TargetVal.text = "0.00"
            }
            setupBarChartData(targetValues: Target_Data, achievementValues: Achieved_data)

        }
        All_Field.isHidden = true
    }
    
    func setupBarChartData(targetValues: [Target], achievementValues: [Achieved]) {
        print(targetValues)
        print(achievementValues)
        var values: [BarChartDataEntry] = []
        for (index, target) in targetValues.enumerated(){
                var achievementValue: Double = 0.0
                if index < achievementValues.count {
                    achievementValue = Double(achievementValues[index].Order_Value) ?? 0.0
                }

                let targetEntry = BarChartDataEntry(x: Double(index), yValues: [Double(target.target_val) ?? 0.0, achievementValue])
                values.append(targetEntry)
            }
        
            if targetValues.isEmpty {
                let defaultEntry = BarChartDataEntry(x: 0.0, yValues: [0.0, 0.0])
                values.append(defaultEntry)
            }
        let dataSet1 = BarChartDataSet(entries: values, label: "Target & Achievement")
        dataSet1.stackLabels = ["Target", "Achievement"]
        dataSet1.colors = [NSUIColor.blue, NSUIColor.red]
        dataSet1.valueTextColor = NSUIColor.black
        dataSet1.drawValuesEnabled = false
        
        let dataSets: [ChartDataSet] = [dataSet1]

        let data = BarChartData(dataSets: dataSets)
        data.groupBars(fromX: 0.0, groupSpace: 0.2, barSpace: 0.1)

        Chart_View.data = data

        let xAxis = Chart_View.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: targetValues.map { $0.Sf_Code })

        xAxis.labelPosition = .bottom
        xAxis.labelCount = targetValues.count
        Chart_View.setVisibleXRangeMinimum(1.0)
        Chart_View.setVisibleXRangeMaximum(5.0)

        
        Chart_View.scaleXEnabled = true
        Chart_View.scaleYEnabled = true
        Chart_View.doubleTapToZoomEnabled = false
        Chart_View.dragEnabled = true

        
        let rightAxis = Chart_View.rightAxis
        rightAxis.enabled = false
    }





    func getUserDetails(){
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
    func Get_All_Field_Force(){
        Field_Force_data.removeAll()
        let apiKey1: String = "get/submgr&divisionCode=\(DivCode)&rSF=\(SFCode)&sfcode=\(SFCode)&stateCode=\(StateCode)&desig=\(Desig)"
        let apiKeyWithoutCommas = apiKey1.replacingOccurrences(of: ",&", with: "&")
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
                
            case .success(let value):
                print(value)
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
                            print(jsonArray)
                            for item in jsonArray{
                                Count = Count+1
                                let name = item["name"] as? String
                                let id = item["rtoSF"] as? String
                                let dsg = item["dsg"] as? String
                                let ID =  item["id"] as? String
                                 let Countdata = "E"+String(Count)
                                if (ID == SFCode){
                                    Field_Force_data.append(Field_Force(Name: name!, id: ID!, dsg: dsg!, Sf_id: Countdata))
                                }else if (id == SFCode){
                                    Field_Force_data.append(Field_Force(Name: name!, id: ID!, dsg: dsg!, Sf_id: Countdata))
                                }
                                
                            }
                            print(Field_Force_data)
                            Summary_Table.reloadData()
                            All_Field_table.reloadData()
                            manager_performance(sec_or_pri:0)
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
        let apiKey1: String = "get/manager_performance&date=\(formatters.string(from: Date()))&desig=\(Desig)&divisionCode=\(DivCode)&Type=ASM&rSF=\(SFCode)&sec_or_pri=\(sec_or_pri)&Div_code=\(DivCode)&sfcode=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
        let apiKeyWithoutCommas = apiKey1.replacingOccurrences(of: ",&", with: "&")
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
                
            case .success(let value):
                print(value)
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
                    if let TargetArray = prettyPrintedJson["Target"] as? [[String: Any]] {
                      print(TargetArray)
                        var Total_Target = 0.0
                        for item in TargetArray {
                            let orderValue = item["target_val"] as? String ?? "0.0"
                            let reportingCode = item["reporting_code"] as? String ?? ""
                            let sfCode = item["Sf_Code"] as? String ?? ""
                            print(orderValue)
                            
                            let Change_Double = Double(orderValue)
//                            if (sfCode == SFCode){
                                Total_Target = Total_Target + Change_Double!
                                Target_Data.append(Target(target_val: String(orderValue), Sf_Code: sfCode, reporting_code: reportingCode))
                                print(Target_Data)
//                            }else if (reportingCode == SFCode){
//                                Total_Target = Total_Target + Change_Double!
//                                Target_Data.append(Target(target_val: String(orderValue), Sf_Code: sfCode, reporting_code: reportingCode))
//                                }
                        }
                        TargetVal.text = String(Total_Target)
                    }
                    
                    if let achievedArray = prettyPrintedJson["Achieved"] as? [[String: Any]] {
                        var Totatal_Order = 0.0
                        for item in achievedArray {
                            let orderValue = item["order_value"] as? Double ?? 0.0
                            let reportingCode = item["reporting_code"] as? String ?? ""
                            let sfCode = item["Sf_Code"] as? String ?? ""
                            if (sfCode == SFCode){
                                Totatal_Order = Totatal_Order+orderValue
                                Achieved_data.append(Achieved(Order_Value: String(orderValue), Reporting_Code: reportingCode, SF_Code: sfCode))
                            }else if (reportingCode == SFCode){
                                Totatal_Order = Totatal_Order+orderValue
                                Achieved_data.append(Achieved(Order_Value: String(orderValue), Reporting_Code: reportingCode, SF_Code: sfCode))
                            }
                        }
                        OrderVal.text = String(Totatal_Order)
                    }
                    setupBarChartData(targetValues: Target_Data, achievementValues: Achieved_data)
                    SelectField.text = "ALL FIELD FORCE"
                    print(Achieved_data)
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    @objc func Viewopen(){
        All_Field.isHidden = false
    }
    @objc func OrderTyps(){
        OrdrTyp.isHidden = false
    }
    @IBAction func Close_BT(_ sender: Any) {
        All_Field.isHidden = true
    }
    @IBAction func CloseOredtyp(_ sender: Any) {
        OrdrTyp.isHidden = true
    }
    
}

