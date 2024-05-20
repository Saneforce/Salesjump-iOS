//
//  TourPlanApproval.swift
//  SAN SALES
//
//  Created by Naga Prasath on 07/05/24.
//

import Foundation
import UIKit
import Alamofire

class TourPlanApproval : IViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var imgtoList: UIImageView!
    
    @IBOutlet weak var twTourPlanList: UITableView!
    
    
    @IBOutlet weak var twTpApprovalList: UITableView!
    
    
    @IBOutlet weak var vwApprovalList: UIView!
    
    
    
    @IBOutlet weak var lblName: UILabel!
    
    
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnApprove: UIButton!
    
    var sfCode: String = "", stateCode: String = "", divCode: String = "",desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    
    var lstApprovals : [AnyObject] = []
    
    var lstApprovalsView : [AnyObject] = []
    
    var lstHQs: [AnyObject] = []
    
    var selectedTp : AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBack.addTarget(target: self, action: #selector(backVC))
        imgtoList.addTarget(target: self, action: #selector(hideApprovalList))
        getUserDetails()
        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list
        }
        
        fetchTpApprovalList()
        
        btnReject.layer.cornerRadius = 5
        btnReject.layer.masksToBounds = true
        
        btnApprove.layer.cornerRadius = 5
        btnApprove.layer.masksToBounds = true
        
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
    
    
    func fetchTpApprovalList(){
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"vwChkTransApproval&sfCode=\(sfCode)" + "&stateCode=\(stateCode)" + "&rSF=\(sfCode)" + "&divisionCode=\(divCode)" + "&desig=\(desig)" + "&State_Code=\(stateCode)",method: .get,encoding: URLEncoding.httpBody).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                
                print(apiResponse)
                guard let response = apiResponse as? [AnyObject] else{
                    return
                }
                
                self.lstApprovals = response
                self.twTourPlanList.reloadData()
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
        
    }
    
    func fetchTpApprovalListView(year : String,month : String,code : String) {
   // http://fmcg.salesjump.in/server/native_Db_V13.php?State_Code=24&desig=MGR&divisionCode=29%2C&code=SEFMR0040&month=5&rSF=MGR1018&year=2024&axn=vwChkTransApprovalOne&sfCode=MGR1018&stateCode=24
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"vwChkTransApprovalOne&sfCode=\(sfCode)" + "&stateCode=\(stateCode)" + "&rSF=\(sfCode)" + "&divisionCode=\(divCode)" + "&desig=\(desig)" + "&State_Code=\(stateCode)" + "&year=\(year)" + "&code=\(code)" + "&month=\(month)" ,method: .get,parameters: nil,encoding: URLEncoding.httpBody).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                
                print(apiResponse)
                guard let response = apiResponse as? [AnyObject] else{
                    return
                }
                
                print(response)
                
             //   self.lblName.text =
                self.lstApprovalsView = response
                self.twTpApprovalList.reloadData()
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == twTourPlanList {
            return lstApprovals.count
        }
        return lstApprovalsView.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return  UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == twTourPlanList {
            let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            cell.lblText.text = lstApprovals[indexPath.row]["TP_Sf_Name"] as? String ?? ""
            
            let month = String(format: "%@", lstApprovals[indexPath.row]["Tour_Month"] as! CVarArg)
            let year = String(format: "%@", lstApprovals[indexPath.row]["Tour_Year"] as! CVarArg)
            
            let mnth = month.count == 1 ? "0\(month)" : month
            print(mnth)
            cell.lblText2.text = mnth.changeFormat(from: "MM",to: "MMM") + " - " + year
            cell.ViewButton.addTarget(self, action: #selector(viewPlanList(_:)), for: .touchUpInside)
            return cell
        }else{
            
            let workTypeName = lstApprovalsView[indexPath.row]["Worktype_Name_B"] as? String ?? ""
            
            
            if workTypeName.contains("Field Work") || workTypeName.contains("FieldWork") || workTypeName.contains("Fieldwork"){
                let cell:TourPlanApprovalListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TourPlanApprovalListTableViewCell
                cell.lblDate.text = lstApprovalsView[indexPath.row]["Tour_Date"] as? String ?? ""
                cell.lblWorkTypeName.text = lstApprovalsView[indexPath.row]["Worktype_Name_B"] as? String ?? ""
                
                cell.lblWorkTypeName.textColor = UIColor.green
    
                let selectedHQ = lstHQs.filter{(String(format: "%@", $0["id"] as! CVarArg)) == (lstApprovalsView[indexPath.row]["HQ_Code"] as? String ?? "")}
                
                if !selectedHQ.isEmpty{
                    cell.lblHeadquarters.text = lstHQs.first?["Name"] as? String ?? ""
                }else{
                    cell.lblHeadquarters.text = ""
                }
                
                let routes = lstApprovalsView[indexPath.row]["Territory_Code1"] as? String ?? ""
                let jointWorks = lstApprovalsView[indexPath.row]["JointWork_Name1"] as? String ?? ""
                
                
                
                cell.lblDistributor.text = lstApprovalsView[indexPath.row]["Worked_With_SF_Name"] as? String ?? ""
                cell.lblJointWork.text = jointWorks.isEmpty ? "" : jointWorks.replacingOccurrences(of: "$$", with: ",")

                
                cell.lblRoutes.text = routes.isEmpty ? "" : routes.replacingOccurrences(of: "$$", with: ",")
                cell.lblPob.text = lstApprovalsView[indexPath.row]["TPOB"] as? String ?? "00"
                cell.lblSob.text = lstApprovalsView[indexPath.row]["TSOB"] as? String ?? "00"
                cell.lblRemarks.text = lstApprovalsView[indexPath.row]["Objective"] as? String ?? ""
                let remarks = lstApprovalsView[indexPath.row]["Objective"] as? String ?? ""
                
                cell.layoutIfNeeded()
                return cell
            }else if workTypeName.contains("Distributor") || workTypeName.contains("distributor"){
                let cell:TourPlanApprovalListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TourPlanApprovalListTableViewCell
                cell.lblDate.text = lstApprovalsView[indexPath.row]["Tour_Date"] as? String ?? ""
                cell.lblWorkTypeName.text = lstApprovalsView[indexPath.row]["Worktype_Name_B"] as? String ?? ""
                
                cell.lblWorkTypeName.textColor = UIColor.green
    
                let selectedHQ = lstHQs.filter{(String(format: "%@", $0["id"] as! CVarArg)) == (lstApprovalsView[indexPath.row]["HQ_Code"] as? String ?? "")}
                
                if !selectedHQ.isEmpty{
                    cell.lblHeadquarters.text = lstHQs.first?["Name"] as? String ?? ""
                }else{
                    cell.lblHeadquarters.text = ""
                }
                
                let routes = lstApprovalsView[indexPath.row]["Territory_Code1"] as? String ?? ""
                let jointWorks = lstApprovalsView[indexPath.row]["JointWork_Name1"] as? String ?? ""
                
                
                
                cell.lblDistributor.text = lstApprovalsView[indexPath.row]["Worked_With_SF_Name"] as? String ?? ""
                cell.lblJointWork.text = jointWorks.isEmpty ? "" : jointWorks.replacingOccurrences(of: "$$", with: ",")

                
                cell.lblRoutes.text = routes.isEmpty ? "" : routes.replacingOccurrences(of: "$$", with: ",")
                cell.lblPob.text = ""
                cell.lblSob.text = ""
                cell.lblRemarks.text = lstApprovalsView[indexPath.row]["Objective"] as? String ?? ""
                let remarks = lstApprovalsView[indexPath.row]["Objective"] as? String ?? ""
                
                cell.layoutIfNeeded()
                return cell
            }else {
                let cell:TourPlanApprovalListNonFieldWorkTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TourPlanApprovalListNonFieldWorkTableViewCell
                cell.lblDate.text = lstApprovalsView[indexPath.row]["Tour_Date"] as? String ?? ""
                cell.lblName.text = lstApprovalsView[indexPath.row]["Worktype_Name_B"] as? String ?? ""
                
                cell.lblName.textColor = UIColor.red
                cell.lblRemarks.text = lstApprovalsView[indexPath.row]["Objective"] as? String ?? ""

                
                cell.layoutIfNeeded()
                return cell
            }
            
            
        }
        
    }
    
    
    @IBAction func rejectAction(_ sender: UIButton) {
        
        SelectedData.shared.selectedTp = selectedTp
        let alertview = RejectReasonViewController<Any>()
        alertview.didSelect = { reason in
            
            self.rejectAction(reason: reason as? String ?? "")
            self.dismiss(animated: true)
        }
        alertview.show()
        
    }
    
    
    @IBAction func approveAction(_ sender: UIButton) {
   
        
        let alert = UIAlertController(title: "TP Approval Confirmation", message: "Do you want to Confirm TP Approval?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.approveAction()
            
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
        
    }
    
    func approveAction() {
        
        // http://fmcg.salesjump.in/server/native_Db_V13.php?State_Code=24&desig=MGR&divisionCode=29%2C&code=SEFMR0040&month=5&rSF=MGR1018&year=2024&axn=dcr%2Fsave&sfCode=MGR1018&stateCode=24
        
        let params : Parameters = ["data" : "[{\"TPApproval\":{}}]"]
        
        let month = String(format: "%@", selectedTp["Tour_Month"] as! CVarArg)
        let year = String(format: "%@", selectedTp["Tour_Year"] as! CVarArg)
        let code = String(format: "%@", selectedTp["Sf_Code"] as! CVarArg)
        
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"State_Code=" + self.stateCode+"&rSF=" + sfCode+"&month=\(month)" + "&code=\(code)" + "&stateCode=" + stateCode + "&year=\(year)")
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"State_Code=" + self.stateCode+"&rSF=" + sfCode+"&month=\(month)" + "&code=\(code)" + "&stateCode=" + stateCode + "&year=\(year)",method: .post,parameters: params,encoding: URLEncoding.httpBody).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result{
                
            case .success(let value):
                print(value)
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                
                print(apiResponse)
                Toast.show(message: "Tour Plan Approved Successfully", controller: self)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    func rejectAction(reason : String) {
        let params : Parameters = ["data" : "[{\"TPReject\":{\"reason\":\"\'\(reason)\'\"}}]"]
        
        
        let month = String(format: "%@", selectedTp["Tour_Month"] as! CVarArg)
        let year = String(format: "%@", selectedTp["Tour_Year"] as! CVarArg)
        let code = String(format: "%@", selectedTp["Sf_Code"] as! CVarArg)
        
        
        print(params)
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"State_Code=" + self.stateCode+"&rSF=" + sfCode+"&month=\(month)" + "&code=\(code)" + "&stateCode=" + stateCode + "&year=\(year)")
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"State_Code=" + self.stateCode+"&rSF=" + sfCode+"&month=\(month)" + "&code=\(code)" + "&stateCode=" + stateCode + "&year=\(year)",method: .post,parameters: params,encoding: URLEncoding.httpBody).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result{
                
            case .success(let value):
                print(value)
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                
                print(apiResponse)
                Toast.show(message: "Tour Plan Rejected Successfully", controller: self)
              //  self.dismiss(animated: true)
                
                self.navigationController?.popViewController(animated: true)
               // self.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    @objc func viewPlanList(_ sender : UIButton) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.twTourPlanList)
        guard let indexPath = self.twTourPlanList.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        self.vwApprovalList.isHidden = false
        
        let month = String(format: "%@", lstApprovals[indexPath.row]["Tour_Month"] as! CVarArg)
        let year = String(format: "%@", lstApprovals[indexPath.row]["Tour_Year"] as! CVarArg)
        let code = String(format: "%@", lstApprovals[indexPath.row]["Sf_Code"] as! CVarArg)
        
        self.selectedTp = lstApprovals[indexPath.row]
        self.lblName.text = lstApprovals[indexPath.row]["TP_Sf_Name"] as? String ?? ""
        self.fetchTpApprovalListView(year: year, month: month, code: code)
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func hideApprovalList() {
        self.vwApprovalList.isHidden = true
        self.fetchTpApprovalList()
    }
    
}




class TourPlanApprovalListTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWorkTypeName: UILabel!
    
    @IBOutlet weak var lblHeadquarters: UILabel!
    @IBOutlet weak var lblRoutes: UILabel!
    
    @IBOutlet weak var lblPob: UILabel!
    @IBOutlet weak var lblSob: UILabel!
    @IBOutlet weak var lblJointWork: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!
    
    
    @IBOutlet weak var lblDistributor: UILabel!
    
    @IBOutlet weak var lblTitleRemarks: UILabel!
    @IBOutlet weak var lblTitleJointWork: UILabel!
    
    
    @IBOutlet weak var lblTitleHeadquarters: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class TourPlanApprovalListNonFieldWorkTableViewCell : UITableViewCell {
    
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var lblName: UILabel!
    
    
    @IBOutlet weak var lblRemarks: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
