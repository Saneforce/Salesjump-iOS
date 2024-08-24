//
//  Expense View.swift
//  SAN SALES
//
//  Created by San eforce on 22/04/24.
//

import UIKit
import Alamofire
import FSCalendar
import Foundation
class Expense_View: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    // selection
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var Sel_Date: UILabel!
    @IBOutlet weak var Sel_Period: UILabel!
    @IBOutlet weak var Close_Drop_Down: UIButton!
    @IBOutlet weak var Close_Pop_Up: UILabel!
    @IBOutlet weak var YearPostion: UILabel!
    @IBOutlet weak var MonthPostion: UILabel!
    
    // View
    @IBOutlet weak var Sel_Date_View: UIView!
    @IBOutlet weak var Select_Period_View: UIView!
    @IBOutlet weak var Summary_View: UIView!
    @IBOutlet weak var Sel_Period_Drop_Down: UIView!
    @IBOutlet var blureView: UIVisualEffectView!
    @IBOutlet var PopUpView: UIView!
    // Table View
    @IBOutlet weak var Exp_Report_TB: UITableView!
    @IBOutlet weak var Period_TB: UITableView!
    @IBOutlet weak var Sum_Exp: UITableView!
    
    // Collection View
    @IBOutlet weak var Collection_Of_Month: UICollectionView!
    
    // Text Search
    @IBOutlet weak var TextSearch: UITextField!
    struct PeriodicDatas:Codable{
        let Division_Code:Int
        let Eff_Month:Int
        let Eff_Year:Int
        let From_Date:String
        let Period_Id:String
        let Period_Name:String
        let To_Date:String
        let dis_Rank:String
    }
    
    struct Exp_Data:Codable{
        let Date:String
        let Mode:String
        let Wok_Typ:String
        let Wok_plc:String
        let From_place:String
        let To_place:String
        let DisKM:String
        let Fare:String
        let Da_Typ:String
        let DA_Exp:String
        var Amount:String
        let DAddit:String
        let Hotal_Bill:String
        var Total:String
        let Satus:String
        let ExpDist:Int
        var Rej_Amt:String
        var ClstrName:String
        var DailyAddDeduct:String
        var DailyAddDeductSymb:String
    }
    struct Exp_Sum:Codable{
        let Tit:String
        var Amt:String
    }
    var Exp_Summary_Data:[Exp_Sum] = []
    var Exp_Detel_Data:[Exp_Data] = []
    var labelsDictionary = [FSCalendarCell: UILabel]()
    let LocalStoreage = UserDefaults.standard
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = "",SF_type: String = ""
    var Period:[PeriodicDatas] = []
    var lstOfPeriod:[PeriodicDatas] = []
    var selectYear:String = "\(Calendar.current.component(.year, from: Date()))"
    var SelectMonth:String = ""
    var SelectMonthPostion:String = ""
    var Monthtext_and_year: [String] = []
    var SelMod:String = "MON"
    var FDate: Date = Date(),TDate: Date = Date()
    var No_Of_Days_In_Perio = 0
    var period_from_date = ""
    var period_to_date = ""
    var period_id = ""
    var Eff_Month="", Eff_Year=0
    override func viewDidLoad(){
        super.viewDidLoad()
        getUserDetails()
        YearPostion.text = selectYear
        let Month = Calendar.current.component(.month, from: Date()) - 1
        let formattedPosition = String(format: "%02d", Month + 1)
        SelectMonth = formattedPosition
        Eff_Month = formattedPosition
        let dateFormatter = DateFormatter()
        let mon_formater =  DateFormatter()
        mon_formater.dateFormat = "MMM"
        dateFormatter.dateFormat = "MMM-yyyy"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        let formattedDatemon = mon_formater.string(from: currentDate)
        print(formattedDatemon)
        MonthPostion.text = formattedDatemon
        Sel_Date.text = formattedDate
        Sel_Date_View.layer.cornerRadius = 10
        Sel_Date_View.layer.shadowColor = UIColor.black.cgColor
        Sel_Date_View.layer.shadowOpacity = 0.5
        Sel_Date_View.layer.shadowOffset = CGSize(width: 0, height: 2)
        Sel_Date_View.layer.shadowRadius = 4
        
        Select_Period_View.layer.cornerRadius = 10
        Select_Period_View.layer.shadowColor = UIColor.black.cgColor
        Select_Period_View.layer.shadowOpacity = 0.5
        Select_Period_View.layer.shadowOffset = CGSize(width: 0, height: 2)
        Select_Period_View.layer.shadowRadius = 4
        
        Summary_View.layer.cornerRadius = 10
        Summary_View.layer.shadowColor = UIColor.black.cgColor
        Summary_View.layer.shadowOpacity = 0.5
        Summary_View.layer.shadowOffset = CGSize(width: 0, height: 2)
        Summary_View.layer.shadowRadius = 4
        
        Exp_Report_TB.delegate = self
        Exp_Report_TB.dataSource = self
        
        Period_TB.delegate = self
        Period_TB.dataSource = self
        
        Sum_Exp.delegate = self
        Sum_Exp.dataSource = self
        
        Collection_Of_Month.delegate=self
        Collection_Of_Month.dataSource=self
        
        blureView.bounds = self.view.bounds
        PopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        PopUpView.layer.cornerRadius = 10
        
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        Sel_Date.addTarget(target: self, action: #selector(Show_Year_and_Month))
        Sel_Period.addTarget(target: self, action: #selector(Open_Drop_Down_View))
        Close_Drop_Down.addTarget(target: self, action: #selector(Close_Drop_Down_View))
        Sel_Date.addTarget(target: self, action: #selector(OpenPopUP))
        Close_Pop_Up.addTarget(target: self, action: #selector(ClosePopUP))
        YearPostion.addTarget(target: self, action: #selector(OpenYear))
        MonthPostion.addTarget(target: self, action: #selector(OpenMonth))
        
        
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Rejected Expense", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: "-"))
        
    }
    func getUserDetails(){
    let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
    let data = Data(prettyPrintedJson!.utf8)
    guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
    print("Error: Cannot convert JSON object to Pretty JSON data")
    return
    }
    print(prettyJsonData)
    SFCode = prettyJsonData["sfCode"] as? String ?? ""
    StateCode = prettyJsonData["State_Code"] as? String ?? ""
    DivCode = prettyJsonData["divisionCode"] as? String ?? ""
    Desig=prettyJsonData["desigCode"] as? String ?? ""
    SF_type=prettyJsonData["SF_type"] as? String ?? ""
    }
    func animateIn(desiredView: UIView){
        let  backGroundView = self.view
        backGroundView?.addSubview(desiredView)
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center=backGroundView!.center
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }
    func animateOut(desiredView:UIView){
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        },completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Monthtext_and_year.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        if (SelMod == "MON"){
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            cell.lblText.text = Monthtext_and_year[indexPath.row]
            //MonthPostion.text = Monthtext_and_year[indexPath.row]
        }else if (SelMod == "YEAR"){
            cell.lblText.text = Monthtext_and_year[indexPath.row]
            let attributedText = NSAttributedString(string: cell.lblText?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            cell.lblText?.attributedText = attributedText
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (SelMod == "MON"){
            let item = Monthtext_and_year[indexPath.row]
            print(item)
            print(Monthtext_and_year)
            if let position = Monthtext_and_year.firstIndex(where: { $0 == item }) {
                let formattedPosition = String(format: "%02d", position + 1)
                SelectMonth = formattedPosition
                Eff_Month = formattedPosition
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-yyyy"
                if let date = dateFormatter.date(from: "\(SelectMonth)-\(selectYear)") {
                    FDate = date
                    TDate = date
                }
                
                if Sel_Date.text != "\(item)-\(selectYear)" {
                    Sel_Period.text = "Select Period"
                    Exp_Detel_Data.removeAll()
                    Exp_Report_TB.reloadData()
                    Exp_Summary_Data.removeAll()
                    Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: "-"))
                    Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "-"))
                    Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "-"))
                    Exp_Summary_Data.append(Exp_Sum(Tit: "Rejected Expense", Amt: "-"))
                    Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: "-"))
                    Sum_Exp.reloadData()
                }
                
                Sel_Date.text = "\(item)-\(selectYear)"
                //SelPeriod.text = "Select Period"
                removeLabels()
                ClosePopUP()
            }
        }else if (SelMod == "YEAR"){
            let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
            if (currentMonthIndex == 0){
                let item = Monthtext_and_year[indexPath.row]
                print(item)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM"
                Monthtext_and_year = dateFormatter.shortMonthSymbols
                selectYear = item
                SelMod = "MON"
                YearPostion.text = selectYear
                Collection_Of_Month.reloadData()
            }else{
                let item = Monthtext_and_year[indexPath.row]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM"
                Monthtext_and_year = dateFormatter.shortMonthSymbols
                selectYear = item
                SelMod = "MON"
                Collection_Of_Month.reloadData()
            }
        }
    }
    func MonthaObj(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        Monthtext_and_year = dateFormatter.shortMonthSymbols
        Collection_Of_Month.reloadData()
    }
    func yearobj(){
        Monthtext_and_year.removeAll()
        let currentYear = Calendar.current.component(.year, from: Date())
        var yearsArray = [String]()
        Monthtext_and_year.append(String(currentYear))
        for i in 1...100 {
            let previousYear = currentYear - i
            Monthtext_and_year.append(String(previousYear))
        }
        print(yearsArray)
        Collection_Of_Month.reloadData()
    }
    @objc private func OpenPopUP() {
        MonthaObj()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
       let Month = dateFormatter.shortMonthSymbols
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
       // MonthPostion.text = Month![currentMonthIndex]
        animateIn(desiredView: blureView)
        animateIn(desiredView: PopUpView)
    }
    @objc private func ClosePopUP() {
        animateOut(desiredView:blureView)
        animateOut(desiredView:PopUpView)
    }
    func removeLabels(){
         for (_, label) in labelsDictionary {
             label.removeFromSuperview()
         }
         labelsDictionary.removeAll()
     }
 
    @objc  func OpenYear() {
        SelMod = "YEAR"
        yearobj()
    }
    @objc func OpenMonth() {
        SelMod = "MON"
        MonthaObj()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Exp_Report_TB == tableView {return 450}
        if Period_TB == tableView {return 50}
        if Sum_Exp == tableView {return 30}
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Exp_Report_TB == tableView{return Exp_Detel_Data.count}
        if Period_TB == tableView {return lstOfPeriod.count}
        if Sum_Exp == tableView {return Exp_Summary_Data.count}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if(Exp_Report_TB == tableView){
            cell.Card_View.layer.cornerRadius = 10
            cell.Card_View.layer.shadowColor = UIColor.black.cgColor
            cell.Card_View.layer.shadowOpacity = 0.5
            cell.Card_View.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.Card_View.layer.shadowRadius = 4
            print(Exp_Detel_Data)
            cell.Exp_Date.text = Exp_Detel_Data[indexPath.row].Date
            cell.Exp_Mod.text = Exp_Detel_Data[indexPath.row].Mode
            cell.Exp_Work_Typ.text = Exp_Detel_Data[indexPath.row].Wok_Typ
            cell.Exp_Work_Plc.text = Exp_Detel_Data[indexPath.row].ClstrName
            cell.Exp_From.text = Exp_Detel_Data[indexPath.row].From_place
            cell.Exp_To.text = Exp_Detel_Data[indexPath.row].To_place
            cell.Exp_Dis_KM.text = String(Exp_Detel_Data[indexPath.row].ExpDist)
            cell.Exp_Fare.text = Exp_Detel_Data[indexPath.row].Fare
            cell.Exp_Da_Typ.text = Exp_Detel_Data[indexPath.row].Da_Typ
            cell.Exp_DA_Exp.text = Exp_Detel_Data[indexPath.row].DA_Exp
            cell.Exp_Amount.text = Exp_Detel_Data[indexPath.row].Amount
            cell.Exp_DAddi.text =  Exp_Detel_Data[indexPath.row].DailyAddDeductSymb + Exp_Detel_Data[indexPath.row].DAddit
            cell.Exp_Hotal.text = Exp_Detel_Data[indexPath.row].Hotal_Bill
            cell.Exp_Total.text = Exp_Detel_Data[indexPath.row].Total
            
            if Exp_Detel_Data[indexPath.row].Satus == "Rejected" {
                // Set the text properties first
                cell.Exp_Status.text = Exp_Detel_Data[indexPath.row].Satus
                let attributedText = NSAttributedString(string: cell.Exp_Status?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                cell.Exp_Status?.attributedText = attributedText
            } else {
                cell.Exp_Status.text = Exp_Detel_Data[indexPath.row].Satus
                let attributedText = NSAttributedString(string: cell.Exp_Status?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.09, green: 0.64, blue: 0.29, alpha: 1.00)])
                cell.Exp_Status?.attributedText = attributedText
            }
            
            
        }else if (Period_TB == tableView){
            cell.lblText.text = lstOfPeriod[indexPath.row].Period_Name
        }else if (Sum_Exp == tableView){
            cell.lblText.text = Exp_Summary_Data[indexPath.row].Tit
            cell.lblText2.text = Exp_Summary_Data[indexPath.row].Amt
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = lstOfPeriod[indexPath.row]
        print(item)
       // Nav_PeriodicData = [item as AnyObject]
        Sel_Period.text = item.Period_Name
        period_id = item.Period_Id
        //Eff_Month = item.Eff_Month
        Eff_Year = item.Eff_Year
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let From_Date = item.From_Date
        period_from_date = "\(selectYear)-\(SelectMonth)-"+From_Date
        if let date = dateFormatter.date(from: "\(selectYear)-\(SelectMonth)-" + From_Date) {
            FDate = date
        } else {
            print("Error: Unable to convert string to Date")
        }
        let To_Date = item.To_Date
        if To_Date == "end of month"{
            let currentDate = FDate
            let calendar = Calendar.current
            if let monthRange = calendar.range(of: .day, in: .month, for: currentDate) {
                print(monthRange)
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
            period_to_date = "\(selectYear)-\(SelectMonth)-"+To_Date
            if let date = dateFormatter.date(from: "\(selectYear)-\(SelectMonth)-" + Per_To_Date) {
                TDate = date
            } else {
                print("Error: Unable to convert string to Date")
            }
        }
        let dateFormatterss = DateFormatter()
        dateFormatterss.dateFormat = "yyyy-MM-dd"
        let From = dateFormatterss.string(from: FDate)
        let To = dateFormatterss.string(from: TDate)
        // Convert string dates to Date objects
        if let startDate = dateFormatterss.date(from: From),
           let endDate = dateFormatterss.date(from: To) {
            let days = daysBetweenDates(startDate, endDate)
            print("Number of days between the two dates: \(days)")
            No_Of_Days_In_Perio = days + 1
        } else {
            print("Invalid date format")
        }
        TextSearch.text = ""
        
      
          ExpenseReportDetails()
      
        Sel_Period_Drop_Down.isHidden = true
    }
    func daysBetweenDates(_ startDate: Date, _ endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
    func periodic() {
        Period.removeAll()
        let axn = "get/periodicWise"
        let apiKey = "\(axn)&desig=\(Desig)&divisionCode=\(DivCode)&div_code=\(DivCode)&month=\(SelectMonth)&rSF=\(SFCode)&year=\(selectYear)&sfCode=\(SFCode)&stateCode=\(StateCode)&sf_code=\(SFCode)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)

                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any],
                                   let data = jsonObject["data"] as? [AnyObject] {
                                    for i in data {
//                                        if let divisionCode = i["Division_Code"] as? Int,
                                        
                                        var effMonth = ""
                                        if let effmont = i["Eff_Month"] as? Int{
                                            effMonth = String(effmont)
                                        }else if let effmont = i["Eff_Month"] as? String {
                                            effMonth = effmont
                                        }
                                        
                                           if let effYear = i["Eff_Year"] as? Int,
                                           let fromDate = i["From_Date"] as? String,
                                           let periodId = i["Period_Id"] as? String,
                                           let periodName = i["Period_Name"] as? String,
                                           let toDate = i["To_Date"] as? String,
                                           let disRank = i["dis_Rank"] as? String {
                                            
                                               Period.append(PeriodicDatas(Division_Code: 0, Eff_Month: Int(effMonth)!, Eff_Year: effYear, From_Date: fromDate, Period_Id: periodId, Period_Name: periodName, To_Date: toDate, dis_Rank: disRank))
                                        } else {
                                            print("Error: Some key in the data is nil or has the wrong type")
                                        }
                                    }
                                    lstOfPeriod = Period
                                    Period_TB.reloadData()
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
    
    func ExpenseReportDetails(){
        self.ShowLoading(Message: "Loading...")
        Exp_Detel_Data.removeAll()
        Exp_Summary_Data.removeAll()
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: "-"))
        var Div = DivCode
        Div = Div.replacingOccurrences(of: ",", with: "")
        let axn = "getExpenseReportDetails"
        let apiKey = "\(axn)&desig=\(Desig)&from_date=\(period_from_date)&rSF=\(SFCode)&year=\(Eff_Year)&mon=\(Eff_Month)&divisionCode=\(Div)&to_date=\(period_to_date)&sfCode=\(SFCode)&stateCode=\(StateCode)&period_id=\(period_id)&sf_code=\(SFCode)&emp_id=\(UserSetup.shared.sf_emp_id)&division_code=\(Div)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any],
                                   let data = jsonObject["exp_data"] as? [AnyObject],let data2 = jsonObject["daily_exp"] as? [AnyObject],let data3 = jsonObject["add_sub_exp"] as? [AnyObject], let data4 = jsonObject["sum_add_data"] as? [AnyObject] {
                                    print(data)
                                    for i in data{
                                        let Date = i["ADate"] as? String
                                        let Mode = i["Mot"] as? String
                                        let WType = i["WType"] as? String
                                        let WorkedPlace = i["WorkedPlace"] as? String
                                        let From = i["Town_Name"] as? String
                                        var To = ""
                                        if let TO = i["WorkedPlace"] as? String, TO != ""{
                                            To = TO
                                        }else{
                                            To = "-"
                                        }
                                        var Dis = ""
                                        if let Diskm = i["ExpDist"] as? String{
                                            Dis = Diskm
                                        }else{
                                            Dis = "0"
                                        }
                                        let Fare = i["ExpFare"] as? String
                                        let DATyp = i["DAtype"] as? String
                                        let DAExp = i["ExpDA"] as? String
                                        //let Amount =
                                        //let DAddit =
                                        let Hotal_Bill = i["Hotel_Bill_Amt"] as? String
                                        //let Total = "0.0"
                                        let status = i["Exp_Status"] as? String
                                        var DAdditionalAmnt = "0"
                                        if let DAdditionalAmt = i["DAdditionalAmnt"] as? String, DAdditionalAmt != ""{
                                            DAdditionalAmnt = DAdditionalAmt
                                        }
                                       let DailyAddDeduct = i["DailyAddDeduct"] as? String
                                        var DailyAddDeductsymb = ""
                                        if DailyAddDeduct == "ADD"{
                                            DailyAddDeductsymb = "+"
                                        }else if DailyAddDeduct == "Deduct" {
                                            DailyAddDeductsymb = "-"
                                        }else{
                                            DailyAddDeductsymb = ""
                                        }
                                        
                                        let ExpDist1 = i["ExpDist"] as? Int
                                        let ClstrName = i["ClstrName"] as? String
                                        Exp_Detel_Data.append(Exp_Data(Date: Date!, Mode: Mode!, Wok_Typ: WType!, Wok_plc: WorkedPlace!, From_place: From!, To_place: To, DisKM: Dis, Fare: Fare!, Da_Typ: DATyp!, DA_Exp: DAExp!, Amount: "0.0", DAddit:DAdditionalAmnt, Hotal_Bill: Hotal_Bill!, Total: DAExp!, Satus: status!, ExpDist: ExpDist1!,Rej_Amt:"0", ClstrName : ClstrName!,DailyAddDeduct:DailyAddDeduct!, DailyAddDeductSymb: DailyAddDeductsymb))
                                        
                                    }
                                    print(data2)
                                    var totalAmountByDate: [String: Double] = [:]
                                    for expense in data2 {
                                        guard let amt = expense["amt"] as? Int, let edate = expense["edate"] as? String else {
                                            continue
                                        }
                                        if let existingTotal = totalAmountByDate[edate] {
                                            totalAmountByDate[edate] = existingTotal + Double(amt)
                                        } else {
                                            totalAmountByDate[edate] = Double(amt)
                                        }
                                    }
                                    print(totalAmountByDate)
                                    
                                    for (date, total) in totalAmountByDate {
                                        print("Total amount for \(date): \(total)")
                                        for index in 0..<Exp_Detel_Data.count {
                                            if date == Exp_Detel_Data[index].Date{
                                               print(Exp_Detel_Data[index].Date)
                                                let bill = Double(Exp_Detel_Data[index].Hotal_Bill)
                                                let da_amt = Double(Exp_Detel_Data[index].Total)
                                                let Fare = Double(Exp_Detel_Data[index].Fare)
                                                let DAddit = Double(Exp_Detel_Data[index].DAddit)
                                                let DailyAddDeduct = Exp_Detel_Data[index].DailyAddDeduct
                                                let Total_Amt = bill! + total + Fare!
                                                Exp_Detel_Data[index].Amount = String(format: "%.2f", total)
                                            }
                                        }
                                    }
                                    for index in 0..<Exp_Detel_Data.count {
                                            let bill = Double(Exp_Detel_Data[index].Hotal_Bill)
                                            let da_amt = Double(Exp_Detel_Data[index].Total)
                                            let Fare = Double(Exp_Detel_Data[index].Fare)
                                            let Amount = Double(Exp_Detel_Data[index].Amount)
                                            
                                            let status = Exp_Detel_Data[index].Satus
                                        var Total_Amt = bill! + da_amt! + Fare! + Amount!
                                        var DAddits = 0.0
                                        if let DAddit = Double(Exp_Detel_Data[index].DAddit){
                                            DAddits = DAddits + DAddit
                                        }
                                        let DailyAddDeduct = Exp_Detel_Data[index].DailyAddDeduct
                                        print(DailyAddDeduct)
                                        print(DAddits)
                                        print(Total_Amt)
                                        if DailyAddDeduct == "ADD" || DailyAddDeduct == ""{
                                            Total_Amt = Total_Amt + DAddits
                                        }else{
                                            Total_Amt = Total_Amt - DAddits
                                        }
                                            if status == "Rejected"{
                                                Exp_Detel_Data[index].Rej_Amt = String(format: "%.2f", Total_Amt)
                                            }
                                            Exp_Detel_Data[index].Total = String(format: "%.2f", Total_Amt)
                                    }
                                    
                                    var SUM_TOTAL = 0.0
                                    var sum_Total_all = 0.0
                                    var reJ_eXP = 0.0
                                    for item in Exp_Detel_Data{
                                        let amt = Double(item.Total)
                                        print(item)
                                        let rej_amt = Double(item.Rej_Amt)
                                        reJ_eXP =  reJ_eXP + rej_amt!
                                        SUM_TOTAL = SUM_TOTAL + amt!
                                    }
                                    if SUM_TOTAL == 0.0 {
                                        Exp_Summary_Data[0].Amt = "-"
                                    }else{
                                        Exp_Summary_Data[0].Amt = String(format: "%.2f",SUM_TOTAL)
                                    }
                                    print(data3)
                                    print(data3)
                                    reJ_eXP = reJ_eXP - sum_Total_all
                                    Exp_Summary_Data.append(Exp_Sum(Tit: "Rejected Expense", Amt: String(format: "%.2f",reJ_eXP)))
                                    var total_sum = 0.0
                                    var total_ded = 0.0
                                    for item3 in data3{
                                        print(item3)
                                        let exp_amnt = Double((item3["exp_amnt"] as? String)!)
                                        if let add_sub = item3["add_sub"] as? String,add_sub == "+"{
                                            total_sum = total_sum + exp_amnt!
                                        }else{
                                            total_ded = total_ded + exp_amnt!
                                        }
                                        
                                    }
                                    print(total_sum)
                                    print(total_ded)
                                    if (data.count > 0){
                                        if(data3.count > 0){
                                            
                                        }else{
                                            print(Exp_Summary_Data.count)
                                           // Exp_Summary_Data[1].Amt = "0"
                                           // Exp_Summary_Data[2].Amt = "0"
                                        
                                        }
                                    }else{
                                        
                                        Exp_Summary_Data[1].Amt = "-"
                                       // Exp_Summary_Data[2].Amt = "-"
                                    }
                                    Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "\(total_sum)"))
                                    Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "\(total_ded)"))
                                    for datas in data4{
                                        print(datas)
                                        if let id = datas["Type"] as? Int, id == 2{
                                            let name = datas["Name"] as? String
                                            let amt = Double((datas["Amt"] as? String)!)
                                            sum_Total_all = sum_Total_all + amt!
                                            Exp_Summary_Data.append(Exp_Sum(Tit: name!, Amt: String(format: "%.2f",amt!)))
                                        }
                                    }
                                    sum_Total_all = sum_Total_all + SUM_TOTAL
                                    sum_Total_all = sum_Total_all - reJ_eXP
                                    sum_Total_all = sum_Total_all + total_sum
                                    sum_Total_all = sum_Total_all - total_ded
                                    Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: String(format: "%.2f",sum_Total_all)))
                                    print(Exp_Summary_Data)
                                    Sum_Exp.reloadData()
                                    Exp_Report_TB.reloadData()
                                    self.LoadingDismiss()
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
    func findPosition(for date: String, in dataArray: [String]) -> Int? {
        for (index, element) in dataArray.enumerated() {
            if element.contains("Date: \"\(date)\"") {
                return index
            }
        }
        return nil
    }
    
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func Open_Drop_Down_View() {
        periodic()
        Sel_Period_Drop_Down.isHidden = false
    }
    @objc private func Close_Drop_Down_View() {
        Sel_Period_Drop_Down.isHidden = true
    }
    @objc private func Show_Year_and_Month() {
        
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
        Period_TB.reloadData()
    }
    
}
