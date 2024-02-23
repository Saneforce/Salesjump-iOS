//
//  SecondaryVisit.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 01/04/22.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

class SecondaryVisit: IViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    @IBOutlet weak var lcLastvistHeight: NSLayoutConstraint!
    @IBOutlet weak var lcContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwRetailCtrl: UIView!
    @IBOutlet weak var vwVstDetCtrl: UIView!
    @IBOutlet var vwVstContainer: UIView!
    
    @IBOutlet weak var lblTitleCap: UILabel!
    @IBOutlet weak var vwSelWindow: UIView!
    @IBOutlet weak var lblSelTitle: UILabel!
    @IBOutlet weak var tbDataSelect: UITableView!
    @IBOutlet weak var tbJWKSelect: UITableView!
    
    @IBOutlet weak var lblRetailNm: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnRmkTmpl: UIButton!
    @IBOutlet weak var txvRmks: UITextView!
    @IBOutlet weak var swOrderMode: UISwitch!
    @IBOutlet weak var txSearchSel: UITextField!
    @IBOutlet weak var btnBack: UIImageView!
    
    @IBOutlet weak var vwBtnOrder: RoundedCornerView!
    @IBOutlet weak var vwBtnCam: RoundedCornerView!
    
    struct lItem: Any {
        let id: String
        let name: String
    }
    
    var vstDets: [String: lItem] = [:]
    
    var lObjSel: [AnyObject] = []
    var lAllObjSel: [AnyObject] = []
    var parameter: [AnyObject] = []
    var SelMode: String = ""
    var strSelJWCd: String = ""
    var strSelJWNm: String = ""
    
    var strJWCd: String = ""
    var strJWNm: String = ""
    
    var lstPlnDetail: [AnyObject] = []
    var lstRetails: [AnyObject] = []
    var lstRmksTmpl: [AnyObject] = []
    var lstJoint: [AnyObject] = []
    var lstSelJWNms: [AnyObject] = []
    var lstJWNms: [AnyObject] = []
    
    var isMulti: Bool = false
    var SFCode: String = ""
    var DataSF: String = ""
    var DivCode: String = ""
    var eKey: String = ""
    var Location : String = ""
    var sImgItems:String = ""
    var sAddress: String = ""
    let LocalStoreage = UserDefaults.standard
    override func viewDidLoad() {
        lcLastvistHeight.constant = 0
        //lcContentHeight.constant = -400
        txvRmks.text = "Enter the Remarks"
        txvRmks.textColor = UIColor.lightGray
        txvRmks.returnKeyType = .done
        txvRmks.delegate = self
        loadViewIfNeeded()
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
        
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        DataSF = self.lstPlnDetail[0]["subordinateid"] as! String
        
        if let list = GlobalFunc.convertToDictionary(text: RmkDatas) as? [AnyObject] {
            lstRmksTmpl = list;
        }
        //new
        if let lstRetailData = LocalStoreage.string(forKey: "Retail_Master_"+DataSF),
           let list = GlobalFunc.convertToDictionary(text:  lstRetailData) as? [AnyObject] {
            lstRetails = list
        }
        //new
//        let lstRetailData: String = LocalStoreage.string(forKey: "Retail_Master_"+DataSF)!
//        if let list = GlobalFunc.convertToDictionary(text: lstRetailData) as? [AnyObject] {
//            lstRetails = list;
//        }
        if let list = GlobalFunc.convertToDictionary(text: JointWData) as? [AnyObject] {
            lstJoint = list;
        }
        
        VisitData.shared.OrderMode.id = "0"
        VisitData.shared.OrderMode.name = "Field Order"
        
        lblTitleCap.text = UserSetup.shared.SecondaryCaption
        lblRetailNm.addTarget(target: self, action: #selector(selRetails))
        btnAdd.addTarget(target: self, action: #selector(selJointWK))
        btnRmkTmpl.addTarget(target: self, action: #selector(selRmksTemp))
        
        vwBtnCam.addTarget(target: self, action: #selector(openCamera))
        vwBtnOrder.addTarget(target: self, action: #selector(openOrder))
        
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        
        tbDataSelect.delegate=self
        tbDataSelect.dataSource=self
        
        tbJWKSelect.delegate=self
        tbJWKSelect.dataSource=self
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==tbJWKSelect { return lstJWNms.count }
        return lObjSel.count
    }
    
    @IBAction func changeSwitch(_ sender: Any) {
        let swtch: UISwitch = sender as! UISwitch
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
        }
        else{
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
        }
        else{
            if SelMode == "RET" {
                if vwVstContainer != nil{ vwVstContainer.removeFromSuperview()
                }
                VisitData.shared.CustID = id
                VisitData.shared.CustName = name
                VisitData.shared.cInTime = GlobalFunc.getCurrDateAsString()
                vwVstContainer =  UIView( frame: CGRect(x: 0, y: 0, width: vwVstDetCtrl.frame.width, height: 500 ))
                lblRetailNm.text = name
                
                var yAx: Double = 0
                yAx = addVstDetControl(aY: yAx, h: 30, Caption: "Address:", text: item["ListedDr_Address1"] as! String)
                yAx = addVstDetControl(aY: yAx, h: 30, Caption: "Contact Person:", text: item["ContactPersion"] as! String)
                yAx = addVstDetControl(aY: yAx, h: 30, Caption: "Mobile:", text: item["Mobile_Number"] as! String)
                
                vwVstDetCtrl.addSubview(vwVstContainer)
                
                lcLastvistHeight.constant = yAx
                loadViewIfNeeded()
            }
            if SelMode=="RMK" {
                txvRmks.text = name
                print(name)
                VisitData.shared.VstRemarks.name = name
                VisitData.shared.VstRemarks.id = id
            }
            print(name)
            vstDets.updateValue(lItem(id: id, name: name), forKey: SelMode)
            closeWin(self)
        }
    
    }
    func addVstDetControl(aY: Double, h: Double, Caption: String, text: String) -> Double {
        if text != "" {
            let lblCap: UILabel! = UILabel(frame: CGRect(x: 10, y: aY, width: vwVstDetCtrl.frame.width, height: 10))
            lblCap.font = UIFont(name: "Poppins-SemiBold", size: 14)
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
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    func validateForm() -> Bool {
        VisitData.shared.VstRemarks.name = txvRmks.text
        if VisitData.shared.CustID == "" {
            Toast.show(message: "Select the Retailer", controller: self)
            return false
        }
        return true
    }
    @IBAction func SubmitCall(_ sender: Any) {
        if validateForm() == false {
            return
        }
        
        if VisitData.shared.VstRemarks.name == "" {
            Toast.show(message: "Select the Remarks", controller: self)
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
        self.ShowLoading(Message: "Getting Device Location...")
        VisitData.shared.cOutTime = GlobalFunc.getCurrDateAsString()
                var isRequestSent = false
                if !isRequestSent {
        LocationService.sharedInstance.getNewLocation(location: { location in
            let sLocation: String = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
            lazy var geocoder = CLGeocoder()
            self.Location = sLocation
         
      
            geocoder.reverseGeocodeLocation(location ) { (placemarks, error) in
               
                if(placemarks != nil){
                    if(placemarks!.count>0){
                        let jAddress:[String] = placemarks![0].addressDictionary!["FormattedAddressLines"] as! [String]
                        for i in 0...jAddress.count-1 {
                            print(jAddress[i])
                            if i==0{
                                self.sAddress = String(format: "%@", jAddress[i])
                            }else{
                                self.sAddress = String(format: "%@, %@", self.sAddress,jAddress[i])
                            }
                            
                        }
                        /*let placemark = placemarks?[0]
                         let Addess=placemark?.debugDescription.components(separatedBy:"@")
                         
                         
                         sAddress = "\(placemark?.subThoroughfare ?? ""), \(placemark?.thoroughfare ?? ""), \(placemark?.locality ?? ""), \(placemark?.subLocality ?? ""), \(placemark?.administrativeArea ?? ""), \(placemark?.postalCode ?? ""), \(placemark?.country ?? "")"*/
                        
                    }
                
                }
                self.ShowLoading(Message: "Data Submitting Please wait...")
                
                
                //let DataSF: String = self.lstPlnDetail[0]["subordinateid"] as! String
                
              
                if(PhotosCollection.shared.PhotoList.count>0){
                    for i in 0...PhotosCollection.shared.PhotoList.count-1{
                        let item: [String: Any] = PhotosCollection.shared.PhotoList[i] as! [String : Any]
                        if i > 0 { self.sImgItems = self.sImgItems + "," }
                        self.sImgItems = self.sImgItems + "{\"imgurl\":\"'" + (item["FileName"]  as! String) + "'\",\"title\":\"''\",\"remarks\":\"''\",\"f_key\":{\"Activity_Report_Code\":\"Activity_Report_APP\"}}"
                    }
                }
  
                let sessionManager = Session(configuration: URLSessionConfiguration.default)

                sessionManager.session.configuration.httpMaximumConnectionsPerHost = 1
                
                self.subcall()
                   
            }
       
        }, error:{ errMsg in
            self.LoadingDismiss()
            Toast.show(message: errMsg, controller: self)
            /*let alert = UIAlertController(title: "Information", message: errMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                return
            })
            self.present(alert, animated: true)*/
        })
        }
        isRequestSent = true
                
                return
            }
            
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                return
            })
            self.present(alert, animated: true)
        /*

         let parmJsonData: [String: Any]=[
            "Activity_Report_APP": [
                "Worktype_code":"'" + lstPlnDetail["worktype"] + "'",
                "Town_code": "'20543'",
                "RateEditable":"''",
                "dcr_activity_date":"'2022-5-12 00:00:00'",
                "Daywise_Remarks": "'" + vstDets["RMK"]?.name + "'",
                "eKey": "EKMR2408-1652295064487",
                "rx":    "'1'",
                "rx_t":    "''",
                "DataSF": "'MR2408'"
            ]
        ]*/
        
    }
    func subcall() {
        let sLocation = Location
        
        var lstPlnDetail: [AnyObject] = []
        if self.LocalStoreage.string(forKey: "Mydayplan") == nil { return }
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        let jwids=(String(format: "%@", lstPlnDetail[0]["worked_with_code"] as! CVarArg)).replacingOccurrences(of: "$$", with: ";")
            .replacingOccurrences(of: "$", with: ";")
            .components(separatedBy: ";")
        print(lstPlnDetail[0]["worked_with_code"] as! CVarArg)
        for k in 0...jwids.count-1 {
            if let indexToDelete = lstJoint.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == jwids[k] }) {
                print(lstJoint)
                let jwid: String = lstJoint[indexToDelete]["id"] as! String
                let jwname: String = lstJoint[indexToDelete]["name"] as! String
                
                strJWCd += jwid+";"
                strJWNm += jwname+";"
                let jitm: AnyObject = lstJoint[indexToDelete] as AnyObject
                lstJWNms.append(jitm)
            }
            
        }
        print(lstJWNms)
        print(strJWCd)
        let JointData = strJWCd
        var Join_Works = JointData.replacingOccurrences(of: ";", with: "$$")
        if Join_Works.hasSuffix("$") {

            Join_Works.removeLast()
            print(Join_Works)
        }
        
        let jsonString = "[{\"Activity_Report_APP\":{\"dcr_activity_date\":\"\'" + VisitData.shared.cInTime + "\'\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"Daywise_Remarks\":\"" + VisitData.shared.VstRemarks.name.trimmingCharacters(in: .whitespacesAndNewlines) + "\",\"RateEditable\":\"\'\'\",\"Worktype_code\":\"\'" + (self.lstPlnDetail[0]["worktype"] as! String) + "\'\",\"Town_code\":\"\'" + (self.lstPlnDetail[0]["clusterid"] as! String) + "\'\",\"DataSF\":\"\'" + self.DataSF + "\'\",\"eKey\":\"" + self.eKey + "\"}},{\"Activity_Doctor_Report\":{\"modified_time\":\"\'" + VisitData.shared.cInTime + "\'\",\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"rateMode\":\"Nil\",\"visit_name\":\"\'\'\",\"CheckoutTime\":\"" + VisitData.shared.cOutTime + "\",\"Order_No\":\"\'0\'\",\"Doc_Meet_Time\":\"\'" + VisitData.shared.cInTime + "\'\",\"Worked_With\":\"'"+Join_Works+"'\",\"discount_price\":\"0\",\"Discountpercent\":\"0\",\"PhoneOrderTypes\":\"" + VisitData.shared.OrderMode.id + "\",\"net_weight_value\":\"0\",\"stockist_name\":\"\'\'\",\"location\":\"\'" + sLocation + "\'\",\"stockist_code\":\"\'\'\",\"Order_Stk\":\"\'\'\",\"superstockistid\":\"\'\'\",\"geoaddress\":\"" + sAddress + "\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"},\"doctor_name\":\"\'" + self.vstDets["RET"]!.name + "\'\",\"visit_id\":\"\'\'\",\"Doctor_POB\":\"0\",\"doctor_code\":\"\'" + self.vstDets["RET"]!.id + "\'\"}},{\"Activity_Sample_Report\":[]},{\"Trans_Order_Details\":[]},{\"Activity_Event_Captures\":[" + sImgItems +  "]},{\"Activity_Input_Report\":[]},{\"Compititor_Product\":[]},{\"PENDING_Bills\":[]}]"
        
      
        let params: Parameters = [
            "data": jsonString //"["+jsonString+"]"//
            ]
        print(params)
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode=" + self.DivCode + "&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            self.LoadingDismiss()
            switch AFdata.result
            {
                
            case .success(let value):
                print(value)
                if let json = value as? [String: Any] {
                    PhotosCollection.shared.PhotoList = []
                    VisitData.shared.clear()
                    Toast.show(message: "Call Visit has been submitted successfully", controller: self)
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                    UIApplication.shared.windows.first?.rootViewController = viewController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
                /*let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                 return
                 })
                 self.present(alert, animated: true)*/
            }
        }
    }
    
    
    @IBAction func setSelValues(_ sender: Any) {
        strJWCd=strSelJWCd
        strJWNm=strSelJWNm
        lstJWNms=lstSelJWNms
        tbJWKSelect.reloadData()
        closeWin(self)
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
    
    @objc private func selJointWK() {
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
    
    @objc private func selRmksTemp() {
        isMulti=false
        lObjSel=lstRmksTmpl
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Reason"
        openWin(Mode: "RMK")
    }
    
    func openWin(Mode:String){
        SelMode=Mode
        lAllObjSel = lObjSel
        txSearchSel.text = ""
        vwSelWindow.isHidden=false
        self.view.endEditing(true)
        
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
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbSecondaryOrder") as!  SecondaryOrder
        
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true)
    }
    
    
    func setView(view: UIView) {
        UIView.transition(with: view, duration: 1.0, options: .transitionFlipFromTop, animations: {
        })
    }
}
