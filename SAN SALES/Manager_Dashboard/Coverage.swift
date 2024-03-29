//
//  Coverage.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//

import UIKit
import Alamofire
import FSCalendar

class Coverage: IViewController,FSCalendarDelegate,FSCalendarDataSource {

    @IBOutlet weak var Custom_date: UIView!
    
    @IBOutlet weak var Cst_Nam_Lbl: UILabel!
    
    
    @IBOutlet weak var Go_Button: UIView!
    
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
        
        Go_Button.backgroundColor = .white
        Go_Button.layer.cornerRadius = 10.0
        Go_Button.layer.shadowColor = UIColor.gray.cgColor
        Go_Button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Go_Button.layer.shadowRadius = 3.0
        Go_Button.layer.shadowOpacity = 0.7
        
        
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
        Go_Button.addTarget(target: self, action: #selector(Click_Go_Button))
        getUserDetails()
        ThiseMonth_Date()
   
       // let formatters = DateFormatter()
        //formatters.dateFormat = "yyyy-MM-dd"
       // Fromdate = formatters.string(from: Date())
        //Todate = formatters.string(from: Date())
       // Total_Team_Size_List(date:formatters.string(from: Date()))
        
        Cst_Nam_Lbl.text = "This month"
    }
    @objc private func selDOF() {
        SelMode = "DOF"
        Calendar_Head.text="Select from date"
        Calendars.reloadData()
        Calendar_View.isHidden = false
        
    }
    @objc private func selDOT() {
//        if Fromdate == Todate{
//            Toast.show(message: "Select From Date", controller: self)
//                    } else {
            SelMode = "DOT"
            Calendar_Head.text="Select to date"
            Calendars.reloadData()
            Calendar_View.isHidden = false
//        }
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
          //  Total_Team_Size_List(date:formatter.string(from: Date()))
            
            
        }
        
        if SelMode == "DOT" {
            TDate=date
           formatter.dateFormat = "yyyy-MM-dd"
            To_Date.text = selectedDates[0]
            Todate = selectedDates[0]
            print(selectedDates)
            //Total_Team_Size_List(date:formatter.string(from: Date()))
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
        Cst_Nam_Lbl.text = "Thise month"
        let calendar = Calendar.current
           let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: currentDate)))!
           
           // Format the start and end dates
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           
           Fromdate = dateFormatter.string(from: startOfMonth)
        
        
       // Fromdate = (formattedDate(date: calculateStartDate(for: 30)))
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        Todate = formatters.string(from: Date())
        From_Date.text = dateFormatter.string(from: startOfMonth)
        To_Date.text = formatters.string(from: Date())
        Filtter_date.isHidden = true
        

          let startOfMonthData = calendar.startOfDay(for: calendar.date(bySetting: .day, value: 1, of: currentDate)!)
          let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
          
          print("Last date of this month: \(endOfMonth)")
        
        Total_Team_Size_List(date:formatters.string(from: endOfMonth))
    }
    @objc func TodayDate(){
        Cst_Nam_Lbl.text = "Today"
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        Fromdate = formatters.string(from: Date())
        Todate = formatters.string(from: Date())
        From_Date.text = formatters.string(from: Date())
        To_Date.text = formatters.string(from: Date())
        Filtter_date.isHidden = true
        Total_Team_Size_List(date:formatters.string(from: Date()))
    }

    func calculateStartDateForThisWeek() -> Date {
        let calendar = Calendar.current
        let currentDate = Date()
        
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else {
            return currentDate
        }
        // Adjust the weekday to ensure Monday is considered as the first day of the week
        let monday = calendar.date(byAdding: .day, value: 2 - (calendar.component(.weekday, from: startOfWeek)), to: startOfWeek) ?? currentDate
        return monday
    }
    func lastDateOfWeek(for date: Date) -> Date? {
           let calendar = Calendar.current

           // Find the first day of the week (Monday)
           guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: date)),
               let lastDayOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else {
                   return nil
           }

           return lastDayOfWeek
       }


    @objc func ThiseWeek_Date() {
        Cst_Nam_Lbl.text = "Thise Week"
        Fromdate = formattedDate(date: calculateStartDateForThisWeek())
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        Todate = formatters.string(from: Date())
        From_Date.text = formattedDate(date: calculateStartDateForThisWeek())
        To_Date.text = formatters.string(from: Date())
        Filtter_date.isHidden = true
        let currentDate = Date()

            if let lastDateOfThisWeek = lastDateOfWeek(for: currentDate) {
                print("Last date of this week (Monday to Sunday): \(lastDateOfThisWeek)")
                Total_Team_Size_List(date: formatters.string(from: lastDateOfThisWeek))
            }
        
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
        
        self.ShowLoading(Message: "Loading ...")
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            switch AFdata.result {
            case .success(let value):
                print(value)
                self.LoadingDismiss()
                
                if let json = value as? [String: Any],
                   let totRetailArray = json["totRetail"] as? [[String: Any]],
                   let totRetailDict = totRetailArray.first,
                   let totalRetailer = totRetailDict["total_retailer"] as? String{
                    
                    print("Total Retailer: \(totalRetailer)")
                    print(json)
                    var ToalRot = 0
                    var TotDis = 0
                    var visit_Rets = 0
                    Total_Ret.text = String(totalRetailer)
                    if let total_route =  json["totRoute"] as? [[String: Any]],
                       let totRetailDict = total_route.first,
                       let totalroute = totRetailDict["total_route"] as? String{
                        print("Total Route: \(totalroute)")
                        ToalRot = Int(totalroute)!
                        Total_Rt.text = String(totalroute)
                    }
                    print(json)
                    if let totDisArray = json["totDis"] as? [[String: Any]],
                        let totRetailDict = totDisArray.first,
                        let totalDis = totRetailDict["total_dis"] as? String {
                            print("Total Dis: \(totalDis)")
                        TotDis = Int(totalDis)!
                            Total_Dis.text = String(totalDis)
                    }
                    
                    if let visit_Details = json["visit_Details"] as? [[String:Any]]{
                        if let visit_Ret = visit_Details[0]["Ret"] as? Int{
                            visit_Rets = visit_Ret
                            Visited_Ret.text = String(visit_Ret)
                            //cell.lblUOM?.text = String(format: "%@",item["OffUntName"] as! String)
                            if(Int(totalRetailer)! < visit_Ret){
                                Coverage_Ret.text = "0.0"
                            }else if(Int(totalRetailer) == 0 && visit_Ret == 0) {
                                Coverage_Ret.text = "0.0"
                            }else{
                                let Coverage_mul = Double(visit_Ret) / Double(totalRetailer)!
                                let Coverage = Double(Coverage_mul) * 100
                                print(Coverage)
                                Coverage_Ret.text = String(format: "%.2f",Coverage)
                            }
                        }
                        if let visit_dis = visit_Details[0]["rout"] as? Int{
                            let Not_Visited_Rtdata = ToalRot - visit_dis
                            if Not_Visited_Rtdata > 0 {
                                Not_Visited_Rt.text = String(Not_Visited_Rtdata)
                            } else {
                                Not_Visited_Rt.text = "0"
                            }
                            Visited_Rt.text = String(visit_dis)
                            if (Int(ToalRot) < visit_dis){
                                Coverage_Rt.text = "0.0"
                            }else if (Int(ToalRot) == 0 && visit_dis == 0){
                                Coverage_Rt.text = "0.0"
                            }else{
                                let Coverage_mul = Double(visit_dis) / Double(ToalRot)
                                let Coverage = Double(Coverage_mul) * 100
                                Coverage_Rt.text = String(format: "%.2f",Coverage)
                            }
                        }
                        if let visit_rout = visit_Details[0]["dis"] as? Int{
                            let Not_Vis_Countdata = TotDis - visit_rout
                            if Not_Vis_Countdata > 0 {
                                Not_Visited_Dis.text = String(Not_Vis_Countdata)
                            } else {
                                Not_Visited_Dis.text = "0"
                            }

                            Visited_Dis.text = String(visit_rout)
                            if(Int(TotDis) < visit_rout){
                                Coverage_Dis.text = "0.0"
                            }else if (Int(TotDis) == 0 && visit_rout == 0){
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
                        //let total_New_Rout_data = totalRetailer + totalroute
                        let NotVis =  Int(totalRetailer)! - visit_Rets
                         print(NotVis)
                        if NotVis > 0 {
                            Not_Visited_Ret.text  = String(NotVis)
                        } else {
                            Not_Visited_Ret.text  = "0"
                        }
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
    @objc func Click_Go_Button(){
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        Total_Team_Size_List(date:Todate)
    }
}
