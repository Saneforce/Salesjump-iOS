//
//  DAY REPORT WITH DATE RANGE.swift
//  SAN SALES
//
//  Created by Anbu j on 21/10/24.
//

import UIKit
import Alamofire
import FSCalendar





class DAY_REPORT_WITH_DATE_RANGE: IViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, FSCalendarDelegate,DayReportCellDelegate {
  
    

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
    
    
    
    let data2 = [
        ["TC:", "PC:", "O. Value", "Pri Ord"],
        ["7", "6", "96.82", "0"]
    ]
    
    
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
        var ACode:String
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
        Table_View.delegate = self
        Table_View.dataSource = self
        
        Total_Collection.delegate = self
        Total_Collection.dataSource = self
        
        Calendar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GotoHome))
        BtBack.isUserInteractionEnabled = true
        BtBack.addGestureRecognizer(tapGesture)
        
        Start_Date.addTarget(target: self, action: #selector(FromDate))
        End_Date.addTarget(target: self, action: #selector(ToDate))
        DATE_bACK.addTarget(target: self, action: #selector(Close_view))
        
        Hq_Selection.addTarget(target: self, action: #selector(HqSelection))
        
        
        Hq_Selection.text = sfName
        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list;
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Foundation.Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        FDate = formattedDate
        TDate = formattedDate
        Start_Date.text = formattedDate
        End_Date.text = formattedDate
        HQ_Id = SFCode
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
        
        
        if Sel_Mod == "F"{
            Start_Date.text = dates
            FDate = dates
        }else{
            End_Date.text = dates
            TDate = dates
        }
        
        print(dates)
        DayRangeReport()
        Date_Selection_View.isHidden = true
    }
    
    func DayRangeReport() {
        
        self.ShowLoading(Message: "Loading...")
        Report_Detils.removeAll()
        let axn = "get/DayRangeReport"
        let apiKey: String = "\(axn)&rptDt=\(FDate)&rptToDt=\(TDate)&divisionCode=\(DivCode)&rSF=\(HQ_Id)&sfCode=\(HQ_Id)&State_Code=\(StateCode)"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                print(value)
                if let json = value as? [String: Any],let dayrepArray = json["dayrep"] as? [[String: Any]]{
                    print(dayrepArray)
                    
                    for Data in dayrepArray{
                        Report_Detils.append(Day_Report_Detils(Sf_Name: Data["SF_Name"] as? String ?? "", Date: Data["Adate"] as? String ?? "", Tc: Data["Drs"] as? Int ?? 0, pc: Data["orders"] as? Int ?? 0, Order_Value:  Data["orderValue"] as? String ?? "", Pri_Ord: Data["Stk"] as? Int ?? 0,total_lines: 0 ,ACode: Data["ACode"] as? String ?? "",Brd_Wise_Orde: []))
                    }
                    
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
                                
                                print(formattedDateString)
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
                                    let date = dateFormatter.date(from: dateString!)
                                    return targetFormatter.string(from: date!) == Date
                                }
                                return false
                            }
                            
                            
                            if let i = Report_Detils.firstIndex(where: { (item) in
                                
                                if item.Date == dateString  {
                                    return true
                                }
                                return false
                            }){
                                print(i)
                                
                                print(filteredData)
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
                        print(Total_lines)
                        for Brand_Wise in Report_Detils{
                            var Date:String = ""
                            let dateString = Brand_Wise.Date
                            let inputFormatter = DateFormatter()
                            inputFormatter.dateFormat = "dd/MM/yyyy"

                            if let date = inputFormatter.date(from: dateString) {
                                let outputFormatter = DateFormatter()
                                outputFormatter.dateFormat = "yyyy-MM-dd"
                                let formattedDateString = outputFormatter.string(from: date)
                                
                                print(formattedDateString)
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
                                    return targetFormatter.string(from: date!) == Date
                                }
                                return false
                            }
                            
                            print(filteredData)
                            
                            if let i = Report_Detils.firstIndex(where: { (item) in
                                
                                if item.Date == dateString  {
                                    return true
                                }
                                return false
                            }){
                                
                                print(filteredData)
                                
                                if !filteredData.isEmpty{
                                    
                                    Report_Detils[i].total_lines = filteredData[0]["total_lines"] as? Int ?? 0
                                }
                            }
                        }
                    }
                }
                
                Table_View.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.LoadingDismiss()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
        cell.Total_Pro_sol.text = String(Report_Detils[indexPath.row].total_lines)
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
        
        Date_Selection_View.isHidden = false
        
    }
    
    @objc func ToDate() {
        Sel_Mod = "T"
        Date_lbl.text = "Select To Date"
        Date_Selection_View.isHidden = false
    }
    
    @objc func Close_view() {
        Date_Selection_View.isHidden = true
    }
    
    @objc private func HqSelection(){
        let distributorVC = ItemViewController(items: lstHQs, configure: { (Cell : SingleSelectionTableViewCell, distributor) in
            Cell.textLabel?.text = distributor["name"] as? String
        })
        distributorVC.title = "Select the HQ"
        distributorVC.didSelect = { [self] selectedDistributor in
            let item: [String: Any]=selectedDistributor as! [String : Any]
            HQ_Id = item["id"] as? String ?? ""
            Hq_Selection.text = item["name"] as? String ?? ""
            
            DayRangeReport()
            
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(distributorVC, animated: true)
    }
    
    
    func navigateToDetails(data: Day_Report_Detils?, id: String) {
        
        print(data)
        
        var Axn:String = ""
        let Code:String = data!.ACode
        var typ:String = ""
        if id=="TC:"{
            Axn = "get/vwVstDetNative"
            typ = "1"
        }else if id == "PC:"{
            Axn = "get/vwVstDetNative"
            typ = "1"
        }else if id == "Pri Ord" {
            Axn = "get/vwVstDetNative"
            typ = "3"
        }else if id == "Pri. Value" {
            Axn = "get/vwVstDetNative"
            typ = "3"
        }
        
        
        
          let storyboard = UIStoryboard(name: "Reports 2", bundle: nil)
          let navController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
          let myDyPln = storyboard.instantiateViewController(withIdentifier: "DAY_REPORT_WITH_DATE_RANGE_DETAILSViewController") as! DAY_REPORT_WITH_DATE_RANGE_DETAILSViewController
          myDyPln.ACCode = Code
         myDyPln.axn = Axn
          myDyPln.Typ = typ
        myDyPln.CodeDate = data!.Date
          navController.setViewControllers([myDyPln], animated: false)

          (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navController)
      }
    
}

