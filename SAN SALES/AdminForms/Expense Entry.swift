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
    @IBOutlet var PopUpView: UIView!
    @IBOutlet var blureView: UIVisualEffectView!
    @IBOutlet weak var MonthView: UIView!
    @IBOutlet weak var selectmonth: UILabel!
    @IBOutlet weak var ClosePopup: UILabel!
    @IBOutlet weak var YearPostion: UILabel!
    @IBOutlet weak var MonthPostion: UILabel!
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
        periodic()
        BackBT.addTarget(target: self, action: #selector(GotoHome))
        SelPeriod.addTarget(target: self, action: #selector(OpenWindo))
        selectmonth.addTarget(target: self, action: #selector(OpenPopUP))
        ClosePopup.addTarget(target: self, action: #selector(ClosePopUP))
        YearPostion.addTarget(target: self, action: #selector(OpenYear))
        MonthPostion.addTarget(target: self, action: #selector(OpenMonth))
        let monthsView = MonthsView(frame: MonthView.bounds)
            monthsView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
            MonthView.addSubview(monthsView)
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
        Nav_Exp_Form(date:date)
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
    func removeLabels(){
         for (_, label) in labelsDictionary {
             label.removeFromSuperview()
         }
         labelsDictionary.removeAll()
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
                                    exp_SubitDate = []
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
        alert.addAction(UIAlertAction(title: "OK", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "Expense") as! Expense_Entry
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "Daily_Expense_Entry") as! Daily_Expense_Entry
            viewController.setViewControllers([RptMnuVc,myDyPln], animated: false)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        })
        self.present(alert, animated: true)
    }
    func validateForm(Seldate: Date) -> Bool {
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
        animateIn(desiredView: blureView)
        animateIn(desiredView: PopUpView)
    }
    @objc private func ClosePopUP() {
        animateOut(desiredView:blureView)
        animateOut(desiredView:PopUpView)
    }
    @objc private func OpenYear() {
        let yearView = YearView(frame: MonthView.bounds)
            yearView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
            MonthView.addSubview(yearView)
    }
    @objc private func OpenMonth() {
        let monthsView = MonthsView(frame: MonthView.bounds)
            monthsView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
            MonthView.addSubview(monthsView)
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
    }
}
