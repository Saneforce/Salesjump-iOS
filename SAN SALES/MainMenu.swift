//
//  MainMenu.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 21/04/22.
//

import Foundation
import UIKit

extension Notification.Name {
    static let didRegistered = Notification.Name("didRegistered")
}

class MainMenu: IViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tbMenuDetail: UITableView!
    
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
        
        let SFName: String=prettyJsonData["sfName"] as? String ?? ""
        let Desig: String=prettyJsonData["desigCode"] as? String ?? ""
        lblSFName.text = SFName
        lblDesig.text = Desig
        imgProf.layer.cornerRadius = 10
        
        strMasList.append(mnuItem.init(MasId: 1, MasName: "Switch Route", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 2, MasName: "Add New Retailer", MasImage: "NewRetailer"))
       /* strMasList.append(mnuItem.init(MasId: 3, MasName: "Edit Retailer", MasImage: "EditRetailer"))
        strMasList.append(mnuItem.init(MasId: 4, MasName: "Submitted Calls", MasImage: "SubmittedCalls"))
        strMasList.append(mnuItem.init(MasId: 5, MasName: "Order Confirmation", MasImage: "OrderConfirm"))*/
        strMasList.append(mnuItem.init(MasId: 6, MasName: "Admin Forms", MasImage: "AdminForms"))
       /* strMasList.append(mnuItem.init(MasId: 7, MasName: "Outbox", MasImage: "Outbox"))*/
        strMasList.append(mnuItem.init(MasId: 8, MasName: "Reports", MasImage: "Reports"))
        strMasList.append(mnuItem.init(MasId: 9, MasName: "GEO Tagging", MasImage: "GEOTag"))/*
        strMasList.append(mnuItem.init(MasId: 10, MasName: "Closing Stock Entry", MasImage: "ClosingStock"))*/
        strMasList.append(mnuItem.init(MasId: 11, MasName: "Master Sync", MasImage: "MasterSync"))
        strMasList.append(mnuItem(MasId:12, MasName: "Submitted Calls", MasImage: "SubmittedCalls"))
        
        menuClose.addTarget(target: self, action: #selector(closeMenuWin))
        tbMenuDetail.delegate=self
        tbMenuDetail.dataSource=self
        NotificationCenter.default.addObserver(self, selector: #selector(onDidRegistered(_:)), name: .didRegistered, object: nil)

    }
    @IBAction func userLogout(_ sender: Any) {
        //dismissedAllAlert()
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want Logout ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "UserLogged")
            self.dismiss(animated: true)
            /*{
                
                NotificationCenter.default.post(name: .didRegistered, object: nil)
            }
            */
            self.dismiss(animated: true, completion: nil)
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let mainTabBarController = storyboard.instantiateViewController(identifier: "sbLogin")
             
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    @objc func onDidRegistered(_ notification: Notification) {
       
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        if lItm.MasId == 1 {
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbMydayplan") as! MydayPlanCtrl
            viewController.setViewControllers([myDyPln], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 2 {
            let Homevc = storyboard.instantiateViewController(withIdentifier: "HomePageVwControl") as! HomePageViewController
            let addCus = storyboard.instantiateViewController(withIdentifier: "AddNewRetailer") as! AddNewCustomer
            viewController.setViewControllers([Homevc, addCus], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }else if lItm.MasId == 6{
            let rptstoryboard = UIStoryboard(name: "AdminForms", bundle: nil)
            let RptMnuVc = rptstoryboard.instantiateViewController(withIdentifier: "sbAdminMnu") as! AdminMenus
            viewController.setViewControllers([RptMnuVc], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }else if lItm.MasId == 8{
            let rptstoryboard = UIStoryboard(name: "Reports", bundle: nil)
            let RptMnuVc = rptstoryboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            viewController.setViewControllers([RptMnuVc], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }else if lItm.MasId == 9 {
            let Homevc = storyboard.instantiateViewController(withIdentifier: "HomePageVwControl") as! HomePageViewController
            let geoTag = storyboard.instantiateViewController(withIdentifier: "sbGeoTagging") as! GEOTagging
            viewController.setViewControllers([Homevc, geoTag], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }else if lItm.MasId == 11 {
            let MasSync = storyboard.instantiateViewController(withIdentifier: "MasterSyncVwControl") as! MasterSync
            MasSync.AutoSync = false
            viewController.setViewControllers([MasSync], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }
        else if lItm.MasId == 12 {
           // let rptstoryboard = UIStoryboard(name: "Submittedcalls", bundle: nil)
//            let Homevc = storyboard.instantiateViewController(withIdentifier: "HomePageVwControl") as! HomePageViewController
            let SBCalls = storyboard.instantiateViewController(withIdentifier: "SubmittedCalls") as! SubmittedCalls
            viewController.setViewControllers([SBCalls], animated: false)
            
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        print(strMasList[indexPath.row].MasName)
    }
    
    @objc func closeMenuWin(){
        dismiss(animated: false)
        
    }
}

  
