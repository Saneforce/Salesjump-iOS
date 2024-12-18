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
    
    
    @IBOutlet weak var lblTo: UILabel!
    
    @IBOutlet weak var tbOrderDetail: UITableView!
    @IBOutlet weak var tbZeroOrd: UITableView!
    
    @IBOutlet weak var OrdHeight: NSLayoutConstraint!
    @IBOutlet weak var OfferHeight: NSLayoutConstraint!
    @IBOutlet weak var ContentHeight: NSLayoutConstraint!
    @IBOutlet weak var ListOforderTB: UITableView!
    
    @IBOutlet weak var TotalOrderView: UIView!
    
    @IBOutlet weak var BackTotalOrder: UIImageView!
    
    
    @IBOutlet weak var lblQty: UILabel!
    
    
    @IBOutlet weak var lblClQty: UILabel!
    
    struct viewDet: Codable {
        let Prname: String
        let rate: Double
        let Cl : String
        let Free : Int
        let Disc : Int
        let Tax : Int
        let qty: Int
        let value: Double
        let Product_Code:String
        let ClQty : Int
       }
    struct NoOfOrder:Codable{
        let OrderId:String
        let TotAmt:String
        let Date:String
        let Rmk:String
        let OrdFlg:Int
    }
    var TotaOrderDet:[NoOfOrder] = []
    var detail: [viewDet] = []
    var RptDate: String = ""
    var RptCode: String = ""
    var CusCount: String = ""
    
    let axn="get/vwOrderDet"
    let axbDet = "get/vwVstDetNative"
    let axnprimary = "get/vwVstDetNative"
    let axn_Acd_code = "get/DayReport"
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",StrRptDt: String="",CusCd: String = "",StrMode: String="",OrdTotal: Float = 0,Desig: String=""
    
    var objOrderDetails: [AnyObject]=[]
    var objOrderDetail: [AnyObject]=[]
    var objOfferDetail: [AnyObject]=[]
    var dayrepDict: [AnyObject]=[]
    var Acodes: String = ""
    var Order_Det:[String: Any] = [:]
    var Trans_Sl_No: String = ""
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        btnBack.addTarget(target: self, action: #selector(CloseWindo))
        BackTotalOrder.addTarget(target: self, action: #selector(GotoHome))
        lblDate.text = RptDate
        
        
        tbOrderDetail.delegate=self
        tbOrderDetail.dataSource=self
        tbZeroOrd.delegate=self
        tbZeroOrd.dataSource=self
        ListOforderTB.delegate=self
        ListOforderTB.dataSource=self
        
        detail.removeAll()
        tbOrderDetail.reloadData()
        getUserDetails()
        getOrderDetail()
       // super.viewDidLayoutSubviews()
       // adjustScrollViewContentSize()
       
        if UserSetup.shared.clCap  == "CB"{
            lblClQty.text = "CB Qty"
            lblQty.text = "Sale"
        }else if UserSetup.shared.clCap  == "CL"{
            lblClQty.text = "CL Qty"
            lblQty.text = "Qty"
        }
        
       
    }
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tbOrderDetail == tableView { return 55}
        if tbZeroOrd == tableView { return 24 }
        if ListOforderTB == tableView {return 80}
        return 42
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if tableView==tbOrderDetail { return objOrderDetail.count }
        print(detail.count)
        print(objOrderDetail)
        print(detail)
        if tableView==tbOrderDetail {
            OrdHeight.constant = CGFloat(self.detail.count * 60) // self.tbOrderDetail.contentSize.height + 30
            ContentHeight.constant = CGFloat(400+(CGFloat(self.detail.count * 60))+(self.tbZeroOrd.contentSize.height))
            return detail.count
        }
        if tableView==tbZeroOrd {
            OfferHeight.constant = self.tbZeroOrd.contentSize.height + 30
            ContentHeight.constant = CGFloat(400+(CGFloat(self.detail.count * 60))+(self.tbZeroOrd.contentSize.height))
            return objOfferDetail.count
        }
        if tableView==ListOforderTB{return TotaOrderDet.count}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        autoreleasepool {
            let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            if ListOforderTB == tableView{
                cell.lblText.text = TotaOrderDet[indexPath.row].OrderId
                //cell.lblAmt.text = "Rs. "+TotaOrderDet[indexPath.row].TotAmt
                
                cell.lblAmt.text = CurrencyUtils.formatCurrency(amount: TotaOrderDet[indexPath.row].TotAmt, currencySymbol: UserSetup.shared.currency_symbol)
                
                
                cell.ordertime.text = TotaOrderDet[indexPath.row].Date
                cell.btnViewDet.addTarget(target: self, action: #selector(ShowOrderDet(_:)))
                if (TotaOrderDet[indexPath.row].OrdFlg == 1){
                    cell.btnViewDet.isHidden = true
                }
            }
            if tbOrderDetail == tableView {
                print(detail.count)
                print(indexPath.row)
                let Pro_ID = detail[indexPath.row].Product_Code
                let filterData = objOrderDetail.filter { $0["PCode"] as? String == Pro_ID }
                var Dis_Amt = 0.0
                if filterData.isEmpty{
                    Dis_Amt = 0.0
                }else{
                    Dis_Amt = filterData[0]["Disc"] as! Double
                }
//                               let item: [String: Any] = objOrderDetail[indexPath.row] as! [String : Any]
                //                print(item)
                //                cell.lblText?.text = item["PName"] as? String
                //                cell.lblActRate?.text = String(format: "%.02f", item["Rate"] as! Double)
                //                cell.lblUOM?.text = String(format: "%@",item["Unit_Name"] as! String)
                //                cell.lblQty?.text = String(format: "%i", item["Qty"] as! Int)
                //                cell.lblValue?.text = String(format: "%.02f", (item["Qty"] as! Double) * (item["Rate"] as! Double) as! Double)
                //                cell.lblDisc?.text = String(format: "%.02f", item["Disc"] as! Double)
                //                cell.lblTax?.text = String(format: "%.02f", item["Tax"] as! Double)
                //                cell.lblAmt?.text = String(format: "%.02f", item["value"] as! Double)
                cell.lblText.text = String(detail[indexPath.row].Prname)
                cell.lblActRate.text = String(format: "%.02f",detail[indexPath.row].rate)
                cell.lblQty.text = String(detail[indexPath.row].qty)
                cell.lblUOM.text =  String(detail[indexPath.row].Cl)
                cell.lblDisc.text = String(format: "%.02f", Dis_Amt)
                cell.lblTax.text = String(detail[indexPath.row].Tax)
              //  cell.lblAmt.text =  (String(format: "%.02f",detail[indexPath.row].value))
                cell.lblAmt.text = CurrencyUtils.formatCurrency_WithoutSymbol(amount: (String(format: "%.02f",detail[indexPath.row].value)), currencySymbol: UserSetup.shared.currency_symbol)
                
               // cell.lblValue.text = String(format: "%.02f",detail[indexPath.row].rate)
                cell.lblValue.text =  CurrencyUtils.formatCurrency_WithoutSymbol(amount: String(format: "%.02f",detail[indexPath.row].rate), currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.lblText2.text = String(detail[indexPath.row].ClQty)
                 
            }
            if tbZeroOrd == tableView {
                let item: [String: Any] = objOfferDetail[indexPath.row] as! [String : Any]
                print(item)
                let name = (item["OffUntID"] as? String) != "" ? (item["OffUntID"] as? String) : (item["OffPName"] as? String)
                cell.lblText?.text = name//  item["OffUntID"] as? String
                cell.lblUOM?.text = String(format: "%@",item["OffUntName"] as! String)
                cell.lblQty?.text = String(format: "%i", item["offQty"] as! Int)
                
                let newHeight = 100 + CGFloat(55 * objOfferDetail.count)
             //   ContentHeight.constant = newHeight
                ContentHeight.constant = CGFloat(800+(self.tbOrderDetail.contentSize.height)+(self.tbZeroOrd.contentSize.height))
                print(newHeight)
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
        Desig=prettyJsonData["desigCode"] as? String ?? ""
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
   //     self.ShowLoading(Message: "Loading...")
        
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.LoadingDismiss()
            }
            switch AFdata.result
            {
               
                case .success(let value):
                print(value)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.LoadingDismiss()
                }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    if let list = GlobalFunc.convertToDictionary(text: prettyPrintedJson) as? [AnyObject] {
                        self.objOrderDetails = list;
                        self.lblOrderNo.text=String(format: "%@", list[0]["Trans_Sl_No"] as! String)
                        self.lblOrderType.text=String(format: "%@", list[0]["OrderTypeNm"] as! String)
                        self.lblFrmCus.text=String(format: "%@", list[0]["StkName"] as! CVarArg)
                        self.lblFrmAdd.text=String(format: "%@", list[0]["StkAddr"] as! CVarArg)
 
                        if let stkMob = list[0]["StkMob"] as? String, stkMob != "<null>" {
                           // self.lblFrmMob.text = stkMob
                            self.lblFrmMob.text = stkMob
                            print(stkMob)
                        } else {
                            self.lblFrmMob.text = ""
                        }

                        
                        self.lblToCus.text=String(format: "%@", list[0]["CusName"] as? String ?? "")
                        self.lblToAdd.text=String(format: "%@", list[0]["CusAddr"] as? String ?? "")
                        
                        if let StkMob = list[0]["CusMobile"] as? String, StkMob != "<null>"{
                            self.lblToMob.text=StkMob
                        } else {
                            self.lblToMob.text=""
                        }
                        RefreshData(indx: 0)
                        if (StrMode == "VstPRet" || StrMode == "VstRet"){
                           // self.ShowLoading(Message: "Loading...")
                            ViewOrder()
                            print("Finesh")
                           // self.LoadingDismiss()
                        }
                        if (StrMode == "VstPDis" || StrMode == "VstDis"){
                            self.ShowLoading(Message: "Loading...")
                            viewprimary()
                        }
                        if (StrMode == "VstSuperStk" || StrMode == "VstPSuperStk"){
                          //  self.ShowLoading(Message: "Loading...")
                            viewSuperStockist()
                        }
                        Trans_Sl_No = String(format: "%@", list[0]["Trans_Sl_No"] as! String)
                    }
             
               case .failure(let error):
                Toast.show(message: error.errorDescription!, controller: self)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.LoadingDismiss()
                }
            }
        }
    }
    func RefreshData(indx: Int){
        
        if self.objOrderDetails.count < 1 { return }
        let todayData:[String: Any] = self.objOrderDetails[indx] as! [String: Any]
        if(todayData.count>0){
            self.lblOrderNo.text=String(format: "%@", todayData["Trans_Sl_No"] as? String ?? "")
            self.lblOrderType.text=String(format: "%@", todayData["OrderTypeNm"] as? String ?? "")
            self.lblToCus.text=String(format: "%@", todayData["CusName"] as? String ?? "")
            self.lblToAdd.text=String(format: "%@", todayData["CusAddr"] as? String ?? "")
            //self.lblFrmMob.text=String(format: "%@", todayData["CusMobile"] as! CVarArg)
            if let stkMob = todayData["CusMobile"] as? String, stkMob != "<null>" {
                self.lblToMob.text = stkMob
            } else {
                self.lblToMob.text = ""
            }
            self.lblFrmCus.text=String(format: "%@", todayData["StkName"] as! CVarArg)
            self.lblFrmAdd.text=String(format: "%@", todayData["StkAddr"] as! CVarArg)
            //self.lblToMob.text=String(format: "%@", todayData["StkMob"] as! CVarArg)
            if let stkMob = todayData["StkMob"] as? String, stkMob != "<null>" {
                //self.lblFrmMob.text = stkMob
                self.lblFrmMob.text = stkMob
            } else {
                self.lblFrmMob.text = ""
            }
            self.objOrderDetail = todayData["Items"] as! [AnyObject]
            var totAmt: Double = 0
//            for i in 0...objOrderDetail.count-1 {
//                let item: [String: Any] = objOrderDetail[i] as! [String : Any]
//                totAmt = totAmt + (item["value"] as! Double)
//            }
            for i in 0..<objOrderDetail.count {
                let item: [String: Any] = objOrderDetail[i] as! [String: Any]
                totAmt = totAmt + (item["value"] as! Double)
            }
           // self.lblTotAmt.text=String(format: "Rs. %.02f", totAmt)
            
            self.lblTotAmt.text = CurrencyUtils.formatCurrency(amount: String(format: "Rs. %.02f", totAmt), currencySymbol: UserSetup.shared.currency_symbol)

           // tbOrderDetail.reloadData()
            OrdHeight.constant = CGFloat(55 * self.objOrderDetail.count)


            print(objOrderDetail)
            objOfferDetail = objOrderDetail.filter({(fitem) in
                return Bool(fitem["offQty"] as! Int > 0)
            })
            print(objOfferDetail)
            tbZeroOrd.reloadData()
            OfferHeight.constant = CGFloat(24 * self.objOrderDetail.count)
//            ContentHeight.constant = CGFloat(800+(60 * self.objOrderDetail.count
//                                         )+(30 * self.objOfferDetail.count
//                                           ))
            ContentHeight.constant = CGFloat(800+(self.tbOrderDetail.contentSize.height)+(self.tbZeroOrd.contentSize.height))
        }
    }
    
    
//    func ViewOrder(){
//        let apiKey: String = "\(axn_Acd_code)&rptDt=\(StrRptDt)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)"
//
//
//        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
//            AFdata in
//            switch AFdata.result
//            {
//
//            case .success(let value):
//                print(value)
//                if let json = value as? [String:AnyObject] {
//                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
//                        print("Error: Cannot convert JSON object to Pretty JSON data")
//                        return
//                    }
//                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
//                        print("Error: Could print JSON in String")
//                        return
//                    }
//                    print(prettyPrintedJson)
//                    dayrepDict = json["dayrep"] as! [AnyObject]
//                    var item = dayrepDict
//                    print(item)
//                    for item2 in item {
//                      var Acod = item2["ACode"]
//                        Acodes = Acod as! String
//                        print(Acodes)
//                        if let Acod = item2["ACode"]{
//                            print(Acod as Any)
//                            if let Acod1 = Acod {
//                                print(Acod1)
//
//                        } else {
//                                       print("No Data")
//                                   }
//
//                    } else {
//                                   print("Value is nil or not a String")
//                               }
//
//                    }
//
//
//
//                }
//            case .failure(let error):
//                Toast.show(message: error.errorDescription!)  //, controller: self
//            }
//        }
//    }
    func ViewOrder(){
        TotaOrderDet.removeAll()
        detail.removeAll()
        let item = RptVisitDetail.objVstDetail
        print(item)
        
        var items = ""
   
        if let Acdid = item[0]["ACD"] {

            items = Acdid as! String
        } else {
            items = "0"
        }
       let apiKey: String = "\(axbDet)&desig=\(Desig)&divisionCode=\(DivCode)&ACd=\(items)&rSF=\(SFCode)&typ=1&sfCode=\(SFCode)&State_Code=\(StateCode)"
        
            let aFormData: [String: Any] = [
                "orderBy":"[\"name asc\"]","desig":"mgr"
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            let params: Parameters = [
                "data": jsonString
            ]
            
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                AFdata in
                self.LoadingDismiss()
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
                        
                        if let indexToDelete = json.firstIndex(where: { String(format: "%@", $0["Order_No"] as! CVarArg) == Trans_Sl_No }) {
                            if let orderid = json[indexToDelete]["id"] as? String{
                                let filteredData = json.filter { $0["id"] as? String == orderid }
                                for iteminFilter in filteredData{
                                    print(iteminFilter)
                                    let Order_No = iteminFilter["Order_No"] as? String
                                    let TotalAmt = iteminFilter["finalNetAmnt"] as? String
                                    let date = iteminFilter["Order_date"] as? String
                                    let Rmk = iteminFilter["remarks"] as? String
                                    var Prod_Flg = 0
                                    var ProList = iteminFilter["productList"] as! [AnyObject]
                                    if (ProList.isEmpty){
                                        Prod_Flg = 1
                                    }
                                    TotaOrderDet.append(NoOfOrder.init(OrderId:Order_No! , TotAmt: TotalAmt!, Date: date!, Rmk: Rmk!,OrdFlg:Prod_Flg))
                                }
                            }
                            let Additional_Prod_Dtls = json[indexToDelete]["productList"] as! [AnyObject]
                            for Item2 in Additional_Prod_Dtls {
//                                detail.append(viewDet(Prname: Item2["Product_Name"] as! String, rate: Item2["Rate"] as! Double, Cl: Item2["Product_Unit_Name"] as! String, Free:Item2["discount"] as! Int, Disc: Item2["discount"] as! Int, Tax: Int(Item2["taxval"] as! Double), qty: Item2["Quantity"] as! Int, value: Item2["sub_total"] as! Double,Product_Code: Item2["Product_Code"] as! String, ClQty: Item2["cl_value"] as! Int))
                                detail.append(viewDet(Prname: Item2["Product_Name"] as? String ?? "", rate: Item2["Rate"] as? Double ?? 0, Cl: Item2["Product_Unit_Name"] as? String ?? "", Free:Item2["discount"] as? Int ?? 0, Disc: Item2["discount"] as? Int ?? 0, Tax: Int(Item2["taxval"] as? Double ?? 0), qty: Item2["eqty"] as? Int ?? 0, value: Item2["sub_total"] as? Double ?? 0,Product_Code: Item2["Product_Code"] as? String ?? "", ClQty: Item2["cl_value"] as? Int ?? 0))
                               //self.lblTotAmt.text = String(Item2["OrderVal"] as? Double ?? 0)
                                //self.lblTotAmt.text = String(Item2["OrderVal"] as! Double)
                                
                                self.lblTotAmt.text = CurrencyUtils.formatCurrency(amount: String(Item2["OrderVal"] as? Double ?? 0), currencySymbol: UserSetup.shared.currency_symbol)
                            }
                            tbOrderDetail.reloadData()
                            ListOforderTB.reloadData()
                            OrdHeight.constant = 40+CGFloat(55*detail.count)
                            self.view.layoutIfNeeded()
                            let newHeight = 100 + CGFloat(75 * detail.count) + CGFloat(2 * detail.count)
                          //  ContentHeight.constant = newHeight
                            ContentHeight.constant = CGFloat(800+(self.tbOrderDetail.contentSize.height)+(self.tbZeroOrd.contentSize.height))
                            self.view.layoutIfNeeded()
                        }
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)
                }
            }
    }
    
    func viewprimary(){
        TotaOrderDet.removeAll()
        detail.removeAll()
        let item = RptVisitDetail.objVstDetail
        var items = ""
        if let Acdid = item[0]["ACD"] {

            items = Acdid as! String
        } else {
            items = "0"
        }
        let apiKey: String = "\(axnprimary)&desig=\(Desig)&divisionCode=\(DivCode)&ACd=\(items)&rSF=\(SFCode)&typ=3&sfCode=\(SFCode)&State_Code=\(StateCode)"

            let aFormData: [String: Any] = [
                "orderBy":"[\"name asc\"]","desig":"mgr"
            ]
           // print(aFormData)
            let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            let params: Parameters = [
                "data": jsonString
            ]
            
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                AFdata in
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.LoadingDismiss()
                }
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
                        print(json)
                        print(Trans_Sl_No)
                        if let indexToDelete = json.firstIndex(where: { String(format: "%@", $0["Order_No"] as! CVarArg) == Trans_Sl_No }) {
                            print(indexToDelete)
                            
                            if let orderid = json[indexToDelete]["Trans_Detail_Slno"] as? String{
                                let filteredData = json.filter { $0["Trans_Detail_Slno"] as? String == orderid }
                                for iteminFilter in filteredData{
                                    print(iteminFilter)
                                    let Order_No = iteminFilter["Order_No"] as? String
                                    let TotalAmt = String((iteminFilter["orderValue"] as? Double ?? 0)!)
                                    let date = iteminFilter["Order_date"] as? String
                                    let Rmk = iteminFilter["remarks"] as? String
                                    var Prod_Flg = 0
                                    var ProList = iteminFilter["productList"] as! [AnyObject]
                                    if (ProList.isEmpty){
                                        Prod_Flg = 1
                                    }
                                    TotaOrderDet.append(NoOfOrder.init(OrderId:Order_No! , TotAmt: TotalAmt, Date: date!, Rmk: Rmk!, OrdFlg :Prod_Flg))
                                }
                            }
                            print(TotaOrderDet)
                            let Additional_Prod_Dtls = json[indexToDelete]["productList"] as! [AnyObject]
                            print(Additional_Prod_Dtls)
                            for Item2 in Additional_Prod_Dtls {
                                if let clBalString = Item2["Product_Unit_Name"] as? String {
//                                    detail.append(viewDet(Prname: Item2["Product_Name"] as! String, rate: Item2["Rate"] as! Double, Cl:clBalString, Free:Item2["discount"] as! Int, Disc: Item2["discount"] as! Int, Tax: Int(Item2["taxval"] as! Double), qty: Item2["Quantity"] as! Int, value: Item2["sub_total"] as! Double,Product_Code: Item2["Product_Code"] as! String, ClQty: Item2["cl_value"] as! Int))
                                    detail.append(viewDet(Prname: Item2["Product_Name"] as? String ?? "", rate: Item2["Rate"] as? Double ?? 0, Cl:clBalString, Free:Item2["discount"] as? Int ?? 0, Disc: Item2["discount"] as? Int ?? 0, Tax: Int(Item2["taxval"] as? Double ?? 0), qty: Item2["Quantity"] as? Int ?? 0, value: Item2["sub_total"] as? Double ?? 0,Product_Code: Item2["Product_Code"] as? String ?? "", ClQty: Item2["cl_value"] as? Int ?? 0))
                                } else {
                                    print("Error: 'Cl_bal' key not found in the dictionary.")
                                }
                                //self.lblTotAmt.text = String(Item2["OrderVal"] as! Double)
                                self.lblTotAmt.text = CurrencyUtils.formatCurrency(amount: String(Item2["OrderVal"] as! Double), currencySymbol: UserSetup.shared.currency_symbol)

                                
                            }
                           
                            OrdHeight.constant = 40+CGFloat(55*detail.count)
                            self.view.layoutIfNeeded()
                            let newHeight = 100 + CGFloat(75 * detail.count) + CGFloat(7 * detail.count)
                          //  ContentHeight.constant = newHeight
                            ContentHeight.constant = CGFloat(800+(self.tbOrderDetail.contentSize.height)+(self.tbZeroOrd.contentSize.height))
                            print(newHeight)
                            self.view.layoutIfNeeded()
                            tbOrderDetail.reloadData()
                            ListOforderTB.reloadData()
                          
                        }
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)
                }
            }
    }
    func viewSuperStockist() {
        let item = RptVisitDetail.objVstDetail
        print(item)
  //      TotalOrderView.isHidden = true
        var items = ""
        if let Acdid = item[0]["ACD"] {

            items = Acdid as! String
        } else {
            items = "0"
        }
        print(items)


        let apiKey: String = "\(axnprimary)&desig=\(Desig)&divisionCode=\(DivCode)&ACd=\(items)&rSF=\(SFCode)&typ=8&sfCode=\(SFCode)&State_Code=\(StateCode)"

            let aFormData: [String: Any] = [
                "orderBy":"[\"name asc\"]","desig":"mgr"
            ]
           // print(aFormData)
            let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            let params: Parameters = [
                "data": jsonString
            ]
            
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                AFdata in
                self.LoadingDismiss()
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
                        print(json)
                        print(Trans_Sl_No)
                        self.lblOrderType.isHidden = true
                        self.lblTo.isHidden = true
                        if let indexToDelete = json.firstIndex(where: { String(format: "%@", $0["Order_No"] as! CVarArg) == Trans_Sl_No }) {
                            print(indexToDelete)
                            TotaOrderDet.removeAll()
                            if let orderid = json[indexToDelete]["Trans_Detail_Slno"] as? String{
                                let filteredData = json.filter { $0["Trans_Detail_Slno"] as? String == orderid }
                                for iteminFilter in filteredData{
                                    print(iteminFilter)
                                    let Order_No = iteminFilter["Order_No"] as? String
                                    let TotalAmt = String((iteminFilter["orderValue"] as? Double) ?? 0)
                                    let date = iteminFilter["Order_date"] as? String
                                    let Rmk = iteminFilter["remarks"] as? String
                                    var Prod_Flg = 0
                                    var ProList = iteminFilter["productList"] as! [AnyObject]
                                    if (ProList.isEmpty){
                                        Prod_Flg = 1
                                    }
                                    TotaOrderDet.append(NoOfOrder.init(OrderId:Order_No! , TotAmt: TotalAmt, Date: date!, Rmk: Rmk!, OrdFlg :Prod_Flg))
                                }
                            }
                            print(TotaOrderDet)
                            detail.removeAll()
                            let Additional_Prod_Dtls = json[indexToDelete]["productList"] as! [AnyObject]
                            // self.lblTotAmt.text = String(detail[IndexPath].OrderVal as! Int)
                            //dayrepDict = json["dayrep"] as! [AnyObject]
                            print(Additional_Prod_Dtls)
                            for Item2 in Additional_Prod_Dtls {
                                print(Item2)
                                
                                if let clBalString = Item2["Product_Unit_Name"] as? String {
                                   
//                                    detail.append(viewDet(Prname: Item2["Product_Name"] as! String, rate: Item2["Rate"] as! Double, Cl:clBalString, Free:Item2["discount"] as! Int, Disc: Item2["discount"] as! Int, Tax: Int(Item2["taxval"] as! Double), qty: Item2["Quantity"] as! Int, value: Item2["sub_total"] as! Double,Product_Code: Item2["Product_Code"] as! String, ClQty: Item2["cl_value"] as! Int))
                                    detail.append(viewDet(Prname: Item2["Product_Name"] as? String ?? "", rate: Item2["Rate"] as? Double ?? 0, Cl:clBalString, Free:Item2["discount"] as? Int ?? 0, Disc: Item2["discount"] as? Int ?? 0, Tax: Int(Item2["taxval"] as? Double ?? 0), qty: Item2["Quantity"] as? Int ?? 0, value: Item2["sub_total"] as? Double ?? 0,Product_Code: Item2["Product_Code"] as? String ?? "", ClQty: Item2["cl_value"] as? Int ?? 0))
                                        print(ContentHeight as Any)
                                   
                                } else {
                                    print("Error: 'Cl_bal' key not found in the dictionary.")
                                }
                                //self.lblTotAmt.text = String(Item2["OrderVal"] as! Double)
                                
                                self.lblTotAmt.text = CurrencyUtils.formatCurrency_WithoutSymbol(amount: String(Item2["OrderVal"] as! Double), currencySymbol: UserSetup.shared.currency_symbol)
                            }
                            tbOrderDetail.reloadData()
                            OrdHeight.constant = self.tbOrderDetail.contentSize.height + 50 // 40+CGFloat(55*detail.count)
                            self.view.layoutIfNeeded()
                            let newHeight = 100 + CGFloat(75 * detail.count) + CGFloat(7 * detail.count)
                   //         ContentHeight.constant = newHeight
                            ContentHeight.constant = CGFloat(800+(self.tbOrderDetail.contentSize.height)+(self.tbZeroOrd.contentSize.height))
                            print(newHeight)
                            self.view.layoutIfNeeded()
                        //    tbOrderDetail.reloadData()
                            ListOforderTB.reloadData()
                        }
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)  //, controller: self
                }
            }
    }
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func CloseWindo() {
        TotalOrderView.isHidden = false
    }
    @objc private func ShowOrderDet(_ sender: UITapGestureRecognizer) {
        print(TotaOrderDet)
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indx:NSIndexPath = tbView.indexPath(for: cell)! as NSIndexPath
        Trans_Sl_No = TotaOrderDet[indx.row].OrderId
        if let indexTo = objOrderDetails.firstIndex(where: { String(format: "%@", $0["Trans_Sl_No"] as! CVarArg) == Trans_Sl_No }){
        RefreshData(indx: indexTo)
        }
        if (StrMode == "VstPRet" || StrMode == "VstRet"){
            ViewOrder()
        }
        if (StrMode == "VstPDis" || StrMode == "VstDis"){
            self.ShowLoading(Message: "Loading...")
            viewprimary()
        }
        if (StrMode == "VstSuperStk" || StrMode == "VstPSuperStk"){
            viewSuperStockist()
        }
        TotalOrderView.isHidden = true
    }
}



