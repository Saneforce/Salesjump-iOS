//
//  Brand Availability.swift
//  SAN SALES
//
//  Created by San eforce on 12/05/23.
//

import UIKit
import Alamofire
import FSCalendar

class Brand_Availability: IViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate {
  
    @IBOutlet weak var BrandAV: UITableView!
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var Titview: UIView!
    @IBOutlet weak var veselwindow: UIView!
    @IBOutlet weak var HeadquarterTable: UITableView!
    @IBOutlet weak var txSearchSel: UITextField!
    @IBOutlet weak var vwHQCtrl: UIView!
    @IBOutlet weak var lblRptDt: UILabel!
    @IBOutlet weak var lblSelTitle: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var lblHQ: LabelSelect!
    
    let axn="get/brandavail"
    
    struct lItem: Any {
        let id: String
        let name: String
        let FWFlg: String
    }
    var myDyTp: [String: lItem] = [:]
    var SelMode: String = ""
    var lAllObjSel: [AnyObject] = []
    var lObjSel: [AnyObject] = []
    var lstDist: [AnyObject] = []
    var lstAllRoutes: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    var lstWType: [AnyObject] = []
    var lstHQs: [AnyObject] = []
    var lstJoint: [AnyObject] = []
    var lstJWNms: [AnyObject] = []
    var strJWCd: String = ""
    var strJWNm: String = ""
    var isMulti: Bool = false
    var isDate: Bool = false
    let LocalStoreage = UserDefaults.standard
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",StrRptDt: String="",StrMode: String=""
    var objcalls: [AnyObject]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BrandAV.delegate=self
        BrandAV.dataSource=self
        
        HeadquarterTable.delegate=self
        HeadquarterTable.dataSource=self
        
        calendar.dataSource=self
        calendar.delegate=self
    
        //Brandavailability ()
        getUserDetails()
        
        BTback.addTarget(target: self, action: #selector(GotoHome))
        lblRptDt.addTarget(target: self, action: #selector(selDORpt))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = Date()
        lblRptDt.text = formatter.string(from: date)
        formatter.dateFormat = "yyyy-MM-dd"
        StrRptDt = formatter.string(from: date)
        
        Titview.layer.cornerRadius=10.0
        
     
        
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        let SFName: String=prettyJsonData["sfName"] as? String ?? ""
        
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
                lblHQ.text = name
                let DistData: String=LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+id)!
                if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                    lstDist = list;
                }
                if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                    lstAllRoutes = list
                    lstRoutes = list
                }
            }
            else
            {
                lblHQ.addTarget(target: self, action: #selector(selHeadquaters))
            }
        }
        // Do any additional setup after loading the view.
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        print("did select date \(formatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({formatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        lblRptDt.text = selectedDates[0]
        formatter.dateFormat = "yyyy-MM-dd"
        StrRptDt = formatter.string(from: date)
       Brandavailability ()
        closeWin(self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if BrandAV == tableView { return 55}
        return 42
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==BrandAV { return objcalls.count }
        if tableView==HeadquarterTable {return lObjSel.count}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            if BrandAV == tableView{
                let item: [String: Any] = objcalls[indexPath.row] as! [String : Any]
                let value = item["value"] as! [[String : Any]]
              
                if !value.isEmpty {
                    cell.lblText?.text = value[0]["BName"] as? String
                    cell.TC?.text = String( value[0]["tc"] as! Int)
                   
                    cell.ACC?.text =  String( value[0]["Avail"] as! Int)
                    cell.ECC?.text = String(value[0]["EC"] as! Int)
                }
                
               
            }else{
                let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
                cell.lblText?.text = item["name"] as? String
            }
            
            return cell
            
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
        let name=item["name"] as! String
        let id=String(format: "%@", item["id"] as! CVarArg)
        print(id)
        Brandavailability ()
        var typ: String = ""
        if SelMode=="WT" {
            typ=item["FWFlg"] as! String
            vwHQCtrl.isHidden=false
            if typ != "F" {
                vwHQCtrl.isHidden=true
                
            }
            else if SelMode == "HQ" {
                lblHQ.text = name  //+(item["id"] as! String)
                var DistData: String=""
                if(LocalStoreage.string(forKey: "Distributors_Master_"+id)==nil){
                    Toast.show(message: "No Distributors found. Please will try to sync", controller: self)
                    GlobalFunc.FieldMasterSync(SFCode: id){
                        DistData = self.LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                        let RouteData: String=self.LocalStoreage.string(forKey: "Route_Master_"+id)!
                        if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                            self.lstDist = list;
                        }
                        if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                            self.lstAllRoutes = list
                            self.lstRoutes = list
                        }
                    }
                    return
                }else{
                    DistData = LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                    
                    let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+id)!
                    if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                        lstDist = list;
                    }
                    if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                        lstAllRoutes = list
                        lstRoutes = list
                    }
                }
                if(UserSetup.shared.DistBased == 1){
                    
                }
            }
            lblHQ.text = name
    
        }
        lblHQ.text = name
        closeWin(self)

    }
    func setTodayPlan(){
        var lstPlnDetail: [AnyObject] = []
        if self.LocalStoreage.string(forKey: "Mydayplan") == nil { return }
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        if(lstPlnDetail.count < 1){ return }
        let wtid=String(format: "%@", lstPlnDetail[0]["worktype"] as! CVarArg)
        if let indexToDelete = lstWType.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == wtid }) {

            let typ: String = lstWType[indexToDelete]["FWFlg"] as! String
            let id=String(format: "%@", lstWType[indexToDelete]["id"] as! CVarArg)
            let name: String = lstWType[indexToDelete]["name"] as! String
            
            vwHQCtrl.isHidden=false
            
            
            if typ != "F" {
                vwHQCtrl.isHidden=true
               
            }else{
                
                let sfid=String(format: "%@", lstPlnDetail[0]["subordinateid"] as! CVarArg)
                if let indexToDelete = lstHQs.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == sfid }) {
                    lblHQ.text = lstHQs[indexToDelete]["name"] as? String
                    let sfname: String = lstHQs[indexToDelete]["name"] as! String
                    //new
                    if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+sfid),
                       let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
                        lstDist = list
                    }
                    if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+sfid),
                       let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
                        lstAllRoutes = list
                        lstRoutes = list
                    }
                    
                    
                    myDyTp.updateValue(lItem(id: sfid, name: sfname,FWFlg: ""), forKey: "HQ")
                }
                let stkid=String(format: "%@", lstPlnDetail[0]["stockistid"] as! CVarArg)
                let rtid=String(format: "%@", lstPlnDetail[0]["clusterid"] as! CVarArg)
                if let indexToDelete = lstRoutes.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == rtid }) {
                    let rtname: String = lstRoutes[indexToDelete]["name"] as! String
                    
                    myDyTp.updateValue(lItem(id: rtid, name: rtname,FWFlg: ""), forKey: "RUT")
                }
                let jwids=(String(format: "%@", lstPlnDetail[0]["worked_with_code"] as! CVarArg)).replacingOccurrences(of: ",", with: ";")
                    .components(separatedBy: ";")
                for k in 0...jwids.count-1 {
                    if let indexToDelete = lstJoint.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == jwids[k] }) {
                        let jwid: String = lstJoint[indexToDelete]["id"] as! String
                        let jwname: String = lstJoint[indexToDelete]["name"] as! String
                        
                        strJWCd += jwid+";"
                        strJWNm += jwname+";"
                        let jitm: AnyObject = lstJoint[indexToDelete] as AnyObject
                        lstJWNms.append(jitm)
                    }
                }
            }
            
            myDyTp.updateValue(lItem(id: id, name: name,FWFlg: typ), forKey: "WT")
        }else{
            print(" No Data")
        }
        
    }
    @objc private func selHeadquaters() {
        calendar.isHidden = true
        HeadquarterTable.isHidden = false
        isMulti=false
        lObjSel=lstHQs
        HeadquarterTable.reloadData()
        lblSelTitle.text="Select the Headquarter"
        openWin(Mode: "HQ")
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
        StrRptDt=GlobalFunc.getCurrDateAsString().replacingOccurrences(of: " ", with: "%20")
    }
    
    func Brandavailability (){
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&activityDate=\(StrRptDt)&sfCode=\(SFCode)"

        let aFormData: [String: Any] = [
           "tableName":"vwMyDayPlan","coloumns":"[\"worktype\",\"FWFlg\",\"sf_member_code as subordinateid\",\"cluster as clusterid\",\"ClstrName\",\"remarks\",\"stockist as stockistid\",\"worked_with_code\",\"worked_with_name\",\"dcrtype\",\"location\",\"name\",\"Sprstk\",\"Place_Inv\",\"WType_SName\",\"convert(varchar,Pln_date,20) plnDate\"]","desig":"mgr"]
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result
            {
               
                case .success(let value):
                print(value)
                if let json = value as? [AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                  // let Brand:[String: Any] = json["value"] as! [String: Any]
                    self.objcalls = json
                    self.BrandAV.reloadData()
//                    vstHeight.constant = CGFloat(55*self.objcalls.count)
//                    self.view.layoutIfNeeded()
                    
                }
               case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func selDORpt() {
        calendar.isHidden = false
        HeadquarterTable.isHidden = true
        isDate = true
        openWin(Mode: "DOP")
        lblSelTitle.text="Select the Date"
    }
    func openWin(Mode:String){
        SelMode=Mode
        lAllObjSel = lObjSel
        txSearchSel.text = ""
        veselwindow.isHidden=false
        self.view.endEditing(true)
    }
    
    @IBAction func closeWin(_ sender: Any) {
        veselwindow.isHidden=true
    }
    
}
