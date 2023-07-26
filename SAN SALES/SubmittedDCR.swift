//
//  SubmittedDCR.swift
//  SAN SALES
//
//  Created by San eforce on 23/05/23.
//

import UIKit
import Alamofire
import SwiftUI
import AVFoundation

class SubmittedDCR: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let product:[String] = ["Start Time","Customer Channel","Address","GST"]
    @IBOutlet weak var BackButton: UIImageView!
    @IBOutlet weak var EditTB: UITableView!
    @IBOutlet weak var submittedDCRTB: UITableView!
    @IBOutlet weak var veselwindow: UIView!
    @IBOutlet weak var Slno: UILabel!
    @IBOutlet weak var Ordervalue: UILabel!
    @IBOutlet weak var Product: UILabel!
    @IBOutlet weak var Viewwindow: UIView!
    @IBOutlet weak var OrderView: UITableView!
    @IBOutlet weak var OrderView2: UITableView!
    
    @IBOutlet weak var Jointlbl: UILabel!
    @IBOutlet weak var Rotlbl: UILabel!
    @IBOutlet weak var Dislbl: UILabel!
    @IBOutlet weak var Retlbl: UILabel!
    @IBOutlet weak var Remark: UILabel!
    @IBOutlet weak var OrderValue: UILabel!
    @IBOutlet weak var OrderTime: UILabel!
    @IBOutlet weak var MeetTime: UILabel!
    @IBOutlet weak var InputTB: UITableView!
    @IBOutlet weak var ScroolHight: NSLayoutConstraint!
    @IBOutlet weak var OrederTBHight: NSLayoutConstraint!
    @IBOutlet weak var InputTBhight: NSLayoutConstraint!
    
    @IBOutlet weak var Ret_and_img_Hed: UIView!
    
    @IBOutlet weak var Ret_and_img_Hed2: UIView!
    
    
    struct mnuItem: Any {
        let MasId: Int
        let MasName: String
        let MasLbl : String
    }
    struct inputval: Any {
        let Key: String
        let Value: String
      
    }
    struct Viewval: Any {
        let Product : String
        let qty : Int
        let value : Int
    }
    var View:[Viewval]=[]
    
    struct OrderViewTB2: Any {
        let id : Int
        let Product: String
        let Qty: String
        let values: String
    }
    var orderViewTable2:[OrderViewTB2] = []
    var Input:[inputval]=[]
    var OrdeView:[mnuItem]=[]
    let axn="table/list"
    let axnsec = "get/SecCallDets"
    let axnview = "get/SecOrderDets"
    let axnvw = "get/vwOrderDetails"
//    let axnproducts = "dcr/updateProducts"
    let axndelet1 = "deleteEntry"
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String=""

    
    let LocalStoreage = UserDefaults.standard
    var objcalls: [AnyObject]=[]
    var objcallsSINO: [AnyObject]=[]
    public static var objcalls_SelectSecondaryorder2: [AnyObject] = []
    
    public static var secondaryOrderData: [AnyObject] = []
    public static var Order_Out_Time: String = ""
    
    
    
    var Submittedclickdata = [SubmittedDCRselect]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        SelectSecondaryorder()
        submittedDCRTB.delegate=self
        submittedDCRTB.dataSource=self
        OrderView2.delegate=self
        OrderView2.dataSource=self
        InputTB.delegate=self
        InputTB.dataSource=self
        BackButton.addTarget(target: self, action: #selector(closeMenuWin))
        // Do any additional setup after loading the view.
    }
    @objc func closeMenuWin(){
        GlobalFunc.movetoHomePage()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if submittedDCRTB == tableView { return 190}
        if EditTB == tableView {return 100}
        return 42
    }
    func updateData () {
        
        for brand in objcalls {
            
            self.Submittedclickdata.append(SubmittedDCRselect(isSelectedAvail:false, isSelectedEC: false,SubmittedData: brand))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // if  tableView == EditTB {return objcalls.count}
        if tableView == OrderView{return OrdeView.count}
        if tableView == OrderView2{return View.count}
        if tableView == submittedDCRTB {
            return SubmittedDCR.objcalls_SelectSecondaryorder2.count
        }
        if tableView == InputTB{
            return Input.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
       
        if tableView == submittedDCRTB {
            let item: [String: Any] = SubmittedDCR.objcalls_SelectSecondaryorder2[indexPath.row] as! [String : Any]
            cell.RetailerName?.text = item["Trans_Detail_Name"] as? String
            cell.DistributerName?.text = item["Trans_Detail_Slno"] as? String
            cell.Rou?.text = item["SDP_Name"] as? String
            cell.MeetTime?.text = item["Order_In_Time"] as? String
            cell.OrderTime?.text = item["Order_Out_Time"] as? String
        }
        if tableView == OrderView {
            cell.lblText.text = OrdeView[indexPath.row].MasName
            cell.OrderValue.text = OrdeView[indexPath.row].MasLbl
        }
        if tableView == OrderView2 {
          
            cell.ProductValue?.text = View[indexPath.row].Product
            cell.Qty?.text = String(View[indexPath.row].qty)
            cell.Value?.text = String(View[indexPath.row].value)
          
        }
        if tableView == InputTB {
            cell.InpuKey.text = Input[indexPath.row].Key
            cell.inputvalu.text = Input[indexPath.row].Value
        }
            
        return cell
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
    
    func SelectSecondaryorder(){
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)"
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
                    self.objcalls = json
                
                    SelectSecondaryorder2()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
        
        func SelectSecondaryorder2(){
            if let transid = objcalls[0]["Trans_SlNo"] as? String {
                // Use the unwrapped value of 'transid' here
                print(transid)
            
            let apiKey: String = "\(axnsec)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)&trans_SlNo=\(transid)"
            //\(String(describing: objcalls[0]["Trans_SlNo"]))
            let aFormData: [String: Any] = [
                "tableName":"vwactivity_report","coloumns":"[\"*\"]","today":1,"wt":1,"orderBy":"[\"activity_date asc\"]","desig":"mgr"
            ]
            //print(aFormData)
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
//                    print(value)
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
                        SubmittedDCR.objcalls_SelectSecondaryorder2 = json
                        
                        
                        if !json.isEmpty {
                        self.Slno.text=String(format: "%@", json[0]["Trans_SlNo"] as! String)
                        self.Product.text=String(format: "%@", json[0]["Trans_Detail_Name"] as! String)
                        self.Ordervalue.text=String(format: "%@", json[0]["finalNetAmnt"] as! String)
                        self.submittedDCRTB.reloadData()
                       
                           
                        }
                        
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)  //, controller: self
                }
            }
            } else {
                // The value was nil or couldn't be cast to a String
                print("Value is nil or not a String")
            }
        }
    
     
    @IBAction func Edit(_ sender: Any) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.submittedDCRTB)
        guard let indexPath = self.submittedDCRTB.indexPathForRow(at: buttonPosition) else{
            return
        }
        
   
            let product = SubmittedDCR.objcalls_SelectSecondaryorder2[indexPath.row]
            print(product)

   
            self.Retlbl.text=String(format: "%@", product["Trans_Detail_Name"] as! String)
            self.Dislbl.text=String(format: "%@", product["Trans_Detail_Slno"] as! String)
            self.Rotlbl.text=String(format: "%@", product["SDP_Name"] as! String)
            let item2 = product["Trans_Sl_No"] as! String
            
            Input.append(inputval(Key: "Meet Time", Value: product["StartOrder_Time"] as! String))
            Input.append(inputval(Key: "Order Time", Value: product["Order_Out_Time"] as! String))
            Input.append(inputval(Key: "Order Value", Value: product["finalNetAmnt"] as! String))
            Input.append(inputval(Key: "Remarks", Value: product["Activity_Remarks"] as! String))
            InputTB.reloadData()
        SubmittedDCR.Order_Out_Time =  product["Order_Out_Time"] as! String
        print(SubmittedDCR.Order_Out_Time)
        
            let apiKey: String = "\(axnview)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)&Order_No=\(item2)"
            
            
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
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
                        self.objcalls = json
                    
                        View.removeAll()
                        for item in json {
                            
                            View.append(Viewval(Product: item["Product_Name"] as! String, qty: item["Quantity"] as! Int, value: Int(item["value"] as! Double)))
                            
                        }
                        OrederTBHight.constant = 100 + CGFloat(40*self.View.count)
                        print(OrederTBHight.constant)
                            self.view.layoutIfNeeded()
                        ScroolHight.constant = 100 + CGFloat(60*self.View.count)
                        print(ScroolHight.constant)
                            self.view.layoutIfNeeded()                  
                        updateTableViewAndSubview()
                        self.OrderView2.reloadData()
                        
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)  //, controller: self
                }
            }
        

        Viewwindow.isHidden=false
    }
    func updateTableViewAndSubview() {
        // Step 1: Calculate the new height for the tableView
        let tableViewHeight = 100 + CGFloat(40 * View.count)

        // Assuming you have a reference to your tableView and viewBelowTableView
        // Replace 'YourTableView' and 'YourViewBelowTableView' with the appropriate class names.
        guard let tableView = OrderView2,//MANI
              let viewBelowTableView = Ret_and_img_Hed else {
            return
        }
        guard let tableView2 = OrderView2,//MANI
              let viewBelowTableView2 = Ret_and_img_Hed2 else {
            return
        }
        guard let tableView3 = OrderView2,//MANI
              let viewBelowTableView3 = InputTB else {
            return
        }


        // Step 2: Calculate the new frame for the view below the tableView
        let viewBelowTableViewY = tableView.frame.origin.y + tableViewHeight+20
        let viewBelowTableViewNewFrame = CGRect(x: viewBelowTableView.frame.origin.x,
                                                y: viewBelowTableViewY,
                                                width: viewBelowTableView.frame.size.width,
                                                height: viewBelowTableView.frame.size.height)
        
        let viewBelowTableViewY2 = tableView2.frame.origin.y + tableViewHeight+40
        let viewBelowTableViewNewFrame2 = CGRect(x: viewBelowTableView2.frame.origin.x,
                                                y: viewBelowTableViewY2,
                                                width: viewBelowTableView2.frame.size.width,
                                                height: viewBelowTableView2.frame.size.height)

        let viewBelowTableViewY3 = tableView3.frame.origin.y + tableViewHeight+80
        let viewBelowTableViewNewFrame3 = CGRect(x: viewBelowTableView3.frame.origin.x,
                                                y: viewBelowTableViewY3,
                                                width: viewBelowTableView3.frame.size.width,
                                                height: viewBelowTableView3.frame.size.height)

        
        
        // Step 3: Update the tableView height and view's frame
        UIView.animate(withDuration: 0.3) {
            // Update tableView height
            tableView.frame = CGRect(x: tableView.frame.origin.x,
                                     y: tableView.frame.origin.y,
                                     width: tableView.frame.size.width,
                                     height: tableViewHeight)

            // Update the view below tableView's frame
            viewBelowTableView.frame = viewBelowTableViewNewFrame
            viewBelowTableView2.frame = viewBelowTableViewNewFrame2
            viewBelowTableView3.frame = viewBelowTableViewNewFrame3

            // Make sure other UI elements are updated correctly
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func EditSecondaryordervalue(_ sender: Any){
        let buttonPosition: CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.submittedDCRTB)
            guard let indexPath = self.submittedDCRTB.indexPathForRow(at: buttonPosition) else {
                return
            }
        let product = SubmittedDCR.objcalls_SelectSecondaryorder2[indexPath.row]
            let item1 = product["Trans_Detail_Slno"] as! String
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbSecondaryOrder") as! SecondaryOrder
               myDyPln.productData = item1
            viewController.setViewControllers([myDyPln], animated: true)
            UIApplication.shared.windows.first?.rootViewController = viewController
    }
    
    @IBAction func DeleteBT(_ sender: Any) {
        
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.submittedDCRTB)
        guard let indexPath = self.submittedDCRTB.indexPathForRow(at: buttonPosition) else{
            return
        }
        for item in 0..<SubmittedDCR.objcalls_SelectSecondaryorder2.count {
            let product = SubmittedDCR.objcalls_SelectSecondaryorder2[indexPath.row]
            let item = product["Trans_Sl_No"] as! String
            
            
            
            let apiKey: String = "\(axndelet1)&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCod=\(StateCode)"
            
            if let transid = product["Trans_SlNo"] as? String,let transid2 = product["Trans_Detail_Slno"] as? String{
                print(transid)//SEF1-81
                print(transid2)//SEF1-167
                let aFormData: [String: Any] = [
                    "arc":"\(transid)","amc":"\(transid2)","sec":2,"custId":"2049231"
                ]
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
                        print(value)
                        if value is [String: Any] {
                            guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                                print("Error: Cannot convert JSON object to Pretty JSON data")
                                return
                            }
                            guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                                print("Error: Could print JSON in String")
                                return
                            }
                            print(prettyPrintedJson)
                        }
                    case .failure(let error):
                        Toast.show(message: error.errorDescription!)
                    }
                }
            } else {
                print("Value is nil or not a String")
            }
        }
        //SelectSecondaryorder2()
    }
    
    @IBAction func clswindow(_ sender: Any) {
        veselwindow.isHidden=true
        Viewwindow.isHidden=true
    }
    }

struct SubmittedDCRselect {
    var isSelectedAvail : Bool
    var isSelectedEC : Bool
    var SubmittedData : AnyObject
}


/*
 [{\"Activity_Report_APP\":{\"Worktype_code\":\"\'1386\'\",\"Town_code\":\"\'114726\'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'2023-07-26 17:24:45\'\",\"Daywise_Remarks\":\"\",\"eKey\":\"EKMGR1018-1690372486\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"DataSF\":\"\'MR4126\'\"}},{\"Activity_Doctor_Report\":{\"Doctor_POB\":0,\"Worked_With\":\"\'\'\",\"Doc_Meet_Time\":\"\'2023-07-26 17:24:45\'\",\"modified_time\":\"\'2023-07-26 17:24:45\'\",\"net_weight_value\":\"0.00\",\"stockist_code\":\"\'32538\'\",\"stockist_name\":\"\'BUTTERFLY APPLIANCES\'\",\"superstockistid\":\"\'\'\",\"Discountpercent\":0,\"CheckinTime\":\"2023-07-26 17:24:45\",\"CheckoutTime\":\"2023-07-26 17:24:49\",\"location\":\"\'37.785834:-122.406417\'\",\"geoaddress\":\"1 Stockton St, San Francisco, CA  94108, Vereinigte Staaten\",\"PhoneOrderTypes\":\"0\",\"Order_Stk\":\"\'15560\'\",\"Order_No\":\"\'\'\",\"rootTarget\":\"0\",\"orderValue\":20,\"disPercnt\":0.0,\"disValue\":0.0,\"finalNetAmt\":340.4,\"taxTotalValue\":0.4,\"discTotalValue\":0.0,\"subTotal\":340.0,\"No_Of_items\":4,\"rateMode\":\"free\",\"discount_price\":0,\"doctor_code\":\"\'2154783\'\",\"doctor_name\":\"\'KUMAR SUPERMARKET\'\",\"doctor_route\":\"\'mylapore\'\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"}}},{\"Activity_Sample_Report\":[{\"product_code\":\"SEF11251\", \"product_Name\":\"Britannia Milk bikis 150g\", \"Product_Rx_Qty\":1, \"UnitId\": \"241\", \"UnitName\": \"PIECE\", \"rx_Conqty\":1, \"Product_Rx_NQty\": 0, \"Product_Sample_Qty\": \"20.00\", \"vanSalesOrder\":0, \"net_weight\": 0.0, \"free\": 0, \"FreePQty\": 0, \"FreeP_Code\": \"\", \"Fname\": \"\", \"discount\": 0, \"discount_price\": 0, \"tax\": 0, \"tax_price\": 0, \"Rate\": 20.00, \"Mfg_Date\": \"\", \"cb_qty\": 0, \"RcpaId\": \"\", \"Ccb_qty\": 0, \"PromoVal\": 0, \"rx_remarks\":\"\", \"rx_remarks_Id\": \"\", \"OrdConv\":1, \"selectedScheme\":0, \"selectedOffProCode\": \"241\", \"selectedOffProName\":\"PIECE\", \"selectedOffProUnit\": \"1\", \"f_key\": {\"Activity_MSL_Code\": \"Activity_Doctor_Report\"}}]},{\"Trans_Order_Details\":[]},{\"Activity_Input_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]},{\"Activity_Event_Captures_Call\":[]}]


 
 {\"Activity_Sample_Report\":[{\"product_code\":\"SEF11251\", \"product_Name\":\"Britannia Milk bikis 150g\", \"Product_Rx_Qty\":1, \"UnitId\": \"241\", \"UnitName\": \"PIECE\", \"rx_Conqty\":1, \"Product_Rx_NQty\": 0, \"Product_Sample_Qty\": \"20.00\", \"vanSalesOrder\":0, \"net_weight\": 0.0, \"free\": 0, \"FreePQty\": 0, \"FreeP_Code\": \"\", \"Fname\": \"\", \"discount\": 0, \"discount_price\": 0, \"tax\": 0, \"tax_price\": 0, \"Rate\": 20.00, \"Mfg_Date\": \"\", \"cb_qty\": 0, \"RcpaId\": \"\", \"Ccb_qty\": 0, \"PromoVal\": 0, \"rx_remarks\":\"\", \"rx_remarks_Id\": \"\", \"OrdConv\":1, \"selectedScheme\":0, \"selectedOffProCode\": \"241\", \"selectedOffProName\":\"PIECE\", \"selectedOffProUnit\": \"1\", \"f_key\": {\"Activity_MSL_Code\": \"Activity_Doctor_Report\"}}]}


 "[\"Products\":[{\"product\":\"SAN361518\",\"UnitId\":\"241\",\"UnitName\":\"PIECE\",\"product_Nm\":\"BUTTERFLY 1.2LTR RICE COOKER\",\"OrdConv\":1,\"free\":0,\"HSN\":\"\",\"Rate\":40.0,\"imageUri\":\"Important for van sales 1.jpg\",\"Schmval\":0,\"rx_qty\":1,\"recv_qty\":0,\"product_netwt\":0.0,\"netweightvalue\":0,\"conversionQty\":1,\"cateid\":1011,\"UcQty\":1,\"rx_Conqty\":1,\"id\":\"SAN361518\",\"name\":\"BUTTERFLY 1.2LTR RICE COOKER\",\"rx_remarks\":\"\",\"rx_remarks_Id\":\"\",\"sample_qty\":\"10.0\",\"FreeP_Code\":\"\",\"Fname\":\"\",\"PromoVal\":0,\"discount\":0.0,\"discount_price\":0.0,\"tax\":0.0,\"tax_price\":0.0,\"selectedScheme\":0,\"selectedOffProCode\":\"\",\"selectedOffProName\":\"\",\"selectedOffProUnit\":\"\"}]
 
 
 
 
 ,\"Activity_Event_Captures\":[],\"POB\":\"0\",\"Value\":\"54.879999999999995\",\"disPercnt\":0.0,\"disValue\":0.0,\"finalNetAmt\":54.879999999999995,\"taxTotalValue\":\"0.88\",\"discTotalValue\":\"0.0\",\"subTotal\":\"54.0\",\"No_Of_items\":\"3\",\"Cust_Code\":\"'2149655'\",\"DCR_Code\":\"SEF1-279\",\"Trans_Sl_No\":\"MGR1018-23-24-SO-126\",\"Route\":\"114726\",\"net_weight_value\":\"0\",\"Discountpercent\":0.0,\"discount_price\":0.0,\"target\":\"0\",\"rateMode\":\"free\",\"Stockist\":\"32538\",\"RateEditable\":\"\"]"
 */
