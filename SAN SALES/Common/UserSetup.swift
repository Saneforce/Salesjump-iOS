//
//  UserSetup.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 12/04/22.
//

import Foundation
class UserSetup{
    static let shared = UserSetup()
    struct item: Any {
        var id: String=""
        var name: String=""
    }
    
    var Fenching: Bool = false
    var PrimaryCaption: String = "Primary Order"
    var SecondaryCaption: String = "Secondary Order"
    var DistBased: Int = 0
    var DistRad: Double = 0
    var OrderMode: item = item()
    func initUserSetup(){
        let SetupStoreage = UserDefaults.standard
        let SetupData: String=SetupStoreage.string(forKey: "UserSetup")!
        var lstSetups: [AnyObject] = []
        if let list = GlobalFunc.convertToDictionary(text: SetupData) as? [AnyObject] {
            lstSetups = list;
        }
        
        SecondaryCaption = lstSetups[0]["EDrCap"] as? String ?? "Secondary Order"
        PrimaryCaption = lstSetups[0]["EStkCap"] as? String ?? "Primary Order"
        DistBased = lstSetups[0]["DistBased"] as? Int ?? 0
        DistRad = lstSetups[0]["DisRad"] as? Double ?? 0
        if(lstSetups[0]["Geo_Fencing"] as? Int == 1){
            Fenching = true
        }else{
            Fenching=false
        }
    }
}
