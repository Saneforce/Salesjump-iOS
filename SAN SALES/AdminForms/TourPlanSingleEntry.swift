//
//  TourPlanSingleEntry.swift
//  SAN SALES
//
//  Created by Naga Prasath on 16/04/24.
//

import Foundation
import UIKit

class TourPlanSingleEntry : UIViewController{
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    var lAllObjSel: [AnyObject] = []
    var lObjSel: [AnyObject] = []
    var lstWType: [AnyObject] = []
    var lstHQs: [AnyObject] = []
    var lstAllRoutes: [AnyObject] = []
    
    var lstDist: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    var lstJoint: [AnyObject] = []
    var lstSelJWNms: [AnyObject] = []
    var lstJWNms: [AnyObject] = []
    
    
    var sfCode = "",divCode = ""
    
    let LocalStoreage = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        
        
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
        let SFName: String=prettyJsonData["sfName"] as? String ?? ""
        
        
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
            lstAllRoutes = list
            lstRoutes = list
        }
        if let JointWData = LocalStoreage.string(forKey: "Jointwork_Master"),
           let list = GlobalFunc.convertToDictionary(text:  JointWData) as? [AnyObject] {
            lstJoint = list;
        }
        
        
    }
    
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
