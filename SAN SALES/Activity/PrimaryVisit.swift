//
//  PrimaryVisit.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 25/05/22.
//

import Foundation
import UIKit
import FSCalendar
import Alamofire
import CoreLocation

class PrimaryVisit: IViewController, UITableViewDelegate, UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource {
    @IBOutlet weak var lcLastvistHeight: NSLayoutConstraint!
    @IBOutlet weak var lcContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwRetailCtrl: UIView!
    @IBOutlet weak var vwVstDetCtrl: UIView!
    @IBOutlet var vwVstContainer: UIView!
    
    @IBOutlet weak var lblPayType: LabelSelect!
    @IBOutlet weak var lblTitleCap: UILabel!
    @IBOutlet weak var vwSelWindow: UIView!
    @IBOutlet weak var lblSelTitle: UILabel!
    @IBOutlet weak var lblDOP: UILabel!
    @IBOutlet weak var tbDataSelect: UITableView!
    @IBOutlet weak var tbJWKSelect: UITableView!
    
    @IBOutlet weak var lblCustNm: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnRmkTmpl: UIButton!
    @IBOutlet weak var txvRmks: UITextView!
    @IBOutlet weak var swOrderMode: UISwitch!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var txSearchSel: UITextField!
    @IBOutlet weak var btnBack: UIImageView!
    
    @IBOutlet weak var txCollectAmt: UITextField!
    @IBOutlet weak var vwBtnOrder: RoundedCornerView!
    @IBOutlet weak var vwBtnCam: RoundedCornerView!
    
    struct lItem: Any {
        let id: String
        let name: String
    }
    
    var vstDets: [String: lItem] = [:]
    
    var lObjSel: [AnyObject] = []
    
    var SelMode: String = ""
    var strSelJWCd: String = ""
    var strSelJWNm: String = ""
    
    var strJWCd: String = ""
    var strJWNm: String = ""
    var sDOP: String = ""
    
    var lstPlnDetail: [AnyObject] = []
    var lstCustomers: [AnyObject] = []
    var lstRmksTmpl: [AnyObject] = []
    var lstJoint: [AnyObject] = []
    var lstSelJWNms: [AnyObject] = []
    var lstJWNms: [AnyObject] = []
    var lstPayTypes: [AnyObject] = []
    var lAllObjSel: [AnyObject] = []
    
    var isMulti: Bool = false
    var isDate: Bool = false
    var SFCode: String = ""
    var DataSF: String = ""
    var DivCode: String = ""
    var eKey: String = ""
    
    override func viewDidLoad() {
        
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
        let PayTypDatas: String=LocalStoreage.string(forKey: "Pay_Types")!
        
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        DataSF = self.lstPlnDetail[0]["subordinateid"] as! String
        
        if let list = GlobalFunc.convertToDictionary(text: RmkDatas) as? [AnyObject] {
            lstRmksTmpl = list;
        }
        let lstCustData: String = LocalStoreage.string(forKey: "Distributors_Master_"+DataSF)!
        if let list = GlobalFunc.convertToDictionary(text: lstCustData) as? [AnyObject] {
            lstCustomers = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: JointWData) as? [AnyObject] {
            lstJoint = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: PayTypDatas) as? [AnyObject] {
            lstPayTypes = list;
        }
        
        VisitData.shared.OrderMode.id = "0"
        VisitData.shared.OrderMode.name = "Field Order"
        
        
        lblTitleCap.text = UserSetup.shared.PrimaryCaption
        
        lblCustNm.addTarget(target: self, action: #selector(selCustomer))
        lblPayType.addTarget(target: self, action: #selector(selPayTypes))
        btnAdd.addTarget(target: self, action: #selector(selJointWK))
        btnRmkTmpl.addTarget(target: self, action: #selector(selRmksTemp))
        lblDOP.addTarget(target: self, action: #selector(selDOP))
        
        vwBtnCam.addTarget(target: self, action: #selector(openCamera))
        vwBtnOrder.addTarget(target: self, action: #selector(openOrder))
        
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        
        tbDataSelect.delegate=self
        tbDataSelect.dataSource=self
        
        tbJWKSelect.delegate=self
        tbJWKSelect.dataSource=self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==tbJWKSelect { return lstJWNms.count }
        return lObjSel.count
    }
    
    @IBAction func changeSwitch(_ sender: Any) {
        var swtch: UISwitch = sender as! UISwitch
        if swtch.isOn == false {
            VisitData.shared.OrderMode.id = "1"
            VisitData.shared.OrderMode.name = "Phone Order"
        }else{
            VisitData.shared.OrderMode.id = "0"
            VisitData.shared.OrderMode.name = "Field Order"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if tableView == tbJWKSelect {
            let item: [String: Any]=lstJWNms[indexPath.row] as! [String : Any]
            cell.lblText?.text = item["name"] as? String
            cell.imgBtnDel.addTarget(target: self, action: #selector(self.delJWK(_:)))
        }else{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
        let name=item["name"] as! String
        let id=String(format: "%@", item["id"] as! CVarArg)
        if isMulti==true {
            if SelMode == "JWK" {
                let sid=(item["id"] as! String)
                let sfind: String = (";"+sid+";")
                
                if let range: Range<String.Index> = (";"+strSelJWCd).range(of: sfind) {
                    strSelJWCd=strSelJWCd.replacingOccurrences(of: sid+";", with: "")
                    strSelJWNm=strSelJWNm.replacingOccurrences(of: name+";", with: "")
                    if let indexToDelete = lstSelJWNms.firstIndex(where: { $0["id"] as? String == sid}) {
                        lstSelJWNms.remove(at: indexToDelete)
                    }
                    tableView.reloadData()
                }else{
                    strSelJWCd += sid+";"
                    strSelJWNm += name+";"
                    let jitm: AnyObject = item as AnyObject
                    lstSelJWNms.append(jitm)
                    tableView.reloadData()
                }
            }
        }else{
            if SelMode == "DIS" {
                if vwVstContainer != nil{ vwVstContainer.removeFromSuperview()
                }
                VisitData.shared.CustID = id
                VisitData.shared.CustName = name
                VisitData.shared.cInTime = GlobalFunc.getCurrDateAsString()
                lblCustNm.text = name
            }
            if SelMode=="RMK" {
                txvRmks.text = name
                VisitData.shared.VstRemarks.name = name
                VisitData.shared.VstRemarks.id = id
            }
            if SelMode=="PAYTYP" {
                lblPayType.text = name
                VisitData.shared.PayType.name = name
                VisitData.shared.PayType.id = id
            }
            
            
            vstDets.updateValue(lItem(id: id, name: name), forKey: SelMode)
            closeWin(self)
        }
    
    }
    func addVstDetControl(aY: Double, h: Double, Caption: String, text: String) -> Double {
        if text != "" {
            let lblCap: UILabel! = UILabel(frame: CGRect(x: 10, y: aY, width: vwVstDetCtrl.frame.width, height: 10))
            lblCap.font = UIFont(name: "Poppins-Regular", size: 10)
            lblCap.text = Caption
            let lblAdd: UILabel! = UILabel(frame: CGRect(x: 10, y: aY+5, width: vwVstDetCtrl.frame.width, height: h))
            lblAdd.font = UIFont(name: "Poppins-Regular", size: 13)
            lblAdd.text = text
            vwVstContainer.addSubview(lblCap)
            vwVstContainer.addSubview(lblAdd)
            
            return aY + lblAdd.frame.height + lblCap.frame.height
        } else {
            return aY
        }
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
        lblDOP.text = selectedDates[0]
        formatter.dateFormat = "yyyy/MM/dd"
        VisitData.shared.DOP.id=formatter.string(from: date)
        VisitData.shared.DOP.name=selectedDates[0]
        sDOP = formatter.string(from: date)
        vstDets.updateValue(lItem(id: sDOP, name: lblDOP.text!), forKey: SelMode)
        closeWin(self)
    }
    func validateForm() -> Bool {
        if VisitData.shared.CustID == "" {
            Toast.show(message: "Select the Distributor") //, controller: self
            return false
        }
        return true
    }
    @IBAction func SubmitCall(_ sender: Any) {
        if validateForm() == false {
            return
        }
        if VisitData.shared.VstRemarks.name == "" {
            Toast.show(message: "Select the Reason", controller: self)
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
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit this Visit Without Order ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.ShowLoading(Message: "Locating Device...")
            VisitData.shared.cOutTime = GlobalFunc.getCurrDateAsString()
            VisitData.shared.PayValue = self.txCollectAmt.text as! String
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
                            /*let placemark = placemarks?[0]
                            let Addess=placemark?.debugDescription.components(separatedBy:"@")
                            
                            
                            sAddress = "\(placemark?.subThoroughfare ?? ""), \(placemark?.thoroughfare ?? ""), \(placemark?.locality ?? ""), \(placemark?.subLocality ?? ""), \(placemark?.administrativeArea ?? ""), \(placemark?.postalCode ?? ""), \(placemark?.country ?? "")"*/
                                            
                        }
                    }
                    self.ShowLoading(Message: "Data Submitting Please wait...")
                    //DataSF = self.lstPlnDetail[0]["subordinateid"] as! String
                    var sImgItems:String = ""
                    if(PhotosCollection.shared.PhotoList.count>0){
                        for i in 0...PhotosCollection.shared.PhotoList.count-1{
                            let item: [String: Any] = PhotosCollection.shared.PhotoList[i] as! [String : Any]
                            if i > 0 { sImgItems = sImgItems + "," }
                            sImgItems = sImgItems + "{\"imgurl\":\"'" + (item["FileName"]  as! String) + "'\",\"title\":\"''\",\"remarks\":\"''\",\"f_key\":{\"Activity_Report_Code\":\"Activity_Report_APP\"}}"
                        }
                    }
                    let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"'" + (self.lstPlnDetail[0]["worktype"] as! String) + "'\",\"Town_code\":\"'" + (self.lstPlnDetail[0]["clusterid"] as! String) + "'\",\"RateEditable\":\"''\",\"dcr_activity_date\":\"'" + VisitData.shared.cInTime + "'\",\"Daywise_Remarks\":\"'" + VisitData.shared.VstRemarks.name + "'\",\"eKey\":\"" + self.eKey + "\",\"rx\":\"'1'\",\"rx_t\":\"''\",\"DataSF\":\"'" + self.DataSF + "'\"}},{\"Activity_Stockist_Report\":{\"Stockist_POB\":\"" + VisitData.shared.PayValue + "\",\"Worked_With\":\"''\",\"location\":\"'" + sLocation + "'\",\"geoaddress\":\"" + sAddress + "\",\"stockist_code\":\"'" + VisitData.shared.CustID + "'\",\"superstockistid\":\"''\",\"Stk_Meet_Time\":\"'" + VisitData.shared.cInTime + "'\",\"modified_time\":\"'" + VisitData.shared.cInTime + "'\",\"date_of_intrument\":\"" + VisitData.shared.DOP.id + "\",\"intrumenttype\":\"" + VisitData.shared.PayType.id + "\",\"orderValue\":\"0\",\"Aob\":0,\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"CheckoutTime\":\"" + VisitData.shared.cOutTime + "\",\"f_key\":{\"Activity_Report_Code\":\"'Activity_Report_APP'\"},\"PhoneOrderTypes\":" + VisitData.shared.OrderMode.id + "}},{\"Activity_Stk_POB_Report\":[]},{\"Activity_Stk_Sample_Report\":[]},{\"Activity_Event_Captures\":[" + sImgItems +  "]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]}]"
                    
                    let params: Parameters = [
                        "data": jsonString //"["+jsonString+"]"//
                    ]
                    print(params)
                    AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode="+self.DivCode+"&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                        AFdata in
                        self.LoadingDismiss()
                        switch AFdata.result
                        {
                           
                        case .success(let value):
                            if let json = value as? [String: Any] {
                                VisitData.shared.clear()
                                Toast.show(message: "Call Visit has been submitted successfully", controller: self)
                                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                                UIApplication.shared.windows.first?.rootViewController = viewController
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                            }
                        case .failure(let error):
                            let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                                return
                            })
                            self.present(alert, animated: true)
                        }
                    }
                }
            }, error:{ errMsg in
                self.LoadingDismiss()
                let alert = UIAlertController(title: "Information", message: errMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                    return
                })
                self.present(alert, animated: true)
                
            })
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    
    @IBAction func setSelValues(_ sender: Any) {
        strJWCd=strSelJWCd
        strJWNm=strSelJWNm
        lstJWNms=lstSelJWNms
        tbJWKSelect.reloadData()
        closeWin(self)
    }
    
    @objc private func selCustomer() {
        isDate = false
        isMulti=false
        self.lAllObjSel = []
        self.lObjSel = []
        self.tbDataSelect.reloadData()
        if UserSetup.shared.Fenching == true && VisitData.shared.OrderMode.id == "0" {
            LocationService.sharedInstance.getNewLocation(location: { location in
                print ("New  : "+location.coordinate.latitude.description + ":" + location.coordinate.longitude.description)
                self.lObjSel=self.lstCustomers.filter({(Cust) in
                    if Cust["lat"] as! String != "" {
                    var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
                    let lat: Double = Double("\(Cust["lat"] as! String)")!
                    let lon: Double = Double("\(Cust["long"] as! String)")!
                    
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
            self.lObjSel=self.lstCustomers
            self.lAllObjSel = self.lObjSel
            
            /*.filter({(retail) in
                print(lstPlnDetail[0]["clusterid"] as! String )
                if VisitData.shared.OrderMode.id == "1" {
                    return true
                }
                if retail["town_code"] as! String == lstPlnDetail[0]["clusterid"] as! String {
                    return true
                }
                return true
            })*/
            self.tbDataSelect.reloadData()
        }
        
        lblSelTitle.text="Select the Distributor"
        openWin(Mode: "DIS")
    }
    
    @objc private func selJointWK() {
        isDate = false
        isMulti=true
        lObjSel=lstJoint
        strSelJWCd=strJWCd
        strSelJWNm=strJWNm
        lstSelJWNms=lstJWNms
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Jointwork"
        openWin(Mode: "JWK")
    }
    @objc private func delJWK(_ sender: UITapGestureRecognizer) {
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indx:NSIndexPath = tbView.indexPath(for: cell)! as NSIndexPath
        removeJWk(indx: indx.row)
     }
    
    func removeJWk(indx: Int){
        let sItem: [String: Any] = lstJWNms[indx] as! [String: Any]
        
        let sid: String = sItem["id"] as! String
        let name: String = sItem["name"] as! String
        
        strJWCd=strJWCd.replacingOccurrences(of: sid+";", with: "")
        strJWNm=strJWNm.replacingOccurrences(of: name+";", with: "")
        
        lstJWNms.remove(at: indx)
        tbJWKSelect.reloadData()
    }
    
    @objc private func selPayTypes() {
        isDate = false
        isMulti=false
        lObjSel=lstPayTypes
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Payment Type"
        openWin(Mode: "PAYTYP")
    }
    @objc private func selDOP() {
        isDate = true
        openWin(Mode: "DOP")
        lblSelTitle.text="Select the Date Of Payment"
    }
    @objc private func selRmksTemp() {
        isDate = false
        isMulti=false
        lObjSel=lstRmksTmpl
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Reason"
        openWin(Mode: "RMK")
    }
    
    func openWin(Mode:String){
        self.view.endEditing(true)
        SelMode=Mode
        lAllObjSel = lObjSel
        txSearchSel.text = ""
        calendar.isHidden = true
        tbDataSelect.isHidden = false
        txSearchSel.isHidden = false
        if isDate == true {
            calendar.isHidden = false
            tbDataSelect.isHidden = true
            txSearchSel.isHidden = true
        }
        vwSelWindow.isHidden=false
        
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
    @objc private func GotoHome() {
        self.dismiss(animated: true, completion: nil)
        GlobalFunc.movetoHomePage()
    }
    @IBAction func closeWin(_ sender:Any){
        vwSelWindow.isHidden=true
    }
    @objc private func openCamera(){
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "PhotoGallary") as!  PhotoGallary
        //let vc=self.storyboard?.instantiateViewController(withIdentifier: "CameraVwCtrl") as!  CameraService
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @objc private func openOrder(){
        if validateForm() == false {
            return
        }
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbPrimaryOrder") as!  PrimaryOrder
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func setView(view: UIView) {
        UIView.transition(with: view, duration: 1.0, options: .transitionFlipFromTop, animations: {
        })
    }
}
