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
    @IBOutlet weak var ViewDet_TB: UITableView!
    @IBOutlet weak var Detiles_View: UIView!
    @IBOutlet weak var Detils_View_Close_BT: UIButton!
    @IBOutlet weak var Mod_of_tra_TB: UITableView!
    @IBOutlet weak var StausView: UIView!
    @IBOutlet weak var Exp_Det_View: UIView!
    @IBOutlet weak var Mod_of_trv_tb_Hig: NSLayoutConstraint!
    @IBOutlet weak var Lab_hig: UIView!
    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var ScrollView_Hig: NSLayoutConstraint!
    @IBOutlet weak var Card_View_Hig: NSLayoutConstraint!
    @IBOutlet weak var lab_layuot_hig: NSLayoutConstraint!
    @IBOutlet weak var Exp_Det_View_hig: NSLayoutConstraint!
    @IBOutlet weak var Status_View_Hig: NSLayoutConstraint!
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
    
    struct ExpenseDatas:Any{
        let date:String
        var miscellaneous_exp:String
        var Total_Amt:String
        let SFCdetils:[AnyObject]
    }
    var ExpenseDetils:[ExpenseDatas] = []
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
    var Selected_data:[ExpenseDatas] = []
    var lstHQs: [AnyObject] = []
    var lstdiskm: [AnyObject] = []
    override func viewDidLoad(){
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
        ViewDet_TB.delegate=self
        ViewDet_TB.dataSource=self
        Mod_of_tra_TB.delegate=self
        Mod_of_tra_TB.dataSource=self
        blureView.bounds = self.view.bounds
        PopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        PopUpView.layer.cornerRadius = 10
        StausView.layer.cornerRadius = 8
        StausView.layer.masksToBounds = true
        Exp_Det_View.layer.cornerRadius = 8
        Exp_Det_View.layer.masksToBounds = true
        
        
        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list;
            
        }
        
        
        cardViewInstance.styleSummaryView(MonthView)
        cardViewInstance.styleSummaryView(PeriodicView)
        cardViewInstance.styleSummaryView(SummaryView)
        cardViewInstance.styleSummaryView(Detils_View_Close_BT)
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        Sel_Period.addTarget(target: self, action: #selector(Open_Drop_Down_View))
        Sel_Date.addTarget(target: self, action: #selector(OpenPopUP))
        Close_Pop_Up.addTarget(target: self, action: #selector(ClosePopUP))
        YearPostion.addTarget(target: self, action: #selector(OpenYear))
        MonthPostion.addTarget(target: self, action: #selector(OpenMonth))
        Close_Drop_Down.addTarget(target: self, action: #selector(Close_Drop_Down_View))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: "-"))
        
        Mod_of_trv_tb_Hig.constant = 0
        print(StausView.frame.size.height)
        print(Exp_Det_View.frame.size.height)
        print(Lab_hig.frame.size.height)
        print(CardView.frame.size.height)
        print(Card_View_Hig.constant)
        
        
        getExpenseDisSFC() { [self] disEnrty in
            if let disEnrty = disEnrty {
                print(disEnrty)
                lstdiskm = disEnrty
                print(lstdiskm)
            } else {
                print("Failed to get disEnrty")
            }
        }
        
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
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
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
        if ViewDet_TB == tableView {return 100}
        if Mod_of_tra_TB == tableView {return 80}
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SFC_Data_TB == tableView {return ExpenseDetils.count}
        if Period_TB == tableView {return lstOfPeriod.count}
        if Summary_TB == tableView {return Exp_Summary_Data.count}
        if ViewDet_TB == tableView{return ExpenseDetils.count}
        if Mod_of_tra_TB == tableView{
            print(Selected_data)
            if !Selected_data.isEmpty{
                let SFCdetils_data = Selected_data[0].SFCdetils
                Mod_of_trv_tb_Hig.constant = CGFloat(SFCdetils_data.count * 40)
                let Fix_height = lab_layuot_hig.constant + Card_View_Hig.constant + CGFloat(SFCdetils_data.count) * 40.0
                Exp_Det_View_hig.constant = Fix_height + 30
                ScrollView_Hig.constant = Status_View_Hig.constant + Fix_height + 30
                let Fixed_Scroll_Hight = Status_View_Hig.constant + Fix_height + 30
                print(Fixed_Scroll_Hight)
                if Fixed_Scroll_Hight < 700 {
                    print("750")
                }
                
                return SFCdetils_data.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        
        if SFC_Data_TB == tableView {
            cardViewInstance.styleSummaryView(cell.Card_View)
            cell.Exp_Date.text = ExpenseDetils[indexPath.row].date
            print(ExpenseDetils[indexPath.row].SFCdetils)
        }else if ViewDet_TB == tableView {
            cell.Status.text = "Expense Submitted"
            cell.item.text = ExpenseDetils[indexPath.row].Total_Amt
            cell.Date.text = ExpenseDetils[indexPath.row].date
            cell.ViewBT.tag = indexPath.row
            cell.ViewBT.addTarget(self, action: #selector(View_Det(_:)), for: .touchUpInside)
            
        }else if Summary_TB == tableView {
            cell.lblText.text = Exp_Summary_Data[indexPath.row].Tit
            cell.lblText2.text = Exp_Summary_Data[indexPath.row].Amt
        }else if Period_TB == tableView{
            cell.lblText.text = lstOfPeriod[indexPath.row].Period_Name
        }else if Mod_of_tra_TB == tableView{
            let getitem = Selected_data[0].SFCdetils
            print(getitem)
            let Fromplace = getitem[indexPath.row]["fromplace"] as? String ?? ""
            let Toplace = getitem[indexPath.row]["Toplace"] as? String ?? ""
            let Mod_of_Travel =  getitem[indexPath.row]["modeoftravel"] as? String ?? ""
            let Km = getitem[indexPath.row]["Dist"] as? String ?? ""
            cell.Fromlbsfc.text = Fromplace
            cell.TolblSFC.text = Toplace
            cell.Mod_of_trv_SFC.text = Mod_of_Travel
            cell.Km_sfc.text = Km
            cell.Fare_sfc.text = ""
            cell.Amount_sfc.text = ""
        }
        return cell
    }
    
    @objc func View_Det(_ sender: UIButton) {
//        Selected_data.removeAll()
//        Selected_data.append(ExpenseDetils[sender.tag])
//        Mod_of_tra_TB.reloadData()
//        Detiles_View.isHidden = false
        
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        let myDyPln = storyboard.instantiateViewController(withIdentifier: "SFC_Details_View") as! SFC_Details_View
        myDyPln.viewdetils = ExpenseDetils[sender.tag]
        viewController.setViewControllers([myDyPln], animated: false)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Period_TB == tableView {
            let item = lstOfPeriod[indexPath.row]
            print(item)
            // Nav_PeriodicData = [item as AnyObject]
            Sel_Period.text = item.Period_Name
            period_id = item.Period_Id
            Eff_Month = String(item.Eff_Month)
            Eff_Year = item.Eff_Year
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let From_Date = item.From_Date
            period_from_date = "\(Eff_Year)-\(Eff_Month)-"+From_Date
            if let date = dateFormatter.date(from: "\(Eff_Year)-\(Eff_Month)-" + From_Date) {
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
            ExpenseReportDetailsSFC(fromdate: From, todate: To)
            
            Sel_Period_Drop_Down.isHidden = true
        }else if ViewDet_TB == tableView {
            print("Test")
        }
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
    func ExpenseReportDetailsSFC(fromdate:String,todate:String){
        let apiKey: String = "getExpenseReportDetailsSFC&sf_code=\(SFCode)&division_code=\(DivCode)&from_date=\(fromdate)&to_date=\(todate)&stateCode=\(StateCode)&Design_code=\(UserSetup.shared.dsg_code)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL2 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
            case .success(let value):
                print(value)
                if let json = value as? [String:AnyObject] {
                    print(json)
                    if let getdata = json["data"] as? [AnyObject], let DistanceEntr = json["DistanceEntr"] as? [AnyObject],let dailyExpense = json["dailyExpense"] as? [AnyObject], let Mot_Exp = json["Mot_Exp"] as? [AnyObject]{
                        print(getdata)
                        var subdates = [String]()
                        var FilterDisKms:[AnyObject] = []
                        var sf_code_data:String = ""
                        var miscellaneous_exp:String = "0"
                        var modeid:String = ""
                        var per_km_fare:String = ""
                        var Km_fare:String = ""
                        var Total_amts:Double = 0.0
                        for item in getdata {
                            print(item)
                            var Date = ""
                            let dateTimeString = item["Date_Time"] as? String ?? "2024-07-01 09:41:38"
                            let inputDateFormat = "yyyy-MM-dd HH:mm:ss"
                            let outputDateFormat = "yyyy-MM-dd"
                            let inputDateFormatter = DateFormatter()
                            inputDateFormatter.dateFormat = inputDateFormat
                            if let date = inputDateFormatter.date(from: dateTimeString) {
                                let outputDateFormatter = DateFormatter()
                                outputDateFormatter.dateFormat = outputDateFormat
                                let dateString = outputDateFormatter.string(from: date)
                                Date = dateString
                                subdates.append(Date)
                                print(dateString)
                            } else {
                                print("Invalid date-time string")
                            }
                            
                        }
                        let uniqueSubdatesSet = Set(subdates)
                        let uniqueSubdatesArray = Array(uniqueSubdatesSet)
                        let sortedUniqueSubdatesArray = uniqueSubdatesArray.sorted()
                        print(sortedUniqueSubdatesArray)
                        
                        for item in sortedUniqueSubdatesArray {
                            var SFCDetils: [AnyObject] = []
                            let filteredData = getdata.filter {
                                if let dateTime = $0["Date_Time"] as? String {
                                    return dateTime.contains(item)
                                }
                                return false
                            }
                            print(filteredData)
                           
                            for data in filteredData {
                                print(data)
                                var Dis_Km = 0
                                var From_Place = ""
                                var To_place = ""
                                let date = data["Date_Time"] as? String ?? ""
                                let MOT_Name = data["MOT_Name"] as? String ?? ""
                                let To_Place = data["To_Place"] as? String ?? ""
                                let to_place_id = data["To_Place_Id"] as? String ?? ""
                                let Fromdat = lstHQs.filter{ $0["id"] as? String == data["From_Place"] as? String}
                                print(Fromdat)
                              if UserSetup.shared.SF_type == 2{
                                if Fromdat.isEmpty {
                                    From_Place = data["From_Place"] as? String ?? ""
                                    modeid = data["MOT"] as? String ?? ""
                                    for i in FilterDisKms{
                                        if From_Place == To_Place{
                                            Dis_Km = i["Distance_KM"] as? Int ?? 0
                                        }else{
                                            let BasLevelFilter = FilterDisKms.filter {
                                                $0["To_Plc_Code"] as? String == To_Place &&
                                                $0["Frm_Plc_Code"] as? String == sf_code_data
                                            }
                                            
                                            if BasLevelFilter.isEmpty{
                                                Dis_Km = 0
                                            }else{
                                                Dis_Km = BasLevelFilter[0]["Distance_KM"] as? Int ?? 0
                                            }
                                        }
                                    }
                                }else{
                                    print(Fromdat)
                                    From_Place = Fromdat[0]["name"] as? String ?? ""
                                    let FilterDis = DistanceEntr.filter{ $0["To_Plc_Code"] as? String == data["From_Place"] as? String}
                                    Dis_Km = FilterDis[0]["Distance_KM"] as? Int ?? 0
                                    let Frm_Plc_Code = data["From_Place"] as? String ?? SFCode
                                    modeid = data["MOT"] as? String ?? ""
                                    let FilterDisKm = lstdiskm.filter{ $0["Sf_code"] as? String == Frm_Plc_Code}
                                    sf_code_data = Frm_Plc_Code
                                    print(FilterDisKm)
                                    FilterDisKms = FilterDisKm
                                    print(FilterDisKms)
                                    for i in FilterDisKm {
                                        if let Frm_Plc_Code = i["Frm_Plc_Code"] as? String,
                                           let To_Plc_Code = i["To_Plc_Code"] as? String {
                                            if data["From_Place"] as? String == Frm_Plc_Code && data["To_Place"] as? String == To_Plc_Code {
                                                let Dis = i["Distance_KM"] as? Int ?? 0
                                                Dis_Km = Dis_Km + Dis
                                            } else {
                                                print("No data")
                                            }
                                        }
                                    }
                                }
                              }else{
                                  print(data)
                                  modeid = data["MOT"] as? String ?? ""
                                  print(modeid)
                                  From_Place = data["From_Place"] as? String ?? ""
                                  sf_code_data = SFCode
                                  if Fromdat.isEmpty{
                                     
                                      print(DistanceEntr)
                                      for i in DistanceEntr{
                                          print(i)
                                          if From_Place == i["Frm_Plc_Code"] as? String && To_Place ==  i["To_Plc_Code"] as? String{
                                              Dis_Km = i["Distance_KM"] as? Int ?? 0
                                          }
//                                          else{
//                                              print(DistanceEntr)
//                                              let BasLevelFilter = DistanceEntr.filter {
//                                                  $0["To_Plc_Code"] as? String == To_Place &&
//                                                  $0["Frm_Plc_Code"] as? String == sf_code_data
//                                              }
//                                              
//                                              print(BasLevelFilter)
//                                              if BasLevelFilter.isEmpty{
//                                                  Dis_Km = 0
//                                              }else{
//                                                  Dis_Km = BasLevelFilter[0]["Distance_KM"] as? Int ?? 0
//                                              }
//                                          }
                                      }
                                  }else{
                                      let BasLevelFilter = DistanceEntr.filter {
                                          $0["To_Plc_Code"] as? String == To_Place &&
                                          $0["Frm_Plc_Code"] as? String == sf_code_data
                                      }
                                      if BasLevelFilter.isEmpty{
                                          Dis_Km = 0
                                      }else{
                                          Dis_Km = BasLevelFilter[0]["Distance_KM"] as? Int ?? 0
                                      }
                                  }
                              }
                                
                                let Mot_Filter_Exp = Mot_Exp.filter{$0["MOT_ID"] as? Int == Int(modeid) }
                                if Mot_Filter_Exp.isEmpty{
                                    per_km_fare = "0.0"
                                    Km_fare = "0.0"
                                }else{
                                    let ful_charge = Mot_Filter_Exp[0]["Fuel_Charge"] as? Double ?? 0.0
                                    per_km_fare = String(ful_charge)
                                    
                                    let Total_amt = Double(Dis_Km) * ful_charge
                                    print(Total_amt)
                                     Km_fare = String(format: "%.2f", Total_amt)
                                    Total_amts =  Total_amts + Total_amt
                                }
                                
                                
                                let itms: [String: Any]=["date": date,"modeoftravel":MOT_Name,"modeid":modeid,"fromplace":From_Place,"Toplace":To_Place,"Fromid":"","Toid":to_place_id,"Dist":Dis_Km,"per_km_fare":per_km_fare,"fare":Km_fare];
                                let jitm: AnyObject = itms as AnyObject
                                SFCDetils.append(jitm)
                            }
                            
                            ExpenseDetils.append(ExpenseDatas(date: item,miscellaneous_exp:miscellaneous_exp, Total_Amt: String(Total_amts), SFCdetils:SFCDetils))
                        }
                        print(ExpenseDetils)
                        for (index, Detils) in ExpenseDetils.enumerated() {
                            let filter = dailyExpense.filter { $0["date"] as? String == Detils.date }
                            print(filter)
                            if filter.isEmpty{
                                ExpenseDetils[index].miscellaneous_exp = "0"
                            }else{
                                //ExpenseDetils[index].miscellaneous_exp = String(filter[0]["amt"] as? Double ?? 0)
                                if let amt = filter[0]["amt"] as? Double {
                                    ExpenseDetils[index].miscellaneous_exp = String(amt)
                                    
                                    if let totalAmt = Double(ExpenseDetils[index].Total_Amt) {
                                        let newTotalAmt = totalAmt + amt
                                        ExpenseDetils[index].Total_Amt = String(format: "%.2f", newTotalAmt)
                                    } else {
                                        ExpenseDetils[index].Total_Amt = String(amt)
                                    }
                                } else {
                                    // Handle the case where filter[0]["amt"] is not a valid Double
                                    ExpenseDetils[index].miscellaneous_exp = "0"
                                }

                            }
                            
                        }
                        print(ExpenseDetils)
                        ViewDet_TB.reloadData()
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
    
    @IBAction func Close_Detiles_View(_ sender: Any) {
        Detiles_View.isHidden = true
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
    
    func getExpenseDisSFC(completion: @escaping ([AnyObject]?) -> Void) {
        self.ShowLoading(Message: "Please Wait...")
        let axn = "getExpenseDisSFC"
        let apiKey = "\(axn)&sf_code=\("")"
        var result = apiKey
        if let lastCommaIndex = result.lastIndex(of: ",") {
            result.remove(at: lastCommaIndex)
        }
        let apiKeyWithoutCommas = result.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL2 + apiKeyWithoutCommas
        
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: AnyObject],
                       let disEnrty = json["DistanceEntr"] as? [AnyObject] {
                        completion(disEnrty)
                        self.LoadingDismiss()
                    } else {
                        completion(nil)
                        self.LoadingDismiss()
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription ?? "Unknown Error")
                    completion(nil)
                    self.LoadingDismiss()
                }
            }
    }

}
