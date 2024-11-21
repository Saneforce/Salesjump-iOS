//
//  MainMenu.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 21/04/22.
//

import Foundation
import UIKit
import Alamofire

extension Notification.Name {
    static let didRegistered = Notification.Name("didRegistered")
}

class MainMenu: IViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tbMenuDetail: UITableView!
    
    @IBOutlet weak var imgProf: UIImageView!
    @IBOutlet weak var lblSFName: UILabel!
    @IBOutlet weak var lblDesig: UILabel!
    @IBOutlet weak var menuClose: UIImageView!
    
    struct mnuItem: Any {
        let MasId: Int
        let MasName: String
        let MasImage: String
    }
    
    var strMasList:[mnuItem]=[]
    var downloadCount: Int = 0
    var lstDist: [AnyObject] = []
    var lstAllRoutes: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    var lat: Double = 0.0
    var log: Double = 0.0
    var SFCode: String = "", StateCode: String = "", DivCode: String = ""
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        let LocalStoreage = UserDefaults.standard
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        print(prettyJsonData)
        let SFName: String=prettyJsonData["sfName"] as? String ?? ""
        let Desig: String=prettyJsonData["desigCode"] as? String ?? ""
        lblSFName.text = SFName
        lblDesig.text = UserSetup.shared.Desig
        imgProf.layer.cornerRadius = 10
        let ImgUrl = prettyJsonData["Profile_Pic"] as? String ?? ""
        if (ImgUrl == ""){
            imgProf.image = UIImage(named: "profile-picture")
        }else{
            let url = URL(string: ImgUrl)
            if let imageUrl = url {
                let data = try? Data(contentsOf: imageUrl)
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    imgProf.image = image
                    imgProf.contentMode = .scaleToFill
                }
            }
            
        }

        strMasList.append(mnuItem.init(MasId: 1, MasName: "Switch \(UserSetup.shared.StkRoute)", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 2, MasName: "Add New Retailer", MasImage: "NewRetailer"))
       /* strMasList.append(mnuItem.init(MasId: 3, MasName: "Edit Retailer", MasImage: "EditRetailer"))
        strMasList.append(mnuItem.init(MasId: 4, MasName: "Submitted Calls", MasImage: "SubmittedCalls"))
        strMasList.append(mnuItem.init(MasId: 5, MasName: "Order Confirmation", MasImage: "OrderConfirm"))*/
        strMasList.append(mnuItem.init(MasId: 6, MasName: "Admin Forms", MasImage: "AdminForms"))
       /* strMasList.append(mnuItem.init(MasId: 7, MasName: "Outbox", MasImage: "Outbox"))*/
        strMasList.append(mnuItem.init(MasId: 8, MasName: "Reports", MasImage: "Reports"))
        strMasList.append(mnuItem.init(MasId: 9, MasName: "GEO Tagging", MasImage: "GEOTag"))/*
        strMasList.append(mnuItem.init(MasId: 10, MasName: "Closing Stock Entry", MasImage: "ClosingStock"))*/
        strMasList.append(mnuItem.init(MasId: 11, MasName: "Master Sync", MasImage: "MasterSync"))
        strMasList.append(mnuItem.init(MasId:12, MasName: "Submitted Calls", MasImage: "SubmittedCalls"))
        if (UserSetup.shared.AddRoute_Nd == 1){
        strMasList.append(mnuItem.init(MasId:13, MasName: "Add \(UserSetup.shared.StkRoute)", MasImage: "AdminForms"))
        }
        if (UserSetup.shared.AddDistibutor_Nd == 1){
            strMasList.append(mnuItem.init(MasId:14, MasName: "Add \(UserSetup.shared.StkCap)", MasImage: "AdminForms"))
        }
        // Old Conduction  = UserSetup.shared.SrtEndKMNd != 0 && UserSetup.shared.exp_auto == 2
        if (UserSetup.shared.SrtEndKMNd == 1 && UserSetup.shared.exp_auto == 2 ){
            strMasList.append(mnuItem.init(MasId:15, MasName: "Start Expense", MasImage: "Start_Expense"))
            strMasList.append(mnuItem.init(MasId:16, MasName: "End Expense", MasImage: "Day_End"))
        }
        if(UserSetup.shared.SF_type == 2){
            strMasList.append(mnuItem.init(MasId:17, MasName: "Approvals", MasImage: "AdminForms"))
        }
        strMasList.append(mnuItem.init(MasId:18, MasName: "Closing Stock Entry (DB)", MasImage: "SubmittedCalls"))
        if(UserSetup.shared.ClSaleEntryNd == 1){
            strMasList.append(mnuItem.init(MasId:19, MasName: "Closing Sale Entry (DB)", MasImage: "SubmittedCalls"))
        }
        if (UserSetup.shared.CL_SS_ND == 1){
            strMasList.append(mnuItem.init(MasId:20, MasName: "Closing Stock Entry (SS)", MasImage: "SubmittedCalls"))
        }
        strMasList.append(mnuItem.init(MasId: 21, MasName: "Outbox", MasImage: "SwitchRoute"))
        menuClose.addTarget(target: self, action: #selector(closeMenuWin))
        tbMenuDetail.delegate=self
        tbMenuDetail.dataSource=self
        NotificationCenter.default.addObserver(self, selector: #selector(onDidRegistered(_:)), name: .didRegistered, object: nil)
    
//        if UserSetup.shared.BrndRvwNd > 0{
//            selectedid()
//        }
        getUserDetails()
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
    }
    @IBAction func userLogout(_ sender: Any) {
        //dismissedAllAlert()
        
        LocationService.sharedInstance.getNewLocation(location: { location in
            print ("New  : "+location.coordinate.latitude.description + ":" + location.coordinate.longitude.description)
            if let latitude = Double(location.coordinate.latitude.description),
                let longitude = Double(location.coordinate.longitude.description) {

                 // Assign the values to your Double variables
                self.lat = latitude
                self.log = longitude

                 // Now you can use lat and log as Double values
             }
            
        }, error:{ errMsg in
            
            print (errMsg)
            let alert = UIAlertController(title: "Information", message: errMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                return
            })
            
        })
        
        
        
        
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to Logout ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            
            print(self.lat)
            print(self.log)
            self.DayEndSub(lat:self.lat, log: self.log)
            
            UserDefaults.standard.removeObject(forKey: "UserLogged")
            self.dismiss(animated: true)
            /*{
                
                NotificationCenter.default.post(name: .didRegistered, object: nil)
            }
            */
            self.dismiss(animated: true, completion: nil)
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let mainTabBarController = storyboard.instantiateViewController(identifier: "sbLogin")
             
             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    
    func DayEndSub(lat:Double,log:Double){
     
        print(lat)
        print(log)
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

        
        var location_lat = "\(self.lat)"
        var location_log = "\(self.log)"
        print(location_lat)
        print(location_log)
     
        let jsonString2 = "{\"Lattitude\":\"\(location_lat)\",\"Langitude\":\"\(location_log)\",\"currentTime\":\"\(VisitData.shared.cInTime)\",\"date_time\":\"'\(VisitData.shared.cInTime)'\",\"date\":\"'\(date)'\",\"time\":\"\(time)\",\"remarks\":\"\"}"
         
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
                 case .failure(let error):
                     Toast.show(message: error.errorDescription ?? "", controller: self)
                 }
             }
    }
    
    @objc func onDidRegistered(_ notification: Notification) {
       
            let storyboard = UIStoryboard(name: "Main", bundle: nil) 
            let mainTabBarController = storyboard.instantiateViewController(identifier: "sbLogin")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strMasList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = strMasList[indexPath.row].MasName
        cell.imgSelect.image = UIImage(named: strMasList[indexPath.row].MasImage)
        cell.vwContainer.layer.cornerRadius = 5
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lItm: mnuItem=strMasList[indexPath.row]
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        if lItm.MasId == 1 {
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbMydayplan") as! MydayPlanCtrl
            viewController.setViewControllers([myDyPln], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }else if lItm.MasId == 2 {
            let Homevc = storyboard.instantiateViewController(withIdentifier: "HomePageVwControl") as! HomePageViewController
            let addCus = storyboard.instantiateViewController(withIdentifier: "AddNewRetailer") as! AddNewCustomer
            viewController.setViewControllers([Homevc, addCus], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }else if lItm.MasId == 6{
            let rptstoryboard = UIStoryboard(name: "AdminForms", bundle: nil)
            let RptMnuVc = rptstoryboard.instantiateViewController(withIdentifier: "sbAdminMnu") as! AdminMenus
            viewController.setViewControllers([RptMnuVc], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }else if lItm.MasId == 8{
            let rptstoryboard = UIStoryboard(name: "Reports", bundle: nil)
            let RptMnuVc = rptstoryboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
            viewController.setViewControllers([RptMnuVc], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }else if lItm.MasId == 9 {
            let Homevc = storyboard.instantiateViewController(withIdentifier: "HomePageVwControl") as! HomePageViewController
            let geoTag = storyboard.instantiateViewController(withIdentifier: "sbGeoTagging") as! GEOTagging
            viewController.setViewControllers([Homevc, geoTag], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }else if lItm.MasId == 11 {
            let MasSync = storyboard.instantiateViewController(withIdentifier: "MasterSyncVwControl") as! MasterSync
            MasSync.AutoSync = false
            viewController.setViewControllers([MasSync], animated: false)
            //viewController.navigationController?.pushViewController(myDyPln, animated: true)
        }
        else if lItm.MasId == 12 {
            var lstPlnDetail: [AnyObject] = []
            let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
            if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
                lstPlnDetail = list;
            }
            if (lstPlnDetail.isEmpty){
                Toast.show(message: "You haven't submitted my day plan.", controller: self)
                return
            }
            let typ: String = lstPlnDetail[0]["FWFlg"] as! String
            if(typ != "F"){
                Toast.show(message: "Your are submitted 'Non - Field Work'. kindly use switch route", controller: self)
                return
            }else{
                // let rptstoryboard = UIStoryboard(name: "Submittedcalls", bundle: nil)
                //            let Homevc = storyboard.instantiateViewController(withIdentifier: "HomePageVwControl") as! HomePageViewController
                let SBCalls = storyboard.instantiateViewController(withIdentifier: "SubmittedCalls") as! SubmittedCalls
                viewController.setViewControllers([SBCalls], animated: false)
                
                //viewController.navigationController?.pushViewController(myDyPln, animated: true)
            }
        }else if lItm.MasId == 13 {
            var lstPlnDetail: [AnyObject] = []
            let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
            if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
                lstPlnDetail = list;
            }
            if (lstPlnDetail.isEmpty){
                Toast.show(message: "You haven't submitted my day plan.", controller: self)
                return
            }
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "AddRoute") as! Add_Route
            viewController.setViewControllers([myDyPln], animated: false)
        }else if lItm.MasId == 14{
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "AddDistributor") as! Add_Distributor
            viewController.setViewControllers([myDyPln], animated: false)
        }else if lItm.MasId == 15{
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "Start_Expense") as! Start_Expense
             myDyPln.Screan_Heding = "Start Expense"
             myDyPln.Show_Date = false
             myDyPln.Curent_Date = ""
            viewController.setViewControllers([myDyPln], animated: false)
        }else if lItm.MasId == 16{
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "End_Expense") as! End_Expense
            myDyPln.End_exp_title = "End Expense"
            myDyPln.Date_Nd = false
            myDyPln.Date = ""
            viewController.setViewControllers([myDyPln], animated: false)
        }else if lItm.MasId == 17{
            let rptstoryboard = UIStoryboard(name: "Approval", bundle: nil)
            let RptMnuVc = rptstoryboard.instantiateViewController(withIdentifier: "ApprovalMenu") as! Approval_Menu
            viewController.setViewControllers([RptMnuVc], animated: false)
        }else if lItm.MasId == 18{
            let rptstoryboard = UIStoryboard(name: "Main", bundle: nil)
            let RptMnuVc = rptstoryboard.instantiateViewController(withIdentifier: "ClosingStockEntry__DB_") as! ClosingStockEntry__DB_
            viewController.setViewControllers([RptMnuVc], animated: false)
        }else if lItm.MasId == 19{
            let rptstoryboard = UIStoryboard(name: "Main", bundle: nil)
            let RptMnuVc = rptstoryboard.instantiateViewController(withIdentifier: "Closing_Sale_Entry__DB_") as! Closing_Sale_Entry__DB_
            viewController.setViewControllers([RptMnuVc], animated: false)
        }else if lItm.MasId == 20{
            let rptstoryboard = UIStoryboard(name: "Main", bundle: nil)
            let RptMnuVc = rptstoryboard.instantiateViewController(withIdentifier: "ClosingStockEntry__SS_") as! ClosingStockEntry__SS_
            viewController.setViewControllers([RptMnuVc], animated: false)
        }else if lItm.MasId == 21{
            let rptstoryboard = UIStoryboard(name: "Main", bundle: nil)
            let RptMnuVc = rptstoryboard.instantiateViewController(withIdentifier: "sbOutbox") as! OutBox
            viewController.setViewControllers([RptMnuVc], animated: false)
        }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        print(strMasList[indexPath.row].MasName)
    }
    @objc func closeMenuWin(){
        dismiss(animated: false)
        GlobalFunc.movetoHomePage()
    }
    func selectedid(){
        
        var lstPlnDetail: [AnyObject] = []
        if self.LocalStoreage.string(forKey: "Mydayplan") == nil { return }
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            
             
            lstPlnDetail = list;
            print(list)
        }
        
        let sfid=String(format: "%@", lstPlnDetail[0]["subordinateid"] as! CVarArg)
        //MydayPlanCtrl.SfidString = sfid
        print(sfid)
        
       // print(MydayPlanCtrl.SfidString)
        var DistData: String=""
        if(LocalStoreage.string(forKey: "Distributors_Master_"+sfid)==nil){
           // Toast.show(message: "No Distributors found. Please will try to sync", controller: self)
            GlobalFunc.FieldMasterSync(SFCode: sfid){
                DistData = self.LocalStoreage.string(forKey: "Distributors_Master_"+sfid)!
                let RouteData: String=self.LocalStoreage.string(forKey: "Route_Master_"+sfid)!
                if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                    self.lstDist = list;
                    
                    print(list)
                }
                if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                    self.lstAllRoutes = list
                    self.lstRoutes = list
                    print(list)
                }
            }
            return
        }else {
            if let DistData = LocalStoreage.string(forKey: "Distributors_Master_" + sfid) {
                if let RouteData = LocalStoreage.string(forKey: "Route_Master_" + sfid) {
                    if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                        lstDist = list
                        print(list)
                    }
                    
                    if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                        lstAllRoutes = list
                        lstRoutes = list
                        print(list)
                    }
                }
            }
        }

    }
    
    
}

  
