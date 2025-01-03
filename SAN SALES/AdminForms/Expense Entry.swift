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
class Expense_Entry: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
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
    @IBOutlet weak var Sent_apr_bt: UIButton!
    static let shared = Expense_Entry()

    
    struct Apr_Data:Codable{
    let Period_Id: String
    let Eff_Month: String
    let Eff_Year: String
    let From_Date: String
    let To_Date:String
    }
    
    let LocalStoreage = UserDefaults.standard
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = "",SF_type: String = ""
    var Period:[PeriodicData] = []
    var lstOfPeriod:[PeriodicData] = []
    var Sent_Apr_Det:[Apr_Data] = []
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
    var Nav_PeriodicData:[AnyObject] = []
    var No_Of_Days_In_Perio = 0
    var Allow_Apr:Bool = false
    var selected_period = ""
    var apr_flg = "0"
    var apr_flgsfc = "0"
    var apr_flg2 = ""
    var Load_Cout = 0
    var Load_Couts = 0
    var srt_exp: [[String: Any]] = []
    var srt_end_exp: [[String: Any]] = []
    var attance_flg:[[String: Any]] = []
    var lstWortyp: [AnyObject] = []
    var exp_neededs = 0
    override func viewDidLoad(){
        super.viewDidLoad()
      if UserSetup.shared.SrtEndKMNd == 2 {
          Sent_apr_bt.isHidden = true
        }
        Sent_apr_bt.backgroundColor = .lightGray
        YearPostion.text = selectYear
        let Month = Calendar.current.component(.month, from: Date()) - 1
        let formattedPosition = String(format: "%02d", Month + 1)
        SelectMonth = formattedPosition
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-yyyy"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        selectmonth.text = formattedDate
        blureView.bounds = self.view.bounds
        PopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        PopUpView.layer.cornerRadius = 10
        // LocalStoreage
        let lstWorktypData: String=LocalStoreage.string(forKey: "Worktype_Master")!
        if let list = GlobalFunc.convertToDictionary(text: lstWorktypData) as? [AnyObject] {
            lstWortyp = list;
            print(lstWortyp)
        }
        getUserDetails()
        calendar.delegate=self
        calendar.dataSource=self
        DataTB.dataSource=self
        DataTB.delegate=self
        Collection_Of_Month.delegate=self
        Collection_Of_Month.dataSource=self
        BackBT.addTarget(target: self, action: #selector(GotoHome))
        SelPeriod.addTarget(target: self, action: #selector(OpenWindo))
        selectmonth.addTarget(target: self, action: #selector(OpenPopUP))
        ClosePopup.addTarget(target: self, action: #selector(ClosePopUP))
        YearPostion.addTarget(target: self, action: #selector(OpenYear))
        MonthPostion.addTarget(target: self, action: #selector(OpenMonth))
        calendar.placeholderType = .none
//        let monthsView = MonthsView(frame: MonthView.bounds)
//            monthsView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
//            MonthView.addSubview(monthsView)
        
        print(VisitData.shared.Nav_id)
//        if VisitData.shared.Nav_id == 1 {
//            VisitData.shared.Nav_id = 0
//
//            set_priod_calendar()
//        }
        periodic()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(VisitData.shared.Nav_id)
        if VisitData.shared.Nav_id == 1 {
            VisitData.shared.Nav_id = 0
            set_priod_calendar()
        }
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
    SF_type=prettyJsonData["SF_type"] as? String ?? ""
    }
    
    func set_priod_calendar(){
        if let data = UserDefaults.standard.data(forKey: "periodicData"),
           let item = try? JSONDecoder().decode(PeriodicData.self, from: data) {
           // self.ShowLoading(Message: "Loading...")
            Nav_PeriodicData = [item as AnyObject]
            print(Nav_PeriodicData)
            removeLabels()
            SelPeriod.text = item.Period_Name
            selected_period = item.Period_Id
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let From_Date = item.From_Date
            let mont = item.Eff_Month
            let year = item.Eff_Year
            period_from_date = "\(year)-\(mont)-"+From_Date
            SelectMonth = "\(mont)"
            if let date = dateFormatter.date(from: "\(year)-\(mont)-" + From_Date){
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
            let month = DateFormatter()
            month.dateFormat = "MMM-yyyy"
            let From = dateFormatterss.string(from: FDate)
            let To = dateFormatterss.string(from: TDate)
            selectmonth.text = month.string(from: TDate)
            
            if let startDate = dateFormatterss.date(from: From),
               let endDate = dateFormatterss.date(from: To) {
                let days = daysBetweenDates(startDate, endDate)
                print("Number of days between the two dates: \(days)")
                No_Of_Days_In_Perio = days + 1
            } else {
                print("Invalid date format")
            }
            print(item.Eff_Month)
            print(FDate)
            print(TDate)
            Sent_Apr_Det.append(Apr_Data(Period_Id: item.Period_Id, Eff_Month: String(item.Eff_Month), Eff_Year: String(item.Eff_Year), From_Date: item.From_Date, To_Date: item.To_Date))
            
          if  UserSetup.shared.SrtEndKMNd == 2{
              expSubmitDatesSFC()
          }else{
              expSubmitDates()
          }
           
            calendar.reloadData()
            Load_Cout = 1
            Load_Couts = 1
            //UserDefaults.standard.removeObject(forKey: "periodicData")
        }else{
            print("no")
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        
        if UserSetup.shared.SrtEndKMNd == 2{
            if apr_flg == "1"{
                Toast.show(message: "Expense Already Approved")
                return
            }
        }
        if (SelPeriod.text == "Select Period"){
            Toast.show(message: "Select Period")
            return
        }
        if monthPosition == .previous || monthPosition == .next {
            return
        }
        let dateFormatter = DateFormatter()
        let selectdate = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        selectdate.dateFormat = "dd-MM-yyyy"
        let dates = dateFormatter.string(from: date)
        let dates2 = selectdate.string(from: date)
        print(dates)
        var exp:Int = 0
        var exp1:Int = 0
        var exp_needed:Int = 0
        
        print(UserSetup.shared.SrtEndKMNd)
        print(UserSetup.shared.exp_auto)
        print(UserSetup.shared.SrtNd)
        if validateForm(Seldate: date) == false {
            return
        }
        if (UserSetup.shared.SrtEndKMNd == 1 && UserSetup.shared.exp_auto == 2 ){
            if (UserSetup.shared.SrtNd == 0){
                if !lstWortyp.isEmpty{
                    print(lstWortyp)
                    for lst in lstWortyp{
                        if (attance_flg.count > 0){
                            print(attance_flg)
                            for i in attance_flg{
                                if let Att_FWFlg = i["FWFlg"] as? String,
                                   let Work_FWFlg = lst["FWFlg"] as? String,
                                   let pln_date = i["pln_date"] as? String ,
                                   pln_date == dates2 || pln_date == dates && Att_FWFlg == Work_FWFlg {
                                    exp_needed = (lst["exp_needed"] as? Int ?? 0)!
                                    exp_neededs = (lst["exp_needed"] as? Int ?? 0)!
                                    
                                }
                            }
                        }
                    }
                }else{
                    print("No Data")
                }
            }
            for i in srt_exp {
                if let full_date = i["full_date"] as? String, dates == full_date{
                    exp = 1
                }
            }
            for i in srt_end_exp {
                if let full_date = i["full_date"] as? String, dates == full_date{
                    exp1 = 1
                }
            }
           
            if (exp==0&&exp1==0&&exp_needed==1){
                let alert = UIAlertController(title: "Confirm Selection", message: "start expense missing. Do u want to submit start expense?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                    return
                })
                alert.addAction(UIAlertAction(title: "OK", style: .destructive) { [self] _ in
                    self.dismiss(animated: true, completion: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewControllers = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                    let myDyPln = storyboard.instantiateViewController(withIdentifier: "Start_Expense") as! Start_Expense
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.string(from: date)
                     myDyPln.Screan_Heding = "Start Expense"
                     myDyPln.Show_Date = true
                     myDyPln.Curent_Date = formattedDate
                     myDyPln.Exp_Nav = "Ex_Ent"
                    viewControllers.setViewControllers([myDyPln], animated: false)
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewControllers)
                })
                self.present(alert, animated: true)
                
            }else if (exp==1&&exp_needed==1){
                let alert = UIAlertController(title: "Confirm Selection", message: "end expense missing. Do u want to submit end expense?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                    return
                })
                alert.addAction(UIAlertAction(title: "OK", style: .destructive) { [self] _ in
                    self.dismiss(animated: true, completion: nil)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.string(from: date)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                    let myDyPln = storyboard.instantiateViewController(withIdentifier: "End_Expense") as! End_Expense
                    myDyPln.End_exp_title = "Ex_Ent"
                    myDyPln.Date_Nd = true
                    myDyPln.Date = formattedDate
                    viewController.setViewControllers([myDyPln], animated: false)
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
                })
                self.present(alert, animated: true)
            }else{
                new_DateofExpense(date: date)
            }
        }else{
            new_DateofExpense(date: date)
        }
   
    }
    func addLetterA(to cell: FSCalendarCell?, text:String){
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
    func addDART(to cell: FSCalendarCell?,text:String){
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
    
    func addDART_ORG(to cell: FSCalendarCell?,text:String){
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
                        selectmonth.text = "\(item)-\(selectYear)"
                        SelPeriod.text = "Select Period"
                        removeLabels()
                        calendar.reloadData()
                        ClosePopUP()
                    }
                }
            }
            
            
          
        }else if (SelMod == "YEAR"){
            let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
            if (currentMonthIndex == 0){
                let item = Monthtext_and_year[indexPath.row]
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
        return lstOfPeriod.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = lstOfPeriod[indexPath.row].Period_Name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Sent_Apr_Det.removeAll()
        let item = lstOfPeriod[indexPath.row]
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(item){
            UserDefaults.standard.set(encoded, forKey: "periodicData")
        }
        Nav_PeriodicData = [item as AnyObject]
        removeLabels()
        SelPeriod.text = item.Period_Name
        selected_period = item.Period_Id
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
        print(item.Eff_Month)
        print(FDate)
        print(TDate)
        Sent_Apr_Det.append(Apr_Data(Period_Id: item.Period_Id, Eff_Month: String(item.Eff_Month), Eff_Year: String(item.Eff_Year), From_Date: item.From_Date, To_Date: item.To_Date))
        if  UserSetup.shared.SrtEndKMNd == 2{
            expSubmitDatesSFC()
        }else{
            expSubmitDates()
        }
        calendar.reloadData()
        TextSeh.text = ""
        Selwind.isHidden = true
    }
    func daysBetweenDates(_ startDate: Date, _ endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }

    func maximumDate(for calendar: FSCalendar) -> Date {
        print(TDate)
        return TDate
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        print(FDate)
       return FDate
    }
    func periodic(){
        if Load_Cout == 0{
            self.ShowLoading(Message: "Loading...")
        }else{
            Load_Cout = 0
        }
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
                    print(value)
                    if let json = value as? [String: Any] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)

                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any],
                                   let data = jsonObject["data"] as? [AnyObject] {
                                    print(data)
                                    for i in data {
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
                                           let disRank = i["dis_Rank"] as? String{
                                               Period.append(PeriodicData(Division_Code: 0, Eff_Month: Int(effMonth)!, Eff_Year: effYear, From_Date: fromDate, Period_Id: periodId, Period_Name: periodName, To_Date: toDate, dis_Rank: disRank))
                                           }
                                    }
                                    print(Period)
                                    lstOfPeriod = Period
                                    DataTB.reloadData()
                                    print(lstOfPeriod)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        self.LoadingDismiss()
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
    
    func expSubmitDates(){
       // self.ShowLoading(Message: "Loading...")
        let axn = "get/expSubmitDates"
        let apiKey = "\(axn)&desig=\(Desig)&divisionCode=\(DivCode)&from_date=\(period_from_date)&to_date=\(period_to_date)&month=\(SelectMonth)&rSF=\(SFCode)&year=\(selectYear)&selected_period=\(selected_period)&sfCode=\(SFCode)&stateCode=\(StateCode)&sf_code=\(SFCode)"
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
                                var count = 0
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any]{
                                    print(jsonObject)
                                    var exp:Int = 0
                                    var exp1:Int = 0
                                    // srt_exp
                                    if let srt_exps = jsonObject["srt_exp"] as? [[String: Any]] {
                                        srt_exp = srt_exps
                                    }
                                    //srt_end_exp
                                    if let srt_end_exps = jsonObject["srt_end_exp"] as? [[String: Any]]{
                                        srt_end_exp = srt_end_exps
                                    }
                                    // attance_flg
                                    if let attance_flgs = jsonObject["attance_flg"] as? [[String: Any]]{
                                        attance_flg = attance_flgs
                                    }
                                    
                                    // apr_flg
                                    if let apr_flags = jsonObject["apr_flag"] as?  [[String: Any]]{
                                        print(apr_flags)
                                        if apr_flags.isEmpty{
                                            apr_flg = "0"
                                            apr_flg2 = ""
                                           
                                        }else{
                                            if let Aprflg = apr_flags[0]["approve_flag"] as? Int{
                                                apr_flg = String(Aprflg)
                                                if String(Aprflg) == "0"{
                                                    apr_flg2 = "12"
                                                }
                                                if 1 <= Aprflg{
                                                    apr_flg2 = "13"
                                                }
                                                
                                            }
                                        }
                                    }
//                                    if Load_Couts == 1{
//                                        apr_flg = "-1"
//                                        Load_Couts = 0
//                                    }
                                    
                                    if apr_flg == "0" || apr_flg == "1"{
                                        Sent_apr_bt.backgroundColor = .lightGray
                                    }else{
                                        Sent_apr_bt.backgroundColor = UIColor(red: 0.06, green: 0.68, blue: 0.76, alpha: 1.00)
                                    }
                                    
                                    // attance_flg
                                    
                                    exp_SubitDate = []
                                    attance_flg_L = []
//                                    if let attance_flg = jsonObject["attance_flg"] as?  [[String: Any]]{
//                                        print(attance_flg)
//                                        if attance_flg.isEmpty{
//                                            MisDatesDatas = []
//                                            return
//                                        }
//
//                                        print(attance_flg)
//
//                                        let dateFormatter = DateFormatter()
//                                        dateFormatter.dateFormat = "dd/MM/yyyy"
//                                        let dates = attance_flg.compactMap { dictionary -> Date? in
//                                            guard let dateString = dictionary["pln_date"] as? String else { return nil }
//                                            return dateFormatter.date(from: dateString)
//                                        }
//                                        for item in attance_flg{
//                                            let datess = item["pln_date"] as? String
//                                            let Formated_Date = dateFormatter.date(from: datess!)
//                                            let Leave = item["FWFlg"] as? String
//                                            if (Leave == "L"){
//                                                count = count + 1
//                                                attance_flg_L = attance_flg
//                                                let cell = calendar.cell(for: Formated_Date!, at: .current)
//                                                addLetterA(to: cell, text: "L")
//                                            }
//                                            if (Leave == "H"){
//                                                count = count + 1
//                                                attance_flg_L = attance_flg
//                                                let cell = calendar.cell(for: Formated_Date!, at: .current)
//                                                addLetterA(to: cell, text: "H")
//                                            }
//                                            if (Leave == "W"){
//                                                count = count + 1
//                                                attance_flg_L = attance_flg
//                                                let cell = calendar.cell(for: Formated_Date!, at: .current)
//                                                addLetterA(to: cell, text: "W")
//                                            }
//                                        }
//
//
//                                        let olDateFormatter = DateFormatter()
//                                        olDateFormatter.dateFormat = "yyyy-MM-dd"
//                                        let startDate = olDateFormatter.date(from: period_from_date)
//                                        let endDate = olDateFormatter.date(from: period_to_date)
//                                        var allDates = [Date]()
//                                        var currentDate = startDate
//                                        while currentDate! <= endDate!{
//                                            allDates.append(currentDate!)
//                                            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate!)!
//                                        }
//                                        let currentDates = Date()
//                                        var missingDates = allDates.filter { !dates.contains($0) }
//                                        missingDates = missingDates.filter { $0 <= currentDates }
//                                        print(missingDates)
//                                        MisDatesDatas = missingDates
//                                        MisDatesDatas = MisDatesDatas.filter { $0 <= currentDates }
//                                        print(MisDatesDatas)
//                                        missingDates.forEach {
//                                            print(dateFormatter.string(from: $0))
//                                            let missingDates = dateFormatter.string(from: $0)
//                                                let formatter = DateFormatter()
//                                                formatter.dateFormat = "dd/MM/yyyy"
//                                                if let missingDate = formatter.date(from: missingDates) {
//                                                    print(missingDate)
//                                                    let cell = calendar.cell(for: missingDate, at: .current)
//                                                    addLetterA(to: cell, text: "A")
//                                                } else {
//                                                    print("Error: Unable to convert string to date.")
//                                                }
//                                        }
//                                    }
                                    
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
                                 
                                    if let attance_flg = jsonObject["attance_flg"] as?  [[String: Any]]{
                                        print(attance_flg)
                                        if attance_flg.isEmpty{
                                            MisDatesDatas = []
                                            return
                                        }
                                        
                                        print(attance_flg)
                                        
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
                                                count = count + 1
                                                attance_flg_L = attance_flg
                                                let cell = calendar.cell(for: Formated_Date!, at: .current)
                                                addLetterA(to: cell, text: "L")
                                            }
                                            if (Leave == "H"){
                                                count = count + 1
                                                attance_flg_L = attance_flg
                                                let cell = calendar.cell(for: Formated_Date!, at: .current)
                                                addLetterA(to: cell, text: "H")
                                            }
                                            if (Leave == "W"){
                                                count = count + 1
                                                attance_flg_L = attance_flg
                                                let cell = calendar.cell(for: Formated_Date!, at: .current)
                                                addLetterA(to: cell, text: "W")
                                            }
                                        }
                                        
                                        
                                        let olDateFormatter = DateFormatter()
                                        olDateFormatter.dateFormat = "yyyy-MM-dd"
                                        let startDate = olDateFormatter.date(from: period_from_date)
                                        let endDate = olDateFormatter.date(from: period_to_date)
                                        var allDates = [Date]()
                                        var currentDate = startDate
                                        while currentDate! <= endDate!{
                                            allDates.append(currentDate!)
                                            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate!)!
                                        }
                                        let currentDates = Date()
                                        var missingDates = allDates.filter { !dates.contains($0) }
                                        missingDates = missingDates.filter { $0 <= currentDates }
                                        print(missingDates)
                                        MisDatesDatas = missingDates
                                        MisDatesDatas = MisDatesDatas.filter { $0 <= currentDates }
                                        print(MisDatesDatas)
                                        missingDates.forEach {
                                            print(dateFormatter.string(from: $0))
                                            let missingDates = dateFormatter.string(from: $0)
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "dd/MM/yyyy"
                                            if let missingDate = formatter.date(from: missingDates) {
                                                    print(missingDate)
                                                    let cell = calendar.cell(for: missingDate, at: .current)
                                                    if let cell = cell {
                                                        addLetterA(to: cell, text: "A")
                                                    } else {
                                                        print("Cell for date \(missingDates) is nil.")
                                                    }
                                                } else {
                                                    print("Date string \(missingDates) is invalid.")
                                                }
                                        }
                                    }
                                    
                                    //rej_exp

                                    if let exp_SubitDate = exp_SubitDate as? [[String: Any]],
                                        let rej_exp = jsonObject["rej_exp"] as? [[String: Any]] {

                                        // Convert data1 dates to Date objects
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "dd/MM/yyyy"
                                        let expDates = exp_SubitDate.compactMap { dictionary -> Date? in
                                            guard let dateString = dictionary["full_date"] as? String else {
                                                return nil
                                            }
                                            return dateFormatter.date(from: dateString)
                                        }

                                        // Iterate through data2 and compare dates
                                        for i in rej_exp {
                                            if let dateString = i["full_date"] as? String {
                                                if let date = dateFormatter.date(from: dateString) {
                                                    let cell = calendar.cell(for: date, at: .current)
                                                    // Check if the date exists in data1
                                                    if expDates.contains(date) {
                                                        addDART(to: cell, text: ".")
                                                    } else {
                                                        addLetterA(to: cell, text: "R")
                                                    }
                                                } else {
                                                    print("Failed to convert \(dateString) to Date.")
                                                }
                                            } else {
                                                print("Date string is nil or not in the expected format.")
                                            }
                                        }
                                    }

                                    let Tot = count+MisDatesDatas.count+exp_SubitDate.count
                                    if (No_Of_Days_In_Perio == Tot){
                                        Allow_Apr = false
                                    }else{
                                        Allow_Apr = true
                                    }
                                    print(Allow_Apr)
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
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                        self.LoadingDismiss()
//                    }
                    
                case .failure(let error):
                    Toast.show(message: error.errorDescription ?? "Unknown Error")
                }
            }
        }
    
    func expSubmitDatesSFC(){
        let axn = "get/expSubmitDatesSFC"
        let apiKey = "\(axn)&desig=\(Desig)&divisionCode=\(DivCode)&from_date=\(period_from_date)&to_date=\(period_to_date)&month=\(SelectMonth)&rSF=\(SFCode)&year=\(selectYear)&selected_period=\(selected_period)&sfCode=\(SFCode)&stateCode=\(StateCode)&sf_code=\(SFCode)"
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
                                var count = 0
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any]{
                                    print(jsonObject)
                                    // apr_flg
                                    if let apr_flags = jsonObject["apr_flag"] as?  [[String: Any]]{
                                        print(apr_flags)
                                        if apr_flags.isEmpty{
                                            apr_flg = "0"
                                           
                                        }else{
                                            let apr = apr_flags.filter {
                                                if let approveFlag = $0["approve_flag"] as? Int {
                                                    return approveFlag != 0
                                                }
                                                return false
                                            }

                                            print(apr)
                                            if !apr.isEmpty{
                                                if let approve_flags = apr[0]["approve_flag"] as? Int {
                                                    apr_flg = String(approve_flags)
                                                }else{
                                                    apr_flg = "0"
                                                }
                                            }else{
                                                apr_flg = "0"
                                            }
                                        }
                                    }
                                    
                                    
                                    if let ExpDate = jsonObject["exp_submit_date"] as? [AnyObject] {
                                        print(ExpDate)
                                        exp_SubitDate = ExpDate
                                        print(exp_SubitDate)
                                    }
                                    if let exp_submit = jsonObject["exp_submit_date"] as? [[String: Any]]{
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

                                    
                                    if let attance_flg = jsonObject["attance_flg"] as?  [[String: Any]]{
                                        print(attance_flg)
                                        if attance_flg.isEmpty{
                                            MisDatesDatas = []
                                            return
                                        }
                                        
                                        print(attance_flg)
                                        
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
                                                count = count + 1
                                                attance_flg_L = attance_flg
                                                let cell = calendar.cell(for: Formated_Date!, at: .current)
                                                addLetterA(to: cell, text: "L")
                                            }
                                            if (Leave == "H"){
                                                count = count + 1
                                                attance_flg_L = attance_flg
                                                let cell = calendar.cell(for: Formated_Date!, at: .current)
                                                addLetterA(to: cell, text: "H")
                                            }
                                            if (Leave == "W"){
                                                count = count + 1
                                                attance_flg_L = attance_flg
                                                let cell = calendar.cell(for: Formated_Date!, at: .current)
                                                addLetterA(to: cell, text: "W")
                                            }
                                        }
                                        
                                        let olDateFormatter = DateFormatter()
                                        olDateFormatter.dateFormat = "yyyy-MM-dd"
                                        let startDate = olDateFormatter.date(from: period_from_date)
                                        let endDate = olDateFormatter.date(from: period_to_date)
                                        var allDates = [Date]()
                                        var currentDate = startDate
                                        while currentDate! <= endDate!{
                                            allDates.append(currentDate!)
                                            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate!)!
                                        }
                                        let currentDates = Date()
                                        var missingDates = allDates.filter { !dates.contains($0) }
                                        missingDates = missingDates.filter { $0 <= currentDates }
                                        print(missingDates)
                                        MisDatesDatas = missingDates
                                        MisDatesDatas = MisDatesDatas.filter { $0 <= currentDates }
                                        print(MisDatesDatas)
                                        missingDates.forEach {
                                            print(dateFormatter.string(from: $0))
                                            let missingDates = dateFormatter.string(from: $0)
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "dd/MM/yyyy"
                                            if let missingDate = formatter.date(from: missingDates) {
                                                    print(missingDate)
                                                    let cell = calendar.cell(for: missingDate, at: .current)
                                                    if let cell = cell {
                                                        addLetterA(to: cell, text: "A")
                                                    } else {
                                                        print("Cell for date \(missingDates) is nil.")
                                                    }
                                                } else {
                                                    print("Date string \(missingDates) is invalid.")
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
            if UserSetup.shared.SrtEndKMNd == 2{
                let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "Expense") as! Expense_Entry
                let myDyPln = storyboard.instantiateViewController(withIdentifier: "Daily_Expense_EntrySFC") as! Daily_Expense_Entry_SFC
                VisitData.shared.Nav_id = 1
                myDyPln.set_Date = Set_Date
                viewController.setViewControllers([RptMnuVc,myDyPln], animated: false)
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
                
            }else{
                
                let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "Expense") as! Expense_Entry
                let myDyPln = storyboard.instantiateViewController(withIdentifier: "Daily_Expense_Entry") as! Daily_Expense_Entry
                VisitData.shared.Nav_id = 1
                myDyPln.day_Plan = Day_Plan_Data
                myDyPln.set_Date = Set_Date
                myDyPln.PeriodicData = Nav_PeriodicData
                myDyPln.ExpEditNeed = exp_neededs
                
                let formatters = DateFormatter()
                formatters.dateFormat = "yyyy-MM-dd"
                VisitData.shared.fromdate = formatters.string(from: FDate)
                VisitData.shared.Todate = formatters.string(from: TDate)
                viewController.setViewControllers([RptMnuVc,myDyPln], animated: false)
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
            }
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
            if item["FWFlg"] as? String == "W"{
                if let dateString = dates, let exdate = dateFormatter.date(from: dateString) {
                    if exdate == Seldate {
                        Toast.show(message: "Please Select a Valid Date")
                        return false
                    }
                }
            }
        }
        if apr_flg2 == "12"{
            Toast.show(message: "Already Sent For Approval")
            return false
        }
        if apr_flg2 == "13"{
            Toast.show(message: "Expense alredy approved")
            return false
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
        periodic()
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
        let apiKey = "\(axn)&State_Code=\(StateCode)&desig=\(Desig)&divisionCode=\(DivCode)&Type=\(SF_type)&div_code=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)&Dateofexp=\(myStringDate)"
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
    func send_forApproval_periodic(Period_Id:String,Eff_Month:String,Eff_Year:String,From_Date:String,To_Date:String){
        var end_Todate = ""
        if To_Date == "end of month"{
            let currentDate = FDate
            let calendar = Calendar.current
            if let monthRange = calendar.range(of: .day, in: .month, for: currentDate) {
                let lastDayOfMonth = monthRange.upperBound - 1
                if let lastDateOfMonth = calendar.date(bySetting: .day, value: lastDayOfMonth, of: currentDate) {
                    let formatters = DateFormatter()
                    formatters.dateFormat = "dd"
                    end_Todate = formatters.string(from: lastDateOfMonth)
                }
            }
        }else{
            end_Todate = To_Date
        }
        let Month = String(format: "%02d",Int(Eff_Month)!)
        let FromDate = String(format: "%02d",Int(From_Date)!)
        let ToDate = String(format: "%02d",Int(end_Todate)!)
        let From_Date = "\(Eff_Year)-\(Month)-\(FromDate)"
        let To_Date = "\(Eff_Year)-\(Month)-\(ToDate)"
        let axn = "send_forApproval_periodic"
        let apiKey = "\(axn)&desig=\(Desig)&divisionCode=\(DivCode)&month=\(SelectMonth)&from_date=\(From_Date)&to_date=\(To_Date)&rSF=\(SFCode)&year=\(Eff_Year)&sfCode=\(SFCode)&stateCode=\(StateCode)&period_id=\(Period_Id)&sf_code=\(SFCode)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        print(url)
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
                                Toast.show(message: "submitted successfully", controller: self)
                                apr_flg = "0"
                                Sent_apr_bt.backgroundColor = .lightGray
                                GlobalFunc.movetoHomePage()
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
    @IBAction func Send_Apr(_ sender: Any) {
        if apr_flg == "0" || apr_flg == "1" {
            print("Not Apr")
        }else{
            if validateForm() == false {
                return
            }
            let alert = UIAlertController(title: "Confirmation", message: "Do you want to send for Approval?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [self] _ in
                send_forApproval_periodic(Period_Id: Sent_Apr_Det[0].Period_Id, Eff_Month: Sent_Apr_Det[0].Eff_Month, Eff_Year: Sent_Apr_Det[0].Eff_Year, From_Date: Sent_Apr_Det[0].From_Date, To_Date:Sent_Apr_Det[0].To_Date)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                return
            })
            self.present(alert, animated: true)
            
            
        }
    }
    func validateForm() -> Bool {
        if (SelPeriod.text=="Select Period"){
            Toast.show(message: "Select Period")
            return false
        }
        if ( Allow_Apr == true){
            Toast.show(message: "Complete this period expense")
            return false
        }
        return true
    }
}
