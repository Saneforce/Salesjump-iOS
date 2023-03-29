//
//  BrandReviewVisit.swift
//  SAN SALES
//
//  Created by San eforce on 10/03/23.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

class BrandReviewVisit: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var btrmktp: UIButton!
    @IBOutlet weak var txvRmks: UITextView!
    @IBOutlet weak var lblSelTitle: UILabel!
    @IBOutlet weak var tbDataSelect: UITableView!
    @IBOutlet weak var txSearchSel: UITextField!
    @IBOutlet weak var veselwindow: UIView!
    @IBOutlet weak var lblselectcustomer: LabelSelect!
    @IBOutlet weak var ActionTable: UITableView!
    @IBOutlet weak var Checkboxtable: UITableView!
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var BTcam: UIView!
    @IBOutlet weak var itmSmryHeight: NSLayoutConstraint!
    
    let product:[String] = ["Start Time","Customer Channal","Class","SCH Enrolment","Potential","Monthly Order Value","Last Order Amount","Last Order Date","Last Visted","Remark","Mobile Number"
    ]
    let action :[String] = ["10.00 AM","123","5"," 00","35","  0.25"," 3.5","  6.32","8.2 ","3.0"," 1234567891",]
    
    var valandkey = ["Customer" : "Customer Channal", "Calss" : "Customer Class", "SCH " : "Enrolment", "Order" : "Monthly order value"]

    
    
    struct lItem: Any {
          let id: String
          let name: String
      }
    let axn="get/precall"
    var objgetprecall: [AnyObject]=[]
    var lstAllProducts: [AnyObject] = []
    var lstBrands: [AnyObject] = []
    var lstPlnDetail: [AnyObject] = []
    var lstRetails: [AnyObject] = []
      var vstDets: [String: lItem] = [:]
      var lstRmksTmpl: [AnyObject] = []
      var lstRateList: [AnyObject] = []
      var lstSchemList: [AnyObject] = []
      var SelMode: String = ""
      var lObjSel: [AnyObject] = []
      var lAllObjSel: [AnyObject] = []
      var lstSelJWNms: [AnyObject] = []
    var lstJoint : [AnyObject] = []
      var sbBrandReviewOrder = [ Int:Bool]()
      var strSelJWCd: String = ""
      var strSelJWNm: String = ""
     // var mytest:[mnuItem]=[]
      var isDate: Bool = false
      var isMulti: Bool = false
    var DataSF: String = ""
    var eKey: String = ""
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",StrRptDt: String="",StrMode: String=""
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let LocalStoreage = UserDefaults.standard
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        eKey = String(format: "EK%@-%i", SFCode,Int(Date().timeIntervalSince1970))

        let JointWData: String=LocalStoreage.string(forKey: "Jointwork_Master")!
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        let RmkDatas: String=LocalStoreage.string(forKey: "Templates_Master")!
      
        var objname = "Brand_Master"
        if UserSetup.shared.BrndRvwNd == 2 {
            var objname = "Products_Master"
        }
        
        
        let lstCatData: String=LocalStoreage.string(forKey: objname)!
        
        if let list = GlobalFunc.convertToDictionary(text: lstCatData) as? [AnyObject] {
            lstBrands = list;
        }
        
        
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        DataSF = self.lstPlnDetail[0]["subordinateid"] as! String
        
        if let list = GlobalFunc.convertToDictionary(text: RmkDatas) as? [AnyObject] {
            lstRmksTmpl = list;
        }
        let lstRetailData: String = LocalStoreage.string(forKey: "Retail_Master_"+DataSF)!
        if let list = GlobalFunc.convertToDictionary(text: lstRetailData) as? [AnyObject] {
            lstRetails = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: JointWData) as? [AnyObject] {
            lstJoint = list;
        }
        
        
        getUserDetails()
        
        Checkboxtable.delegate=self
        Checkboxtable.dataSource=self
        
        ActionTable.delegate=self
        ActionTable.dataSource=self
        
        tbDataSelect.delegate=self
        tbDataSelect.dataSource=self
        
        btrmktp.addTarget(target: self, action: #selector(selRmksTemp))
        lblselectcustomer.addTarget(target: self, action: #selector(selRetails))
        BTback.addTarget(target: self, action: #selector(GotoHome))
        BTcam.addTarget(target: self, action: #selector(openCamera))
         
        // Do any additional setup after loading the view.
    }
    @objc private func selRmksTemp() {
        isDate = false
        isMulti=false
        lObjSel=lstRmksTmpl
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Reason"
        openWin(Mode: "RMK")
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if ActionTable == tableView { return 55}
            return 42
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Checkboxtable == tableView { return lstBrands.count }
        if ActionTable == tableView { return objgetprecall.count}
//        if ActionTable == tableView {return product.count}
//        if ActionTable == tableView{return action.count}
       
        return lObjSel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:cellListItem
               if Checkboxtable == tableView{
                   cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
                   let item: [String: Any]=lstBrands[indexPath.row] as! [String : Any]
                   //let productitem: [String: Any]=lstAllProducts[indexPath.row] as! [String : Any]
                   cell.imgSelect.addTarget(target: self, action: #selector(self.checkboxTapped(_:)))
                   cell.imgSelect2.addTarget(target: self, action: #selector(self.checkboxunTapped(_:)))
                   cell.lblText?.text = item["name"] as? String
                  // cell.lblText?.text = productitem["name"] as? String
                   cell.imgSelect.image = UIImage(named:"uncheckbox")
                   cell.selectionStyle = .none
                  
               }
            else if  ActionTable == tableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
//                cell.lblText.text = product[indexPath.row]
//                cell.ActionTB.text = action[indexPath.row]
               let item: [String: Any] = objgetprecall[indexPath.row] as! [String : Any]
                cell.lblText?.text = item["name"] as? String
                cell.ActionTB?.text = item["Last_Visit_Date"] as? String
                cell.ActionTB1?.text = item["Last_Order_Date"] as? String
                cell.ActionTB2?.text = item["POTENTIAL"] as? String
                cell.ActionTB3?.text = item["LastorderAmount"] as? String
                cell.ActionTB4?.text = item["StartTime"] as? String
                cell.ActionTB5?.text = item [""] as? String
                
           }
        else{
                cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
                let item: [String: Any] = lObjSel[indexPath.row] as! [String : Any]
                cell.lblText?.text = item["name"] as? String
                cell.imgSelect?.image = nil
                if SelMode == "JWK" {
                    let sid=(item["id"] as! String)
                    let sfind: String = (";"+sid+";")
                    if let range: Range<String.Index> = (";"+strSelJWCd).range(of: sfind) {
                        cell.imgSelect?.image = UIImage(named: "Select")
                    }
                }
                
            }
          return cell
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
    func selectcustomer(mslno : String ){
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&Msl_No=\(mslno)&sfCode=\(SFCode)&Mode=\(StrMode)"
//        let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"'" + (self.lstPlnDetail[0]["worktype"] as! String) + "'\",\"Town_code\":\"'" + (self.lstPlnDetail[0]["clusterid"] as! String) + "'\",\"RateEditable\":\"''\",\"dcr_activity_date\":\"'" + VisitData.shared.cInTime + "'\",\"Daywise_Remarks\":\"'" + VisitData.shared.VstRemarks.name + "'\",\"eKey\":\"" + self.eKey + "\",\"rx\":\"'1'\",\"rx_t\":\"''\",\"DataSF\":\"'" + DataSF + "'\"}},{\"Activity_Stockist_Report\":{\"Stockist_POB\":\"" + VisitData.shared.PayValue + "\",\"Worked_With\":\"''\",\"location\":\"'" + "'\",\"geoaddress\":\"" + "\",\"stockist_code\":\"'" + VisitData.shared.CustID + "'\",\"superstockistid\":\"''\",\"Stk_Meet_Time\":\"'" + VisitData.shared.cInTime + "'\",\"modified_time\":\"'" + VisitData.shared.cInTime + "'\",\"date_of_intrument\":\"" + VisitData.shared.DOP.id + "\",\"intrumenttype\":\""+VisitData.shared.PayType.id+"\",\"orderValue\":\"" + "\",\"Aob\":0,\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"CheckoutTime\":\"" + VisitData.shared.cOutTime + "\",\"f_key\":{\"Activity_Report_Code\":\"'Activity_Report_APP'\"},\"PhoneOrderTypes\":" + VisitData.shared.OrderMode.id + "}},{\"Activity_Stk_POB_Report\":[" + "]},{\"Activity_Stk_Sample_Report\":[]},{\"Activity_Event_Captures\":[" +  "]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]}]"
//        let jsonData = try? JSONSerialization.data(withJSONObject: jsonString, options: [])
//        let params: Parameters = [
//            "data": jsonString
//        ]
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                AFdata in
                switch AFdata.result
            {
                    
                case .success(let value):
                    if let json = value as? [AnyObject]{
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        
                        print(prettyPrintedJson)
                    
                        self.objgetprecall = json
                        self.ActionTable.reloadData()
                        self.itmSmryHeight.constant = CGFloat(42*self.objgetprecall.count)
                        self.view.layoutIfNeeded()
//                        ContentHeight.constant = 100+CGFloat(55*self.objVstDetail.count)+CGFloat(42*self.objItmSmryDetail.count)
//                        self.view.layoutIfNeeded()
//                        print(ContentHeight.constant)
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)
                }
        }
    }
    
    @objc func checkboxTapped(_ sender: UITapGestureRecognizer) {
            let cell: cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
            let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!) as! UITableView
            let indxPath: IndexPath = tbView.indexPath(for: cell)!
            
            if cell.ischeck == false
            {
                cell.ischeck = true
                cell.imgSelect.image = UIImage(named:"checkbox")
               // print("\(lstAllProducts[indxPath.row])")
                print("\(lstBrands[indxPath.row])")
            }
            else
            {
                cell.ischeck = false
                cell.imgSelect.image = UIImage(named:"uncheckbox")
                //print("\(lstAllProducts[indxPath.row])")
                print("\(lstBrands[indxPath.row])")
            }
        }
    @objc func checkboxunTapped (_ sender: UITapGestureRecognizer){
            let cell: cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
            let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!) as! UITableView
            let indxPath: IndexPath = tbView.indexPath(for: cell)!
            
            if cell.ischeck == false
            {
                cell.ischeck = true
                cell.imgSelect2.image = UIImage(named:"checkbox")
                //print("\(lstAllProducts[indxPath.row])")
                print("\(lstBrands[indxPath.row])")
            }
            else
            {
                cell.ischeck = false
                cell.imgSelect2.image = UIImage(named:"uncheckbox")
               // print("\(lstAllProducts[indxPath.row])")
                print("\(lstBrands[indxPath.row])")
            }
            
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
        let name=item["name"] as! String
        let id=String(format: "%@", item["id"] as! CVarArg)
        lblselectcustomer.text = name
        selectcustomer(mslno: id)
        clswindow(self)
    }
    func validateForm() -> Bool {
        VisitData.shared.VstRemarks.name = txvRmks.text
        if VisitData.shared.CustID == "" {
            Toast.show(message: "Select the Retailer", controller: self)
            return false
        }
        return true
    }
      @IBAction func searchBytext(_ sender: Any) {
          
          let txtbx: UITextField = sender as! UITextField
          if txtbx.text!.isEmpty {
              lObjSel = lAllObjSel
          }else{
              lObjSel = lAllObjSel.filter({(product) in
                  let name: String = String(format: "%@", product["name"] as! CVarArg)
                  return name.lowercased().contains(txtbx.text!.lowercased())
              })
          }
          tbDataSelect.reloadData()
      }

    func openWin(Mode:String){
        SelMode=Mode
        lAllObjSel = lObjSel
        txSearchSel.text = ""
        veselwindow.isHidden=false
        self.view.endEditing(true)
        
    }
    @objc private func selRetails() {
        isMulti=false
        self.lAllObjSel = []
        self.lObjSel = []
        self.tbDataSelect.reloadData()
        if UserSetup.shared.Fenching == true && VisitData.shared.OrderMode.id == "0" {
            LocationService.sharedInstance.getNewLocation(location: { location in
                print ("New  : "+location.coordinate.latitude.description + ":" + location.coordinate.longitude.description)
                self.lObjSel=self.lstRetails.filter({(retail) in
                    if retail["lat"] as! String != "" {
                    var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
                    let lat: Double = Double("\(retail["lat"] as! String)")!
                    let lon: Double = Double("\(retail["long"] as! String)")!
                    
                    center.latitude = lat
                    center.longitude = lon

                    let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
                    let distance = location.distance(from: loc)
                    let distanceInKM = distance/1000
                        return Bool(distanceInKM <= UserSetup.shared.DistRad)
                    }else{
                        return false
                    }
                })
                self.lAllObjSel = self.lObjSel
                self.tbDataSelect.reloadData()
            }, error:{ errMsg in
                print (errMsg)
            })
        } else {
            self.lObjSel=self.lstRetails.filter({(retail) in
                print(lstPlnDetail[0]["clusterid"] as! String )
                if VisitData.shared.OrderMode.id == "1" {
                    return true
                }
                if retail["town_code"] as! String == lstPlnDetail[0]["clusterid"] as! String {
                    return true
                }
                return false
            })
            self.lAllObjSel = self.lObjSel
            self.tbDataSelect.reloadData()
        }
        
        lblSelTitle.text="Select the Retailer"
        openWin(Mode: "RET")
      }
    @objc private func GotoHome() {
        self.dismiss(animated: true, completion: nil)
        GlobalFunc.movetoHomePage()
    }
    @objc private func openCamera(){
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "PhotoGallary") as!  PhotoGallary
        //let vc=self.storyboard?.instantiateViewController(withIdentifier: "CameraVwCtrl") as!  CameraService
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clswindow(_ sender: Any) {
        veselwindow.isHidden=true
    }
}
