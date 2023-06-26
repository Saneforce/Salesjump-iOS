//
//  LeaveForm.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 19/10/22.
//

import Foundation

import UIKit
import FSCalendar
import Alamofire
import CoreLocation

class LeaveForm: IViewController, UITableViewDelegate,
                    UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource  {
    @IBOutlet weak var vwSelWindow: UIView!
    @IBOutlet weak var lblSelTitle: UILabel!
    @IBOutlet weak var lblFDate: UILabel!
    @IBOutlet weak var lblTDate: UILabel!
    @IBOutlet weak var lblNoDays: UILabel!
    @IBOutlet weak var lblLvlTyp: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendar2: FSCalendar!
    @IBOutlet weak var txSearchSel: UITextField!
    @IBOutlet weak var txReason: UITextView!
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var menuClose: UIImageView!
    
    @IBOutlet weak var LeaveAvailability: UITableView!
    @IBOutlet weak var tbDataSelect: UITableView!
    
    struct mnuItem: Any {
        let levtype: String
        let Eligibility : Int
        let Taken : Int
        let Available : Int
    }
    var LeveDet:[mnuItem]=[]
    
    let axn="get/LeaveAvailabilityCheck"
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String=""
    
    var SelMode: String = ""
    var isDate: Bool = false
//    var SFCode: String = ""
//    var DivCode: String = ""
    var lstLvlTypes: [AnyObject] = []
    var lObjSel: [AnyObject] = []
    var lAllObjSel: [AnyObject] = []
    var LeaveAvailabilitydata: [AnyObject] = []
    var sLvlType: String = "",sDOF = "",sDOT = ""
    var FDate: Date = Date(),TDate: Date = Date()
    var eKey: String = ""
    let LocalStoreage = UserDefaults.standard
    override func viewDidLoad() {
        
        getUserDetails()
        LeaveAvailabilityCheck()
        let LocalStoreage = UserDefaults.standard
        
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        eKey = String(format: "EK%@-%i", SFCode,Int(Date().timeIntervalSince1970))
        
        let LvlTypData: String=LocalStoreage.string(forKey: "LeaveType_Master")!
        
        if let list = GlobalFunc.convertToDictionary(text: LvlTypData) as? [AnyObject] {
            lstLvlTypes = list;
        }
        lblLvlTyp.addTarget(target: self, action: #selector(selLvlTypes))
        lblFDate.addTarget(target: self, action: #selector(selDOF))
        lblTDate.addTarget(target: self, action: #selector(selDOT))
        
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        
        tbDataSelect.delegate=self
        tbDataSelect.dataSource=self
        
        LeaveAvailability.delegate=self
        LeaveAvailability.dataSource=self
        calendar.delegate=self
        calendar.dataSource=self
        calendar2.delegate=self
        calendar2.dataSource=self
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
//        lblFDate.text = formatter.string(from: Date())
//        lblTDate.text = formatter.string(from: Date())
        self.lblFDate.text = "Select Date"
        lblFDate.textColor = UIColor.systemBlue
        
        self.lblTDate.text = "Select Date"
        lblTDate.textColor = UIColor.systemBlue
        
        
        
        formatter.dateFormat = "yyyy/MM/dd"
        sDOF = formatter.string(from: Date())
        sDOT = formatter.string(from: Date())
        FDate=Date()
        TDate=Date()
        datediff()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == LeaveAvailability {
            return LeveDet.count
        }
        return lObjSel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if tableView == tbDataSelect {
            let item: [String: Any] = lObjSel[indexPath.row] as! [String : Any]
            cell.lblText?.text = item["name"] as? String
        }
        if tableView == LeaveAvailability {
          //  let item: [String: Any] = LeveDet[indexPath.row] as! [String : Any]
            cell.Levtype?.text = LeveDet[indexPath.row].levtype
            cell.Leveligibility?.text = String(LeveDet[indexPath.row].Eligibility)
            cell.Levtaken?.text = String(LeveDet[indexPath.row].Taken)
            cell.Levavailable?.text = String(LeveDet[indexPath.row].Available)
        }
         
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
        let name=item["name"] as! String
        let id=String(format: "%@", item["id"] as! CVarArg)
        if SelMode == "LTYP" {
            lblLvlTyp.text = name
            sLvlType = id
        }
        //outletData.updateValue(lItem(id: id, name: name), forKey: SelMode)
        closeWin(self)
    }
    
    @objc private func selLvlTypes() {
        isDate = false
        lObjSel=lstLvlTypes
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Leave Type"
        openWin(Mode: "LTYP")
    }
    
    @objc private func selDOF() {
        isDate = true
        openWin(Mode: "DOF")
        lblSelTitle.text="Select the leave from date"
        calendar.reloadData()
    }
    
    @objc private func selDOT() {
        if lblFDate.text == "Select Date" {
            Toast.show(message: "Select From Date", controller: self)
            
            
        } else {
            isDate = true
            openWin(Mode: "DOT")
            lblSelTitle.text="Select the leave to date"
         
            //minimumDate(for: )
        }
    }
    //
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        print("did select date \(formatter.string(from: date))")
       // let selectedDates = calendar.selectedDates.sorted(by: {formatter.string(from: $0)})
        let selectedDates = calendar.selectedDates.map({formatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        if SelMode == "DOF"{
            
            
            lblFDate.text = selectedDates[0]
            formatter.dateFormat = "yyyy/MM/dd"
            sDOF = formatter.string(from: date)
            FDate=date
            datediff()
            
            calendar.reloadData()
            
        }
        
        if SelMode == "DOT" {
            lblTDate.text = selectedDates[0]
           formatter.dateFormat = "yyyy/MM/dd"
            sDOT = formatter.string(from: date)
            TDate = date
            

            datediff()
        }

        closeWin(self)
    }
    

    func minimumDate(for calendar: FSCalendar) -> Date {
        let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
       
                if SelMode == "DOF" {
                    if let selectedDate = calendar.selectedDates.first {
                        return selectedDate
                    }
                   
                   
                    return formatter.date(from: "1900/01/01")!
                }
       

       return Date()
    }

    
    func openWin(Mode:String){
        self.view.endEditing(true)
        SelMode=Mode
        lAllObjSel = lObjSel
        txSearchSel.text = ""
        calendar.isHidden = true
        tbDataSelect.isHidden = false
        txSearchSel.isHidden = false
        if isDate == true {
            calendar.isHidden = false
            tbDataSelect.isHidden = true
            txSearchSel.isHidden = true
        }
        vwSelWindow.isHidden=false
    }
// crrection by mani closewin 17/03/23
    @IBAction func closeWin(_ sender:Any){
        vwSelWindow.isHidden=true
    }
    
    // crrection by mani 17/03/23
    @IBAction func searchBytext(_ sender: Any) {
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            lObjSel = lAllObjSel
        }
        else{
            lObjSel = lAllObjSel.filter({(product) in
                let name: String = String(format: "%@", product["name"] as! CVarArg)
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        tbDataSelect.reloadData()
        
    }
    
    func validateForm() -> Bool {
        
        if sLvlType == "" {
            Toast.show(message: "Select the Leave Type") //, controller: self
            return false
        }
        if sDOF == "" {
            Toast.show(message: "Select the From Date") //, controller: self
            return false
        }
        if sDOT == "" {
            Toast.show(message: "Select the To Date") //, controller: self
            return false
        }
        if (datediff()<0){
            Toast.show(message: "Invalid date selection")
            return false
        }
//        if FDate>=TDate{
//            Toast.show(message: "To date must be grater or equal")
//            return false
//        }
        if txReason.text == "" {
            Toast.show(message: "Select the Reason", controller: self)
            return false
        }
        return true
        
    }
    
    //[{"LeaveForm":{"Leave_Type":"'174'","From_Date":"2021-11-01",
    //        "To_Date":"'2021-11-03'","Reason":"'test'","address":"''","No_of_Days":3,"halfday":"''"}}]
    
    @IBAction func SubmitLeave(_ sender: Any) {
        if validateForm() == false {
            return
        }
        
        if(NetworkMonitor.Shared.isConnected != true){
            let alert = UIAlertController(title: "Information", message: "Check the Internet Connection", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                     return
                 })
                 self.present(alert, animated: true)
                return
        }
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit this Visit Without Order ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            
            self.ShowLoading(Message: "Locating Device...")
            VisitData.shared.cOutTime = GlobalFunc.getCurrDateAsString()
            LocationService.sharedInstance.getNewLocation(location: { location in
                let sLocation: String = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
                self.ShowLoading(Message: "Data Submitting Please wait...")
                let jsonString = "[{\"LeaveFormValidate\":{\"Leave_Type\":\"'" + self.sLvlType + "'\",\"From_Date\":\"'" + self.sDOF + "'\",\"To_Date\":\"'" + self.sDOT + "'\",\"Reason\":\"'" + self.txReason.text! + "'\",\"eKey\":\"" + self.eKey + "\",\"address\":\"''\",\"No_of_Days\":\"''\",\"halfday\":\"''\"}}]"
                let params: Parameters = ["data": jsonString]
                
                AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode="+self.DivCode+"&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                    AFdata in
                    self.LoadingDismiss()
                    switch AFdata.result
                    {
                    case .success(let value):
                        print(value)
                        if let json = value as? [String: Any] {
                            if(json["Msg"] as! String != ""){
                                Toast.show(message: json["Msg"] as! String, controller: self)
                                self.LoadingDismiss()
                                return
                            }
                        }
                        let jsonString = "[{\"LeaveForm\":{\"Leave_Type\":\"'" + self.sLvlType + "'\",\"From_Date\":\"'" + self.sDOF + "'\",\"To_Date\":\"'" + self.sDOT + "'\",\"Reason\":\"'" + self.txReason.text! + "'\",\"eKey\":\"" + self.eKey + "\",\"address\":\"''\",\"No_of_Days\":\"''\",\"halfday\":\"''\"}}]"
                        let params: Parameters = [
                                            "data": jsonString //"["+jsonString+"]"//
                                        ]
                        print(params)
                
                        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode="+self.DivCode+"&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                            AFdata in
                            self.LoadingDismiss()
                            switch AFdata.result
                            {
                            case .success(let value):
                                print(value)
                                if let json = value as? [String: Any] {
                                    VisitData.shared.clear()
                                    Toast.show(message: "Leave has been submitted successfully", controller: self)
                                    GlobalFunc.movetoHomePage()
                                }
                            case .failure(let error):
                                let resErr = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
                                resErr.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                                    return
                                })
                                self.present(resErr, animated: true)
                            }
                        }
                    case .failure(let error):
                        let resErr = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
                        resErr.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                            return
                        })
                        self.present(resErr, animated: true)
                    }
                }
            },error: {_ in
                
            })
                                                          
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
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
    
    func LeaveAvailabilityCheck(){
       let apiKey: String = "\(axn)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)&Year=2023&stateCode=\(StateCode)&rSF=\(SFCode)"
        
        let aFormData: [String: Any] = [
            "tableName":"vwactivity_report","coloumns":"[\"*\"]","today":1,"wt":1,"orderBy":"[\"activity_date asc\"]","desig":"mgr"
        ]
       // print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result
            {
                
            case .success(let value):
                print(value)
                if let json = value as? [AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    self.LeaveAvailabilitydata = json
                    //strMasList.append(mnuItem.init(MasId: 1, MasName: "Start Time", MasLbl:VisitData.shared.cInTime))
                    for item in json {
                        LeveDet.append(mnuItem(levtype: item["Leave_Name"] as! String, Eligibility:item["LeaveValue"] as! Int, Taken: item["LeaveTaken"] as! Int, Available: item["LeaveAvailability"] as! Int))
                    }
                    LeaveAvailability.reloadData()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    func datediff() -> Int {
        let calendar = NSCalendar.current as NSCalendar
        
        let date1 = calendar.startOfDay(for: FDate)
        let date2 = calendar.startOfDay(for: TDate)
        let flags = NSCalendar.Unit.day
        let components = calendar.components(flags, from: date1, to: date2)
        
        var sdys = ("\(String(describing: components.day!+1)) Day")
        if(components.day!>0){ sdys += "s" }
        print(components.day!<0)
       
        lblNoDays.text = sdys
        if FDate > TDate{
            lblNoDays.text = "0 Day"
        }
        
        
        return components.day!;
    }
    
    @objc private func GotoHome() {
        self.resignFirstResponder()
   
        self.navigationController?.popViewController(animated: true)
        return
    }
    
    //
    
   
}
