
//
//  MasterSync.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 12/03/22.
//

import Foundation
import UIKit
import Alamofire
import UserNotifications
import BackgroundTasks
 class MasterSync: IViewController, UITableViewDelegate, UITableViewDataSource  {
     @IBOutlet weak var tbMasLists: UITableView!
     @IBOutlet weak var btnClearData: UIImageView!
     @IBOutlet weak var btnSyncAll: UIImageView!
     @IBOutlet weak var btnHome: UIImageView!
     
     struct mnuItem: Any {
         let MasId: Int
         let MasName: String
         let MasImage: String
         let StoreKey: String
         let ApiKey: String
         let fromData: [String: Any]
     }
     
     var strMasList:[mnuItem]=[]
     var downloadCount: Int = 0
     var AutoSync: Bool = true
     var SyncKeys: String = ""
     var SyncImgs = [UIImage]()
     let backgroundTaskIdentifier = "com.yourapp.clearData"
     override func viewDidLoad() {
         let LocalStoreage = UserDefaults.standard
         let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
         let data = Data(prettyPrintedJson!.utf8)
         
         guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
         else {
             print("Error: Cannot convert JSON object to Pretty JSON data")
             return
         }
         
         let SFCode: String=prettyJsonData["sfCode"] as? String ?? ""
         let StateCode: String=prettyJsonData["State_Code"] as? String ?? ""
         let desigCode : String = prettyJsonData["desigCode"] as? String ?? ""
         
         strMasList.append(mnuItem.init(MasId: 1, MasName: "Headquarters", MasImage: "mnuPrimary",StoreKey: "HQ_Master", ApiKey: "get/subordinate&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: ["tableName":"subordinate_master","coloumns":"[\"sf_code as id\", \"sf_name as name\"]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 2, MasName: "Worktype List", MasImage: "mnuPrimary",StoreKey: "Worktype_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&rSF="+SFCode,fromData: [
             "tableName": "mas_worktype",
             "coloumns": "[\"type_code as id\", \"Wtype as name\"]",
             "where": "[\"isnull(Active_flag,0)=0\"]",
             "sfCode": "0",
             "orderBy": "[\"name asc\"]",
             "desig": "mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 3, MasName: "Brands List", MasImage: "mnuPrimary",StoreKey: "Brand_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: ["tableName":"category_master","coloumns":"[\"Category_Code as id\", \"Category_Name as name\"]","sfCode":0,"orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 4, MasName: "Products List", MasImage: "mnuPrimary",StoreKey: "Products_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
             "tableName": "product_master",
             "coloumns":"[\"product_code as id\", \"product_name as name\", \"Product_Sl_No as pSlNo\", \"Product_Category cateid\"]","where":"[\"isnull(Product_DeActivation_Flag,0)=0\"]","sfCode":0,"orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         strMasList.append(mnuItem.init(MasId: 5, MasName: "Product Rate Details", MasImage: "mnuPrimary",StoreKey: "ProductsRates_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
             "tableName":"vwProductStateRates","coloumns":"[\"State_Code\",\"Division_Code\",\"Distributor_Price\",\"Product_Detail_Code\"]","where":"[\"isnull(State_Code,0)=24\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 6, MasName: "Tax Details", MasImage: "mnuPrimary",StoreKey: "Tax_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
             "tableName":"TaxMaster","coloumns":"[*]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         strMasList.append(mnuItem.init(MasId: 7, MasName: "Productwise Tax Details", MasImage: "mnuPrimary",StoreKey: "ProductTax_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode+"&State_Code="+StateCode,fromData: [
             "tableName":"ProdTaxDets","coloumns":"[*]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 8, MasName: "Route List", MasImage: "mnuPrimary",StoreKey: "Route_Master_"+SFCode, ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"vwTown_Master_APP","coloumns":"[\"town_code as id\", \"town_name as name\",\"target\",\"min_prod\",\"field_code\",\"stockist_code\",\"Allowance_Type\"]","where":"[\"isnull(Town_Activation_Flag,0)=0\"]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         
         strMasList.append(mnuItem.init(MasId: 9, MasName: "Retailers List", MasImage: "mnuPrimary",StoreKey: "Retail_Master_"+SFCode, ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
         "tableName":"vwDoctor_Master_APP","coloumns":"[\"doctor_code as id\", \"doctor_name as name\",\"town_code\",\"town_name\",\"lat\",\"long\",\"addrs\",\"ListedDr_Address1\",\"ListedDr_Sl_No\",\"Mobile_Number\",\"Doc_cat_code\",\"ContactPersion\",\"Doc_Special_Code\",\"Distributor_Code\",\"Doctor_Code\",\"gst\",\"createdDate\",\"Doctor_Active_flag\",\"ListedDr_Email\",\"Spec_Doc_Code\",\"debtor_code\"]","where":"[\"isnull(Doctor_Active_flag,0)=0\"]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 10, MasName: "Distributors List", MasImage: "mnuPrimary",StoreKey: "Distributors_Master_"+SFCode, ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"vwstockiest_Master_APP","coloumns":"[\"distributor_code as id\", \"stockiest_name as name\",\"town_code\",\"town_name\",\"Addr1\",\"Addr2\",\"City\",\"Pincode\",\"GSTN\",\"lat\",\"long\",\"addrs\",\"Tcode\",\"Dis_Cat_Code\"]","where":"[\"isnull(Stockist_Status,0)=0\"]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 11, MasName: "Supplier List", MasImage: "mnuPrimary",StoreKey: "Supplier_Master_"+SFCode, ApiKey: "get/SupplierMster&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         strMasList.append(mnuItem.init(MasId: 12, MasName: "Channel List", MasImage: "mnuPrimary",StoreKey: "Channel_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"Doctor_Specialty","coloumns":"[\"Specialty_Code as id\", \"Specialty_Name as name\"]","where":"[\"isnull(Deactivate_flag,0)=0\"]","sfCode":0,"orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 13, MasName: "Retail Category List", MasImage: "mnuPrimary",StoreKey: "Category_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"Doctor_Category","coloumns":"[\"Cat_Code as id\", \"Cat_Name as name\"]","where":"[\"isnull(Cat_Flag,0)=0\"]","sfCode":0,"orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 14, MasName: "Retail Class List", MasImage: "mnuPrimary",StoreKey: "Class_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"Mas_Doc_Class","coloumns":"[\"Doc_ClsCode as id\", \"Doc_ClsSName as name\"]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 15, MasName: "Qualification List", MasImage: "mnuPrimary",StoreKey: "Qualification_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"Mas_Doc_Qualification","coloumns":"[\"sf_code as id\", \"sf_name as name\"]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 16, MasName: "Jointwork", MasImage: "mnuPrimary",StoreKey: "Jointwork_Master", ApiKey: "get/jointwork&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"salesforce_master","coloumns":"[\"sf_code as id\", \"sf_name as name\"]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 17, MasName: "Leave Types", MasImage: "mnuPrimary",StoreKey: "LeaveType_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"vwLeaveType","coloumns":"[\"id\",\"name\",\"Leave_Name\"]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 18, MasName: "Remark Templates", MasImage: "mnuPrimary",StoreKey: "Templates_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"vwRmksTemplate","coloumns":"[\"id as id\", \"content as name\"]","where":"[\"isnull(ActFlag,0)=0\"]","sfCode":0,"orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 19, MasName: "My Day Plan", MasImage: "mnuPrimary",StoreKey: "Mydayplan", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"vwMyDayPlan","coloumns":"[\"worktype\",\"FWFlg\",\"sf_member_code as subordinateid\",\"cluster as clusterid\",\"ClstrName\",\"remarks\",\"stockist as stockistid\",\"worked_with_code\",\"worked_with_name\",\"dcrtype\",\"location\",\"name\",\"Sprstk\",\"Place_Inv\",\"WType_SName\",\"convert(varchar,Pln_date,20) plnDate\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 20, MasName: "Allowance Type", MasImage: "mnuPrimary",StoreKey: "AllowanceType", ApiKey: "get/LEOS&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 21, MasName: "Schemes", MasImage: "mnuPrimary",StoreKey: "Schemes_Master", ApiKey: "get/Scheme&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 22, MasName: "Category Rate", MasImage: "mnuPrimary",StoreKey: "CateRate_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"Productcategoryrates","coloumns":"[*]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 23, MasName: "Product Rate", MasImage: "mnuPrimary",StoreKey: "ProductRate_Master", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"vwProductStateRates","coloumns":"[\"State_Code\",\"Division_Code\",\"Distributor_Price\",\"Product_Detail_Code\"]","where":"[\"isnull(State_Code,0)="+StateCode+"\"]","desig":"mgr"
         ]))
         strMasList.append(mnuItem.init(MasId: 24, MasName: "Pending Bills", MasImage: "mnuPrimary",StoreKey: "PendingBills", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"PendingBils","coloumns":"[*]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 25, MasName: "Unit   Conversion", MasImage: "mnuPrimary",StoreKey: "UnitConversion", ApiKey: "get/UnitConversion&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"unitConversion","coloumns":"[*]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 26, MasName: "Payment Modes", MasImage: "mnuPrimary",StoreKey: "Pay_Types", ApiKey: "get/mas_payment&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         strMasList.append(mnuItem.init(MasId: 27, MasName: "Stockist Schemes", MasImage: "mnuPrimary",StoreKey: "Stockist_Schemes", ApiKey: "get/StockistScheme&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode+"&State_Code="+StateCode+"&desig="+desigCode,fromData: [
            "orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 28, MasName: "Random Number", MasImage: "mnuPrimary",StoreKey: "Random_Number", ApiKey: "get/Randomnumber&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode+"&State_Code="+StateCode+"&desig="+desigCode,fromData: [
            "orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 29, MasName: "Subordinate", MasImage: "mnuPrimary",StoreKey: "Subordinates", ApiKey: "get/submgr&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode+"&State_Code="+StateCode+"&desig="+desigCode,fromData: [
            "orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
    
         
         strMasList.append(mnuItem.init(MasId: 30, MasName: "Product Remarks", MasImage: "mnuPrimary",StoreKey: "Product_Remarks", ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode+"&State_Code="+StateCode+"&desig="+desigCode,fromData: [
            "tableName":"vwProductTemplate","coloumns":"[\"id as id\",\"content as name\"]","where":"[\"isnull(ActFlag,0)=0\"]","sfCode":0,"orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 31, MasName: "Competitor Product", MasImage: "mnuPrimary",StoreKey: "Competitor_Product", ApiKey: "get/Mas_RCPA&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode+"&State_Code="+StateCode+"&desig="+desigCode,fromData: [
            "tableName":"Mas_RCPA","coloumns":"[\"sf_code as id\",\"sf_name as name\"]","orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 32, MasName: "Retailer Rate", MasImage: "mnuPrimary",StoreKey: "Retailer_Rate", ApiKey: "get/RetailerwiseRate&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode+"&State_Code="+StateCode+"&desig="+desigCode,fromData: [
            "orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         
         strMasList.append(mnuItem.init(MasId: 33, MasName: "Distributor Rate", MasImage: "mnuPrimary",StoreKey: "Distributor_Rate", ApiKey: "get/stockistRate&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode+"&State_Code="+StateCode+"&desig="+desigCode,fromData: [
            "orderBy":"[\"name asc\"]","desig":"mgr"
         ]))
         

         btnClearData.addTarget(target: self, action: #selector(clearAllData))
         btnSyncAll.addTarget(target: self, action: #selector(callAllApi))
         btnHome.addTarget(target: self, action: #selector(GotoHome))
         
         getAnimImages()
         tbMasLists.delegate=self
         tbMasLists.dataSource=self
         if AutoSync == true {
             callAllApi()
         }
     }
     func getAnimImages(){
         guard let gifData = NSDataAsset(name: "Sync")?.data,
         let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else {
               return
         }
         let imageCount = CGImageSourceGetCount(source)
         for i in 0 ..< imageCount {
             if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                 SyncImgs.append(UIImage(cgImage: image))
             }
         }
     }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return strMasList.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem

        cell.lblText?.text = strMasList[indexPath.row].MasName
        //cell.imgSelect.image = UIImage.animatedImageNamed("Sync", duration: 1)
        
        cell.imgSelect.image = nil
        //cell.imgSelect.animationImages = nil
        let errkey: String = ";e:"+strMasList[indexPath.row].StoreKey + ";"
        let skey: String = ";" + strMasList[indexPath.row].StoreKey + ";"
        if(self.SyncKeys.contains(errkey) == true)
        {
            print(self.SyncKeys + " = " + skey)
            cell.imgSelect?.image = UIImage(named: "warning")
        }
        if(self.SyncKeys.contains(skey) == true){
            
            cell.imgSelect.animationImages = SyncImgs
            cell.imgSelect.startAnimating()
        }
                return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lItm: mnuItem=strMasList[indexPath.row]
        MasSync(apiKey: lItm.ApiKey, aIndex: lItm.MasId, aFormData: lItm.fromData,aStoreKey: lItm.StoreKey)
        print(strMasList[indexPath.row].ApiKey)
    }
    
    @objc func callAllApi(){
       for lItm in strMasList {
           MasSync(apiKey: lItm.ApiKey, aIndex: lItm.MasId, aFormData: lItm.fromData,aStoreKey: lItm.StoreKey)
       }
    }
    @objc func clearAllData(){
       let alert = UIAlertController(title: "Confirmation", message: "Do you want to clear all data?", preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
           self.clearData()
           return
       })
       alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
           return
       })
       self.present(alert, animated: true)
    }
    func clearData(){
//        for lItm in strMasList {
//            UserDefaults.standard.removeObject(forKey: lItm.StoreKey)
//        }
        for lItm in strMasList {
            let storedname =  lItm.StoreKey
            let userDefaults = UserDefaults.standard
            let allItems = userDefaults.dictionaryRepresentation()
            
            for (key, _) in allItems {
                if key.contains(storedname){
                    print(key)
                    UserDefaults.standard.removeObject(forKey: key)
                }
            }
       }
       UserDefaults.standard.removeObject(forKey: "UserLogged")
       UserDefaults.standard.removeObject(forKey: "APPConfig")
       UserDefaults.standard.removeObject(forKey: "UserDetails")
       UserDefaults.standard.removeObject(forKey: "UserSetup")
       self.dismiss(animated: true, completion: nil)
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let mainTabBarController = storyboard.instantiateViewController(identifier: "sbLogin")

       (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    @objc private func GotoHome() {
        self.dismiss(animated: true, completion: nil)
        GlobalFunc.movetoHomePage()
    }
    func MasSync(apiKey: String,aIndex: Any,aFormData: [String: Any],aStoreKey:String) {
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        
        let params: Parameters = [
            "data": jsonString
        ]
        self.SyncKeys = self.SyncKeys.replacingOccurrences(of: ";e:" + aStoreKey + ";", with: "")
        SyncKeys = SyncKeys + ";" + aStoreKey + ";"
        tbMasLists.reloadData()
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey)
        print(params)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            switch AFdata.result
            {
               
                case .success(let json):
                   self.downloadCount += 1
                   guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                       print("Error: Cannot convert JSON object to Pretty JSON data")
                       return
                   }
                   guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                       print("Error: Could print JSON in String")
                       return
                   }

                   print(prettyPrintedJson)
                   self.SyncKeys = self.SyncKeys.replacingOccurrences(of: ";" + aStoreKey + ";", with: "")
                   let LocalStoreage = UserDefaults.standard
                   LocalStoreage.set(prettyPrintedJson, forKey: aStoreKey)
               case .failure(let error):
                   self.downloadCount += 1
                   self.SyncKeys = self.SyncKeys.replacingOccurrences(of: ";" + aStoreKey + ";", with: ";e:" + aStoreKey + ";")
                   print(error.errorDescription!)
                    /*let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                        return
                    })
                    self.present(alert, animated: true)*/
            }
            self.tbMasLists.reloadData()
            if(self.downloadCount >= self.strMasList.count && self.AutoSync == true){
                print("download completed")
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                UIApplication.shared.windows.first?.rootViewController = viewController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
            
        }
    }
    
    //Trigger Night 12:Am
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           requestNotificationAuthorization()
           scheduleDailyNotification()
           scheduleBackgroundTask()
           return true
       }

       func requestNotificationAuthorization() {
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: [.alert, .sound]) { granted, error in
               if granted {
               } else {
               }
           }
       }

       func scheduleDailyNotification() {
           let content = UNMutableNotificationContent()
           content.title = "Clear Data"
           content.body = "It's midnight. Time to clear data."

           var dateComponents = DateComponents()
           dateComponents.hour = 0 // Midnight
           dateComponents.minute = 0

           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

           let request = UNNotificationRequest(identifier: "midnightClearData", content: content, trigger: trigger)

           let center = UNUserNotificationCenter.current()
           center.add(request) { error in
               if let error = error {
               }
           }
       }

       func scheduleBackgroundTask() {
           let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
           request.earliestBeginDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())

           do {
               try BGTaskScheduler.shared.submit(request)
           } catch {
           }
       }

       func applicationDidEnterBackground(_ application: UIApplication) {
           scheduleBackgroundTask()
       }

       func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
       }

       func performBackgroundTask(_ task: BGTask) {
           if task.identifier == backgroundTaskIdentifier {
               clearData()
               
               task.setTaskCompleted(success: true)
           }
       } }


