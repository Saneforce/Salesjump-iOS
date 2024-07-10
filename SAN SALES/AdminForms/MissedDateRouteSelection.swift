//
//  MissedDateRouteSelection.swift
//  SAN SALES
//
//  Created by Naga Prasath on 18/06/24.
//

import Foundation
import UIKit

class MissedDateRouteSelection : IViewController , UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var lblHeadquarters: LabelSelect!
    @IBOutlet weak var lblDistributor: LabelSelect!
    @IBOutlet weak var lblRoutes: LabelSelect!
    @IBOutlet weak var tableViewOrderList: UITableView!
    
    var isFromSecondary : Bool!
    
    var lstHQs: [AnyObject] = []
    
    var lstDist: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    
    var lstAllRetails: [AnyObject] = []
    var lstRetails : [AnyObject] = []
    
    var sfCode = "",divCode = "",desig = "", sfName = "",stateCode = ""
    let LocalStoreage = UserDefaults.standard
    
    var retailerList = [RetailerList]()
    var selectedList = [RetailerList]()
    var allRetailerList = [RetailerList]()
    
    var selectedHeadquarter : AnyObject! {
        didSet {
            self.lblHeadquarters.text = selectedHeadquarter["name"] as? String
            
            self.selectedDistributor = nil
            lblDistributor.text = "Select the \(UserSetup.shared.StkCap)"
            
        }
    }
    
    var selectedDistributor : AnyObject? {
        didSet {
            self.lblDistributor.text = selectedDistributor?["name"] as? String
        }
    }
    
    var selectedRoute : AnyObject! {
        didSet {
            self.lblRoutes.text = selectedRoute?["name"] as? String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBack.addTarget(target: self, action: #selector(backVC))
        lblHeadquarters.addTarget(target: self, action: #selector(headquarterAction))
        lblDistributor.addTarget(target: self, action: #selector(distributorAction))
        lblRoutes.addTarget(target: self, action: #selector(routeAction))
        getUserDetails()
        
        if UserSetup.shared.SF_type != 1 {
            if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
               let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
                lstHQs = list
            }
        }
        
        if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+sfCode),
           let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
            lstDist = list;
        }
        
        if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+sfCode),
           let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
            lstRoutes = list
            
        }
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
    
    func updateRetailer(retailers : [AnyObject]) {
        
        for retailer in retailers {
            
            let name = String(format: "%@", retailer["name"] as! CVarArg)
            let id = String(format: "%@", retailer["id"] as! CVarArg)
            let townCode = String(format: "%@", retailer["town_code"] as! CVarArg)
            
            self.allRetailerList.append(RetailerList(id: id,name: name,townCode: townCode, isSelected: false,retailer: retailer))
        }
        
        
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
                }
                if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                    self.lstRoutes = list
                }
                
                if let list = GlobalFunc.convertToDictionary(text: RetailData) as? [AnyObject] {
                    lstAllRetails = list
                    self.updateRetailer(retailers: list)
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
                    }
                    
                    if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                        lstRoutes = list
                    }
                }
                
                if let lstRetailData = LocalStoreage.string(forKey: "Retail_Master_"+id),
                   let list = GlobalFunc.convertToDictionary(text:  lstRetailData) as? [AnyObject] {
                    lstAllRetails = list
                    self.updateRetailer(retailers: list)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retailerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MissedDateOrderSelectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MissedDateOrderSelectionTableViewCell
       
        cell.lblName.text = retailerList[indexPath.row].name // lstRetails[indexPath.row]["name"] as? String ?? ""
        cell.btnSelect.isSelected = retailerList[indexPath.row].isSelected
        cell.btnOrder.addTarget(target: self, action: #selector(orderAction))
        cell.btnOrder.addTarget(self, action: #selector(orderAction(_:)), for: .touchUpInside)
        cell.btnSelect.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
        cell.heightVwRemarksConstrainst.constant = retailerList[indexPath.row].isSelected == true ? 125 : 0
        cell.btnOrder.isHidden = retailerList[indexPath.row].isSelected == true ? false : true
        return cell
    }
    
    @objc func selectAction(_ sender : UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableViewOrderList)
        guard let indexPath = self.tableViewOrderList.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        let retailer = retailerList[indexPath.row]
        
        retailerList[indexPath.row].isSelected = !retailerList[indexPath.row].isSelected
        
        self.tableViewOrderList.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc func orderAction(_ sender : UIButton) {
        
        
        if isFromSecondary == true {

            let secondaryOrder = UIStoryboard.secondaryOrder
            secondaryOrder.isFromMissedEntry = true
            secondaryOrder.missedDateSubmit = { paramString in
                print(paramString)
                self.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.pushViewController(secondaryOrder, animated: true)
            
        }else {

            
            let primaryOrder = UIStoryboard.primaryOrder
            primaryOrder.isFromMissedEntry = true
            primaryOrder.missedDateSubmit = { paramString in
                print(paramString)
                self.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.pushViewController(primaryOrder, animated: true)
        }
     
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
            
            self.retailerList = self.allRetailerList.filter{$0.townCode == "\(self.selectedRoute["id"] as? String ?? "")"}
            
            self.tableViewOrderList.reloadData()
        }
        self.navigationController?.pushViewController(routeVC, animated: true)
    }
    
    @objc private func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MissedDateRouteSelection: UITextViewDelegate{
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

class MissedDateOrderSelectionTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnOrder: UIButton!
    
    
    @IBOutlet weak var heightVwRemarksConstrainst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


struct SecondaryOrderList {
    
    var headquarterId : String!
    var distributorId : String!
    var routeId : String!
    
    var params : String!
}

struct RetailerList {
    
    var id : String!
    var name : String!
    var townCode : String!
    var isSelected : Bool!
    var retailer : AnyObject!
}






extension UIStoryboard {
    
    static var adminForms: UIStoryboard {
        return UIStoryboard(name: "AdminForms", bundle: nil)
    }
    
    static var main : UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    
    static var secondaryOrder:SecondaryOrder {
        guard let secondaryOrder = UIStoryboard.main.instantiateViewController(withIdentifier: "sbSecondaryOrder") as? SecondaryOrder else {
            fatalError("SecondaryOrder couldn't be found in Storyboard file")
        }
        return secondaryOrder
    }
    
    static var primaryOrder: PrimaryOrder {
        guard let primaryOrder = UIStoryboard.main.instantiateViewController(withIdentifier: "sbPrimaryOrder") as? PrimaryOrder else {
            fatalError("primaryOrder couldn't be found in Storyboard file")
        }
        return primaryOrder
    }
}
