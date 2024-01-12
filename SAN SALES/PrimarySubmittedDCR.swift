//
//  PrimarySubmittedDCR.swift
//  SAN SALES
//
//  Created by San eforce on 23/05/23.
//

import UIKit
import Alamofire

class PrimarySubmittedDCR: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sample:[String] = ["bha","shgdhfghdf","djfgdf"]
    
    var axn = "table/list"
    var axnDelete = "deleteEntry"
    var axnEdit = "get/pmOrderDetails"

    @IBOutlet weak var BackButton: UIImageView!
    @IBOutlet weak var PrimayOrderViewTB: UITableView!
    @IBOutlet weak var InputTB: UITableView!
    @IBOutlet weak var veselwindow: UIView!
    @IBOutlet weak var Joint_Work: UILabel!
    @IBOutlet weak var Route: UILabel!
    @IBOutlet weak var Disbutorsname: UILabel!
    @IBOutlet weak var OrderTB: UITableView!
    @IBOutlet weak var Remark: UILabel!
    @IBOutlet weak var OrderTime: UILabel!
    @IBOutlet weak var MeetTime: UILabel!
    @IBOutlet weak var Viwinput: UIView!
    @IBOutlet weak var inputTB_Hed: UIView!
    @IBOutlet weak var ScHig: NSLayoutConstraint!
    @IBOutlet weak var OrderHig: NSLayoutConstraint!
    @IBOutlet weak var InputHig: NSLayoutConstraint!
    @IBOutlet weak var lblnodata: UILabel!
    
    
    struct Viewval: Any {
        let Product : String
        let qty : Int
        let value : Double
    }
    var View:[Viewval]=[]
    
    struct inputval: Any {
        let Key: String
        let Value: String
      
    }
    
    var Input:[inputval]=[]
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    var objcalls: [AnyObject]=[]
    public static var EndOrder_Time: String = ""
    var refreshControl = UIRefreshControl()
     
   public static var objcalls_SelectPrimaryorder2: [AnyObject]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
      
        lblnodata.isHidden = true
        getUserDetails()
        SelectPrimaryorder()
        //SelectPrimary2order()
        PrimarySubmittedDCR.objcalls_SelectPrimaryorder2.removeAll()
        PrimayOrderViewTB.delegate=self
        PrimayOrderViewTB.dataSource=self
        OrderTB.dataSource=self
        OrderTB.delegate=self
        InputTB.dataSource=self
        InputTB.delegate=self
        BackButton.addTarget(target: self, action: #selector(closeMenuWin))
        PrimayOrderViewTB.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    @objc func refreshData() {
         
           fetchDataFromServer()
       }
    func fetchDataFromServer() {
        
        DispatchQueue.main.async {
            self.PrimayOrderViewTB.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    @objc func closeMenuWin(){
        navigationController?.popViewController(animated: true)
        
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        <#code#>
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if PrimayOrderViewTB  == tableView { return 210}
        return 42
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == PrimayOrderViewTB {
            
            if PrimarySubmittedDCR.objcalls_SelectPrimaryorder2.isEmpty {
                PrimayOrderViewTB.isHidden=true
                lblnodata.isHidden=false
                lblnodata.text="No data available"
                self.ShowLoading(Message: "Loading...")
            }else{
                return PrimarySubmittedDCR.objcalls_SelectPrimaryorder2.count
            }
        }
        if tableView == OrderTB {
            return View.count
        }
        if tableView == InputTB {
            return Input.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if tableView == PrimayOrderViewTB {
            lblnodata.isHidden=true
            PrimayOrderViewTB.isHidden=false
            let item: [String: Any] = PrimarySubmittedDCR.objcalls_SelectPrimaryorder2[indexPath.row] as! [String : Any]
            cell.Disbutor?.text = item["Trans_Detail_Name"] as? String
            cell.rout?.text = item["SDP_Name"] as? String
            cell.meettime.text = item["StartOrder_Time"] as? String
           
            if let order = item["Order_date"] as? String {
                cell.ordertime.text = order
            }
             
            let order = item["Order_No"] as? String
            let Additional_Prod_Dtls = item["Additional_Prod_Dtls"] as! String
            if (order == nil || Additional_Prod_Dtls == "" ) {
                cell.EditButton.isHidden = true
                cell.DeleteButton.isHidden = true
            } else {
                cell.EditButton.isHidden = false
                cell.DeleteButton.isHidden = false
            }
            
           
           
            
            cell.vwContainer.layer.cornerRadius = 20
            cell.ViewButton.layer.cornerRadius = 12
            cell.EditButton.layer.cornerRadius = 12
            cell.DeleteButton.layer.cornerRadius = 12
        }
        if tableView == OrderTB {
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
    func SelectPrimaryorder(){
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)"
        let aFormData: [String: Any] = [
            "tableName":"vwactivity_report","coloumns":"[\"*\"]","today":1,"wt":1,"orderBy":"[\"activity_date asc\"]","desig":"mgr"
        ]
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        lblnodata.isHidden=true
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result
            {
                
            case .success(let value):
                //print(value)
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
                    self.objcalls=json
                    print(json.count)
                    print(prettyPrintedJson.count)
                    if(json.count != 0){
                        SelectPrimary2order()
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
    
    func SelectPrimary2order(){
        self.ShowLoading(Message: "Loading...")
        if let transid = objcalls[0]["Trans_SlNo"] as? String {
            // Use the unwrapped value of 'transid' here
            print(transid)
       
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)"
        let aFormData: [String: Any] = [
            "tableName":"vwActivity_CSH_Detail","coloumns":"[\"*\"]","where":"[\"Trans_SlNo='\(transid)'\"]","or":3,"orderBy":"[\"stk_meet_time\"]","desig":"mgr"
        ]
       // print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
            lblnodata.isHidden=true
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            lblnodata.isHidden=false
           
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
                    print(prettyPrintedJson.count)
                    print(json.count)
                    if (json.count == 0){
                        PrimayOrderViewTB.isHidden=true
                        lblnodata.isHidden=false
                        lblnodata.text="No data available"
                    }
                 
                                               
                    PrimarySubmittedDCR.objcalls_SelectPrimaryorder2 = json
                    self.PrimayOrderViewTB.reloadData()
                    self.OrderTB.reloadData()
                    self.LoadingDismiss()
                    
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
    
    @IBAction func EditButton(_ sender: Any) {
        //Trans_Detail_SlNo=SEF3-1324&&Order_No=SEF3-424"
        
        let buttonPosition: CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.PrimayOrderViewTB)
            guard let indexPath = self.PrimayOrderViewTB.indexPathForRow(at: buttonPosition) else {
                return
            }
        let product = PrimarySubmittedDCR.objcalls_SelectPrimaryorder2[indexPath.row]
        let arey = indexPath.row
        
            let item1 = product["Trans_Detail_Slno"] as! String
        print(item1)
            let item2 = product["Order_No"] as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbPrimaryOrder") as! PrimaryOrder
        myDyPln.productData1 = item1
        myDyPln.productData2 = item2
        myDyPln.areypostion = arey
        self.navigationController?.pushViewController(myDyPln, animated: true)
         UIApplication.shared.windows.first?.rootViewController = navigationController
    }
    
    
    @IBAction func DeleteButton(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to Delete order?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
        self.ShowLoading(Message: "    Loading...")
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.PrimayOrderViewTB)
            print(buttonPosition)
        guard let indexPath = self.PrimayOrderViewTB.indexPathForRow(at: buttonPosition) else{
            return
        }
            print(indexPath)
        let product = PrimarySubmittedDCR.objcalls_SelectPrimaryorder2[indexPath.row]
            //let item = product["Trans_Sl_No"] as! String
             print(product)
            
            
            let apiKey: String = "\(self.axnDelete)&divisionCode=\(self.DivCode)%2C&desig=\(self.Desig)&rSF=\(self.SFCode)&sfCode=\(self.SFCode)&State_Code=\(self.StateCode)"
            
            if let transid = product["Trans_SlNo"] as? String,let transid2 = product["Trans_Detail_Slno"] as? String{
                // Use the unwrapped value of 'transid' here
                print(transid)//SEF1-81
                print(transid2)//SEF1-167
                var Order_No2: String = ""
                var sec: Int = 0
                if let Order_No =  product["Order_No"] as? String {
                    print(Order_No)
                    Order_No2 = Order_No
                    sec=1
                }else{
                     Order_No2 = product["Trans_Detail_Slno"] as! String
                    sec=2
                }
                
                
                
                let aFormData: [String: Any] = [
                           "arc":"\(transid)","amc":"\(Order_No2)","sec":sec
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
//                        let storyboard = UIStoryboard(name: "Submittedcalls", bundle: nil)
//                        let viewController = storyboard.instantiateViewController(withIdentifier: "PriSubNav") as! UINavigationController
//                        let myDyPln = storyboard.instantiateViewController(withIdentifier: "PrimarySubmittedDCR") as! PrimarySubmittedDCR
//                        viewController.setViewControllers([myDyPln], animated: true)
//                        UIApplication.shared.windows.first?.rootViewController = viewController
                        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
                        SelectPrimaryorder()
                        Toast.show(message: "Deleted successfully ")
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
                        //Toast.show(message: error.errorDescription!)
//                        let storyboard = UIStoryboard(name: "Submittedcalls", bundle: nil)
//                        let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
//                        let myDyPln = storyboard.instantiateViewController(withIdentifier: "PrimarySubmittedDCR") as! PrimarySubmittedDCR
//                        viewController.setViewControllers([myDyPln], animated: true)
//                        UIApplication.shared.windows.first?.rootViewController = viewController
                        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
                        SelectPrimaryorder()
                        Toast.show(message: "Deleted successfully ")
                    }
                    self.LoadingDismiss()
                }
        }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)

    }
    
    @IBAction func ViewBT(_ sender: Any) {
        Input.removeAll()
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.PrimayOrderViewTB)
        guard let indexPath = self.PrimayOrderViewTB.indexPathForRow(at: buttonPosition) else{
            return
        }
        print(buttonPosition)
        print(indexPath)
        
            let product = PrimarySubmittedDCR.objcalls_SelectPrimaryorder2[indexPath.row]
            print(product)
            self.Disbutorsname.text = product["Trans_Detail_Name"] as? String
            self.Route.text = product["SDP_Name"] as? String
            self.Joint_Work.text = product["Worked_with_Name"] as? String
            
     
        
        Input.append(inputval(Key: "Meet Time", Value: product["StartOrder_Time"] as! String))
        Input.append(inputval(Key: "Order Time", Value: product["StartOrder_Time"] as! String))
        if let pobValue = product["POB_Value"] as? Double {
            Input.append(inputval(Key: "Order Value", Value: String(pobValue)))
        } else {
            Input.append(inputval(Key: "Order Value", Value: ""))
        }

        Input.append(inputval(Key: "Remarks", Value: product["Activity_Remarks"] as! String))
        print(Input)
        InputTB.reloadData()
        PrimarySubmittedDCR.EndOrder_Time = product["EndOrder_Time"] as! String
        
            let Additional_Prod_Dtls = product["Additional_Prod_Dtls"] as! String
            let productArray = Additional_Prod_Dtls.components(separatedBy: "#")
        print(productArray)
        View.removeAll()
        if (Additional_Prod_Dtls == ""){
            print("No Data")
            OrderTB.reloadData()
        }else{
            for product in productArray {
                let productData = product.components(separatedBy: "@")
                print(productData[0])
                let productData2 = productData[0]
                print(productData2)
                
                let productDatas = productData2.components(separatedBy: "~")
                print(productDatas[0])
                let price = productDatas[1].components(separatedBy: "$")[0]
                let price1 = productDatas[1].components(separatedBy: "$")[1]
                print(price)
                print(price1)
                
                View.append(Viewval(Product:productDatas[0] , qty: Int(price1)!, value: Double(price)!))
                print(View)
                OrderTB.reloadData()
                
            }
        }
        if (View.count == 0){
            OrderHig.constant = 10
        }else if (10 < View.count){
            OrderHig.constant = 100 + CGFloat(35*self.View.count)
        }
        else{
            OrderHig.constant = 100 + CGFloat(25*self.View.count)
        }
        print(OrderHig.constant)
            self.view.layoutIfNeeded()
        if ( 10 < View.count){
            ScHig.constant = 120 + CGFloat(55*self.View.count)+CGFloat(45*self.Input.count)
        }else{
            ScHig.constant = 100 + CGFloat(40*self.View.count)+CGFloat(35*self.Input.count)
        }
        self.view.layoutIfNeeded()
        
        
        veselwindow.isHidden=false
    }
    
    @IBAction func CloseWI(_ sender: Any) {
        veselwindow.isHidden=true
    }
    
}

/*
 
 */
