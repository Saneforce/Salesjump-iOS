//
//  End Expense.swift
//  SAN SALES
//
//  Created by San eforce on 28/03/24.
//

import UIKit
import Alamofire
import FSCalendar
import Foundation
import CoreLocation
class End_Expense:IViewController {
    
    @IBOutlet weak var Calender_View: UIView!
    
    @IBOutlet weak var BT_Back: UIImageView!
    @IBOutlet weak var End_Expense_Scr: UILabel!
    @IBOutlet weak var Select_Date: LabelSelect!
    @IBOutlet weak var From_plc: UILabel!
    @IBOutlet weak var To_plc: UILabel!
    @IBOutlet weak var Start_KM: UILabel!
    @IBOutlet weak var Mode_OF_Trav: UILabel!
    @IBOutlet weak var Start_Text_KM: EditTextField!
    @IBOutlet weak var Start_Photo: UILabel!
    @IBOutlet weak var Ending_Fare: EditTextField!
    @IBOutlet weak var Ending_fare_Photo: UILabel!
    @IBOutlet weak var Ending_rmk: UITextView!
    @IBOutlet weak var Per_KM: EditTextField!
    
    //views
    @IBOutlet weak var Date_View: UIView!
    @IBOutlet weak var End_Attachment: UIView!
    //Hight
    @IBOutlet weak var Date_View_Hight: NSLayoutConstraint!
    @IBOutlet weak var End_Attachmeni_Height: NSLayoutConstraint!
    
    struct End_exData:Codable{
        let From:String
        let To_Plce:String
        let Start_KM:String
        let Mode_Of_Travel:String
    }
    
    var SelMod:String = ""
    var End_exp_title:String?
    var Date_Nd:Bool?
    var Date:String?
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = "",SF_type: String = ""
    let LocalStoreage = UserDefaults.standard
    var end_Exp_Datas:[End_exData]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        End_Expense_Scr.text = End_exp_title
        if Date_Nd == true{
        Date_View.isHidden = true
        Date_View_Hight.constant = 0
        }
        BT_Back.addTarget(target: self, action: #selector(GotoHome))
        Select_Date.addTarget(target: self, action: #selector(Opencalender))
        Start_Photo.addTarget(target: self, action: #selector(openCamera_Km))
        Ending_fare_Photo.addTarget(target: self, action: #selector(openCamera_Ending))
        Start_Photo.layer.cornerRadius = 5
        Start_Photo.layer.masksToBounds = true
        Ending_fare_Photo.layer.cornerRadius = 5
        Ending_fare_Photo.layer.masksToBounds = true
        From_plc.text = "no data"
        To_plc.text = "no data"
        Start_KM.text = "no data"
        Mode_OF_Trav.text = "no data"
        if Date != ""{
            Select_Date.text = Date
            srtExpenseData(Select_date:Date!)
        }
        End_exp_date()
        //srtExpenseData()
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
    SF_type=prettyJsonData["SF_type"] as? String ?? ""
    }
    @objc private func GotoHome() {
        if (End_exp_title == "Day End Plan"){
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
            UIApplication.shared.windows.first?.rootViewController = viewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }else{
            GlobalFunc.MovetoMainMenu()
        }
    }
    @objc private func Opencalender(){
        Calender_View.isHidden = false
    }
    @objc private func openCamera_Km(){
        SelMod = "KM"
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "PhotoGallary") as!  PhotoGallary
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @objc private func openCamera_Ending(){
        SelMod = "Ending"
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "PhotoGallary") as!  PhotoGallary
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func Close_Calender_View(_ sender: Any) {
        Calender_View.isHidden = true
    }
    func validate() -> Bool {
        if Select_Date.text == "Select Date"{
            Toast.show(message: "Select Date", controller: self)
            return false
        }
        
        if Start_Text_KM.text == ""{
            Toast.show(message: "Enter Starting KM", controller: self)
            return false
        }
        
        if Ending_Fare.text == "" {
            Toast.show(message: "Enter Ending Fare", controller: self)
            return false
        }
    
        if Ending_rmk.text == ""{
            Toast.show(message: "Enter Ending Remarks", controller: self)
            return false
        }
        
        if Per_KM.text == ""{
            Toast.show(message: "Enter Personal KM", controller: self)
            return false
        }
        
        return true
    }
    @IBAction func Save_Data(_ sender: Any) {
        
        if validate() == false {
            return
        }
        
        let axn = "post/endDayExpense"
        let apiKey = "\(axn)&date=2024-4-1&desig=\(Desig)&fare=&rSF=\(SFCode)&endRemarks=&divisionCode=\(DivCode)&date_time=2024-04-01%2011%3A15%3A24&imageUrl=&sfCode=\(SFCode)&stateCode=\(StateCode)&personalKM=&endModID=Car&sf_code=\(SFCode)&endEntry=1&endKM=58"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                if let json = value as? [[String: Any]] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could not print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
        Toast.show(message:"No data" )
    }
    
    func End_exp_date(){
        let dateFormatter = DateFormatter()
        let date = Foundation.Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    
        //  Start of Month
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = Calendar.current.date(from: comp)!
        print(dateFormatter.string(from: startOfMonth))
        
        //  End of Month
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth)
        print(dateFormatter.string(from: endOfMonth!))
        let axn = "get/expSubmitDates"
        let apiKey = "\(axn)&from_date=\(dateFormatter.string(from: startOfMonth))&to_date=\(dateFormatter.string(from: endOfMonth!))&selected_period=null&sf_code=\(SFCode)"
        
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could not print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
    }
    
func srtExpenseData(Select_date:String){
        let axn = "get/srtExpenseData"
        let apiKey = "\(axn)&date=\(Select_date)&sf_code=\(SFCode)"
        
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                if let json = value as? [[String: Any]] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could not print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    if let firstItem = json.first {
                        print(firstItem["NeedAttachment"] as? Int as Any)
                        if let NeedAttachment = firstItem["NeedAttachment"] as? Int, NeedAttachment == 0{
                            End_Attachment.isHidden = true
                            End_Attachmeni_Height.constant = 0
                        }else if let NeedAttachment = firstItem["NeedAttachment"] as? Int, NeedAttachment == 1{
                            End_Attachment.isHidden = false
                            End_Attachmeni_Height.constant = 80
                        }else{
                            End_Attachment.isHidden = true
                            End_Attachmeni_Height.constant = 0
                        }
                        if let from = firstItem["From_Place"] as? String {
                            let to = firstItem["To_Place"] as? String
                            let Star_KM = firstItem["Start_Km"] as? String
                            let Mode_Of_Travel = firstItem["MOT_Name"] as? String
                            From_plc.text = from
                            To_plc.text = to
                            Start_KM.text = Star_KM
                            Mode_OF_Trav.text = Mode_Of_Travel
                            end_Exp_Datas.append(End_exData(From: from, To_Plce: to!, Start_KM: Star_KM!, Mode_Of_Travel: Mode_Of_Travel!))
                        }
                    }
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
    }

}
