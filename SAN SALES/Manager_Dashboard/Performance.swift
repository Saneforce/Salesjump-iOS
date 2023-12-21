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
  
    @IBOutlet weak var TargetVal: UILabel!
    @IBOutlet weak var OrderVal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Chart_View.delegate = self
        
        Summary_Table.delegate=self
        Summary_Table.dataSource=self
        
        All_Field_table.delegate=self
        All_Field_table.dataSource=self
        
        OrderTyp.addTarget(target: self, action: #selector(Viewopen))
        All_Field_Force.addTarget(target: self, action: #selector(Viewopen))
        
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
        manager_performance()
        setupBarChartData()
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Summary_Table == tableView{
            return 10
        }
        if All_Field_table == tableView {
            return Field_Force_data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if (Summary_Table == tableView) {
            
            cell.lblText?.text = "test"
            cell.lblText2?.text = "test 2"
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
        if (id == ""){
            var totalOrderValue: Double = 0.0
            var totalTarget:Double = 0.0
               for achievement in Achieved_data {
                   if let orderValue = Double(achievement.Order_Value) {
                       totalOrderValue += orderValue
                   }
               }
            for achievement in Target_Data {
                if let orderValue = Double(achievement.target_val) {
                    totalTarget += orderValue
                }
            }
            OrderVal.text = String(totalOrderValue)
            TargetVal.text = String(totalTarget)
           // String(format: "%.2f",Coverage)
        }else{
            
        }
        
    }
    
    func setupBarChartData() {
        let values: [BarChartDataEntry] = [
            BarChartDataEntry(x: 0.0, yValues: [30.0, 0.0]), // Target bar
            BarChartDataEntry(x: 0.2, yValues: [0.0, 40.0]), // Achievement bar
            BarChartDataEntry(x: 5.0, yValues: [40.0, 0.0]),
            BarChartDataEntry(x: 5.2, yValues: [0.0, 60.0]),
            BarChartDataEntry(x: 10.0, yValues: [20.0, 0.0]),
            BarChartDataEntry(x: 10.2, yValues: [0.0, 30.0]),
            BarChartDataEntry(x: 15.0, yValues: [20.0, 0.0]),
            BarChartDataEntry(x: 15.2, yValues: [0.0, 25.0]),
            BarChartDataEntry(x: 20.0, yValues: [20.0, 0.0]),
            BarChartDataEntry(x: 20.2, yValues: [0.0, 22.0]),
            BarChartDataEntry(x: 25.0, yValues: [20.0, 0.0]),
            BarChartDataEntry(x: 25.2, yValues: [0.0, 18.0]),
            BarChartDataEntry(x: 30.0, yValues: [20.0, 0.0]),
            BarChartDataEntry(x: 30.2, yValues: [0.0, 15.0]),
            BarChartDataEntry(x: 35.0, yValues: [25000.0, 0.0]), // Target bar
            BarChartDataEntry(x: 35.2, yValues: [0.0, 22000.0]), // Achievement bar
            // Add more entries as needed
        ]

        // Create data sets with the data values and labels
        let dataSet1 = BarChartDataSet(entries: values, label: "Target & Achievement")
        dataSet1.stackLabels = ["Target", "Achievement"]
        dataSet1.colors = [NSUIColor.blue, NSUIColor.red]
        dataSet1.valueTextColor = NSUIColor.black

        // Create an array of data sets
        let dataSets: [ChartDataSet] = [dataSet1]

        // Create a data object with the array of data sets
        let data = BarChartData(dataSets: dataSets)

        // Set data to the chart view
        Chart_View.data = data
        
        // Customize x-axis values
        let xAxis = Chart_View.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: ["0", "5", "10", "15", "20", "25", "30", "35"])
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
                   
                        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []),
                           let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
                            Field_Force_data.append(Field_Force(Name: "ALL FIELD FORCE", id: "", dsg: ""))
                            for item in jsonArray{
                                let name = item["name"] as? String
                                let id = item["rtoSF"] as? String
                                let dsg = item["dsg"] as? String
                                Field_Force_data.append(Field_Force(Name: name!, id: id!, dsg: dsg!))
                            }
                            
                            All_Field_table.reloadData()
                        }else{
                            print("Error: Unable to parse JSON")
                        }
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }

    
    func manager_performance(){
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        let apiKey1: String = "get/manager_performance&date=\(formatters.string(from: Date()))&desig=\(Desig)&divisionCode=\(DivCode)&Type=ASM&rSF=\(SFCode)&sec_or_pri=0&Div_code=\(DivCode)&sfcode=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
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
                    if let achievedArray = prettyPrintedJson["Target"] as? [[String: Any]] {
                      
                        for item in achievedArray {
                            let orderValue = item["target_val"] as? Double ?? 0.0
                            let reportingCode = item["reporting_code"] as? String ?? ""
                            let sfCode = item["Sf_Code"] as? String ?? ""
                            Target_Data.append(Target(target_val: String(orderValue), Sf_Code: sfCode, reporting_code: reportingCode))
                        }
                    }
                    
                    if let achievedArray = prettyPrintedJson["Achieved"] as? [[String: Any]] {
                      
                        for item in achievedArray {
                            let orderValue = item["order_value"] as? Double ?? 0.0
                            let reportingCode = item["reporting_code"] as? String ?? ""
                            let sfCode = item["Sf_Code"] as? String ?? ""
                            Achieved_data.append(Achieved(Order_Value: String(orderValue), Reporting_Code: reportingCode, SF_Code: sfCode))
                        }
                    }
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
    @IBAction func Close_BT(_ sender: Any) {
        All_Field.isHidden = true
    }
}
