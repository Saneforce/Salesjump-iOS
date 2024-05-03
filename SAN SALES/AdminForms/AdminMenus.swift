//
//  AdminMenus.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 19/10/22.
//

import Foundation
import UIKit

class AdminMenus: IViewController, UITableViewDelegate, UITableViewDataSource  {
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
        
        strMasList.append(mnuItem.init(MasId: 1, MasName: "Apply Leave", MasImage: "SwitchRoute"))
        //strMasList.append(mnuItem.init(MasId: 2, MasName: "Expense Entry", MasImage: "SwitchRoute"))
        //strMasList.append(mnuItem.init(MasId: 2, MasName: "Add New Retailer", MasImage: "NewRetailer"))
        //strMasList.append(mnuItem.init(MasId: 11, MasName: "Master Sync", MasImage: "MasterSync"))
        
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
        let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        if lItm.MasId == 1 {
            
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbAdminMnu") as! AdminMenus
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbLeaveFrm") as! LeaveForm
            viewController.setViewControllers([RptMnuVc,myDyPln], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 2 {
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "sbAdminMnu") as! AdminMenus
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "Expense") as! Expense_Entry
            viewController.setViewControllers([RptMnuVc,myDyPln], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }
        print(strMasList[indexPath.row].MasName)
    }
    
    @objc func closeMenuWin(){
        GlobalFunc.MovetoMainMenu()
    }
}
