//
//  TourPlanSingleEntry.swift
//  SAN SALES
//
//  Created by Naga Prasath on 16/04/24.
//

import Foundation
import UIKit
import Alamofire

class TourPlanSingleEntry : IViewController , UITableViewDataSource,UITableViewDelegate{
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var lblWorkType: LabelSelect!
    @IBOutlet weak var lblHeadquarter: LabelSelect!
    @IBOutlet weak var lblDistributor: LabelSelect!
    
    
    @IBOutlet weak var txtRemarks: UITextView!
    
    
    @IBOutlet weak var txtSob: UITextField!
    @IBOutlet weak var txtPob: UITextField!
    
    @IBOutlet weak var routeTableView: UITableView!
    @IBOutlet weak var jointWorkTableView: UITableView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    @IBOutlet weak var lblTitleDistributor: UILabel!
    
    
    @IBOutlet weak var lblRoute: UILabel!
    
    
    @IBOutlet weak var vwWorkType: UIView!
    @IBOutlet weak var vwHeadquarter: UIView!
    @IBOutlet weak var vwDistributor: UIView!
    @IBOutlet weak var vwRoute: UIView!
    @IBOutlet weak var vwJointWork: UIView!
    @IBOutlet weak var vwSob: UIView!
    @IBOutlet weak var vwPob: UIView!
    @IBOutlet weak var vwRemarks: UIView!
    
    
    
    @IBOutlet weak var vwWorktypeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwHeadquarterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwDistributorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwRouteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwSobHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwPobHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwJointWorkHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var topVwHeadquarterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topVwDistributorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topVwRouteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topVwJointWorkHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topVwSobHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topVwPobHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    
    var lstWType: [AnyObject] = []
    var lstHQs: [AnyObject] = []
    
    var lstSelectedJoints : [AnyObject] = []
    var lstSelectedRoutes : [AnyObject] = []
    var lstSelectJoints : [AnyObject] = []
    var lstSelectRoutes : [AnyObject] = []
    
    var lstDist: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    var lstJoint: [AnyObject] = []
    var lstSelJWNms: [AnyObject] = []
    var lstJWNms: [AnyObject] = []
    
    var dateEntry : AnyObject!
    var date = ""
    var sfCode = "",divCode = "",desig = "", sfName = ""
    
    let LocalStoreage = UserDefaults.standard
    
    var height : Double = 750
    
    var editData : AnyObject!
    
    var didSelect : (Bool) -> () = { _ in}
    
    var selectedWorktype : AnyObject! {
        didSet {
            self.lblWorkType.text = selectedWorktype["name"] as? String
        }
    }
    
    var selectedHeadquarter : AnyObject! {
        didSet {
            self.lblHeadquarter.text = selectedHeadquarter["name"] as? String
            // updateRoutes(id: String(format: "%@", selectedHeadquarter["id"] as! CVarArg))
            
            self.selectedDistributor = nil
            lblDistributor.text = "Select the \(UserSetup.shared.StkCap)"
            self.lstSelectedRoutes.removeAll()
            self.routeTableView.reloadData()
            self.lstSelectedJoints.removeAll()
            self.jointWorkTableView.reloadData()
            
        }
    }
    
    var selectedDistributor : AnyObject? {
        didSet {
            self.lblDistributor.text = selectedDistributor?["name"] as? String
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        
        lblWorkType.addTarget(target: self, action: #selector(workTypeSelection))
        lblHeadquarter.addTarget(target: self, action: #selector(headquarterSelection))
        lblDistributor.addTarget(target: self, action: #selector(distributorSelection))
        
        lblTitleDistributor.text = UserSetup.shared.StkCap
        lblDistributor.text = "Select the \(UserSetup.shared.StkCap)"
        lblRoute.text = UserSetup.shared.StkRoute
        
        txtRemarks.delegate = self
        txtRemarks.text = "Enter the remarks"
        txtRemarks.textColor = .lightGray
        
        self.updateSetup()
        
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        LocationService.sharedInstance.getNewLocation(location: { location in
        }, error:{ errMsg in
        })
        
        sfCode = prettyJsonData["sfCode"] as? String ?? ""
        divCode = prettyJsonData["divisionCode"] as? String ?? ""
        desig = prettyJsonData["desigCode"] as? String ?? ""
        sfName = prettyJsonData["sfName"] as? String ?? ""
        
        
        if let WorkTypeData = LocalStoreage.string(forKey: "Worktype_Master"),
           let list = GlobalFunc.convertToDictionary(text:  WorkTypeData) as? [AnyObject] {
            lstWType = list
        }
        
        if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+sfCode),
           let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
            lstDist = list;
        }
        if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+sfCode),
           let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
            lstRoutes = list
            
        }
        if let JointWData = LocalStoreage.string(forKey: "Jointwork_Master"),
           let lists = GlobalFunc.convertToDictionary(text:  JointWData) as? [AnyObject] {
           lstJoint = lists
        }
        
        if UserSetup.shared.SF_type != 1 {
            if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
               let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
                lstHQs = list
            }
        }
        
        vwRouteHeightConstraint.constant = 55
        
        if UserSetup.shared.jointWorkNeed != 1{
            vwJointWorkHeightConstraint.constant = 55
        }
        
      
        print(height)
        scrollViewHeightConstraint.constant = height
        print(self.editData)
        
        self.updateEditData()
    }
    
    
    
    func updateEditData() {
        if editData != nil {
            let selectedWT = lstWType.filter{(String(format: "%@", $0["id"] as! CVarArg)) == (String(format: "%@", editData["worktype_code"] as! CVarArg))}
            let selectedHQ = lstHQs.filter{(String(format: "%@", $0["id"] as! CVarArg)) == (editData["HQ_Code"] as? String)}
            
            
//            if UserSetup.shared.SF_type != 1 {
//                self.updateRoutes(id: (editData["HQ_Code"] as? String ?? ""))
//            }
            if !selectedHQ.isEmpty {
                updateRoutes(id: String(format: "%@", selectedHQ.first!["id"] as! CVarArg), isFromEdit: true)
                self.selectedHeadquarter = selectedHQ.first
            }
            
            let selectDistri = lstDist.filter{(String(format: "%@", $0["id"] as! CVarArg)) == (String(format: "%@", editData["Worked_with_Code"] as! CVarArg))}
            let selectedRoutes = lstRoutes.filter{(editData["RouteCode"] as! String).contains((String(format: "%@", $0["id"] as! CVarArg)))}
            
            // RouteCode id
            let selectedJW = lstJoint.filter{(editData["JointWork_Name"] as? String ?? "").contains((String(format: "%@", $0["id"] as! CVarArg)))}
            
            print(editData["RouteCode"] as! String)
            print(selectedRoutes)
            print(lstRoutes)
            if !selectedWT.isEmpty {
                self.selectedWorktype = selectedWT.first
                
                let fwflg = selectedWorktype["FWFlg"] as? String ?? ""
                
                switch fwflg{
                    case "F":
                        self.updateFieldWork()
                    case "DH":
                        self.updateDistributorHunting()
                    default:
                        self.updateNonFieldWork()
                }
            }
            
            
            
            if !selectDistri.isEmpty {
                self.selectedDistributor = selectDistri.first
            }
            
            if !selectedRoutes.isEmpty {
                self.lstSelectedRoutes = selectedRoutes
                
                self.vwRouteHeightConstraint.constant = 55 + CGFloat(self.lstSelectedRoutes.count * 50)
                let ht : Double = Double(self.lstSelectedJoints.count * 50) + self.height + Double(self.lstSelectedRoutes.count * 50)
             //   self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: ht)
                scrollViewHeightConstraint.constant = ht
                routeTableView.reloadData()
            }else{}
            
            if !selectedJW.isEmpty {
                self.lstSelectedJoints = selectedJW
                
                self.vwJointWorkHeightConstraint.constant = 55 + CGFloat(self.lstSelectedJoints.count * 50)
                let ht : Double = Double(self.lstSelectedJoints.count * 50) + self.height + Double(self.lstSelectedRoutes.count * 50)
             //   self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: ht)
                scrollViewHeightConstraint.constant = ht
                jointWorkTableView.reloadData()
            }
            
            self.txtPob.text = editData["pob"] as? String ?? ""
            self.txtSob.text = editData["sob"] as? String ?? ""
            
            
            let remarks = editData["remarks"] as? String ?? ""
            
            if remarks.isEmpty {
                self.txtRemarks.text = "Enter the remarks"
                self.txtRemarks.textColor = .lightGray
            }else{
                self.txtRemarks.text = remarks
                self.txtRemarks.textColor = .black
            }
        }
    }
    
    func updateRoutes(id : String , isFromEdit : Bool) {
       // let id: String = sfCode
        if(LocalStoreage.string(forKey: "Distributors_Master_"+id)==nil){
            //Toast.show(message: "No Distributors found. Please will try to sync", controller: self)
            self.ShowLoading(Message: "       Sync Data Please wait...")
            GlobalFunc.FieldMasterSync(SFCode: id){ [self] in
                let DistData = self.LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                let RouteData: String=self.LocalStoreage.string(forKey: "Route_Master_"+id)!
                let jointWorkData : String = self.LocalStoreage.string(forKey: "Jointwork_Master_"+id)!
                if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                    self.lstDist = list;
                }
                if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                 //   self.lstAllRoutes = list
                    self.lstRoutes = list
                }
                if let list  =  GlobalFunc.convertToDictionary(text: jointWorkData) as? [AnyObject] {
                    self.lstJoint = list
                }
                lblDistributor.text = "Select the Distributor"
                self.lstSelectedRoutes.removeAll()
                self.routeTableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.LoadingDismiss()
                    if isFromEdit == false {
                        self.navigationController?.popViewController(animated: true)
                    }else {
                        self.updateEditData()
                    }
                }
                
               // self.navigationController?.popViewController(animated: true)
            }
            
            
        }else {
            if let DistData = LocalStoreage.string(forKey: "Distributors_Master_" + id) {
                if let RouteData = LocalStoreage.string(forKey: "Route_Master_" + id) {
                    if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                        lstDist = list
                    }
                    
                    if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                        lstRoutes = list
                    }
                }
                
                if let jointWorkData = LocalStoreage.string(forKey: "Jointwork_Master_"+id){
                    if let list = GlobalFunc.convertToDictionary(text: jointWorkData) as? [AnyObject] {
                        lstJoint = list
                    }
                }
            }
        }
    }
    
    func updateSetup(){
        
        if UserSetup.shared.tpTargetBased == 0 {
            self.vwPob.isHidden = true
            self.vwSob.isHidden = true
            
            self.vwSobHeightConstraint.constant = 0
            self.topVwSobHeightConstraint.constant = 0
            
            self.vwPobHeightConstraint.constant = 0
            self.topVwPobHeightConstraint.constant = 0
            
            height = height - 190
        }
        
        if UserSetup.shared.distributorBased == 0 {
            self.vwDistributor.isHidden = true
            self.vwDistributorHeightConstraint.constant = 0
            self.topVwDistributorHeightConstraint.constant = 0
            
            height = height - 95
        }
        
        if UserSetup.shared.jointWorkNeed == 1 {
            self.vwJointWork.isHidden = true
            self.vwJointWorkHeightConstraint.constant = 0
            self.topVwJointWorkHeightConstraint.constant = 0
            
            height = height - 55
        }

        if UserSetup.shared.SF_type == 1 {
            self.vwHeadquarter.isHidden = true
            self.vwHeadquarterHeightConstraint.constant = 0
            self.topVwHeadquarterHeightConstraint.constant = 0
            
            height = height - 95
        }
        
    }
    
    func updateFieldWork() {
        if UserSetup.shared.SF_type != 1 {
            self.vwHeadquarter.isHidden = false
            self.vwHeadquarterHeightConstraint.constant = 80
            self.topVwHeadquarterHeightConstraint.constant = 15
            
        }
        
        if UserSetup.shared.distributorBased != 0 {
            self.vwDistributor.isHidden = false
            self.vwDistributorHeightConstraint.constant = 80
            self.topVwDistributorHeightConstraint.constant = 15
        }
        
        if UserSetup.shared.jointWorkNeed != 1 {
            self.vwJointWork.isHidden = false
            self.vwJointWorkHeightConstraint.constant = 50
            self.topVwJointWorkHeightConstraint.constant = 15
        }
        
        self.vwRoute.isHidden = false
        
        
        self.lstSelectedRoutes.removeAll()
        self.lstSelectedJoints.removeAll()
        
        
        if UserSetup.shared.tpTargetBased != 0 {
            self.vwPob.isHidden = false
            self.vwSob.isHidden = false
            
            self.txtPob.text = ""
            self.txtSob.text = ""
            
            self.vwSobHeightConstraint.constant = 80
            self.topVwSobHeightConstraint.constant = 15
            
            self.vwPobHeightConstraint.constant = 80
            self.topVwPobHeightConstraint.constant = 15
        }
        
        
        
        self.vwRouteHeightConstraint.constant = 50
        self.topVwRouteHeightConstraint.constant = 15
        
        
    }
    
    func updateNonFieldWork(){
        self.vwHeadquarter.isHidden = true
        self.vwDistributor.isHidden = true
        self.vwJointWork.isHidden = true
        self.vwRoute.isHidden = true
        self.vwPob.isHidden = true
        self.vwSob.isHidden = true
        
        self.lstSelectedRoutes.removeAll()
        self.lstSelectedJoints.removeAll()
        
        self.txtPob.text = ""
        self.txtSob.text = ""
        
        self.vwHeadquarterHeightConstraint.constant = 0
        self.topVwHeadquarterHeightConstraint.constant = 0
        
        self.vwDistributorHeightConstraint.constant = 0
        self.topVwDistributorHeightConstraint.constant = 0
        
        self.vwRouteHeightConstraint.constant = 0
        self.topVwRouteHeightConstraint.constant = 0
        
        self.vwJointWorkHeightConstraint.constant = 0
        self.topVwJointWorkHeightConstraint.constant = 0
        
        self.vwSobHeightConstraint.constant = 0
        self.topVwSobHeightConstraint.constant = 0
        
        self.vwPobHeightConstraint.constant = 0
        self.topVwPobHeightConstraint.constant = 0
    }
    
    func updateDistributorHunting() {
        
        if UserSetup.shared.SF_type == 1 {
            self.vwHeadquarter.isHidden = true
            self.vwHeadquarterHeightConstraint.constant = 0
            self.topVwHeadquarterHeightConstraint.constant = 0
        }else {
            self.vwHeadquarter.isHidden = false
            self.vwHeadquarterHeightConstraint.constant = 80
            self.topVwHeadquarterHeightConstraint.constant = 15
        }
        
        self.vwRoute.isHidden = false
        self.vwRouteHeightConstraint.constant = 50
        self.topVwRouteHeightConstraint.constant = 15
        
        self.vwDistributor.isHidden = true
        
        self.vwPob.isHidden = true
        self.vwSob.isHidden = true
        
        
        self.lstSelectedRoutes.removeAll()
        self.lstSelectedJoints.removeAll()
        
        self.txtPob.text = ""
        self.txtSob.text = ""
        
        self.vwDistributorHeightConstraint.constant = 0
        self.topVwDistributorHeightConstraint.constant = 0
        
        self.vwSobHeightConstraint.constant = 0
        self.topVwSobHeightConstraint.constant = 0
        
        self.vwPobHeightConstraint.constant = 0
        self.topVwPobHeightConstraint.constant = 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case routeTableView:
            return lstSelectedRoutes.count
        case jointWorkTableView:
            return lstSelectedJoints.count
        default:
            return 0
        
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        
        switch tableView{
            case routeTableView:
                let item: [String: Any]=lstSelectedRoutes[indexPath.row] as! [String : Any]
                cell.lblText.text = item["name"] as? String
                cell.imgSelect.addTarget(target: self, action: #selector(deleteRoute(_:)))
            case jointWorkTableView:
                let item: [String: Any]=lstSelectedJoints[indexPath.row] as! [String : Any]
                cell.lblText.text = item["name"] as? String
                cell.imgSelect.addTarget(target: self, action: #selector(deleteJointWork(_:)))
            default:
                break
        }
        
        return cell
    }
    
    @objc func deleteRoute(_ sender : UITapGestureRecognizer) {
        
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indx:NSIndexPath = tbView.indexPath(for: cell)! as NSIndexPath
        lstSelectedRoutes.remove(at: indx.row)
        
        self.vwRouteHeightConstraint.constant = 55 + CGFloat(self.lstSelectedRoutes.count * 50)
        let ht : Double = Double(self.lstSelectedJoints.count * 50) + self.height + Double(self.lstSelectedRoutes.count * 50)
        scrollViewHeightConstraint.constant = ht
        routeTableView.reloadData()
        self.view.layoutIfNeeded()
    }
    
    @objc func deleteJointWork(_ sender : UITapGestureRecognizer) {
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indx:NSIndexPath = tbView.indexPath(for: cell)! as NSIndexPath
        lstSelectedJoints.remove(at: indx.row)
        
        self.vwJointWorkHeightConstraint.constant = 55 + CGFloat(self.lstSelectedJoints.count * 50)
        let ht : Double = Double(self.lstSelectedJoints.count * 50) + self.height + Double(self.lstSelectedRoutes.count * 50)
        scrollViewHeightConstraint.constant = ht
        jointWorkTableView.reloadData()
        self.view.layoutIfNeeded()
    }
    
    func isValid() -> Bool{
        if self.selectedWorktype == nil {
            Toast.show(message: "Please Select WorkType", controller: self)
            return true
        }
        let fwflg = selectedWorktype["FWFlg"] as? String ?? ""
        
        if fwflg == "F" {
            if UserSetup.shared.SF_type != 1 {
                
                if self.selectedHeadquarter == nil {
                    Toast.show(message: "Please Select Headquarter", controller: self)
                    return true
                }
            }
            
            if UserSetup.shared.distributorBased != 0{
                if self.selectedDistributor == nil{
                    Toast.show(message: "Please Select \(UserSetup.shared.StkCap)", controller: self)
                    return true
                }
            }
            
            
            if self.lstSelectedRoutes.isEmpty {
                Toast.show(message: "Please Select \(UserSetup.shared.StkRoute)", controller: self)
                return true
            }
            
            if UserSetup.shared.tpTargetBased != 0{
                if self.txtSob.text == "" {
                    Toast.show(message: "Please Enter SOB", controller: self)
                    return true
                }
                if self.txtPob.text == "" {
                    Toast.show(message: "Please Enter POB", controller: self)
                    return true
                }
            }
        }else if fwflg == "DH" {
            if UserSetup.shared.SF_type != 1 {
                
                if self.selectedHeadquarter == nil {
                    Toast.show(message: "Please Select Headquarter", controller: self)
                    return true
                }
            }
            
            
            if self.lstSelectedRoutes.isEmpty {
                Toast.show(message: "Please Select \(UserSetup.shared.StkRoute)", controller: self)
                return true
            }
        }
        
        
        return false
    }
    
    func submitAction() {
        
        
        
        let hqName = self.selectedHeadquarter == nil ? "" : self.selectedHeadquarter["name"] as? String ?? ""
        let hqId = self.selectedHeadquarter == nil ? "" : String(format: "%@", self.selectedHeadquarter["id"] as! CVarArg)
        
        let disName = self.selectedDistributor == nil ? "" : self.selectedDistributor?["name"] as? String ?? ""
        let disId = self.selectedDistributor == nil ? "" : String(format: "%@", self.selectedDistributor?["id"] as! CVarArg)
        
        let workWithName = self.lstSelectedJoints.map({$0["name"] as? String ?? ""}).joined(separator: "$$")
        let workWithId = self.lstSelectedJoints.map({$0["id"] as? String ?? ""}).joined(separator: "$$")
        
        let routeName = self.lstSelectedRoutes.map({$0["name"] as? String ?? ""}).joined(separator: "$$")
        let routeId = self.lstSelectedRoutes.map({($0["id"] as? String ?? "")}).joined(separator: "$$")
        
        
        let remarks = self.txtRemarks.textColor == .lightGray ? "" : self.txtRemarks.text!
        
        let jsonString = "[{\"Tour_Plan\":{\"worktype_code\":\"\'\(String(format: "%@", self.selectedWorktype["id"] as! CVarArg))\'\",\"worktype_name\":\"' \(selectedWorktype["name"] as? String ?? "")'\",\"Worked_with_Code\":\"\'\(disId)\'\",\"Worked_with_Name\":\"\'\(disName)\'\",\"sfName\":\"\'\(self.sfName)\'\",\"Place_Inv\":\"\(selectedWorktype["Place_Involved"] as? String ?? "")\",\"objective\":\"\'\(remarks) \'\",\"Tour_Date\":\"\'\(self.date)\'\",\"Multiretailername\":\"\'\'\",\"MultiretailerCode\":\"\'\'\",\"worked_with\":\"\'\(workWithId)\'\",\"HQ_Code\":\"\'\(hqId)\'\",\"HQ_Name\":\"\'\(hqName)\'\",\"SOB\":\"\(self.txtSob.text!)\",\"POB\":\"\(self.txtPob.text!)\",\"AppVersion\":\"\",\"location\":\"0:0\",\"dcr_activity_date\":\"\'\(Date().toString(format: "yyyy-MM-dd HH:mm:ss"))\'\",\"worked_withname\":\"\'\(workWithName)\'\",\"RouteName\":\"\'\(routeName)\'\",\"RouteCode\":\"\'\(routeId)\'\"}}]"
        
        let params: Parameters = [ "data": jsonString ]
        
        print(params)
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig)
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseData { AFdata in
            self.LoadingDismiss()
            switch AFdata.result
            {
                
            case .success(let value):
                print(value)
                let apiResponse = try? JSONSerialization.jsonObject(with: AFdata.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                print(apiResponse as Any)
                
                
                self.navigationController?.popViewController(animated: true)
                self.didSelect(true)
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    
    @IBAction func addRoute(_ sender: UIButton) {
        if self.selectedWorktype == nil {
            Toast.show(message: "Please Select WorkType", controller: self)
            return
        }
        
        if UserSetup.shared.SF_type != 1 {
            if self.selectedHeadquarter == nil {
                Toast.show(message: "Please Select Headquarter", controller: self)
                return
            }
        }
        
        let routesVC = ItemMultipleSelectionViewController(items: lstRoutes, configure: { (Cell : MultipleSelectionTableViewCell, route) in
            Cell.lblName.text = route["name"] as? String
            
            let selectedRoutes = self.lstSelectedRoutes.filter{$0["id"] as? String == route["id"] as? String}
            
            if !selectedRoutes.isEmpty {
                Cell.button.isSelected = true
            }else{
                Cell.button.isSelected = false
            }
        })
        routesVC.title = "Select the \(UserSetup.shared.StkRoute)"
        routesVC.didSelect = { selectedItem in
            print(selectedItem)
            
            if let index = self.lstSelectedRoutes.firstIndex(where: { (item) -> Bool in
                return selectedItem["id"] as? String == item["id"] as? String
            }){
                self.lstSelectedRoutes.remove(at: index)
            }else{
                self.lstSelectedRoutes.append(selectedItem)
            }
        }
        routesVC.save = { items in
            self.vwRouteHeightConstraint.constant = 55 + CGFloat(self.lstSelectedRoutes.count * 50)
            
            
            let ht : Double = Double(self.lstSelectedRoutes.count * 50) + self.height + Double(self.lstSelectedJoints.count * 50)
         //   self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: ht)
            self.scrollViewHeightConstraint.constant = ht
            self.routeTableView.reloadData()
    
            self.view.layoutIfNeeded()
        }
        self.navigationController?.pushViewController(routesVC, animated: true)
    }
    
    
    @IBAction func addJointWork(_ sender: UIButton) {
        print("tappped")
        if self.selectedWorktype == nil {
            Toast.show(message: "Please Select WorkType", controller: self)
            return
        }
        
        if UserSetup.shared.SF_type != 1 {
            if self.selectedHeadquarter == nil {
                Toast.show(message: "Please Select Headquarter", controller: self)
                return
            }
        }
        
        if self.lstSelectedRoutes.isEmpty {
            Toast.show(message: "Please Select \(UserSetup.shared.StkRoute)", controller: self)
            return
        }
        
        let jointWorkVC = ItemMultipleSelectionViewController(items: lstJoint, configure: { (Cell : MultipleSelectionTableViewCell, jointwork) in
            Cell.lblName.text = jointwork["name"] as? String
            
            let selectedJoints = self.lstSelectedJoints.filter{$0["id"] as? String == jointwork["id"] as? String}
            
            if !selectedJoints.isEmpty {
                Cell.button.isSelected = true
            }else{
                Cell.button.isSelected = false
            }
        })
        jointWorkVC.title = "Select the JointWork"
        jointWorkVC.didSelect = { selectedItem in
            print(selectedItem)
            
            if let index = self.lstSelectedJoints.firstIndex(where: { (item) -> Bool in
                return selectedItem["id"] as? String == item["id"] as? String
            }){
                self.lstSelectedJoints.remove(at: index)
            }else{
                self.lstSelectedJoints.append(selectedItem)
            }
        }
        jointWorkVC.save = { items in
            
//            self.lstSelectedJoints = items
//            self.lstSelectJoints = items
            self.vwJointWorkHeightConstraint.constant = 55 + CGFloat(self.lstSelectedJoints.count * 50)
            
            let ht : Double = Double(self.lstSelectedJoints.count * 50) + self.height + Double(self.lstSelectedRoutes.count * 50)
          //  self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: ht)
            self.scrollViewHeightConstraint.constant = ht
            self.jointWorkTableView.reloadData()
            self.view.layoutIfNeeded()
        }
        self.navigationController?.pushViewController(jointWorkVC, animated: true)
    }
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        if isValid() == true {
            return
        }
        submitAction()
    }
    
    
    @objc func workTypeSelection(sender : UITapGestureRecognizer) {
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
                    self.updateFieldWork()
                case "DH":
                    self.updateDistributorHunting()
                default:
                    self.updateNonFieldWork()
            }
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(worktypeVC, animated: true)
    }
    
    @objc func headquarterSelection(sender : UITapGestureRecognizer) {
        if self.selectedWorktype == nil {
            Toast.show(message: "Please Select WorkType", controller: self)
            return
        }
        
        let headquarterVC = ItemViewController(items: lstHQs, configure: { (Cell : SingleSelectionTableViewCell, headquarter) in
            Cell.textLabel?.text = headquarter["name"] as? String
        })
        headquarterVC.title = "Select the Headquarter"
        headquarterVC.didSelect = { selectedHeadquarter in
            print(selectedHeadquarter)
            self.selectedHeadquarter = selectedHeadquarter
            self.updateRoutes(id: selectedHeadquarter["id"] as? String ?? "", isFromEdit: false)
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(headquarterVC, animated: true)
    }
    
    @objc func distributorSelection(sender : UITapGestureRecognizer) {
        if self.selectedWorktype == nil {
            Toast.show(message: "Please Select WorkType", controller: self)
            return
        }
        
        if UserSetup.shared.SF_type != 1 {
            if self.selectedHeadquarter == nil {
                Toast.show(message: "Please Select Headquarter", controller: self)
                return
            }
        }
        
        
        let distributorVC = ItemViewController(items: lstDist, configure: { (Cell : SingleSelectionTableViewCell, distributor) in
            Cell.textLabel?.text = distributor["name"] as? String
        })
        distributorVC.title = "Select the \(UserSetup.shared.StkCap)"
        distributorVC.didSelect = { selectedDistributor in
            print(selectedDistributor)
            self.selectedDistributor = selectedDistributor
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(distributorVC, animated: true)
    }
    
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TourPlanSingleEntry: UITextViewDelegate{
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
