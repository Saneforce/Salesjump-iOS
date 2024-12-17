//
//  ReportMenu.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 16/06/22.
//

import Foundation
import UIKit

class ReportMenu: IViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tbMenuDetail: UITableView!
    
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var imgProf: UIImageView!
    @IBOutlet weak var lblSFName: UILabel!
    @IBOutlet weak var lblDesig: UILabel!
    @IBOutlet weak var menuClose: UIImageView!
    
    
    
    struct mnuItem: Any {
        let MasId: Int
        let MasName: String
        let MasImage: String
    }
    
    var strMasList:[mnuItem]=[]
    var downloadCount: Int = 0
    let LocalStoreage = UserDefaults.standard
    
    var SFCode: String=""
    var sfName:String = ""
    override func viewDidLoad() {
        getUserDetails()
        let LocalStoreage = UserDefaults.standard
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        strMasList.append(mnuItem.init(MasId: 1, MasName: "Day Report", MasImage: "SwitchRoute"))
        if UserSetup.shared.BrndRvwNd > 0{
            strMasList.append(mnuItem.init(MasId: 2, MasName: "Brand Availability", MasImage: "SwitchRoute"))
        }
        strMasList.append(mnuItem.init(MasId: 3, MasName: "Expense View", MasImage: "SwitchRoute"))
        //strMasList.append(mnuItem.init(MasId: 2, MasName: "Add New Retailer", MasImage: "NewRetailer"))
        //strMasList.append(mnuItem.init(MasId: 11, MasName: "Master Sync", MasImage: "MasterSync"))
        
        strMasList.append(mnuItem.init(MasId: 4, MasName: "TP View", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 5, MasName: "TP View Datewise", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 6, MasName: "My Resources", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 7, MasName: "Attendance Report", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 8, MasName: "Rejected Leave Details", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 9, MasName: "Closing Stock View (DB)", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 10, MasName: "Target vs Sales Analysis", MasImage: "SwitchRoute"))
        if (UserSetup.shared.CL_SS_ND == 1){
            strMasList.append(mnuItem.init(MasId: 11, MasName: "Closing Stock View (SS)", MasImage: "SwitchRoute"))
        }
        strMasList.append(mnuItem.init(MasId: 12, MasName: "Order Details", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 13, MasName: "Day Report With date range", MasImage: "SwitchRoute"))
        if (UserSetup.shared.StkNeed == 1) {
            strMasList.append(mnuItem.init(MasId: 14, MasName: "Distributor Order Details", MasImage: "SwitchRoute"))
        }
        strMasList.append(mnuItem.init(MasId: 15, MasName: " Secondary Order Details", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 16, MasName: "CustomFields", MasImage: "SwitchRoute"))
       
        btnBack.addTarget(target: self, action: #selector(closeMenuWin))
        menuClose.addTarget(target: self, action: #selector(closeMenuWin))
        tbMenuDetail.delegate=self
        tbMenuDetail.dataSource=self
    }
    
    func getUserDetails(){
    let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
    let data = Data(prettyPrintedJson!.utf8)
    guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
    print("Error: Cannot convert JSON object to Pretty JSON data")
    return
    }
    SFCode = prettyJsonData["sfCode"] as? String ?? ""
    sfName = prettyJsonData["sfName"] as? String ?? ""
    }
    @IBAction func userLogout(_ sender: Any) {
        dismiss(animated: true)
        self.dismiss(animated: true, completion: nil)
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let mainTabBarController = storyboard.instantiateViewController(identifier: "sbLogin")
         
         (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strMasList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = strMasList[indexPath.row].MasName
        cell.imgSelect.image = UIImage(named: strMasList[indexPath.row].MasImage)
        cell.vwContainer.layer.cornerRadius = 5
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lItm: mnuItem=strMasList[indexPath.row]
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let storyboard2 = UIStoryboard(name: "Reports 2", bundle: nil)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        if lItm.MasId == 1 {
            
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbDayReport") as! DayReport
           
            viewController.setViewControllers([RptMnuVc,myDyPln], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }
        else if lItm.MasId == 2 {
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let brandAv = storyboard.instantiateViewController(withIdentifier: "brandAV") as! Brand_Availability
            
             viewController.setViewControllers([RptMnuVc,brandAv], animated: false)
             //viewController.navigationController?.pushViewController(myDyPln, animated: true)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
            
        } else if lItm.MasId == 3 {
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            
            if UserSetup.shared.SrtEndKMNd == 2{
                let brandAv = storyboard.instantiateViewController(withIdentifier: "ExpenseviewSFC") as! Expense_View_SFC
                viewController.setViewControllers([RptMnuVc,brandAv], animated: false)
            }else{
                let brandAv = storyboard.instantiateViewController(withIdentifier: "Expenseview") as! Expense_View
                viewController.setViewControllers([RptMnuVc,brandAv], animated: false)
            }
            
            
             //viewController.navigationController?.pushViewController(myDyPln, animated: true)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
            
        }else if lItm.MasId == 4 {
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let tpVwVC = storyboard.instantiateViewController(withIdentifier: "sbTourPlanView") as! TourPlanView
            
             viewController.setViewControllers([RptMnuVc,tpVwVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 5 {
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let tpVwDayVC = storyboard.instantiateViewController(withIdentifier: "sbTourPlanViewDateWise") as! TourPlanViewDateWise
            
             viewController.setViewControllers([RptMnuVc,tpVwDayVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 6 {
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let resVC = storyboard.instantiateViewController(withIdentifier: "sbMyResources") as! MyResources
            
             viewController.setViewControllers([RptMnuVc,resVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 7 {
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let attenReportVC = storyboard.instantiateViewController(withIdentifier: "sbAttendanceReport") as! AttendanceReport
            
             viewController.setViewControllers([RptMnuVc,attenReportVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 8{
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let detailVC = storyboard.instantiateViewController(withIdentifier: "sbRejectedAndCancelledLeaveDetails") as! RejectedAndCancelledLeaveDetails
            
             viewController.setViewControllers([RptMnuVc,detailVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 9{
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let attenReportVC = storyboard.instantiateViewController(withIdentifier: "ClosingStockView__DB_") as! ClosingStockView__DB_
            
             viewController.setViewControllers([RptMnuVc,attenReportVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 10{
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let attenReportVC = storyboard.instantiateViewController(withIdentifier: "Target_vs_Sales_Analysis") as! Target_vs_Sales_Analysis
            
             viewController.setViewControllers([RptMnuVc,attenReportVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 11{
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let attenReportVC = storyboard.instantiateViewController(withIdentifier: "ClosingStockView__SS_") as! ClosingStockView__SS_
            
             viewController.setViewControllers([RptMnuVc,attenReportVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 12{
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let attenReportVC = storyboard2.instantiateViewController(withIdentifier: "Order_Details") as! Order_Details
            
             viewController.setViewControllers([RptMnuVc,attenReportVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 13{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = Foundation.Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            RangeData.shared.Hq_Name = sfName
            RangeData.shared.Hq_Id = SFCode
            RangeData.shared.from_Date = formattedDate
            RangeData.shared.To_Date = formattedDate
            
            
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let attenReportVC = storyboard2.instantiateViewController(withIdentifier: "DAY_REPORT_WITH_DATE_RANGE") as! DAY_REPORT_WITH_DATE_RANGE
            
             viewController.setViewControllers([RptMnuVc,attenReportVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 14{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = Foundation.Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let attenReportVC = storyboard2.instantiateViewController(withIdentifier: "Distributor_Order_Details") as! Distributor_Order_Details
            
             viewController.setViewControllers([RptMnuVc,attenReportVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 15{
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let attenReportVC = storyboard2.instantiateViewController(withIdentifier: "sbSecondaryOrderDetails") as! Secondary_Order_Details
             viewController.setViewControllers([RptMnuVc,attenReportVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 16{
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            let attenReportVC = storyboard.instantiateViewController(withIdentifier: "sbCustomFields") as! CustomFields
             viewController.setViewControllers([RptMnuVc,attenReportVC], animated: false)
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        print(strMasList[indexPath.row].MasName)
    }
    
    @objc func closeMenuWin(){
        GlobalFunc.MovetoMainMenu()
        
    }
}
