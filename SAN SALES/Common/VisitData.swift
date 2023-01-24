//
//  VisitData.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 10/04/22.
//

import Foundation
class VisitData{
    static var shared = VisitData()
    struct item: Any {
        var id: String=""
        var name: String=""
    }
    
    var WorkType: String = ""
    var TownCode: String = ""
    var ActivityDate: String = ""
    var Remarks: String = ""
    
    
    var CustID: String = ""
    var CustName: String = ""
    var cInTime: String = ""
    var cOutTime: String = ""
    var Dist: item = item()
    var OrderMode: item = item()
    var VstRemarks: item = item()
    var PayType: item = item()
    var DOP: item = item()
    var PayValue: String = ""
    
    var ProductCart: [AnyObject] = []
    
    func clear(){
        WorkType = ""
        TownCode = ""
        ActivityDate = ""
        Remarks = ""
        
        CustID = ""
        CustName = ""
        cInTime = ""
        cOutTime = ""
        Dist = item()
        OrderMode = item()
        VstRemarks = item()
        ProductCart = []
    }
}
