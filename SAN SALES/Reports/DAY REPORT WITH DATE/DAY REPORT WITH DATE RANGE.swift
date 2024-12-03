//
//  DAY REPORT WITH DATE RANGE.swift
//  SAN SALES
//
//  Created by Anbu j on 21/10/24.
//

import UIKit
import Alamofire
import FSCalendar
import Foundation





class DAY_REPORT_WITH_DATE_RANGE: IViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, FSCalendarDelegate,FSCalendarDataSource,DayReportCellDelegate {
  
    

    @IBOutlet weak var BtBack: UIImageView!
    @IBOutlet weak var Hq_View: UIView!
    @IBOutlet weak var Date_View: UIView!
    @IBOutlet weak var Table_View: UITableView!
    @IBOutlet weak var Total_Call_View: UIView!
    @IBOutlet weak var Total_Collection: UICollectionView!
    
    let cardViewInstance = CardViewdata()
    
    @IBOutlet weak var Date_Selection_View: UIView!
    
    @IBOutlet weak var DATE_bACK: UIImageView!
    
    @IBOutlet weak var Date_lbl: UILabel!
    
    @IBOutlet weak var Calendar: FSCalendar!
    
    
    @IBOutlet weak var Start_Date: UILabel!
    @IBOutlet weak var End_Date: UILabel!
    
    
    @IBOutlet weak var Hq_Selection: UILabel!
    
    
    @IBOutlet weak var hq_view_height: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var Nodata_Lbl: UILabel!
    @IBOutlet weak var Nodataavil_Height: NSLayoutConstraint!
    
    var data2:[[String]] = []
    
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    var sfName:String = ""
    let LocalStoreage = UserDefaults.standard
    var lstHQs: [AnyObject] = []
    var lObjSel: [AnyObject] = []
    var HQ_Id:String = ""
    
    struct Day_Report_Detils:Any{
        var Sf_Name:String
        var Date:String
        var Tc:Int
        var pc:Int
        var Order_Value:String
        var Pri_Ord:Int
        var total_lines:Int
        var Total_Product_Sold:Int
        var ACode:String
        var liters:String
        var Disamt:String
        var Brd_Wise_Orde:[AnyObject]
        
    }
    
    var Report_Detils:[Day_Report_Detils] = []
    
    
    var Sel_Mod:String = ""
    
    var FDate:String = ""
    var TDate:String = ""
    
    
    var Brind_List:[AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        [Hq_View, Date_View, Table_View, Total_Call_View].forEach { view in
            view?.layer.cornerRadius = 10
        }
        
        Nodata_Lbl.isHidden = true
        Nodataavil_Height.constant = 0
        data2 = [
            ["TC:", "PC:", "O. Value   ", "Pri Ord"],
            ["","","",""]
        ]
        Table_View.delegate = self
        Table_View.dataSource = self
        
        Total_Collection.delegate = self
        Total_Collection.dataSource = self

        
        Calendar.delegate=self
        Calendar.dataSource=self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GotoHome))
        BtBack.isUserInteractionEnabled = true
        BtBack.addGestureRecognizer(tapGesture)
        
        Start_Date.addTarget(target: self, action: #selector(FromDate))
        End_Date.addTarget(target: self, action: #selector(ToDate))
        DATE_bACK.addTarget(target: self, action: #selector(Close_view))
        
        Hq_Selection.addTarget(target: self, action: #selector(HqSelection))
        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list;
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = Foundation.Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        Hq_Selection.text = RangeData.shared.Hq_Name
//        Start_Date.text = RangeData.shared.from_Date
//        End_Date.text =  RangeData.shared.To_Date
        Start_Date.text = formattedDate
        End_Date.text = formattedDate
        
        
        if   UserSetup.shared.SF_type == 1{
            hq_view_height.constant = 0
        }
        
        DayRangeReport()
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
    sfName = prettyJsonData["sfName"] as? String ?? ""
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let selectdate = DateFormatter()
        selectdate.dateFormat = "yyyy-MM-dd"
        let dates = selectdate.string(from: date)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = date
        let formattedDate = dateFormatter.string(from: currentDate)
        
        if Sel_Mod == "F"{
            Start_Date.text = formattedDate
            FDate = dates
            RangeData.shared.from_Date = dates
            RangeData.shared.from_Date = dates
        }else{
            End_Date.text = formattedDate
            TDate = dates
            RangeData.shared.To_Date = dates
        }
        
        
        let From = selectdate.date(from:  RangeData.shared.from_Date)
        let To = selectdate.date(from: TDate)

        if let fromDate = From, let toDate = To, fromDate > toDate {
            RangeData.shared.from_Date = "-"
            Start_Date.text = "-"
        }
        
        Calendar.reloadData()
        print(dates)
        DayRangeReport()
        Date_Selection_View.isHidden = true
    }
    
    
    


    func maximumDate(for calendar: FSCalendar) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if Sel_Mod == "F" {
            if let date = dateFormatter.date(from: TDate) {
                return date
            }
        }
        return Date()
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if Sel_Mod == "T"{
            if let date = dateFormatter.date(from: FDate) {
                return date
            }
        }
        return dateFormatter.date(from: "1999-02-28")!
    }
    
    
    func DayRangeReport(){
        self.ShowLoading(Message: "Loading...")
        Report_Detils.removeAll()
        let axn = "get/DayRangeReport"
        let apiKey: String = "\(axn)&rptDt=\(RangeData.shared.from_Date)&rptToDt=\(RangeData.shared.To_Date)&divisionCode=\(DivCode)&rSF=\(RangeData.shared.Hq_Id)&sfCode=\(RangeData.shared.Hq_Id)&State_Code=\(StateCode)"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                print(value)
                if let json = value as? [String: Any],let dayrepArray = json["dayrep"] as? [[String: Any]]{
                    print(dayrepArray)
                    
                    for Data in dayrepArray{
                        Report_Detils.append(Day_Report_Detils(Sf_Name: Data["SF_Name"] as? String ?? "", Date: Data["Adate"] as? String ?? "", Tc: Data["Drs"] as? Int ?? 0, pc: Data["orders"] as? Int ?? 0, Order_Value:  Data["orderValue"] as? String ?? "", Pri_Ord: Data["Stk"] as? Int ?? 0,total_lines: 0, Total_Product_Sold: 0 ,ACode: Data["ACode"] as? String ?? "", liters: String(Data["liters"] as? Double ?? 0), Disamt: String(Data["DisAmt"] as? Double ?? 0),Brd_Wise_Orde: []))
                    }
                    
                    print(Report_Detils)
                    
                    if let brndwise = json["brndwise"] as? [[String: Any]]{
                        
                        for Brand_Wise in Report_Detils{
                            Brind_List.removeAll()
                            var Date:String = ""
                            let dateString = Brand_Wise.Date
                            let inputFormatter = DateFormatter()
                            inputFormatter.dateFormat = "dd/MM/yyyy"

                            if let date = inputFormatter.date(from: dateString) {
                                let outputFormatter = DateFormatter()
                                outputFormatter.dateFormat = "yyyy-MM-dd"
                                let formattedDateString = outputFormatter.string(from: date)
                                
                                Date = formattedDateString
                            } else {
                                print("Invalid date format")
                            }
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
                            
                            let targetFormatter = DateFormatter()
                            targetFormatter.dateFormat = "yyyy-MM-dd"
                            
                            let filteredData = brndwise.filter { item in
                                
                                let dt = item["dt"] as? [String: Any]
                                
                                if let dt = item["dt"] as? [String: Any]{
                                   let dateString = dt["date"] as? String
                                    print(dateString)
                                    let date = dateFormatter.date(from: dateString!)
                                    return targetFormatter.string(from: date ?? Date.toDate(format: "yyyy-MM-dd hh:mm:ss")) == Date
                                }
                                return false
                            }
                            
                            
                            if let i = Report_Detils.firstIndex(where: { (item) in
                                
                                if item.Date == dateString  {
                                    return true
                                }
                                return false
                            }){
                                
                                if !filteredData.isEmpty{
                                
                                for H in filteredData{
                                    
                                    let product_brd_name = H["product_brd_name"] as? String ?? ""
                                    let RetailCount = H["RetailCount"] as? Int ?? 0
                                    var item:[String:Any] = ["product_brd_name":product_brd_name,"RetailCount":RetailCount]
                                    let jitm: AnyObject = item as AnyObject
                                    Brind_List.append(jitm)
                                }
                                
                                Report_Detils[i].Brd_Wise_Orde = Brind_List
                            }
                            }
                        }
                    }
                    
                    if let Total_lines = json["DCR_TLSD"] as? [[String: Any]]{
                        for Brand_Wise in Report_Detils{
                            var Date:String = ""
                            let dateString = Brand_Wise.Date
                            let inputFormatter = DateFormatter()
                            inputFormatter.dateFormat = "dd/MM/yyyy"

                            if let date = inputFormatter.date(from: dateString) {
                                let outputFormatter = DateFormatter()
                                outputFormatter.dateFormat = "yyyy-MM-dd"
                                let formattedDateString = outputFormatter.string(from: date)
                             
                                Date = formattedDateString
                            } else {
                                print("Invalid date format")
                            }
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
                            
                            let targetFormatter = DateFormatter()
                            targetFormatter.dateFormat = "yyyy-MM-dd"
                            
                            let filteredData = Total_lines.filter { item in
                                
                                
                                if let dt = item["date"] as? [String: Any]{
                                   let dateString = dt["date"] as? String
                                    let date = dateFormatter.date(from: dateString!)
                                    return targetFormatter.string(from: date ?? Date.toDate(format: "yyyy-MM-dd hh:mm:ss")) == Date
                                }
                                return false
                            }
                            
                            if let i = Report_Detils.firstIndex(where: { (item) in
                                
                                if item.Date == dateString  {
                                    return true
                                }
                                return false
                            }){
                             
                                if !filteredData.isEmpty{
                                    
                                    Report_Detils[i].total_lines = filteredData[0]["total_lines"] as? Int ?? 0
                                }
                            }
                        }
                    }
                    
                    if let Total_lines = json["DCR_LPC"] as? [[String: Any]]{
                        for Brand_Wise in Report_Detils{
                            var Date:String = ""
                            let dateString = Brand_Wise.Date
                            let inputFormatter = DateFormatter()
                            inputFormatter.dateFormat = "dd/MM/yyyy"

                            if let date = inputFormatter.date(from: dateString) {
                                let outputFormatter = DateFormatter()
                                outputFormatter.dateFormat = "yyyy-MM-dd"
                                let formattedDateString = outputFormatter.string(from: date)
                             
                                Date = formattedDateString
                            } else {
                                print("Invalid date format")
                            }
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
                            
                            let targetFormatter = DateFormatter()
                            targetFormatter.dateFormat = "yyyy-MM-dd"
                            
                            let filteredData = Total_lines.filter { item in
                                if let dt = item[""] as? [String: Any]{
                                   let dateString = dt["date"] as? String
                                    let date = dateFormatter.date(from: dateString!)
                                    return targetFormatter.string(from: date ?? Date.toDate(format: "yyyy-MM-dd hh:mm:ss")) == Date
                                }
                                return false
                            }
                            
                            if let i = Report_Detils.firstIndex(where: { (item) in
                                if item.Date == dateString  {
                                    return true
                                }
                                return false
                            }){
                                if !filteredData.isEmpty{
                                    Report_Detils[i].Total_Product_Sold = filteredData.count
                                }
                            }
                        }
                    }
                    
                }
                
                var Tccall: Int = 0
                var Pccall: Int = 0
                var ovalue: Double = 0
                var Privalue: Int = 0
                var Priamt:Double = 0
                var liter:Double = 0

                for k in Report_Detils {
                    print(k)
                    Tccall += k.Tc
                    Pccall += k.pc

                    // Remove commas and convert to Double
                    let orderValueString = k.Order_Value.replacingOccurrences(of: ",", with: "")
                    let DisorderValueString = k.Disamt.replacingOccurrences(of: ",", with: "")
                    let liters = Double(k.liters)
                    if let orderValue = Double(orderValueString), let DisorderValue = Double(DisorderValueString){
                        ovalue += orderValue
                        Priamt += DisorderValue
                        liter += liters!
                    } else {
                        print("Invalid order value: \(k.Order_Value)")
                    }

                    Privalue += k.Pri_Ord
                   // Priamt + =
                }

                var headers: [String] = ["TC:", "PC:", "O. Value           "]
                var values: [String] = ["\(Tccall)", "\(Pccall)", "\(CurrencyUtils.formatCurrency_WithoutSymbol(amount: ovalue, currencySymbol: UserSetup.shared.currency_symbol))"]

                if UserSetup.shared.Liters_Need == 1 {
                    headers.append("Volumes")
                    values.append("\(liter)")
                }

                if Priamt > 0 {
                    headers.append("Pri Ord")
                    values.append("\(Privalue)")
                    
                    if UserSetup.shared.StkNeed == 1 {
                        headers.append("Pri.Value")
                        values.append("\(Priamt)")
                    }
                } else if UserSetup.shared.StkNeed == 1 {
                    headers.append("Pri Ord")
                    values.append("\(Privalue)")
                }

                data2 = [headers, values]


                if Report_Detils.isEmpty{
                    Nodata_Lbl.isHidden = false
                    Nodataavil_Height.constant = 100
                    Table_View.isHidden = true
                }else{
                    Nodata_Lbl.isHidden = true
                    Nodataavil_Height.constant = 0
                    Table_View.isHidden = false
                }
                
                Table_View.reloadData()
                Total_Collection.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.LoadingDismiss()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.LoadingDismiss()
                }
            }
        }
    }
    
    // MARK: - Collection View DataSource & Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data2[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        cell.lblText.text = data2[0][indexPath.row]
        cell.Test.text = data2[1][indexPath.row]
        return cell
    }
    
    // MARK: - Table View DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Report_Detils.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DAY_REPORT_WITH_DATE_RANGE_CELL
        cell.Name.text = Report_Detils[indexPath.row].Sf_Name
        cell.Date.text = Report_Detils[indexPath.row].Date
        cell.BraindList = Report_Detils[indexPath.row].Brd_Wise_Orde
        cell.RangData = Report_Detils[indexPath.row]
        cell.Total_lines.text = String(Report_Detils[indexPath.row].total_lines)
        cell.Total_lbl.text = "Total:\(Report_Detils[indexPath.row].Tc)"
        cell.Effective_lbl.text = "Effective:\(Report_Detils[indexPath.row].pc)"
        cell.Total_Pro_sol.text = String(Report_Detils[indexPath.row].Total_Product_Sold)
        cell.delegate = self
        cell.Reload()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 535
    }
    
    // MARK: - Navigation
    
    @objc private func GotoHome() {
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
        
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
    
    @objc func FromDate() {
        Sel_Mod = "F"
        Date_lbl.text = "Select From Date"
        if !TDate.isEmpty{
            Calendar.reloadData()
        }
        
        Date_Selection_View.isHidden = false
    }
    
    @objc func ToDate() {
        Sel_Mod = "T"
        Date_lbl.text = "Select To Date"
        
        if !FDate.isEmpty{
            Calendar.reloadData()
        }
        Date_Selection_View.isHidden = false
    }
    
    @objc func Close_view() {
        Date_Selection_View.isHidden = true
    }
    
    @objc private func HqSelection() {
        let distributorVC = ItemViewController(items: lstHQs) { (cell: SingleSelectionTableViewCell, distributor) in
            cell.textLabel?.text = distributor["name"] as? String
        }
        distributorVC.title = "Select the Headquarters"
        distributorVC.didSelect = { [weak self] selectedDistributor in
            guard let self = self else { return }
            let item = selectedDistributor as! [String: Any]
            self.HQ_Id = item["id"] as? String ?? ""
            self.Hq_Selection.text = item["name"] as? String ?? ""
            RangeData.shared.Hq_Name = item["name"] as? String ?? ""
            RangeData.shared.Hq_Id = self.HQ_Id
            self.navigationController?.popViewController(animated: true)
            self.DayRangeReport()
        }
        self.navigationController?.pushViewController(distributorVC, animated: true)
    }
    
    func navigateToDetails(data: Day_Report_Detils?, id: String) {
        guard let data = data else { return }
        var axn = ""
        var typ = ""
        
        switch id {
        case "TC:", "PC:":
            axn = "get/vwVstDetNative"
            typ = "1"
        case "Pri Ord", "Pri. Value":
            axn = "get/vwVstDetNative"
            typ = "3"
        default:
            break
        }
        
        let storyboard = UIStoryboard(name: "Reports 2", bundle: nil)
        let myDyPln = storyboard.instantiateViewController(withIdentifier: "DAY_REPORT_WITH_DATE_RANGE_DETAILSViewController") as! DAY_REPORT_WITH_DATE_RANGE_DETAILSViewController
        myDyPln.ACCode = data.ACode
        myDyPln.axn = axn
        myDyPln.Typ = typ
        myDyPln.CodeDate = data.Date
        myDyPln.Total_and_Non_Total = id
        myDyPln.Hqname = Hq_Selection.text
        
        self.navigationController?.pushViewController(myDyPln, animated: true)
    }

    
}

