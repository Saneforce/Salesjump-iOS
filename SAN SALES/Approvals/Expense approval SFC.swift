//
//  Expense approval SFC.swift
//  SAN SALES
//
//  Created by Anbu j on 05/08/24.
//

import UIKit
import Alamofire
import FSCalendar
class Expense_approval_SFC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var YearPostion: UILabel!
    @IBOutlet weak var MonthPostion: UILabel!
    @IBOutlet weak var Sel_Date: UILabel!
    @IBOutlet weak var Sel_Period: UILabel!
    
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var MonthView: UIView!
    @IBOutlet weak var PeriodicView: UIView!
    @IBOutlet weak var SummaryView: UIView!
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
    @IBOutlet weak var eXP_Data: UITableView!
    @IBOutlet weak var Approval_Scr: UIView!
    @IBOutlet weak var aprscr_close: UIImageView!
    
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
        let Work_typ:String
        var miscellaneous_exp:String
        var Total_Amt:String
        let Returnkm:String
        let Plc_typ:String
        let Fuel_amount:String
        let Mot_Name:String
        let status:String
        var Da_amount:String
        var Mot_ID:String
        var Place_Types:String
        var Work_place:String
        var Total_dis:String
        let SFCdetils:[AnyObject]
    }
    
    struct AllExpenseDatas:Codable{
        let SF_Name:String
        let Expense_Amt:String
        let Emp_ID:String
        let Expense_Month:String
        let Expense_Year:Int
        let SF_Code:String
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
    var AllExpenses:[AllExpenseDatas] = []
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
    var Exp_approv_item:Int = 0
    var Rej_Coun = 0
    var Emp_Id = ""
    var Aprsfcode = ""
    var Per_From = ""
    var Per_To = ""
    var Per_Id = ""
    var Expense_Amt = "0"
    var Applied_ExpAmnt = "0"
    var Get_Sf_Typ:Int = 0
    override func viewDidLoad() {
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
//
        Summary_TB.delegate = self
        Summary_TB.dataSource = self
        Collection_Of_Month.delegate=self
        Collection_Of_Month.dataSource=self
        Period_TB.delegate=self
        Period_TB.dataSource=self
        ViewDet_TB.delegate=self
        ViewDet_TB.dataSource=self
        eXP_Data.delegate=self
        eXP_Data.dataSource=self
        
        blureView.bounds = self.view.bounds
        PopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        PopUpView.layer.cornerRadius = 10
        
        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list;
            
        }
        
        
        cardViewInstance.styleSummaryView(MonthView)
        cardViewInstance.styleSummaryView(PeriodicView)
        cardViewInstance.styleSummaryView(SummaryView)
        //cardViewInstance.styleSummaryView(Detils_View_Close_BT)
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        Sel_Period.addTarget(target: self, action: #selector(Open_Drop_Down_View))
        Sel_Date.addTarget(target: self, action: #selector(OpenPopUP))
        Close_Pop_Up.addTarget(target: self, action: #selector(ClosePopUP))
        YearPostion.addTarget(target: self, action: #selector(OpenYear))
        MonthPostion.addTarget(target: self, action: #selector(OpenMonth))
        Close_Drop_Down.addTarget(target: self, action: #selector(Close_Drop_Down_View))
        aprscr_close.addTarget(target: self, action: #selector(Close_Apr_scr))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: "-"))
        
        //Mod_of_trv_tb_Hig.constant = 0
//        print(StausView.frame.size.height)
//        print(Exp_Det_View.frame.size.height)
//        print(Lab_hig.frame.size.height)
//        print(CardView.frame.size.height)
//        print(Card_View_Hig.constant)
        
        
        getExpenseDisSFC() { [self] disEnrty in
            if let disEnrty = disEnrty {
                print(disEnrty)
                lstdiskm = disEnrty
                print(lstdiskm)
            } else {
                print("Failed to get disEnrty")
            }
        }
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
        if let data = UserDefaults.standard.data(forKey: "periodicDataapr"),
           let items = try? JSONDecoder().decode(PeriodicData.self, from: data) {
            let item = items
            print(item)
            Sel_Period.text = item.Period_Name
            period_id = item.Period_Id
            Eff_Month = String(item.Eff_Month)
            Eff_Year = item.Eff_Year
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let From_Date = item.From_Date
            
            
            var dateComponents = DateComponents()
            dateComponents.month = item.Eff_Month
            dateComponents.day = 1

            let calendar = Calendar.current
            if let date = calendar.date(from: dateComponents) {
                // Get month in short word format
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM"
                let monthShortWord = dateFormatter.string(from: date)
                Sel_Date.text = "\(monthShortWord)-\(item.Eff_Year)"
            }
            
            SelectMonth = String(item.Eff_Month)
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
            Per_From = From
            Per_To = To
            Per_Id = item.Period_Id
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
            AllExpenseData(From: From, To: To)
            
            Sel_Period_Drop_Down.isHidden = true
        }
    }
    
    @objc private func GotoHome() {
        UserDefaults.standard.removeObject(forKey: "periodicDataapr")
        let storyboard = UIStoryboard(name: "Approval", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ApprovalMenu") as! Approval_Menu
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
        if Period_TB == tableView {return 50}
        if Summary_TB == tableView {return 30}
        if ViewDet_TB == tableView {return 100}
        if eXP_Data == tableView {return 70}
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Period_TB == tableView {return lstOfPeriod.count}
        if Summary_TB == tableView {return Exp_Summary_Data.count}
        if ViewDet_TB == tableView{return ExpenseDetils.count}
        if eXP_Data == tableView {return AllExpenses.count}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
       if ViewDet_TB == tableView {
            cell.Status.text = ExpenseDetils[indexPath.row].status
            cell.item.text = ExpenseDetils[indexPath.row].Total_Amt
            cell.Date.text = ExpenseDetils[indexPath.row].date
            cell.ViewBT.tag = indexPath.row
            cell.ViewBT.addTarget(self, action: #selector(View_Det(_:)), for: .touchUpInside)
        }else if Summary_TB == tableView{
            cell.lblText.text = Exp_Summary_Data[indexPath.row].Tit
            cell.lblText2.text = Exp_Summary_Data[indexPath.row].Amt
        }else if Period_TB == tableView{
            cell.lblText.text = lstOfPeriod[indexPath.row].Period_Name
        }else if (eXP_Data == tableView){
            cell.New_Exp_View_Bt.layer.cornerRadius=10
            cell.New_Exp_View_Bt.layer.masksToBounds = true
            cell.New_Exp_View_Bt.tag = indexPath.row
            cell.New_Exp_View_Bt.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            print(AllExpenses[indexPath.row])
            cell.Sf_Name.text = AllExpenses[indexPath.row].SF_Name + " - " + AllExpenses[indexPath.row].SF_Code
            cell.Date_Sf.text = "\(AllExpenses[indexPath.row].Expense_Month) - \(AllExpenses[indexPath.row].Expense_Year)"
            }
        return cell
    }
    
    @objc func View_Det(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        let myDyPln = storyboard.instantiateViewController(withIdentifier: "SFC_Details_View") as! SFC_Details_View
        myDyPln.viewdetils_approv = ExpenseDetils[sender.tag]
        myDyPln.Sf_Typ = Get_Sf_Typ
        myDyPln.Naveapprovel_scr = 1
        viewController.setViewControllers([myDyPln], animated: false)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Period_TB == tableView {
            let item = lstOfPeriod[indexPath.row]
            print(item)
            // Nav_PeriodicData = [item as AnyObject]
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(item){
                UserDefaults.standard.set(encoded, forKey: "periodicDataapr")
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
            Per_From = From
            Per_To = To
            Per_Id = item.Period_Id
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
            AllExpenseData(From: From, To: To)
            
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
    
    @objc func buttonClicked(_ sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        print("Button clicked in cell at indexPath: \(indexPath)")
        print(sender.tag)
        Rej_Coun = 0
       // Approve_All.backgroundColor = UIColor(red: 0.06, green: 0.68, blue: 0.76, alpha: 1.00)
       let item = AllExpenses[sender.tag]
        Exp_approv_item = sender.tag
        Emp_Id = item.Emp_ID
        let dateFormatterss = DateFormatter()
        dateFormatterss.dateFormat = "yyyy-MM-dd"
        let From = dateFormatterss.string(from: FDate)
        let To = dateFormatterss.string(from: TDate)
        ExpenseReportDetailsSFC(fromdate: From, todate: To, SF_code: item.SF_Code)
        Aprsfcode = item.SF_Code
        Approval_Scr.isHidden = false
    }
    
    func AllExpenseData(From:String,To:String){
        self.ShowLoading(Message: "Loading...")
        AllExpenses.removeAll()
        let axn = "get/AllExpenseDataSFC"
        let apiKey = "\(axn)&sf_code=\(SFCode)&From_date=\(From)&To_date=\(To)&period_id=\(period_id)&Eff_Month=\(Eff_Month)&Eff_Year=\(Eff_Year)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String:AnyObject] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)
                                
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any],
                                   let data = jsonObject["AllExpenseData"] as? [AnyObject] {
                                    print(data)
                                    for i in data{
                                        print(i)
                                        let SF_Name = i["Sf_Name"] as? String
                                        //let Expense_Amt = String(format: "%.2f",(i["Expense_Amt"] as? Double)!)
                                        let Emp_ID = i["sf_emp_id"] as? String
                                        let Expense_Month = i["Expense_Month"] as? String ?? ""
                                        let Expense_Year = i["Expense_Year"] as? Int
                                        let SF_Code = i["Sf_Code"] as? String
                                        let Approve_Flag = i["Approve_Flag"] as? String ?? ""
                                        if  Approve_Flag != "1"{
                                            AllExpenses.append(AllExpenseDatas(SF_Name: SF_Name!, Expense_Amt: "0.0",Emp_ID: Emp_ID!, Expense_Month: Expense_Month, Expense_Year: Expense_Year!, SF_Code: SF_Code!))
                                        }
                                    }
                                    eXP_Data.reloadData()
                                    self.LoadingDismiss()
                                    if AllExpenses.count == 0 {
                                        Toast.show(message:"No Data Available")
                                    }
                                }else {
                                    print("Error: Some key in the data is nil or has the wrong type")
                                }
                            } else {
                                print("Error: Could not convert JSON to String")
                            }
                        } catch {
                            print("Error: \(error.localizedDescription)")
                            
                        }
                    }
                    
                case .failure(let error):
                    self.LoadingDismiss()
                    Toast.show(message: error.errorDescription ?? "Unknown Error")
                }
            }
    }
    
    func periodic(){
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
    func ExpenseReportDetailsSFC(fromdate:String,todate:String,SF_code:String){
        self.ShowLoading(Message: "Please Wait...")
        ExpenseDetils.removeAll()
        mgrRouts.removeAll()
        let apiKey: String = "getExpenseReportDetailsSFC&sf_code=\(SF_code)&division_code=\(DivCode)&from_date=\(fromdate)&to_date=\(todate)&stateCode=\(StateCode)&Design_code=\(UserSetup.shared.dsg_code)&Mn=\(Eff_Month)&Yr=\(Eff_Year)&PriID=\(period_id)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result{
            case .success(let value):
                print(value)
                if let json = value as? [String:AnyObject]{
                    print(json)
                    if let DistanceEntr = json["DistanceEntr"] as? [AnyObject],let dailyExpense = json["dailyExpense"] as? [AnyObject],let GetRouteChart = json["GetRouteChart"] as? [AnyObject], let add_sub_exp = json["add_sub_exp"] as? [AnyObject]{
                       
                        var sf_type = 0
                        if  GetRouteChart.isEmpty{
                            sf_type = 0
                        }else{
                            sf_type = GetRouteChart[0]["sf_type"] as? Int ?? 0
                        }
                        print(sf_type)
                        if sf_type == 2{
                            getExpenseDisSFC { [self] success in
                                if success {
                                    Get_Sf_Typ = 2
                                    Collect_mgr_rout(Getdata:GetRouteChart, distance_data: DistanceEntr, add_sub_exp: add_sub_exp,FromDate:fromdate,ToDate:todate,dailyExpense: dailyExpense, get_sf_code: SF_code )
                                } else {
                                    print("First function failed, second function won't run.")
                                }
                            }
                            
                        }else{
                            Get_Sf_Typ = 1
                            collectrout(Getdata:GetRouteChart, distance_data: DistanceEntr, add_sub_exp: add_sub_exp,FromDate:fromdate,ToDate:todate, dailyExpense: dailyExpense, get_sf_code: SF_code)
                        }
                    }
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.LoadingDismiss()
                }
            case .failure(let error):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.LoadingDismiss()
                }
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
    
    func Collect_mgr_rout(Getdata:[AnyObject], distance_data:[AnyObject], add_sub_exp:[AnyObject], FromDate:String, ToDate:String,dailyExpense:[AnyObject],get_sf_code:String){
        print(Getdata)
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
            
           // DA_Allowance_amount = String(MgrRout["Allowance_amount"] as? Double ?? 0)
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
                let newRout = Expense_approval_SFC.MgrRout(date: Date, Routs: getRouts, ClusterName: ClstrName_mgr, Mot_Name: Mot_Name, Mot_ID: Mot_ID, Fuel_amount: Fuel_amount, Miscellaneous_amount: miscellaneous_exp, Work_typ: Work_typ, status: status, Place_Types: Place_Types,sf_hq:Sf_hq,HQ_Allowance_amount:HQ_Allowance_amount,EX_Allowance_amount: EX_Allowance_amount,OS_Allowance_amount: OS_Allowance_amount)
                mgrRouts.append(newRout)
            } else {
                if let index = mgrRouts.firstIndex(where: { $0.date == Date }) {
                    print("Position of date '\(Date)': \(index)")
                    mgrRouts[index].Routs += "," + getRouts
                    mgrRouts[index].ClusterName += "," + ClstrName_mgr
                    mgrRouts[index].Place_Types += "," + Place_Types
                }else{
                    let newRout = Expense_approval_SFC.MgrRout(date: Date, Routs: getRouts, ClusterName: ClstrName_mgr, Mot_Name: Mot_Name, Mot_ID: Mot_ID, Fuel_amount: Fuel_amount, Miscellaneous_amount: miscellaneous_exp, Work_typ: Work_typ, status: status, Place_Types: Place_Types,sf_hq:Sf_hq,HQ_Allowance_amount:HQ_Allowance_amount,EX_Allowance_amount: EX_Allowance_amount,OS_Allowance_amount: OS_Allowance_amount)
                    mgrRouts.append(newRout)
                }
            }
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
            var PastSf = get_sf_code
            var CurentSf = ""
            var past_Toplace = ""
            var last_hq_id:String = ""
            var One_day_plac_typ = [String]()
            for (index,i) in substrings2.enumerated(){
                print(substrings2)
                while placstring.count < substrings2.count{
                    placstring.append("")
                }
                print(placstring)
                var Fromplace = ""
                var Toplace = ""
                var PlcTyp = [String]()
                if index == 0{
                    Fromplace = get_sf_code
                    Toplace = String(i)
                    last_hq_id = String(i)
                    print(Fromplace)
                    print(Toplace)
                    print(distance_data)
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
                                                Clusterfrom=x.sf_hq
                                                
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
                                                    Dis_km = Double(Dis)
                                                    One_day_plac_typ.append(Routs[0]["Place_Type"] as? String ?? "")
                                                }
                                            }
                                        }else{
                                            CurentSf = ""
                                            PastSf = ""

                                            Clusterfrom=x.sf_hq
                                            let Dis = Routss[0]["Distance_KM"] as? Int ?? 0
                                            Dis_km = Double(Dis)
                                            One_day_plac_typ.append(Routss[0]["Place_Type"] as? String ?? "")
                                        }
                                    }else{
                                        let Dis = Routs[0]["Distance_KM"] as? Int ?? 0
                                        Dis_km = Double(Dis)
                                        One_day_plac_typ.append(Routs[0]["Place_Type"] as? String ?? "")
                                    }
                            }
                            }else{
                                let Dis = Routs[0]["Distance_KM"] as? Int ?? 0
                                Dis_km = Double(Dis)
                                One_day_plac_typ.append(Routs[0]["Place_Type"] as? String ?? "")
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
                            if MrRouts.isEmpty{
                               Dis_km = 0
                            }else{
                                //let Fromplace = MrRouts[0]["Sf_code"] as? String ?? ""
                                let Fromplace = ""
                                let Toplace = substrings2[index]
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
                                    Dis_km = Dis_km+Double(dis)
                                    One_day_plac_typ.append(Routs[0]["Place_Type"] as? String ?? "")
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
                        let SwitchRouts = MrRouts.filter {
                            $0["To_Plc_Code"] as? String ?? "" == Toplaces &&
                            $0["Frm_Plc_Code"] as? String ?? "" == Fromplaces
                        }
                        print(SwitchRouts)
                        
                        if SwitchRouts.isEmpty{
                            Dis_km = 0
//                            if MrRouts.isEmpty{
//                                Dis_km = 0
//                            }else{
//                            
//                            let Fromplace = MrRouts[0]["Sf_code"] as? String ?? ""
//                            var Toplace = substrings2[index]
//                            let Routs = MrRouts.filter {
//                                $0["To_Plc_Code"] as? String ?? "" == Toplace &&
//                                $0["Frm_Plc_Code"] as? String ?? "" == Fromplace
//                            }
//                            print(Routs)
//                            
//                            if Routs.isEmpty{
//                                Dis_km = 0
//                            }else{
//                                let dis = Routs[0]["Distance_KM"] as? Int ?? 0
//                                Dis_km = Double(dis)
//                                One_day_plac_typ.append(Routs[0]["Place_Type"] as? String ?? "")
//                            }
//                        }
                        }else{
                            let dis = SwitchRouts[0]["Distance_KM"] as? Int ?? 0
                            Dis_km = Double(dis)
                            One_day_plac_typ.append(SwitchRouts[0]["Place_Type"] as? String ?? "")
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
                    }
                    // bjbnnjhnj
                 
                }
                
                
                if index != 0 {
                    if String(substrings2[index-1]) != String(i){
                        fare = Double(Dis_km) * Double(Fuel_amount)
                        let itms: [String: Any]=["date": getdate,"modeoftravel":MOT_Name,"modeid":Mot_ID,"fromplace":Fromplace,"Toplace":Toplace,"Fromid":Fromplace,"Toid":Toplace,"Dist":Dis_km,"per_km_fare":String(Fuel_amount),"fare":String(format: "%.2f", fare),"Cls_From":Clusterfrom,"Cls_To":ClusterTo];
                        let jitm: AnyObject = itms as AnyObject
                        print(itms)
                        SFCDetils.append(jitm)
                        print(SFCDetils)
                    }
                }else{
                    fare = Double(Dis_km) * Double(Fuel_amount)
                    let itms: [String: Any]=["date": getdate,"modeoftravel":MOT_Name,"modeid":Mot_ID,"fromplace":Fromplace,"Toplace":Toplace,"Fromid":Fromplace,"Toid":Toplace,"Dist":Dis_km,"per_km_fare":String(Fuel_amount),"fare":String(format: "%.2f", fare),"Cls_From":Clusterfrom,"Cls_To":ClusterTo];
                    let jitm: AnyObject = itms as AnyObject
                    print(itms)
                    SFCDetils.append(jitm)
                    print(SFCDetils)
                }
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
                            let mgr_Returnrouts = distance_data.filter{$0["Sf_code"] as? String == get_sf_code}
                            
                            let Mgr_From = get_sf_code
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
                            
                            let mgr_Returnrouts = distance_data.filter{$0["Sf_code"] as? String == get_sf_code}
                            
                            let Mgr_From = get_sf_code
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
            }else if Dayend_Place_Types == "OS-EX"{
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
            
            if One_day_plac_typ.contains("HQ") && !One_day_plac_typ.contains("EX") && !One_day_plac_typ.contains("OS"){
                print("Cover Only HQ")
                print(UserSetup.shared.ExpDist_HQ)
                
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
            
            if !One_day_plac_typ.contains("HQ") && One_day_plac_typ.contains("EX") && !One_day_plac_typ.contains("OS"){
                Total_amts = Total_amts+(Double(Total_Dis)  * Double(Fuel_amount))
                Total_amts = Total_amts + Double(x.EX_Allowance_amount)
                DA_Allowance_amount = String(x.EX_Allowance_amount)
            }
            
            if One_day_plac_typ.contains("OS"){
                Total_amts = Total_amts+(Double(Total_Dis)  * Double(Fuel_amount))
                Total_amts = Total_amts + Double(x.OS_Allowance_amount)
                DA_Allowance_amount = String(x.OS_Allowance_amount)
            }
            
            if One_day_plac_typ.contains("OX") && !One_day_plac_typ.contains("HQ") && !One_day_plac_typ.contains("EX") && !One_day_plac_typ.contains("OS"){
                Total_amts = Total_amts+(Double(Total_Dis)  * Double(Fuel_amount))
                Total_amts = Total_amts + Double(x.OS_Allowance_amount)
                DA_Allowance_amount = String(x.OS_Allowance_amount)
            }
            if One_day_plac_typ.contains("OS-EX") && !One_day_plac_typ.contains("HQ") && !One_day_plac_typ.contains("EX") && !One_day_plac_typ.contains("OS"){
                Total_amts = Total_amts+(Double(Total_Dis)  * Double(Fuel_amount))
                Total_amts = Total_amts + Double(x.OS_Allowance_amount)
                DA_Allowance_amount = String(x.OS_Allowance_amount)
            }
            
            print(One_day_plac_typ)
            
            
            let commaSeparatedString = One_day_plac_typ.joined(separator: ",")

            ExpenseDetils.append(ExpenseDatas(date: getdate, Work_typ: Work_typ,miscellaneous_exp:String(format: "%.2f", miscellaneous_exp), Total_Amt: String(Total_amts), Returnkm: String(Returnkm), Plc_typ: Dayend_Place_Types, Fuel_amount: String(Fuel_amount), Mot_Name: MOT_Name, status: status, Da_amount: DA_Allowance_amount, Mot_ID: x.Mot_ID, Place_Types: commaSeparatedString, Work_place: x.ClusterName, Total_dis: String(Total_Dis), SFCdetils:SFCDetils))
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
                    status: "Not Climed", Da_amount: "0", Mot_ID: "", Place_Types: "", Work_place: "", Total_dis: "",
                    SFCdetils: []
                ))
            }
        }
        
        ExpenseDetils.sort { $0.date < $1.date }
        
        print(ExpenseDetils)
        
        var sum_Total_all = 0.0
        for i in ExpenseDetils{
            let Total_Amt =  Double(i.Total_Amt) ?? 0.0
            sum_Total_all = sum_Total_all + Total_Amt
        }
        // Expense Summary
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: String(sum_Total_all)))
        
        Expense_Amt = String(sum_Total_all)
        
        
        var total_sum = 0.0
        var total_ded = 0.0
        for item3 in add_sub_exp{
            print(item3)
            let exp_amnt = Double(truncating: (item3["exp_amnt"] as? NSNumber)!)
            if let add_sub = item3["add_sub"] as? String,add_sub == "+"{
                total_sum = total_sum + exp_amnt
            }else{
                total_ded = total_ded + exp_amnt
            } }
        
        sum_Total_all = sum_Total_all + total_sum
        sum_Total_all = sum_Total_all - total_ded
        
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "\(total_sum)"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "\(total_ded)"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: "\(sum_Total_all)"))
        
        Applied_ExpAmnt = String(sum_Total_all)
        
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
    
    func collectrout(Getdata:[AnyObject],distance_data:[AnyObject],add_sub_exp:[AnyObject],FromDate:String,ToDate:String,dailyExpense:[AnyObject],get_sf_code:String){
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
            let allownace_typ = Getdata[count]["Dayend_Place_Types"] as? String ?? ""
            allow.append(allownace_typ)
            let Place_Types = i["Place_Types"] as? String ?? ""
            var substrings = Place_Types.split(separator: ",")
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
            var One_day_plac_typ = [String]()
            
            for (index,i) in result2.enumerated(){
                List_Count = List_Count + 1
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
                    print(BasLevelFilter)
                    Dis_km = BasLevelFilter[0]["Distance_KM"] as? Int ?? 0
                    One_day_plac_typ.append(BasLevelFilter[0]["Place_Type"] as? String ?? "")
                }
                
                if BasLevelFilter.isEmpty{
                    
//                    let BasLevelFilter = lstdiskm.filter {
//                        $0["To_Plc_Code"] as? String == To_Place &&
//                        $0["Frm_Plc_Code"] as? String == get_sf_code
//                    }
//                    
//                    if !BasLevelFilter.isEmpty{
//                        print(BasLevelFilter)
//                        Dis_km = BasLevelFilter[0]["Distance_KM"] as? Int ?? 0
//                        One_day_plac_typ.append(BasLevelFilter[0]["Place_Type"] as? String ?? "")
//                    }else{
                        Dis_km = 0
                   // }
                }
                
                
                //Find Next switch Route
//                if List_Count+1 != result2.count{
//                    let Nextswitch_From_Place = result2[List_Count]
//                    let Nextswitch_To_Place = result2[List_Count+1]
//                    let Nextswitch_BasLevelFilter = distance_data.filter {
//                        $0["To_Plc_Code"] as? String == Nextswitch_To_Place &&
//                        $0["Frm_Plc_Code"] as? String == Nextswitch_From_Place
//                    }
//                    if Nextswitch_BasLevelFilter.isEmpty{
//                        print(BasLevelFilter)
//                        Dis_km = Dis_km + Dis_km
//                    }
//                }
                
                if index != 0 {
                    if i != result2[List_Count]{
                        Totalkm = Totalkm + Dis_km
                        fare = Double(Dis_km) * per_km_fare
                        let itms: [String: Any]=["date": date,"modeoftravel":MOT_Name,"modeid":modeid,"fromplace":From_Place,"Toplace":To_Place,"Fromid":From_Place,"Toid":To_Place,"Dist":Dis_km,"per_km_fare":String(per_km_fare),"fare":String(format: "%.2f", fare),"cluster_from":cluster_from,"cluster_to":cluster_to];
                        let jitm: AnyObject = itms as AnyObject
                        SFCDetils.append(jitm)
                        print(SFCDetils)
                    }
                    
                }else{
                    Totalkm = Totalkm + Dis_km
                    fare = Double(Dis_km) * per_km_fare
                    let itms: [String: Any]=["date": date,"modeoftravel":MOT_Name,"modeid":modeid,"fromplace":From_Place,"Toplace":To_Place,"Fromid":From_Place,"Toid":To_Place,"Dist":Dis_km,"per_km_fare":String(per_km_fare),"fare":String(format: "%.2f", fare),"cluster_from":cluster_from,"cluster_to":cluster_to];
                    let jitm: AnyObject = itms as AnyObject
                    SFCDetils.append(jitm)
                    print(SFCDetils)
                }
                
              
            }
           // Collect return distance.
            print(Dayend_Place_Types)
            print(One_day_plac_typ)
            print(date)
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
            }else if One_day_plac_typ.last ?? "" == "OS-EX"{
                Returnkm = 0
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
                    
                    print(Total_amts)
                    
                    Total_amts = Total_amts + Double(HQ_Allowance_amount)
                    
                    print(Total_amts)
                    
                    DA_Allowance_amount = String(HQ_Allowance_amount)
                }else if UserSetup.shared.ExpDist_HQEX == 2{
                    Total_amts = Total_amts+(Double(Totalkm)  * Double(per_km_fare))
                    Total_amts = Total_amts + Double(EX_Allowance_amount)
                    
                    DA_Allowance_amount = String(EX_Allowance_amount)
                }
                
            }
            
            if !One_day_plac_typ.contains("HQ") && One_day_plac_typ.contains("EX") && !One_day_plac_typ.contains("OS"){
                Total_amts = Total_amts+(Double(Totalkm)  * Double(per_km_fare))
                Total_amts = Total_amts + Double(EX_Allowance_amount)
                DA_Allowance_amount = String(EX_Allowance_amount)
            }
            
            
            if One_day_plac_typ.contains("OS"){
                Total_amts = Total_amts+(Double(Totalkm)  * Double(per_km_fare))
                Total_amts = Total_amts + Double(OS_Allowance_amount)
                DA_Allowance_amount = String(OS_Allowance_amount)
            }
            if One_day_plac_typ.contains("OX") && !One_day_plac_typ.contains("HQ") && !One_day_plac_typ.contains("EX") && !One_day_plac_typ.contains("OS"){
                Total_amts = Total_amts+(Double(Totalkm)  * Double(per_km_fare))
                Total_amts = Total_amts + Double(OS_Allowance_amount)
                DA_Allowance_amount = String(OS_Allowance_amount)
            }
            
            if One_day_plac_typ.contains("OS-EX") && !One_day_plac_typ.contains("HQ") && !One_day_plac_typ.contains("EX") && !One_day_plac_typ.contains("OS"){
                Total_amts = Total_amts+(Double(Totalkm)  * Double(per_km_fare))
                Total_amts = Total_amts + Double(OS_Allowance_amount)
                DA_Allowance_amount = String(OS_Allowance_amount)
            }
            
            
            print(Total_amts)
            let commaSeparatedString = One_day_plac_typ.joined(separator: ",")
            ExpenseDetils.append(ExpenseDatas(date: date, Work_typ: Work_typ,miscellaneous_exp:String(format: "%.2f", miscellaneous_exp), Total_Amt: String(Total_amts), Returnkm: String(Returnkm), Plc_typ: Dayend_Place_Types, Fuel_amount: String(per_km_fare), Mot_Name: Mot_Name, status: status, Da_amount: DA_Allowance_amount, Mot_ID: String(modeid), Place_Types: commaSeparatedString, Work_place: cluster_chart, Total_dis: String(Totalkm), SFCdetils:SFCDetils))
            count = count + 1
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
                    status: "NOT CLAIMED", Da_amount: "", Mot_ID: "", Place_Types: "", Work_place: "", Total_dis: "",
                    SFCdetils: []
                ))
            }
        }

        
        ExpenseDetils.sort { $0.date < $1.date }

        print(ExpenseDetils)
        
        var sum_Total_all = 0.0
        for i in ExpenseDetils{
            let Total_Amt =  Double(i.Total_Amt) ?? 0.0
            sum_Total_all = sum_Total_all + Total_Amt
        }
        // Expense Summary
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: String(sum_Total_all)))
        
        Expense_Amt = String(sum_Total_all)

        var total_sum = 0.0
        var total_ded = 0.0
        for item3 in add_sub_exp{
            print(item3)
            let exp_amnt = Double(truncating: (item3["exp_amnt"] as? NSNumber)!)
            if let add_sub = item3["add_sub"] as? String,add_sub == "+"{
                total_sum = total_sum + exp_amnt
            }else{
                total_ded = total_ded + exp_amnt
            } }
        
        sum_Total_all = sum_Total_all + total_sum
        sum_Total_all = sum_Total_all - total_ded
        
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "\(total_sum)"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "\(total_ded)"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: "\(sum_Total_all)"))
        
        Applied_ExpAmnt = String(sum_Total_all)
        
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
        
    @objc private func Close_Apr_scr() {
        Approval_Scr.isHidden = true
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
    
    
    
    @IBAction func Appr_sfc(_ sender: Any) {
  
        let First = ExpenseDetils.first?.date
        let last = ExpenseDetils.last?.date
            
            if First == Per_From && last == Per_To{

            }else{
                Toast.show(message: "Complete this period.")
                return
            }
        
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to approve?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [self] _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDateString = dateFormatter.string(from: Date())
            var sPItems:String = ""
            
            let filteredExpenseDetails = ExpenseDetils.filter { $0.status != "NOT CLAIMED" }

            print(filteredExpenseDetails)
            
            for j in filteredExpenseDetails{
                sPItems = sPItems + "{\"WorkType\":\"\(j.Work_typ)\",\"Expense_Date\":\"\(j.date)\",\"Expense_All_Type\":\"\(j.Place_Types)\",\"Expense_Distance\":\"\(j.Total_dis)\",\"Expense_Fare\":\(j.Total_Amt),\"Expense_DA\":\(j.Da_amount),\"Daily_Total\":\"\(j.Total_Amt)\",\"Dayplan_Work_place\":\"\(j.Work_place)\",\"MOT\":\"\(j.Mot_Name)\",\"mot_id\":\"\(j.Mot_ID)\",\"st_endNeed\":\"0\",\"max_km\":\"0\",\"fuel_charge\":\"\(j.Fuel_amount)\",\"exp_km\":\"\(j.Total_dis)\",\"exp_amount\":\"\(j.miscellaneous_exp)\",\"SF_Code\":\"\(Aprsfcode)\"},"
            }
            var sPItems2:String = ""
            if sPItems.hasSuffix(",") {
                while sPItems.hasSuffix(",") {
                    sPItems.removeLast()
                }
                sPItems2 = sPItems
            }
            
            let jsonString = "[{\"Expense_New_Sfc\":[" + sPItems2 + "]}]"
            let params: Parameters = [
                "data": jsonString //"["+jsonString+"]"//
            ]
            
            print(params)
            
            let axn = "approv_SFC"
            let apiKey = "\(axn)&sf_code=\(Aprsfcode)&expense_Month=\(Eff_Month)&Expense_Year=\(Eff_Year)&Expense_Amt=\(Expense_Amt)&Exp_Sent_date=\(formattedDateString)&Approval_Date=\(formattedDateString)&Applied_ExpAmnt=\(Applied_ExpAmnt)&Appr_By=\(SFCode)&Periodic_ID=\(Per_Id)&Pri_FrmDt=\(Per_From)&Pri_ToDt=\(Per_To)"
            
            let encodedApiKey = apiKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print(apiKey)
            print("test")
            AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + encodedApiKey!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                AFdata in
                switch AFdata.result{
                case .success(let value):
                    print(value)
                    GlobalFunc.movetoHomePage()
                    Toast.show(message: "Approved Successfully")
//                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
//                    UIApplication.shared.windows.first?.rootViewController = viewController
//                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)  //, controller: self
                }
            }
            self.navigationController?.popViewController(animated: true)
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
        
        
      
        
        }
    

}
