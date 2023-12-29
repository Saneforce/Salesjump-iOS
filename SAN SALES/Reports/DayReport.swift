//
//  DayReport.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 15/06/22.
//

import Foundation
import UIKit
import FSCalendar
import Alamofire
class DayReport:IViewController,UICollectionViewDelegate,UICollectionViewDataSource, FSCalendarDataSource, FSCalendarDelegate{
    
    @IBOutlet weak var btnBack: UIImageView!
    
    @IBOutlet weak var lblRptDt: UILabel!
    @IBOutlet weak var lblWorkTyp: UILabel!
    @IBOutlet weak var lblRetCnt: UILabel!
    @IBOutlet weak var lblRetOrdCnt: UILabel!
    @IBOutlet weak var lblDistCnt: UILabel!
    @IBOutlet weak var lblDistOrdCnt: UILabel!
    @IBOutlet weak var lblSecVal: UILabel!
    @IBOutlet weak var lblPriVal: UILabel!
    @IBOutlet weak var lblAttnTM: UILabel!
    @IBOutlet weak var lblDyStTM: UILabel!
    @IBOutlet weak var lblDyEnTM: UILabel!
    @IBOutlet weak var lblFCTM: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var clvwBrandSal: UICollectionView!
    @IBOutlet weak var lblSelTitle: UILabel!
    
    @IBOutlet weak var vwSelWindow: UIView!
    var objBrnd: [AnyObject]=[]
    
    let axn="get/iOSDayReport"
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",StrRptDt: String=""
    let LocalStoreage = UserDefaults.standard
    var isDate: Bool = false
    override func viewDidLoad() {
        getUserDetails()
        getDayReport()
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        lblRptDt.addTarget(target: self, action: #selector(selDORpt))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = Date()
        lblRptDt.text = formatter.string(from: date)
        formatter.dateFormat = "yyyy-MM-dd"
        StrRptDt = formatter.string(from: date)
        
        clvwBrandSal.dataSource=self
        clvwBrandSal.delegate=self
        calendar.dataSource=self
        calendar.delegate=self
        clvwBrandSal.collectionViewLayout = layBranswsSal()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objBrnd.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        autoreleasepool {
            let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
            let item: [String: Any]=objBrnd[indexPath.row] as! [String : Any]
            
            cell.lblCap.text = item["product_brd_name"] as? String
            cell.lblText.text = String(format: "%i",item["RetailCount"] as! Int)
                
            return cell
        }
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
        lblRptDt.text = selectedDates[0]
        formatter.dateFormat = "yyyy-MM-dd"
        StrRptDt = formatter.string(from: date)
        getDayReport()
        clswindow(self)
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
        StrRptDt=GlobalFunc.getCurrDateAsString().replacingOccurrences(of: " ", with: "%20")
    }
    
    func getDayReport(){
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&rSF=\(SFCode)&rptDt=\(StrRptDt)&sfCode=\(SFCode)&State_Code=\(StateCode)"
        let aFormData: [String: Any] = [
           "tableName":"vwMyDayPlan","coloumns":"[\"worktype\",\"FWFlg\",\"sf_member_code as subordinateid\",\"cluster as clusterid\",\"ClstrName\",\"remarks\",\"stockist as stockistid\",\"worked_with_code\",\"worked_with_name\",\"dcrtype\",\"location\",\"name\",\"Sprstk\",\"Place_Inv\",\"WType_SName\",\"convert(varchar,Pln_date,20) plnDate\"]","desig":"mgr"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result
            {
               
                case .success(let value):
                if let json = value as? [String: Any] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                 
                    print(prettyPrintedJson)
                    let todayData:[String: Any] = json["daydets"] as! [String: Any]
                    if(todayData.count>0){
                        self.lblWorkTyp.text=String(format: "%@", todayData["wtype"] as! String)
                        self.lblRetCnt.text=String(format: "%i", todayData["secVC"] as! Int)
                        self.lblRetOrdCnt.text=String(format: "%i", todayData["secPC"] as! Int)
                        self.lblDistCnt.text=String(format: "%i", todayData["priVC"] as! Int)
                        self.lblDistOrdCnt.text=String(format: "%i", todayData["priPC"] as! Int)
                        self.lblSecVal.text=String(format: "%.02f", todayData["secoVal"] as! Double)
                        self.lblPriVal.text=String(format: "%.02f", todayData["prioVal"] as! Double)
                        self.lblAttnTM.text=String(format: "%@", todayData["attTM"] as! String)
                        self.lblDyStTM.text=String(format: "%@", todayData["StartTime"] as! String)
                        self.lblDyEnTM.text=String(format: "%@:00", todayData["secFC"] as! String)
                        if let endTime = todayData["EndTime"] as? String, !endTime.isEmpty {
                            self.lblFCTM.text = endTime
                        } else {
                            self.lblFCTM.text = "-"
                        }
                        
                        self.lblRetCnt.addTarget(target: self, action: #selector(ShowVstRet))
                        self.lblRetOrdCnt.addTarget(target: self, action: #selector(ShowPVstRet))
                        self.lblDistCnt.addTarget(target: self, action: #selector(ShowVstDis))
                        self.lblDistOrdCnt.addTarget(target: self, action: #selector(ShowPVstDis))
                        
                        /*
                         self.lblWorkTyp.text = String(format: "%@", todayData[0]["wtype"] as! String)
                         self.lblRetCnt.text = String(format: "%i", todayData[0]["Drs"] as! Int)
                         self.lblRetOrdCnt.text = String(format: "%i", todayData[0]["orders"] as! Int)
                         self.lblDistCnt.text = String(format: "%i", todayData[0]["Stk"] as! Int)
                         self.lblDistOrdCnt.text = String(format: "%i", todayData[0]["Stk"] as! Int)
                         self.lblSecVal.text = String(format: "%i", todayData[0]["Stk"] as! Int)
                         self.lblPriVal.text = String(format: "%i", todayData[0]["Stk"] as! Int)
                        */
                        
                    }
                    self.objBrnd = json["brndwise"] as! [AnyObject]
                    self.clvwBrandSal.reloadData()
                }
               case .failure(let error):
                Toast.show(message: error.errorDescription!) //, controller: self
            }
        }
    }
    
    @objc private func ShowVstRet() {
        openVstDetail(Mode: "VstRet",Cnt: self.lblRetCnt.text!)
    }
    
    @objc private func ShowPVstRet() {
        openVstDetail(Mode: "VstPRet",Cnt: self.lblRetOrdCnt.text!)
    }
    @objc private func ShowVstDis() {
        openVstDetail(Mode: "VstDis",Cnt: self.lblDistCnt.text!)
    }
    @objc private func ShowPVstDis() {
        openVstDetail(Mode: "VstPDis",Cnt: self.lblDistOrdCnt.text!)
    }
    @objc private func selDORpt() {
        isDate = true
        openWin(Mode: "DOP")
        lblSelTitle.text="Select the Date"
    }
    func openVstDetail(Mode: String,Cnt: String){
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "RptVisitDetail") as!  RptVisitDetail
        vc.RptDate = lblRptDt.text!
        vc.StrRptDt = StrRptDt
        vc.CusCount = Cnt
        vc.StrMode = Mode
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func openWin(Mode:String){
//        SelMode=Mode
//        lAllObjSel = lObjSel
//        txSearchSel.text = ""
//        calendar.isHidden = true
//        tbDataSelect.isHidden = false
//        txSearchSel.isHidden = false
        if isDate == true {
            calendar.isHidden = false
//            tbDataSelect.isHidden = true
//            txSearchSel.isHidden = true
        }
        vwSelWindow.isHidden=false
        
    }
    @objc private func GotoHome() {
        //let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbSecondaryVisit") as!  SecondaryVisit
        //self.navigationController?.pushViewController(vc, animated: true)
        
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func clswindow(_ sender: Any) {
        vwSelWindow.isHidden=true
    }
}
