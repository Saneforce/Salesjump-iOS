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
    
    @IBOutlet weak var tbDataSelect: UITableView!
    var SelMode: String = ""
    var isDate: Bool = false
    var SFCode: String = ""
    var DivCode: String = ""
    var lstLvlTypes: [AnyObject] = []
    var lObjSel: [AnyObject] = []
    var lAllObjSel: [AnyObject] = []
    
    var sLvlType: String = "",sDOF = "",sDOT = ""
    var FDate: Date = Date(),TDate: Date = Date()
    var eKey: String = ""
    override func viewDidLoad() {
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
        calendar.delegate=self
        calendar.dataSource=self
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        lblFDate.text = formatter.string(from: Date())
        lblTDate.text = formatter.string(from: Date())
        formatter.dateFormat = "yyyy/MM/dd"
        sDOF = formatter.string(from: Date())
        sDOT = formatter.string(from: Date())
        FDate=Date()
        TDate=Date()
        datediff()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lObjSel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            let item: [String: Any] = lObjSel[indexPath.row] as! [String : Any]
            cell.lblText?.text = item["name"] as? String
         
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
    }
    
    @objc private func selDOT() {
        isDate = true
        openWin(Mode: "DOT")
        lblSelTitle.text="Select the leave to date"
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        print("did select date \(formatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({formatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        if SelMode == "DOF" {
            lblFDate.text = selectedDates[0]
            formatter.dateFormat = "yyyy/MM/dd"
            sDOF = formatter.string(from: date)
            FDate=date
            datediff()
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

    @IBAction func closeWin(_ sender:Any){
        vwSelWindow.isHidden=true
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
            Toast.show(message: "To date must be grater or equal") //, controller: self
            return false
        }
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
    func datediff() -> Int {
        let calendar = NSCalendar.current as NSCalendar
        
        let date1 = calendar.startOfDay(for: FDate)
        let date2 = calendar.startOfDay(for: TDate)
        let flags = NSCalendar.Unit.day
        let components = calendar.components(flags, from: date1, to: date2)
        var sdys = ("\(String(describing: components.day!+1)) Day")
        if(components.day!>0){ sdys += "s" }
        lblNoDays.text = sdys
        return components.day!;
    }
    
    @objc private func GotoHome() {
        self.resignFirstResponder()
   
        self.navigationController?.popViewController(animated: true)
        return
    }
}
