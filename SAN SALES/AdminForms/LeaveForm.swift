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
    @IBOutlet weak var txSearchSel: UITextField!
    @IBOutlet weak var txReason: UITextView!
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var menuClose: UIImageView!
    
    @IBOutlet weak var LeaveAvailability: UITableView!
    @IBOutlet weak var tbDataSelect: UITableView!
    
    @IBOutlet weak var Leave_Avaailability_View: UIView!
    
    
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
    var NoofDays : String = ""
    var NoLeaveAvil : String = ""
    var NoLevSl: String = ""
    var NoLevPl: String = ""
    var NolevPat: String = ""
    var printvalue : String = ""
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
       // datediff()
        lblNoDays.text = "0 Days"
        Leave_Avaailability_View.isHidden = true
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
            
            print(LeveDet)
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
        print(id)
        print(printvalue)
        
        if printvalue == "" {
            lblLvlTyp.text = name
            sLvlType = id
            
        }
        if SelMode == "LTYP" {
//            if valu() == false {
//                return
//            }
            
            if let indexToDelete = LeaveAvailabilitydata.firstIndex(where: { String(format: "%@", $0["LeaveCode"] as! CVarArg) == id }){
                print(indexToDelete)
               // var Levid = LeaveAvailabilitydata[indexToDelete]["LeaveCode"] as? String
                //print(Levid)
                let Levname = LeaveAvailabilitydata[indexToDelete]["Leave_SName"] as? String
                let LeaveValue = LeaveAvailabilitydata[indexToDelete]["LeaveAvailability"] as? Int
                print(LeaveValue!)
                
                let NodayLv = Int(NoofDays)
                //let avil = NoLeaveAvil
                print(NodayLv!)
               
                    if (NodayLv! > LeaveValue!) {
                        Toast.show(message: "\(String(describing: Levname)) Leave count Exceeded, Available \(LeaveValue!)")
                        lblLvlTyp.text = "Select the Leave Type"
                        closeWin(self)
                    }else {
                        lblLvlTyp.text = name
                        sLvlType = id
                    }
                
                }
            
            
//            let NodayLv = NoofDays
//            let avil = NoLeaveAvil
//
//            print(NodayLv)
//            print(avil)
          
               
        
        }
        
        print(LeaveAvailabilitydata)
        
       
        
        //outletData.updateValue(lItem(id: id, name: name), forKey: SelMode)
        closeWin(self)
    }
    
    @objc private func selLvlTypes() {
        if lblFDate.text == "Select Date" || lblTDate.text == "Select Date" {
            Toast.show(message: "Select Date First", controller: self)
        } else {
            isDate = false
            lObjSel = lstLvlTypes
            tbDataSelect.reloadData()
            lblSelTitle.text = "Select the Leave Type"
            openWin(Mode: "LTYP")
        }
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
            calendar.reloadData()
        
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
            lblLvlTyp.text = "Select the Leave Type"
            calendar.reloadData()
            
        }
        
        if SelMode == "DOT" {
            lblTDate.text = selectedDates[0]
           formatter.dateFormat = "yyyy/MM/dd"
            sDOT = formatter.string(from: date)
            TDate = date
            //calendar.reloadData()
            lblLvlTyp.text = "Select the Leave Type"
            datediff()
        }

        closeWin(self)
    }
    

    func minimumDate(for calendar: FSCalendar) -> Date {
        let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
       
//                if SelMode == "DOF" {
//                    if let selectedDate = calendar.selectedDates.first {
//                        return selectedDate
//                    }
        if SelMode == "DOT"{
            return FDate
                   
                   
                }
       
        return formatter.date(from: "1900/01/01")!
       //return Date()
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
            Toast.show(message: "Enter the Reason", controller: self)
            return false
        }
       
        return true
        
    }
//    func valu() -> Bool {
//
//        if NoLevSl < NodayLv {
//             Toast.show(message: "SL Leave count Exceeded, Available \(NoLevSl)")
//            return false
//         }
//        if NoLevPl < NodayLv {
//             Toast.show(message: "PL Leave count Exceeded, Available \(NoLevPl)")
//            return false
//         }
//
//       if NolevPat < NodayLv {
//            Toast.show(message: "PAT L Leave count Exceeded, Available \(NolevPat)")
//           return false
//        }
//        return true
//    }
    
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
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit Leave ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            
//            self.ShowLoading(Message: "Locating Device...")
//            VisitData.shared.cOutTime = GlobalFunc.getCurrDateAsString()
//            LocationService.sharedInstance.getNewLocation(location: { location in
//                let sLocation: String = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
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
                        let jsonString = "[{\"LeaveForm_New\":{\"Leave_Type\":\"'" + self.sLvlType + "'\",\"From_Date\":\"'" + self.sDOF + "'\",\"To_Date\":\"'" + self.sDOT + "'\",\"Reason\":\"'" + self.txReason.text! + "'\",\"address\":\"''\",\"No_of_Days\":1,\"halfday\":\"''\"}}]"
                        let params: Parameters = [
                                            "data": jsonString //"["+jsonString+"]"//
                                        ]
                        print(params)
                
                        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode="+self.DivCode+"&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
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
//            },error: {_ in
//
//            })

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
        
       
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result
            {
                
            case .success(let value):
                print(value)
                let values = value
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
//                    let LeaveAvil = json[0]["LeaveValue"]
//                    let SlAvil = json[1]["LeaveValue"]
//                    let PlAvil = json[2]["LeaveValue"]
//                    let PatAvil = json[3]["LeaveValue"]
//                    print(LeaveAvil!!)
//                    self.NoLeaveAvil =  String(LeaveAvil as! Int)
//                    self.NoLevPl = String(SlAvil as! Int)
//                    self.NoLevPl = String(PlAvil as! Int)
//                    self.NolevPat = String(PatAvil as! Int)
                    //strMasList.append(mnuItem.init(MasId: 1, MasName: "Start Time", MasLbl:VisitData.shared.cInTime))
                    for item in json {
                        LeveDet.append(mnuItem(levtype: item["Leave_Name"] as! String, Eligibility:item["LeaveValue"] as! Int, Taken: item["LeaveTaken"] as! Int, Available: item["LeaveAvailability"] as! Int))
                    }
                    LeaveAvailability.reloadData()
                    Leave_Avaailability_View.isHidden = false
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
        NoofDays = String(describing: components.day!+1)
        print(String(describing: components.day!+1))
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
//ticket No = 0028008


/*
 
 Secondary order

 ["data": "[{\"Activity_Report_APP\":{\"Worktype_code\":\"\'1308\'\",\"Town_code\":\"\'47610\'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'2023-08-11 18:11:49\'\",\"Daywise_Remarks\":\"\",\"eKey\":\"EKSEFMR0040-1691757711\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"DataSF\":\"\'SEFMR0040\'\"}},{\"Activity_Doctor_Report\":{\"Doctor_POB\":0,\"Worked_With\":\"\'\'\",\"Doc_Meet_Time\":\"\'2023-08-11 18:11:49\'\",\"modified_time\":\"\'2023-08-11 18:11:49\'\",\"net_weight_value\":\"0.00\",\"stockist_code\":\"\'15560\'\",\"stockist_name\":\"\'BUTTERFLY APPLIANCES\'\",\"superstockistid\":\"\'\'\",\"Discountpercent\":0,\"CheckinTime\":\"2023-08-11 18:11:49\",\"CheckoutTime\":\"2023-08-11 18:11:58\",\"location\":\"\'13.03008375920465:80.24142815211357\'\",\"geoaddress\":\"1/1, Pasumpon Muthuramalinga Thevar Salai, Nandanam Extension, Nandanam, Chennai, 600035, Tamil Nadu, India\",\"PhoneOrderTypes\":\"0\",\"Order_Stk\":\"\'15560\'\",\"Order_No\":\"\'\'\",\"rootTarget\":\"0\",\"orderValue\":11,\"disPercnt\":0.0,\"disValue\":0.0,\"finalNetAmt\":11,\"taxTotalValue\":0,\"discTotalValue\":0.0,\"subTotal\":340.0,\"No_Of_items\":2,\"rateMode\":\"free\",\"discount_price\":0,\"doctor_code\":\"\'2267475\'\",\"doctor_name\":\"\'bala n co\'\",\"doctor_route\":\"\'mylapore\'\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"}}},{\"Activity_Sample_Report\":[{\"product_code\":\"SAN361518\", \"product_Name\":\"BUTTERFLY 1.2LTR RICE COOKER\", \"Product_Rx_Qty\":1, \"UnitId\": \"241\", \"UnitName\": \"PIECE\", \"rx_Conqty\":1, \"Product_Rx_NQty\": 0, \"Product_Sample_Qty\": \"10.00\", \"vanSalesOrder\":0, \"net_weight\": 0.0, \"free\": 0, \"FreePQty\": 0, \"FreeP_Code\": \"\", \"Fname\": \"\", \"discount\": 0, \"discount_price\": 0, \"tax\": 0, \"tax_price\": 0, \"Rate\": 10.00, \"Mfg_Date\": \"\", \"cb_qty\": 0, \"RcpaId\": \"\", \"Ccb_qty\": 0, \"PromoVal\": 0, \"rx_remarks\":\"\", \"rx_remarks_Id\": \"\", \"OrdConv\":1, \"selectedScheme\":0, \"selectedOffProCode\": \"241\", \"selectedOffProName\":\"PIECE\", \"selectedOffProUnit\": \"1\", \"f_key\": {\"Activity_MSL_Code\": \"Activity_Doctor_Report\"}},{\"product_code\":\"SAN361519\", \"product_Name\":\"BUTTERFLY 1.8LTR RICE COOKER\", \"Product_Rx_Qty\":1, \"UnitId\": \"241\", \"UnitName\": \"PIECE\", \"rx_Conqty\":1, \"Product_Rx_NQty\": 0, \"Product_Sample_Qty\": \"1.00\", \"vanSalesOrder\":0, \"net_weight\": 0.0, \"free\": 0, \"FreePQty\": 0, \"FreeP_Code\": \"\", \"Fname\": \"\", \"discount\": 0, \"discount_price\": 0, \"tax\": 0, \"tax_price\": 0, \"Rate\": 1.00, \"Mfg_Date\": \"\", \"cb_qty\": 0, \"RcpaId\": \"\", \"Ccb_qty\": 0, \"PromoVal\": 0, \"rx_remarks\":\"\", \"rx_remarks_Id\": \"\", \"OrdConv\":1, \"selectedScheme\":0, \"selectedOffProCode\": \"241\", \"selectedOffProName\":\"PIECE\", \"selectedOffProUnit\": \"1\", \"f_key\": {\"Activity_MSL_Code\": \"Activity_Doctor_Report\"}},]},{\"Trans_Order_Details\":[]},{\"Activity_Input_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]},{\"Activity_Event_Captures_Call\":[]}]"]
 
 
 


 Primary order   ["data": "[{\"Activity_Report_APP\":{\"Worktype_code\":\"\'1308\'\",\"Town_code\":\"\'47610\'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'2023-08-11 18:18:20\'\",\"Daywise_Remarks\":\"\",\"eKey\":\"EKSEFMR0040-1691758101\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"DataSF\":\"\'SEFMR0040\'\"}},{\"Activity_Stockist_Report\":{\"Stockist_POB\":\"\",\"Worked_With\":\"\'\'\",\"location\":\"\'13.03008375920465:80.24142815211357\'\",\"geoaddress\":\"1/1, Pasumpon Muthuramalinga Thevar Salai, Nandanam Extension, Nandanam, Chennai, 600035, Tamil Nadu, India\",\"superstockistid\":\"\'\'\",\"Stk_Meet_Time\":\"\'2023-08-11 18:18:20\'\",\"modified_time\":\"\'2023-08-11 18:18:20\'\",\"date_of_intrument\":\"\",\"intrumenttype\":\"\",\"orderValue\":\"1910.00\",\"Aob\":0,\"CheckinTime\":\"2023-08-11 18:18:20\",\"CheckoutTime\":\"2023-08-11 18:18:28\",\"PhoneOrderTypes\":0,\"Super_Stck_code\":\"\'SS458\'\",\"stockist_code\":\"\'15560\'\",\"stockist_name\":\"\'\'\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"}}},{\"Activity_Stk_POB_Report\":[{\"product_code\":\"SAN361518\",\"product_Name\":\"BUTTERFLY 1.2LTR RICE COOKER\",\"rx_Conqty\":1,\"Qty\":1,\"PQty\":0,\"cb_qty\":0,\"free\":0,\"Pfree\":0,\"Rate\":10.00,\"PieseRate\":10.00,\"discount\":0,\"FreeP_Code\":\"\",\"Fname\":\"\",\"discount_price\":0,\"tax\":0.0,\"tax_price\":0.0,\"OrdConv\":\"1\",\"product_unit_name\":\"PIECE\",\"selectedScheme\":0,\"selectedOffProCode\":\"241\",\"selectedOffProName\":\"PIECE\",\"selectedOffProUnit\":\"1\",\"f_key\":{\"activity_stockist_code\":\"Activity_Stockist_Report\"}},{\"product_code\":\"SAN361521\",\"product_Name\":\"BUTTERFLY PLUS 2.8LTR RICE COOKER\",\"rx_Conqty\":1,\"Qty\":1,\"PQty\":0,\"cb_qty\":0,\"free\":0,\"Pfree\":0,\"Rate\":1900.00,\"PieseRate\":1900.00,\"discount\":0,\"FreeP_Code\":\"\",\"Fname\":\"\",\"discount_price\":0,\"tax\":0.0,\"tax_price\":0.0,\"OrdConv\":\"1\",\"product_unit_name\":\"PIECE\",\"selectedScheme\":0,\"selectedOffProCode\":\"241\",\"selectedOffProName\":\"PIECE\",\"selectedOffProUnit\":\"1\",\"f_key\":{\"activity_stockist_code\":\"Activity_Stockist_Report\"}}]},{\"Activity_Stk_Sample_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]},{\"Activity_Event_Captures_Call\":[]}]"]
 
 
 

 */
