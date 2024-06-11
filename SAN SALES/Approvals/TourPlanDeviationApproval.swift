//
//  TourPlanDeviationApproval.swift
//  SAN SALES
//
//  Created by Naga Prasath on 05/06/24.
//

import UIKit
import Alamofire

class TourPlanDeviationApproval : IViewController, UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var twDeviationList: UITableView!
    
    var sfCode: String = "", stateCode: String = "", divCode: String = "",desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    
    var json : JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBack.addTarget(target: self, action: #selector(backVC))
        getUserDetails()
        
        fetchDeviationList()
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
    
    
    func fetchDeviationList() {
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"vwChkDevApproval&sfCode=\(sfCode)&year=All&rSF=\(sfCode)&month=All&divisionCode=\(divCode)&State_Code=\(stateCode)",method: .get,parameters: nil).validate(statusCode: 200..<209).responseData { AFData in
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                do {
                    let json = try JSON(data: AFData.data!)
                    self.json = json
                    
                    if self.json?.dev.count == 0 {
                        Toast.show(message: "No data Available", controller: self)
                    }
                    
                    self.twDeviationList.reloadData()
                    print(json)
                }catch{
                    print("Error")
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
        
    }
    
    func rejectApi(slNo : String ,code : String, reason : String) {
        
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"DevReject&sfCode=\(code)&rejectionReason=\(reason)&slno=\(slNo)&State_Code=\(stateCode)&divisionCode=\(divCode)&rSF=\(sfCode)")
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"DevReject&sfCode=\(code)&rejectionReason=\(reason)&slno=\(slNo)&State_Code=\(stateCode)&divisionCode=\(divCode)&rSF=\(sfCode)",method: .get,parameters: nil).validate(statusCode: 200..<209).responseData { AFData in
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                do {
                    let json = try JSON(data: AFData.data!)
                    print(json)
                    Toast.show(message: "Rejected Successfully", controller: self)
                    self.fetchDeviationList()
                }catch {
                    print("Error")
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
        

    }
    
    func approveApi(slNo : String ,code : String) {
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"DevApproval&sfCode=\(code)&rejectionReason=&slno=\(slNo)&State_Code=\(stateCode)&divisionCode=\(divCode)&rSF=\(sfCode)",method: .get,parameters: nil).validate(statusCode: 200..<209).responseData { AFData in
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                do {
                    let json = try JSON(data: AFData.data!)
                    print(json)
                    Toast.show(message: "Deviation Approved", controller: self)
                    self.fetchDeviationList()
                }catch {
                    print("Error")
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.json?.dev.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TourPlanDeviationApprovalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TourPlanDeviationApprovalTableViewCell
        cell.lblDate.text = self.json?.dev[indexPath.row].missed_date.string
        cell.lblName.text = self.json?.dev[indexPath.row].sf_name.string
        cell.lblReason.text = self.json?.dev[indexPath.row].reason.string
        cell.btnReject.addTarget(self, action: #selector(rejectAction(_:)), for: .touchUpInside)
        cell.btnApprove.addTarget(self, action: #selector(approveAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func rejectAction(_ sender : UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: self.twDeviationList)
        guard let indexPath = self.twDeviationList.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        let alertview = RejectReasonViewController<Any>()
        alertview.didSelect = { reason in
            print(reason)
            let slNo = self.json?.dev[indexPath.row].sl_no.int ?? 0
            
            let code = self.json?.dev[indexPath.row].sf_code.string
            
            self.rejectApi(slNo: "\(slNo)", code: code ?? "", reason: reason as? String ?? "")
            self.dismiss(animated: true)
        }
        alertview.show()
        

        
    }
    
    @objc func approveAction(_ sender : UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: self.twDeviationList)
        guard let indexPath = self.twDeviationList.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        let slNo = self.json?.dev[indexPath.row].sl_no.int ?? 0
        
        let code = self.json?.dev[indexPath.row].sf_code.string
        
        self.approveApi(slNo: "\(slNo)", code: code ?? "")
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}




class TourPlanDeviationApprovalTableViewCell : UITableViewCell {
    
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    
    
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnApprove: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}




