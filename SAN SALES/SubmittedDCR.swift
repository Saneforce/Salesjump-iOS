//
//  SubmittedDCR.swift
//  SAN SALES
//
//  Created by San eforce on 23/05/23.
//

import UIKit
import Alamofire
import SwiftUI

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
    
    let axn="table/list"
    let axnsec = "get/SecCallDets"
    let axnview = "get/SecOrderDets"
    let axnvw = "get/vwOrderDetails"
    let axnproducts = "dcr/updateProducts"
    let axndelet1 = "deleteEntry"
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String=""
    
    let LocalStoreage = UserDefaults.standard
    var objcalls: [AnyObject]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        SelectSecondaryorder()
        SelectSecondaryorder2()
        submittedDCRTB.delegate=self
        submittedDCRTB.dataSource=self
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if let tableView = EditTB {return objcalls.count}
        return objcalls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        let item: [String: Any] = objcalls[indexPath.row] as! [String : Any]
        cell.RetailerName?.text = item["Trans_Detail_Name"] as? String
        cell.DistributerName?.text = item["Trans_Detail_Slno"] as? String
        cell.Rou?.text = item["SDP_Name"] as? String
        cell.MeetTime?.text = item["Order_In_Time"] as? String
        cell.OrderTime?.text = item["Order_Out_Time"] as? String
            
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
    func SelectSecondaryorder2(){
        let apiKey: String = "\(axnsec)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)&trans_SlNo=SEF3-309"
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
                    self.objcalls = json
                    self.Slno.text=String(format: "%@", json[0]["Trans_SlNo"] as! String)
                    self.Product.text=String(format: "%@", json[0]["Trans_Detail_Name"] as! String)
                    self.Ordervalue.text=String(format: "%@", json[0]["finalNetAmnt"] as! String)
                    self.submittedDCRTB.reloadData()
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    @IBAction func ViewBT(_ sender: Any) {
        let apiKey: String = "\(axnvw)&State_Code=\(StateCode)&divisionCode=\(DivCode)&sfCode=\(SFCode)&DCR_Code=SEF3-1261"
        
        let aFormData: [String: Any] = [
            "orderBy":"[\"name asc\"]","desig":"mgr"
        ]
        //DCR_Code=SEF3-1264    &State_Code=12&desig=MR&divisionCode=4%2C&rSF=MR3533&axn=get%2FvwOrderDetails&sfCode=MR3533&stateCode=12
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
                    self.objcalls = json
                    self.submittedDCRTB.reloadData()
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
        Viewwindow.isHidden=false
    }
    @IBAction func Edit(_ sender: Any) {
        let apiKey: String = "\(axnview)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)&DCR_Code=SEF3-1268 "
       
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

                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
        
        veselwindow.isHidden=false
    }
    
    @IBAction func EditSecondaryordervalue(_ sender: Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbSecondaryOrder") as! SecondaryOrder
        viewController.setViewControllers([myDyPln], animated: false)
        UIApplication.shared.windows.first?.rootViewController = viewController
    }
    
    @IBAction func DeleteBT(_ sender: Any) {
        let apiKey: String = "\(axndelet1)&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCod=\(StateCode)"
        
        let aFormData: [String: Any] = [
            "arc":"SEF3-309","amc":"MR4126-23-24-SO-857","sec":1,"custId":"114728"
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
    }
    
    @IBAction func clswindow(_ sender: Any) {
        veselwindow.isHidden=true
        Viewwindow.isHidden=true
    }
    
    }


