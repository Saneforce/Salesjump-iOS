//
//  Approval Menu.swift
//  SAN SALES
//
//  Created by San eforce on 26/04/24.
//

import UIKit

class Approval_Menu: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var tbMenuDetail: UITableView!
    @IBOutlet weak var menuClose: UIImageView!
    struct mnuItem: Any {
        let MasId: Int
        let MasName: String
        let MasImage: String
    }
    
    var strMasList:[mnuItem]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.addTarget(target: self, action: #selector(closeMenuWin))
        menuClose.addTarget(target: self, action: #selector(closeMenuWin))
        //strMasList.append(mnuItem.init(MasId: 1, MasName: "Expense Approval", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 2, MasName: "New Expense Approval", MasImage: "SwitchRoute"))
        tbMenuDetail.delegate=self
        tbMenuDetail.dataSource=self
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
        let storyboard = UIStoryboard(name: "Approval", bundle: nil)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        if lItm.MasId == 1{
            
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "ApprovalMenu") as! Approval_Menu
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "ExpenseApproval") as! Expense_Approval
            viewController.setViewControllers([RptMnuVc,myDyPln], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if (lItm.MasId == 2){
            let RptMnuVc = storyboard.instantiateViewController(withIdentifier: "ApprovalMenu") as! Approval_Menu
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "New_Expense_apr") as! New_Expense_Approval
            viewController.setViewControllers([RptMnuVc,myDyPln], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }
    }
    
    @objc func closeMenuWin(){
        GlobalFunc.MovetoMainMenu()
    }
}
