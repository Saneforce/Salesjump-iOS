//
//  TourPlanView.swift
//  SAN SALES
//
//  Created by Naga Prasath on 13/05/24.
//

import Foundation
import UIKit
import Alamofire


class TourPlanView : IViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    @IBOutlet weak var vwHq: UIView!
    
    @IBOutlet weak var vwDate: UIView!
    
    
    
    @IBOutlet weak var twTpList: UITableView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var lblHeadquarter: UILabel!
    
    
    @IBOutlet weak var lblHeadquarterHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var vwHqHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewHead: UIView!
    
    
    @IBOutlet weak var vwHeadHeightConstraint: NSLayoutConstraint!
    
    
    
    var sfCode: String = "", stateCode: String = "", divCode: String = "",desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    
    var lstSub : [AnyObject] = []
    var lstHQs : [AnyObject] = []
    var lstTp : [AnyObject] = []
    
    var date = ""
    
    var selectedHq : AnyObject! {
        didSet {
            self.lblName.text = selectedHq["name"] as? String
            self.fetchTourPlanData(code: self.selectedHq["id"] as? String ?? "", date: self.date)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBack.addTarget(target: self, action: #selector(backVC))
        getUserDetails()
        
        vwHq.layer.borderWidth = 2
        vwHq.layer.borderColor = CGColor(red: 54.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 0.6)
        vwHq.layer.masksToBounds = true
        
        vwDate.layer.borderWidth = 2
        vwDate.layer.borderColor = CGColor(red: 54.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 0.6)
        vwDate.layer.masksToBounds = true
        
        let lstSubordinates : String = LocalStoreage.string(forKey: "Subordinates")!
        
        if let list = GlobalFunc.convertToDictionary(text: lstSubordinates) as? [AnyObject] {
            lstSub = list
        }
        print(lstSub)
        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list
        }
        
        self.lblDate.text = Date().toString(format: "dd MMM yyyy")
        self.date = Date().toString(format: "yyyy-MM-dd")
        
        if UserSetup.shared.SF_type == 1 {
            
            vwHq.isHidden  = true
            vwHqHeightConstraint.constant = 0
            lblHeadquarterHeightConstraint.constant = 0
            vwHeadHeightConstraint.constant = 80
            self.fetchTourPlanData(code: sfCode, date: date)
        }else {
            let hq = lstSub.filter{($0["id"] as? String ?? "") == sfCode}
            
            if !hq.isEmpty{
                self.selectedHq = hq.first
            }
        }
        
    }
    
    
    @IBAction func hqAction(_ sender: UIButton) {
        
        let hqVC = ItemViewController(items: lstSub, configure: { (Cell : SingleSelectionTableViewCell, subordinate) in
            Cell.textLabel?.text = subordinate["name"] as? String
        })
        hqVC.title = "Select the Name"
        hqVC.didSelect = { subordinate in
            print(subordinate)
            
            self.navigationController?.popViewController(animated: true)
            self.selectedHq = subordinate
        }
        self.navigationController?.pushViewController(hqVC, animated: true)
    }
    
    
    
    @IBAction func dateAction(_ sender: UIButton) {
        if UserSetup.shared.SF_type != 1 {
            if self.selectedHq == nil{
                Toast.show(message: "Please Select Headquarter", controller: self)
                return
            }
        }
        
        let alertView = CalendarViewController()
        alertView.didSelect = { date in
            print(date)
            self.date = date
            self.lblDate.text = date.changeFormat(from: "yyyy-MM-dd",to: "dd MMM yyyy")
            if UserSetup.shared.SF_type == 1 {
                self.fetchTourPlanData(code: self.sfCode, date: date)
            }else {
                self.fetchTourPlanData(code: self.selectedHq["id"] as? String ?? "", date: date)
            }
            self.dismiss(animated: true)
        }
        alertView.show()
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
    
    func fetchTourPlanData(code : String ,date : String) {
        
        let jsonString = "{\"sfCode\":\"\(code)\",\"mnthYr\":\"\(date)\"}"
        
        
        let params : Parameters = ["data" : jsonString ]
        
//    http://fmcg.salesjump.in/server/native_Db_V13.php?desig=MR&divisionCode=29%2C&rSF=SEFMR0040&axn=tpview&sfCode=SEFMR0040&stateCode=24
        
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"tpview&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"&rSF=" + sfCode + "&stateCode=" + stateCode)
        print(params)
        self.ShowLoading(Message: "Loading ...")
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"tpview&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"&rSF=" + sfCode + "&stateCode=" + stateCode,method: .post , parameters: params,encoding: URLEncoding.httpBody,headers: nil).validate(statusCode: 200..<209).responseData { AFData in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.LoadingDismiss()
            }
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                guard let response = apiResponse as? [AnyObject] else{
                    return
                }
                self.lstTp = response
                
                if self.lstTp.isEmpty {
                    Toast.show(message: "No Data", controller: self)
                    self.twTpList.reloadData()
                }else{
                    self.twTpList.reloadData()
                    self.twTpList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
                print(self.lstTp)
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstTp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let workTypeName = lstTp[indexPath.row]["wtype"] as? String ?? ""
        
        
        if workTypeName.contains("Field Work") || workTypeName.contains("FieldWork") || workTypeName.contains("Fieldwork"){
            let cell:TourPlanViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TourPlanViewTableViewCell
            cell.lblDate.text = lstTp[indexPath.row]["date"] as? String ?? ""
            cell.lblWorkType.text = lstTp[indexPath.row]["wtype"] as? String ?? ""
            
            cell.lblWorkType.textColor = UIColor.systemGreen

            let selectedHQ = lstHQs.filter{(String(format: "%@", $0["id"] as! CVarArg)) == (lstTp[indexPath.row]["HQ_Code"] as? String ?? "")}
            
            print(lstTp[indexPath.row])
            if !selectedHQ.isEmpty{
                cell.lblHeadquarter.text = selectedHQ.first?["name"] as? String ?? ""
            }else{
                cell.lblHeadquarter.text = ""
            }
            
            let routes = lstTp[indexPath.row]["towns"] as? String ?? ""
            let jointWorks = lstTp[indexPath.row]["JointWork_Name1"] as? String ?? ""
            
            
            cell.lblTitleDistributor.text = UserSetup.shared.StkCap
            cell.lblTitleRoutes.text = UserSetup.shared.StkRoute
            cell.lblDistributor.text = lstTp[indexPath.row]["distributor"] as? String ?? ""
            cell.lblJointWorks.text = jointWorks.isEmpty ? "" : jointWorks.replacingOccurrences(of: "$$", with: ",")

            
            cell.lblRoutes.text = routes.isEmpty ? "" : routes.replacingOccurrences(of: "$$", with: ",")
            cell.lblPob.text = lstTp[indexPath.row]["pob"] as? String ?? "00"
            cell.lblSob.text = lstTp[indexPath.row]["sob"] as? String ?? "00"
            cell.lblRemarks.text = lstTp[indexPath.row]["remark"] as? String ?? ""
            
            cell.layoutIfNeeded()
            return cell
        }else if workTypeName.contains("Distributor") || workTypeName.contains("distributor"){
            let cell:TourPlanViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TourPlanViewTableViewCell
            cell.lblDate.text = lstTp[indexPath.row]["date"] as? String ?? ""
            cell.lblWorkType.text = lstTp[indexPath.row]["wtype"] as? String ?? ""
            
            cell.lblWorkType.textColor = UIColor.blue

            let selectedHQ = lstHQs.filter{(String(format: "%@", $0["id"] as! CVarArg)) == (lstTp[indexPath.row]["HQ_Code"] as? String ?? "")}
            
            if !selectedHQ.isEmpty{
                cell.lblHeadquarter.text = selectedHQ.first?["Name"] as? String ?? ""
            }else{
                cell.lblHeadquarter.text = ""
            }
            
            let routes = lstTp[indexPath.row]["towns"] as? String ?? ""
            let jointWorks = lstTp[indexPath.row]["JointWork_Name1"] as? String ?? ""
            
            
            cell.lblTitleDistributor.text = UserSetup.shared.StkCap
            cell.lblTitleRoutes.text = UserSetup.shared.StkRoute
            cell.lblDistributor.text = lstTp[indexPath.row]["distributor"] as? String ?? ""
            cell.lblJointWorks.text = jointWorks.isEmpty ? "" : jointWorks.replacingOccurrences(of: "$$", with: ",")

            
            cell.lblRoutes.text = routes.isEmpty ? "" : routes.replacingOccurrences(of: "$$", with: ",")
            cell.lblPob.text = ""
            cell.lblSob.text = ""
            cell.lblRemarks.text = lstTp[indexPath.row]["remark"] as? String ?? ""
            
            cell.layoutIfNeeded()
            return cell
        }else {
            let cell:TourPlanViewNonFieldWorkTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TourPlanViewNonFieldWorkTableViewCell
            
            cell.lblDate.text = lstTp[indexPath.row]["date"] as? String ?? ""
            cell.lblWorkTypeName.text = lstTp[indexPath.row]["wtype"] as? String ?? ""
            cell.lblWorkTypeName.textColor = UIColor.red
            cell.lblRemarks.text = lstTp[indexPath.row]["remark"] as? String ?? ""
            return cell
        }
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}


class TourPlanViewTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWorkType: UILabel!
    
    
    @IBOutlet weak var lblTitleHeadquartes: UILabel!
    
    @IBOutlet weak var lblHeadquarter: UILabel!
    @IBOutlet weak var lblDistributor: UILabel!
    @IBOutlet weak var lblRoutes: UILabel!

    @IBOutlet weak var lblPob: UILabel!
    @IBOutlet weak var lblSob: UILabel!

    @IBOutlet weak var lblJointWorks: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!
    
    
    @IBOutlet weak var lblTitleDistributor: UILabel!
    
    
    @IBOutlet weak var lblTitleRoutes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


class TourPlanViewNonFieldWorkTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblWorkTypeName: UILabel!
    
    
    @IBOutlet weak var lblRemarks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
