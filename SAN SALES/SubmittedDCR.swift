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
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
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
            
             Input.removeAll()
        
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
         let arey = indexPath.row
        let product = SubmittedDCR.objcalls_SelectSecondaryorder2[indexPath.row]
            let item1 = product["Trans_Detail_Slno"] as! String
        print(item1)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbSecondaryOrder") as! SecondaryOrder
               myDyPln.productData = item1
               myDyPln.areypostion = arey
            viewController.setViewControllers([myDyPln], animated: true)
            UIApplication.shared.windows.first?.rootViewController = viewController
    }
   
    @IBAction func DeleteBT(_ sender: Any) {
        self.ShowLoading(Message: "    Loading...")
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.submittedDCRTB)
        guard let indexPath = self.submittedDCRTB.indexPathForRow(at: buttonPosition) else{
            return
        }
       // for item in 0..<SubmittedDCR.objcalls_SelectSecondaryorder2.count {
            let product = SubmittedDCR.objcalls_SelectSecondaryorder2[indexPath.row]
            //let item = product["Trans_Sl_No"] as! String
            
            print(product)
          //  Trans_Sl_No = product["Trans_Sl_No"] as! String? ?? "0"
            
            
            let apiKey: String = "\(axndelet1)&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCod=\(StateCode)"
            
        if let transid = product["Trans_SlNo"] as? String,let transid2 = product["Trans_Detail_Slno"] as? String,let Trans_Detail_Info_Code = product["Trans_Detail_Info_Code"]{
                print(transid)//SEF1-81
                print(transid2)//SEF1-167
            var item : String = ""
            if let Trans_Detail_Info_Code1 = Trans_Detail_Info_Code {
                print(Trans_Detail_Info_Code1)
                item = Trans_Detail_Info_Code1 as! String
            }else{
                print("No data")
            }
            
                //print(transid3)
            var Trans_Sl_No2 : String = ""
            var sec: Int = 0
       
                if let  Trans_Sl_No = product["Trans_Sl_No"] as? String {
                 Trans_Sl_No2 = Trans_Sl_No
                    sec = 1
                    print(Trans_Sl_No2)
                    print("Trans_Sl_No is not null. Value: \(Trans_Sl_No)")
                } else {
                   Trans_Sl_No2 = transid2
                    sec = 2
                    print("Trans_Sl_No is null. Performing else conduction.")
                }
                
            
                let aFormData: [String: Any] = [
                    "arc":"\(transid)","amc":"\(Trans_Sl_No2)","sec":sec,"custId":"\(item)"
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
                        Toast.show(message: "Deleted successfully ")
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
                       // Toast.show(message: error.errorDescription!)
                        Toast.show(message: "Deleted successfully ")
                    }
                    self.LoadingDismiss()
                }
            } else {
                print("Value is nil or not a String")
            }
      //  }
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

My
 data:{"Products":[{"product_code":"SEF11251","product_Name":"Britannia Milk bikis 150g","rx_Conqty":2,"Qty":20,"PQty":0,"cb_qty":0,"free":0,"Pfree":0,"Rate":10.0,"PieseRate":10.0,"discount":0.0,"FreeP_Code":0,"Fname":0,"discount_price":0.0,"tax":2.0,"tax_price":4.0,"OrdConv":10,"product_unit_name":"BOX","Trans_POrd_No":"1328115","Order_Flag":0,"Division_code":29,"selectedScheme":0,"selectedOffProCode":"441","selectedOffProName":"BOX","selectedOffProUnit":"10","sample_qty":"204.0"},{"product_code":"SEF11254","product_Name":"Parle-G","rx_Conqty":3,"Qty":60,"PQty":0,"cb_qty":0,"free":0,"Pfree":0,"Rate":6.0,"PieseRate":6.0,"discount":0.0,"FreeP_Code":0,"Fname":0,"discount_price":0.0,"tax":2.0,"tax_price":7.2,"OrdConv":20,"product_unit_name":"BOX","Trans_POrd_No":"1328116","Order_Flag":0,"Division_code":29,"selectedScheme":0,"selectedOffProCode":"441","selectedOffProName":"BOX","selectedOffProUnit":"20","sample_qty":"367.2"},{"product_code":"SEF11426","product_Name":"Oreo","rx_Conqty":1,"Qty":10,"PQty":0,"cb_qty":0,"free":0,"Pfree":0,"Rate":6.0,"PieseRate":6.0,"discount":0.0,"FreeP_Code":0,"Fname":0,"discount_price":0.0,"tax":3.0,"tax_price":1.7999999999999998,"OrdConv":10,"product_unit_name":"BOX","Trans_POrd_No":"","Order_Flag":0,"Division_code":0,"selectedScheme":0,"selectedOffProCode":"441","selectedOffProName":"BOX","selectedOffProUnit":"10","sample_qty":"61.8"}],"Activity_Event_Captures":[],"POB":"0","Value":"633.0","order_No":"SEF3-415","DCR_Code":"SEF3-306","Trans_Sl_No":"SEF3-306","Trans_Detail_slNo":"SEF3-1258","Route":"","net_weight_value":"","target":"","rateMode":null,"Stockist":"32469","RateEditable":"","orderValue":633.0,"Stockist_POB":"","Stk_Meet_Time":"'2023-05-29 15:15:29'","modified_time":"'2023-05-29 15:15:29'","CheckoutTime":"2023-05-29 15:15:29","PhoneOrderTypes":0,"dcr_activity_date":"'2023-05-29 00:00:00'"}
*/
