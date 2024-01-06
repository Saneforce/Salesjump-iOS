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
    @IBOutlet weak var Nodatalbl: UILabel!
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
    var lstDisDetail: [AnyObject] = []
    public static var objcalls_SelectSecondaryorder2: [AnyObject] = []
    
    public static var secondaryOrderData: [AnyObject] = []
    public static var Order_Out_Time: String = ""
    
    var refreshControl = UIRefreshControl()
    
    var Submittedclickdata = [SubmittedDCRselect]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let LocalStoreage = UserDefaults.standard
        Nodatalbl.isHidden = true
        getUserDetails()
        SelectSecondaryorder()

//        let lstDisData: String=LocalStoreage.string(forKey: "Distributors_Master_")!
//        if let list = GlobalFunc.convertToDictionary(text: lstDisData) as? [AnyObject] {
//            lstDisDetail = list;
//        }
        
        submittedDCRTB.delegate=self
        submittedDCRTB.dataSource=self
        OrderView2.delegate=self
        OrderView2.dataSource=self
        InputTB.delegate=self
        InputTB.dataSource=self
        BackButton.addTarget(target: self, action: #selector(closeMenuWin))
        // Do any additional setup after loading the view.
        submittedDCRTB.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
    }
    @objc func refreshData() {
         
           fetchDataFromServer()
       }
    func fetchDataFromServer() {
        
        DispatchQueue.main.async {
            self.submittedDCRTB.reloadData()
            self.refreshControl.endRefreshing()
        }
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
            
            if SubmittedDCR.objcalls_SelectSecondaryorder2.isEmpty{
                submittedDCRTB.isHidden = true
                Nodatalbl.isHidden = false
                Nodatalbl.text = "No data available"
                self.ShowLoading(Message: "Loading...")
               
            }else{
              return SubmittedDCR.objcalls_SelectSecondaryorder2.count
            }
           
          
        }
        if tableView == InputTB{
            return Input.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
           
        
        if tableView == submittedDCRTB {
            submittedDCRTB.isHidden = false
                print(SubmittedDCR.objcalls_SelectSecondaryorder2)
                let item: [String: Any] = SubmittedDCR.objcalls_SelectSecondaryorder2[indexPath.row] as! [String : Any]
            print(item)
                cell.RetailerName?.text = item["Trans_Detail_Name"] as? String
            print(lstDisDetail)
            
                cell.DistributerName?.text = ""
                cell.Rou?.text = item["SDP_Name"] as? String
                cell.MeetTime?.text = item["Order_In_Time"] as? String
                cell.OrderTime?.text = item["Order_Out_Time"] as? String
                
                if let transSlNo = item["Order_Out_Time"] as? String {
                    cell.OrderTime?.text = transSlNo
                    
                }
            
            if (item["Trans_Sl_No"] as? String == nil){
                cell.EditBton.isHidden = true
                cell.DeleteButton.isHidden = true
            }else {
                    cell.EditBton.isHidden = false
                    cell.DeleteButton.isHidden = false
                }
                cell.vwContainer.layer.cornerRadius = 20
                cell.Viewbt.layer.cornerRadius = 12
                cell.EditBton.layer.cornerRadius = 12
                cell.DeleteButton.layer.cornerRadius = 12
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
        Nodatalbl.isHidden = true
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
                    if (json.count != 0){
                        SelectSecondaryorder2()
                    }
                    
                    if(json.count == 0){
                        self.LoadingDismiss()
                    }
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
            
                Nodatalbl.isHidden = true
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                AFdata in
                self.LoadingDismiss()
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
        
        
        
        Input.removeAll()
        
        Input.append(inputval(Key: "Meet Time", Value: product["StartOrder_Time"] as! String))
        
        if (product["Order_Out_Time"] as? String == nil){
            Input.append(inputval(Key: "Order Time", Value: ""))
        }else{
            Input.append(inputval(Key: "Order Time", Value: product["Order_Out_Time"] as! String))
        }
        if (product["Order_Value"] as? String == nil){
            Input.append(inputval(Key: "Order Value", Value: "0.0"))
        }else{
            Input.append(inputval(Key: "Order Value", Value: product["Order_Value"] as! String))
        }
        Input.append(inputval(Key: "Remarks", Value: product["Activity_Remarks"] as! String))
        InputTB.reloadData()
        
        if (product["Order_Out_Time"] as? String == nil){
            SubmittedDCR.Order_Out_Time =  ""
        }else{
            SubmittedDCR.Order_Out_Time =  product["Order_Out_Time"] as! String
        }
        print(SubmittedDCR.Order_Out_Time)
        if (product["Trans_Sl_No"] as? String == nil){
            print("No Data")
            self.OrderView2.reloadData()
        }else{
            var Trans_Sl_No_Code = ""
            if let item2 = product["Trans_Sl_No"] as? String{
                Trans_Sl_No_Code = item2
            }
            
        let apiKey: String = "\(axnview)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)&Order_No=\(Trans_Sl_No_Code)"
        
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
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
       // let =self.storyboard?.instantiateViewController(withIdentifier: "sbSecondaryOrder") as!  SecondaryOrder
        
       // self.navigationController?.pushViewController(vc, animated: true)
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbSecondaryOrder") as! SecondaryOrder
               myDyPln.productData = item1
               myDyPln.areypostion = arey
           // viewController.setViewControllers([myDyPln], animated: true)
           self.navigationController?.pushViewController(myDyPln, animated: true)
            UIApplication.shared.windows.first?.rootViewController = navigationController
    }
   
    @IBAction func DeleteBT(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to Delete order?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
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
            
            
            let apiKey: String = "\(self.axndelet1)&desig=\(self.Desig)&divisionCode=\(self.DivCode)&rSF=\(self.SFCode)&sfCode=\(self.SFCode)&stateCod=\(self.StateCode)"
            
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
                        let storyboard = UIStoryboard(name: "Submittedcalls", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                        let myDyPln = storyboard.instantiateViewController(withIdentifier: "SubmittedDCR") as! SubmittedDCR
                        viewController.setViewControllers([myDyPln], animated: true)
                        UIApplication.shared.windows.first?.rootViewController = viewController
                        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
                        self.updateOrderValues(refresh: 1)
                        
                        
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
                        let storyboard = UIStoryboard(name: "Submittedcalls", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                        let myDyPln = storyboard.instantiateViewController(withIdentifier: "SubmittedDCR") as! SubmittedDCR
                        viewController.setViewControllers([myDyPln], animated: true)
                        UIApplication.shared.windows.first?.rootViewController = viewController
                        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
                        Toast.show(message: "Deleted successfully ")
                    }
                    self.LoadingDismiss()
                }
            } else {
                print("Value is nil or not a String")
            }
      //  }
        //SelectSecondaryorder2()
            self.updateOrderValues(refresh: 1)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    
    func updateOrderValues(refresh: Int){
        if(refresh == 1){
            submittedDCRTB.reloadData()
            //tbProduct.reloadData()
        }
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
