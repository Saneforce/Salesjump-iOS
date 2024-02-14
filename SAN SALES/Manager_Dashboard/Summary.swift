//
//  Summary.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//

import UIKit
import Alamofire
import FSCalendar
struct sfDetails: Codable {
    let id: String
    let name: String
}
class Summary: IViewController,FSCalendarDelegate,FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Date_View: UIView!
    @IBOutlet weak var Date_lbl: UILabel!
    @IBOutlet weak var All_Filed: UIView!
    @IBOutlet weak var Cal_View: UIView!
    @IBOutlet weak var Calendar: FSCalendar!
    @IBOutlet weak var All_Field_View: UIView!
    @IBOutlet weak var Search: UIView!
    @IBOutlet weak var All_Filed_Name: UITableView!
    @IBOutlet weak var Total_Outlets: UILabel!
    @IBOutlet weak var Total_Calls: UILabel!
    @IBOutlet weak var Productive_Calls: UILabel!
    @IBOutlet weak var Primary_Call: UILabel!
    @IBOutlet weak var Secondary_Calls: UILabel!
    @IBOutlet weak var Productivity: UILabel!
    @IBOutlet weak var UPC: UILabel!
    @IBOutlet weak var Net_Weight: UILabel!
    @IBOutlet weak var Select_Field: UILabel!
    @IBOutlet weak var txSearchSel: UITextField!
    var SfData: [sfDetails] = []
    var lAllObjSel: [sfDetails] = []
    var targetId: String = ""
    var SelectDate : String = ""
    let LocalStoreage = UserDefaults.standard
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendar.delegate=self
        Calendar.dataSource=self
        
        All_Filed_Name.delegate=self
        All_Filed_Name.dataSource=self
        //Date_Card_View
        Date_View.backgroundColor = .white
        Date_View.layer.cornerRadius = 10.0
        Date_View.layer.shadowColor = UIColor.gray.cgColor
        Date_View.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Date_View.layer.shadowRadius = 3.0
        Date_View.layer.shadowOpacity = 0.7
        
        //All_Filed_Card_View
        All_Filed.backgroundColor = .white
        All_Filed.layer.cornerRadius = 10.0
        All_Filed.layer.shadowColor = UIColor.gray.cgColor
        All_Filed.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        All_Filed.layer.shadowRadius = 3.0
        All_Filed.layer.shadowOpacity = 0.7
        
        Search.backgroundColor = .white
        Search.layer.cornerRadius = 10.0
        Search.layer.shadowColor = UIColor.gray.cgColor
        Search.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Search.layer.shadowRadius = 3.0
        Search.layer.shadowOpacity = 0.5
        getUserDetails()
        Date_View.addTarget(target: self, action: #selector(dateView))
        All_Filed.addTarget(target: self, action: #selector(FiledData))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        Date_lbl.text = formatter.string(from: Date())
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        SelectDate = formatters.string(from: Date())
        Total_Team_Size_List(date: formatters.string(from: Date()))
        Get_All_Field_Force(Data: formatters.string(from: Date()))
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(SfData)
        return SfData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText?.text = SfData[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data =  SfData[indexPath.row].id
        targetId = data
        Select_Field.text = SfData[indexPath.row].name
        print(targetId)
        Get_All_Field_Force(Data: SelectDate)
        txSearchSel.text = ""
        All_Field_View.isHidden = true
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        let formatters = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatters.dateFormat = "yyyy-MM-dd"
        //print("did select date \(formatter.string(from: date))")
        print("did select date \(formatters.string(from: date))")
        let selectedDates = calendar.selectedDates.map({formatter.string(from: $0)})
        let selectedDates_Attendance = calendar.selectedDates.map({formatters.string(from: $0)})
        print("selected dates is \(selectedDates_Attendance)")
        if let firstDate = selectedDates_Attendance.first {
            print("Selected date outside the box: \(firstDate)")
            targetId = ""
            Select_Field.text = "All Field Force"
            Total_Team_Size_List(date: firstDate)
            Get_All_Field_Force(Data: firstDate)
            SelectDate = firstDate
        } else {
            print("No selected dates.")
        }
        Date_lbl.text = formatter.string(from: date)
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        Cal_View.isHidden = true
        
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
    
    func Get_All_Field_Force(Data:String){
        print(Data)
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        let apiKey1: String = "get/sfDetails&selected_date=\(Data)&sf_code=\(SFCode)&division_code=\(DivCode)"
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
                    if (targetId == ""){
                        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []),
                           let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
                            var All_Id = [String]()
                            for item in jsonArray {
                                if  let id = item["id"] as? String{
                                    All_Id.append(id)
                                    
                                }
                            }
                            print(All_Id)
                            let encodedData = All_Id.map { element in
                                return "%27\(element)%27"
                            }
                            
                            let joinedString = encodedData.joined(separator: "%2C")
                            print(joinedString)
                            get_Summary_data(sfcode:joinedString)
                            // SfData.append(sfDetails(id: joinedString, name: "All Field Force"))
                        }else{
                            print("Error: Unable to parse JSON")
                        }
                    }else{
                        var Count = 0
                        let matchingEntries = json.filter { entry in
                            if let rtoSF = entry["id"] as? String {
                                Count = Count + 1
                                print(targetId)
                                print(rtoSF)
                                print(entry)
                                return rtoSF == targetId
                            }
                            return false
                        }
                        // Print matched entries
                      
                        print(matchingEntries)
                        print("Matched Entries:")
                        var select_Id = [String]()
                        if matchingEntries.isEmpty{
                            select_Id.removeAll()
                                for _ in 0..<Count {
                                    select_Id.append(targetId)
                                }
                        }else{
                            select_Id.removeAll()
                            for entry in matchingEntries {
                                print(entry)
                                let rtoSF = entry["id"] as? String
                                select_Id.append(rtoSF!)
                            }
                        }
                        let FilterData = select_Id.map { element in
                            return "%27\(element)%27"
                        }
                        
                        let joinedString_Data = FilterData.joined(separator: "%2C")
                        print(joinedString_Data)
                        
                        get_Summary_data(sfcode:joinedString_Data)
                    }
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    func Total_Team_Size_List(date:String){
        print(date)
        SfData.removeAll()
        let apiKey: String = "get/sfDetails&selected_date=\(date)&sf_code=\(SFCode)&division_code=\(DivCode)"
        
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
                
            case .success(let value):
                print(value)
                if let json = value as? [ AnyObject] {
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
                        SfData.append(sfDetails(id: "", name: "All Field Force"))
                        
                        for item in jsonArray {
                            if let name = item["name"] as? String, let id = item["id"] as? String{
                                SfData.append(sfDetails(id: id, name: name))
                            }
                        }
                    } else {
                        print("Error: Unable to parse JSON")
                    }
                    print(SfData)
                    self.lAllObjSel = SfData
                    All_Filed_Name.reloadData()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    func get_Summary_data(sfcode:String){
        print(sfcode)
    print(SelectDate)
        let apiKey: String = "get/fieldForceData&date=\(SelectDate)&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfcode=\(sfcode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        self.ShowLoading(Message: "Loading...")
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
            case .success(let value):
                print(value)
                self.LoadingDismiss()
                if let json = value as? [String: AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = try? JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any] else {
                        print("Error: Could not convert Pretty JSON data to Dictionary")
                        return
                    }
                    print(prettyPrintedJson)
                    if let Secon_Det = prettyPrintedJson["SEC"] as? [[String: Any]] {
                        var Total_Call = 0
                        var Productive_Call = 0
                        var UPClls = 0
                        var Order_Val = 0.0
                        var weightValue = 0
                        
                        for item in Secon_Det {
                            print(item)
                            let TC = item["TC"] as? Int
                            let PC = item["PC"] as? Int
                            let orderValue = Double((item["orderValue"] as? String)!)
                            let UPC = item["UPC"] as? Int
                            let weight = item["weightValue"] as? Int ?? 0
                            Total_Call = Total_Call + TC!
                            Productive_Call = Productive_Call + PC!
                            UPClls = UPClls + UPC!
                            Order_Val = Order_Val + orderValue!
                            weightValue = weightValue + weight
                        }
                        
                        Total_Calls.text = String(Total_Call)
                        Productive_Calls.text = String(Productive_Call)
                        UPC.text = String(UPClls)
                        Secondary_Calls.text = String(format: "%.2f",Order_Val)
                        Net_Weight.text = String(weightValue)+".00"
                        var Productivity_Data: Double

                        if Total_Call != 0 {
                            Productivity_Data = Double(Productive_Call) / Double(Total_Call) * 100
                            print(Productivity_Data)
                            
                        } else {
                           
                            Productivity_Data = 0 // Setting a default value
                        }
                        print(Productivity_Data)
                        Productivity.text = String(format: "%.2f",Productivity_Data)
                        
                        
                        
                    }
                    if let PRI = prettyPrintedJson["PRI"] as? [[String: Any]]{
                        print(PRI)
                        var Order_Val = 0.0
                        for item in PRI {
                            let orderValue = item["Order_Value"] as? Double
                            Order_Val = Order_Val + orderValue!
                        }
                        Primary_Call.text = String(format: "%.2f",Order_Val)
                    }
                    
                    if let OUTLET = prettyPrintedJson["OUTLET"] as? [[String: Any]]{
                        Total_Outlets.text = String((OUTLET[0]["total_outlet"] as? Int)!)
                    }
                }

            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
        
    }
    @objc func dateView(){
        Cal_View.isHidden = false
    }
    @objc func FiledData(){
        SfData = lAllObjSel
        All_Filed_Name.reloadData()
        All_Field_View.isHidden = false
    }
    @IBAction func Cancel_Bt(_ sender: Any) {
        Cal_View.isHidden = true
    }
    
    @IBAction func All_Filed_Close(_ sender: Any) {
        txSearchSel.text = ""
        All_Field_View.isHidden = true
    }
    

    @IBAction func searchBytext(_ sender: Any) {
        print(SfData)
        print(lAllObjSel)
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            SfData = lAllObjSel
        }else{
            SfData = lAllObjSel.filter({(product) in
                let name: String = product.name
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        All_Filed_Name.reloadData()
    }
}
