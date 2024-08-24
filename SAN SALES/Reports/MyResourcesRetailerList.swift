//
//  MyResourcesRetailerList.swift
//  SAN SALES
//
//  Created by Naga Prasath on 26/07/24.
//

import Foundation
import UIKit


class MyResourcesRetailerList : UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var tableViewRetailerList: UITableView!
    
    var lstRetails : [AnyObject] = []
    var lstDistList : [AnyObject] = []
    var isFromRetailer : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromRetailer == true{
            return lstRetails.count
        }else {
            return lstDistList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if isFromRetailer == true {
            cell.lblText.text = "\(indexPath.row+1). " + "\(lstRetails[indexPath.row]["name"] as? String ?? "")"
            cell.lblText2.text = lstRetails[indexPath.row]["town_name"] as? String ?? ""
            cell.vwContainer.layer.borderColor = UIColor.black.cgColor
            cell.vwContainer.layer.borderWidth = 1
            cell.vwContainer.layer.masksToBounds = true
            cell.Card_View.isHidden = true
        }else {
            cell.lblText.text = "\(indexPath.row+1). " + "\(lstDistList[indexPath.row]["name"] as? String ?? "")"
            cell.lblText2.text = lstDistList[indexPath.row]["town_name"] as? String ?? ""
            
            let retailers = lstRetails.filter{($0["Distributor_Code"] as? String ?? "").contains(String(lstDistList[indexPath.row]["id"] as? Int ?? 0))}
            
            cell.Countlbl.text = retailers.count.description
            cell.vwContainer.layer.borderColor = UIColor.black.cgColor
            cell.vwContainer.layer.borderWidth = 1
            cell.vwContainer.layer.masksToBounds = true
            cell.Card_View.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromRetailer == true {
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbPrecallAnalysis") as!  PrecallAnalysis
            vc.retailer = lstRetails[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let retailers = lstRetails.filter{($0["Distributor_Code"] as? String ?? "").contains(String(lstDistList[indexPath.row]["id"] as? Int ?? 0))}
            
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMyResourceRoutes") as!  MyResourceRoutes
            vc.lists = retailers
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
