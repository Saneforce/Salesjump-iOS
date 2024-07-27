//
//  MyResources.swift
//  SAN SALES
//
//  Created by Naga Prasath on 25/07/24.
//

import UIKit


class MyResources : UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var tableViewResourceList: UITableView!
    
    
    struct mnuItem: Any {
        let MasId: Int
        let MasName: String
        let MasImage: String
        let BTC: String
    }
    
    var strMasList:[mnuItem]=[]
    
    var lstRoutes : [AnyObject] = []
    var lstDistList : [AnyObject] = []
    var lstRetails : [AnyObject] = []
    
    var sfCode : String = ""
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        getUserDetails()
        
        
        var subordinateid:String = ""
        if let PlnDets = LocalStoreage.string(forKey: "Mydayplan"),let list = GlobalFunc.convertToDictionary(text:  PlnDets) as? [AnyObject],list.count != 0 {
            subordinateid = (list[0]["subordinateid"] as? String)!
        } else {
            subordinateid = sfCode
        }
       
        if let lstDistData = LocalStoreage.string(forKey: "Distributors_Master_"+subordinateid),
           let list = GlobalFunc.convertToDictionary(text:  lstDistData) as? [AnyObject] {
            lstDistList = list
        }
        
        if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+subordinateid),
           let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
            lstRoutes = list
        }
        
        if let RetailData = LocalStoreage.string(forKey: "Retail_Master_"+subordinateid),
           let list = GlobalFunc.convertToDictionary(text:  RetailData) as? [AnyObject] {
            lstRetails = list
        }
        
        strMasList.append(mnuItem.init(MasId: 1, MasName: "\(UserSetup.shared.drCap) Count", MasImage: "SwitchRoute",BTC: String(lstRetails.count)))
        strMasList.append(mnuItem.init(MasId: 2, MasName: "\(UserSetup.shared.StkCap) Count", MasImage: "SwitchRoute",BTC: String(lstDistList.count)))
        strMasList.append(mnuItem.init(MasId: 3, MasName: "\(UserSetup.shared.StkRoute) Count", MasImage: "SwitchRoute",BTC: String(lstRoutes.count)))
        
        tableViewResourceList.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewResourceList.reloadData()
    }
    
    func getUserDetails(){
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
        print("Error: Cannot convert JSON object to Pretty JSON data")
        return
        }
        sfCode = prettyJsonData["sfCode"] as? String ?? ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strMasList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = strMasList[indexPath.row].MasName
        cell.imgSelect.image = UIImage(named: strMasList[indexPath.row].MasImage)
        cell.Countlbl.text = strMasList[indexPath.row].BTC
        cell.vwContainer.layer.cornerRadius = 5
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lItm: mnuItem=strMasList[indexPath.row]
        if lItm.MasId == 1 {
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMyResourcesRetailerList") as!  MyResourcesRetailerList
            vc.lstRetails = self.lstRetails
            vc.isFromRetailer = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if lItm.MasId == 2 {
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMyResourcesRetailerList") as!  MyResourcesRetailerList
            vc.lstRetails = self.lstRetails
            vc.lstDistList = self.lstDistList
            vc.isFromRetailer = false
            self.navigationController?.pushViewController(vc, animated: true)
        }else if lItm.MasId == 3 {
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMyResourceRoutes") as!  MyResourceRoutes
            vc.lists = self.lstRoutes
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
