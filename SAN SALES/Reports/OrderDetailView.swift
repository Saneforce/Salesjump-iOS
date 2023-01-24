//
//  OrderDetailView.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 04/07/22.
//

import Foundation
import UIKit
import Alamofire

class OrderDetailView: IViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var btnBack: UIImageView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOrderType: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    //From Customer
    @IBOutlet weak var lblFrmCus: UILabel!
    @IBOutlet weak var lblFrmAdd: UILabel!
    @IBOutlet weak var lblFrmMob: UILabel!
    
    //To Customer
    @IBOutlet weak var lblToCus: UILabel!
    @IBOutlet weak var lblToAdd: UILabel!
    @IBOutlet weak var lblToMob: UILabel!
    
    @IBOutlet weak var lblTotAmt: UILabel!
    
    @IBOutlet weak var tbOrderDetail: UITableView!
    @IBOutlet weak var tbZeroOrd: UITableView!
    
    @IBOutlet weak var OrdHeight: NSLayoutConstraint!
    @IBOutlet weak var OfferHeight: NSLayoutConstraint!
    @IBOutlet weak var ContentHeight: NSLayoutConstraint!
    
    var RptDate: String = ""
    var RptCode: String = ""
    var CusCount: String = ""
    
    let axn="get/vwOrderDet"
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",StrRptDt: String="",CusCd: String = "",StrMode: String="",OrdTotal: Float = 0
    
    var objOrderDetails: [AnyObject]=[]
    var objOrderDetail: [AnyObject]=[]
    var objOfferDetail: [AnyObject]=[]
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        lblDate.text = RptDate
        getUserDetails()
        getOrderDetail()
        tbOrderDetail.delegate=self
        tbOrderDetail.dataSource=self
        tbZeroOrd.delegate=self
        tbZeroOrd.dataSource=self
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tbOrderDetail == tableView { return 55}
        if tbZeroOrd == tableView { return 24 }
        return 42
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==tbOrderDetail { return objOrderDetail.count }
        if tableView==tbZeroOrd { return objOfferDetail.count }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        autoreleasepool {
            let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            if tbOrderDetail == tableView {
                let item: [String: Any] = objOrderDetail[indexPath.row] as! [String : Any]
                cell.lblText?.text = item["PName"] as? String
                cell.lblActRate?.text = String(format: "%.02f", item["Rate"] as! Double)
                cell.lblUOM?.text = String(format: "%@",item["Unit_Name"] as! String)
                cell.lblQty?.text = String(format: "%i", item["Qty"] as! Int)
                cell.lblValue?.text = String(format: "%.02f", (item["Qty"] as! Double) * (item["Rate"] as! Double) as! Double)
                cell.lblDisc?.text = String(format: "%.02f", item["Disc"] as! Double)
                cell.lblTax?.text = String(format: "%.02f", item["Tax"] as! Double)
                cell.lblAmt?.text = String(format: "%.02f", item["value"] as! Double)
            }
            if tbZeroOrd == tableView {
                let item: [String: Any] = objOfferDetail[indexPath.row] as! [String : Any]
                cell.lblText?.text = item["OffPName"] as? String
                cell.lblUOM?.text = String(format: "%@",item["OffUntName"] as! String)
                cell.lblQty?.text = String(format: "%i", item["offQty"] as! Int)
            }
            //ContentHeight.constant = tbZeroOrd.frame.height + tbZeroOrd.frame.origin.y + 10
            print(ContentHeight.constant)
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
    func getOrderDetail(){
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&rSF=\(SFCode)&rptDt=\(StrRptDt)&CusCd=\(CusCd)&sfCode=\(SFCode)&State_Code=\(StateCode)&Mode=\(StrMode)"
        let aFormData: [String: Any] = [
           "tableName":"vwMyDayPlan","coloumns":"[\"worktype\",\"FWFlg\",\"sf_member_code as subordinateid\",\"cluster as clusterid\",\"ClstrName\",\"remarks\",\"stockist as stockistid\",\"worked_with_code\",\"worked_with_name\",\"dcrtype\",\"location\",\"name\",\"Sprstk\",\"Place_Inv\",\"WType_SName\",\"convert(varchar,Pln_date,20) plnDate\"]","desig":"mgr"
        ]
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
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }
                if let list = GlobalFunc.convertToDictionary(text: prettyPrintedJson) as? [AnyObject] {
                    self.objOrderDetails = list;
                    RefreshData(indx: 0)
                }
               case .failure(let error):
                Toast.show(message: error.errorDescription!, controller: self)
            }
        }
    }
    func RefreshData(indx: Int){
        if self.objOrderDetails.count < 1 { return }
        let todayData:[String: Any] = self.objOrderDetails[indx] as! [String: Any]
        if(todayData.count>0){
            self.lblOrderNo.text=String(format: "%@", todayData["Trans_Sl_No"] as! String)
            self.lblOrderType.text=String(format: "%@", todayData["OrderTypeNm"] as! String)
            self.lblFrmCus.text=String(format: "%@", todayData["CusName"] as! String)
            self.lblFrmAdd.text=String(format: "%@", todayData["CusAddr"] as! String)
            self.lblFrmMob.text=String(format: "%@", todayData["CusMobile"] as! CVarArg)
            
            self.lblToCus.text=String(format: "%@", todayData["StkName"] as! CVarArg)
            self.lblToAdd.text=String(format: "%@", todayData["StkAddr"] as! CVarArg)
            self.lblToMob.text=String(format: "%@", todayData["StkMob"] as! CVarArg)
            self.objOrderDetail = todayData["Items"] as! [AnyObject]
            var totAmt: Double = 0
            for i in 0...objOrderDetail.count-1 {
                let item: [String: Any] = objOrderDetail[i] as! [String : Any]
                totAmt = totAmt + (item["value"] as! Double)
            }
            self.lblTotAmt.text=String(format: "Rs. %.02f", totAmt)
            
            tbOrderDetail.reloadData()
            OrdHeight.constant = CGFloat(55 * self.objOrderDetail.count)
            
            
            objOfferDetail = objOrderDetail.filter({(fitem) in
                return Bool(fitem["offQty"] as! Int > 0)
            })
            tbZeroOrd.reloadData()
            OfferHeight.constant = CGFloat(24 * self.objOrderDetail.count)
            ContentHeight.constant = CGFloat(800+(60 * self.objOrderDetail.count
                                         )+(30 * self.objOfferDetail.count
                                           ))
        }
    }
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }
}
