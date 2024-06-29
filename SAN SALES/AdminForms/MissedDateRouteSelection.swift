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
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstRetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MissedDateOrderSelectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MissedDateOrderSelectionTableViewCell
        print(lstRetails[indexPath.row])
        cell.lblName.text = lstRetails[indexPath.row]["name"] as? String ?? ""
        cell.btnOrder.addTarget(target: self, action: #selector(orderAction))
        return cell
    }
    
    @objc func orderAction(_ sender : UIButton) {
        
        
        if isFromSecondary == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
            let trPln = storyboard.instantiateViewController(withIdentifier: "sbSecondaryOrder") as! SecondaryOrder
            
            viewController.setViewControllers([trPln], animated: false)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
            let trPln = storyboard.instantiateViewController(withIdentifier: "sbPrimaryOrder") as! PrimaryOrder
            
            viewController.setViewControllers([trPln], animated: false)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
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
            
            self.lstRetails = self.lstAllRetails.filter{($0["id"] as? Int ?? 0) == (self.selectedRoute["id"] as? Int ?? 0)}
            
            self.tableViewOrderList.reloadData()
        }
        self.navigationController?.pushViewController(routeVC, animated: true)
    }
    
    @objc private func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}


class MissedDateOrderSelectionTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnOrder: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
