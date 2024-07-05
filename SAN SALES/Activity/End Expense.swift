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
class End_Expense:IViewController,FSCalendarDelegate,FSCalendarDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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

    @IBOutlet weak var End_Km_Img: UIImageView!
    
    @IBOutlet weak var End_Att_Img: UIImageView!
    
    //Hight
    @IBOutlet weak var Date_View_Hight: NSLayoutConstraint!
    @IBOutlet weak var End_Attachmeni_Height: NSLayoutConstraint!
    @IBOutlet weak var End_Km_Hig: NSLayoutConstraint!
    @IBOutlet weak var Personal_Km_Hig: NSLayoutConstraint!
    @IBOutlet weak var End_Km_Img_width: NSLayoutConstraint!
    @IBOutlet weak var End_Att_Img_width: NSLayoutConstraint!
    
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
    var photo_Km = ""
    var Photo_End_Att = ""
    var EndingFare = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        End_Expense_Scr.text = "End Expense"
        if Date_Nd == true{
        Date_View.isHidden = true
        Date_View_Hight.constant = 0
        }
        calendar.delegate = self
        calendar.dataSource = self
        calendar.placeholderType = .none
        BT_Back.addTarget(target: self, action: #selector(GotoHome))
        Select_Date.addTarget(target: self, action: #selector(Opencalender))
        Start_Photo.addTarget(target: self, action: #selector(openCamera_Km))
        Ending_fare_Photo.addTarget(target: self, action: #selector(openCamera_Ending))
        Start_Photo.layer.cornerRadius = 5
        Start_Photo.layer.masksToBounds = true
        Ending_fare_Photo.layer.cornerRadius = 5
        Ending_fare_Photo.layer.masksToBounds = true
        End_Km_Img.layer.cornerRadius = 5
        End_Km_Img.layer.masksToBounds = true
        End_Att_Img.layer.cornerRadius = 5
        End_Att_Img.layer.masksToBounds = true
        Start_Text_KM.keyboardType = UIKeyboardType.numberPad
        Ending_Fare.keyboardType = UIKeyboardType.numberPad
        Per_KM.keyboardType = UIKeyboardType.numberPad
        From_plc.text = "-"
        To_plc.text = "-"
        Start_KM.text = "-"
        Mode_OF_Trav.text = "-"
        if Date != ""{
            Select_Date.text = Date
            srtExpenseData(Select_date:Date!)
        }
        End_exp_date() 
        End_Km_Img.isHidden = true
        End_Km_Img_width.constant = 0
        End_Att_Img_width.constant = 0
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Calculate the start of the month 3 months ago
        var comp = DateComponents()
        comp.month = -1
        let currentDate = Foundation.Date()
        guard let threeMonthsAgo = Calendar.current.date(byAdding: comp, to: currentDate) else {
            fatalError("Error calculating date")
        }
        var startOfMonthComponents = Calendar.current.dateComponents([.year, .month], from: threeMonthsAgo)
        startOfMonthComponents.day = 1
        guard let startOfMonth = Calendar.current.date(from: startOfMonthComponents) else {
            fatalError("Error calculating start of month")
        }
        return startOfMonth
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
            srtExpenseData(Select_date:myStringDate)
            Ending_rmk.text = ""
        }
    }
    @objc private func GotoHome() {
            if (End_exp_title == "Day End Plan"){
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                UIApplication.shared.windows.first?.rootViewController = viewController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }else if (End_exp_title == "Ex_Ent"){
                VisitData.shared.Nav_id = 1
                let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "Expense") as! Expense_Entry;()
                UIApplication.shared.windows.first?.rootViewController = viewController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }else{
                GlobalFunc.MovetoMainMenu()
            }
    }
    @objc private func Opencalender(){
        Calender_View.isHidden = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let fileName: String = String(Int(Foundation.Date().timeIntervalSince1970))
            let filenameno = "\(fileName).jpg"
            
            if SelMod == "KM" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.ShowLoading(Message: "Image upload, please wait...")
                                 }
                End_Km_Img.isHidden = false
                End_Km_Img.image = pickedImage
                photo_Km = "_\(filenameno)"
                ImageUploade().uploadImage(SFCode: self.SFCode, image: pickedImage, fileName: "__\(filenameno)") {
                    DispatchQueue.main.async { [self] in
                        End_Km_Img_width.constant = 74
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                              self.LoadingDismiss()
                                         }
                    }
                }
            } else if SelMod == "Ending" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.ShowLoading(Message: "Image upload, please wait...")
                                 }
                End_Att_Img.image = pickedImage
                Photo_End_Att = "_\(filenameno)"
                ImageUploade().uploadImage(SFCode: self.SFCode, image: pickedImage, fileName: "__\(filenameno)") {
                    DispatchQueue.main.async { [self] in
                        End_Att_Img_width.constant = 74
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                              self.LoadingDismiss()
                                         }
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }

    
    @objc private func openCamera_Km(){
        SelMod = "KM"
        let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
             present(imagePickerController, animated: true, completion: nil)
    }
    @objc private func openCamera_Ending(){
        SelMod = "Ending"
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func Close_Calender_View(_ sender: Any) {
        Calender_View.isHidden = true
    }
    func validate(personalKm:Bool) -> Bool {
        if Select_Date.text == "Select Date"{
            Toast.show(message: "Select Date", controller: self)
            return false
        }
        if StrEnd_Need == 1{
            if Start_Text_KM.text == ""{
                Toast.show(message: "Enter Ending KM", controller: self)
                return false
            }
            if End_Km_Img.isHidden == true {
                Toast.show(message: "Add Ending KM Photo", controller: self)
                return false
            }
            
        }
        if Attach_Need == 1{
            if Ending_Fare.text == ""{
                Toast.show(message: "Enter Ending Fare", controller: self)
                return false
            }
            
            if let endingFare = Int(Ending_Fare.text ?? ""), endingFare > EndingFare {
                Toast.show(message: "Enter the fare less than \(EndingFare)", controller: self)
                return false
            }
        }
    
        if Ending_rmk.text == ""{
            Toast.show(message: "Enter Ending Remarks", controller: self)
            return false
        }
        
        if let Star_KM =  Double(Start_KM.text!),let end = Double(Start_Text_KM.text!), Star_KM > end{
            Toast.show(message: "Please provide a valid Ending KM...",controller: self)
            return false
        }

        if StrEnd_Need == 1{
            if Per_KM.text == ""{
                Toast.show(message: "Enter Personal KM", controller: self)
                return false
            }
            if personalKm == true{
                Toast.show(message: "Please provide a valid Personal KM", controller: self)
                return false
            }
        }
        
        
        
        return true
    }
    @IBAction func Save_Data(_ sender: Any) {
        var StKM = 0
        var EndKM = 0
        var perKm = 0
        var AllPerKm:Bool = false
        var StartKm = ""
        if end_Exp_Datas.count == 0 {
            StartKm = ""
        }else{
             StartKm = end_Exp_Datas[0].Start_KM
        }
        if StartKm != "" {
            StKM = Int(StartKm) ?? 0
        } else {
            StKM = 0
        }

        if let endKM = Start_Text_KM.text, !endKM.isEmpty {
            EndKM = Int(endKM) ?? 0
        } else {
            EndKM = 0
        }
        
        
        if let PerKm = Per_KM.text, !PerKm.isEmpty{
            perKm = Int(PerKm)!
        }else{
            perKm = 0
        }
        
        let TotalKm = EndKM - StKM
        
        if (TotalKm < perKm){
            AllPerKm = true
        }else{
            AllPerKm = false
        }
        
        
        if validate(personalKm: AllPerKm) == false {
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
            let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit the end expense?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [self] _ in
                save_ending_km()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                return
            })
            self.present(alert, animated: true)
        
        
    }
    
    func save_ending_km(){
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
        let apiKey = "\(axn)&date=\(Date)&desig=\(Desig)&fare=\(EndFar)&rSF=\(SFCode)&endRemarks=\(EndRmk)&divisionCode=\(DivCode)&date_time=\(date_time)&imageUrl=\(photo_Km)&sfCode=\(SFCode)&stateCode=\(StateCode)&personalKM=\(PerKOM)&endModID=\(endModID)&sf_code=\(SFCode)&endEntry=1&endKM=\(EndKM)"
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
                    
                        if (End_exp_title == "Ex_Ent"){
                            VisitData.shared.Nav_id = 1
                            let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
                            let viewController = storyboard.instantiateViewController(withIdentifier: "Expense") as! Expense_Entry;()
                            UIApplication.shared.windows.first?.rootViewController = viewController
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        }else{
                            GlobalFunc.movetoHomePage()
                        }
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Calculate the start of the month 3 months ago
        var comp = DateComponents()
        comp.month = -1
       // comp.month = 0
        let currentDate = Foundation.Date()
        guard let threeMonthsAgo = Calendar.current.date(byAdding: comp, to: currentDate) else {
            fatalError("Error calculating date")
        }
        var startOfMonthComponents = Calendar.current.dateComponents([.year, .month], from: threeMonthsAgo)
        startOfMonthComponents.day = 1
        guard let startOfMonth = Calendar.current.date(from: startOfMonthComponents) else {
            fatalError("Error calculating start of month")
        }
        
        let currentDates = Foundation.Date()
        
        var components = Calendar.current.dateComponents([.year, .month], from: currentDate)
        components.month! += 1
        components.day = 1
        guard let startOfNextMonth = Calendar.current.date(from: components) else {
            fatalError("Error calculating start of next month")
        }
        let lastDayOfCurrentMonth = Calendar.current.date(byAdding: .day, value: -1, to: startOfNextMonth)
        
        var comps2 = DateComponents()
        comps2.month = 0
        comps2.day = 0
        let date = Foundation.Date()
        
        guard let endOfMonth = Calendar.current.date(byAdding: comps2, to: lastDayOfCurrentMonth!) else {
            fatalError("Error calculating end of month")
        }
        let axn = "get/expSubmitDates"
        let apiKey = "\(axn)&from_date=\(dateFormatter.string(from: startOfMonth))&to_date=\(dateFormatter.string(from: endOfMonth))&selected_period=null&sf_code=\(SFCode)"
        
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
                        print(attance_flg)
                        for item in attance_flg{
                            print(item)
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                                    if let cell = calendar.cell(for: Formated_Date!, at: .current){
                                        addLetter(to: cell, text: ".")
                                    }else{
                                        print("Cell is nil for date: \(full_date)")
                                    }
                                }
                                expsub_Date = expsub_Date.filter { $0.Dates != full_date }
                            }
                        }
                    }
                    print(expsub_Date)
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        self.ShowLoading(Message: "Loading...")
        removeLabels()
        
        End_exp_date()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                               self.LoadingDismiss()
                           }
        
    }
    
    func removeLabels(){
       
         for (_, label) in labelsDictionary {
                label.removeFromSuperview()
         }
         labelsDictionary.removeAll()
     }
    
    func addLetter(to cell: FSCalendarCell?, text:String){
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
                    if json.isEmpty || json.count == 0{
                        Toast.show(message: "Please Select a Valid Date", controller: self)
                        return
                    }
                    
                    Select_Date.text = Select_date
                    
                    if let firstItem = json.first {
                            // NeedAttachment
                        if let NeedAttachment = firstItem["NeedAttachment"] as? Int, NeedAttachment == 0{
                            if let MaxKm = firstItem["MaxKm"] as? Int , MaxKm > 0 {
                                EndingFare = MaxKm
                                Attach_Need = 1
                                End_Attachment.isHidden = false
                                End_Attachmeni_Height.constant = 80
                            }else{
                                Attach_Need = 0
                                End_Attachment.isHidden = true
                                End_Attachmeni_Height.constant = 0
                            }
                            
                        }else if let NeedAttachment = firstItem["NeedAttachment"] as? Int, NeedAttachment == 1{
                            Attach_Need = 1
                            End_Attachment.isHidden = false
                            End_Attachmeni_Height.constant = 80
                        }else{
                            if let MaxKm = firstItem["MaxKm"] as? Int , MaxKm > 0 {
                                EndingFare = MaxKm
                                Attach_Need = 1
                                End_Attachment.isHidden = false
                                End_Attachmeni_Height.constant = 80
                            }else{
                                Attach_Need = 0
                                End_Attachment.isHidden = true
                                End_Attachmeni_Height.constant = 0
                            }
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
                            if let StEndNeed = firstItem["StEndNeed"] as? Int,StEndNeed == 0 {
                                    End_Km_Hig.constant = 0
                                    EndKm_View.isHidden = true
                                    Personal_Km_Hig.constant = 0
                                    Personal_Km_View.isHidden = true
                            }else{
                                End_Km_Hig.constant = 80
                                EndKm_View.isHidden = false
                                Personal_Km_Hig.constant = 80
                                Personal_Km_View.isHidden = false
                            }
                            
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
                    Calender_View.isHidden = true
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
                Calender_View.isHidden = true
            }
        }
    }
}
