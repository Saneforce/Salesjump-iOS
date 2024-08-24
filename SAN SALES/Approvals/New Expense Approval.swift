//
//  New Expense Approval.swift
//  SAN SALES
//
//  Created by San eforce on 26/04/24.
//

import UIKit
import FSCalendar
import Alamofire
import Foundation
class New_Expense_Approval: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
// label Sel
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var Close_Pop_Up: UILabel!
    @IBOutlet weak var YearPostion: UILabel!
    @IBOutlet weak var MonthPostion: UILabel!
    @IBOutlet weak var Close_Drop_Down: UIButton!
    @IBOutlet weak var Sel_Date: UILabel!
    @IBOutlet weak var Sel_Period: UILabel!
    // Button

    // View
    @IBOutlet weak var Exp_Sum_View: UIView!
    @IBOutlet weak var Sel_Date_View: UIView!
    @IBOutlet weak var Select_Period_View: UIView!
    @IBOutlet weak var Sel_Period_Drop_Down: UIView!
    
    @IBOutlet weak var Approval_Scr: UIView!
    
    @IBOutlet var blureView: UIVisualEffectView!
    @IBOutlet var PopUpView: UIView!
    
    //TableView
    @IBOutlet weak var eXP_Data: UITableView!
    @IBOutlet weak var Period_TB: UITableView!
    // Collection View
    @IBOutlet weak var Collection_Of_Month: UICollectionView!
    
    // Text Search
    @IBOutlet weak var TextSearch: UITextField!
    
    // APPROVE Scene
    @IBOutlet weak var Close_Apr_SC: UIImageView!
    @IBOutlet weak var Exp_Summary: UIView!
    @IBOutlet weak var Approve_bt: UIButton!
    @IBOutlet weak var Apr_View_TB: UITableView!
    @IBOutlet weak var Summary_TB: UITableView!
    @IBOutlet weak var Approve_View: UIView!
    @IBOutlet weak var Approve_All: UILabel!
    @IBOutlet weak var Reject_All: UILabel!
    
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
    var Period:[PeriodicDatas] = []
    var lstOfPeriod:[PeriodicDatas] = []
    
    struct AllExpenseDatas:Codable{
        let SF_Name:String
        let Expense_Amt:String
        let Pri_FrmDt:String
        let Pri_ToDt:String
        let Trans_Sl_No:Int
        let Emp_ID:String
        let Expense_Month:Int
        let Expense_Year:Int
        let SF_Code:String
    }
    var AllExpenses:[AllExpenseDatas] = []
    var Exp_approv_item:Int = 0
    struct Exp_Sum:Codable{
        let Tit:String
        var Amt:String
    }
    var Exp_Summary_Data:[Exp_Sum] = []
    
    struct ExpenseDetails_data:Any{
        let sf_code:String
        let name:String
        let full_date:String
        let from_place:String
        let to_place:String
        var amount:String
        let work_type:String
        let expense_type:String
        let da_amount:String
        let travel_k:String
        let travel_amount:String
        let worked_place:String
        let Hotel_Bill_Amt:String
        let DailyAddDeduct:String
        let DAdditionalAmnt:String
        var Add_Exp:String
        let DailyAddDeductsymbl:String
        let MotName:String
    }
    var ExpenseDetail_data:[ExpenseDetails_data] = []
    var Monthtext_and_year: [String] = []
    var selectYear:String = "\(Calendar.current.component(.year, from: Date()))"
    var SelMod:String = "MON"
    var SelectMonth:String = ""
    var SelectMonthPostion:String = ""
    var Eff_Month="", Eff_Year=0
    var FDate: Date = Date(),TDate: Date = Date()
    var labelsDictionary = [FSCalendarCell: UILabel]()
    let LocalStoreage = UserDefaults.standard
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = "",SF_type: String = ""
    var No_Of_Days_In_Perio = 0
    var period_from_date = ""
    var period_to_date = ""
    var period_id = ""
    var Emp_Id = ""
    var Rej_Coun = 0
    var Mod_of_trave_data:[AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let Month = Calendar.current.component(.month, from: Date()) - 1
        let formattedPosition = String(format: "%02d", Month + 1)
        SelectMonth = formattedPosition
        Eff_Month = formattedPosition
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-yyyy"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        Sel_Date.text = formattedDate
        getUserDetails()
        //lbl sel
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        Sel_Date.addTarget(target: self, action: #selector(OpenPopUP))
        Close_Pop_Up.addTarget(target: self, action: #selector(ClosePopUP))
        YearPostion.addTarget(target: self, action: #selector(OpenYear))
        MonthPostion.addTarget(target: self, action: #selector(OpenMonth))
        Sel_Period.addTarget(target: self, action: #selector(Open_Drop_Down_View))
        Close_Drop_Down.addTarget(target: self, action: #selector(Close_Drop_Down_View))
        Close_Apr_SC.addTarget(target: self, action: #selector(Closs_approve_Sc))
        Approve_All.addTarget(target: self, action: #selector(Approve_Expense_BT))
        Reject_All.addTarget(target: self, action: #selector(Rej_All_BT))
        
        blureView.bounds = self.view.bounds
        PopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        PopUpView.layer.cornerRadius = 10
        
        
        // Card View
        Sel_Date_View.CornerRadius(cornerRadius: 10, shadowColor: UIColor.black, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 4)
        Select_Period_View.CornerRadius(cornerRadius: 10, shadowColor: UIColor.black, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 4)
        Exp_Summary.CornerRadius(cornerRadius: 10, shadowColor: UIColor.black, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 4)
        
        Approve_View.CornerRadius(cornerRadius: 10, shadowColor: UIColor.black, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 4)
        
        Approve_All.layer.cornerRadius = 10
        Approve_All.layer.masksToBounds = true
        Reject_All.layer.cornerRadius = 10
        Reject_All.layer.masksToBounds = true
        
        eXP_Data.dataSource = self
        eXP_Data.delegate = self
        
        Period_TB.dataSource = self
        Period_TB.delegate = self
        
        Apr_View_TB.dataSource = self
        Apr_View_TB.delegate = self
        
        Collection_Of_Month.delegate=self
        Collection_Of_Month.dataSource=self
        
        Summary_TB.delegate=self
        Summary_TB.dataSource=self
        
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Rejected Expense", Amt: "-"))
        Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: "-"))
        travelmode()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                YearPostion.text = selectYear
                SelMod = "MON"
                Collection_Of_Month.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if eXP_Data == tableView {return 70}
        if Period_TB == tableView {return 50}
        if Apr_View_TB == tableView {return 530}
        if Summary_TB == tableView {return 30}
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (eXP_Data == tableView){
            return AllExpenses.count
    }
        if Period_TB == tableView {
            return lstOfPeriod.count
        }
        if Apr_View_TB == tableView {
            return ExpenseDetail_data.count
        }
        if Summary_TB == tableView {
            return Exp_Summary_Data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if (eXP_Data == tableView){
            cell.New_Exp_View_Bt.layer.cornerRadius=10
            cell.New_Exp_View_Bt.layer.masksToBounds = true
            cell.New_Exp_View_Bt.tag = indexPath.row
            cell.New_Exp_View_Bt.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            print(AllExpenses[indexPath.row])
            cell.Sf_Name.text = AllExpenses[indexPath.row].SF_Name + " - " + AllExpenses[indexPath.row].SF_Code
            cell.Date_Sf.text = "\(AllExpenses[indexPath.row].Expense_Month) - \(AllExpenses[indexPath.row].Expense_Year)"
            cell.new_Exp_Tot.text = "₹"+AllExpenses[indexPath.row].Expense_Amt
            }else if (Period_TB == tableView){
            cell.lblText.text = lstOfPeriod[indexPath.row].Period_Name
            }else if(Apr_View_TB == tableView){
                cell.NA_Reject_BT.isHidden = false
                cell.NA_Reject_BT.layer.cornerRadius = 10
                cell.NA_Reject_BT.layer.masksToBounds = true
                cell.NA_Approve_BT.layer.cornerRadius = 10
                cell.NA_Approve_BT.layer.masksToBounds = true
                cell.NA_Reject_BT.tag = indexPath.row
                cell.NA_Reject_BT.addTarget(self, action: #selector(Rj_Exp(_:)), for: .touchUpInside)
                cell.NA_Approve_BT.tag = indexPath.row
                cell.NA_Approve_BT.addTarget(self, action: #selector(Apr_Exp(_:)), for: .touchUpInside)
                cell.NA_Approve_BT.isHidden = true
                cell.Card_View.CornerRadius(cornerRadius: 10, shadowColor: UIColor.black, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 4)
                cell.DATE.text = ExpenseDetail_data[indexPath.row].name
                cell.NA_Name.text = ExpenseDetail_data[indexPath.row].full_date
                cell.NA_fROM.text = ExpenseDetail_data[indexPath.row].from_place
                cell.NA_To.text = ExpenseDetail_data[indexPath.row].to_place
                cell.NA_WORK.text = ExpenseDetail_data[indexPath.row].work_type
                cell.NA_Work.text = ExpenseDetail_data[indexPath.row].worked_place
                
                cell.NA_Daily_Allowance_Heda.text = "Daily Allowance (\(ExpenseDetail_data[indexPath.row].expense_type))"
                
                cell.NA_Daily.text = ExpenseDetail_data[indexPath.row].da_amount
                cell.NA_DAdd.text =   ExpenseDetail_data[indexPath.row].DailyAddDeductsymbl + ExpenseDetail_data[indexPath.row].DAdditionalAmnt
                cell.NA_Hotal_Bill.text = ExpenseDetail_data[indexPath.row].Hotel_Bill_Amt
                cell.NA_Travel_Expense_Head.text = "Travel Expense  (\( ExpenseDetail_data[indexPath.row].travel_k))"
                cell.NA_Travel.text = ExpenseDetail_data[indexPath.row].travel_amount
                cell.NA_Addit.text = ExpenseDetail_data[indexPath.row].Add_Exp
                cell.NA_Total.text = ExpenseDetail_data[indexPath.row].amount
                if(ExpenseDetail_data[indexPath.row].amount == "0.00"){
                    cell.NA_Reject_BT.isHidden = true
                }
                cell.Mode_of_trave_in_apr.text = ExpenseDetail_data[indexPath.row].MotName
            }else if (Summary_TB == tableView) {
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
        AllExpenseData()
        Sel_Period_Drop_Down.isHidden = true
    }
    func daysBetweenDates(_ startDate: Date, _ endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
    @objc func buttonClicked(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        print("Button clicked in cell at indexPath: \(indexPath)")
        print(sender.tag)
        Rej_Coun = 0
        Approve_All.backgroundColor = UIColor(red: 0.06, green: 0.68, blue: 0.76, alpha: 1.00)
       let item = AllExpenses[sender.tag]
        print(item)
        print(AllExpenses)
        Exp_approv_item = sender.tag
        Emp_Id = item.Emp_ID
        ExpenseDetails(mon: item.Expense_Month, year: item.Expense_Year, sfcode: item.SF_Code, trans_sl_no: item.Trans_Sl_No)
        Approval_Scr.isHidden = false
    }
    
    func AllExpenseData(){
        self.ShowLoading(Message: "Loading...")
        AllExpenses.removeAll()
        let axn = "get/AllExpenseData"
        let apiKey = "\(axn)&div_code=\(DivCode)&month=\(SelectMonth)&year=\(Eff_Year)&period_id=\(period_id)&sf_code=\(SFCode)"
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
                                    print(data)
                                    for i in data{
                                        print(i)
                                        let SF_Name = i["SF_Name"] as? String
                                        let Expense_Amt = String(format: "%.2f",(i["Expense_Amt"] as? Double)!)
                                        let Pri_FrmDt = i["Pri_FrmDt1"] as? String
                                        let Pri_ToDt = i["Pri_ToDt1"] as? String
                                        let Trans_Sl_No = i["Trans_Sl_No"] as? Int
                                        let Emp_ID = i["Emp_ID"] as? String
                                        let Expense_Month = i["Expense_Month"] as? Int
                                        let Expense_Year = i["Expense_Year"] as? Int
                                        let SF_Code = i["SF_Code"] as? String
                                        AllExpenses.append(AllExpenseDatas(SF_Name: SF_Name!, Expense_Amt: Expense_Amt, Pri_FrmDt: Pri_FrmDt!, Pri_ToDt: Pri_ToDt!, Trans_Sl_No: Trans_Sl_No!, Emp_ID: Emp_ID!, Expense_Month: Expense_Month!, Expense_Year: Expense_Year!, SF_Code: SF_Code!))
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
                                        //if let divisionCode = i["Division_Code"] as? Int,
                                        
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
    func ExpenseDetails(mon:Int,year:Int,sfcode:String,trans_sl_no:Int){
        self.ShowLoading(Message: "Loading...")
        Exp_Summary_Data.removeAll()
        ExpenseDetail_data.removeAll()
        let axn = "get/ExpenseDetails"
        let apiKey = "\(axn)&month=\(mon)&year=\(year)&sf_code=\(sfcode)&trans_slno=\(trans_sl_no)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        print(url)
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
                                   let data = jsonObject["data"] as? [AnyObject], let data2 = jsonObject["additional_data"] as? [AnyObject], let data3 = jsonObject["add_sub_exp"] as? [AnyObject], let data4 = jsonObject["sum_add_data"] as? [AnyObject] {
                                    for i in data{
                                        print(i)
                                        let sf_code = i["sf_code"] as? String
                                        let name = i["name"] as? String
                                        let full_date = i["full_date"] as? String
                                        let from_place = i["from_place"] as? String
                                        let to_place = i["to_place"] as? String
                                        let MotId =  i["mot_id"] as? String
                                        var Tot_amt = 0.0
                                        var amount = i["amount"] as? String
                                        if (amount == ""){
                                            amount = "0.00"
                                        }
                                        let amount2 = Double(amount!)
                                       // Tot_amt = Tot_amt + amount2!
                                        let work_type = i["work_type"] as? String
                                        let expense_type = i["expense_type"] as? String
                                        var da_amount = i["da_amount"] as? String
                                        if (da_amount == ""){
                                            da_amount = "0"
                                        }
                                        let da_amount2 = Double(da_amount!)
                                        Tot_amt = Tot_amt + da_amount2!
                                        var travel_k = ""
                                        if let travel_k2 = i["travel_km"] as? Int{
                                            travel_k = String(travel_k2)+" KM"
                                        }else{
                                            travel_k = "0"
                                        }
                                        
                                        if let travel_k2 = i["travel_km"] as? String{
                                            travel_k = travel_k2+" KM"
                                        }else{
                                            travel_k = "0"
                                        }
                                        var travel_amount = String((i["travel_amount"] as? Double)!)
                                        if (travel_amount == ""){
                                            travel_amount = "0"
                                        }
                                        let travel_amount2 = Double(travel_amount)
                                        Tot_amt = Tot_amt + travel_amount2!
                                        let worked_place = i["worked_place"] as? String
                                        var Hotel_Bill_Amt = i["Hotel_Bill_Amt"] as? String
                                        if (Hotel_Bill_Amt == ""){
                                            Hotel_Bill_Amt = "0"
                                        }
                                        let Hotel_Bill_Amt2 = Double(Hotel_Bill_Amt!)
                                        Tot_amt = Tot_amt + Hotel_Bill_Amt2!
                                        
                                        var DailyAddDeduct = ""
                                        var DailyAddDeductsymb = ""
                                        if let DailyAddDeduct2 = i["DailyAddDeduct"] as? String{
                                            DailyAddDeduct = DailyAddDeduct2
                                        }
//                                        if (DailyAddDeduct == ""){
//                                            DailyAddDeduct = "0"
//                                        }else{
//                                            DailyAddDeduct = "0"
//                                        }
                                        let DailyAddDeduct2 = Double(DailyAddDeduct)
                                    //    Tot_amt = Tot_amt + DailyAddDeduct2!
                                        
                                        var DAdditionalAmnt = Double((i["DAdditionalAmnt"] as? String)!)
                                        
                                        
                                        if let DAdditionalAmnts = i["DAdditionalAmnt"] as? String, DAdditionalAmnts == ""{
                                            DAdditionalAmnt = 0.0
                                        }
                                        
//                                        let DAdditionalAmnt2 = Double(DAdditionalAmnt!)
//                                        Tot_amt = Tot_amt + DAdditionalAmnt2
//                                        print(Tot_amt)
                                        
                                        print(DailyAddDeduct)
                                        if DailyAddDeduct == "ADD" || DailyAddDeduct == "" || DailyAddDeduct == "0"{
                                            Tot_amt = Tot_amt + Double(DAdditionalAmnt!)
                                        }else{
                                            Tot_amt = Tot_amt - Double(DAdditionalAmnt!)
                                        }
                                        
                                        if DailyAddDeduct == "ADD"{
                                            DailyAddDeductsymb = "+"
                                        }else if DailyAddDeduct == "Deduct"{
                                            DailyAddDeductsymb = "-"
                                        }else{
                                            DailyAddDeductsymb = ""
                                        }
                                        
                                        var MotName = ""
                                        
                                        if let moddata = Mod_of_trave_data.filter({ $0["Sl_No"] as? Int == Int(MotId!) }).first {
                                            print(moddata)
                                            MotName = (moddata["MOT"] as? String)!
                                            
                                        } else {
                                            print("No data found with the given MotId")
                                            MotName = ""
                                        }
                                        

                                        
                                        print(MotName)
                                        ExpenseDetail_data.append(ExpenseDetails_data(sf_code: sf_code!, name: name!, full_date: full_date!, from_place: from_place!, to_place: to_place!, amount: String(format: "%.2f",Tot_amt), work_type: work_type!, expense_type: expense_type!, da_amount: da_amount!, travel_k: travel_k, travel_amount: travel_amount, worked_place: worked_place!, Hotel_Bill_Amt: Hotel_Bill_Amt!, DailyAddDeduct: DailyAddDeduct, DAdditionalAmnt: String(format: "%.2f",DAdditionalAmnt!), Add_Exp: "0", DailyAddDeductsymbl: DailyAddDeductsymb, MotName: MotName))
                                    }
                                    
                                    print(ExpenseDetail_data)
                                    
                                    for i2 in data2{
                                        print(i2)
                                        var amt = ""
                                        var date = ""
                                        if let amt2 = i2["Amt"] as? Int, let date2 = i2["date"] as? String {
                                            amt = String(format: "%.2f", Double(amt2))
                                            date = date2
                                        }
                                        var loopCount = 0
                                        for ExpenseDetai in ExpenseDetail_data {
                                            print(ExpenseDetai)
                                            loopCount += 1
                                            print(date)
                                            print(ExpenseDetai.full_date)
                                            if (date == ExpenseDetai.full_date){
                                               let getdata_count = loopCount - 1
                                                print(getdata_count)
                                                ExpenseDetail_data[getdata_count].Add_Exp = amt
                                               let total_amt =  Double(ExpenseDetail_data[getdata_count].amount)
                                                let total_additional_amt = Double(amt)
                                                
                                                ExpenseDetail_data[getdata_count].amount = String(format: "%.2f",total_amt! + total_additional_amt!)
                                            }
                                        }
                                    }
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

                                    
                                    var total = 0.0
                                    for sum_tot in ExpenseDetail_data {
                                        let amt = Double(sum_tot.amount)
                                        total = total + amt!
                                    }
                                 
                                    // sum_add_data
                                    print(data4)
                                    var all_total = 0.0
                                    for i4 in data4{
                                        let Name = i4["Name"] as? String
                                        let Amt = i4["Amt"] as? String
                                        let Type = i4["Type"] as? Int
                                            if (Type == 2) {
                                                let amount = Double(Amt!)
                                                all_total = all_total + amount!
                                                Exp_Summary_Data.append(Exp_Sum(Tit: Name!, Amt: Amt!))
                                            
                                        }
                                    }
                                    all_total = all_total + total
                                    all_total = all_total + total_sum
                                    all_total = all_total - total_ded
                                    Exp_Summary_Data.append(Exp_Sum(Tit: "Total Daily Expense", Amt: String(format: "%.2f",total)))
                                    Exp_Summary_Data.append(Exp_Sum(Tit: "Total Added (+)", Amt: "\(total_sum)"))
                                    Exp_Summary_Data.append(Exp_Sum(Tit: "Total Deducted (-)", Amt: "\(total_ded)"))
                                    //Exp_Summary_Data.append(Exp_Sum(Tit: "Rejected Expense", Amt: "-"))
                                    Exp_Summary_Data.append(Exp_Sum(Tit: "Payable Amount", Amt: String(format: "%.2f",all_total)))
                                    Apr_View_TB.reloadData()
                                    Summary_TB.reloadData()
                                    self.LoadingDismiss()
                                }else{
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
    
    func travelmode(){
        let axn = "get/travelmode"
        let apiKey = "\(axn)&State_Code=\(StateCode)&Division_Code=\(DivCode)"
        var result = apiKey
        if let lastCommaIndex = result.lastIndex(of: ",") {
            result.remove(at: lastCommaIndex)
        }
        let apiKeyWithoutCommas = result.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    print(value)
                    if let json = value as? [AnyObject] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [AnyObject]{
                                    print(jsonObject)
                                   
                                    Mod_of_trave_data = jsonObject
                                    
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                           self.LoadingDismiss()
                                       }
                    Toast.show(message: error.errorDescription ?? "Unknown Error")
                }
            }
    }
    
    
    @objc private func Approve_Expense_BT(){
        if Rej_Coun == 1 {
            return
        }
        let item = AllExpenses[Exp_approv_item]
        print(item)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to Approve all ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [self] _ in
            Approve_Expense(date:formattedDate,month:item.Expense_Month,year:item.Expense_Year,period_id:period_id,sf_code:item.SF_Code,trans_slno:item.Trans_Sl_No)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
        
    }
    
    func Approve_Expense(date: String, month: Int, year: Int, period_id: String, sf_code: String, trans_slno: Int) {
        let axn = "Approve_Expense"
        let formattedDate = date.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let apiKey = "\(axn)&date=\(formattedDate)&approve_code=\(SFCode)&month=\(month)&year=\(year)&period_id=\(period_id)&sf_code=\(sf_code)&trans_slno=\(trans_slno)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        print(url)
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
                                Toast.show(message:"Submitted Successfully", controller: self)
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

    @objc private func Rej_All_BT() {
        let item = AllExpenses[Exp_approv_item]
        print(item)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to Reject all?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [self] _ in
            Reject_all_exp(date:formattedDate,month:item.Expense_Month,year:item.Expense_Year,period_id:period_id,sf_code:item.SF_Code,trans_slno:item.Trans_Sl_No)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
        
      
    }
    
    func Reject_all_exp(date:String,month:Int,year:Int,period_id:String,sf_code:String,trans_slno:Int){
        let axn = "rejectExpense"
            let apiKey = "\(axn)&month=\(month)&year=\(year)&selected_date=&rej_sf_code=\(SFCode)&rej_type=1&period_id=\(period_id)&sf_code=\(sf_code)&remarks=&emp_id=\(Emp_Id)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
            print(url)
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
                                    Toast.show(message: "Rejected Successfully")
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
    
    @objc func Rj_Exp(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Confirmation", message: "Reject Expense ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [self] _ in
            rej_date(tag:sender.tag)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
        
    }
    
    func rej_date(tag:Int){
    let item = ExpenseDetail_data[tag]
    print(item)
    let components = item.full_date.components(separatedBy: "/")
    print(components)
    let mon = components[1]
    let year = components[2]
    let Sel_Date = item.full_date
    let axn = "rejectExpense"
        let apiKey = "\(axn)&month=\(mon)&year=\(year)&selected_date=\(Sel_Date)&rej_sf_code=\(SFCode)&rej_type=0&period_id=\(period_id)&sf_code=\(item.sf_code)&remarks=reject&emp_id=\(Emp_Id)"
    let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
    let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        print(url)
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
                                Toast.show(message: "Rejection successful")
                                ExpenseDetail_data.remove(at:tag )
                                Apr_View_TB.reloadData()
                                Rej_Coun = 1
                                Approve_All.backgroundColor = .lightGray
                               // GlobalFunc.movetoHomePage()
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
    
    
    @objc func Apr_Exp(_ sender: UIButton) {
    let indexPath = IndexPath(row: sender.tag, section: 0)
    
    }

    
    
    @objc  func OpenYear() {
        SelMod = "YEAR"
        yearobj()
    }
    @objc func OpenMonth() {
        SelMod = "MON"
        MonthaObj()
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
    @objc private func Closs_approve_Sc() {
        AllExpenseData()
        Approval_Scr.isHidden = true
    }
    
    @objc private func OpenPopUP() {
        MonthaObj()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
       let Month = dateFormatter.shortMonthSymbols
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        //MonthPostion.text = Month![currentMonthIndex]
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
    @objc private func Open_Drop_Down_View() {
        periodic()
        Sel_Period_Drop_Down.isHidden = false
    }
    @objc private func Close_Drop_Down_View() {
        Sel_Period_Drop_Down.isHidden = true
    }
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
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

extension UIView {
    func CornerRadius(cornerRadius: CGFloat, shadowColor: UIColor, shadowOpacity: Float, shadowOffset: CGSize, shadowRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
}
