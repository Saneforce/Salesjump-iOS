//
//  Expense Entry.swift
//  SAN SALES
//
//  Created by San eforce on 13/03/24.
//

import UIKit
import FSCalendar
import Alamofire
import Foundation

class Expense_Entry: IViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDataSource, UITableViewDelegate {
  
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
    var FDate: Date = Date(),TDate: Date = Date()
    var period_from_date = ""
    var period_to_date = ""
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
        if (SelPeriod.text == "Select Period"){
            Toast.show(message: "Select Period")
            return
        }
        if monthPosition == .previous || monthPosition == .next {
            return
        }
        print(date)
        print(monthPosition)
        let cell = calendar.cell(for: date, at: monthPosition)

        // Change the background color of the selected date cell to red
//        if let label = cell?.titleLabel {
//               label.textColor = UIColor.red
//           }
       // addLetterA(to: cell, text: "A")
        addDART(to: cell, text: ".")
    }


    func addLetterA(to cell: FSCalendarCell?, text:String) {
        cell?.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        let letterLabel = UILabel()
        letterLabel.text = text
        letterLabel.textColor = .red
        letterLabel.font = UIFont.boldSystemFont(ofSize: 14)
        letterLabel.textAlignment = .center
        letterLabel.frame = CGRect(x: 0, y: 15, width: cell?.bounds.width ?? 0, height: cell?.bounds.height ?? 0)
        cell?.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        cell?.addSubview(letterLabel)
    }
    func addDART(to cell: FSCalendarCell?,text:String) {
        cell?.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        let letterLabel = UILabel()
        letterLabel.text = text
        letterLabel.textColor = UIColor(red: 0.06, green: 0.68, blue: 0.76, alpha: 1.00)
        letterLabel.font = UIFont.boldSystemFont(ofSize: 50)
        letterLabel.textAlignment = .center
        letterLabel.frame = CGRect(x: 0, y: 3, width: cell?.bounds.width ?? 0, height: cell?.bounds.height ?? 0)
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
        calendar.reloadData()
        let item = Period[indexPath.row]
        print(item)
        SelPeriod.text = item.Period_Name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let From_Date = item.From_Date
        period_from_date = "2024-03-"+From_Date
        if let date = dateFormatter.date(from: "2024-03-" + From_Date) {
            FDate = date
        } else {
            print("Error: Unable to convert string to Date")
        }
        let To_Date = item.To_Date
        if To_Date == "end of month"{
            let currentDate = Date()
            let calendar = Calendar.current
            if let monthRange = calendar.range(of: .day, in: .month, for: currentDate) {
                let lastDayOfMonth = monthRange.upperBound - 1
                if let lastDateOfMonth = calendar.date(bySetting: .day, value: lastDayOfMonth, of: currentDate) {
                    print("Last date of the month: \(lastDateOfMonth)")
                    TDate = lastDateOfMonth
                    print(lastDateOfMonth)
                    let formatters = DateFormatter()
                    formatters.dateFormat = "yyyy-MM-dd"
                    period_to_date = formatters.string(from: lastDateOfMonth)
                }
            }
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let Per_To_Date = To_Date
            period_to_date = "2024-03-"+To_Date
            if let date = dateFormatter.date(from: "2024-03-" + Per_To_Date) {
                TDate = date
            } else {
                print("Error: Unable to convert string to Date")
            }
        }
        expSubmitDates()
        calendar.reloadData()
        TextSeh.text = ""
        Selwind.isHidden = true
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return TDate
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
       return FDate
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
    
    func expSubmitDates(){
        
        let axn = "get/expSubmitDates"
        let apiKey = "\(axn)&desig=\(Desig)&divisionCode=\(DivCode)&from_date=\(period_from_date)&to_date=\(period_to_date)&month=3&rSF=\(SFCode)&year=2024&selected_period=58&sfCode=\(SFCode)&stateCode=\(StateCode)&sf_code=\(SFCode)"
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
                                
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any]{
                                    print(jsonObject)
                                    // attance_flg
                                    if let attance_flg = jsonObject["attance_flg"] as?  [[String: Any]]{
                                        print(attance_flg)
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "dd/MM/yyyy"
                                        let dates = attance_flg.compactMap { dictionary -> Date? in
                                            guard let dateString = dictionary["pln_date"] as? String else { return nil }
                                            return dateFormatter.date(from: dateString)
                                        }

                                        // Generate an array of all dates between the start and end dates
                                        let startDate = dates.min() ?? Date()
                                        let endDate = dates.max() ?? Date()
                                        var allDates = [Date]()
                                        var currentDate = startDate
                                        while currentDate <= endDate {
                                            allDates.append(currentDate)
                                            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                                        }

                                        // Find the missing date
                                        let missingDate = allDates.first { !dates.contains($0) }

                                        // Print the result
                                        print(missingDate)
                                        if let missingDate = missingDate {
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "dd/MM/yyyy"
                                            print(missingDate)
                                            let cell = calendar.cell(for: missingDate, at: .current)
                                            addLetterA(to: cell, text: "A")
                                        } else {
                                            print("No missing date found.")
                                        }
                                    }
                                    // exp_submit
                                    if let exp_submit = jsonObject["exp_submit"] as? [[String: Any]]{
                                        print(exp_submit)
                                        for i in exp_submit {
                                            if let dateString = i["full_date"] as? String {
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "dd/MM/yyyy"
                                                
                                                if let date = dateFormatter.date(from: dateString) {
                                                    let cell = calendar.cell(for: date, at: .current)
                                                    addDART(to: cell, text: ".")
                                                } else {
                                                    print("Failed to convert \(dateString) to Date.")
                                                }
                                            } else {
                                                print("Date string is nil or not in the expected format.")
                                            }
                                        }
                                    }
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
