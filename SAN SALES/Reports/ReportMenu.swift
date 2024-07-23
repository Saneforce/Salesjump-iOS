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
    
    override func viewDidLoad() {
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
        
        btnBack.addTarget(target: self, action: #selector(closeMenuWin))
        menuClose.addTarget(target: self, action: #selector(closeMenuWin))
        tbMenuDetail.delegate=self
        tbMenuDetail.dataSource=self
        

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
        }
        /*else if lItm.MasId == 2 {
            let Homevc = storyboard.instantiateViewController(withIdentifier: "HomePageVwControl") as! HomePageViewController
            let addCus = storyboard.instantiateViewController(withIdentifier: "AddNewRetailer") as! AddNewCustomer
            viewController.setViewControllers([Homevc, addCus], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }else if lItm.MasId == 11 {
            let MasSync = storyboard.instantiateViewController(withIdentifier: "MasterSyncVwControl") as! MasterSync
            MasSync.AutoSync = false
            viewController.setViewControllers([MasSync], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }*/
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        print(strMasList[indexPath.row].MasName)
    }
    
    @objc func closeMenuWin(){
        GlobalFunc.MovetoMainMenu()
        
    }
}
