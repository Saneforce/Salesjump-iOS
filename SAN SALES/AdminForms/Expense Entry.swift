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

class Expense_Entry: IViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var BackBT: UIImageView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var Selwind: UIView!
    @IBOutlet weak var SelPeriod: LabelSelect!
    @IBOutlet weak var DataTB: UITableView!
    @IBOutlet weak var TextSeh: UITextField!
    @IBOutlet var PopUpView: UIView!
    @IBOutlet var blureView: UIVisualEffectView!
    @IBOutlet weak var MonthView: UIView!
    @IBOutlet weak var selectmonth: UILabel!
    @IBOutlet weak var ClosePopup: UILabel!
    @IBOutlet weak var YearPostion: UILabel!
    @IBOutlet weak var MonthPostion: UILabel!
    @IBOutlet weak var Collection_Of_Month: UICollectionView!
    static let shared = Expense_Entry()
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
    var labelsDictionary = [FSCalendarCell: UILabel]()
    var MisDatesDatas:[Date] = []
    var exp_SubitDate:[AnyObject] = []
    var attance_flg_L: [[String: Any]] = []
    var SelectMonthPostion:String = ""
    var Monthtext_and_year: [String] = []
    var SelMod:String = "MON"
    var selectYear:String = "\(Calendar.current.component(.year, from: Date()))"
    var SelectMonth:String = ""
    var Day_Plan_Data:[AnyObject] = []
    var Set_Date:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        blureView.bounds = self.view.bounds
        PopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        PopUpView.layer.cornerRadius = 10
        getUserDetails()
        calendar.delegate=self
        calendar.dataSource=self
        DataTB.dataSource=self
        DataTB.delegate=self
        Collection_Of_Month.delegate=self
        Collection_Of_Month.dataSource=self
        periodic()
        YearPostion.text = selectYear
        let Month = Calendar.current.component(.month, from: Date()) - 1
        let formattedPosition = String(format: "%02d", Month + 1)
        SelectMonth = formattedPosition
        BackBT.addTarget(target: self, action: #selector(GotoHome))
        SelPeriod.addTarget(target: self, action: #selector(OpenWindo))
        selectmonth.addTarget(target: self, action: #selector(OpenPopUP))
        ClosePopup.addTarget(target: self, action: #selector(ClosePopUP))
        YearPostion.addTarget(target: self, action: #selector(OpenYear))
        MonthPostion.addTarget(target: self, action: #selector(OpenMonth))
        
//        let monthsView = MonthsView(frame: MonthView.bounds)
//            monthsView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
//            MonthView.addSubview(monthsView)
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
        new_DateofExpense(date: date)
        
    }

    func addLetterA(to cell: FSCalendarCell?, text:String) {
        let letterLabel = UILabel()
        letterLabel.text = text
        letterLabel.textColor = .red
        letterLabel.font = UIFont.boldSystemFont(ofSize: 14)
        letterLabel.textAlignment = .center
        letterLabel.frame = CGRect(x: 0, y: 15, width: cell?.bounds.width ?? 0, height: cell?.bounds.height ?? 0)
        cell?.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        cell?.addSubview(letterLabel)
        labelsDictionary[cell!] = letterLabel
    }
    func addDART(to cell: FSCalendarCell?,text:String) {
        let letterLabel = UILabel()
        letterLabel.text = text
        letterLabel.textColor = UIColor(red: 0.06, green: 0.68, blue: 0.76, alpha: 1.00)
        letterLabel.font = UIFont.boldSystemFont(ofSize: 50)
        letterLabel.textAlignment = .center
        letterLabel.frame = CGRect(x: 0, y: 3, width: cell?.bounds.width ?? 0, height: cell?.bounds.height ?? 0)
        cell?.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        cell?.addSubview(letterLabel)
        labelsDictionary[cell!] = letterLabel
    }
    
    func addDART_ORG(to cell: FSCalendarCell?,text:String) {
        let letterLabel = UILabel()
        letterLabel.text = text
        letterLabel.textColor = .orange
        letterLabel.font = UIFont.boldSystemFont(ofSize: 50)
        letterLabel.textAlignment = .center
        letterLabel.frame = CGRect(x: 0, y: 3, width: cell?.bounds.width ?? 0, height: cell?.bounds.height ?? 0)
        cell?.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        cell?.addSubview(letterLabel)
        labelsDictionary[cell!] = letterLabel
    }
    
    func removeLabels(){
         for (_, label) in labelsDictionary {
             label.removeFromSuperview()
         }
         labelsDictionary.removeAll()
     }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Monthtext_and_year.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        if (SelMod == "MON"){
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            if (selectYear == "\(currentYear)"){
            let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
            if indexPath.row == currentMonthIndex || indexPath.row == currentMonthIndex - 1 {
                cell.lblText.text = Monthtext_and_year[indexPath.row]
                MonthPostion.text = Monthtext_and_year[indexPath.row]
                let attributedText = NSAttributedString(string: cell.lblText?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                cell.lblText?.attributedText = attributedText
            } else {
                cell.lblText.text = Monthtext_and_year[indexPath.row]
                let attributedText = NSAttributedString(string: cell.lblText?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                cell.lblText?.attributedText = attributedText
            }
            }else{
                if indexPath.row == 11 {
                    cell.lblText.text = Monthtext_and_year[indexPath.row]
                    MonthPostion.text = Monthtext_and_year[11]
                    let attributedText = NSAttributedString(string: cell.lblText?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                    cell.lblText?.attributedText = attributedText
                } else {
                    cell.lblText.text = Monthtext_and_year[indexPath.row]
                    let attributedText = NSAttributedString(string: cell.lblText?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    cell.lblText?.attributedText = attributedText
                }
            }
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
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-yyyy"
                if let date = dateFormatter.date(from: "\(SelectMonth)-\(selectYear)") {
                    FDate = date
                    TDate = date
                }
                selectmonth.text = "\(item)-\(selectYear)"
                SelPeriod.text = "Select Period"
                removeLabels()
                calendar.reloadData()
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
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let previousYear = currentYear - 1
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        if (currentMonthIndex == 0){
            Monthtext_and_year = [String(previousYear),String(currentYear)]
        }else{
            Monthtext_and_year = [String(currentYear)]
        }
        Collection_Of_Month.reloadData()
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
        let item = Period[indexPath.row]
        removeLabels()
        SelPeriod.text = item.Period_Name
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
        let apiKey = "\(axn)&desig=\(Desig)&divisionCode=\(DivCode)&div_code=\(DivCode)&month=\(SelectMonth)&rSF=\(SFCode)&year=\(selectYear)&sfCode=\(SFCode)&stateCode=\(StateCode)&sf_code=\(SFCode)"
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
        let apiKey = "\(axn)&desig=\(Desig)&divisionCode=\(DivCode)&from_date=\(period_from_date)&to_date=\(period_to_date)&month=\(SelectMonth)&rSF=\(SFCode)&year=\(selectYear)&selected_period=58&sfCode=\(SFCode)&stateCode=\(StateCode)&sf_code=\(SFCode)"
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
                                    exp_SubitDate = []
                                    attance_flg_L = []
                                    if let attance_flg = jsonObject["attance_flg"] as?  [[String: Any]]{
                                        print(attance_flg)
                                        if attance_flg.isEmpty{
                                            MisDatesDatas = []
                                            return
                                        }
                                        
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "dd/MM/yyyy"
                                        let dates = attance_flg.compactMap { dictionary -> Date? in
                                            guard let dateString = dictionary["pln_date"] as? String else { return nil }
                                            return dateFormatter.date(from: dateString)
                                        }
                                        for item in attance_flg{
                                            let datess = item["pln_date"] as? String
                                            let Formated_Date = dateFormatter.date(from: datess!)
                                            let Leave = item["FWFlg"] as? String
                                            if (Leave == "L"){
                                                attance_flg_L = attance_flg
                                                let cell = calendar.cell(for: Formated_Date!, at: .current)
                                                addLetterA(to: cell, text: "L")
                                            }
                                            if (Leave == "H"){
                                                attance_flg_L = attance_flg
                                                let cell = calendar.cell(for: Formated_Date!, at: .current)
                                                addLetterA(to: cell, text: "H")
                                            }
                                        }
                                        
                                        let startDate = dates.min() ?? Date()
                                        let endDate = dates.max() ?? Date()

                                        var allDates = [Date]()
                                        var currentDate = startDate

                                        while currentDate <= endDate {
                                            allDates.append(currentDate)
                                            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                                        }
                                        let missingDates = allDates.filter { !dates.contains($0) }
                                        print(missingDates)
                                        MisDatesDatas = missingDates
                                        missingDates.forEach {
                                            print(dateFormatter.string(from: $0))
                                            let missingDates = dateFormatter.string(from: $0)
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "dd/MM/yyyy"
                                                if let missingDate = formatter.date(from: missingDates) {
                                                    print(missingDate)
                                                    let cell = calendar.cell(for: missingDate, at: .current)
                                                    addLetterA(to: cell, text: "A")
                                                } else {
                                                    print("Error: Unable to convert string to date.")
                                                }
                                        }
                                        
                                    }
                                    // exp_submit
                                    if let ExpDate = jsonObject["exp_submit"] as? [AnyObject] {
                                        print(ExpDate)
                                        exp_SubitDate = ExpDate
                                        print(exp_SubitDate)
                                    }
                                    if let exp_submit = jsonObject["exp_submit"] as? [[String: Any]]{
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
                                    // srt_end_exp
                                    if let srt_end_exp = jsonObject["srt_end_exp"] as? [[String: Any]]{
                                        for i in srt_end_exp {
                                            if let dateString = i["full_date"] as? String {
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "dd/MM/yyyy"
                                                
                                                if let date = dateFormatter.date(from: dateString) {
                                                    let cell = calendar.cell(for: date, at: .current)
                                                    addDART_ORG(to: cell, text: ".")
                                                } else {
                                                    print("Failed to convert \(dateString) to Date.")
                                                }
                                            } else {
                                                print("Date string is nil or not in the expected format.")
                                            }
                                        }
                                    }
                                    //rej_exp
                                    if let rej_exp = jsonObject["rej_exp"] as? [[String: Any]]{
                                        for i in rej_exp {
                                            if let dateString = i["full_date"] as? String {
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "dd/MM/yyyy"
                                                
                                                if let date = dateFormatter.date(from: dateString) {
                                                    let cell = calendar.cell(for: date, at: .current)
                                                    addLetterA(to: cell, text: "R")
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
    func Nav_Exp_Form(date:Date){
        if validateForm(Seldate: date) == false {
            return
        }
        let alert = UIAlertController(title: "Confirm Selection", message: "Do you want to submit expense ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        alert.addAction(UIAlertAction(title: "OK", style: .destructive) { [self] _ in
            self.dismiss(animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "Expense") as! Expense_Entry
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "Daily_Expense_Entry") as! Daily_Expense_Entry
            myDyPln.day_Plan = Day_Plan_Data
            myDyPln.set_Date = Set_Date
            viewController.setViewControllers([RptMnuVc,myDyPln], animated: false)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        })
        self.present(alert, animated: true)
    }
    func validateForm(Seldate: Date) -> Bool {
        
        let currentDate = Date()
          if Seldate > currentDate {
              return false
          }
        
        for item in MisDatesDatas {
            if item == Seldate {
                Toast.show(message: "Please Select a Valid Date")
                return false
            }
        }
        
        for item in exp_SubitDate {
            let dates = item["full_date"] as? String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let dateString = dates, let exdate = dateFormatter.date(from: dateString) {
                if exdate == Seldate {
                    Toast.show(message: "Expense Already Submitted")
                    return false
                }
            }
        }
        for item in attance_flg_L{
            let dates = item["pln_date"] as? String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if item["FWFlg"] as? String == "L"{
                if let dateString = dates, let exdate = dateFormatter.date(from: dateString) {
                    if exdate == Seldate {
                        Toast.show(message: "Please Select a Valid Date")
                        return false
                    }
                }
            }
            if item["FWFlg"] as? String == "H"{
                if let dateString = dates, let exdate = dateFormatter.date(from: dateString) {
                    if exdate == Seldate {
                        Toast.show(message: "Please Select a Valid Date")
                        return false
                    }
                }
            }
        }
        
        return true
    }

    @objc private func GotoHome() {
        let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbAdminMnu") as! AdminMenus;()
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    @objc private func OpenWindo() {
        Selwind.isHidden = false
    }
    @objc private func OpenPopUP() {
        MonthaObj()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
       let Month = dateFormatter.shortMonthSymbols
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        MonthPostion.text = Month![currentMonthIndex]
        animateIn(desiredView: blureView)
        animateIn(desiredView: PopUpView)
    }
    @objc private func ClosePopUP() {
        animateOut(desiredView:blureView)
        animateOut(desiredView:PopUpView)
    }
    @objc  func OpenYear() {
//        let yearView = YearView(frame: MonthView.bounds)
//            yearView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
//            MonthView.addSubview(yearView)
        SelMod = "YEAR"
        yearobj()
    }
    @objc func OpenMonth() {
//        let monthsView = MonthsView(frame: MonthView.bounds)
//        monthsView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
//        MonthView.addSubview(monthsView)
        SelMod = "MON"
        MonthaObj()
        
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
    func new_DateofExpense(date:Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myStringDate = formatter.string(from: date)
        print(myStringDate)
        Set_Date = myStringDate
        let axn = "get/new_DateofExpense"
        let apiKey = "\(axn)&State_Code=\(StateCode)&desig=\(Desig)&divisionCode=\(DivCode)&Type=1&div_code=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)&Dateofexp=\(myStringDate)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        //self.ShowLoading(Message: "Loading...")
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    print(value)
                    //self.LoadingDismiss()
                    if let json = value as? [String: Any] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)
                                
                                    

                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any],
                                   let data = jsonObject["day_plan"] as? [AnyObject] {
                                    print(data)
                                    if data.isEmpty{
                                        Toast.show(message: "Please Select a Valid Date")
                                        return
                                    }else{
                                        Day_Plan_Data = data
                                        Nav_Exp_Form(date:date)
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
    
}

class MonthsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMonthsView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMonthsView()
    }
    private func setupMonthsView(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let monthLabels = dateFormatter.shortMonthSymbols
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        print(currentMonthIndex)
        Expense_Entry.shared.SelectMonthPostion = "0\(currentMonthIndex+1)"
        UserSetup.shared.CurentMonthPostion = currentMonthIndex
        let rows = 3
        let columns = 4
        let labelWidth = bounds.width / CGFloat(columns)
        let labelHeight = bounds.height / CGFloat(rows)
        
        for (index, month) in monthLabels!.enumerated() {
            let row = index / columns
            let column = index % columns
            
            let label = UILabel()
            label.text = month
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            
            label.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(row) * labelHeight).isActive = true
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(column) * labelWidth).isActive = true
            label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
            label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
            
            if index == currentMonthIndex || index == currentMonthIndex - 1 {
                label.textColor = .black
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(monthTapped(_:)))
                label.addGestureRecognizer(tapGestureRecognizer)
                label.tag = index
            } else {
                label.textColor = .lightGray
            }
        }
    }
    
    @objc private func monthTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        let monthLabels = DateFormatter().monthSymbols
        let selectedMonth = monthLabels![index]
        let WhichMonth = index + 1
        Expense_Entry.shared.SelectMonthPostion = "0\(WhichMonth)"
        Expense_Entry.shared.periodic()
        print("Selected month: \(selectedMonth)")
    }
}

class YearView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupYearView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupYearView()
    }
    private func setupYearView(){
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let previousYear = currentYear - 1
        let rows = 3
        let columns = 4
        let labelWidth = bounds.width / CGFloat(columns)
        let labelHeight = bounds.height / CGFloat(rows)
        let yearsArray: [String]
        
        if (UserSetup.shared.CurentMonthPostion == 0) {
            yearsArray = [String(previousYear), String(currentYear)]
        } else {
            yearsArray = [String(currentYear)]
        }
        
        for (index, year) in yearsArray.enumerated() {
            let row = index / columns
            let column = index % columns
            
            let label = UILabel()
            label.text = year
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            
            // Constraints
            label.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(row) * labelHeight).isActive = true
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(column) * labelWidth).isActive = true
            label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
            label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(YearTapped(_:)))
            label.addGestureRecognizer(tapGestureRecognizer)
            label.tag = index
        }
    }
    @objc private func YearTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let previousYear = currentYear - 1
        let yearsArray: [String]
        if (UserSetup.shared.CurentMonthPostion == 0) {
            yearsArray = [String(previousYear), String(currentYear)]
        } else {
            yearsArray = [String(currentYear)]
        }
        let selectedMonth = yearsArray[index]
        print("Selected month: \(selectedMonth)")
       // Expense_Entry.shared.OpenView()
    }
    
}

