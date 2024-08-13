//
//  HomePageViewController.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 03/03/22.
//
import Foundation
import Alamofire
import UIKit
import MapKit


class HomePageViewController: IViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    
    @IBOutlet weak var ScrolHight: NSLayoutConstraint!
    @IBOutlet weak var hightMnth: NSLayoutConstraint!
    @IBOutlet weak var mnulist: NSLayoutConstraint!
    @IBOutlet weak var Titleview: UIView!
    @IBOutlet weak var vstHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblHeadCap: UILabel!
    @IBOutlet weak var vwMnuList: UIView!
    @IBOutlet weak var vwTdyDash: UIView!
    @IBOutlet weak var vwMnthDash: UIView!
    @IBOutlet weak var vwMainScroll: UIScrollView!
    @IBOutlet weak var mMainMnu: UIImageView!
    @IBOutlet weak var DashBoradTB: UITableView!
    @IBOutlet weak var currentdate: UILabel!
    @IBOutlet weak var Managerdas: UILabel!
    @IBOutlet weak var DayEnd: UILabel!
    @IBOutlet weak var DayEandClosBt: UIButton!
    @IBOutlet weak var DayEndView: UIView!
    @IBOutlet weak var EndRmk: UITextView!
    @IBOutlet weak var DayendBT: UILabel!
    
    
    var lstMyplnList: [AnyObject] = []
    var TodayDate: [String:AnyObject] = [:]
    var routeNames = [String]()
    var routeNames1 = [String]()
    var logOutMod = 1
    
    struct mnuItem: Codable {
        let MnuId: Int
        let MenuName: String
        let MenuImage: String
    }
    
    struct Todaydate: Any {
        let id : Int
        let Route: String
        let AC: String
        let ACvalue: Int
        let TC: String
        let TCvalue : Int
        let PC : String
        let PCvalue : Int
        let BAC : String
        let BACvalue : Int
        let valuesTotal: String
    }
    var axn="get/allcalls"
    var TodayDetls:[Todaydate] = []
    var strMenuList:[mnuItem]=[]
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",attendanceViews = 0,Desig: String = ""
    public static var selfieLoginActive = 0
    
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        UserDefaults.standard.removeObject(forKey: "periodicData")
        LocalStoreage.set("0", forKey: "dayplan")
        AutoLogOut()
        DashBoradTB.delegate=self
        DashBoradTB.dataSource=self
        EndRmk.text = "Enter the Remarks"
        EndRmk.returnKeyType = .done
        EndRmk.delegate = self
        
        Managerdas.layer.cornerRadius = 20
        Managerdas.layer.borderWidth = 3.0
        Managerdas.layer.borderColor = UIColor(red: 0.10, green: 0.59, blue: 0.81, alpha: 1.00).cgColor
        Managerdas.addTarget(target: self, action: #selector(MangerBtTap))
        
        Managerdas.isHidden = true
        if(UserSetup.shared.SF_type == 2){
            Managerdas.isHidden = false
        }
        DayEnd.isHidden = true
        DayEnd.layer.cornerRadius = 20
        DayEnd.layer.borderWidth = 3.0
        DayEnd.layer.borderColor = UIColor(red: 0.10, green: 0.59, blue: 0.81, alpha: 1.00).cgColor//Colore = 10ADC2
        
        DayEnd.addTarget(target: self, action: #selector(OpenDayEndView))
        EndRmk.layer.borderWidth = 2.0
        EndRmk.layer.borderColor = UIColor.gray.cgColor
        EndRmk.layer.cornerRadius = 5
        EndRmk.returnKeyType = .done
        
        EndRmk.delegate = self
              // Add a UITapGestureRecognizer to dismiss the keyboard when tapping outside the UITextView
              let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
              view.addGestureRecognizer(tapGesture)
        DayendBT.layer.cornerRadius = 5
        DayendBT.addTarget(target: self, action: #selector(ClikDayEnd))
        
        
        
        
       // LocalStoreage.removeObject(forKey: "Mydayplan")
        
        //lblHeadCap.font=UIFont.init(name: "Poppins-Bold", size: 20)
        //        for family: String in UIFont.familyNames
        //                {
        //                    print(family)
        //                    for names: String in UIFont.fontNames(forFamilyName: family)
        //                    {
        //                        print("== \(names)")
        //                    }
        //                }
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimeDisplay), userInfo: nil, repeats: true)
        getUserDetails()
        
        
        if UserSetup.shared.SrtEndKMNd == 2{
            //DayEnd_SFC()
        }
        
        
        self.tpMandatoryNeed()
        /*if let json = try JSONSerialization.jsonObject(with: prettyPrintedJson!, options: []) as? [String: Any] {
                // try to read out a string array
                if let names = json["names"] as? [String] {
                    print(names)
                }
            }*/
        
        strMenuList.append(mnuItem.init(MnuId: 1, MenuName: UserSetup.shared.SecondaryCaption, MenuImage: "mnuPrimary"))
        strMenuList.append(mnuItem.init(MnuId: 2, MenuName: UserSetup.shared.PrimaryCaption, MenuImage: "mnuPrimary"))
        print(UserSetup.shared.BrndRvwNd)
        if (UserSetup.shared.BrndRvwNd > 0) {
            strMenuList.append(mnuItem.init(MnuId: 3, MenuName: UserSetup.shared.BrandReviewVisit, MenuImage: "mnuPrimary"))
        }
        if (UserSetup.shared.SuperStockistNeed > 0){
            strMenuList.append(mnuItem.init(MnuId: 4, MenuName: UserSetup.shared.SuperStockistOrder, MenuImage: "mnuPrimary"))
        }
        mnulist.constant = CGFloat(87*self.strMenuList.count)
                         self.view.layoutIfNeeded()
        var moveMyPln: Bool=false
        if LocalStoreage.string(forKey: "Mydayplan") == nil {
            LocalStoreage.set("0", forKey: "dayplan")
            moveMyPln=true
        }else{
            let lstMyPlnData: String = LocalStoreage.string(forKey: "Mydayplan")!
            if let list = GlobalFunc.convertToDictionary(text: lstMyPlnData) as? [AnyObject] {
                lstMyplnList = list;
                if lstMyplnList.count<1 {
                    LocalStoreage.set("0", forKey: "dayplan")
                    moveMyPln=true
                }
                else{
                    //LocalStoreage.set("1", forKey: "dayplan")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    //let finalDate = formatter.date(from: plnDt["plnDate"] as! String)
                    var sPlnDt: String = lstMyplnList[0]["plnDate"] as! String
                    if(sPlnDt.contains(":") == false){ sPlnDt = sPlnDt + " 00:00:00" }
                    let plnDt=formatter.date(from: sPlnDt)
                    let strDate: String = formatter.string(from: Date())
                    print(strDate)
                    let calendar = Calendar.current
//                    if(calendar.dateComponents([.day],from: plnDt!,to: Date()).day! > 0){
//                        LocalStoreage.removeObject(forKey: "Mydayplan")
//                        moveMyPln=true
//                    }
                    if("\(String(describing: lstMyplnList[0]["tourplanDone"]))" != "Optional(nil)"){
                        let myDyPln = self.storyboard?.instantiateViewController(withIdentifier: "sbMydayplan") as! MydayPlanCtrl
                        self.navigationController?.pushViewController(myDyPln, animated: true)
                        return
                    }
                }
            }
        }
        if moveMyPln {
            getMyDayPlan(Validate: { [self] in
                if self.LocalStoreage.string(forKey: "Mydayplan") == nil{
                    LocalStoreage.set("0", forKey: "dayplan")
                    let myDyPln = self.storyboard?.instantiateViewController(withIdentifier: "sbMydayplan") as! MydayPlanCtrl
                    self.navigationController?.pushViewController(myDyPln, animated: true)
                    return
                }else{
                    HomePageViewController.selfieLoginActive = 1
                    let lstMyPlnData: String = self.LocalStoreage.string(forKey: "Mydayplan")!
                    print(lstMyPlnData)
                    if let list = GlobalFunc.convertToDictionary(text: lstMyPlnData) as? [AnyObject] {
                        self.lstMyplnList = list;
                        
                    }
                    if (self.lstMyplnList.count>0){
                        if("\(String(describing: self.lstMyplnList[0]["tourplanDone"]))" != "Optional(nil)"){
                            LocalStoreage.set("0", forKey: "dayplan")
                            let myDyPln = self.storyboard?.instantiateViewController(withIdentifier: "sbMydayplan") as! MydayPlanCtrl
                            self.navigationController?.pushViewController(myDyPln, animated: true)
                            return
                        }
                    }else{
                        LocalStoreage.set("0", forKey: "dayplan")
                        self.Managerdas.isHidden = true
                        let myDyPln = self.storyboard?.instantiateViewController(withIdentifier: "sbMydayplan") as! MydayPlanCtrl
                        self.navigationController?.pushViewController(myDyPln, animated: true)
                        return
                    }
                    self.makeMenuView()
                    self.Dashboard()
                }
            })
        }else{
            LocalStoreage.set("1", forKey: "dayplan")
            makeMenuView()
            Dashboard()
        }
        
        Navstartfrom()
        DashboardNew()
        if UserSetup.shared.SrtEndKMNd != 2{
            LOG_OUTMODE()
        }
        neededMOT()
    }
    
    func tpMandatoryNeed() {

        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"get/tpdetails_mand&sfCode=\(SFCode)&rSF=\(SFCode)&divisionCode=\(DivCode)&State_Code=\(StateCode)")
        
         AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"get/tpdetails_mand&sfCode=\(SFCode)&rSF=\(SFCode)&divisionCode=\(DivCode)&State_Code=\(StateCode)",method: .get,parameters: nil,headers: nil).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                
                guard let response = apiResponse as? AnyObject else {
                    return
                }
                
                guard let currentResponse = response["current"] as? [AnyObject] else{
                    return
                }
                
                guard let nextResponse = response["next"] as? [AnyObject] else{
                    return
                }
                
                if (currentResponse.isEmpty || nextResponse.isEmpty) &&  Int(Date().toString(format: "dd"))! >= Int(UserSetup.shared.tpRemainderDate) ?? 0 && Int(Date().toString(format: "dd"))! <= UserSetup.shared.tpMandatoryNeed && UserSetup.shared.tpNeed == 1 {
                    
                    
                    let LocalStoreage = UserDefaults.standard
                    
                    
                 //  let isShown = LocalStoreage.data(forKey: "isRemainderShown")
                    
                    
                    let isShown = UserDefaults.standard.bool(forKey: "isRemainderShown")
                
                    let today = UserDefaults.standard.string(forKey: "TodayDate")
                    
                    if today != Date().toString(format: "yyyy-MM-dd"){
                        LocalStoreage.set(false, forKey: "isRemainderShown")
                    }
                    
                    print(isShown)
                    if !isShown{
                        let date = Date().toString(format: "yyyy-MM-dd")
                        LocalStoreage.set(true, forKey: "isRemainderShown")
                        LocalStoreage.set(date, forKey: "TodayDate")
                        Toast.show(message: "Reminder Enter the Tour Plan", controller: self)
                    }
                    
                    
                }
                
                
                if UserSetup.shared.tpDcrDeviationNeed == 0 || UserSetup.shared.tpNeed == 1 {
                    
                    let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                    if currentResponse.isEmpty {
                        let tpMnuVc = storyboard.instantiateViewController(withIdentifier: "sbAdminMnu") as! AdminMenus
                        let trPln = storyboard.instantiateViewController(withIdentifier: "sbTourPlanCalenderScreen") as! TourPlanCalenderScreen
                        trPln.date = Date()
                        trPln.isBackEnabled = false
                        viewController.setViewControllers([tpMnuVc,trPln], animated: false)
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
                        return
                    }
                    
                    
                    if UserSetup.shared.tpMandatoryNeed <= Int(Date().toString(format: "dd"))! {
                        
                        if nextResponse.isEmpty {
                            let tpMnuVc = storyboard.instantiateViewController(withIdentifier: "sbAdminMnu") as! AdminMenus
                            let trPln = storyboard.instantiateViewController(withIdentifier: "sbTourPlanCalenderScreen") as! TourPlanCalenderScreen
                            let actualNext = Calendar.current.date(byAdding: .month, value: 1, to: Date())
                            trPln.date = actualNext!
                            trPln.isBackEnabled = false
                            viewController.setViewControllers([tpMnuVc,trPln], animated: false)
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
                            return
                        }
                    }
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter the Remarks"{
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Enter the Remarks"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func getUserDetails(){
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        print(prettyJsonData)
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        StateCode = prettyJsonData["State_Code"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        Desig=prettyJsonData["desigCode"] as? String ?? ""
        attendanceViews=prettyJsonData["attendanceView"] as? Int ?? 0
        
        if attendanceViews == 1{
            LocalStoreage.set("1", forKey: "attendanceView")
        }
       
    }
    
    func Navstartfrom(){
        //Get Design code
            let apiKey1: String = "get/submgr&divisionCode=\(DivCode)&rSF=\(SFCode)&sfcode=\(SFCode)&stateCode=\(StateCode)&desig=\(Desig)"
            let apiKeyWithoutCommas = apiKey1.replacingOccurrences(of: ",&", with: "&")
            
            AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                AFdata in
                switch AFdata.result {
                    
                case .success(let value):
                    //print(value)
                    if let json = value as? [AnyObject]{
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                       
                            if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []),
                               let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
                                    
                                let filterid = jsonArray.filter{ $0["id"] as? String == SFCode }
                                UserSetup.shared.dsg_code = (filterid[0]["dsg_code"] as? Int)!
                            }else{
                                print("Error: Unable to parse JSON")
                            }
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)  //, controller: self
                }
            }
        //Old Conduction
      //  if (UserSetup.shared.SrtEndKMNd != 0 && UserSetup.shared.exp_auto == 2 ){

        if (UserSetup.shared.SrtEndKMNd == 1 && UserSetup.shared.exp_auto == 2 ){
        if let data=LocalStoreage.string(forKey: "dayplan"), data == "1" {
            print(attendanceViews)
            if (attendanceViews == 0) {
                print(LocalStoreage.string(forKey: "attendanceView"))
                if let attendanceView=LocalStoreage.string(forKey: "attendanceView"){
                    print(attendanceView)
                }
                if let attendanceView=LocalStoreage.string(forKey: "attendanceView"){
                    print(attendanceView)
                    if attendanceView == "0"{
                    attendanceViews = Int(attendanceView)!
                    // Naviagte To Strat Expense
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewControllers = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                    let myDyPln = storyboard.instantiateViewController(withIdentifier: "Start_Expense") as! Start_Expense
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let currentDate = Date()
                    let formattedDate = dateFormatter.string(from: currentDate)
                    myDyPln.Screan_Heding = "Start Expense" //
                    myDyPln.Show_Date = true
                    myDyPln.Curent_Date = formattedDate
                    myDyPln.Exp_Nav = ""
                    viewControllers.setViewControllers([myDyPln], animated: false)
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewControllers)
                }
            }
            }
        }
    }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        VisitData.shared.clear()
        PhotosCollection.shared.PhotoList = []
    }
    
    @objc func TimeDisplay()
    {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let someDateTime = formatter.string(from: Date())
        lblTimer.text = "eTime: "+someDateTime
    }
    func DashboardNew(){
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&vanWorkFlag=&State_Code=\(StateCode)"
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result
            {
            case .success(let value):
                //print(value)
                if let json = value as? [String:AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    //self.TodayDate=json
                    let todayData = json["today"] as? [String: Any]
                    print(todayData)
                
                    if let callsArray = todayData?["calls"] as? [[String: Any]] {
                        for item in callsArray {
                            let totalcalls = (item["RCCOUNT"] as! Int) - (item["calls"] as! Int)
                            print(totalcalls)
                            
                            TodayDetls.append(Todaydate(id: 1, Route: item["RouteName"] as? String ?? "", AC: "AC", ACvalue: item["RCCOUNT"] as! Int, TC: "TC", TCvalue: item["calls"] as! Int, PC: "PC", PCvalue: item["order"] as! Int, BAC: "BAC", BACvalue: totalcalls, valuesTotal: String(item["orderVal"] as! Double)))
                            
                            self.currentdate.text = item["Adate"] as? String
                        }
                    }
//                    mnulistHeight.constant = CGFloat(70*self.strMenuList.count)
//                    self.view.layoutIfNeeded()
                    self.DashBoradTB.reloadData()
                    vstHeight.constant = CGFloat(60*self.TodayDetls.count)
                    self.view.layoutIfNeeded()
                    
                   
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == DashBoradTB {
               let todayDetail = TodayDetls[indexPath.row]
               
               // Check if ACvalue is 0
               if todayDetail.ACvalue == 0 {
                   // Return the desired height for the empty cell
                   return 0.0 // Set to 0 to hide the cell
               }
           }
           
           // Return the default height for other cells
           return 60 // Modify this value based on your cell's height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if tableView == DashBoradTB {
            return TodayDetls.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        
        if tableView == DashBoradTB {
            let todayDetail = TodayDetls[indexPath.row]
            
            // Check if ACvalue is 0
            if todayDetail.ACvalue == 0 {
                // Return an empty cell
                return UITableViewCell()
            }
            
            cell.RouteLb.text = todayDetail.Route
            cell.AvlaCalls.text = String(todayDetail.ACvalue)
            cell.TotalCalls.text = String(todayDetail.TCvalue)
            cell.PcCalls.text = String(todayDetail.PCvalue)
            cell.BAC.text = String(todayDetail.BACvalue)
            cell.Toalvalue.text = String(todayDetail.valuesTotal)
        }
        
        return cell
    }
    
    
    func Dashboard(){
        let aFormData: [String: Any] = ["orderBy":"[\"name asc\"]","desig":"mgr"]
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        
        let apiKey="get/calls&divisionCode=" + DivCode + "&rSF=" + SFCode + "&sfCode=" + SFCode
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            switch AFdata.result
            {
               
                case .success(let value):
                if let json = value as? [String: Any] {
                    let todayData:[String:Any] = json["today"] as! [String: Any]
                    print(json)
                    var x: Double = 40
                    var TCalls=0
                    var mOrdVal: Double = 0
                    if (todayData["RCCOUNT"].debugDescription != "Optional(<null>)"){
                        TCalls = todayData["RCCOUNT"] as! Int
                    }
                    if (todayData["orderVal"].debugDescription != "Optional(<null>)"){
                        mOrdVal = todayData["orderVal"] as! Double
                    }
                    let calls = todayData["calls"] as! Int
                    let Pcalls = todayData["order"] as! Int
                    x = self.addVstDetControl(aY: x, h: 20, Caption: "Available Calls", text: String(format: "%i", TCalls),textAlign: .right)
                    x = self.addVstDetControl(aY: x, h: 20, Caption: "Visited", text: String(format: "%i", calls),textAlign: .right)
                    x = self.addVstDetControl(aY: x, h: 20, Caption: "Ordered", text: String(format: "%i", Pcalls),textAlign: .right)
                    x = self.addVstDetControl(aY: x, h: 20, Caption: "Order Value", text: String(format: "%.02f", mOrdVal),textAlign: .right)
                    x = self.addVstDetControl(aY: x, h: 20, Caption: "Yet To Visit", text: String(format: "%i", TCalls-calls),textAlign: .right)
                    
                    
                    let MonthData:[String:Any] = json["month"] as! [String: Any]
                    x = 40
                    print(MonthData)
                    let Mcalls = MonthData["calls"] as! Int
                    let PMcalls = MonthData["order"] as! Int
                    if (MonthData["orderVal"].debugDescription != "Optional(<null>)"){
                        mOrdVal = MonthData["orderVal"] as! Double
                    }
                    let OAmt = mOrdVal
                    var TAmt = ""
                    if let targetValue = MonthData["target_val"] as? String {

                        TAmt = targetValue
                    } else {
                        TAmt = "0"
                    }
                    //let AAmt = MonthData["orderVal"] as! Double ?? 0
                    x = self.addMonthVstDetControl(aY: x, h: 25, Caption: "Visited", text: String(format: "%i", Mcalls),textAlign: .right)
                    x = self.addMonthVstDetControl(aY: x, h: 25, Caption: "Ordered", text: String(format: "%i", PMcalls),textAlign: .right)
                    x = self.addMonthVstDetControl(aY: x, h: 25, Caption: "Order Value", text: String(format: "%.02f", OAmt),textAlign: .right)
                    x = self.addMonthVstDetControl(aY: x, h: 25, Caption: "Target", text: String(TAmt),textAlign: .right)
                    x = self.addMonthVstDetControl(aY: x, h: 25, Caption: "Achieve", text: String(format: "%.02f", OAmt),textAlign: .right)
                }
               case .failure(let error):
                   print(error.errorDescription!)
                    /*let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                        return
                    })
                    self.present(alert, animated: true)*/
            }
        }
    }
    func makeMenuView(){
        
        let hlfWidth = (vwMnuList.frame.width-20)/2
        var mnux:CGFloat=0
        var mnuy:CGFloat=0
        
        for sItem in strMenuList {
            let vwMainMnu: UIImageView=UIImageView(frame: CGRect(x: mnux, y: mnuy, width: hlfWidth, height: 124.00))
            let mnuImg: UIImageView = UIImageView(frame: CGRect(x: (hlfWidth/2)-20, y: 15, width: 50.00, height: 50.00))
            let mnuTextUI: UILabel = UILabel(frame: CGRect(x: 0, y: 75, width: hlfWidth, height: 30.00))
           
            vwMainMnu.image=UIImage(named: "mnuBg")
            mnuImg.image=UIImage(named: sItem.MenuImage)
            mnuTextUI.text=sItem.MenuName
            mnuTextUI.textAlignment=NSTextAlignment.center
            mnuTextUI.font=UIFont(name: "Poppins-Bold", size: 14)
            mnuTextUI.textColor=UIColor.white
            
            vwMainMnu.addSubview(mnuImg)
            vwMainMnu.addSubview(mnuTextUI)
            vwMainMnu.tag=sItem.MnuId
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(moveMenuScreen))
            vwMainMnu.addGestureRecognizer(tap)
            vwMainMnu.isUserInteractionEnabled = true
            
            let openmnu = UITapGestureRecognizer(target: self, action: #selector(openMenu))
            mMainMnu.addGestureRecognizer(openmnu)
            mMainMnu.isUserInteractionEnabled = true
            //vwMainMnu.addTarget(self, action: #selector(moveMenuScreen(self)), for: .touchUpInside)
            if(mnux==0){ mnux=hlfWidth+20 } else{ mnux=0 }
            if(mnux==0){ mnuy+=130 }
            
            vwMnuList.addSubview(vwMainMnu)
        }
        if(mnux != 0) {mnuy+=130}
       
        var newFrame = vwMnuList.frame
        newFrame.size.height = mnuy
        vwMnuList.frame = newFrame
        //vwMnuList.backgroundColor=UIColor.gray
        
          
        var xfrm = vwTdyDash.frame
        xfrm.origin.y = mnuy+15
        vwTdyDash.frame = xfrm
        mnuy+=xfrm.height+15
        
        xfrm = vwMnthDash.frame
        xfrm.origin.y = mnuy+15
        vwMnthDash.frame = xfrm
        mnuy+=xfrm.height+15
        
        vwMainScroll.contentSize = CGSize(width:view.frame.width, height: mnuy)
        
    }
    
    func addVstDetControl(aY: Double, h: Double, Caption: String, text: String,textAlign: NSTextAlignment = .left) -> Double {
        if text != "" {
            let lblCap: UILabel! = UILabel(frame: CGRect(x: 10, y: aY, width: 180, height: h))
            lblCap.font = UIFont(name: "Poppins-Regular", size: 13)
            lblCap.text = Caption
            let lblAdd: UILabel! = UILabel(frame: CGRect(x: 110, y: aY, width: 80, height: h))
            lblAdd.font = UIFont(name: "Poppins-Regular", size: 13)
            //lblAdd.backgroundColor = UIColor.orange
            lblAdd.text = text
            lblAdd.textAlignment = textAlign
            vwTdyDash.addSubview(lblCap)
            vwTdyDash.addSubview(lblAdd)
            
            return aY + lblAdd.frame.height + 5
        } else {
            return aY + 5
        }
    }
    func addMonthVstDetControl(aY: Double, h: Double, Caption: String, text: String,textAlign: NSTextAlignment = .left) -> Double {
        if text != "" {
            let lblCap: UILabel! = UILabel(frame: CGRect(x: 10, y: aY, width: 180, height: h))
            lblCap.font = UIFont(name: "Poppins-Regular", size: 13)
            lblCap.text = Caption
            let lblAdd: UILabel! = UILabel(frame: CGRect(x: 190, y: aY, width: 80, height: h))
            lblAdd.font = UIFont(name: "Poppins-Regular", size: 13)
            lblAdd.textAlignment = textAlign
            //lblAdd.backgroundColor = UIColor.orange
            lblAdd.text = text
            vwMnthDash.addSubview(lblCap)
            vwMnthDash.addSubview(lblAdd)
            
            return aY + lblAdd.frame.height + 5
        } else {
            return aY + 5
        }
    }
    func getMyDayPlan(Validate:(() -> Void)?){
        let apiKey: String = "table/list&divisionCode="+DivCode+"&rSF="+SFCode+"&sfCode="+SFCode
        let aFormData: [String: Any] = [
           "tableName":"vwMyDayPlan","coloumns":"[\"worktype\",\"FWFlg\",\"sf_member_code as subordinateid\",\"cluster as clusterid\",\"ClstrName\",\"remarks\",\"stockist as stockistid\",\"worked_with_code\",\"worked_with_name\",\"dcrtype\",\"location\",\"name\",\"Sprstk\",\"Place_Inv\",\"WType_SName\",\"convert(varchar,Pln_date,20) plnDate\"]","desig":"mgr"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            switch AFdata.result
            {
               
                case .success(let json):
                   guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                       print("Error: Cannot convert JSON object to Pretty JSON data")
                       return
                   }
                   guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                       print("Error: Could print JSON in String")
                       return
                   }
                    print(prettyPrintedJson)
                   let LocalStoreage = UserDefaults.standard
                   LocalStoreage.set(prettyPrintedJson, forKey: "Mydayplan")
                Validate?()
               case .failure(let error):
                print(error)
                Toast.show(message: error.errorDescription!, controller: self)
            }
        }
    }
    @objc func moveMenuScreen(_ sender: UITapGestureRecognizer) {
        let menuID: Int = sender.view?.tag ?? 0
        
        var lstPlnDetail: [AnyObject] = []
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        let typ: String = lstPlnDetail[0]["FWFlg"] as! String
        if(typ != "F"){
            Toast.show(message: "Your are submitted 'Non - Field Work'. kindly use switch route", controller: self)
            return
        }
        switch menuID {
        case 1:
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbSecondaryVisit") as!  SecondaryVisit
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbPrimaryVisit") as!  PrimaryVisit
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc=self.storyboard?.instantiateViewController(withIdentifier:"sbbrandReviewVisit") as! BrandReviewVisit
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc=self.storyboard?.instantiateViewController(withIdentifier:"superStockistOrder") as! SuperStockistOrder
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    @objc func openMenu(_ sender: UITapGestureRecognizer){
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMainmnu") as!  MainMenu
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve //.crossDissolve
        
        self.present(vc, animated: true, completion: nil)
    }
    @objc func MangerBtTap(){
        let storyboard = UIStoryboard(name: "ManagerDashboard", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
    let myDyPln = storyboard.instantiateViewController(withIdentifier: "ManagerDashboard") as! ManagerDashboard
       self.navigationController?.pushViewController(myDyPln, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
    @objc func OpenDayEndView(){
        if UserSetup.shared.SrtEndKMNd == 1{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "End_Expense") as! End_Expense
            myDyPln.End_exp_title = "Day End Plan"
            myDyPln.Date_Nd = true
            myDyPln.Date = formattedDate
            viewController.setViewControllers([myDyPln], animated: false)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if ( UserSetup.shared.SrtEndKMNd == 2){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "Day_End_SFC") as! Day_End_SFC
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = dateFormatter.string(from: Date())
            myDyPln.Date_Time = currentDate
            viewController.setViewControllers([myDyPln], animated: false)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else{
             DayEndView.isHidden = false
        }
    }
    
    @IBAction func DayEndView(_ sender: Any) {
        DayEndView.isHidden = true
    }
    @objc func ClikDayEnd(){
        LocationService.sharedInstance.getNewLocation(location: { location in
            print ("New  : "+location.coordinate.latitude.description + ":" + location.coordinate.longitude.description)
            //self.ShowLoading(Message: "Submitting Please wait...")
           // self.saveDayTP(location: location)
            self.DayEndSub(Loction: location)
        }, error:{ errMsg in
            //self.LoadingDismiss()
            print (errMsg)
            let alert = UIAlertController(title: "Information", message: errMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                return
            })
        })
    }
    func DayEndSub(Loction: CLLocation){
     
        EndRmk.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        let axn = "get/logouttime"
         let apiKey: String = "\(axn)&divisionCode=\(DivCode)&SrtEndNd=0&sfCode=\(SFCode)"

         VisitData.shared.cInTime = GlobalFunc.getCurrDateAsString()
         var date = ""
         var time = ""
         let dateString = VisitData.shared.cInTime
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

         // Convert the string to a Date object
         if let inputDate = dateFormatter.date(from: dateString) {
             // Extract date and time components
             let calendar = Calendar.current
             let dateComponents = calendar.dateComponents([.year, .month, .day], from: inputDate)
             let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: inputDate)

             // Print the date and time components
             if let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day,
                let hour = timeComponents.hour, let minute = timeComponents.minute, let second = timeComponents.second {
                 print("Date: \(year)-\(month)-\(day)")
                 print("Time: \(hour):\(minute):\(second)")
                 date = "\(year)-\(month)-\(day)"
                 time = "\(hour):\(minute):\(second)"
             }
         } else {
             print("Unable to parse the date string.")
         }

         // Now you can use the 'date' and 'time' variables as needed
         print("Formatted Date: \(date)")
         print("Formatted Time: \(time)")

         
         
         
         print(VisitData.shared.cInTime)
        if EndRmk.text == "Enter the Remarks" {
            EndRmk.text = ""
        }
         var Remardata = ""
         if let Reamrk = EndRmk.text{
             print(Reamrk)
             Remardata = Reamrk
         }
        if Remardata == "" {
            Toast.show(message: "Enter the Remarks", controller: self)
            return
        }
   
        var location_lat = Loction.coordinate.latitude.description
        var location_log = Loction.coordinate.longitude.description
    
        let jsonString2 = "{\"Lattitude\":\"\(location_lat)\",\"Langitude\":\"\(location_log)\",\"currentTime\":\"\(VisitData.shared.cInTime)\",\"date_time\":\"'\(VisitData.shared.cInTime)'\",\"date\":\"'\(date)'\",\"time\":\"\(time)\",\"remarks\":\"\(Remardata)\"}"
         
             let params: Parameters = [
                 "data":jsonString2
             ]
             print(params)
         AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                 
                 AFdata in
                 print(AFdata)
                 //self.LoadingDismiss()
                 switch AFdata.result
                 {
                 case .success(let value):
                     print(value)

                     DayEndView.isHidden = true
                     LOG_OUTMODE()
                     Toast.show(message: "Day End has been submitted successfully", controller: self)
                 case .failure(let error):
                     Toast.show(message: error.errorDescription ?? "", controller: self)
                 }
             }
    }
  

        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    func LOG_OUTMODE() {
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + "get/logout_day&sfCode=\(SFCode)", method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                if let json = value as? [String: Any], let cnt = json["cnt"] as? Int {
                    print(cnt)
                    logOutMod = cnt
                    print(logOutMod)
                    DayEnd.isHidden = true
                    if (self.lstMyplnList.count>0){
                        if (logOutMod == 0){
                            DayEnd.isHidden = false
                        }
                    }else{
                        self.Managerdas.isHidden = true
                    }
                   
                } else {
                    print("Invalid response format")
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    func neededMOT(){
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + "neededMOTSFC&sf_code=\(SFCode)&Date=", method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                if let json = value as? [String: Any]{
                    print(json)
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    func AutoLogOut(){
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatters.string(from: Date())
        let defaults = UserDefaults.standard
        var storedDate_Today = ""
        if let storedDate = defaults.string(forKey: "storedDate") {
            storedDate_Today = storedDate
        }
      
        if (storedDate_Today != formattedDate){
            defaults.set(formattedDate, forKey: "storedDate")
            UserDefaults.standard.removeObject(forKey: "UserLogged")
            self.dismiss(animated: true)
         
            self.dismiss(animated: true, completion: nil)
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let mainTabBarController = storyboard.instantiateViewController(identifier: "sbLogin")
             
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            return
        }

    }
    
    func DayEnd_SFC(){
        let axn = "get/dayendsfc"
        let apiKey: String = "\(axn)&rSF=\(SFCode)&sfCode=\(SFCode)"
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL2 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                if let json = value as? [AnyObject]{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let currentDate = dateFormatter.string(from: Date())
                    let Date_Time = json[0]["Date_Time"] as? String ?? ""
                    let Enddateand_time = json[0]["Enddateand_time"] as? String ?? ""
                    if currentDate == Date_Time{
                        if Enddateand_time == ""{
                            DayEnd.isHidden = false
                        }else{
                            DayEnd.isHidden = true
                        }
                        
                    }else{
                        if Enddateand_time == ""{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                            let myDyPln = storyboard.instantiateViewController(withIdentifier: "Day_End_SFC") as! Day_End_SFC
                            myDyPln.Date_Time = Date_Time
                            viewController.setViewControllers([myDyPln], animated: false)
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
                            Toast.show(message:"Please submit past day end missing date(\(Date_Time))", controller: self)
                        }
                    }
                } else {
                    print("Invalid response format")
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    func allLoacl(){
        let userDefaults = UserDefaults.standard

        // Get all the items as a dictionary
        let allItems = userDefaults.dictionaryRepresentation()

        // Print all the items
        for (key, value) in allItems {
            print("\(key): \(value)")
        }
    }
}

//Username: Sankafo2,aachi-testso2
//Paswoord :123,123

//AWS-SQL
//IP: 13.200.61.175,10433
//Username : sa
//Password: SanMedia#123


//Server username
//username =Developer
//Password = DevFMCG@1234

//MYSORE DEMO 1
//123

//ENGL-MR00121
//PASS = EBIL

