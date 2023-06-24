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
    
    struct mnuItem: Any {
        let MasId: Int
        let MasName: String
        let MasLbl : String
    }
    
    struct OrderViewTB2: Any {
        let id : Int
        let Product: String
        let Qty: String
        let values: String
    }
    var orderViewTable2:[OrderViewTB2] = []
    var OrdeView:[mnuItem]=[]
    let axn="table/list"
    let axnsec = "get/SecCallDets"
    let axnview = "get/SecOrderDets"
    let axnvw = "get/vwOrderDetails"
    let axnproducts = "dcr/updateProducts"
    let axndelet1 = "deleteEntry"
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String=""

    
    let LocalStoreage = UserDefaults.standard
    var objcalls: [AnyObject]=[]
    var objcallsSINO: [AnyObject]=[]
    public static var objcalls_SelectSecondaryorder2: [AnyObject] = []
    
    public static var secondaryOrderData: [AnyObject] = []
    
    
    
    var Submittedclickdata = [SubmittedDCRselect]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        SelectSecondaryorder()
        submittedDCRTB.delegate=self
        submittedDCRTB.dataSource=self
        OrderView2.delegate=self
        OrderView2.dataSource=self
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
       if  tableView == EditTB {return objcalls.count}
        if tableView == OrderView{return OrdeView.count}
        if tableView == OrderView2{return objcalls.count}
        if tableView == submittedDCRTB {
            return SubmittedDCR.objcalls_SelectSecondaryorder2.count
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
            let item: [String: Any] = objcalls[indexPath.row] as! [String : Any]
            cell.ProductValue?.text = item["Product_Name"] as? String
            cell.Qty?.text = String(item["Quantity"] as! Int)
            cell.Value?.text = String(item["value"] as! Double)
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
    
    
//    @IBAction func ViewBT(_ sender: Any) {
//        let apiKey: String = "\(axnvw)&State_Code=\(StateCode)&divisionCode=\(DivCode)&sfCode=\(SFCode)&DCR_Code=SEF3-1326"
//
//        let aFormData: [String: Any] = [
//            "orderBy":"[\"name asc\"]","desig":"mgr"
//        ]
//        //DCR_Code=SEF3-1264    &State_Code=12&desig=MR&divisionCode=4%2C&rSF=MR3533&axn=get%2FvwOrderDetails&sfCode=MR3533&stateCode=12
//        print(aFormData)
//        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
//        let jsonString = String(data: jsonData!, encoding: .utf8)!
//        let params: Parameters = [
//            "data": jsonString
//        ]
//        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
//            AFdata in
//            switch AFdata.result
//            {
//
//            case .success(let value):
//                print(value)
//                if let json = value as? [AnyObject] {
//                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
//                        print("Error: Cannot convert JSON object to Pretty JSON data")
//                        return
//                    }
//                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
//                        print("Error: Could print JSON in String")
//                        return
//                    }
//                    print(prettyPrintedJson)
//                    self.objcalls = json
//                    OrdeView=[]
//                    OrdeView.append(mnuItem(MasId: 1, MasName: "Retailer Name :", MasLbl:json[0]["Additional_Prod_Dtls"] as! String))
//                    OrdeView.append(mnuItem(MasId: 2, MasName: "Distributors Name :", MasLbl:json[0]["OrderType"] as! String))
//                    OrdeView.append(mnuItem(MasId: 3, MasName: "Route :", MasLbl:json[0]["Route"] as! String))
//                    OrdeView.append(mnuItem(MasId: 4, MasName: "Joint Wpork :", MasLbl:json[0]["taxValue"] as! String))
//                    //rdeView.append(mnuItem(MasId: 5, MasName: "Product", MasLbl: ""))
//                    //orderViewTable2.append(OrderViewTB2(Product: "Product", Qty:"Qty", values:"Value"))
//                    self.OrderView.reloadData()
//                    orderViewTable2=[]
//                    orderViewTable2.append(OrderViewTB2(id: 1, Product: "Product", Qty: "Qty", values: "values"))
//                    orderViewTable2.append(OrderViewTB2(id: 2, Product:json[0]["Products"] as! String, Qty:String(json[0]["net_weight_value"] as! Int), values:json[0]["taxValue"] as! String))
//                    self.OrderView2.reloadData()
//                }
//            case .failure(let error):
//                Toast.show(message: error.errorDescription!)
//            }
//        }
//        Viewwindow.isHidden=false
//    }
    
    @IBAction func Edit(_ sender: Any) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.submittedDCRTB)
        guard let indexPath = self.submittedDCRTB.indexPathForRow(at: buttonPosition) else{
            return
        }
       // let secondaryorder = SubmittedDCR.secondaryOrderData[indexPath.row]
        
        for item in 0..<SubmittedDCR.objcalls_SelectSecondaryorder2.count {
            let product = SubmittedDCR.objcalls_SelectSecondaryorder2[indexPath.row]
//            let item = product["Trans_Sl_No"] as! String
//            let item2 = product["DCR_Code"] as! String
   
            self.Retlbl.text=String(format: "%@", product["Trans_Detail_Name"] as! String)
            self.Dislbl.text=String(format: "%@", product["Trans_Detail_Slno"] as! String)
            self.Rotlbl.text=String(format: "%@", product["SDP_Name"] as! String)
            self.MeetTime.text=String(format: "%@", product["StartOrder_Time"] as! String)
           // self.OrderTime.text=String(format: "%@", json[0]["Order_Out_Time"] as! String)
            self.Ordervalue.text=String(format: "%@", product["finalNetAmnt"] as! String)
            self.Remark.text=String(format: "%@", product["Activity_Remarks"] as! String)
            let item2 = product["Trans_Sl_No"] as! String
           
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
                        //                    self.objcallsSINO = Position(json[0][""])
                        self.OrderView2.reloadData()
                        
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)  //, controller: self
                }
            }
        }

        Viewwindow.isHidden=false
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
                let alert = UIAlertController(title: "Confirmation", message: "Do you want Delete this Order ?", preferredStyle: .alert)
                
                AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                    AFdata in
                    switch AFdata.result
                    {
                    case .success(let value):
                        print(value)
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
