//
//  HomePageViewController.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 03/03/22.
//
import Foundation
import UIKit
import Alamofire

class HomePageViewController: IViewController, UITableViewDelegate, UITableViewDataSource{
   
    
   // @IBOutlet weak var mnulistHeight: NSLayoutConstraint!
    
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
   
    var lstMyplnList: [AnyObject] = []
    var TodayDate: [String:AnyObject] = [:]
    var routeNames = [String]()
    var routeNames1 = [String]()
    
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
    var SFCode: String = "", StateCode: String = "", DivCode: String = ""
    public static var selfieLoginActive = 0
    
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        DashBoradTB.delegate=self
        DashBoradTB.dataSource=self
        
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
        /*if let json = try JSONSerialization.jsonObject(with: prettyPrintedJson!, options: []) as? [String: Any] {
                // try to read out a string array
                if let names = json["names"] as? [String] {
                    print(names)
                }
            }*/
        
        strMenuList.append(mnuItem.init(MnuId: 1, MenuName: UserSetup.shared.SecondaryCaption, MenuImage: "mnuPrimary"))
        strMenuList.append(mnuItem.init(MnuId: 2, MenuName: UserSetup.shared.PrimaryCaption, MenuImage: "mnuPrimary"))
        if UserSetup.shared.BrndRvwNd > 0{
            strMenuList.append(mnuItem.init(MnuId: 3, MenuName: UserSetup.shared.BrandReviewVisit, MenuImage: "mnuPrimary"))
        }
        mnulist.constant = CGFloat(87*self.strMenuList.count)
                         self.view.layoutIfNeeded()
        var moveMyPln: Bool=false
        if LocalStoreage.string(forKey: "Mydayplan") == nil {
            moveMyPln=true
        }else{
            let lstMyPlnData: String = LocalStoreage.string(forKey: "Mydayplan")!
            if let list = GlobalFunc.convertToDictionary(text: lstMyPlnData) as? [AnyObject] {
                lstMyplnList = list;
                if lstMyplnList.count<1 {
                    moveMyPln=true
                }
                else{
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    //let finalDate = formatter.date(from: plnDt["plnDate"] as! String)
                    var sPlnDt: String = lstMyplnList[0]["plnDate"] as! String
                    if(sPlnDt.contains(":") == false){ sPlnDt = sPlnDt + " 00:00:00" }
                    let plnDt=formatter.date(from: sPlnDt)
                    let strDate: String = formatter.string(from: Date())
                    print(strDate)
                    let calendar = Calendar.current
                    if(calendar.dateComponents([.day],from: plnDt!,to: Date()).day! > 0){
                        LocalStoreage.removeObject(forKey: "Mydayplan")
                        moveMyPln=true
                    }
                    if("\(String(describing: lstMyplnList[0]["tourplanDone"]))" != "Optional(nil)"){
                        let myDyPln = self.storyboard?.instantiateViewController(withIdentifier: "sbMydayplan") as! MydayPlanCtrl
                        self.navigationController?.pushViewController(myDyPln, animated: true)
                        return
                    }
                }
            }
        }
        if moveMyPln {
            getMyDayPlan(Validate: {
                if self.LocalStoreage.string(forKey: "Mydayplan") == nil {
                    let myDyPln = self.storyboard?.instantiateViewController(withIdentifier: "sbMydayplan") as! MydayPlanCtrl
                    self.navigationController?.pushViewController(myDyPln, animated: true)
                    return
                }else{
                    HomePageViewController.selfieLoginActive = 1
                    let lstMyPlnData: String = self.LocalStoreage.string(forKey: "Mydayplan")!
                    if let list = GlobalFunc.convertToDictionary(text: lstMyPlnData) as? [AnyObject] {
                        self.lstMyplnList = list;
                        
                    }
                    if (self.lstMyplnList.count>0){
                        if("\(String(describing: self.lstMyplnList[0]["tourplanDone"]))" != "Optional(nil)"){
                            let myDyPln = self.storyboard?.instantiateViewController(withIdentifier: "sbMydayplan") as! MydayPlanCtrl
                            self.navigationController?.pushViewController(myDyPln, animated: true)
                            return
                        }
                    }else{
                        let myDyPln = self.storyboard?.instantiateViewController(withIdentifier: "sbMydayplan") as! MydayPlanCtrl
                        self.navigationController?.pushViewController(myDyPln, animated: true)
                        return
                    }
                    self.makeMenuView()
                    self.Dashboard()
                }
            })
        }else{
            makeMenuView()
            Dashboard()
        }
        DashboardNew()
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
        
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
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
                            
                            TodayDetls.append(Todaydate(id: 1, Route: item["RouteName"] as! String, AC: "AC", ACvalue: item["RCCOUNT"] as! Int, TC: "TC", TCvalue: item["calls"] as! Int, PC: "PC", PCvalue: item["order"] as! Int, BAC: "BAC", BACvalue: totalcalls, valuesTotal: item["orderVal"] as! String))
                            
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
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
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
                    let AAmt = MonthData["AAmt"] as! Double
                    x = self.addMonthVstDetControl(aY: x, h: 20, Caption: "Visited", text: String(format: "%i", Mcalls),textAlign: .right)
                    x = self.addMonthVstDetControl(aY: x, h: 20, Caption: "Ordered", text: String(format: "%i", PMcalls),textAlign: .right)
                    x = self.addMonthVstDetControl(aY: x, h: 20, Caption: "Order Value", text: String(format: "%.02f", OAmt),textAlign: .right)
                    x = self.addMonthVstDetControl(aY: x, h: 20, Caption: "Target", text: String(TAmt),textAlign: .right)
                    x = self.addMonthVstDetControl(aY: x, h: 20, Caption: "Achieve", text: String(format: "%.02f", AAmt),textAlign: .right)
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
            let lblAdd: UILabel! = UILabel(frame: CGRect(x: 110, y: aY, width: 80, height: h))
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
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
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
                   let LocalStoreage = UserDefaults.standard
                   LocalStoreage.set(prettyPrintedJson, forKey: "Mydayplan")
                Validate?()
               case .failure(let error):
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



