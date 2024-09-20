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
    var BrandReviewVisit: String = "Brand Review"
    var SuperStockistOrder: String = "Super Stockist Order"
    var DistBased: Int = 0
    var BrndRvwNd: Int = 0
    var DistRad: Double = 0
    var Selfie:Int = 0
    var SF_type:Int = 0
    var SF_Name:String = ""
    var offerMode: Int = 0
    var SchemeBased : Int = 0
    var SuperStockistNeed : Int = 0
    var distributorBased : Int = 0
    var tpTargetBased : Int = 0
    var jointWorkNeed : Int = 0
    var Desig:String = ""
    var Sf_HQ:String = ""
    var StkRoute:String = ""
    var AddRoute_Nd:Int = 1
    var AddDistibutor_Nd:Int = 0
    var StkCap:String = ""
    var Mandator:String = ""
    var Phone_Country_Length:String = ""
    var OrderMode: item = item()
    var Division_SName:String = ""
    var CurentMonthPostion:Int = 0
    var exp_auto:Int = 0
    var exp_process_type:Int = 0
    var SrtEndKMNd:Int = 0
    var sf_emp_id:String = ""
    var employeeId: String = ""
    var tpDcrDeviationNeed: Int = 0
    var tpNeed: Int = 0
    var tpRemainderDate: String = ""
    var tpMandatoryNeed: Int = 0
    var Hotel_Bill_Nd:Int = 0
    var SrtNd:Int = 0
    var dsg_code:Int = 0
    var ExpDist_HQ:Int = 0
    var ExpDist_HQEX:Int = 0
    var drCap : String = ""
    var clCap : String = ""
    var clFilter : String = ""
    var productRemark : Int = 0
    var rateEditable : Int = 0
    var Eligibility_Nd:Int = 0
    var ClSaleEntryNd:Int = 0
    var hideClosingStockBatch:Int = 0
    var hideClosingStockMfg:Int = 0
    func initUserSetup(){
        let SetupStoreage = UserDefaults.standard
        let SetupData: String=SetupStoreage.string(forKey: "UserSetup")!
        var lstSetups: [AnyObject] = []
        if let list = GlobalFunc.convertToDictionary(text: SetupData) as? [AnyObject] {
            lstSetups = list;
        }
        print(lstSetups)
        SecondaryCaption = lstSetups[0]["EDrCap"] as? String ?? "Secondary Order"
        PrimaryCaption = lstSetups[0]["EStkCap"] as? String ?? "Primary Order"
        BrandReviewVisit = "Brand Review Visit"
        DistBased = lstSetups[0]["DistBased"] as? Int ?? 0
        BrndRvwNd = Int(lstSetups[0]["outlet_review_need"] as? Double ?? 0)
        DistRad = lstSetups[0]["DisRad"] as? Double ?? 0
        Selfie = lstSetups[0]["Selfie"] as? Int ?? 0
        SF_type = lstSetups[0]["SF_type"] as? Int ?? 0
        offerMode = lstSetups[0]["OfferMode"] as? Int ?? 0
        SchemeBased = lstSetups[0]["scheme_based"] as? Int ?? 0
        SuperStockistNeed = lstSetups[0]["MR_SStockist_Nd"] as? Int ?? 0
        SF_Name = lstSetups[0]["SF_Name"] as? String ?? ""
        Desig = lstSetups[0]["Desig"] as? String ?? ""
        Sf_HQ = lstSetups[0]["Sf_HQ"] as? String ?? ""
        StkRoute = lstSetups[0]["StkRoute"] as? String ?? ""
        AddRoute_Nd = lstSetups[0]["AddRoute_Nd"] as? Int ?? 0
        AddDistibutor_Nd = lstSetups[0]["AddDistibutor_Nd"] as? Int ?? 0
        StkCap = lstSetups[0]["StkCap"] as? String ?? ""
        Mandator = lstSetups[0]["Mandatory"] as? String ?? ""
        Phone_Country_Length = lstSetups[0]["Phone_Country_Length"] as? String ?? ""
        Division_SName = lstSetups[0]["Division_SName"] as? String ?? ""
        exp_auto = lstSetups[0]["exp_auto"] as? Int ?? 0
        exp_process_type = lstSetups[0]["exp_process_type"] as? Int ?? 0
        SrtEndKMNd = lstSetups[0]["SrtEndKMNd"] as? Int ?? 0
        sf_emp_id = lstSetups[0]["sf_emp_id"] as? String ?? ""
        distributorBased = lstSetups[0]["DistBased"] as? Int ?? 0
        tpTargetBased = lstSetups[0]["TP_Target_Based"] as? Int ?? 0
        jointWorkNeed = lstSetups[0]["jointwork"] as? Int ?? 0
        employeeId = lstSetups[0]["Employee_Id"] as? String ?? ""
        tpDcrDeviationNeed = lstSetups[0]["TPDCR_Deviation"] as? Int ?? 0
        tpNeed = lstSetups[0]["TP_ND"] as? Int ?? 0
        tpRemainderDate = lstSetups[0]["TP_Remainder_Date"] as? String ?? ""
        tpMandatoryNeed = lstSetups[0]["TP_Mandatory_ND"] as? Int ?? 0
        Hotel_Bill_Nd = lstSetups[0]["Hotel_Bill_Nd"] as? Int ?? 0
        drCap = lstSetups[0]["DrCap"] as? String ?? ""
        SrtNd = lstSetups[0]["SrtNd"] as? Int ?? 0
        clCap = lstSetups[0]["clcap"] as? String ?? ""
        clFilter = lstSetups[0]["Cl_Filter"] as? String ?? ""
        productRemark = lstSetups[0]["Product_Remark"] as? Int ?? 0
        rateEditable = lstSetups[0]["RateEditable"] as? Int ?? 0
        ExpDist_HQ = lstSetups[0]["ExpDist_HQ"] as? Int ?? 0
        ExpDist_HQEX = lstSetups[0]["ExpDist_HQEX"] as? Int ?? 0
        Eligibility_Nd = lstSetups[0]["Eligibility_Nd"] as? Int ?? 0
        ClSaleEntryNd = lstSetups[0]["ClSaleEntryNd"] as? Int ?? 0
        hideClosingStockBatch = lstSetups[0]["hideClosingStockBatch"] as? Int ?? 0 //0-->need,1-->not need
        hideClosingStockMfg = lstSetups[0]["hideClosingStockMfg"] as? Int ?? 0 // 0-->need,1-->not need
        if(lstSetups[0]["Geo_Fencing"] as? Int == 1){
            Fenching = true
        }else{
            Fenching=false
        }
    }
}


