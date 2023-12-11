//
//  Attendance.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//

import UIKit
import Alamofire
import FSCalendar

class Attendance: UIViewController,FSCalendarDelegate,FSCalendarDataSource {

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
    
    let axn="ManagerAttendanceData"
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate=self
        calendar.dataSource=self
        Team_Size.layer.cornerRadius = 5
        In_Market.layer.cornerRadius = 5
        Not_Logged_in.layer.cornerRadius = 5
        Leave.layer.cornerRadius = 5
        Other_Work_Type.layer.cornerRadius = 5
        
        DateView.layer.cornerRadius = 10
        DateView.layer.shadowColor = UIColor.black.cgColor
        DateView.layer.shadowOpacity = 0.5
        DateView.layer.shadowOffset = CGSize(width: 0, height: 2)
        DateView.layer.shadowRadius = 4
        // Do any additional setup after loading the view.
        getUserDetails()
        Get_Data_Attendance()
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
    func Get_Data_Attendance() {
        
        let apiKey1: String = "ManagerAttendanceData&date=2023-12-11&division=\(DivCode)&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfcode=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
        
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
                    print(CatWise)
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

}
