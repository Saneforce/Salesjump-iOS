//
//  Expense View SFC.swift
//  SAN SALES
//
//  Created by Anbu j on 22/07/24.
//

import UIKit
import Alamofire
import FSCalendar
class Expense_View_SFC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet weak var YearPostion: UILabel!
    @IBOutlet weak var MonthPostion: UILabel!
    @IBOutlet weak var Sel_Date: UILabel!
    @IBOutlet weak var Sel_Period: UILabel!
    
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var MonthView: UIView!
    @IBOutlet weak var PeriodicView: UIView!
    @IBOutlet weak var SummaryView: UIView!
    @IBOutlet weak var SFC_Data_TB: UITableView!
    @IBOutlet weak var Summary_TB: UITableView!
    @IBOutlet var blureView: UIVisualEffectView!
    @IBOutlet var PopUpView: UIView!
    @IBOutlet weak var Collection_Of_Month: UICollectionView!
    @IBOutlet weak var Period_TB: UITableView!
    @IBOutlet weak var Sel_Period_Drop_Down: UIView!
    @IBOutlet weak var Close_Pop_Up: UILabel!
    @IBOutlet weak var TextSearch: UITextField!
    
    @IBOutlet weak var Close_Drop_Down: UIButton!
    
    
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
    
    struct Exp_Sum:Codable{
        let Tit:String
        var Amt:String
    }
    var Exp_Summary_Data:[Exp_Sum] = []
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = "",SF_type: String = ""
    let LocalStoreage = UserDefaults.standard
    let cardViewInstance = CardViewdata()
    var Monthtext_and_year: [String] = []
    var SelMod:String = "MON"
    var selectYear:String = "\(Calendar.current.component(.year, from: Date()))"
    var labelsDictionary = [FSCalendarCell: UILabel]()
    var Period:[PeriodicDatas] = []
    var lstOfPeriod:[PeriodicDatas] = []
    var SelectMonth:String = ""
    var SelectMonthPostion:String = ""
    var FDate: Date = Date(),TDate: Date = Date()
    var No_Of_Days_In_Perio = 0
    var period_from_date = ""
    var period_to_date = ""
    var period_id = ""
    var Eff_Month="", Eff_Year=0
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        SFC_Data_TB.delegate = self
        SFC_Data_TB.dataSource = self
        Summary_TB.delegate = self
        Summary_TB.dataSource = self
        Collection_Of_Month.delegate=self
        Collection_Of_Month.dataSource=self
        Period_TB.delegate=self
        Period_TB.dataSource=self
        blureView.bounds = self.view.bounds
        PopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        PopUpView.layer.cornerRadius = 10
        cardViewInstance.styleSummaryView(MonthView)
        cardViewInstance.styleSummaryView(PeriodicView)
        cardViewInstance.styleSummaryView(SummaryView)
        
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        Sel_Period.addTarget(target: self, action: #selector(Open_Drop_Down_View))
        Sel_Date.addTarget(target: self, action: #selector(OpenPopUP))
        Close_Pop_Up.addTarget(target: self, action: #selector(ClosePopUP))
        YearPostion.addTarget(target: self, action: #selector(OpenYear))
        MonthPostion.addTarget(target: self, action: #selector(OpenMonth))
        ExpenseReportDetailsSFC()
        Close_Drop_Down.addTarget(target: self, action: #selector(Close_Drop_Down_View))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "-"))
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
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
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
                    Exp_Summary_Data.removeAll()
                    Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: "-"))
                    Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "-"))
                    Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "-"))
                    Exp_Summary_Data.append(Exp_Sum(Tit: "Rejected Expense", Amt: "-"))
                    Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: "-"))
                    Summary_TB.reloadData()
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
        if SFC_Data_TB == tableView {return 450}
        if Period_TB == tableView {return 50}
        if Summary_TB == tableView {return 30}
            
        
        return 0
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SFC_Data_TB == tableView {return 10}
        if Period_TB == tableView {return lstOfPeriod.count}
        if Summary_TB == tableView {return Exp_Summary_Data.count}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        
        if SFC_Data_TB == tableView {
            cardViewInstance.styleSummaryView(cell.Card_View)
        }else if Summary_TB == tableView {
            cell.lblText.text = Exp_Summary_Data[indexPath.row].Tit
            cell.lblText2.text = Exp_Summary_Data[indexPath.row].Amt
        }else if Period_TB == tableView{
            cell.lblText.text = lstOfPeriod[indexPath.row].Period_Name
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
        
      
        ExpenseReportDetailsSFC()
      
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

    
    @objc private func Open_Drop_Down_View() {
        periodic()
        Sel_Period_Drop_Down.isHidden = false
    }
    
    func ExpenseReportDetailsSFC(){
        let apiKey: String = "getExpenseReportDetailsSFC&sf_code=\(SFCode)&division_code=\(DivCode)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL2 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
            case .success(let value):
                print(value)
                if let json = value as? [String:AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    
                    do {
                        let json = try! JSON(data: AFdata.data!)
                        print(json)
                    }catch{
                        
                    }
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    @objc private func Close_Drop_Down_View() {
        Sel_Period_Drop_Down.isHidden = true
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
