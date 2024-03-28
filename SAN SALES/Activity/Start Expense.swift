//
//  Start Expense.swift
//  SAN SALES
//
//  Created by San eforce on 28/03/24.
//

import UIKit
import Alamofire
import FSCalendar

class Start_Expense:IViewController, FSCalendarDelegate,FSCalendarDataSource, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var BT_Back: UIImageView!
    @IBOutlet weak var Start_Expense_Scr: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendar_view: UIView!
    @IBOutlet weak var Close_calendar_View: UIButton!
    @IBOutlet weak var Select_Date: LabelSelect!
    @IBOutlet weak var Drop_Down_Sc: UIView!
    @IBOutlet weak var Drop_Down_TB: UITableView!
    @IBOutlet weak var Text_Serch: UITextField!
    @IBOutlet weak var Close_Drop_Down: UIButton!
    @IBOutlet weak var Drop_Down_Head: UILabel!
    @IBOutlet weak var Daily_Allowance: LabelSelect!
    @IBOutlet weak var Mode_Of_Travel: LabelSelect!
    @IBOutlet weak var Check_Box: UIImageView!
    
    struct exData:Codable{
    let id:String
    let name:String
    let newname:String
    //let Travelid:String
    }
    var expsub_Date:[String]=[]
    var Only_Exp_Date:[Int]=[]
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = "",SF_type: String = ""
    let LocalStoreage = UserDefaults.standard
    var Exp_Data:[exData] = []
    var Exp_Datas:[exData]=[]
    var SelMod:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        BT_Back.addTarget(target: self, action: #selector(GotoHome))
        Close_calendar_View.addTarget(target: self, action: #selector(Clos_Calender))
        Select_Date.addTarget(target: self, action: #selector(Open_Calender))
        Daily_Allowance.addTarget(target: self, action: #selector(Open_Allowance))
        Close_Drop_Down.addTarget(target: self, action: #selector(Close_Allowance))
        Mode_Of_Travel.addTarget(target: self, action: #selector(Open_Mod_of_Travel))
        expSubmitDates()
        calendar.delegate = self
        calendar.dataSource = self
        Drop_Down_TB.dataSource = self
        Drop_Down_TB.delegate = self
        calendar.appearance.titlePlaceholderColor = .lightGray
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
    SF_type=prettyJsonData["SF_type"] as? String ?? ""
    }
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        let cal = Calendar.current
//            let day = cal.component(.day, from: date)
//        print(Only_Exp_Date)
//           if Only_Exp_Date.contains(where: { dict in
//               print(dict)
//               if dict == day {
//                   return true
//               }
//               return false
//           }) {
//               return 1
//           }
//
//           return 0
//       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Exp_Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = Exp_Data[indexPath.row].name
        return cell
    }
    func expSubmitDates(){
        let axn = "get/expSubmitDates"
        let apiKey = "\(axn)&from_date=2024-3-01&to_date=2024-3-31&selected_period=null&sf_code=\(SFCode)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could not print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    
                    if let srt_exp = json["srt_exp"] as? [AnyObject] {
                        print(srt_exp)
                        for item in srt_exp {
                            print(item)
                            expsub_Date.append((item["full_date"] as? String)!)
                            Only_Exp_Date.append(Int((item["only_date"] as? Int)!))
                        }
                    }
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  // Show error message
            }
        }
    }
    func getallowns(){
        Exp_Data.removeAll()
        
        let axn = "get/Allow_Type"
        let apiKey = "\(axn)&division_code=\(DivCode)"
        var result = apiKey
            if let lastCommaIndex = result.lastIndex(of: ",") {
                result.remove(at: lastCommaIndex)
            }
        let apiKeyWithoutCommas = result.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    print(value)
                    if let json = value as? [AnyObject] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [AnyObject]{
                                    print(jsonObject)
                                    for i in jsonObject{
                                        Exp_Data.append(exData(id: (i["id"] as? String)!, name: (i["name"] as? String)!, newname: (i["newname"] as? String)!))
                                    }
                                    Exp_Datas = Exp_Data
                                    Drop_Down_TB.reloadData()
                                } else {
                                    print("Error: Could not convert JSON to Dictionary or access 'data'")
                                }
                            } else {
                                print("Error: Could not convert JSON to String")
                            }
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                    
                case .failure(let error):
                    Toast.show(message: error.errorDescription ?? "Unknown Error")
            }
        }
    }

    @objc private func Open_Allowance() {
        SelMod = "Daily Allowance"
        Drop_Down_Head.text = "Daily Allowance"
        getallowns()
        Drop_Down_Sc.isHidden = false
    }
    @objc private func Open_Mod_of_Travel() {
        SelMod = "Travel"
        Drop_Down_Head.text = "Mode of Travel"
        Drop_Down_Sc.isHidden = false
    }
    @objc private func Close_Allowance() {
        Drop_Down_Sc.isHidden = true
    }
    @objc private func Open_Calender() {
        calendar.reloadData()
        calendar_view.isHidden = false
    }
    @objc private func Clos_Calender() {
        calendar_view.isHidden = true
    }
    @objc private func GotoHome() {
        GlobalFunc.MovetoMainMenu()
    }
    
    @IBAction func SearchByText(_ sender: Any) {
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            Exp_Datas = Exp_Data
        }else{
            Exp_Datas = Exp_Data.filter({(product) in
                let name: String = product.name
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        Drop_Down_TB.reloadData()
    }
}
