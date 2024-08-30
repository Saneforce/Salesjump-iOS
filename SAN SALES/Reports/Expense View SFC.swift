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
    struct MgrRout:Any{
        var date:String
        var Routs:String
        var ClusterName:String
        var Mot_Name:String
        var Mot_ID:String
        var Fuel_amount: Double
        var Miscellaneous_amount: Double
        var Work_typ:String
        var status:String
        var Place_Types:String
        var sf_hq:String
        var HQ_Allowance_amount:Double
        var EX_Allowance_amount:Double
        var OS_Allowance_amount:Double
    }
    var mgrRouts:[MgrRout] = []
    
    struct ExpenseDatas:Any{
        let date:String
        let Work_typ:String
        var miscellaneous_exp:String
        var Total_Amt:String
        let Returnkm:String
        let Plc_typ:String
        let Fuel_amount:String
        let Mot_Name:String
        let status:String
        var Da_amount:String
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
    var Get_Sf_Typ:Int = 0
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
        
        set_priod_calendar()
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
    
    func set_priod_calendar(){
        if let data = UserDefaults.standard.data(forKey: "periodicData"),
           let item = try? JSONDecoder().decode(PeriodicData.self, from: data) {
            print(item)
            let item = item
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
            }else{
                print("Invalid date format")
            }
            TextSearch.text = ""
            ExpenseReportDetailsSFC(fromdate: From, todate: To)
        }
    }
    
    @objc private func GotoHome() {
        UserDefaults.standard.removeObject(forKey: "periodicData")
        UserDefaults.standard.removeObject(forKey: "periodicDataapr")
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
            let calendars = Calendar.current
            
            let currentYear = calendars.component(.year, from: Date())
            if (selectYear == "\(currentYear)"){
                let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
                if indexPath.row == currentMonthIndex || indexPath.row == currentMonthIndex - 1{
                    if let position = Monthtext_and_year.firstIndex(where: { $0 == item }) {
                        let formattedPosition = String(format: "%02d", position + 1)
                        SelectMonth = formattedPosition
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
                                          Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: "-"))
                                          Summary_TB.reloadData()
                                      }
                                      
                                      Sel_Date.text = "\(item)-\(selectYear)"
                                      removeLabels()
                                      ClosePopUP()
                    }
                }
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
        print(Monthtext_and_year)
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
        
        print(Monthtext_and_year)
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
        }else if ViewDet_TB == tableView{
            cell.Status.text = ExpenseDetils[indexPath.row].status
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
        myDyPln.Sf_Typ = Get_Sf_Typ
        myDyPln.viewdetils = ExpenseDetils[sender.tag]
        viewController.setViewControllers([myDyPln], animated: false)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Period_TB == tableView {
            let item = lstOfPeriod[indexPath.row]
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(item){
                UserDefaults.standard.set(encoded, forKey: "periodicData")
            }
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
        ExpenseDetils.removeAll()
        mgrRouts.removeAll()
        let apiKey: String = "getExpenseReportDetailsSFC&sf_code=\(SFCode)&division_code=\(DivCode)&from_date=\(fromdate)&to_date=\(todate)&stateCode=\(StateCode)&Design_code=\(UserSetup.shared.dsg_code)&Mn=\(Eff_Month)&Yr=\(Eff_Year)&PriID=\(period_id)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result{
            case .success(let value):
                print(value)
                if let json = value as? [String:AnyObject] {
                    print(json)
                    if let DistanceEntr = json["DistanceEntr"] as? [AnyObject],let dailyExpense = json["dailyExpense"] as? [AnyObject],let GetRouteChart = json["GetRouteChart"] as? [AnyObject], let add_sub_exp = json["add_sub_exp"] as? [AnyObject]{
                        print(GetRouteChart)
                       if UserSetup.shared.SF_type == 1{
                           Get_Sf_Typ = 1
                           collectrout(Getdata:GetRouteChart, distance_data: DistanceEntr, add_sub_exp: add_sub_exp,FromDate:fromdate,ToDate:todate, dailyExpense: dailyExpense )
                       }else{
                           getExpenseDisSFC { [self] success in
                               if success {
                                   Get_Sf_Typ = 2
                                   Collect_mgr_rout(Getdata: GetRouteChart, distance_data: DistanceEntr, add_sub_exp: add_sub_exp, FromDate: fromdate, ToDate: todate, dailyExpense: dailyExpense)
                               } else {
                                   print("First function failed, second function won't run.")
                               }
                           }
                       }
                    }
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    func getExpenseDisSFC(completion: @escaping (Bool) -> Void) {
        // Assuming this is an asynchronous operation
        getExpenseDisSFC() { [self] disEnrty in
            if let disEnrty = disEnrty {
                print(disEnrty)
                lstdiskm = disEnrty
                print(lstdiskm)
                completion(true) // Call the completion handler when done
            } else {
                print("Failed to get disEnrty")
                completion(false) // Call the completion handler if there was an error
            }
        }
    }
    
    
    func Collect_mgr_rout(Getdata:[AnyObject], distance_data:[AnyObject], add_sub_exp:[AnyObject], FromDate:String, ToDate:String,dailyExpense:[AnyObject]){
        print(Getdata)
        print(distance_data)
        print(lstdiskm)
        Exp_Summary_Data.removeAll()
        var seenEntries = [String: String]()
        var DA_Allowance_amount = ""
        // Filter out duplicates
        let filteredData = Getdata.filter { entry in
            guard let pln_date = entry["pln_date"] as? String,
                  let routeChartMgr = entry["Route_chart_mgr"] as? String else {
                return false
            }
            let date = extractDate(from: pln_date)
            let key = "\(routeChartMgr)-\(date)"
            
            if seenEntries[key] != nil {
                return false
            } else {
                seenEntries[key] = routeChartMgr
                return true
            }
        }
        for MgrRout in filteredData {
            print(MgrRout)
            let getRouts = MgrRout["Route_chart_mgr"] as? String ?? ""
            var Date = ""
            let originalDateString = MgrRout["pln_date"] as? String ?? ""
            let ClstrName_mgr = MgrRout["ClstrName_mgr"] as? String ?? ""
            let Place_Types = MgrRout["Place_Types"] as? String ?? ""
            let Mot_Name = MgrRout["Mot_Name"] as? String ?? ""
            let Mot_ID = MgrRout["Mot_ID"] as? String ?? ""
            let Fuel_amount = MgrRout["Fuel_amount"] as? Double ?? 0
            let miscellaneous_exp = MgrRout["Miscellaneous_amount"] as? Double ?? 0.0
            let originalDateFormatter = DateFormatter()
            let Work_typ = MgrRout["Work_typ"] as? String ?? ""
            let status = MgrRout["status"] as? String ?? ""
            let Sf_hq = MgrRout["Sf_hq"] as? String ?? ""
            let HQ_Allowance_amount = MgrRout["HQ_Allowance_amount"] as? Double ?? 0.0
            let EX_Allowance_amount = MgrRout["EX_Allowance_amount"] as? Double ?? 0.0
            let OS_Allowance_amount = MgrRout["OS_Allowance_amount"] as? Double ?? 0.0
            DA_Allowance_amount = String(MgrRout["Allowance_amount"] as? Double ?? 0)
            originalDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = originalDateFormatter.date(from: originalDateString) {
                let newDateFormatter = DateFormatter()
                newDateFormatter.dateFormat = "yyyy-MM-dd"
                let newDateString = newDateFormatter.string(from: date)
                print("Formatted Date: \(newDateString)")
                Date = newDateString
            } else {
                print("Invalid date format")
            }
            
            if mgrRouts.isEmpty {
                let newRout = Expense_View_SFC.MgrRout(date: Date, Routs: getRouts, ClusterName: ClstrName_mgr, Mot_Name: Mot_Name, Mot_ID: Mot_ID, Fuel_amount: Fuel_amount, Miscellaneous_amount: miscellaneous_exp, Work_typ: Work_typ, status: status, Place_Types: Place_Types, sf_hq: Sf_hq,HQ_Allowance_amount:HQ_Allowance_amount,EX_Allowance_amount: EX_Allowance_amount,OS_Allowance_amount: OS_Allowance_amount )
                mgrRouts.append(newRout)
            } else {
                if let index = mgrRouts.firstIndex(where: { $0.date == Date }) {
                    print("Position of date '\(Date)': \(index)")
                    mgrRouts[index].Routs += "," + getRouts
                    mgrRouts[index].ClusterName += "," + ClstrName_mgr
                    mgrRouts[index].Place_Types += "," + Place_Types
                }else{
                    let newRout = Expense_View_SFC.MgrRout(date: Date, Routs: getRouts, ClusterName: ClstrName_mgr, Mot_Name: Mot_Name, Mot_ID: Mot_ID, Fuel_amount: Fuel_amount, Miscellaneous_amount: miscellaneous_exp, Work_typ: Work_typ, status: status, Place_Types: Place_Types,sf_hq:Sf_hq,HQ_Allowance_amount:HQ_Allowance_amount,EX_Allowance_amount: EX_Allowance_amount,OS_Allowance_amount: OS_Allowance_amount )
                    mgrRouts.append(newRout)
                }
            }
            print(mgrRouts)
        }
        
        print(mgrRouts)
        var Total_Dis = 0.0
        for x in mgrRouts{
            var SFCDetils: [AnyObject] = []
            let routs = x.Routs
            let Place_Types = x.Place_Types
            let MOT_Name = x.Mot_Name
            let Mot_ID = x.Mot_ID
            var ClusterName = x.ClusterName
            let substrings2 = routs.split(separator: ",")
            var placstring = Place_Types.split(separator: ",")
            var ClusterNames = ClusterName.split(separator: ",")
            
            
            print(substrings2)
            print(placstring)
            print(ClusterNames)
            
            var Dis_km = 0.0
            let Fuel_amount = x.Fuel_amount
            var fare = 0.0
            var Work_typ = x.Work_typ
            var Dayend_Place_Types = ""
            var Clusterfrom = ""
            var ClusterTo = ""
           
            
            if let plcetyp = placstring.last{
                Dayend_Place_Types = String(plcetyp)
            }
            var  miscellaneous_exp = 0.0
            let Miscellaneous_amount = dailyExpense.filter{$0["date"] as? String == x.date}
            if Miscellaneous_amount.isEmpty{
                miscellaneous_exp = 0.0
            }else{
                miscellaneous_exp = Miscellaneous_amount[0]["amt"] as? Double ?? 0.0
            }
            var Total_amts = miscellaneous_exp
            var status = x.status
            var MrRouts = lstdiskm.filter{$0["Sf_code"] as? String == String(substrings2[0])}
            print(MrRouts)
            let getdate = x.date
            var PastSf = SFCode
            var CurentSf = ""
            var past_Toplace = ""
            var last_hq_id:String = ""
            var One_day_plac_typ = [String]()
            var List_Count = 0
            for (index,i) in substrings2.enumerated(){

                while placstring.count < substrings2.count{
                    placstring.append("")
                }
                
                var Fromplace = ""
                var Toplace = ""
                var PlcTyp = [String]()
                if index == 0{
                    Fromplace = SFCode
                    last_hq_id = String(i)
                    Toplace = String(i)
                    let mgrLevelFilter = distance_data.filter {
                        $0["To_Plc_Code"] as? String == Toplace &&
                        $0["Frm_Plc_Code"] as? String == Fromplace
                    }
                    
                    Clusterfrom = x.sf_hq
                    ClusterTo = String(ClusterNames[index])
                    print(mgrLevelFilter)
                    if mgrLevelFilter.isEmpty{
                        Dis_km = 0
                    }else{
                        let Dis = mgrLevelFilter[0]["Distance_KM"] as? Int ?? 0
                        Dis_km = Double(Dis)
                        print(mgrLevelFilter)
                        One_day_plac_typ.append(mgrLevelFilter[0]["Place_Type"] as? String ?? "")
                    }
                }else{
                    //find Future Switch Route
                    if substrings2.count != index+1{
                        
                        let FutreRoute = substrings2[index+1]
                        let hqFilter = lstHQs.filter {
                            $0["id"] as? String ?? "" == FutreRoute
                        }
                        print(substrings2)
                        
                        
                        
                        print(hqFilter)
                        print(MrRouts)
                        
                        if hqFilter.isEmpty{
                            Fromplace = String(substrings2[index-1])
                            Toplace = String(i)
                            Clusterfrom=String(ClusterNames[index-1])
                            ClusterTo = String(ClusterNames[index])
                            print(Clusterfrom)
                            print(ClusterTo)
                            
                            let Routs = MrRouts.filter {
                                $0["To_Plc_Code"] as? String == Toplace &&
                                $0["Frm_Plc_Code"] as? String == Fromplace
                            }
                            
                            print(Routs)
                            if Routs.isEmpty{
                                if MrRouts.isEmpty{
                                    Dis_km = 0
                                }else{
                                    let mr_sfcode = MrRouts[0]["Sf_code"] as? String ?? ""
                                    let Routs = MrRouts.filter{
                                        $0["To_Plc_Code"] as? String == Toplace &&
                                        $0["Frm_Plc_Code"] as? String == mr_sfcode
                                    }
                                    print(Routs)
                                    if Routs.isEmpty{
                                        let Routss = distance_data.filter{
                                            $0["To_Plc_Code"] as? String == CurentSf &&
                                            $0["Frm_Plc_Code"] as? String == PastSf
                                        }
                                        print(Routss)
                                        if Routss.isEmpty{
                                            if CurentSf != "" && PastSf != ""{
                                                CurentSf = ""
                                                PastSf = ""
                                                Dis_km = 0.0
                                                
                                            }else{
                                            
                                            let Routs = MrRouts.filter{
                                                $0["To_Plc_Code"] as? String == past_Toplace &&
                                                $0["Frm_Plc_Code"] as? String == mr_sfcode
                                            }
                                            print(Routs)
                                            if Routs.isEmpty{
                                                Dis_km = 0
                                            }else{
                                                let Dis = Routs[0]["Distance_KM"] as? Int ?? 0
                                                One_day_plac_typ.append(Routs[0]["Place_Type"] as? String ?? "")
                                                Dis_km = Double(Dis)
                                            }
                                        }
                                        }else{
                                            CurentSf = ""
                                            PastSf = ""
                                            Clusterfrom=x.sf_hq
                                            let Dis = Routss[0]["Distance_KM"] as? Int ?? 0
                                            One_day_plac_typ.append(Routss[0]["Place_Type"] as? String ?? "")
                                            Dis_km = Double(Dis)
                                        }
                                    }else{
                                        let Dis = Routs[0]["Distance_KM"] as? Int ?? 0
                                        One_day_plac_typ.append(Routs[0]["Place_Type"] as? String ?? "")
                                        Dis_km = Double(Dis)
                                    }
                            }
                            }else{
                                let Dis = Routs[0]["Distance_KM"] as? Int ?? 0
                                One_day_plac_typ.append(Routs[0]["Place_Type"] as? String ?? "")
                                Dis_km = Double(Dis)
                            }
                            
                            //find past Route place typ
                            
                            if index+1 != placstring.count{
                                if substrings2.count == placstring.count{
                                let past_allow = placstring[index]
                                let curent_allow = placstring[index+1]
                                print(past_allow)
                                print(curent_allow)
                                if past_allow == "OS" && curent_allow == "HQ"{
                                    Dis_km = Dis_km + Dis_km
                                    
                                }else if past_allow == "OS" && curent_allow == "EX"{
                                        Dis_km = Dis_km + Dis_km
                                        
                                    }else if past_allow == "OS" && curent_allow == "OX"{
                                        Dis_km = Dis_km + Dis_km
                                        
                                    }
                            }
                            }
                            
                        }else{
                            
                            Clusterfrom=String(ClusterNames[index-1])
                            ClusterTo = String(ClusterNames[index])
                            print(Clusterfrom)
                            print(ClusterTo)
                            
                            if MrRouts.isEmpty{
                               Dis_km = 0
                            }else{
                                let Fromplace = MrRouts[0]["Sf_code"] as? String ?? ""
                                var Toplace = substrings2[index]
                                
   
                                
                                let Routs = MrRouts.filter {
                                    $0["To_Plc_Code"] as? String ?? "" == Toplace &&
                                    $0["Frm_Plc_Code"] as? String ?? "" == Fromplace
                                }
                                
                                CurentSf = hqFilter[0]["id"] as? String ?? ""
                                last_hq_id = hqFilter[0]["id"] as? String ?? ""
                                if Routs.isEmpty{
                                    
                                    let Routs = MrRouts.filter {
                                        $0["To_Plc_Code"] as? String ?? "" == substrings2[index] &&
                                        $0["Frm_Plc_Code"] as? String ?? "" == substrings2[index-1]
                                    }
                                    print(Routs)
                                    
                                    if Routs.isEmpty{
                                        Dis_km = Dis_km + 0
                                    }else{
                                        let dis = Routs[0]["Distance_KM"] as? Int ?? 0
                                          One_day_plac_typ.append(Routs[0]["Place_Type"] as? String ?? "")
                                          Dis_km = Double(dis)
                                    }
                                }else{
                                  let dis = Routs[0]["Distance_KM"] as? Int ?? 0
                                    One_day_plac_typ.append(Routs[0]["Place_Type"] as? String ?? "")
                                    Dis_km = Dis_km+Double(dis)
                                }
                            }
                            
                            //find past Route place typ
                            
                            if index+1 != placstring.count{
                                if substrings2.count == placstring.count{
                                let past_allow = placstring[index]
                                let curent_allow = placstring[index+1]
                                 print(placstring)
                                print(past_allow)
                                print(curent_allow)
                                if past_allow == "OS" && curent_allow == "HQ"{
                                    Dis_km = Dis_km + Dis_km
                                    
                                }else if past_allow == "OS" && curent_allow == "EX"{
                                        Dis_km = Dis_km + Dis_km
                                        
                                    }else if past_allow == "OS" && curent_allow == "OX"{
                                        Dis_km = Dis_km + Dis_km
                                        
                                    }
                            }
                            }
                            MrRouts = lstdiskm.filter{$0["Sf_code"] as? String == String(FutreRoute)}
                            print(MrRouts)
                            past_Toplace = String(substrings2[index+2])
                            print(substrings2)
                            print(Toplace)
                        }
                    }else{
                        print("No data")
                        //Fixed switch route
                        let Fromplaces = substrings2[index-1]
                        let Toplaces = substrings2[index]
                        Clusterfrom = String(ClusterNames[index-1])
                        ClusterTo = String(ClusterNames[index])
                        
                        print(Clusterfrom)
                        print(ClusterTo)
                        let SwitchRouts = MrRouts.filter {
                            $0["To_Plc_Code"] as? String ?? "" == Toplaces &&
                            $0["Frm_Plc_Code"] as? String ?? "" == Fromplaces
                        }
                        print(SwitchRouts)
                        
                        if SwitchRouts.isEmpty{
                            
                            if MrRouts.isEmpty{
                                Dis_km = 0
                            }else{
                            
                            let Fromplace = MrRouts[0]["Sf_code"] as? String ?? ""
                            var Toplace = substrings2[index]
                            let Routs = MrRouts.filter {
                                $0["To_Plc_Code"] as? String ?? "" == Toplace &&
                                $0["Frm_Plc_Code"] as? String ?? "" == Fromplace
                            }
                            print(Routs)
                            
                            if Routs.isEmpty{
                                Dis_km = 0
                            }else{
                                let dis = Routs[0]["Distance_KM"] as? Int ?? 0
                                One_day_plac_typ.append(Routs[0]["Place_Type"] as? String ?? "")
                                Dis_km = Double(dis)
                            }
                        }
                        }else{
                            let dis = SwitchRouts[0]["Distance_KM"] as? Int ?? 0
                            One_day_plac_typ.append(SwitchRouts[0]["Place_Type"] as? String ?? "")
                            Dis_km = Double(dis)
                        }
                        //find past Route place typ
                        
                        print(One_day_plac_typ)
                        
                        if index+1 != placstring.count{
                            if substrings2.count == placstring.count{
                                let past_allow = placstring[index]
                                let curent_allow = placstring[index+1]
                                print(placstring)
                                print(past_allow)
                                print(curent_allow)
                                if past_allow == "OS" && curent_allow == "HQ"{
                                    Dis_km = Dis_km + Dis_km
                                    
                                }else if past_allow == "OS" && curent_allow == "EX"{
                                    Dis_km = Dis_km + Dis_km
                                    
                                }else if past_allow == "OS" && curent_allow == "OX"{
                                    Dis_km = Dis_km + Dis_km
                                    
                                }
                            }
                        }
                    }
                    // bjbnnjhnj
                 
                }
                
                print(getdate)
                print(placstring)
                
                print(Clusterfrom)
                print(ClusterTo)
                
                
                
                fare = Double(Dis_km) * Double(Fuel_amount)
                let itms: [String: Any]=["date": getdate,"modeoftravel":MOT_Name,"modeid":Mot_ID,"fromplace":Fromplace,"Toplace":Toplace,"Fromid":Fromplace,"Toid":Toplace,"Dist":Dis_km,"per_km_fare":String(Fuel_amount),"fare":String(format: "%.2f", fare),"Cls_From":Clusterfrom,"Cls_To":ClusterTo];
                let jitm: AnyObject = itms as AnyObject
                print(itms)
                SFCDetils.append(jitm)
                print(SFCDetils)
            }
            // Collect return
            
            print(One_day_plac_typ)
            
            Dayend_Place_Types = One_day_plac_typ.last ?? ""
            var Returnkm = 0

            if Dayend_Place_Types == "HQ" || Dayend_Place_Types == "EX"{
                let routs = x.Routs
                let substrings2 = routs.split(separator: ",")
                print(substrings2)
          
              let Returnrouts = distance_data.filter{$0["Sf_code"] as? String == String(last_hq_id)}
                if let index = substrings2.firstIndex(of:"\(last_hq_id)") {
                    let outputArray = Array(substrings2[index...])
                    var From = ""
                    var to = ""
                    
                    if let firstElement = outputArray.first, let lastElement = outputArray.last {
                        From = String(firstElement)
                        to = String(lastElement)
                    } else {
                        print("The array is empty.")
                    }
                       print(to)
                        print(From)
                        
                        let Routs = Returnrouts.filter {
                            $0["To_Plc_Code"] as? String ?? "" == to &&
                            $0["Frm_Plc_Code"] as? String ?? "" == From
                        }
                        print(Routs)
                        
                        if Routs.isEmpty{
                            var Lop_Count = 0
                            for (index,i)in outputArray.enumerated(){
                                Lop_Count = Lop_Count+1
                                if outputArray.count == Lop_Count{
                                    break
                                }
                                let from = i
                                let To = outputArray[Lop_Count]
                                let Routs = Returnrouts.filter {
                                    $0["To_Plc_Code"] as? String ?? "" == To &&
                                    $0["Frm_Plc_Code"] as? String ?? "" == from
                                }
                                if Routs.isEmpty{
                                    Returnkm = Returnkm + 0
                                }else{
                                    let dis = Routs[0]["Distance_KM"] as? Int ?? 0
                                    Returnkm = Returnkm + dis
                                }
                                
                            }
                            let mgr_Returnrouts = distance_data.filter{$0["Sf_code"] as? String == SFCode}
                            
                            let Mgr_From = SFCode
                            let Mgr_To = last_hq_id
                            let MgrRouts = mgr_Returnrouts.filter {
                                $0["To_Plc_Code"] as? String ?? "" == Mgr_To &&
                                $0["Frm_Plc_Code"] as? String ?? "" == Mgr_From
                            }
                            
                            if MgrRouts.isEmpty{
                                Returnkm = Returnkm + 0
                            }else{
                                let dis = MgrRouts[0]["Distance_KM"] as? Int ?? 0
                                Returnkm = Returnkm + dis
                            }
                            
                            
                        }else{
                            let dis = Routs[0]["Distance_KM"] as? Int ?? 0
                            Returnkm = Returnkm + dis
                            
                            let mgr_Returnrouts = distance_data.filter{$0["Sf_code"] as? String == SFCode}
                            
                            let Mgr_From = SFCode
                            let Mgr_To = last_hq_id
                            let MgrRouts = mgr_Returnrouts.filter {
                                $0["To_Plc_Code"] as? String ?? "" == Mgr_To &&
                                $0["Frm_Plc_Code"] as? String ?? "" == Mgr_From
                            }
                            
                            if MgrRouts.isEmpty{
                                Returnkm = Returnkm + 0
                            }else{
                                let dis = MgrRouts[0]["Distance_KM"] as? Int ?? 0
                                Returnkm = Returnkm + dis
                            }
                        }
                } else {
                    print("last_hq_id not found")
                }
                
            }else if Dayend_Place_Types == "OS"{
                Returnkm = 0
            }
            
            print(Returnkm)
            
            
            Total_Dis = Double(Returnkm)
            for i in SFCDetils{
                print(i)
                if let Dis = i["Dist"] as? Int{
                    Total_Dis = Total_Dis + Double(Dis)
                }
            }
            
        print(Total_Dis)
            
            
            if One_day_plac_typ.contains("HQ") && !One_day_plac_typ.contains("EX") && !One_day_plac_typ.contains("OS"){
                print("Cover Only HQ")
                if UserSetup.shared.ExpDist_HQ == 0{
                    Total_Dis = 0
                    Total_amts = miscellaneous_exp
                    Total_amts = Total_amts + Double(x.HQ_Allowance_amount)
                    DA_Allowance_amount = String(x.HQ_Allowance_amount)
                }else if UserSetup.shared.ExpDist_HQ == 1{
                    Total_amts = Total_amts+(Double(Total_Dis)  * Double(Fuel_amount))
                    Total_amts = Total_amts + Double(x.HQ_Allowance_amount)
                    DA_Allowance_amount = String(x.HQ_Allowance_amount)
                }else{
                    Total_amts = Total_amts+(Double(Total_Dis)  * Double(Fuel_amount))
                    Total_amts = Total_amts + Double(x.HQ_Allowance_amount)
                    DA_Allowance_amount = String(x.HQ_Allowance_amount)
                }
            }
            
            if One_day_plac_typ.contains("HQ") && One_day_plac_typ.contains("EX") && !One_day_plac_typ.contains("OS"){
                print("Cover HQ AND EX")
                print(UserSetup.shared.ExpDist_HQEX)
                
                if UserSetup.shared.ExpDist_HQEX == 0{
                    Total_Dis = 0
                    Total_amts = miscellaneous_exp + Double(x.HQ_Allowance_amount)
                    DA_Allowance_amount = String(x.HQ_Allowance_amount)
                    
                }else if UserSetup.shared.ExpDist_HQEX == 1{
                    Total_amts = Total_amts+(Double(Total_Dis)  * Double(Fuel_amount))
                    
                    print(Total_amts)
                    
                    Total_amts = Total_amts + Double(x.HQ_Allowance_amount)
                    
                    print(Total_amts)
                    
                    DA_Allowance_amount = String(x.HQ_Allowance_amount)
                }else if UserSetup.shared.ExpDist_HQEX == 2{
                    Total_amts = Total_amts+(Double(Total_Dis)  * Double(Fuel_amount))
                    Total_amts = Total_amts + Double(x.EX_Allowance_amount)
                    
                    DA_Allowance_amount = String(x.EX_Allowance_amount)
                }
                
            }
            
            if One_day_plac_typ.contains("EX") && One_day_plac_typ.count == 1{
                Total_amts = Total_amts+(Double(Total_Dis)  * Double(Fuel_amount))
                Total_amts = Total_amts + Double(x.EX_Allowance_amount)
                DA_Allowance_amount = String(x.EX_Allowance_amount)
            }
            
            if One_day_plac_typ.contains("OS"){
                Total_amts = Total_amts+(Double(Total_Dis)  * Double(Fuel_amount))
                Total_amts = Total_amts + Double(x.OS_Allowance_amount)
                DA_Allowance_amount = String(x.OS_Allowance_amount)
            }
            
            
            ExpenseDetils.append(ExpenseDatas(date: getdate, Work_typ: Work_typ,miscellaneous_exp:String(format: "%.2f", miscellaneous_exp), Total_Amt: String(Total_amts), Returnkm: String(Returnkm), Plc_typ: Dayend_Place_Types, Fuel_amount: String(Fuel_amount), Mot_Name: MOT_Name, status: status, Da_amount: DA_Allowance_amount, SFCdetils:SFCDetils))
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fromDateString = FromDate
        let getdate = dateFormatter.string(from: Date())
        
        var currentDate = ""
        
        
        if let Date_to_set_up = dateFormatter.date(from:ToDate),let To_Current_Date = dateFormatter.date(from: getdate), Date_to_set_up >= To_Current_Date{
            
            
            currentDate = dateFormatter.string(from: Date())
            
        }else{
            currentDate = ToDate
        }

        guard let fromDate = dateFormatter.date(from: fromDateString),
              let endDate = dateFormatter.date(from: currentDate) else {
            fatalError("Invalid dates")
        }
        let calendar = Calendar.current
        guard let adjustedStartDate = calendar.date(byAdding: .day, value: -1, to: fromDate) else {
            fatalError("Failed to calculate the adjusted start date")
        }
        let missingDates = getMissingDates(from: adjustedStartDate, to: endDate, excludingStart: true)
        let missingDatesFormatted = missingDates.map { dateFormatter.string(from: $0) }
        
        print("Missing Dates: \(missingDatesFormatted)")
        print(ExpenseDetils)
        
        for missdates in missingDatesFormatted {
            var found = false
            for AddMissdate in ExpenseDetils {
                if missdates == AddMissdate.date {
                    found = true
                    break
                }
            }
            if !found {
                ExpenseDetils.append(ExpenseDatas(
                    date: missdates,  // Ensure `missdates` matches the type expected by `ExpenseDatas`
                    Work_typ: "",
                    miscellaneous_exp: "0.00",
                    Total_Amt: "0.00",
                    Returnkm: "0",
                    Plc_typ: "",
                    Fuel_amount: "0.00",
                    Mot_Name: "",
                    status: "NOT CLAIMED", Da_amount: "0",
                    SFCdetils: []
                ))
            }
        }
        ExpenseDetils.sort { $0.date < $1.date }
        var sum_Total_all = 0.0
        for i in ExpenseDetils{
            let Total_Amt =  Double(i.Total_Amt) ?? 0.0
            sum_Total_all = sum_Total_all + Total_Amt
        }
        // Expense Summary
        print(ExpenseDetils)
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: String(sum_Total_all)))
        var total_sum = 0.0
        var total_ded = 0.0
        for item3 in add_sub_exp{
            print(item3)
            let exp_amnt = Double((item3["exp_amnt"] as? String)!)
            if let add_sub = item3["add_sub"] as? String,add_sub == "+"{
                total_sum = total_sum + exp_amnt!
            }else{
                total_ded = total_ded + exp_amnt!
            } }
        
        sum_Total_all = sum_Total_all + total_sum
        sum_Total_all = sum_Total_all - total_ded
        
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "\(total_sum)"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "\(total_ded)"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: "\(sum_Total_all)"))
        
        ViewDet_TB.reloadData()
        Summary_TB.reloadData()
    }
    func extractDate(from pln_date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: pln_date) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        return ""
    }

    func collectrout(Getdata:[AnyObject],distance_data:[AnyObject],add_sub_exp:[AnyObject],FromDate:String,ToDate:String,dailyExpense:[AnyObject]){
        print(Getdata)
        Exp_Summary_Data.removeAll()
        ExpenseDetils.removeAll()
        let past_Place_Types = ""
        var count = 0
        var allow = [String]()
        
        print(FromDate)
        print(ToDate)
        
        var DA_Allowance_amount = ""
        for i in Getdata{
            let Place_Types = i["Place_Types"] as? String ?? ""
            let substrings = Place_Types.split(separator: ",")
            let result = substrings.map { String($0) }
            let Route_chart = i["Route_chart"] as? String ?? ""
            let substrings2 = Route_chart.split(separator: ",")
            let cluster_chart = i["cluster_chart"] as? String ?? ""
            let cluster_chart_split = cluster_chart.split(separator: ",")
            let result2 = substrings2.map { String($0) }
            let date = i["pln_date"] as? String ?? ""
            let MOT_Name = i["Mot_Name"] as? String ?? ""
            let modeid = i["Mot_ID"] as? Int ?? 0
            let Mot_Name = i["Mot_Name"] as? String ?? ""
            let per_km_fare = i["Fuel_amount"] as? Double ?? 0.0
            DA_Allowance_amount = String(i["Allowance_amount"] as? Double ?? 0)
            print(dailyExpense)
            var  miscellaneous_exp = 0.0
            let Miscellaneous_amount = dailyExpense.filter{$0["date"] as? String == date}
            if Miscellaneous_amount.isEmpty{
                miscellaneous_exp = 0.0
            }else{
                miscellaneous_exp = Miscellaneous_amount[0]["amt"] as? Double ?? 0.0
            }
            
           
            var Total_amts = miscellaneous_exp
            let Dayend_Place_Types = i["Dayend_Place_Types"] as? String ?? ""
            let Work_typ = i["Work_typ"] as? String ?? ""
            let status = i["status"] as? String ?? ""
            
            let HQ_Allowance_amount = i["HQ_Allowance_amount"] as? Double ?? 0.0
            let EX_Allowance_amount = i["EX_Allowance_amount"] as? Double ?? 0.0
            let OS_Allowance_amount = i["OS_Allowance_amount"] as? Double ?? 0.0
            
            var SFCDetils: [AnyObject] = []
            var List_Count = 0
            var Totalkm = 0
            print(result2)
            var One_day_plac_typ = [String]()
            for (index,i) in result2.enumerated(){
                
                List_Count = List_Count + 1
                print(result2.count)
                if List_Count == result2.count{
                    break
                }
                let From_Place = i
                let To_Place = result2[List_Count]
                var Dis_km = 0
                var fare = 0.0
                let cluster_from = cluster_chart_split[index]
                let cluster_to = cluster_chart_split[List_Count]
                
                let BasLevelFilter = distance_data.filter {
                    $0["To_Plc_Code"] as? String == To_Place &&
                    $0["Frm_Plc_Code"] as? String == From_Place
                }
                
                if !BasLevelFilter.isEmpty {
                    Dis_km = BasLevelFilter[0]["Distance_KM"] as? Int ?? 0
                    One_day_plac_typ.append(BasLevelFilter[0]["Place_Type"] as? String ?? "")
                }
                
                if BasLevelFilter.isEmpty{
                    print(From_Place)
                    print(To_Place)
                    
                    let BasLevelFilter = distance_data.filter {
                        $0["To_Plc_Code"] as? String == To_Place &&
                        $0["Frm_Plc_Code"] as? String == SFCode
                    }
                    if !BasLevelFilter.isEmpty{
                        Dis_km = BasLevelFilter[0]["Distance_KM"] as? Int ?? 0
                        One_day_plac_typ.append(BasLevelFilter[0]["Place_Type"] as? String ?? "")
                    }else{
                        Dis_km = 0
                    }
                }
                //Find Next switch Route
                if List_Count+1 != result2.count{
                    let Nextswitch_From_Place = result2[List_Count]
                    let Nextswitch_To_Place = result2[List_Count+1]
                    let Nextswitch_BasLevelFilter = distance_data.filter {
                        $0["To_Plc_Code"] as? String == Nextswitch_To_Place &&
                        $0["Frm_Plc_Code"] as? String == Nextswitch_From_Place
                    }
                    if Nextswitch_BasLevelFilter.isEmpty{
                        Dis_km = Dis_km + Dis_km
                    }
                }
  
                
                Totalkm = Totalkm + Dis_km
                
                fare = Double(Dis_km) * per_km_fare
                let itms: [String: Any]=["date": date,"modeoftravel":MOT_Name,"modeid":modeid,"fromplace":From_Place,"Toplace":To_Place,"Fromid":From_Place,"Toid":To_Place,"Dist":Dis_km,"per_km_fare":String(per_km_fare),"fare":String(format: "%.2f", fare),"cluster_from":cluster_from,"cluster_to":cluster_to];
                let jitm: AnyObject = itms as AnyObject
                SFCDetils.append(jitm)
                print(SFCDetils)
            }
           // Collect return distance.
            var Returnkm = 0
            if One_day_plac_typ.last ?? "" == "HQ"{
                print(Dayend_Place_Types)
                print(result)
                print(result2)
                let Firstplace = result2.first
                let secondplace =  result2.last
                let BasLevelFilter = distance_data.filter {
                    $0["To_Plc_Code"] as? String == secondplace &&
                    $0["Frm_Plc_Code"] as? String == Firstplace
                }
                
                if !BasLevelFilter.isEmpty{
                    Returnkm = BasLevelFilter[0]["Distance_KM"] as? Int ?? 0
                }
                print(BasLevelFilter)
                if BasLevelFilter.isEmpty{
                    for i in SFCDetils{
                        let dis = i["Dist"] as? Int ?? 0
                        Returnkm = Returnkm + dis
                        
                    }
                }
            }else if One_day_plac_typ.last ?? "" == "EX"{
                print(Dayend_Place_Types)
                print(result2)
                let Firstplace = result2.first
                let secondplace =  result2.last
                let BasLevelFilter = distance_data.filter {
                    $0["To_Plc_Code"] as? String == secondplace &&
                    $0["Frm_Plc_Code"] as? String == Firstplace
                }
                
                if !BasLevelFilter.isEmpty{
                    Returnkm = BasLevelFilter[0]["Distance_KM"] as? Int ?? 0
                }
                print(BasLevelFilter)
                if BasLevelFilter.isEmpty{
                    for i in SFCDetils{
                        let dis = i["Dist"] as? Int ?? 0
                        Returnkm = Returnkm + dis
                        
                    }
                }
                
            }else if One_day_plac_typ.last ?? "" == "OS"{
                Returnkm = 0
            }else if One_day_plac_typ.last ?? "" == "OX"{
                print(Dayend_Place_Types)
                print(result2)
                let Firstplace = result2.first
                let secondplace =  result2.last
                let BasLevelFilter = distance_data.filter {
                    $0["To_Plc_Code"] as? String == secondplace &&
                    $0["Frm_Plc_Code"] as? String == Firstplace
                }
                
                if !BasLevelFilter.isEmpty{
                    Returnkm = BasLevelFilter[0]["Distance_KM"] as? Int ?? 0
                }
                print(BasLevelFilter)
                if BasLevelFilter.isEmpty{
                    for i in SFCDetils{
                        let dis = i["Dist"] as? Int ?? 0
                        Returnkm = dis
                        
                    }
                }
            }
            
            print(One_day_plac_typ)
            Totalkm = Totalkm + Returnkm
           
            
            if One_day_plac_typ.contains("HQ") && !One_day_plac_typ.contains("EX") && !One_day_plac_typ.contains("OS"){
                print("Cover Only HQ")
                if UserSetup.shared.ExpDist_HQ == 0{
                    Totalkm = 0
                    Total_amts = miscellaneous_exp
                    Total_amts = Total_amts + Double(HQ_Allowance_amount)
                    DA_Allowance_amount = String(HQ_Allowance_amount)
                }else if UserSetup.shared.ExpDist_HQ == 1{
                    Total_amts = Total_amts+(Double(Totalkm)  * Double(per_km_fare))
                    Total_amts = Total_amts + Double(HQ_Allowance_amount)
                    DA_Allowance_amount = String(HQ_Allowance_amount)
                }else{
                    Total_amts = Total_amts+(Double(Totalkm)  * Double(per_km_fare))
                    Total_amts = Total_amts + Double(HQ_Allowance_amount)
                    DA_Allowance_amount = String(HQ_Allowance_amount)
                }
            }
            
            if One_day_plac_typ.contains("HQ") && One_day_plac_typ.contains("EX") && !One_day_plac_typ.contains("OS"){
                print("Cover HQ AND EX")
                print(UserSetup.shared.ExpDist_HQEX)
                
                if UserSetup.shared.ExpDist_HQEX == 0{
                    Totalkm = 0
                    Total_amts = miscellaneous_exp + Double(HQ_Allowance_amount)
                    DA_Allowance_amount = String(HQ_Allowance_amount)
                    
                }else if UserSetup.shared.ExpDist_HQEX == 1{
                    Total_amts = Total_amts+(Double(Totalkm)  * Double(per_km_fare))

                    Total_amts = Total_amts + Double(HQ_Allowance_amount)
                    
                    DA_Allowance_amount = String(HQ_Allowance_amount)
                }else if UserSetup.shared.ExpDist_HQEX == 2{
                    Total_amts = Total_amts+(Double(Totalkm)  * Double(per_km_fare))
                    Total_amts = Total_amts + Double(EX_Allowance_amount)
                    
                    DA_Allowance_amount = String(EX_Allowance_amount)
                }
                
            }
            
            if One_day_plac_typ.contains("OS"){
                Total_amts = Total_amts+(Double(Totalkm)  * Double(per_km_fare))
                Total_amts = Total_amts + Double(OS_Allowance_amount)
                DA_Allowance_amount = String(OS_Allowance_amount)
            }
            
            print(Total_amts)
            
            ExpenseDetils.append(ExpenseDatas(date: date, Work_typ: Work_typ,miscellaneous_exp:String(format: "%.2f", miscellaneous_exp), Total_Amt: String(Total_amts), Returnkm: String(Returnkm), Plc_typ: One_day_plac_typ.last ?? "", Fuel_amount: String(per_km_fare), Mot_Name: Mot_Name, status: status, Da_amount: DA_Allowance_amount, SFCdetils:SFCDetils))
            count = count + 1
        }
        
        print(ExpenseDetils)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fromDateString = FromDate
        let getdate = dateFormatter.string(from: Date())
        var currentDate = ""
        
        
        if let Date_to_set_up = dateFormatter.date(from:ToDate),let To_Current_Date = dateFormatter.date(from: getdate), Date_to_set_up >= To_Current_Date{
            
            
            currentDate = dateFormatter.string(from: Date())
            
        }else{
            currentDate = ToDate
        }
        
        print(currentDate)
        
        
        guard let fromDate = dateFormatter.date(from: fromDateString),
              let endDate = dateFormatter.date(from: currentDate) else {
            fatalError("Invalid dates")
        }
        let calendar = Calendar.current
        guard let adjustedStartDate = calendar.date(byAdding: .day, value: -1, to: fromDate) else {
            fatalError("Failed to calculate the adjusted start date")
        }
        let missingDates = getMissingDates(from: adjustedStartDate, to: endDate, excludingStart: true)
        let missingDatesFormatted = missingDates.map { dateFormatter.string(from: $0) }
        
        print("Missing Dates: \(missingDatesFormatted)")
        print(ExpenseDetils)
        
        for missdates in missingDatesFormatted {
            var found = false
            for AddMissdate in ExpenseDetils {
                if missdates == AddMissdate.date {
                    found = true
                    break
                }
            }
            if !found {
                ExpenseDetils.append(ExpenseDatas(
                    date: missdates,  // Ensure `missdates` matches the type expected by `ExpenseDatas`
                    Work_typ: "",
                    miscellaneous_exp: "0.00",
                    Total_Amt: "0.00",
                    Returnkm: "0",
                    Plc_typ: "",
                    Fuel_amount: "0.00",
                    Mot_Name: "",
                    status: "NOT CLAIMED", Da_amount: "0",
                    SFCdetils: []
                ))
            }
        }

        
        print(ExpenseDetils)
        
        ExpenseDetils.sort { $0.date < $1.date }

        print(ExpenseDetils)
        
        var sum_Total_all = 0.0
        for i in ExpenseDetils{
            let Total_Amt =  Double(i.Total_Amt) ?? 0.0
            sum_Total_all = sum_Total_all + Total_Amt
        }
        // Expense Summary
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: String(sum_Total_all)))
        var total_sum = 0.0
        var total_ded = 0.0
        for item3 in add_sub_exp{
            print(item3)
            let exp_amnt = Double((item3["exp_amnt"] as? String)!)
            if let add_sub = item3["add_sub"] as? String,add_sub == "+"{
                total_sum = total_sum + exp_amnt!
            }else{
                total_ded = total_ded + exp_amnt!
            } }
        
        sum_Total_all = sum_Total_all + total_sum
        sum_Total_all = sum_Total_all - total_ded
        
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "\(total_sum)"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "\(total_ded)"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: "\(sum_Total_all)"))
        
        ViewDet_TB.reloadData()
        Summary_TB.reloadData()
    }
    func getMissingDates(from start: Date, to end: Date, excludingStart: Bool) -> [Date] {
        var missingDates: [Date] = []
        let calendar = Calendar.current

        // Determine the actual start date based on excludingStart flag
        var currentDate = excludingStart ? calendar.date(byAdding: .day, value: 1, to: start) : start

        // Ensure the start date is valid
        guard let unwrappedCurrentDate = currentDate else {
            fatalError("Invalid start date")
        }

        // Iterate from the start date to the end date
        var dateToCheck = unwrappedCurrentDate
        while dateToCheck <= end {
            missingDates.append(dateToCheck)
            
            // Move to the next day
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: dateToCheck) else {
                break
            }
            dateToCheck = nextDate
        }

        return missingDates
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
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        
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
