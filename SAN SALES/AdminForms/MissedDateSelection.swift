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
    
    
    @IBOutlet weak var lblHeadquarters: LabelSelect!
    @IBOutlet weak var lblDistributor: LabelSelect!
    @IBOutlet weak var lblRoute: LabelSelect!
    @IBOutlet weak var lblTravelMode: LabelSelect!
    
    
    @IBOutlet weak var txtRemarks: UITextView!
    
    @IBOutlet weak var vwOrderList: UIView!
    
    
    @IBOutlet weak var vwOrderListHeightConstraints: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var lblSecondaryOrder: UILabel!
    
    @IBOutlet weak var lblPrimaryOrder: UILabel!
    
    @IBOutlet weak var lblSecondaryOrderCount: UILabel!
    @IBOutlet weak var lblPrimaryOrderCount: UILabel!
    
    
    @IBOutlet weak var vwHeadquarters: UIView!
    @IBOutlet weak var vwDistributor: UIView!
    @IBOutlet weak var vwRoutes: UIView!
    
    @IBOutlet weak var vwTravelMode: UIView!
    
    
    @IBOutlet weak var vwTravelModeHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var vwHeadquarterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwDistributorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwRouteHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var vwTravelHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var topVwHeadquarterHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topVwDistributorHeightConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var Primary_Order_height: NSLayoutConstraint!
    
    @IBOutlet weak var Primary_Order_Card_view: CardView!
    
    @IBOutlet weak var Secondary_Order_height: NSLayoutConstraint!
    
    
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
    
    var lstHQs: [AnyObject] = []
    
    var lstDist: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    var lstModeOfTravel: [AnyObject] = []
    
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
            self.secondaryOrderList.removeAll()
            self.primaryOrderList.removeAll()
        }
    }
    
    var selectedHeadquarter : AnyObject! {
        didSet {
            self.lblHeadquarters.text = selectedHeadquarter["name"] as? String
            
            self.selectedDistributor = nil
            lblDistributor.text = "Select the \(UserSetup.shared.StkCap)"
            
            
            self.selectedRoute = nil
            self.lblRoute.text = "Select the \(UserSetup.shared.StkRoute)"
            
            self.updateRoutes(id: selectedHeadquarter["id"] as? String ?? "")
        }
    }
    
    var selectedDistributor : AnyObject? {
        didSet {
            self.lblDistributor.text = selectedDistributor?["name"] as? String
            
            
        }
    }
    
    var selectedRoute : AnyObject! {
        didSet {
            self.lblRoute.text = selectedRoute?["name"] as? String
            
            self.selectedTravelMode = nil
            self.lblTravelMode.text = "Select Travel Mode"
        }
    }
    
    var selectedTravelMode : AnyObject! {
        didSet {
            self.lblTravelMode.text = selectedTravelMode?["MOT"] as? String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        getUserDetails()
        fetchMissedDate()
        fetchTravelMode()
        
        if (UserSetup.shared.StkNeed != 1) {
            Primary_Order_height.constant = 0
            Primary_Order_Card_view.isHidden = true
            Secondary_Order_height.constant = 60
            vwOrderListHeightConstraints.constant = 60
        }
        
        lblDate.addTarget(target: self, action: #selector(dateAction))
        lblWorkType.addTarget(target: self, action: #selector(workTypeAction))
        
        lblHeadquarters.addTarget(target: self, action: #selector(headquarterAction))
        lblDistributor.addTarget(target: self, action: #selector(distributorAction))
        lblRoute.addTarget(target: self, action: #selector(routeAction))
        lblTravelMode.addTarget(target: self, action: #selector(TravelModeAction))
        
        vwOrderListHeightConstraints.constant = 0
        vwOrderList.isHidden = true
        
        self.vwTravelMode.isHidden = true
        self.vwHeadquarters.isHidden = true
        self.vwDistributor.isHidden = true
        self.vwRoutes.isHidden = true
        
        self.vwTravelHeightConstraint.constant = 0
        
        txtRemarks.delegate = self
        txtRemarks.text = "Enter the remarks"
        txtRemarks.textColor = .lightGray
        
        if let WorkTypeData = LocalStoreage.string(forKey: "Worktype_Master"),
           let list = GlobalFunc.convertToDictionary(text:  WorkTypeData) as? [AnyObject] {
            lstWType = list
        }
        
        if UserSetup.shared.SF_type != 1 {
            if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
               let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
                lstHQs = list
            }
        }
        
        if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+sfCode),
           let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
            lstDist = list
        }
        
        if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+sfCode),
           let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
            lstRoutes = list
            
        }
        
        self.lblPrimaryOrder.text = UserSetup.shared.StkCap
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
    
    func fetchTravelMode() {
        let divisionCode = self.divCode.replacingOccurrences(of: ",", with: "")
        let url =  APIClient.shared.BaseURL+APIClient.shared.DBURL1+"get/travelmode&State_Code=" + self.stateCode + "&Division_Code=" + divisionCode
        AF.request(url,method: .get).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result {
                
            case .success(let value):
                
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data!)
                
                guard let response = apiResponse as? [AnyObject] else {
                    return
                }
                self.lstModeOfTravel = response
               
            case .failure(let Error):
                Toast.show(message:  Error.errorDescription ?? "" , controller: self)
            }
        }
    }
    func updateDisplay() {
        var height = 400
        if UserSetup.shared.SF_type == 1 {
            self.vwHeadquarters.isHidden = true
            self.topVwHeadquarterHeightConstraint.constant = 0
            self.vwHeadquarterHeightConstraint.constant = 0
            height = height - 100
        }else {
            self.vwHeadquarters.isHidden = false
            self.topVwHeadquarterHeightConstraint.constant = 10
            self.vwHeadquarterHeightConstraint.constant = 80
        }
        
        if UserSetup.shared.distributorBased == 0 {
            self.vwDistributor.isHidden = true
            self.topVwHeadquarterHeightConstraint.constant = 0
            self.vwDistributorHeightConstraint.constant = 0
            height = height - 100
        }else {
            self.vwDistributor.isHidden = false
            self.topVwHeadquarterHeightConstraint.constant = 10
            self.vwDistributorHeightConstraint.constant = 80
        }
        
        self.vwRoutes.isHidden = false
        self.vwTravelMode.isHidden = false
        
        self.vwTravelHeightConstraint.constant = CGFloat(height)
        
//        if UserSetup.shared.SrtEndKMNd != 2 {
//            self.vwTravelMode.isHidden = true
//            self.vwHeadquarters.isHidden = true
//            self.vwDistributor.isHidden = true
//            self.vwRoutes.isHidden = true
//            
//            self.vwTravelHeightConstraint.constant = 0
//        }
    }
    
    func updateRoutes(id : String) {
        if(LocalStoreage.string(forKey: "Distributors_Master_"+id)==nil){
            self.ShowLoading(Message: "       Sync Data Please wait...")
            GlobalFunc.FieldMasterSync(SFCode: id){ [self] in
                let DistData = self.LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                let RouteData: String=self.LocalStoreage.string(forKey: "Route_Master_"+id)!
                let RetailData: String=LocalStoreage.string(forKey: "Retail_Master_"+id)!
                if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                    self.lstDist = list;
                    print(list)
                    
                }
                if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                    self.lstRoutes = list
                }
                
                
                lblDistributor.text = "Select the Distributor"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.LoadingDismiss()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else {
            if let DistData = LocalStoreage.string(forKey: "Distributors_Master_" + id) {
                if let RouteData = LocalStoreage.string(forKey: "Route_Master_" + id) {
                    if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                        lstDist = list
                        print(list)
                        
                    }
                    
                    if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                        lstRoutes = list
                    }
                }
            }
        }
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
    
    func saveTravelMode() {
        
        let url = APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&sfCode=\(sfCode)&divisionCode=\(divCode)"
        
        
        let date = (selectedDate["name"] as? String ?? "") + " 00:00:00"
        let name = self.selectedTravelMode["MOT"] as? String ?? ""
        let id = self.selectedTravelMode["Sl_No"] as? Int ?? 0
        let hqcode = selectedHeadquarter?["id"] as? String ?? sfCode
        
        let jsonString = "[{\"save_missed_date_trvel_mod\":{\"mode_name\":\"\(name)\",\"mod_id\":\"\(id)\",\"Date_Time\":\"\(date)\",\"Hq_id\":\"\(hqcode)\"}}]"
        
        let params: Parameters = [  "data": jsonString ]
        
        AF.request(url,method: .post,parameters: params).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result {
                
            case .success(let value):
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
    
    
    
    @IBAction func secondaryAction(_ sender: UIButton) {
        
        if UserSetup.shared.SrtEndKMNd == 2{
            if self.selectedRoute == nil {
                Toast.show(message: "Please Select Route", controller: self)
                return
            }
            
            if self.selectedTravelMode == nil {
                Toast.show(message: "Please Select Travel Mode", controller: self)
                return
            }
        }
        
        
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMissedDateRouteSelection") as!  MissedDateRouteSelection
        vc.isFromSecondary = true
        vc.selectedDate = self.selectedDate
        vc.selectedWorktype = self.selectedWorktype
        vc.selectedList = self.secondaryOrderList
        
        if UserSetup.shared.SrtEndKMNd == 2{
            if UserSetup.shared.SF_type != 1 {
                vc.headquarter = self.selectedHeadquarter
            }
            if UserSetup.shared.distributorBased != 0 {
                vc.distributor = self.selectedDistributor
            }
            vc.route = self.selectedRoute
        }
        
        vc.missedDateSubmit = { products in
            print(products)
            
            self.secondaryOrderList = products
            self.navigationController?.popViewController(animated: true)
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func primaryAction(_ sender: UIButton) {
        
        if UserSetup.shared.SrtEndKMNd == 2{
            if self.selectedRoute == nil {
                Toast.show(message: "Please Select Route", controller: self)
                return
            }
            
            if self.selectedTravelMode == nil {
                Toast.show(message: "Please Select Travel Mode", controller: self)
                return
            }
        }
        
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMissedDateRouteSelection") as!  MissedDateRouteSelection
        vc.isFromSecondary = false
        vc.selectedDate = self.selectedDate
        vc.selectedWorktype = self.selectedWorktype
        vc.selectedList = self.primaryOrderList
        if UserSetup.shared.SrtEndKMNd == 2{
            if UserSetup.shared.SF_type != 1 {
                vc.headquarter = self.selectedHeadquarter
            }
            if UserSetup.shared.distributorBased != 0 {
                vc.distributor = self.selectedDistributor
            }
            vc.route = self.selectedRoute
        }
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
        
        let fwflg = self.selectedWorktype?["FWFlg"] as? String ?? ""
        
        if fwflg == "F" {
            if self.secondaryOrderList.isEmpty && self.primaryOrderList.isEmpty {
                Toast.show(message: "Please Select at least One Order", controller: self)
                return
            }
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
                
                if UserSetup.shared.SrtEndKMNd == 2{
                    self.saveTravelMode()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
        
        let remarks = self.txtRemarks.textColor == UIColor.lightGray ? "" : self.txtRemarks.text!
        
        let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"\'\(workTypeCode)\'\",\"Town_code\":\"\'\'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'\(date)\'\",\"workTypFlag_Missed\":\"\(fwflg)\",\"mydayplan\":1,\"mypln_town\":\"\'\'\",\"mypln_town_id\":\"\''\",\"Daywise_Remarks\":\"\(remarks)\",\"eKey\":\"\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"\":\"\'\(sfCode)\'\"}},{\"Activity_Sample_Report\":[]},{\"Trans_Order_Details\":[]},{\"Activity_Input_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]}]"
        
        let params: Parameters = [ "data": jsonString ]
        
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr%2Fsave&divisionCode=\(divCode)&sfCode=\(sfCode)&desig=\(self.desig)")
        print(params)
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=\(divCode)&sfCode=\(sfCode)&desig=\(self.desig)",method: .post,parameters: params).validate(statusCode: 200..<209).responseData { AFData in
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                do {
                    let json = try JSON(data: AFData.data!)
                    print(json)
                    GlobalFunc.movetoHomePage()
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
                
                    if UserSetup.shared.SrtEndKMNd == 2 {
                        self.updateDisplay()
                    }
                
                    
                    self.vwOrderListHeightConstraints.constant = 120
                if (UserSetup.shared.StkNeed != 1) {
                    self.vwOrderListHeightConstraints.constant = 70
                }
                    self.vwOrderList.isHidden = false
                default:
                    self.vwTravelMode.isHidden = true
                    self.vwHeadquarters.isHidden = true
                    self.vwDistributor.isHidden = true
                    self.vwRoutes.isHidden = true
                    
                    self.vwTravelHeightConstraint.constant = 0
                    self.vwOrderListHeightConstraints.constant = 0
                    self.vwOrderList.isHidden = true
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(worktypeVC, animated: true)
    }
    
    @objc private func headquarterAction() {
        
        
        let headquarterVC = ItemViewController(items: lstHQs, configure: { (Cell : SingleSelectionTableViewCell, headquarter) in
            Cell.textLabel?.text = headquarter["name"] as? String
        })
        headquarterVC.title = "Select the Headquarter"
        headquarterVC.didSelect = { selectedHeadquarter in
            print(selectedHeadquarter)
            self.selectedHeadquarter = selectedHeadquarter
            self.updateRoutes(id: selectedHeadquarter["id"] as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(headquarterVC, animated: true)
    }
    
    @objc private func distributorAction() {
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
    
    @objc private func routeAction() {
        let routeVC = ItemViewController(items: lstRoutes, configure: { (Cell : SingleSelectionTableViewCell, route) in
            Cell.textLabel?.text = route["name"] as? String
        })
        routeVC.title = "Select the \(UserSetup.shared.StkRoute)"
        routeVC.didSelect = { selectedRoute in
            print(selectedRoute)
            self.selectedRoute = selectedRoute
            self.navigationController?.popViewController(animated: true)
            
        }
        self.navigationController?.pushViewController(routeVC, animated: true)
    }
    
    @objc private func TravelModeAction() {
        
        if self.selectedRoute == nil {
            Toast.show(message: "Please Select Route", controller: self)
            return
        }
        
        let travelMode = lstModeOfTravel.filter{($0["Alw_Eligibilty"] as? String ?? "").contains(self.selectedRoute["Allowance_Type"] as? String ?? "")}
        
        let travelModeVC = ItemViewController(items: travelMode, configure: { (Cell : SingleSelectionTableViewCell, travelMode) in
            Cell.textLabel?.text = travelMode["MOT"] as? String
        })
        travelModeVC.title = "Select the Travel Mode"
        travelModeVC.didSelect = { selectedTravelMode in
            print(selectedTravelMode)
            self.selectedTravelMode = selectedTravelMode
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(travelModeVC, animated: true)
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
