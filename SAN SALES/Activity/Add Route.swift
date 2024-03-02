//
//  Add Route.swift
//  SAN SALES
//
//  Created by San eforce on 01/03/24.
//

import UIKit
import Alamofire

class Add_Route: IViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    @IBOutlet weak var btnback: UIImageView!
    @IBOutlet weak var WinLbl: UILabel!
    @IBOutlet weak var DataTB: UITableView!
    @IBOutlet weak var SelDis: LabelSelect!
    @IBOutlet weak var SelWindo: UIView!
    @IBOutlet weak var TextSearch: UITextField!
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    var lObjSel: [AnyObject] = []
    var lstPlnDetail: [AnyObject] = []
    var lstCustomers: [AnyObject] = []
    var DataSF: String = ""
    struct customGrp:Codable{
        var FGTableName:String
        var FGroupName:String
        var FieldGroupId:String
    }
    struct customDatas:Codable{
        let Fld_Type : String
        let Field_Name : String
        let Fld_Src_Name : String
        let Fld_Symbol : String
        let FGTableName : String
        let flag : Int
        let FieldGroupId : Int
        let ModuleId : Int
        let Mandate : Int
        let Fld_Src_Field : String
        let Field_Col : String
    }
    enum CustomError: Error {
        case missingFGTableName
        case missingFieldGroupId
        case missingFGroupName
        case Fld_Type
        case Field_Name
        case Fld_Src_Name
        case Fld_Symbol
        case FGTableName
        case flag
        case FieldGroupId
        case ModuleId
        case Mandate
        case Fld_Src_Field
        case Field_Col
    }
    var customGrpData: [customGrp] = []
    var customGetData:[customDatas] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        DataTB.delegate = self
        DataTB.dataSource = self
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
        lstPlnDetail = list;
        }
        DataSF = self.lstPlnDetail[0]["subordinateid"] as! String
        if let lstCustData = LocalStoreage.string(forKey: "Distributors_Master_"+DataSF),
        let list = GlobalFunc.convertToDictionary(text:  lstCustData) as? [AnyObject] {
        lstCustomers = list
        lObjSel = list
        }
        btnback.addTarget(target: self, action: #selector(GotoHome))
        SelDis.addTarget(target: self, action: #selector(SelDistributor))
        //CustomFieldData()
        }
    func getUserDetails(){
    let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
    let data = Data(prettyPrintedJson!.utf8)
    guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
    print("Error: Cannot convert JSON object to Pretty JSON data")
    return
    }
    SFCode = prettyJsonData["sfCode"] as? String ?? ""
    StateCode = prettyJsonData["State_Code"] as? String ?? ""
    DivCode = prettyJsonData["divisionCode"] as? String ?? ""
    Desig=prettyJsonData["desigCode"] as? String ?? ""
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lObjSel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if tableView == DataTB {
            let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
            cell.lblText?.text = item["name"] as? String
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
        print(item)
        self.SelDis.text = item["name"] as? String
        SelWindo.isHidden = true
        
    }
    func saveRoute(){
        let apiKey: String = "dcr/save&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
        let jsonString = "[{\"Addnewroute\":{\"routename\":\"tttttrrrr\",\"Target\":\"400\",\"Populations\":\"155\",\"minprod\":\"sgddfg\",\"Allowance_Type\":\"HQ\",\"Sf_HQ\":\"chennai\",\"Stockist_code\":\"32469\",\"Territory_SName\":\"1635\",\"Sf_code\":\"MR4126\",\"DrKeyId\":\"AR-\(SFCode)-1709355543000\"}}]"
        let params: Parameters = [
            "data": jsonString
        ]
        print(params)
        AF.request(APIClient.shared.BaseURL + APIClient.shared.CustomFieldDB + apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
            case .success(let value):
                if let json = value as? [ String:AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
            
        }
    }
        func CustomFieldData(){
            let apiKey: String = "get/CustomDetails&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)&moduleId=4"
            
            let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
            
            AF.request(APIClient.shared.BaseURL + APIClient.shared.CustomFieldDB + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                AFdata in
                switch AFdata.result {
                    
                case .success(let value):
                    if let json = value as? [ String:AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        print(prettyPrintedJson)
                        if let jsonData = prettyPrintedJson.data(using: .utf8),
                           let customData = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                           let customGroupData = customData["customGrp"] as? [[String: Any]], let customDetData = customData["customData"]  as? [[String: Any]] {
                            for item in customGroupData {
                                do {
                                    guard let FGTableName = item["FGTableName"] as? String else {
                                        throw CustomError.missingFGTableName
                                    }
                                    guard let FieldGroupId = item["FieldGroupId"] as? String else {
                                        throw CustomError.missingFieldGroupId
                                    }
                                    guard let FGroupName = item["FGroupName"] as? String else {
                                        throw CustomError.missingFGroupName
                                    }
                                    customGrpData.append(customGrp(FGTableName: FGTableName, FGroupName: FGroupName, FieldGroupId: FieldGroupId))
                                } catch let error {
                                    print("Error: \(error)")
                                    Toast.show(message:"Error: \(error)")
                                }
                            }
                            for CusdataItem in customDetData{
                                do {
                                    guard let Fld_Type = CusdataItem["Fld_Type"] as? String else{
                                        throw CustomError.Fld_Type
                                    }
                                    guard let Field_Name = CusdataItem["Field_Name"] as? String else{
                                        throw CustomError.Field_Name
                                    }
                                    guard let Fld_Src_Name = CusdataItem["Fld_Src_Name"] as? String else{
                                        throw CustomError.Fld_Src_Name
                                    }
                                    guard let Fld_Symbol = CusdataItem["Fld_Symbol"] as? String else{
                                        throw CustomError.Fld_Symbol
                                    }
                                    guard let FGTableName = CusdataItem["FGTableName"] as? String else{
                                        throw CustomError.FGTableName
                                    }
                                    guard let flag = CusdataItem["flag"] as? Int else{
                                        throw CustomError.flag
                                    }
                                    guard let FieldGroupId = CusdataItem["FieldGroupId"] as? Int else{
                                        throw CustomError.FieldGroupId
                                    }
                                    guard let ModuleId = CusdataItem["ModuleId"] as? Int else{
                                        throw CustomError.ModuleId
                                    }
                                    guard let Mandate = CusdataItem["Mandate"] as? Int else{
                                        throw CustomError.Mandate
                                    }
                                    guard  let Fld_Src_Field = CusdataItem["Fld_Src_Field"] as? String else{
                                        throw CustomError.Fld_Src_Field
                                    }
                                    guard  let Field_Col = CusdataItem["Field_Col"] as? String else {
                                        throw CustomError.Field_Col
                                    }
                                    customGetData.append(customDatas(Fld_Type: Fld_Type, Field_Name: Field_Name, Fld_Src_Name: Fld_Src_Name, Fld_Symbol: Fld_Symbol, FGTableName: FGTableName, flag: flag, FieldGroupId: FieldGroupId, ModuleId: ModuleId, Mandate: Mandate, Fld_Src_Field: Fld_Src_Field, Field_Col: Field_Col))
                                } catch let error{
                                    print("Error: \(error)")
                                    Toast.show(message:"Error: \(error)")
                                }
                            }
                            print(customGetData)
                        }else{
                            Toast.show(message: "Error : No Data in CustomDetails")
                        }
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)
                }
            }
            
        }
        @objc private func GotoHome() {
            self.dismiss(animated: true, completion: nil)
            GlobalFunc.MovetoMainMenu()
        }
    @objc private func SelDistributor() {
        SelWindo.isHidden = false
        WinLbl.text = "Select the Distributor"
        DataTB.reloadData()
    }
    @IBAction func ClosWin(_ sender: Any) {
        SelWindo.isHidden = true
    }
    
    @IBAction func searchBytext(_ sender: Any) {
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            lObjSel = lstCustomers
        }else{
            lObjSel = lstCustomers.filter({(product) in
                let name: String = String(format: "%@", product["name"] as! CVarArg)
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        DataTB.reloadData()
    }
}


