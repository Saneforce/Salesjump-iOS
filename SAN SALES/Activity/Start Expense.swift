//
//  Start Expense.swift
//  SAN SALES
//
//  Created by San eforce on 28/03/24.
//

import UIKit
import Alamofire
import FSCalendar
import Foundation
import CoreLocation
class Start_Expense:IViewController, FSCalendarDelegate,FSCalendarDataSource, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var BT_Back: UIImageView!
    @IBOutlet weak var Start_Expense_Scr: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendar_view: UIView!
    @IBOutlet weak var Close_calendar_View: UIButton!
    @IBOutlet weak var Select_Date: LabelSelect!
    @IBOutlet weak var Drop_Down_Sc: UIView!
    @IBOutlet weak var Drop_Down_TB: UITableView!
    @IBOutlet weak var Text_Serch: UITextField!
    @IBOutlet weak var Close_Drop_Down: UIButton!
    @IBOutlet weak var Drop_Down_Head: UILabel!
    @IBOutlet weak var Daily_Allowance: LabelSelect!
    @IBOutlet weak var Mode_Of_Travel: LabelSelect!
    @IBOutlet weak var Enter_From: EditTextField!
    @IBOutlet weak var Check_Box: UIImageView!
    @IBOutlet weak var Driver_Need: UILabel!
    @IBOutlet weak var Starting_View: UIView!
    @IBOutlet weak var Add_Photo: UILabel!
    @IBOutlet weak var Date_View: UIView!
    @IBOutlet weak var Start_Km: EditTextField!
    @IBOutlet weak var Select_To: LabelSelect!
    @IBOutlet weak var Enter_To: EditTextField!
    @IBOutlet weak var Start_Km_Img: UIImageView!
    
    //Set Height
    @IBOutlet weak var Date_height: NSLayoutConstraint!
    @IBOutlet weak var Daily_Allowance_Height: NSLayoutConstraint!
    @IBOutlet weak var Mod_Of_Tra_Height: NSLayoutConstraint!
    @IBOutlet weak var From_Height: NSLayoutConstraint!
    @IBOutlet weak var To_Height: NSLayoutConstraint!
    @IBOutlet weak var Starting_Height: NSLayoutConstraint!
    
    @IBOutlet weak var Str_Km_text_width: NSLayoutConstraint!
    @IBOutlet weak var Str_Km_with: NSLayoutConstraint!
    
    
    struct exData:Codable{
    let id:String
    let name:String
    let newname:String
    }
    struct Rout_list:Codable{
    let id:String
    let name:String
    let stockist_code:String
    }
    struct Trav_Data:Codable{
        let name:String
        let StEndNeed:Int
        let DriverNeed:Int
        let Sl_No:Int
    }
    struct Expsub_Date:Codable{
        let Dates:String
        let Text:String
    }
    var expsub_Date:[Expsub_Date]=[]
    var expsub_Dates:[Date]=[]
    var Only_Exp_Date:[Int]=[]
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = "",SF_type: String = ""
    let LocalStoreage = UserDefaults.standard
    var Exp_Data:[exData] = []
    var Exp_Datas:[exData]=[]
    var Trave_Det:[Trav_Data]=[]
    var Trave_Dets:[Trav_Data]=[]
    var SelMod:String = ""
    var Screan_Heding:String?
    var Curent_Date:String?
    var Show_Date:Bool?
    var Exp_Nav:String?
    var sImgItems:String = ""
    var select_allow:String = ""
    var select_date:String = ""
    var lstAllRoutes: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    var AllRout:[Rout_list] = []
    var lstrout:[Rout_list] = []
    var checked = false
    var StarKmNeed:Int = 0
    var Mod_Id = 0
    var to_place = ""
    var To_Place_id = ""
    var labelsDictionary = [FSCalendarCell: UILabel]()
    var lstWType: [AnyObject] = []
    var lstDist: [AnyObject] = []
    var photo_name:String = ""
    override func viewDidLoad(){
        super.viewDidLoad()
        getUserDetails()
        BT_Back.addTarget(target: self, action: #selector(GotoHome))
        Close_calendar_View.addTarget(target: self, action: #selector(Clos_Calender))
        Select_Date.addTarget(target: self, action: #selector(Open_Calender))
        Daily_Allowance.addTarget(target: self, action: #selector(Open_Allowance))
        Close_Drop_Down.addTarget(target: self, action: #selector(Close_Allowance))
        Mode_Of_Travel.addTarget(target: self, action: #selector(Open_Mod_of_Travel))
        Add_Photo.addTarget(target: self, action: #selector(openCamera))
        Select_To.addTarget(target: self, action: #selector(opento))
        Check_Box.addTarget(target: self, action: #selector(Box))
        
        
        if let WorkTypeData = LocalStoreage.string(forKey: "Worktype_Master"),
           let list = GlobalFunc.convertToDictionary(text:  WorkTypeData) as? [AnyObject] {
            lstWType = list
        }
        
        var Id:String = ""
        var subordinateid:String = ""
        if let PlnDets = LocalStoreage.string(forKey: "Mydayplan"),let list = GlobalFunc.convertToDictionary(text:  PlnDets) as? [AnyObject],list.count != 0 {
            print(list)
            Id = (list[0]["subordinateid"] as? String)!
            subordinateid = (list[0]["subordinateid"] as? String)!
        } else {
            subordinateid = SFCode
        }
       
        if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+subordinateid),
           let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
            lstAllRoutes = list
            lstRoutes = list
            print(list)
        }
        lstRoutes = lstAllRoutes.filter({(fitem) in
            print(fitem)
            let StkId: String = String(format: ",%@,", fitem["field_code"] as! CVarArg)
            print(StkId)
            return Bool(StkId.range(of: String(format: ",%@,", Id))?.lowerBound != nil )
        })
        
        expSubmitDates()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.placeholderType = .none
        Drop_Down_TB.dataSource = self
        Drop_Down_TB.delegate = self
        calendar.appearance.titlePlaceholderColor = .lightGray
        Add_Photo.layer.cornerRadius = 5
        //Add_Photo.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        Add_Photo.layer.masksToBounds = true
        Start_Expense_Scr.text = Screan_Heding
        if Show_Date == true{
        Date_View.isHidden = true
        Date_height.constant = 0
        }
        if (Curent_Date != ""){
            select_date = Curent_Date!
            Select_Date.text = Curent_Date!
        }
        Enter_To.isHidden = true
        To_Height.constant = 80
        
        Check_Box.isHidden = true
        Driver_Need.isHidden = true
        Mod_Of_Tra_Height.constant = 80
        
        Start_Km.keyboardType = UIKeyboardType.numberPad
        Str_Km_text_width.constant = 250
        Str_Km_with.constant = 0
        Start_Km_Img.isHidden = true
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (SelMod == "Allowance") {
            return Exp_Datas.count
        }else if (SelMod == "Travel"){
            return Trave_Dets.count
        }else if (SelMod == "TO"){
            return lstrout.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        
        if (SelMod == "Allowance") {
            cell.lblText.text = Exp_Datas[indexPath.row].name
        }else if (SelMod == "Travel"){
            cell.lblText.text = Trave_Dets[indexPath.row].name
        }else if (SelMod == "TO"){
            cell.lblText.text = lstrout[indexPath.row].name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (SelMod == "Allowance") {
            let item = Exp_Datas[indexPath.row]
            print(item)
            select_allow = item.name
            Daily_Allowance.text = item.name
        }else if (SelMod == "Travel"){
            let item = Trave_Dets[indexPath.row]
            print(item)
            //Mod_Id
            Mode_Of_Travel.text = item.name
            Mod_Id = item.Sl_No
            //Need Driver
            if (item.DriverNeed == 0){
                Check_Box.isHidden = true
                Driver_Need.isHidden = true
                Mod_Of_Tra_Height.constant = 80
            }else{
                Check_Box.isHidden = false
                Driver_Need.isHidden = false
                Mod_Of_Tra_Height.constant = 127
            }
            
            //Need Strat KM
            StarKmNeed = item.StEndNeed
            print(StarKmNeed)
            if (item.StEndNeed == 0){
                Starting_View.isHidden = true
            }else{
                Starting_View.isHidden = false
            }
        } else if(SelMod == "TO"){
            let item = lstrout[indexPath.row]
            print(item)
            Select_To.text = item.name
            if item.name == "others"{
                To_Place_id = ""
                Enter_To.isHidden = false
                To_Height.constant = 130
            }else{
                to_place = item.name
                To_Place_id = item.id
                Enter_To.isHidden = true
                To_Height.constant = 80
            }
        }
        Close_Allowance()
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
     
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Calculate the start of the month 3 months ago
        var comp = DateComponents()
        comp.month = -1
        let currentDate = Date()
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
        if expsub_Date.contains(where: { $0.Dates == Match_Date }) {
            Select_Date.text = myStringDate
            Clos_Calender()
        } else {
            Toast.show(message: "Please Select a Valid Date", controller: self)
            return
        }
    }

    func expSubmitDates() {
       // expsub_Date.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Calculate the start of the month 3 months ago
        var comp = DateComponents()
        comp.month = -1
       // comp.month = 0
        let currentDate = Date()
        guard let threeMonthsAgo = Calendar.current.date(byAdding: comp, to: currentDate) else {
            fatalError("Error calculating date")
        }
        var startOfMonthComponents = Calendar.current.dateComponents([.year, .month], from: threeMonthsAgo)
        startOfMonthComponents.day = 1
        guard let startOfMonth = Calendar.current.date(from: startOfMonthComponents) else {
            fatalError("Error calculating start of month")
        }
        
        let currentDates = Date()
        
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
        let date = Date()
        
        guard let endOfMonth = Calendar.current.date(byAdding: comps2, to: lastDayOfCurrentMonth!) else {
            fatalError("Error calculating end of month")
        }
        
        self.ShowLoading(Message: "Loading...")
        let axn = "get/expSubmitDates"
        let apiKey = "\(axn)&from_date=\(dateFormatter.string(from: startOfMonth))&to_date=\(dateFormatter.string(from:endOfMonth))&selected_period=null&sf_code=\(SFCode)"
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
                                expsub_Date.append(Expsub_Date(Dates: (item["pln_date"] as? String)!, Text: (item["FWFlg"] as? String)!))
                            }
                        }
                    }
                    if let srt_exp = json["srt_exp"] as? [AnyObject] {
                        for item in srt_exp {
                            if let full_date = item["full_date"] as? String{
                                expsub_Date = expsub_Date.filter { $0.Dates != full_date }
                            }
                        }
                    }
                    if let srt_end_exp = json["srt_end_exp"] as? [AnyObject] {
                        for item in srt_end_exp{
                            if let full_date = item["full_date"] as? String{
                                expsub_Date = expsub_Date.filter { $0.Dates != full_date }
                            }
                        }
                    }
                    
                    if let exp_submit = json["exp_submit"] as? [AnyObject] {
                        
                        for item in exp_submit{
                            if let full_date = item["full_date"] as? String{
                                expsub_Date = expsub_Date.filter { $0.Dates != full_date }
                            }
                        }
                    }
                    
                    print(expsub_Date)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.LoadingDismiss()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.LoadingDismiss()
                }
                Toast.show(message: error.errorDescription!)
            }
        }
    }
    

    func getLastThreeMonthsDates() -> [String] {
        var dates: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // Calculate the start of the month 3 months ago
        var comp = DateComponents()
        comp.month = -3
        let currentDate = Date()
        guard let threeMonthsAgo = Calendar.current.date(byAdding: comp, to: currentDate) else {
            fatalError("Error calculating date")
        }
        var startOfMonthComponents = Calendar.current.dateComponents([.year, .month], from: threeMonthsAgo)
        startOfMonthComponents.day = 1
        guard let startOfMonth = Calendar.current.date(from: startOfMonthComponents) else {
            fatalError("Error calculating start of month")
        }
        
        // Iterate through each day from startDate to currentDate
        var date = startOfMonth
        let calendar = Calendar.current
        while date <= currentDate {
            let formattedDate = dateFormatter.string(from: date)
            dates.append(formattedDate)
            // Move to the next day
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        return dates
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
    
    func removeLabels(){
       
         for (_, label) in labelsDictionary {
                label.removeFromSuperview()
         }
         labelsDictionary.removeAll()
     }
    
    func getallowns(){
        self.ShowLoading(Message: "Loading...")
        Exp_Data.removeAll()
        Trave_Det.removeAll()
        let axn = "get/Allow_Type"
        let apiKey = "\(axn)&division_code=\(DivCode)"
        var result = apiKey
            if let lastCommaIndex = result.lastIndex(of: ",") {
                result.remove(at: lastCommaIndex)
            }
        let apiKeyWithoutCommas = result.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    print(value)
                    if let json = value as? [AnyObject] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [AnyObject]{
                                    print(jsonObject)
                                    for i in jsonObject{
                                        Exp_Data.append(exData(id: (i["id"] as? String)!, name: (i["name"] as? String)!, newname: (i["newname"] as? String)!))
                                    }
                                    Exp_Datas = Exp_Data
                                    Drop_Down_TB.reloadData()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        self.LoadingDismiss()
                                    }
                                } else {
                                    print("Error: Could not convert JSON to Dictionary or access 'data'")
                                }
                            } else {
                                print("Error: Could not convert JSON to String")
                            }
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.LoadingDismiss()
                    }
                    Toast.show(message: error.errorDescription ?? "Unknown Error")
            }
        }
    }
    func travelmode(){
        self.ShowLoading(Message: "Loading...")
        Exp_Data.removeAll()
        Trave_Det.removeAll()
        let axn = "get/travelmode"
        let apiKey = "\(axn)&State_Code=\(StateCode)&Division_Code=\(DivCode)"
        var result = apiKey
        if let lastCommaIndex = result.lastIndex(of: ",") {
            result.remove(at: lastCommaIndex)
        }
        let apiKeyWithoutCommas = result.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    print(value)
                    if let json = value as? [AnyObject] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [AnyObject]{
                                    print(jsonObject)
                                    for item in jsonObject{
                                        let Alw_Eligibilty = item["Alw_Eligibilty"] as? String
                                        let spriteArray = Alw_Eligibilty!.components(separatedBy: ",")
                                        if spriteArray.contains(select_allow) {
                                            print(item)
                                            Trave_Det.append(Trav_Data(name: (item["MOT"] as? String)!, StEndNeed: (item["StEndNeed"] as? Int)!, DriverNeed: (item["DriverNeed"] as? Int)!, Sl_No: (item["Sl_No"] as? Int)!))
                                        }
                                    }
                                    Trave_Dets = Trave_Det
                                    Drop_Down_TB.reloadData()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                           self.LoadingDismiss()
                                                       }
                                } else {
                                    print("Error: Could not convert JSON to Dictionary or access 'data'")
                                }
                            } else {
                                print("Error: Could not convert JSON to String")
                            }
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                           self.LoadingDismiss()
                                       }
                    Toast.show(message: error.errorDescription ?? "Unknown Error")
                }
            }
    }
    
    @IBAction func Sub_Start_Exp(_ sender: Any) {
        
        if validate() == false {
            return
        }
        
        var OrderSub = "OD"
        if(NetworkMonitor.Shared.isConnected != true){
            let alert = UIAlertController(title: "Information", message: "Check the Internet Connection", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                     return
                 })
                 self.present(alert, animated: true)
                return
        }
            let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit the start expense?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                VisitData.shared.cOutTime = GlobalFunc.getCurrDateAsString()
                self.ShowLoading(Message: "Getting Device Location...")
                LocationService.sharedInstance.getNewLocation(location: { location in
                    let sLocation: String = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
                    lazy var geocoder = CLGeocoder()
                    var sAddress: String = ""
                    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                        if(placemarks != nil){
                            if(placemarks!.count>0){
                                let jAddress:[String] = placemarks![0].addressDictionary!["FormattedAddressLines"] as! [String]
                                for i in 0...jAddress.count-1 {
                                    print(jAddress[i])
                                    if i==0{
                                        sAddress = String(format: "%@", jAddress[i])
                                    }else{
                                        sAddress = String(format: "%@, %@", sAddress,jAddress[i])
                                    }
                                }
                            }
                        }
                    }
                    if (OrderSub == "OD"){
                       print(sLocation)
                        self.save_data(lat:location.coordinate.latitude.description,log:location.coordinate.longitude.description)
                        OrderSub  = ""
                       
                    }else{
                    
                    }
                }, error:{ errMsg in
                    print (errMsg)
                    self.LoadingDismiss()
                })
                return
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                return
            })
            self.present(alert, animated: true)
  
    }
    func save_data(lat:String,log:String){
        
        print(StarKmNeed)
        
        if Select_To.text == "others"{
            to_place=Enter_To.text!
        }
        let currentTimeAndMilliseconds = getCurrentTimeAndMilliseconds()
        var date = ""
        var day_start_km = ""
        var mode_name = ""
        var from_place = ""
        var daily_allowance = ""
      if let dates = Select_Date.text {
            date = dates
        }
        if let mode_names = Mode_Of_Travel.text{
            mode_name = mode_names
        }
        if let day_start_kms = Start_Km.text{
            day_start_km = day_start_kms
        }
        
        if let from_places = Enter_From.text{
            from_place = from_places
        }
        if let daily_allow = Daily_Allowance.text{
            daily_allowance = daily_allow
        }
        let axn = "dcr/save"
        let apiKey = "\(axn)&update=0&divisionCode=\(DivCode)&sfCode=\(SFCode)&State_Code=\(StateCode)&desig=\(Desig)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        var Div = DivCode
        Div = Div.replacingOccurrences(of: ",", with: "")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        let jsonString = "[{\"New_TP_Attendance\":{\"lat\":\"'\(lat)'\",\"long\":\"'\(log)'\",\"date_time\":\"'\(Select_Date.text! + " " + currentTimeAndMilliseconds.time)'\",\"date\":\"'\(date)'\",\"time\":\"\(currentTimeAndMilliseconds.time)\",\"milli_sec\":\"\(currentTimeAndMilliseconds.milliseconds)\",\"day_start_km\":\"\(day_start_km)\",\"imgurl\":\"\(photo_name)\",\"mode_name\":\"\(mode_name)\",\"mod_id\":\"\(Mod_Id)\",\"daily_allowance\":\"\(daily_allowance)\",\"from_place\":\"\(from_place) \",\"to_place\":\"\(to_place)\",\"to_placeID\":\"\(To_Place_id)\",\"stEndNeed\":\"\(StarKmNeed)\",\"srtEntry\":1,\"attach_need\":\"0\",\"division_code\":\"\(Div)\",\"driver_allowance\":\"\(checked)\"}}]"
        let params: Parameters = [
            "data": jsonString
        ]
        print(params)
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            self.LoadingDismiss()
            switch AFdata.result {
            case .success(let value):
                self.LoadingDismiss()
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
                    let LocalStoreage = UserDefaults.standard
                    if let attendanceArray = prettyPrintedJson["Attendance"] as? [[String: Any]] {
                        if let firstAttendance = attendanceArray.first {
                            if let msgValue = firstAttendance["msg"] as? String {
                                LocalStoreage.set(msgValue, forKey: "attendanceView")
                            } else {
                                LocalStoreage.set("0", forKey: "attendanceView")
                            }
                        } else {
                            LocalStoreage.set("0", forKey: "attendanceView")
                        }
                    } else {
                        LocalStoreage.set("0", forKey: "attendanceView")
                    }
                    
                    
                    Toast.show(message: "submitted successfully", controller: self)
                    if let NavExp = Exp_Nav, NavExp=="Ex_Ent"{
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
    
    func validate() -> Bool {
        // Date Validation
        if (Select_Date.text == "Select Date"){
            Toast.show(message: "Select Date", controller: self)
            return false
        }
        // Allowance Validation
        if Daily_Allowance.text == "Select  Daily Allowance" {
            Toast.show(message: "Select  Daily Allowance", controller: self)
            return false
        }
        // Mode_Of_Travel Validation
        if Mode_Of_Travel.text == "Select Mode of Travel" {
            Toast.show(message: "Select Mode of Travel", controller: self)
            return false
        }
       // Enter_From Validation
        if let enterFromText = Enter_From.text?.trimmingCharacters(in: .whitespaces), enterFromText.isEmpty {
            Toast.show(message: "Enter From", controller: self)
            return false
        }
        // To Validation
        if Select_To.text == "others"{
            if let EnterText = Enter_To.text?.trimmingCharacters(in: .whitespaces),EnterText.isEmpty{
                Toast.show(message: "Enter To", controller: self)
                return false
            }
        }else if (Select_To.text == "Select To"){
            Toast.show(message: "Select To", controller: self)
            return false
        }
        //Start_Km Validation
        if Start_Km.text == "" {
            if StarKmNeed == 1 {
                Toast.show(message: "Enter Start KM", controller: self)
                return false
            }
        }
        // Start Km Image
        if Start_Km_Img.isHidden == true {
            if StarKmNeed == 1 {
                Toast.show(message: "Add Start KM Photo", controller: self)
                return false
            }
        }
        
        return true
    }
    func getCurrentTimeAndMilliseconds() -> (time: String, milliseconds: Int) {
        let currentTime = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let timeString = dateFormatter.string(from: currentTime)
        let milliseconds = calendar.component(.nanosecond, from: currentTime) / 1_000_000

        return (time: timeString, milliseconds: milliseconds)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            Start_Km_Img.layer.cornerRadius = 10
            Start_Km_Img.layer.masksToBounds = true
            Start_Km_Img.image = pickedImage
            let fileName: String = String(Int(Date().timeIntervalSince1970))
            let filenameno="\(fileName).jpg"
            photo_name = "_\(filenameno)"
            ImageUploader().uploadImage(SFCode: self.SFCode, image: pickedImage, fileName: "__\(filenameno)")
            Str_Km_text_width.constant = 200
            Str_Km_with.constant = 60
            Start_Km_Img.isHidden = false
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func openCamera(){
        let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
             present(imagePickerController, animated: true, completion: nil)
    }
    @objc private func Open_Allowance(){
        SelMod = "Allowance"
        Drop_Down_Head.text = "Daily Allowance"
        getallowns()
        Drop_Down_Sc.isHidden = false
    }
    @objc private func Open_Mod_of_Travel(){
        if Daily_Allowance.text == "Select  Daily Allowance"{
            Toast.show(message: "Select  Daily Allowance", controller: self)
        }else{
            SelMod = "Travel"
            Drop_Down_Head.text = "Mode of Travel"
            travelmode()
            Drop_Down_Sc.isHidden = false
        }
    }
    @objc private func Close_Allowance(){
        Text_Serch.text = ""
        Drop_Down_Sc.isHidden = true
    }
    @objc private func Open_Calender(){
        
       
        for letter in expsub_Date {
            let datess = letter.Dates
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            if let formattedDate = dateFormatter.date(from: datess) {
                print("Formatted Date: \(formattedDate)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                    if let cell = calendar.cell(for: formattedDate, at: .current) {
                        addLetter(to: cell, text: ".")
                    } else {
                        print("Cell is nil for date: \(datess)")
                    }
                    }
                
               
            } else {
                print("Failed to parse date: \(datess)")
            }
        }
        calendar_view.isHidden = false
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        self.ShowLoading(Message: "Loading...")
        removeLabels()
        
        Open_Calender()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                               self.LoadingDismiss()
                           }
     }
    
    @objc private func Clos_Calender(){
        calendar_view.isHidden = true
    }
    @objc private func GotoHome(){
        if let NavExp = Exp_Nav{
            if (NavExp == "Ex_Ent"){
                VisitData.shared.Nav_id = 1
                let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "Expense") as! Expense_Entry;()
                UIApplication.shared.windows.first?.rootViewController = viewController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }else{
            GlobalFunc.MovetoMainMenu()
        }
    }
    @objc private func opento(){
        AllRout.removeAll()
        SelMod = "TO"
        print(lstAllRoutes)
        for items in lstRoutes {
            AllRout.append(Rout_list(id: (items["id"] as? String)!, name: (items["name"] as? String)!, stockist_code: (items["stockist_code"] as? String)!))
        }
        AllRout.append(Rout_list(id:"others", name: "others", stockist_code:"others"))
        lstrout = AllRout
        Drop_Down_TB.reloadData()
        Drop_Down_Head.text = "Select To"
        Drop_Down_Sc.isHidden = false
    }
    @objc private func Box(){
        if checked == false {
            checked = true
            Check_Box.image = UIImage(named: "checkbox")
        }else{
            checked = false
            Check_Box.image = UIImage(named: "uncheckbox")
        }
    }
    @IBAction func SearchByText(_ sender: Any) {
        let txtbx: UITextField = sender as! UITextField
        print(txtbx.text!.lowercased())
        if (SelMod == "Allowance") {
            if txtbx.text!.isEmpty {
                Exp_Datas = Exp_Data
            }else{
                Exp_Datas = Exp_Data.filter({(product) in
                    let name: String = product.name
                    return name.lowercased().contains(txtbx.text!.lowercased())
                })
            }
        }else if (SelMod == "Travel"){
            if txtbx.text!.isEmpty {
                Trave_Dets = Trave_Det
            }else{
                Trave_Dets = Trave_Det.filter({(product) in
                    let name: String = product.name
                    return name.lowercased().contains(txtbx.text!.lowercased())
                })
            }
        }else if (SelMod == "TO"){
            if txtbx.text!.isEmpty {
                lstrout = AllRout
            }else{
                lstrout = AllRout.filter({(product) in
                    let name: String = product.name
                    return name.lowercased().contains(txtbx.text!.lowercased())
                })
            }
        }
        Drop_Down_TB.reloadData()
    }
}
