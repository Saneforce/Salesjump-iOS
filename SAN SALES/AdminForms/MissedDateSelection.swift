//
//  MissedDateSelection.swift
//  SAN SALES
//
//  Created by Naga Prasath on 13/06/24.
//

import Foundation
import UIKit
import Alamofire

typealias SyncCallBack = (_ status: Bool) -> Void
class MissedDateSelection : IViewController{
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var lblDate: LabelSelect!
    @IBOutlet weak var lblWorkType: LabelSelect!
    
    @IBOutlet weak var txtRemarks: UITextView!
    
    @IBOutlet weak var vwOrderList: UIView!
    
    
    @IBOutlet weak var vwOrderListHeightConstraints: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var lblSecondaryOrder: UILabel!
    
    @IBOutlet weak var lblPrimaryOrder: UILabel!
    
    @IBOutlet weak var lblSecondaryOrderCount: UILabel!
    @IBOutlet weak var lblPrimaryOrderCount: UILabel!
    
    
    
    var secondaryOrderList = [RetailerList](){
        didSet{
            self.lblSecondaryOrderCount.text = secondaryOrderList.count.description
        }
    }
    var primaryOrderList = [RetailerList](){
        didSet{
            self.lblPrimaryOrderCount.text = primaryOrderList.count.description
        }
    }
    
    
    var lstWType: [AnyObject] = []
    var lstDates: [AnyObject] = []
    
    var json : JSON!
    
    var sfCode = "",divCode = "",desig = "", sfName = "",stateCode = ""
    let LocalStoreage = UserDefaults.standard
    
    
    var selectedWorktype : AnyObject! {
        didSet {
            self.lblWorkType.text = selectedWorktype?["name"] as? String
        }
    }
    
    var selectedDate : AnyObject! {
        didSet {
            self.lblDate.text = selectedDate["name"] as? String
            
            self.selectedWorktype = nil
            self.lblWorkType.text = "Select the WorkType"
            self.vwOrderListHeightConstraints.constant = 0
            self.vwOrderList.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        getUserDetails()
        fetchMissedDate()
        
        lblDate.addTarget(target: self, action: #selector(dateAction))
        lblWorkType.addTarget(target: self, action: #selector(workTypeAction))
        
        vwOrderListHeightConstraints.constant = 0
        vwOrderList.isHidden = true
        
        txtRemarks.delegate = self
        txtRemarks.text = "Enter the remarks"
        txtRemarks.textColor = .lightGray
        
        if let WorkTypeData = LocalStoreage.string(forKey: "Worktype_Master"),
           let list = GlobalFunc.convertToDictionary(text:  WorkTypeData) as? [AnyObject] {
            lstWType = list
        }
        
        self.lblPrimaryOrder.text = UserSetup.shared.PrimaryCaption
        self.lblSecondaryOrder.text = UserSetup.shared.SecondaryCaption
        
    }
    
    deinit {
        print("Missed Date Deallocted")
    }
    
    func getUserDetails(){
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        sfCode = prettyJsonData["sfCode"] as? String ?? ""
        stateCode = prettyJsonData["State_Code"] as? String ?? ""
        divCode = prettyJsonData["divisionCode"] as? String ?? ""
        desig=prettyJsonData["desigCode"] as? String ?? ""
    }
    
    
    func fetchMissedDate() {
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"get/misseddates&sfCode=\(sfCode)&rSF=\(sfCode)&State_Code=\(stateCode)&divisionCode=\(divCode)").validate(statusCode: 200..<209).responseData { AFData in
            switch AFData.result {
                
            case .success(let value):
                print(value)
                    
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data!)
                
                guard let response = apiResponse as? AnyObject else {
                    return
                }
                guard let dateArray = response["data"] as? [AnyObject] else{
                    return
                }
                print(response)
                self.lstDates = dateArray

                
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
        
        
    }
    
    
    
    @IBAction func secondaryAction(_ sender: UIButton) {
        
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMissedDateRouteSelection") as!  MissedDateRouteSelection
        vc.isFromSecondary = true
        vc.selectedDate = self.selectedDate
        vc.selectedWorktype = self.selectedWorktype
        vc.selectedList = self.secondaryOrderList
        vc.missedDateSubmit = { products in
            print(products)
            
            self.secondaryOrderList = products
            self.navigationController?.popViewController(animated: true)
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func primaryAction(_ sender: UIButton) {
        
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMissedDateRouteSelection") as!  MissedDateRouteSelection
        vc.isFromSecondary = false
        vc.selectedDate = self.selectedDate
        vc.selectedWorktype = self.selectedWorktype
        vc.selectedList = self.primaryOrderList
        vc.missedDateSubmit = { products in
            print(products)
            
            self.primaryOrderList = products
            self.navigationController?.popViewController(animated: true)
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func finalSubmit(_ sender: UIButton) {
        if self.selectedDate == nil {
            Toast.show(message: "Please Select Missed Date", controller: self)
            return
        }
        
        if self.selectedWorktype == nil {
            Toast.show(message: "Please Select WorkType", controller: self)
            return
        }
        
        if self.secondaryOrderList.isEmpty && self.primaryOrderList.isEmpty {
            Toast.show(message: "Please Select at least One Order", controller: self)
            return
        }
        
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit order?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            
            
            let workTypeCode = self.selectedWorktype?["id"] as? Int ?? 0
            let fwflg = self.selectedWorktype?["FWFlg"] as? String ?? ""
            let workTypeName = self.selectedWorktype?["name"] as? String ?? ""
            
            print(fwflg)
            print(workTypeCode)
            print(workTypeName)
            
            if fwflg == "F" {
                
                if self.secondaryOrderList.count == 0 && self.primaryOrderList.count == 0 {
                    Toast.show(message: "Please Select Atleast one Order", controller: self)
                    return
                }
                
                self.finalSubmit()
            }else {
                self.finalSubmitNonFieldwork()
            }
            
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
        
        
        
        
    }
    
    func finalSubmit() {
        
        let secondaryOrder = self.secondaryOrderList.map{["params": $0.params ?? ""]}
        
        let primaryOrder = self.primaryOrderList.map{["params": $0.params ?? ""]}
        
        let orders = secondaryOrder + primaryOrder
        
        print(secondaryOrder)
        UserDefaults.standard.set(orders, forKey: "MissedDate")
        UserDefaults.standard.synchronize()
        
        self.submit()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            GlobalFunc.movetoHomePage()
        }
       // GlobalFunc.movetoHomePage()
    }
    
    func submit(){
        DispatchQueue.global(qos: .background).async {
            let outboxes = UserDefaults.standard.object(forKey: "MissedDate") as! [[String : Any]]
            guard let outbox = outboxes.first else{
                return
            }
            self.OrderOutbox(data: outbox) { (_) in
                self.submit()
            }
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
            }
        }
    }
    
    func OrderOutbox(data:[String : Any],callback:@escaping SyncCallBack) {
        let url =  APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.divCode + "&rSF=" + self.sfCode + "&sfCode=" + self.sfCode
        let paramStr = data["params"] as? String ?? ""
        
        let params: Parameters = [ "data": paramStr ]
        
        print(url)
        print(params)
        AF.request(url,method: .post, parameters: params).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                let json = try? JSON(data: AFData.data!)
                print(json as Any)
                var datas = UserDefaults.standard.object(forKey: "MissedDate") as! [[String : Any]]
                if !datas.isEmpty {
                    datas.removeFirst()
                    UserDefaults.standard.set(datas, forKey: "MissedDate")
                    callback(true)
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    func finalSubmitNonFieldwork() {
        
        let workTypeCode = self.selectedWorktype?["id"] as? Int ?? 0
        let fwflg = selectedWorktype["FWFlg"] as? String ?? ""
        let workTypeName = selectedWorktype["name"] as? String ?? ""
        
        let date = (self.selectedDate["name"] as? String ?? "") + " 00:00:00"
        
        let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"\'\(workTypeCode)\'\",\"Town_code\":\"\'\'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'\(date)\'\",\"workTypFlag_Missed\":\"\(fwflg)\",\"mydayplan\":1,\"mypln_town\":\"\'Missed Entry\'\",\"mypln_town_id\":\"\'Missed Entry'\",\"Daywise_Remarks\":\"\'\'\",\"eKey\":\"\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"\":\"\'\(sfCode)\'\"}},{\"Activity_Sample_Report\":[]},{\"Trans_Order_Details\":[]},{\"Activity_Input_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]}]"
        
        let params: Parameters = [ "data": jsonString ]
        
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr%2Fsave&divisionCode=\(divCode)&sfCode=\(sfCode)&desig=\(self.desig)")
        print(params)
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr%2Fsave&divisionCode=\(divCode)&sfCode=\(sfCode)&desig=\(self.desig)",method: .post,parameters: params).validate(statusCode: 200..<209).responseData { AFData in
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                do {
                    let json = try JSON(data: AFData.data!)
                    print(json)
                }catch {
                    print("Error")
                }
                
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    
    
    @objc private func dateAction() {
        print(self.lstDates)
        let dateVC = ItemViewController(items: lstDates, configure: { (Cell : SingleSelectionTableViewCell, date) in
            Cell.textLabel?.text = date["name"] as? String
        })
        dateVC.title = "Select the Missed Date"
        dateVC.didSelect = { selectedDate in
            print(selectedDate)
            self.navigationController?.popViewController(animated: true)
            
            if self.selectedWorktype != nil {
                let alert = UIAlertController(title: "Confirm Clear", message: "Do you want to Clear Data?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                    self.selectedDate = selectedDate
                    return
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                    return
                })
                self.present(alert, animated: true)
            }else {
                self.selectedDate = selectedDate
            }
            
            
        }
        self.navigationController?.pushViewController(dateVC, animated: true)
    }
    
    @objc private func workTypeAction() {
        if self.selectedDate == nil {
            Toast.show(message: "Please Select Missed Date", controller: self)
            return
        }
        let worktypeVC = ItemViewController(items: lstWType, configure: { (Cell : SingleSelectionTableViewCell, worktype) in
            Cell.textLabel?.text = worktype["name"] as? String
        })
        worktypeVC.title = "Select the Worktype"
        worktypeVC.didSelect = { selectedWorktype in
            print(selectedWorktype)
            self.selectedWorktype = selectedWorktype
            
            let fwflg = selectedWorktype["FWFlg"] as? String ?? ""
            
            switch fwflg{
                case "F":
                    self.vwOrderListHeightConstraints.constant = 120
                    self.vwOrderList.isHidden = false
                default:
                    self.vwOrderListHeightConstraints.constant = 0
                    self.vwOrderList.isHidden = true
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(worktypeVC, animated: true)
    }
    
    @objc func backVC() {
        let alert = UIAlertController(title: "Confirm Exit", message: "Do you want to Close?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
}


extension MissedDateSelection: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter the remarks"
            textView.textColor = UIColor.lightGray
        }
    }
}
