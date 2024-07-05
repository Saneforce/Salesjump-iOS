//
//  TourPlanCalenderScreen.swift
//  SAN SALES
//
//  Created by Naga Prasath on 16/04/24.
//

import Foundation
import UIKit
import FSCalendar
import Alamofire


class TourPlanCalenderScreen : UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance , UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var twPlanList: UITableView!
    
    @IBOutlet weak var calendarView: FSCalendar!

    @IBOutlet weak var lblName: UILabel!
    
    
    @IBOutlet weak var lblReason: UILabel!
    
    
    @IBOutlet weak var lblTargetCommitment: UILabel!
    
    
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    
    
    @IBOutlet weak var vwSubmitForApproval: CardView!
    
    @IBOutlet weak var vwreasonandTargetCommit: UIView!
    
    
    @IBOutlet weak var vwTargetCommit: ShadowView!
    
    
    @IBOutlet weak var vwSubmitForApprovalHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var vwReasonandTargetCommitHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var vwTargetCommitHeightConstraints: NSLayoutConstraint!
    
    var dates = [Date]()
    
    var sfCode = "",divCode = "",desig = "", sfName = "",stateCode = ""
    let LocalStoreage = UserDefaults.standard
    
    var lstTourDetails : [AnyObject] = []
    
    var month = "",year = ""
    var date : Date = Date()
    var isBackEnabled : Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        getUserDetails()
        
        self.vwSubmitForApproval.isHidden = true
        self.vwSubmitForApprovalHeightConstraint.constant = 0
        
        print("Month == \(month)")
        print("Year == \(year)")
        
        month = date.toString(format: "MM")
        year = date.toString(format: "yyyy")
        
        fetchFullTP()
        
        if UserSetup.shared.tpTargetBased == 0 {
            vwTargetCommit.isHidden = true
            vwTargetCommitHeightConstraints.constant = 0
        }
        
        btnPrev.isEnabled = false
        
        if isBackEnabled == false {
            Toast.show(message: "Enter Tour Plan first (or) Contact Administrator", controller: self)
            self.btnNext.isEnabled = false
            self.btnPrev.isEnabled = false
        }
        
        self.calendarView.appearance.titleFont = UIFont(name: "Poppins-Regular", size: 16)!
        self.calendarView.appearance.headerTitleFont = UIFont(name: "Poppins-Bold", size: 18)!
        self.calendarView.appearance.weekdayFont = UIFont(name: "Poppins-SemiBold", size: 16)!
        
        self.calendarView.appearance.headerTitleColor = .darkGray
        self.calendarView.appearance.weekdayTextColor = .lightGray
            
        self.calendarView.appearance.todayColor = .clear
        self.calendarView.appearance.selectionColor = .clear
        self.calendarView.appearance.titleSelectionColor = .black
        self.calendarView.appearance.titleDefaultColor = .black
        self.calendarView.appearance.titleTodayColor = .red
        self.calendarView.scope = .month
        self.calendarView.placeholderType = .none
        
        self.calendarView.scrollEnabled = false
        self.calendarView.setCurrentPage(date, animated: true)
        self.calendarView.reloadData()
        
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        LocationService.sharedInstance.getNewLocation(location: { location in
        }, error:{ errMsg in
        })
        
        sfCode = prettyJsonData["sfCode"] as? String ?? ""
        divCode = prettyJsonData["divisionCode"] as? String ?? ""
        desig = prettyJsonData["desigCode"] as? String ?? ""
        sfName = prettyJsonData["sfName"] as? String ?? ""
    }
    
    deinit {
        print("TourPlanCalenderScreen deCollected")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func getUserDetails(){
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        sfCode = prettyJsonData["sfCode"] as? String ?? ""
        stateCode = prettyJsonData["State_Code"] as? String ?? ""
        divCode = prettyJsonData["divisionCode"] as? String ?? ""
        desig=prettyJsonData["desigCode"] as? String ?? ""
        
        let sfName = UserSetup.shared.SF_Name
        let empId = UserSetup.shared.employeeId
        
        
        
        
        self.lblName.text = sfName + " - " + empId
       
    }
    
    
    @IBAction func nextMonthAction(_ sender: UIButton) {
        let actualNext = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendarView.currentPage.addingTimeInterval(86400))
        calendarView.setCurrentPage(nextMonth!, animated: true)
        
        self.date = nextMonth!
        month = nextMonth!.toString(format: "MM")
        year = nextMonth!.toString(format: "yyyy")
        sender.isEnabled = (getMonth(actualNext!).month == getMonth(nextMonth!).month) ? false : true
        self.btnPrev.isEnabled = true
        self.lstTourDetails.removeAll()
        self.fetchFullTP()
        
    }
    
    
    @IBAction func prevMonthAction(_ sender: UIButton) {
        let actualprevious = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage.addingTimeInterval(86400))
        calendarView.setCurrentPage(previousMonth!, animated: true)

      //  self.deleteAllRecords()
        self.date = previousMonth!
        month = previousMonth!.toString(format: "MM")
        year = previousMonth!.toString(format: "yyyy")
        sender.isEnabled = (getMonth(actualprevious!).month == getMonth(previousMonth!).month) ? false : true
        self.btnNext.isEnabled = true
        self.btnPrev.isEnabled = false
        self.lstTourDetails.removeAll()
        self.fetchFullTP()
        
    }
    
    func getMonth(_ date : Date) -> DateComponents {
        return Calendar.current.dateComponents([.day, .year, .month], from: date)
    }
    
    func fetchTotalCommitment() {
        // http://fmcg.salesjump.in/server/native_Db_V13.php?axn=gettour_month_value&divisionCode=29%2C&sfCode=SEFMR0040&TourMont=04&Tyear=2024
        
       // print(<#T##items: Any...##Any#>)
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL+"gettour_month_value&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&TourMont=\(month)" + "&Tyear=\(year)")
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"gettour_month_value&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&TourMont=\(month)" + "&Tyear=\(year)",method : .get,parameters: nil,encoding: URLEncoding.httpBody,headers: nil).validate(statusCode: 200..<209).responseData { AFData in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.LoadingDismiss()
            }
            switch AFData.result {
                
            case .success(let value):
                print(value)
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                
                print(apiResponse)
                if let response = apiResponse as? [AnyObject]{
                    print(response)
                    if !response.isEmpty {
                        
                        let target = String(format: "%@", response.first?["MonthTotal"] as! CVarArg)
                        let targetRound = Double(round(100 * (Double(target) ?? 0)) / 100)
                        self.lblTargetCommitment.text = "\(targetRound)"
                    }else {
                        self.lblTargetCommitment.text = "00"
                    }
                     //  response.first?["MonthTotal"] as? String ?? ""
                }
                
                
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    func fetchFullTP() {
        
        let jsonString = "{\"tableName\":\"vwTourPlan\",\"coloumns\":\"[\\\"date\\\",\\\"remarks\\\",\\\"worktype_code\\\",\\\"worktype_name\\\",\\\"RouteCode\\\",\\\"RouteName\\\",\\\"Worked_with_Code\\\",\\\"Worked_with_Name\\\",\\\"JointWork_Name\\\",\\\"JointWork_Name1\\\",\\\"Retailer_Code\\\",\\\"Retailer_Name\\\",\\\"Place_Inv\\\"]\",\"orderBy\":\"[\\\"name asc\\\"]\",\"desig\":\"mgr\"}"
        
        let params : Parameters = ["data" : jsonString]
        print(params)
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"table/list&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"State_Code=" + self.stateCode+"&rSF=" + sfCode+"&CMonth=\(month)" + "&stateCode=" + stateCode + "&CYr=\(year)")
        self.ShowLoading(Message: "Loading...")
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"table/list&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"State_Code=" + self.stateCode+"&rSF=" + sfCode+"&CMonth=\(month)" + "&stateCode=" + stateCode + "&CYr=\(year)",method : .post,parameters: params,encoding: URLEncoding.httpBody,headers: nil).validate(statusCode: 200..<209).responseData { AFData in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.LoadingDismiss()
            }
            switch AFData.result {
            
            case .success(let value):
                print(value)
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                
                if let responseArray = apiResponse as? [AnyObject] {
                    if responseArray.isEmpty{
                        self.lstTourDetails.removeAll()
                        self.dates.removeAll()
                        self.lblTargetCommitment.text = "00"
                        self.vwSubmitForApproval.isHidden = true
                        self.vwSubmitForApprovalHeightConstraint.constant = 0
                        self.calendarView.setCurrentPage(self.date, animated: true)
                        self.lblReason.text = ""
                        if UserSetup.shared.tpTargetBased == 0 {
                            self.vwReasonandTargetCommitHeightConstraint.constant = 0
                        }else {
                            self.vwReasonandTargetCommitHeightConstraint.constant = 40
                        }
                        self.calendarView.reloadData()
                        self.twPlanList.reloadData()
                        return
                    }
                    print("Gooo fvjovo")
                //    self.lstTourDetails = responseArray
                    print(responseArray)
                    self.lstTourDetails =  responseArray.sorted(by: { (plan1, plan2) -> Bool in
                        let date1 = (plan1["date"] as? String ?? "").toDate(format: "yyyy-MM-dd") //"yyyy-MM-dd HH:mm:ss"
                        let date2 = (plan2["date"] as? String ?? "").toDate(format: "yyyy-MM-dd")
                        return date1.compare(date2) == .orderedAscending
                    })
                    
                
                    let calendar = Calendar.current
                  
                    let dat = self.calendarView.currentPage.addingTimeInterval(86400)
                    
                    let interval = calendar.dateInterval(of: .month, for: dat)!
                    
                    let month = dat.toString(format: "MM")
                    let year = dat.toString(format: "yyyy")
                    
                    let date = Date()
                    if month == date.toString(format: "MM") && year == date.toString(format: "yyyy") {
                        self.lstTourDetails.removeAll{Int(($0["date"] as? String ?? "").changeFormat(from: "yyyy-MM-dd",to: "dd"))! < Int(Date().toString(format: "dd"))!}
                    }
                    
                    
                    
                    self.dates = self.lstTourDetails.map{($0["date"] as? String ?? "").toDate(format: "yyyy-MM-dd")}
                    
                    print(self.dates)
                    if UserSetup.shared.tpTargetBased != 0 {
                        self.fetchTotalCommitment()
                    }
                    
                    self.isAllDaysApplied()
                    self.calendarView.setCurrentPage(self.date, animated: true)
                    self.calendarView.reloadData()
                    self.twPlanList.reloadData()
                }
                
                
                
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
        
    }
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to Submit?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.saveFullTP()
            return
        }
                        
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    
    func isAllDaysApplied() {
        let calendar = Calendar.current
      
        let dat = self.calendarView.currentPage.addingTimeInterval(86400)
        
        let interval = calendar.dateInterval(of: .month, for: dat)!
        
        let month = dat.toString(format: "MM")
        let year = dat.toString(format: "yyyy")
        
        let date = Date() // .addingTimeInterval(86400)
        
        
        
        var days = 0
       // days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        if month == date.toString(format: "MM") && year == date.toString(format: "yyyy") {
            let tDays = calendar.dateComponents([.day], from: date, to: interval.end).day!
            
            days = tDays + 1
            print(days)
            print(self.lstTourDetails.count)
            print(interval)
            print(date)
            print(interval.end)
        }else {
            days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        }
        
        let confirmed = String(format: "%@", self.lstTourDetails.first?["Confirmed"] as? CVarArg ?? "") // self.lstTourDetails.first["Confirmed"]
        
        print(confirmed)
        
        if confirmed == "1" {
            self.lblReason.text = "Status: Waiting for Approval"
            if UserSetup.shared.tpTargetBased == 0{
                self.vwReasonandTargetCommitHeightConstraint.constant = 60
            }else {
                self.vwReasonandTargetCommitHeightConstraint.constant = 100
            }
        }else if confirmed == "0" {
            let reason = self.lstTourDetails.first?["Rejection_Reason"] as? String ?? ""
            
            if !reason.isEmpty{
                self.lblReason.text = "Rejected Reason : " + String(format: "%@", self.lstTourDetails.first?["Rejection_Reason"] as! CVarArg)
                
                if UserSetup.shared.tpTargetBased == 0{
                    self.vwReasonandTargetCommitHeightConstraint.constant = 60
                }else {
                    self.vwReasonandTargetCommitHeightConstraint.constant = 100
                }
            }else {
                self.lblReason.text = ""
                if UserSetup.shared.tpTargetBased == 0{
                    self.vwReasonandTargetCommitHeightConstraint.constant = 0
                }else {
                    self.vwReasonandTargetCommitHeightConstraint.constant = 40
                }
            }
            
        }else {
            if UserSetup.shared.tpTargetBased == 0{
                self.vwReasonandTargetCommitHeightConstraint.constant = 0
            }else {
                self.vwReasonandTargetCommitHeightConstraint.constant = 40
            }
            self.lblReason.text = ""
        }
        
        self.vwSubmitForApproval.isHidden = ((self.lstTourDetails.count >= days) && (confirmed == "0" || confirmed == "2")) ? false : true
        self.vwSubmitForApprovalHeightConstraint.constant = ((self.lstTourDetails.count >= days) && (confirmed == "0" || confirmed == "2")) ? 70 : 0
        
    }
    
    func saveFullTP() {
        
        
 //   http://fmcg.salesjump.in/server/native_Db_V13.php?State_Code=24&desig=MGR&divisionCode=29%2C&month=05&rSF=MGR1018&year=2024&axn=dcr%2Fsave&sfCode=MGR1018&stateCode=24
        
        let params : Parameters = ["data" : "[{\"TourPlanSubmit\":{}}]"]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"State_Code=" + self.stateCode+"&rSF=" + sfCode+"&month=\(month)" + "&stateCode=" + stateCode + "&year=\(year)",method: .post,parameters: params,encoding: URLEncoding.httpBody).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result{
                
            case .success(let value):
                print(value)
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                
                print(apiResponse)
                Toast.show(message: "Tour Plan Submitted Successfully", controller: self)
                GlobalFunc.movetoHomePage()
              //  GlobalFunc.MovetoMainMenu()
              //  self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let editData = self.lstTourDetails.filter({($0["date"] as? String ?? "") == date.toString(format: "yyyy-MM-dd")})
        
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbTourPlanSingleEntry") as!  TourPlanSingleEntry
        vc.date = date.toString(format: "yyyy-MM-dd")
        vc.didSelect = { save in
            if save == true {
                self.fetchFullTP()
            }
        }
        if !editData.isEmpty{
            let confirmed = String(format: "%@", self.lstTourDetails.first?["Confirmed"] as! CVarArg)
            
            if confirmed == "1" || confirmed == "3" {
                return
            }
            vc.editData = editData.first
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let day: Int! = Int(date.toString(format: "dd"))
        let dates = self.dates.map{Int($0.toString(format: "dd"))}
        return dates.contains(day) ?  1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.init(cgColor: CGColor(red: 16/255, green: 173/255, blue: 194/255, alpha: 1.0))]
    }
    
    
    //Mark:-
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        print(lstTourDetails[indexPath.row])
        cell.lblText.text = lstTourDetails[indexPath.row]["worktype_name"] as? String ?? ""
        
        let date = lstTourDetails[indexPath.row]["date"] as? String ?? ""
        cell.lblText2.text = date.changeFormat(from: "yyyy-MM-dd", to: "dd/MM/yyyy")
        cell.Rmks.text = lstTourDetails[indexPath.row]["remarks"] as? String ?? ""
        cell.EditButton.addTarget(self, action: #selector(editAction(_:)), for: .touchUpInside)
        
        let confirmed = String(format: "%@", self.lstTourDetails.first?["Confirmed"] as! CVarArg)
        
        if confirmed == "1" || confirmed == "3" {
            cell.EditButton.isHidden = true
        }else {
            cell.EditButton.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstTourDetails.count
    }
    
    @objc func editAction(_ sender : UIButton) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.twPlanList)
        guard let indexPath = self.twPlanList.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbTourPlanSingleEntry") as!  TourPlanSingleEntry
        vc.date = self.lstTourDetails[indexPath.row]["date"] as? String ?? ""
        vc.didSelect = { save in
            if save == true {
                self.fetchFullTP()
            }
        }
        vc.editData = self.lstTourDetails[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backVC() {
        if self.isBackEnabled == true {
            self.navigationController?.popViewController(animated: true)
        }else {
            tpMandatoryNeed()
        }
        
    }
    
    func tpMandatoryNeed() {
        
         AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"get/tpdetails_mand&sfCode=\(sfCode)&rSF=\(sfCode)&divisionCode=\(divCode)&State_Code=\(stateCode)",method: .get,parameters: nil,headers: nil).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                
                guard let response = apiResponse as? AnyObject else {
                    return
                }
                
                guard let currentResponse = response["current"] as? [AnyObject] else{
                    return
                }
                
                guard let nextResponse = response["next"] as? [AnyObject] else{
                    return
                }
                
                if UserSetup.shared.tpDcrDeviationNeed == 0 || UserSetup.shared.tpNeed == 1 {
                    
                    if !currentResponse.isEmpty {
                        GlobalFunc.movetoHomePage()
                        return
                    }
                    if UserSetup.shared.tpMandatoryNeed <= Int(Date().toString(format: "dd"))! {
                        
                        if !nextResponse.isEmpty {
                            GlobalFunc.movetoHomePage()
                            return
                        }
                    }
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
        
    }
}
