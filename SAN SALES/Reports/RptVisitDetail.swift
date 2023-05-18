//
//  RptVisitDetail.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 29/06/22.
//

import Foundation
import UIKit
import Alamofire

class RptVisitDetail: IViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCusCnt: UILabel!
    @IBOutlet weak var tbVstDetail: UITableView!
    @IBOutlet weak var tbItemSumry: UITableView!
    @IBOutlet weak var vstHeight: NSLayoutConstraint!
    @IBOutlet weak var itmSmryHeight: NSLayoutConstraint!
    @IBOutlet weak var ContentHeight: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIImageView!
    
    var RptDate: String = ""
    var RptCode: String = ""
    var CusCount: String = ""
    
    let axn="get/vwiOSVstDet"
    let axnsumry="get/vwItemSummmary"
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",StrRptDt: String="",StrMode: String=""
    let LocalStoreage = UserDefaults.standard
    
    var objVstDetail: [AnyObject]=[]
    var objItmSmryDetail: [AnyObject]=[]
    
    override func viewDidLoad() {
        lblDate.text = RptDate
        lblCusCnt.text = CusCount
        getUserDetails()
        getVisitDetail()
        getItemSummary()
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        tbVstDetail.delegate = self
        tbVstDetail.dataSource = self
        tbItemSumry.delegate = self
        tbItemSumry.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tbVstDetail == tableView { return 70}
        return 42
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==tbVstDetail { return objVstDetail.count }
        if tableView==tbItemSumry { return objItmSmryDetail.count }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        autoreleasepool {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if tbVstDetail == tableView {
            let item: [String: Any] = objVstDetail[indexPath.row] as! [String : Any]
            cell.lblText?.text = item["OutletName"] as? String
            cell.lblTime?.text = item["VstTime"] as? String
            cell.lblActRate?.text = String(format: "Rs. %.02f", item["OrdVal"] as! Double)
            cell.lblremark?.text = item["Activity_Remarks"] as? String
            //cell.btnViewDet.addTarget(target: self, action:  )
            cell.btnViewDet.isHidden = true
            if item["OrdVal"] as! Double > 0 { cell.btnViewDet.isHidden = false }
            cell.btnViewDet.addTarget(target: self, action: #selector(ShowOrderDet(_:)))
        }
        if tbItemSumry == tableView {
            let item: [String: Any] = objItmSmryDetail[indexPath.row] as! [String : Any]
            cell.lblText?.text = item["PName"] as? String
            cell.lblQty?.text = String(format: "%i", item["Qty"] as! Int)
            cell.lblActRate?.text = String(format: "Rs. %.02f", item["Val"] as! Double)
            
        }
        return cell
    }
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
    }
    func getVisitDetail(){
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&rSF=\(SFCode)&rptDt=\(StrRptDt)&sfCode=\(SFCode)&State_Code=\(StateCode)&Mode=\(StrMode)"
        let aFormData: [String: Any] = [
           "tableName":"vwMyDayPlan","coloumns":"[\"worktype\",\"FWFlg\",\"sf_member_code as subordinateid\",\"cluster as clusterid\",\"ClstrName\",\"remarks\",\"stockist as stockistid\",\"worked_with_code\",\"worked_with_name\",\"dcrtype\",\"location\",\"name\",\"Sprstk\",\"Place_Inv\",\"WType_SName\",\"convert(varchar,Pln_date,20) plnDate\"]","desig":"mgr"]
        print(aFormData)
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
                    if(StrMode == "VstPRet" || StrMode == "VstPDis"){
                        self.objVstDetail = json.filter({(fitem) in
                            return Bool(fitem["OrdVal"] as! Double > 0)
                        })
                    }else{
                        self.objVstDetail = json
                    }
                    tbVstDetail.reloadData()
                    vstHeight.constant = CGFloat(70*self.objVstDetail.count)
                    self.view.layoutIfNeeded()
                    ContentHeight.constant = 100+CGFloat(55*self.objVstDetail.count)+CGFloat(42*self.objItmSmryDetail.count)
                    self.view.layoutIfNeeded()
                }
               case .failure(let error):
                Toast.show(message: error.errorDescription!)//, controller: self
            }
        }
    }
    func getItemSummary(){
        let apiKey: String = "\(axnsumry)&divisionCode=\(DivCode)&rSF=\(SFCode)&rptDt=\(StrRptDt)&sfCode=\(SFCode)&State_Code=\(StateCode)&Mode=\(StrMode)"
        let aFormData: [String: Any] = [
           "tableName":"vwMyDayPlan","coloumns":"[\"worktype\",\"FWFlg\",\"sf_member_code as subordinateid\",\"cluster as clusterid\",\"ClstrName\",\"remarks\",\"stockist as stockistid\",\"worked_with_code\",\"worked_with_name\",\"dcrtype\",\"location\",\"name\",\"Sprstk\",\"Place_Inv\",\"WType_SName\",\"convert(varchar,Pln_date,20) plnDate\"]","desig":"mgr"
        ]
        print (aFormData)
        print(apiKey)
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
                    
                    self.objItmSmryDetail = json
                    tbItemSumry.reloadData()
                    itmSmryHeight.constant = CGFloat(42*self.objItmSmryDetail.count)
                    self.view.layoutIfNeeded()
                    ContentHeight.constant = 100+CGFloat(55*self.objVstDetail.count)+CGFloat(42*self.objItmSmryDetail.count)
                    self.view.layoutIfNeeded()
                    print(ContentHeight.constant)
                    print(tbItemSumry)
                }
               case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    @objc private func ShowOrderDet(_ sender: UITapGestureRecognizer) {
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indx:NSIndexPath = tbView.indexPath(for: cell)! as NSIndexPath
        openOrderDetail(Mode: StrMode,indx: indx.row)
    }
    func openOrderDetail(Mode: String,indx: Int){
        let item: [String: Any] = objVstDetail[indx] as! [String : Any]
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailView") as!  OrderDetailView
        vc.RptDate = lblDate.text!
        vc.StrRptDt = StrRptDt
        vc.CusCd=(item["OutletCode"] as? String)!
        vc.StrMode = Mode
       // vc.CusCount = Cnt
        self.navigationController?.pushViewController(vc, animated: true)
        }
    
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }
    
}
