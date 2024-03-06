//
//  Add Distributor.swift
//  SAN SALES
//
//  Created by San eforce on 04/03/24.
//

import UIKit
import Alamofire

class Add_Distributor: IViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var Head_Dis_Name: UILabel!
    @IBOutlet weak var btnback: UIImageView!
    @IBOutlet weak var Dis_Name: EditTextField!
    @IBOutlet weak var ERP_Code: EditTextField!
    @IBOutlet weak var GST_No: EditTextField!
    @IBOutlet weak var UserName: EditTextField!
    @IBOutlet weak var PassWord: EditTextField!
    @IBOutlet weak var Contact_Person: EditTextField!
    @IBOutlet weak var Mobile_No: EditTextField!
    @IBOutlet weak var Enter_Email: EditTextField!
    @IBOutlet weak var Enter_Add: EditTextField!
    @IBOutlet weak var Typr: LabelSelect!
    @IBOutlet weak var Norm_Value: EditTextField!
    @IBOutlet weak var Field_Off: LabelSelect!
    @IBOutlet weak var ERP_Ma: UILabel!
    @IBOutlet weak var Dis_Hed: UILabel!
    @IBOutlet weak var DisID_Hed: UILabel!
    @IBOutlet weak var SelWindo: UIView!
    @IBOutlet weak var SelWindHed: UILabel!
    @IBOutlet weak var Sub_BT: UIButton!
    @IBOutlet weak var DataTB: UITableView!
    @IBOutlet weak var TextSearch: UITextField!
    @IBOutlet weak var Hed_Typ: LabelSelect!
    
    struct TypData:Codable{
        var Name:String
    }
    var Typs: [TypData] = []
    var lstOfTyp: [TypData] = []
    var lstHQs: [AnyObject] = []
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    var DataSF: String = ""
    var eKey: String = ""
    var lstRetails: [AnyObject] = []
    var lstDists: [AnyObject] = []
    var tlObjSel: [AnyObject] = []
    var SelMod:String = ""
    var HQ_Sf:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        Head_Dis_Name.text = UserSetup.shared.StkCap
        Dis_Name.placeholder = "Enter the \(UserSetup.shared.StkCap) Name"
        Sub_BT.setTitle("Create \(UserSetup.shared.StkCap)", for: .normal)
        Dis_Hed.text = "\(UserSetup.shared.StkCap) Name"
        DisID_Hed.text = "\(UserSetup.shared.StkCap) ID"
        Mobile_No.keyboardType = UIKeyboardType.numberPad
        Norm_Value.keyboardType = UIKeyboardType.numberPad
        DataTB.dataSource = self
        DataTB.delegate = self
        Mobile_No.delegate = self
        if let range =  UserSetup.shared.Mandator.range(of: "erp", options: .caseInsensitive) {
            let position = UserSetup.shared.Mandator.distance(from: UserSetup.shared.Mandator.startIndex, to: range.lowerBound)
            ERP_Ma.isHidden = true
        } else {
            print("Substring 'erp' not found")
        }
        
        
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        DataSF = prettyJsonData["sfCode"] as? String ?? ""
        let SFName: String=prettyJsonData["sfName"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        eKey = String(format: "EK%@-%i", SFCode,Int(Date().timeIntervalSince1970))
        let HQData: String=LocalStoreage.string(forKey: "HQ_Master")!
        if let list = GlobalFunc.convertToDictionary(text: HQData) as? [AnyObject] {
            lstHQs = list;
            var id: String = SFCode
            var name: String = SFName
            if lstHQs.count > 0 {
                let item: [String: Any]=lstHQs[0] as! [String : Any]
                name = item["name"] as! String
                id=String(format: "%@", item["id"] as! CVarArg)
            }
            if(lstHQs.count < 2){
                Hed_Typ.text = name
                Field_Off.text = name
                let DistData: String=LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                let RetailData: String=LocalStoreage.string(forKey: "Retail_Master_"+id)!
                if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                    lstDists = list;
                }
                if let list = GlobalFunc.convertToDictionary(text: RetailData) as? [AnyObject] {
                    lstRetails = list;
                }
            }
            else
            {
              let text = lstHQs[0]["name"] as? String
                Hed_Typ.text = text
                Field_Off.text = text
                Hed_Typ.addTarget(target: self, action: #selector(selHeadquaters))
            }
        }
        
        TypsData()
        Typr.addTarget(target: self, action: #selector(OpenTyp))
        btnback.addTarget(target: self, action: #selector(GotoHomee))
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          guard let currentText = textField.text else {
              return true
          }
          let newLength = currentText.count + string.count - range.length
        return newLength <= Int(UserSetup.shared.Phone_Country_Length)!
      }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (SelMod == "TY"){
            return lstOfTyp.count
        }else if(SelMod == "HQ"){
            return tlObjSel.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if (SelMod == "TY"){
            cell.lblText.text = lstOfTyp[indexPath.row].Name
        }else if (SelMod == "HQ"){
            cell.lblText.text = tlObjSel[indexPath.row]["name"] as? String
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if (SelMod == "TY"){
            Typr.text = lstOfTyp[indexPath.row].Name
        }else if (SelMod == "HQ"){
            let item = tlObjSel[indexPath.row]
            Hed_Typ.text = item["name"] as? String
            Field_Off.text = item["name"] as? String
            HQ_Sf = (item["id"] as? String)!
            
        }
        TextSearch.text = ""
        SelWindo.isHidden = true
    }
    @IBAction func Add_Dis(_ sender: Any) {
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
            self.Create_Dis()
            return
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    func Create_Dis(){
        self.ShowLoading(Message: "Data Submitting Please wait...")
        var Dis = ""
        var ERP = ""
        var GST_NO = ""
        var UserN = ""
        var Pass = ""
        var Contact_Persons = ""
        var Mobile_Number = ""
        var Email = ""
        var Address = ""
        var Type = ""
        var Norm_Values = ""
        var Field_Officer = ""
        if let Diss = Dis_Name.text {
            Dis = Diss
        }
        if let Erp =  ERP_Code.text {
            ERP = Erp
        }
        if let Gst = GST_No.text {
            GST_NO = Gst
        }
        if let User =  UserName.text{
            UserN =  User
        }
        if let password = PassWord.text{
            Pass = password
        }
        if let Cont_Per = Contact_Person.text {
            Contact_Persons = Cont_Per
        }
        if let MobNo = Mobile_No.text {
            Mobile_Number = MobNo
        }
        if let Ent_mail = Enter_Email.text{
            Email = Ent_mail
        }
        if let Ent_Add = Enter_Add.text {
            Address = Ent_Add
        }
        if let Typ = Typr.text{
            Type = Typ
        }
        if let Norm_Val = Norm_Value.text{
            Norm_Values =  Norm_Val
        }
        if let Field = Field_Off.text{
            Field_Officer = Field
        }
        
        let currentDate = Date()
        let timestampInMilliseconds = Int64(currentDate.timeIntervalSinceReferenceDate * 1000)
        let apiKey: String = "dcr/save&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
       
        let jsonString = " [{\"AddnewDistributor\":{\"distributorname\":\"\(Dis)\",\"erp_code\":\"\(ERP)\",\"Username\":\"\(UserN)\",\"Password\":\"\(Pass)\",\"contactpname\":\"\(Contact_Persons)\",\"mobilenumber\":\"\(Mobile_Number)\",\"email\":\"\(Email)\",\"Address\":\"\(Address)\",\"gst\":\"\(GST_NO)\",\"type\":\"\(Type)\",\"normvalue\":\"\(Norm_Values)\",\"fieldofficer\":\"\(Field_Officer)\",\"Sf_HQ\":\"\(UserSetup.shared.Sf_HQ)\",\"Stockist_code\":\"\",\"Sf_code\":\"\(HQ_Sf)\",\"DrKeyId\":\"AD-\(SFCode)-\(timestampInMilliseconds)\"}}]"
        let params: Parameters = [
            "data": jsonString
        ]
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            self.LoadingDismiss()
            switch AFdata.result {
            case .success(let value):
                if let json = value as? [ String:AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = try? JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: AnyObject] else {
                                  print("Error: Could print JSON in String")
                                  return
                              }
                    
                    print(prettyPrintedJson)
                    
                    if let success = prettyPrintedJson["success"] as? Bool, success == false {
                        if let errorMsg = prettyPrintedJson["msg"] as? String {
                            Toast.show(message: errorMsg, controller: self)
                            return
                        }
                    }
                    Toast.show(message: "\(UserSetup.shared.StkCap) Created successfully", controller: self)
                    GlobalFunc.MovetoMainMenu()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
    }
    func validateForm() -> Bool {
        if (Dis_Name.text == "") {
            Toast.show(message: "Enter the \(UserSetup.shared.StkCap) Name", controller: self)
            return false
        }
        if let range =  UserSetup.shared.Mandator.range(of: "erp", options: .caseInsensitive) {
            
        } else {
            print("Substring 'erp' not found")
            if (ERP_Code.text == "") {
                Toast.show(message: "Enter the ERP Code", controller: self)
                return false
            }
        }
        if Enter_Email.text != "" {
            if let Mail = Enter_Email.text {
                print(Mail)
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                let Verf = emailTest.evaluate(with: Mail)
                if Verf == false {
                    Toast.show(message: "Enter the valid email", controller: self)
                }
                return Verf
            }
        }
        if Mobile_No.text != "" {
            let Mobcount = Mobile_No.text!
            let textCount = Mobcount.count
            print(textCount)
            print(Mobcount.count)
            if Mobcount.count != Int(UserSetup.shared.Phone_Country_Length)! {
                Toast.show(message: "Enter the valid Mobile Number", controller: self)
                return false
            }
        }
        return true
    }
    @IBAction func ClosWin(_ sender: Any) {
        TextSearch.text = ""
        SelWindo.isHidden = true
    }
    func TypsData(){
        Typs.removeAll()
        Typs.append(TypData(Name: "Warehouse"))
        Typs.append(TypData(Name: "Stockist"))
    }
    @objc private func GotoHomee() {
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
    @objc private func OpenTyp() {
        SelMod = "TY"
        lstOfTyp = Typs
        SelWindHed.text = "Select the Type"
        DataTB.reloadData()
        SelWindo.isHidden = false
    }
    @objc private func selHeadquaters() {
        SelMod = "HQ"
        tlObjSel=lstHQs
        print(tlObjSel)
        SelWindHed.text="Select the Headquarter"
        DataTB.reloadData()
        SelWindo.isHidden = false
    }
    @IBAction func SerchByText(_ sender: Any) {
        let txtbx: UITextField = sender as! UITextField
        if(SelMod == "TY"){
            if txtbx.text!.isEmpty {
                lstOfTyp = Typs
            }else{
                lstOfTyp = Typs.filter({(product) in
                    let name: String = product.Name
                    return name.lowercased().contains(txtbx.text!.lowercased())
                })
            }
        }else if (SelMod == "HQ"){
            if txtbx.text!.isEmpty {
                tlObjSel=lstHQs
            }else{
                tlObjSel = lstHQs.filter({(product) in
                    let name: String = (product["name"] as? String)!
                    return name.lowercased().contains(txtbx.text!.lowercased())
                })
            }
        }
        DataTB.reloadData()
    }
}
