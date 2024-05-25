//
//  TourPlanViewDateWise.swift
//  SAN SALES
//
//  Created by Naga Prasath on 13/05/24.
//

import Foundation
import UIKit
import Alamofire

class TourPlanViewDateWise : IViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    
    @IBOutlet weak var twTpList: UITableView!
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var vwDate: UIView!
    
    
    var sfCode: String = "", stateCode: String = "", divCode: String = "",desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    
    var lstTp : [AnyObject] = []
    var lstHQs : [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        
        getUserDetails()
        
        self.lblDate.text = Date().toString(format: "dd MMM yyyy")
        fetchTp(date: Date().toString(format: "yyyy-MM-dd"))
        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list
        }
        
        vwDate.layer.borderWidth = 2
        vwDate.layer.borderColor = CGColor(red: 54.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 0.6)
        vwDate.layer.masksToBounds = true
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
    
    func fetchTp(date : String) {
        
        let jsonString = "{\"sfCode\":\"\(sfCode)\",\"tpDate\":\"\(date)\"}"
        
        let params : Parameters = ["data" : jsonString ]
        
        self.ShowLoading(Message: "Loading ...")
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"tpviewdt&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"&rSF=" + sfCode + "&stateCode=" + stateCode,method: .post , parameters: params,encoding: URLEncoding.httpBody,headers: nil).validate(statusCode: 200..<209).responseData { AFData in
            self.LoadingDismiss()
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                guard let response = apiResponse as? [AnyObject] else{
                    return
                }
                self.lstTp = response
                self.twTpList.reloadData()
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    
    
    @IBAction func dateAction(_ sender: UIButton) {
        
        let alertView = CalendarViewController()
        alertView.didSelect = { date in
            print(date)
            self.lblDate.text = date.changeFormat(from: "yyyy-MM-dd",to: "dd MMM yyyy")
            self.fetchTp(date: date)
            self.dismiss(animated: true)
        }
        alertView.show()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstTp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let workTypeName = lstTp[indexPath.row]["wtype"] as? String ?? ""
        
        
        if workTypeName.contains("Field Work") || workTypeName.contains("FieldWork") || workTypeName.contains("Fieldwork"){
            let cell:TourPlanViewDateWiseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TourPlanViewDateWiseTableViewCell
            cell.lblDate.text = lstTp[indexPath.row]["date"] as? String ?? ""
            cell.lblWorkType.text = lstTp[indexPath.row]["wtype"] as? String ?? ""
            cell.lblName.text = lstTp[indexPath.row]["sfName"] as? String ?? ""
            cell.lblWorkType.textColor = UIColor.systemGreen

            let selectedHQ = lstHQs.filter{(String(format: "%@", $0["id"] as! CVarArg)) == (lstTp[indexPath.row]["HQ_Code"] as? String ?? "")}
            
            if !selectedHQ.isEmpty{
                cell.lblHeadquarters.text = lstHQs.first?["name"] as? String ?? ""
            }else{
                cell.lblHeadquarters.text = ""
            }
            
            let routes = lstTp[indexPath.row]["towns"] as? String ?? ""
            let jointWorks = lstTp[indexPath.row]["JointWork_Name1"] as? String ?? ""
            
            
            
            cell.lblDistributor.text = lstTp[indexPath.row]["distributor"] as? String ?? ""
            cell.lblJointWorks.text = jointWorks.isEmpty ? "" : jointWorks.replacingOccurrences(of: "$$", with: ",")

            
            cell.lblRoutes.text = routes.isEmpty ? "" : routes.replacingOccurrences(of: "$$", with: ",")
            cell.lblPob.text = lstTp[indexPath.row]["pob"] as? String ?? "00"
            cell.lblSob.text = lstTp[indexPath.row]["sob"] as? String ?? "00"
            cell.lblRemarks.text = lstTp[indexPath.row]["remark"] as? String ?? ""
            
            cell.layoutIfNeeded()
            return cell
        }else if workTypeName.contains("Distributor") || workTypeName.contains("distributor"){
            let cell:TourPlanViewDateWiseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TourPlanViewDateWiseTableViewCell
            cell.lblDate.text = lstTp[indexPath.row]["date"] as? String ?? ""
            cell.lblWorkType.text = lstTp[indexPath.row]["wtype"] as? String ?? ""
            cell.lblName.text = lstTp[indexPath.row]["sfName"] as? String ?? ""
            cell.lblWorkType.textColor = UIColor.blue

            let selectedHQ = lstHQs.filter{(String(format: "%@", $0["id"] as! CVarArg)) == (lstTp[indexPath.row]["HQ_Code"] as? String ?? "")}
            
            if !selectedHQ.isEmpty{
                cell.lblHeadquarters.text = lstHQs.first?["name"] as? String ?? ""
            }else{
                cell.lblHeadquarters.text = ""
            }
            
            let routes = lstTp[indexPath.row]["towns"] as? String ?? ""
            let jointWorks = lstTp[indexPath.row]["JointWork_Name1"] as? String ?? ""
            
            
            
            cell.lblDistributor.text = lstTp[indexPath.row]["distributor"] as? String ?? ""
            cell.lblJointWorks.text = jointWorks.isEmpty ? "" : jointWorks.replacingOccurrences(of: "$$", with: ",")

            
            cell.lblRoutes.text = routes.isEmpty ? "" : routes.replacingOccurrences(of: "$$", with: ",")
            cell.lblPob.text = ""
            cell.lblSob.text = ""
            cell.lblRemarks.text = lstTp[indexPath.row]["remark"] as? String ?? ""
            
            cell.layoutIfNeeded()
            return cell
        }else {
            let cell:TourPlanViewDateWiseNonFieldWorkTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TourPlanViewDateWiseNonFieldWorkTableViewCell
            cell.lblDate.text = lstTp[indexPath.row]["date"] as? String ?? ""
            cell.lblWorkType.text = lstTp[indexPath.row]["wtype"] as? String ?? ""
            cell.lblName.text = lstTp[indexPath.row]["sfName"] as? String ?? ""
            cell.lblWorkType.textColor = UIColor.red

            cell.lblRemarks.text = lstTp[indexPath.row]["remark"] as? String ?? ""
            
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}



class TourPlanViewDateWiseTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWorkType: UILabel!
    
    
    @IBOutlet weak var lblHeadquarters: UILabel!
    @IBOutlet weak var lblDistributor: UILabel!
    @IBOutlet weak var lblRoutes: UILabel!
    
    
    
    
    @IBOutlet weak var lblPob: UILabel!
    @IBOutlet weak var lblSob: UILabel!
    
    @IBOutlet weak var lblJointWorks: UILabel!
    
    
    @IBOutlet weak var lblRemarks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class TourPlanViewDateWiseNonFieldWorkTableViewCell : UITableViewCell {
    
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWorkType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    
    
    @IBOutlet weak var lblRemarks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
