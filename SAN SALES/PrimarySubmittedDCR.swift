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
//http://www.fmcg.sanfmcg.com/server/native_Db_V13.php?State_Code=24&Trans_Detail_SlNo=SEF3-1258&axn=get%2FpmOrderDetails&Order_No=SEF3-415
    @IBOutlet weak var BackButton: UIImageView!
    @IBOutlet weak var PrimayOrderViewTB: UITableView!
    @IBOutlet weak var veselwindow: UIView!
    @IBOutlet weak var Joint_Work: UILabel!
    @IBOutlet weak var Route: UILabel!
    @IBOutlet weak var Disbutorsname: UILabel!
    @IBOutlet weak var OrderTB: UITableView!
    @IBOutlet weak var Remark: UILabel!
    @IBOutlet weak var OrderTime: UILabel!
    @IBOutlet weak var MeetTime: UILabel!
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    var objcalls: [AnyObject]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        getUserDetails()
        SelectPrimaryorder()
        SelectPrimary2order()
        PrimayOrderViewTB.delegate=self
        PrimayOrderViewTB.dataSource=self
        OrderTB.dataSource=self
        OrderTB.delegate=self
        BackButton.addTarget(target: self, action: #selector(closeMenuWin))
        // Do any additional setup after loading the view.
    }
    @objc func closeMenuWin(){
        GlobalFunc.movetoHomePage()
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
            return objcalls.count
        }
        if tableView == OrderTB {
            return objcalls.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if tableView == PrimayOrderViewTB {
            let item: [String: Any] = objcalls[indexPath.row] as! [String : Any]
            cell.Disbutor?.text = item["Trans_Detail_Name"] as? String
            cell.rout?.text = item["SDP"] as? String
            cell.meettime.text = item["StartOrder_Time"] as? String
            cell.ordertime.text = item["Order_date"] as? String
            cell.vwContainer.layer.cornerRadius = 20
            cell.ViewButton.layer.cornerRadius = 12
            cell.EditButton.layer.cornerRadius = 12
            cell.DeleteButton.layer.cornerRadius = 12
        }
        if tableView == OrderTB {
            let item: [String: Any] = objcalls[indexPath.row] as! [String : Any]
            cell.ProductValue?.text = item["Additional_Prod_Dtls"] as? String
            cell.Qty?.text = item[""] as? String
            cell.Value?.text = item ["POB_Value"] as? String
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
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    func SelectPrimary2order(){
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)"
        let aFormData: [String: Any] = [
            "tableName":"vwActivity_CSH_Detail","coloumns":"[\"*\"]","where":"[\"Trans_SlNo='SEF1-80'\"]","or":3,"orderBy":"[\"stk_meet_time\"]","desig":"mgr"
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
                  //  self.lblWorkTyp.text=String(format: "%@", todayData["wtype"] as! String)
                    self.Disbutorsname.text = json[0]["Trans_Detail_Name"] as? String
                    self.Route.text = json[0]["SDP"] as? String
                    self.Joint_Work.text = json[0]["jgch"] as? String
                    self.MeetTime.text = json[0]["StartOrder_Time"] as? String
                    self.OrderTime.text = json[0]["EndOrder_Time"] as? String
                    self.Remark.text = json[0]["Activity_Remarks"] as? String
                                               
                    self.objcalls = json
                    self.PrimayOrderViewTB.reloadData()
                    self.OrderTB.reloadData()
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    @IBAction func EditButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbPrimaryOrder") as! PrimaryOrder
        viewController.setViewControllers([myDyPln], animated: false)
        UIApplication.shared.windows.first?.rootViewController = viewController
    }
    
    
    @IBAction func DeleteButton(_ sender: Any) {
        let apiKey: String = "\(axnDelete)&divisionCode=\(DivCode)%2C&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)"
        let aFormData: [String: Any] = [
            "arc":"\(objcalls[0]["Trans_SlNo"])","amc":"\(objcalls[0]["Trans_Detail_Slno"])","sec":1
        ]
       
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString]
        
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
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }

    }
    
    @IBAction func ViewBT(_ sender: Any) {
    
        
        veselwindow.isHidden=false
    }
    
    @IBAction func CloseWI(_ sender: Any) {
        veselwindow.isHidden=true
    }
    
}
