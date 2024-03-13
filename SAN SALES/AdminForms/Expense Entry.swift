//
//  Expense Entry.swift
//  SAN SALES
//
//  Created by San eforce on 13/03/24.
//

import UIKit
import FSCalendar
import Alamofire

class Expense_Entry: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDataSource, UITableViewDelegate {
  
    @IBOutlet weak var BackBT: UIImageView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var Selwind: UIView!
    @IBOutlet weak var SelPeriod: LabelSelect!
    @IBOutlet weak var DataTB: UITableView!
    @IBOutlet weak var TextSeh: UITextField!
    struct PeriodicData:Codable{
        let Division_Code:Int
        let Eff_Month:Int
        let Eff_Year:Int
        let From_Date:String
        let Period_Id:String
        let Period_Name:String
        let To_Date:String
        let dis_Rank:String
    }
    let LocalStoreage = UserDefaults.standard
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    var Period:[PeriodicData] = []
    var lstOfPeriod:[PeriodicData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        calendar.delegate=self
        calendar.dataSource=self
        DataTB.dataSource=self
        DataTB.delegate=self
        periodic()
        BackBT.addTarget(target: self, action: #selector(GotoHome))
        SelPeriod.addTarget(target: self, action: #selector(OpenWindo))
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

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            return
        }

        let cell = calendar.cell(for: date, at: monthPosition)

        // Change the background color of the selected date cell to red
//        if let label = cell?.titleLabel {
//               label.textColor = UIColor.red
//           }
        addLetterA(to: cell)
    }


    func addLetterA(to cell: FSCalendarCell?) {
        // Customize the appearance of the letter as needed
        let letterLabel = UILabel()
        letterLabel.text = "A"
        letterLabel.textColor = .red
        letterLabel.font = UIFont.boldSystemFont(ofSize: 14)
        letterLabel.textAlignment = .center
        letterLabel.frame = CGRect(x: 0, y: 10, width: cell?.bounds.width ?? 0, height: cell?.bounds.height ?? 0)
        cell?.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        cell?.addSubview(letterLabel)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Period.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = Period[indexPath.row].Period_Name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TextSeh.text = ""
    }
    
    func periodic() {
        let axn = "get/periodicWise"
        let apiKey = "\(axn)&desig=\(Desig)&divisionCode=\(DivCode)&div_code=\(DivCode)&month=03&rSF=\(SFCode)&year=2024&sfCode=\(SFCode)&stateCode=\(StateCode)&sf_code=\(SFCode)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    print(value)
                    if let json = value as? [String: Any] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)

                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any],
                                   let data = jsonObject["data"] as? [AnyObject] {
                                    
                                    for i in data {
                                        if let divisionCode = i["Division_Code"] as? Int,
                                           let effMonth = i["Eff_Month"] as? Int,
                                           let effYear = i["Eff_Year"] as? Int,
                                           let fromDate = i["From_Date"] as? String,
                                           let periodId = i["Period_Id"] as? String,
                                           let periodName = i["Period_Name"] as? String,
                                           let toDate = i["To_Date"] as? String,
                                           let disRank = i["dis_Rank"] as? String {
                                            
                                            Period.append(PeriodicData(Division_Code: divisionCode, Eff_Month: effMonth, Eff_Year: effYear, From_Date: fromDate, Period_Id: periodId, Period_Name: periodName, To_Date: toDate, dis_Rank: disRank))
                                        } else {
                                            print("Error: Some key in the data is nil or has the wrong type")
                                        }
                                    }
                                    lstOfPeriod = Period
                                    DataTB.reloadData()
                                    print(lstOfPeriod)
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
    @objc private func GotoHome() {
        self.resignFirstResponder()
   
        self.navigationController?.popViewController(animated: true)
        return
    }
    @objc private func OpenWindo() {
        Selwind.isHidden = false
    }
    @IBAction func Closwindo(_ sender: Any) {
        TextSeh.text = ""
        Selwind.isHidden = true
    }
    
    @IBAction func SerchByText(_ sender: Any) {
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            lstOfPeriod = Period
        }else{
            lstOfPeriod = Period.filter({(product) in
                let name: String = product.Period_Name
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        DataTB.reloadData()
    }
}
