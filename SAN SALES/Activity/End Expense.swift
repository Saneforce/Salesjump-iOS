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
class End_Expense:IViewController,FSCalendarDelegate,FSCalendarDataSource {
    
    @IBOutlet weak var Calender_View: UIView!
    
    @IBOutlet weak var BT_Back: UIImageView!
    @IBOutlet weak var End_Expense_Scr: UILabel!
    @IBOutlet weak var Select_Date: LabelSelect!
    @IBOutlet weak var From_plc: UILabel!
    @IBOutlet weak var To_plc: UILabel!
    @IBOutlet weak var Start_Km_Hed: UILabel!
    @IBOutlet weak var Start_KM: UILabel!
    @IBOutlet weak var Mode_OF_Trav: UILabel!
    @IBOutlet weak var Start_Text_KM: EditTextField!
    @IBOutlet weak var Start_Photo: UILabel!
    @IBOutlet weak var Ending_Fare: EditTextField!
    @IBOutlet weak var Ending_fare_Photo: UILabel!
    @IBOutlet weak var Ending_rmk: UITextView!
    @IBOutlet weak var Per_KM: EditTextField!
    
    //calender
    @IBOutlet weak var calendar: FSCalendar!
    //views
    @IBOutlet weak var EndKm_View: UIView!
    @IBOutlet weak var Date_View: UIView!
    @IBOutlet weak var End_Attachment: UIView!
    @IBOutlet weak var Personal_Km_View: UIView!
    
    //Hight
    @IBOutlet weak var Date_View_Hight: NSLayoutConstraint!
    @IBOutlet weak var End_Attachmeni_Height: NSLayoutConstraint!
    @IBOutlet weak var End_Km_Hig: NSLayoutConstraint!
    @IBOutlet weak var Personal_Km_Hig: NSLayoutConstraint!
    
    struct End_exData:Codable{
        let From:String
        let To_Plce:String
        let Start_KM:String
        let Mode_Of_Travel:String
    }
    struct Endsub_Date:Codable{
        let Dates:String
        let Text:String
    }
    var expsub_Date:[Endsub_Date]=[]
    var labelsDictionary = [FSCalendarCell: UILabel]()
    var SelMod:String = ""
    var End_exp_title:String?
    var Date_Nd:Bool?
    var Date:String?
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = "",SF_type: String = ""
    let LocalStoreage = UserDefaults.standard
    var end_Exp_Datas:[End_exData]=[]
    var Attach_Need = 1
    var StrEnd_Need = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        End_Expense_Scr.text = End_exp_title
        if Date_Nd == true{
        Date_View.isHidden = true
        Date_View_Hight.constant = 0
        }
        calendar.delegate = self
        calendar.dataSource = self
        BT_Back.addTarget(target: self, action: #selector(GotoHome))
        Select_Date.addTarget(target: self, action: #selector(Opencalender))
        Start_Photo.addTarget(target: self, action: #selector(openCamera_Km))
        Ending_fare_Photo.addTarget(target: self, action: #selector(openCamera_Ending))
        Start_Photo.layer.cornerRadius = 5
        Start_Photo.layer.masksToBounds = true
        Ending_fare_Photo.layer.cornerRadius = 5
        Ending_fare_Photo.layer.masksToBounds = true
        Start_Text_KM.keyboardType = UIKeyboardType.numberPad
        Ending_Fare.keyboardType = UIKeyboardType.numberPad
        Per_KM.keyboardType = UIKeyboardType.numberPad
        From_plc.text = "no data"
        To_plc.text = "no data"
        Start_KM.text = "no data"
        Mode_OF_Trav.text = "no data"
        if Date != ""{
            Select_Date.text = Date
            srtExpenseData(Select_date:Date!)
        }
        End_exp_date() 
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
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Foundation.Date()
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        let currentDate = Foundation.Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let firstDayOfMonth = calendar.date(from: components) else {
            return currentDate
        }
        return firstDayOfMonth
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            return
        }
        let formatter = DateFormatter()
        let dateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let myStringDate = formatter.string(from: date)
        let Match_Date = dateFormatter.string(from: date)
        print(expsub_Date)
        print(Match_Date)
        if expsub_Date.contains(where: { $0.Dates == Match_Date }){
            Toast.show(message: "Please Select a Valid Date", controller: self)
            return
        }else{
            Select_Date.text = myStringDate
            srtExpenseData(Select_date:myStringDate)
            Calender_View.isHidden = true
        }
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
        if StrEnd_Need == 1{
            if Start_Text_KM.text == ""{
                Toast.show(message: "Enter Starting KM", controller: self)
                return false
            }
        }
        if Attach_Need == 1{
            if Ending_Fare.text == "" {
                Toast.show(message: "Enter Ending Fare", controller: self)
                return false
            }
        }
    
        if Ending_rmk.text == ""{
            Toast.show(message: "Enter Ending Remarks", controller: self)
            return false
        }
        if StrEnd_Need == 1{
            if Per_KM.text == ""{
                Toast.show(message: "Enter Personal KM", controller: self)
                return false
            }
        }
        
        return true
    }
    @IBAction func Save_Data(_ sender: Any) {
        
        if validate() == false {
            return
        }
        self.ShowLoading(Message: "Loading...")
        var EndKM = ""
        var PerKOM = ""
        var EndRmk = ""
        var endModID = ""
        var date_time = ""
        var Date = ""
        var EndFar = ""
        if let endKM = Start_Text_KM.text{
            EndKM = endKM
        }
        if let perkm = Per_KM.text{
            PerKOM = perkm
        }
        if let endRmk = Ending_rmk.text{
            EndRmk = endRmk.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        let endMod = end_Exp_Datas[0].Mode_Of_Travel
        endModID = endMod.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let currentTimeAndMilliseconds = getCurrentTimeAndMilliseconds()
        
        if let Date_time = Select_Date.text{
            date_time = Date_time+" "+currentTimeAndMilliseconds.time
            date_time = date_time.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        
        if let date = Select_Date.text{
            Date = date.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        
        if let EndFars = Ending_Fare.text{
            EndFar = EndFars
        }
        
        let axn = "post/endDayExpense"
        let apiKey = "\(axn)&date=\(Date)&desig=\(Desig)&fare=\(EndFar)&rSF=\(SFCode)&endRemarks=\(EndRmk)&divisionCode=\(DivCode)&date_time=\(date_time)&imageUrl=&sfCode=\(SFCode)&stateCode=\(StateCode)&personalKM=\(PerKOM)&endModID=\(endModID)&sf_code=\(SFCode)&endEntry=1&endKM=\(EndKM)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.LoadingDismiss()
                }
                if let json = value as? [ String:AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could not print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                    Toast.show(message: "submitted successfully", controller: self)
                    GlobalFunc.movetoHomePage()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
    }
    func getCurrentTimeAndMilliseconds() -> (time: String, milliseconds: Int) {
        let currentTime = Foundation.Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let timeString = dateFormatter.string(from: currentTime)
        let milliseconds = calendar.component(.nanosecond, from: currentTime) / 1_000_000

        return (time: timeString, milliseconds: milliseconds)
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
                    if let attance_flg = json["attance_flg"] as? [AnyObject] {
                        for item in attance_flg{
                            if let Flf = item["FWFlg"] as? String, Flf == "F"||Flf=="H"||Flf=="W"{
                                print(item)
                                expsub_Date.append(Endsub_Date(Dates: (item["pln_date"] as? String)!, Text: (item["FWFlg"] as? String)!))
                            }
                        }
                    }
                    if let srt_exp = json["srt_exp"] as? [AnyObject] {
                        for item in srt_exp {
                            if let full_date = item["full_date"] as? String{
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd/MM/yyyy"
                                let Formated_Date = dateFormatter.date(from: full_date)
                                let cell = calendar.cell(for: Formated_Date!, at: .current)
                                addLetter(to: cell, text: ".")
                                expsub_Date = expsub_Date.filter { $0.Dates != full_date }
                            }
                        }
                    }
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
    }
    func addLetter(to cell: FSCalendarCell?, text:String) {
        let letterLabel = UILabel()
        letterLabel.text = text
        letterLabel.textColor = .red
        letterLabel.font = UIFont.boldSystemFont(ofSize: 50)
        letterLabel.textAlignment = .center
        letterLabel.frame = CGRect(x: 0, y: 3, width: cell?.bounds.width ?? 0, height: cell?.bounds.height ?? 0)
        cell?.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        cell?.addSubview(letterLabel)
        labelsDictionary[cell!] = letterLabel
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
                            // NeedAttachment
                        if let NeedAttachment = firstItem["NeedAttachment"] as? Int, NeedAttachment == 0{
                            Attach_Need = 0
                            End_Attachment.isHidden = true
                            End_Attachmeni_Height.constant = 0
                        }else if let NeedAttachment = firstItem["NeedAttachment"] as? Int, NeedAttachment == 1{
                            Attach_Need = 1
                            End_Attachment.isHidden = false
                            End_Attachmeni_Height.constant = 80
                        }else{
                            Attach_Need = 0
                            End_Attachment.isHidden = true
                            End_Attachmeni_Height.constant = 0
                        }
                        // StEndNeed
                        if let StEndNeed = firstItem["StEndNeed"] as? Int,StEndNeed == 0{
                            StrEnd_Need = 0
                            Start_Km_Hed.isHidden = true
                            Start_KM.isHidden = true
                            EndKm_View.isHidden = true
                            Personal_Km_View.isHidden = true
                            End_Km_Hig.constant = 0
                            Personal_Km_Hig.constant = 0
                        }else if let StEndNeed = firstItem["StEndNeed"] as? Int,StEndNeed == 1{
                            StrEnd_Need = 1
                            Start_Km_Hed.isHidden = false
                            Start_KM.isHidden = false
                            EndKm_View.isHidden = false
                            Personal_Km_View.isHidden = false
                            End_Km_Hig.constant = 80
                            Personal_Km_Hig.constant = 80

                        }else{
                            StrEnd_Need = 0
                            Start_Km_Hed.isHidden = true
                            Start_KM.isHidden = true
                            EndKm_View.isHidden = true
                            Personal_Km_View.isHidden = true
                            End_Km_Hig.constant = 0
                            Personal_Km_Hig.constant = 0
                        }
                        
                        if let from = firstItem["From_Place"] as? String{
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
