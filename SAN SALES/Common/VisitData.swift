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
    
    var Nav_id = 0
    var fromdate = ""
    var Todate = ""
    
    
    var CustID: String = ""
    var CustName: String = ""
    var cInTime: String = ""
    var cOutTime: String = ""
    var Sup: item = item()
    var Dist: item = item()
    var OrderMode: item = item()
    var VstRemarks: item = item()
    var PayType: item = item()
    var DOP: item = item()
    var PayValue: String = ""
    
    var ProductCart: [AnyObject] = []
    
    var selectedOrders = [ProductList]()
    
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
