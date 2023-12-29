//
//  Coverage.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//

import UIKit
import Alamofire
import FSCalendar

class Coverage: UIViewController,FSCalendarDelegate,FSCalendarDataSource {

    @IBOutlet weak var Custom_date: UIView!
    @IBOutlet weak var From_and_to_date: UIView!
    @IBOutlet weak var Retailers_View: UIView!
    @IBOutlet weak var Route_View: UIView!
    @IBOutlet weak var Distributors_View: UIView!
    @IBOutlet weak var From_Date: UILabel!
    @IBOutlet weak var To_Date: UILabel!
    
    @IBOutlet weak var Total_Ret: UILabel!
    @IBOutlet weak var Visited_Ret: UILabel!
    @IBOutlet weak var New_Ret: UILabel!
    @IBOutlet weak var Coverage_Ret: UILabel!
    @IBOutlet weak var Not_Visited_Ret: UILabel!
    
    @IBOutlet weak var Total_Rt: UILabel!
    @IBOutlet weak var Visited_Rt: UILabel!
    @IBOutlet weak var Coverage_Rt: UILabel!
    @IBOutlet weak var Not_Visited_Rt: UILabel!
    
    @IBOutlet weak var Total_Dis: UILabel!
    @IBOutlet weak var Visited_Dis: UILabel!
    @IBOutlet weak var Coverage_Dis: UILabel!
    @IBOutlet weak var Not_Visited_Dis: UILabel!
    
    @IBOutlet weak var Filtter_date: UIView!
    @IBOutlet weak var ThiseMonth: UILabel!
    @IBOutlet weak var Today: UILabel!
    @IBOutlet weak var ThiseWeek: UILabel!
    @IBOutlet weak var Calendar_Head: UILabel!
    @IBOutlet weak var Calendars: FSCalendar!
    @IBOutlet weak var Calendar_View: UIView!
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    var Coverage_Sfcode = ""
    var Fromdate = ""
    var Todate = ""
    let calendar = Calendar.current
    let currentDate = Date()
    var SelMode = ""
    var FDate: Date = Date(),TDate: Date = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        Calendars.delegate=self
        Calendars.dataSource=self
        Custom_date.backgroundColor = .white
        Custom_date.layer.cornerRadius = 10.0
        Custom_date.layer.shadowColor = UIColor.gray.cgColor
        Custom_date.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Custom_date.layer.shadowRadius = 3.0
        Custom_date.layer.shadowOpacity = 0.7
        
        From_and_to_date.backgroundColor = .white
        From_and_to_date.layer.cornerRadius = 10.0
        From_and_to_date.layer.shadowColor = UIColor.gray.cgColor
        From_and_to_date.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        From_and_to_date.layer.shadowRadius = 3.0
        From_and_to_date.layer.shadowOpacity = 0.7
        
        
        Retailers_View.backgroundColor = .white
        Retailers_View.layer.cornerRadius = 10.0
        Retailers_View.layer.shadowColor = UIColor.gray.cgColor
        Retailers_View.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Retailers_View.layer.shadowRadius = 3.0
        Retailers_View.layer.shadowOpacity = 0.7
        
        Route_View.backgroundColor = .white
        Route_View.layer.cornerRadius = 10.0
        Route_View.layer.shadowColor = UIColor.gray.cgColor
        Route_View.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Route_View.layer.shadowRadius = 3.0
        Route_View.layer.shadowOpacity = 0.7
        
        Distributors_View.backgroundColor = .white
        Distributors_View.layer.cornerRadius = 10.0
        Distributors_View.layer.shadowColor = UIColor.gray.cgColor
        Distributors_View.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Distributors_View.layer.shadowRadius = 3.0
        Distributors_View.layer.shadowOpacity = 0.7
        // Do any additional setup after loading the view.
        Custom_date.addTarget(target: self, action: #selector(Viewopen))
        ThiseMonth.addTarget(target: self, action: #selector(ThiseMonth_Date))
        Today.addTarget(target: self, action: #selector(TodayDate))
        ThiseWeek.addTarget(target: self, action: #selector(ThiseWeek_Date))
        From_Date.addTarget(target: self, action: #selector(selDOF))
        To_Date.addTarget(target: self, action: #selector(selDOT))
        getUserDetails()
        ThiseMonth_Date()
   
       // let formatters = DateFormatter()
        //formatters.dateFormat = "yyyy-MM-dd"
       // Fromdate = formatters.string(from: Date())
        //Todate = formatters.string(from: Date())
       // Total_Team_Size_List(date:formatters.string(from: Date()))
        
    }
    @objc private func selDOF() {
        SelMode = "DOF"
        Calendar_Head.text="Select from date"
        Calendars.reloadData()
        Calendar_View.isHidden = false
        
    }
    @objc private func selDOT() {
        if Fromdate == Todate{
            Toast.show(message: "Select From Date", controller: self)
                    } else {
            SelMode = "DOT"
            Calendar_Head.text="Select to date"
            Calendars.reloadData()
            Calendar_View.isHidden = false
        }
    }
    func openWin(Mode:String){
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("did select date \(formatter.string(from: date))")
       // let selectedDates = calendar.selectedDates.sorted(by: {formatter.string(from: $0)})
        let selectedDates = calendar.selectedDates.map({formatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        if SelMode == "DOF"{
            FDate=date
            print(selectedDates)
            formatter.dateFormat = "yyyy-MM-dd"
            From_Date.text = selectedDates[0]
            Fromdate = selectedDates[0]
            Calendars.reloadData()
            Total_Team_Size_List(date:formatter.string(from: Date()))
            
            
        }
        
        if SelMode == "DOT" {
            TDate=date
           formatter.dateFormat = "yyyy-MM-dd"
            To_Date.text = selectedDates[0]
            Todate = selectedDates[0]
            print(selectedDates)
            Total_Team_Size_List(date:formatter.string(from: Date()))
        }
        Calendar_View.isHidden = true

    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        if SelMode == "DOF"{
            return TDate
        }
        return Date()
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
        if SelMode == "DOT"{
            return FDate
                }
        return formatter.date(from: "1900/01/01")!
    }
    @objc func ThiseMonth_Date(){
        Fromdate = (formattedDate(date: calculateStartDate(for: 30)))
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        Todate = formatters.string(from: Date())
        From_Date.text = (formattedDate(date: calculateStartDate(for: 30)))
        To_Date.text = formatters.string(from: Date())
        Filtter_date.isHidden = true
        Total_Team_Size_List(date:formatters.string(from: Date()))
    }
    @objc func TodayDate(){
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        Fromdate = formatters.string(from: Date())
        Todate = formatters.string(from: Date())
        From_Date.text = formatters.string(from: Date())
        To_Date.text = formatters.string(from: Date())
        Filtter_date.isHidden = true
        Total_Team_Size_List(date:formatters.string(from: Date()))
    }
    @objc func ThiseWeek_Date(){
        Fromdate = (formattedDate(date: calculateStartDate(for: 7)))
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        Todate = formatters.string(from: Date())
        From_Date.text = (formattedDate(date: calculateStartDate(for: 7)))
        To_Date.text = formatters.string(from: Date())
        Filtter_date.isHidden = true
        Total_Team_Size_List(date:formatters.string(from: Date()))
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
    func Total_Team_Size_List(date:String){
        print(date)
       
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
                       var select_Id = [String]()
                        for entry in jsonArray {
                            print(entry)
                            let rtoSF = entry["id"] as? String
                            select_Id.append(rtoSF!)
                        }
                        let encodedData = select_Id.map { element in
                            return "%27\(element)%27"
                        }
                        
                        let joinedString = encodedData.joined(separator: "%2C")
                        print(joinedString)
                        Coverage_Sfcode = joinedString
                        print(Coverage_Sfcode)
                        Get_Coverage_data()
                       
                    } else {
                        print("Error: Unable to parse JSON")
                    }
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    func Get_Coverage_data() {
        print(Coverage_Sfcode)
        let apiKey: String = "get/CoverageDetails&desig=\(Desig)&divisionCode=\(DivCode)&todate=\(Todate)&rSF=\(SFCode)&sfcode=\(Coverage_Sfcode)&sfCode=\(SFCode)&stateCode=\(StateCode)&fromdate=\(Fromdate)"
        
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        
        self.ShowLoading(Message: "Get Coverage Data...")
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            switch AFdata.result {
            case .success(let value):
                print(value)
                self.LoadingDismiss()
                
                if let json = value as? [String: Any],
                   let totRetailArray = json["totRetail"] as? [[String: Int]],
                   let totRetailDict = totRetailArray.first,
                   let totalRetailer = totRetailDict["total_retailer"] {
                    
                    print("Total Retailer: \(totalRetailer)")
                    print(json)
                    var ToalRot = 0
                    var TotDis = 0
                    Total_Ret.text = String(totalRetailer)
                    if let total_route =  json["totRoute"] as? [[String: Int]],
                       let totRetailDict = total_route.first,
                       let totalroute = totRetailDict["total_route"]{
                        print("Total Route: \(totalroute)")
                        ToalRot = totalroute
                        Total_Rt.text = String(totalroute)
                    }
                    if let totDis =  json["totDis"] as? [[String: Int]],
                       let totRetailDict = totDis.first,
                       let totalDis = totRetailDict["total_dis"]{
                        print("Total Dis: \(totalDis)")
                        TotDis = totalDis
                        Total_Dis.text = String(totalDis)
                    }
                    
                    if let visit_Details = json["visit_Details"] as? [[String:Int]]{
                        if let visit_Ret = visit_Details[0]["Ret"]{
                           let NotVis = totalRetailer - visit_Ret
                            print(NotVis)
                            Not_Visited_Ret.text = String(NotVis)
                            Visited_Ret.text = String(visit_Ret)
                            //cell.lblUOM?.text = String(format: "%@",item["OffUntName"] as! String)
                            if(totalRetailer < visit_Ret){
                                Coverage_Ret.text = "0.0"
                            }else{
                                let Coverage_mul = Double(visit_Ret) / Double(totalRetailer)
                                let Coverage = Double(Coverage_mul) * 100
                                print(Coverage)
                                Coverage_Ret.text = String(format: "%.2f",Coverage)
                            }
                        }
                        if let visit_dis = visit_Details[0]["rout"]{
                            Not_Visited_Rt.text = String(ToalRot - visit_dis)
                            Visited_Rt.text = String(visit_dis)
                            if (ToalRot < visit_dis){
                                Coverage_Rt.text = "0.0"
                            }else{
                                let Coverage_mul = Double(visit_dis) / Double(ToalRot)
                                let Coverage = Double(Coverage_mul) * 100
                                Coverage_Rt.text = String(format: "%.2f",Coverage)
                            }
                        }
                        if let visit_rout = visit_Details[0]["dis"]{
                            Not_Visited_Dis.text = String(TotDis - visit_rout)
                            Visited_Dis.text = String(visit_rout)
                            if(TotDis < visit_rout){
                                Coverage_Dis.text = "0.0"
                            }else{
                                let Coverage_mul = Double(visit_rout) / Double(TotDis)
                                let Coverage = Double(Coverage_mul) * 100
                                Coverage_Dis.text = String(format: "%.2f",Coverage)
                            }
                        }
                    }
                    if let newRetail =  json["newRetail"] as? [[String: Int]],
                       let totRetailDict = newRetail.first,
                       let totalroute = totRetailDict["new_retailer"]{
                        print("New Retailer : \(totalroute)")
                        New_Ret.text = String(totalroute)
                    }
                }
                
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
    }
    @objc func Viewopen(){
        Filtter_date.isHidden = false
    }
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    private func calculateStartDate(for days: Int) -> Date {
         let startDate = calendar.date(byAdding: .day, value: -days, to: currentDate)
         return startDate ?? currentDate
     }
 
    
    @IBAction func Close_View(_ sender: Any) {
        Filtter_date.isHidden = true
    }
    
    
    @IBAction func Calendar_View_Close(_ sender: Any) {
        Calendar_View.isHidden =  true
    }
}
