//
//  Leave Approval.swift
//  SAN SALES
//
//  Created by Anbu j on 16/08/24.
//

import UIKit
import Alamofire
class Leave_Approval: IViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var BackBT: UIImageView!
    @IBOutlet weak var Leave_View_TB: UITableView!
    @IBOutlet weak var Approv_View: UIView!
    @IBOutlet weak var Apr_Close_BT: UIImageView!
    @IBOutlet weak var Approve: UIButton!
    @IBOutlet weak var Reject: UIButton!
    @IBOutlet weak var Resign_View_Hight: NSLayoutConstraint!
    
    @IBOutlet weak var Reject_Reason_View: UIView!
    
    @IBOutlet weak var Reject_reason_hig: NSLayoutConstraint!
    
    
    @IBOutlet weak var Reject_bt_text: UIButton!
    
    struct mnuItem: Any {
        let Field_Force_Name:String
        let Emp_Code:String
        let HQ:String
        let Designation:String
        let Reason:String
        let Leave_Typ:String
        let From_Date:String
        let To_Date:String
        let Laeve_Days:String
        let Leave_Option:String
        let Leave_Id:String
        let Sf_Code:String
    }
    var LeveDet:[mnuItem]=[]
    let cardViewInstance = CardViewdata()
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String=""
    let LocalStoreage = UserDefaults.standard
    
    // View Detils
    @IBOutlet weak var Field_Force_Name: UILabel!
    @IBOutlet weak var Emp_Code: UILabel!
    @IBOutlet weak var HQ: UILabel!
    @IBOutlet weak var Designation: UILabel!
    @IBOutlet weak var Reason: UILabel!
    @IBOutlet weak var Leave_Typ: UILabel!
    @IBOutlet weak var From_Date: UILabel!
    @IBOutlet weak var To_Date: UILabel!
    @IBOutlet weak var Laeve_Days: UILabel!
    @IBOutlet weak var Leave_Option: UILabel!
    @IBOutlet weak var Text_Reason: UITextView!
    
    
    var from_Date:String = ""
    var to_Date:  String = ""
    var No_of_Days: String = ""
    var reason: String = ""
    var Sf_Code: String = ""
    var Leave_ID: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        
        Leave_View_TB.delegate = self
        Leave_View_TB.dataSource = self
        cardViewInstance.styleSummaryView(Approve)
        cardViewInstance.styleSummaryView(Reject)
        BackBT.addTarget(target: self, action: #selector(GotoHome))
        Apr_Close_BT.addTarget(target: self, action: #selector(Close_apr_view))
        Reject.addTarget(target: self, action: #selector(Reject_leave))
        Approve.addTarget(target: self, action: #selector(Approv_leave))
        vwLeave()
    }
    func getUserDetails(){
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        print(prettyJsonData)
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        StateCode = prettyJsonData["State_Code"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        Desig=prettyJsonData["desigCode"] as? String ?? ""
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LeveDet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = LeveDet[indexPath.row].Field_Force_Name+"(\(LeveDet[indexPath.row].HQ))"
        cell.lblText2.text = LeveDet[indexPath.row].Laeve_Days
        cell.Leave_Apr.tag = indexPath.row
        cell.Leave_Apr.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        cardViewInstance.styleSummaryView(cell.Leave_Apr)
        return cell
    }
    
    @objc func buttonClicked(_ sender: UIButton){
        self.ShowLoading(Message: "Loading...")
        Text_Reason.text = ""
        Reject_Reason_View.isHidden = true
        Reject_reason_hig.constant = 0
        Resign_View_Hight.constant = 22
        Field_Force_Name.text = LeveDet[sender.tag].Field_Force_Name
        Emp_Code.text = LeveDet[sender.tag].Emp_Code
        HQ.text = LeveDet[sender.tag].HQ
        Designation.text = LeveDet[sender.tag].Designation
        Reason.text = LeveDet[sender.tag].Reason
        Leave_Typ.text = LeveDet[sender.tag].Leave_Typ
        From_Date.text = LeveDet[sender.tag].From_Date
        To_Date.text = LeveDet[sender.tag].To_Date
        Laeve_Days.text = LeveDet[sender.tag].Laeve_Days
        Leave_Option.text = LeveDet[sender.tag].Leave_Option
        // Set From and To date
        from_Date = LeveDet[sender.tag].From_Date
        to_Date = LeveDet[sender.tag].To_Date
        No_of_Days = LeveDet[sender.tag].Laeve_Days
        Sf_Code = LeveDet[sender.tag].Sf_Code
        Leave_ID = LeveDet[sender.tag].Leave_Id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
            Reject_bt_text.setTitle("Reject", for: .normal)
            Resign_View_Hight.constant = Reason.layer.frame.height
            Approv_View.isHidden = false
            self.LoadingDismiss()
        }
    }
    func vwLeave(){
        LeveDet.removeAll()
        self.ShowLoading(Message: "Loading...")
        let axn = "vwLeave"
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&desig=\(UserSetup.shared.Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
         AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
             AFdata in
             switch AFdata.result
             {
                 
             case .success(let value):
                 print(value)
                 let values = value
                 if let json = value as? [AnyObject] {
                     for data in json{
                         let FieldForceName = data["FieldForceName"] as? String ?? ""
                         let EmpCode = data["EmpCode"] as? String ?? ""
                         let HQ = data["HQ"] as? String ?? ""
                         let Designation = data["Designation"] as? String ?? ""
                         let Reason = data["Reason"] as? String ?? ""
                         let Leave_Name = data["Leave_Name"] as? String ?? ""
                         let From_Date = data["From_Date"] as? String ?? ""
                         let To_Date = data["To_Date"] as? String ?? ""
                         let LeaveDays = String(data["LeaveDays"] as? Double ?? 0)
                         let leaveoption = data["leaveoption"] as? String ?? ""
                         let Leave_Id = String(data["Leave_Id"] as? Int ?? 0)
                         let Sf_Code = data["Sf_Code"] as? String ?? ""
                         LeveDet.append(mnuItem(Field_Force_Name: FieldForceName, Emp_Code: EmpCode, HQ: HQ, Designation: Designation, Reason: Reason, Leave_Typ: Leave_Name, From_Date: From_Date, To_Date: To_Date, Laeve_Days: LeaveDays, Leave_Option: leaveoption, Leave_Id: Leave_Id, Sf_Code: Sf_Code))
                     }
                     Leave_View_TB.reloadData()
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                         self.LoadingDismiss()
                         
                         if LeveDet.isEmpty{
                             Toast.show(message: "No Data to Show")
                         }
                         
                     }
                 }
             case .failure(let error):
                 Toast.show(message: error.errorDescription!)
             }
         }
    }
    
    
    @objc private func Reject_leave(){
        
        if  Reject_Reason_View.isHidden == true{
            Reject_Reason_View.isHidden = false
            Reject_reason_hig.constant = 90
            Reject_bt_text.setTitle("Send for Field Force", for: .normal)
            return
        }
        
        if Text_Reason.text.isEmpty{
            Toast.show(message: "Enter Rejection Reason.")
            return
        }
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to reject the leave?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [self] _ in
            LeaveReject()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    
    func LeaveReject(){
        reason = Text_Reason.text
        let jsonString = "[{\"LeaveReject\":{\"From_Date\":\"\(from_Date)\",\"To_Date\":\"\(to_Date)\",\"No_of_Days\": \"\(No_of_Days)\",\"reason\":\"'\(reason)'\",\"Sf_Code\":\"\(Sf_Code)\"}}]"
        let params: Parameters = [
            "data": jsonString
        ]
        print(params)
        let axn = "dcr/save"
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&desig=\(UserSetup.shared.Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&leaveid=\(Leave_ID)&sfCode=\(SFCode)&stateCode=\(StateCode)"
        
        print(apiKey)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result
            {
            case .success(let value):
                print(value)
                let values = value
                if let json = value as? [AnyObject] {
                }
                Toast.show(message: "Leave reject successfully.")
                vwLeave()
                Approv_View.isHidden = true
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
    }
    @objc private func Approv_leave(){
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to approve the leave?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [self] _ in
            LeaveApproval()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    func LeaveApproval(){
        let jsonString = "[{\"LeaveApproval\":{\"From_Date\":\"\(from_Date)\",\"To_Date\":\"\(to_Date)\",\"No_of_Days\": \"\(No_of_Days)\",\"Sf_Code\":\"\(Sf_Code)\"}}]"
        let params: Parameters = [
            "data": jsonString
        ]
        print(params)
        let axn = "dcr/save"
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&desig=\(UserSetup.shared.Desig)&divisionCod=\(DivCode)&rSF=\(SFCode)&leaveid=\(Leave_ID)&sfCode=\(SFCode)&stateCode=\(StateCode)"
        print(apiKey)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result
            {
                
            case .success(let value):
                print(value)
                let values = value
                if let json = value as? [AnyObject] {
                }
                Toast.show(message: "Leave approved successfully.")
                vwLeave()
                Approv_View.isHidden = true
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
    }
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func Close_apr_view() {
        Approv_View.isHidden = true
    }
}
