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
    @IBOutlet weak var Route_Text: EditTextField!
    @IBOutlet weak var Allowance_Type: LabelSelect!
    @IBOutlet weak var Target: EditTextField!
    @IBOutlet weak var Populations: EditTextField!
    @IBOutlet weak var Minprod: EditTextField!
    @IBOutlet weak var Add_Rout_Title: UILabel!
    @IBOutlet weak var Sub_BT: UIButton!
    @IBOutlet weak var Route_Name_Hed: UILabel!
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
    struct allowanceList:Codable{
        let id :Int
        let Typ:String
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
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    var lObjSel: [AnyObject] = []
    var lstPlnDetail: [AnyObject] = []
    var lstCustomers: [AnyObject] = []
    var Class_Master: [AnyObject] = []
    var DataSF: String = ""
    var SelMod: String = ""
    var customGrpData: [customGrp] = []
    var customGetData:[customDatas] = []
    var allowance:[allowanceList] = []
    var lOballowance:[allowanceList] = []
    var stk_Code:String = ""
    var Ter_Code:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Add_Rout_Title.text = "Add \(UserSetup.shared.StkRoute)"
        Sub_BT.setTitle("Create \(UserSetup.shared.StkRoute)", for: .normal)
        Route_Text.placeholder = "Enter the \(UserSetup.shared.StkRoute) Name"
        Route_Name_Hed.text = "\(UserSetup.shared.StkRoute) Name"
        getUserDetails()
        DataTB.delegate = self
        DataTB.dataSource = self
        Populations.keyboardType = UIKeyboardType.numberPad
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
        lstPlnDetail = list;
        }
        DataSF = self.lstPlnDetail[0]["subordinateid"] as! String
        if let lstCustData = LocalStoreage.string(forKey: "Distributors_Master_"+DataSF),
        let list = GlobalFunc.convertToDictionary(text:  lstCustData) as? [AnyObject] {
        lstCustomers = list
        lObjSel = list
            print(list)
        }
        if let lstCustData = LocalStoreage.string(forKey: "Class_Master"),
        let list = GlobalFunc.convertToDictionary(text:  lstCustData) as? [AnyObject] {
        Class_Master = list
        print(Class_Master)
        }
        allowancData()
        
        btnback.addTarget(target: self, action: #selector(GotoHome))
        SelDis.addTarget(target: self, action: #selector(SelDistributor))
        Allowance_Type.addTarget(target: self, action: #selector(SelAllowance))
        
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
        if tableView == DataTB {
            if (SelMod == "DIS"){
                return lObjSel.count
            }else if (SelMod == "AlW"){
                return lOballowance.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if tableView == DataTB {
            if (SelMod == "DIS"){
                let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
                print(lObjSel)
                cell.lblText?.text = item["name"] as? String
            }else if (SelMod == "AlW"){
                cell.lblText?.text = lOballowance[indexPath.row].Typ
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (SelMod == "DIS"){
        let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
        self.SelDis.text = item["name"] as? String
            stk_Code = String((item["id"] as? Int)!)
            Ter_Code = ((item["Tcode"] as? String)!)
        }else if (SelMod == "AlW"){
        self.Allowance_Type.text = lOballowance[indexPath.row].Typ
        }
        TextSearch.text = ""
        SelWindo.isHidden = true
        
    }
    func validateForm() -> Bool {
        if (SelDis.text == "Select Distributor") {
            Toast.show(message: "Select Distributor", controller: self)
            return false
        }
        if (Route_Text.text == ""){
            Toast.show(message: "Enter \(UserSetup.shared.StkRoute) name", controller: self)
            return false
        }
        return true
    }
    
    
    @IBAction func Create_Route(_ sender: Any) {
        
        if validateForm() == false {
            return
        }
        if(NetworkMonitor.Shared.isConnected != true){
            let alert = UIAlertController(title: "Information", message: "Check the Internet Connection", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                     return
                 })
                 self.present(alert, animated: true)
                return
        }
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.Route_Sub()
            return
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)

    }
    func Route_Sub(){
        self.ShowLoading(Message: "Data Submitting Please wait...")
        var Dis = ""
        var Rou = ""
        var Allowance = ""
        var Targett = ""
        var Populationss = ""
        var Min = ""
        if let DisNAME = SelDis.text {
            Dis = DisNAME
        }
        if let Rou2 = Route_Text.text{
            Rou = Rou2
        }
        if let Allowances = Allowance_Type.text{
            Allowance = Allowances
        }
        if let Targets = Target.text{
            Targett = Targets
        }
        if let Population = Populations.text{
            Populationss = Population
        }
        if let Mins = Minprod.text{
            Min = Mins
        }
        let currentDate = Date()
        let timestampInMilliseconds = Int64(currentDate.timeIntervalSinceReferenceDate * 1000)
        let apiKey: String = "dcr/save&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
        let jsonString = "[{\"Addnewroute\":{\"routename\":\"\(Rou)\",\"Target\":\"\(Targett)\",\"Populations\":\"\(Populationss)\",\"minprod\":\"\(Min)\",\"Allowance_Type\":\"\(Allowance)\",\"Sf_HQ\":\"\(UserSetup.shared.Sf_HQ)\",\"Stockist_code\":\"\(stk_Code)\",\"Territory_SName\":\"\(Ter_Code)\",\"Sf_code\":\"\(SFCode)\",\"DrKeyId\":\"AR-\(SFCode)-\(timestampInMilliseconds)\"}}]"
        let params: Parameters = [
            "data": jsonString
        ]
        AF.request(APIClient.shared.BaseURL + APIClient.shared.CustomFieldDB + apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            self.LoadingDismiss()
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
                    Toast.show(message: "\(UserSetup.shared.StkRoute) Created successfully", controller: self)
                    print(prettyPrintedJson)
                    self.GotoHome()
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
    func allowancData(){
        if Class_Master.isEmpty{
            print("No Data")
        }else{
            allowance.append(allowanceList(id: 1, Typ: "EX"))
            allowance.append(allowanceList(id: 2, Typ: "HQ"))
            allowance.append(allowanceList(id: 3, Typ: "OS"))
            allowance.append(allowanceList(id: 4, Typ: "OX"))
        }
        print(allowance)
    }
    @objc private func GotoHome() {
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to Back?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
            GlobalFunc.MovetoMainMenu()
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
        }
    @objc private func SelDistributor() {
        lObjSel = lstCustomers
        SelMod = "DIS"
        SelWindo.isHidden = false
        WinLbl.text = "Select the Distributor"
        DataTB.reloadData()
    }
    @objc private func SelAllowance() {
        lOballowance = allowance
        SelMod = "AlW"
        SelWindo.isHidden = false
        WinLbl.text = "Select allowance type"
        print(lObjSel)
        DataTB.reloadData()
    }
    @IBAction func ClosWin(_ sender: Any) {
        TextSearch.text = ""
        SelWindo.isHidden = true
    }
    
    @IBAction func searchBytext(_ sender: Any) {
        let txtbx: UITextField = sender as! UITextField
        if (SelMod == "DIS"){
            if txtbx.text!.isEmpty {
            lObjSel = lstCustomers
        }else{
            lObjSel = lstCustomers.filter({(product) in
                let name: String = String(format: "%@", product["name"] as! CVarArg)
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        }else if (SelMod == "AlW"){
            if txtbx.text!.isEmpty {
            lOballowance = allowance
        }else{
            lOballowance = allowance.filter({(product) in
                let name: String = product.Typ
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        }
        DataTB.reloadData()
    }
}


