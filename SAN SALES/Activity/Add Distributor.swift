//
//  Add Distributor.swift
//  SAN SALES
//
//  Created by San eforce on 04/03/24.
//

import UIKit
import Alamofire

class Add_Distributor: IViewController {
    
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
    @IBOutlet weak var Typr: EditTextField!
    @IBOutlet weak var Norm_Value: EditTextField!
    @IBOutlet weak var Field_Off: EditTextField!
    @IBOutlet weak var ERP_Ma: UILabel!
    
    
    @IBOutlet weak var Sub_BT: UIButton!
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        Head_Dis_Name.text = UserSetup.shared.StkCap
        Sub_BT.setTitle("Create \(UserSetup.shared.StkCap)", for: .normal)
        Mobile_No.keyboardType = UIKeyboardType.numberPad
        Norm_Value.keyboardType = UIKeyboardType.numberPad
        if let range =  UserSetup.shared.Mandator.range(of: "erp", options: .caseInsensitive) {
            let position = UserSetup.shared.Mandator.distance(from: UserSetup.shared.Mandator.startIndex, to: range.lowerBound)
            print("Substring 'erp' found at position \(position)")
        } else {
            print("Substring 'erp' not found")
        }
        
        btnback.addTarget(target: self, action: #selector(GotoHome))
        
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
       
        let jsonString = " [{\"AddnewDistributor\":{\"distributorname\":\"\(Dis)\",\"erp_code\":\"\(ERP)\",\"Username\":\"\(UserN)\",\"Password\":\"\(Pass)\",\"contactpname\":\"\(Contact_Persons)\",\"mobilenumber\":\"\(Mobile_Number)\",\"email\":\"\(Email)\",\"Address\":\"\(Address)\",\"gst\":\"\(GST_NO)\",\"type\":\"\(Type)\",\"normvalue\":\"\(Norm_Values)\",\"fieldofficer\":\"\(Field_Officer)\",\"Sf_HQ\":\"\(UserSetup.shared.Sf_HQ)\",\"Stockist_code\":\"\",\"Sf_code\":\"\(SFCode)\",\"DrKeyId\":\"AD-\(SFCode)-\(timestampInMilliseconds)\"}}]"
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
                    Toast.show(message: "\(UserSetup.shared.StkCap) Created successfully", controller: self)
                    print(prettyPrintedJson)
                    self.GotoHome()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
    }
    func validateForm() -> Bool {
        if (Dis_Name.text == "") {
            Toast.show(message: "Enter the Distributor Name", controller: self)
            return false
        }
     
        return true
    }
    @objc private func GotoHome() {
            self.dismiss(animated: true, completion: nil)
            GlobalFunc.MovetoMainMenu()
        }
}
