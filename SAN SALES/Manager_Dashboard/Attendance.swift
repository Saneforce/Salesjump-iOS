//
//  Attendance.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//

import UIKit
import Alamofire
import FSCalendar

class Attendance: UIViewController,FSCalendarDelegate,FSCalendarDataSource{

    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var Team_Size: UIView!
    @IBOutlet weak var In_Market: UIView!
    @IBOutlet weak var Not_Logged_in: UIView!
    @IBOutlet weak var Leave: UIView!
    @IBOutlet weak var Other_Work_Type: UIView!
    @IBOutlet weak var Team_size_UILabel: UILabel!
    @IBOutlet weak var In_Market_UILabel: UILabel!
    @IBOutlet weak var Not_Logged_in_UILabel: UILabel!
    @IBOutlet weak var Leave_UILabel: UILabel!
    @IBOutlet weak var other_work_type_UILabel: UILabel!
    
    @IBOutlet weak var Calender_View: UIView!
    @IBOutlet weak var Calendar: FSCalendar!
    @IBOutlet weak var Date_Lbl: UILabel!
    @IBOutlet weak var Cancle_bt: UIButton!
    @IBOutlet weak var Click_Det: UIView!
    
    @IBOutlet weak var Close_BT: UIButton!
    
    
    let axn="ManagerAttendanceData"
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Calendar.delegate=self
        Calendar.dataSource=self
        Team_Size.layer.cornerRadius = 5
        In_Market.layer.cornerRadius = 5
        Not_Logged_in.layer.cornerRadius = 5
        Leave.layer.cornerRadius = 5
        Other_Work_Type.layer.cornerRadius = 5
        Cancle_bt.layer.cornerRadius = 10
        Close_BT.layer.cornerRadius = 10
        
        DateView.layer.cornerRadius = 10
        DateView.layer.shadowColor = UIColor.black.cgColor
        DateView.layer.shadowOpacity = 0.5
        DateView.layer.shadowOffset = CGSize(width: 0, height: 2)
        DateView.layer.shadowRadius = 4
        // Do any additional setup after loading the view.
       
        DateView.addTarget(target: self, action: #selector(selDOT))
        Team_Size.addTarget(target: self, action: #selector(View_BT))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        Date_Lbl.text = formatter.string(from: Date())
        getUserDetails()
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        Get_Data_Attendance(Date:formatters.string(from: Date()))
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
    func Get_Data_Attendance(Date:String) {
        print(Date)
        let apiKey1: String = "ManagerAttendanceData&date=\(Date)&division=\(DivCode)&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfcode=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
        
        // Remove the unnecessary commas in the apiKey1 string
        let apiKeyWithoutCommas = apiKey1.replacingOccurrences(of: ",&", with: "&")
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
                
            case .success(let value):
                print(value)
                if let json = value as? [String: AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    let totalSizeArray = json["TotalSize"] as? [[String: Any]]
                    if let firstItem = totalSizeArray?.first, let totUser = firstItem["Tot_User"] as? Int {
                        print("Tot_User: \(totUser)")
                        Team_size_UILabel.text = String(totUser)
                    }
                    let CatWise = json["CatWise"] as? [[String: Any]]
                    if let Typ = CatWise![0]["Cnt"] as? Int{
                        print(Typ)
                        In_Market_UILabel.text = String(Typ)
                    }
                    if let iNA = CatWise![1]["Cnt"] as? Int{
                        print(iNA)
                        Not_Logged_in_UILabel.text = String(iNA)
                    }
                    if let L = CatWise![2]["Cnt"] as? Int{
                        print(L)
                        Leave_UILabel.text = String(L)
                    }
                    if let Oth = CatWise![3]["Cnt"] as? Int{
                        print(Oth)
                        other_work_type_UILabel.text = String(Oth)
                    }
                        
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
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
            Get_Data_Attendance(Date:firstDate)
        } else {
            print("No selected dates.")
        }
        Date_Lbl.text = formatter.string(from: date)
       
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
     
        Calender_View.isHidden = true
    }
    @objc func View_BT(){
        Click_Det.isHidden = false
    }
    @objc func selDOT(){
        Calender_View.isHidden = false
    }
    @IBAction func Cancel_BT(_ sender: Any) {
        Calender_View.isHidden = true
    }
    
    @IBAction func BT_Close(_ sender: Any) {
        Click_Det.isHidden = true
    }
    
}
