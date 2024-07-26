//
//  AddNewCustomer.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 16/05/22.
//

import UIKit
import MapKit
import Alamofire
import FSCalendar

class AddNewCustomer: IViewController, UITableViewDelegate, UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource{
    @IBOutlet weak var vwScroll: UIScrollView!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var mapOutletLoc: MKMapView!
    @IBOutlet weak var lblDist: LabelSelect!
    @IBOutlet weak var lblHQ: LabelSelect!
    @IBOutlet weak var lblRoute: LabelSelect!
    @IBOutlet weak var lblDOB: LabelSelect!
    @IBOutlet weak var lblCats: LabelSelect!
    @IBOutlet weak var lblCls: LabelSelect!
    @IBOutlet weak var txOutletNm: EditTextField!
    @IBOutlet weak var txOwnerNm: EditTextField!
    @IBOutlet weak var txOutletAdd: UITextView!
    @IBOutlet weak var txStreet: EditTextField!
    @IBOutlet weak var txCity: EditTextField!
    @IBOutlet weak var txPinCode: EditTextField!
    @IBOutlet weak var txMobile: EditTextField!
    @IBOutlet weak var imgOutlet: UIImageView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var lblTitleCap: UILabel!
    @IBOutlet weak var vwSelWindow: UIView!
    @IBOutlet weak var txSearchSel: UITextField!
    @IBOutlet weak var lblSelTitle: UILabel!
    @IBOutlet weak var tbDataSelect: UITableView!
    
    @IBOutlet weak var SetSalValu: UIButton!
    
    struct lItem: Any {
        let id: String
        let name: String
    }
    var outletData: [String: lItem] = [:]
    var lAllObjSel: [AnyObject] = []
    var lObjSel: [AnyObject] = []
    
    var lstHQs: [AnyObject] = []
    var lstDist: [AnyObject] = []
    var lstAllRoutes: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    var lstCat: [AnyObject] = []
    var lstCls: [AnyObject] = []
    
    var SelMode: String = ""
    var isDate: Bool = false
    var sDOB: String = ""
    var eKey: String = ""
    var SFCode: String = ""
    var DivCode: String = ""
    
    override func viewDidLoad() {
        vwScroll.contentSize = CGSize(width: view.frame.width, height: vwContent.frame.height)
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        imgOutlet.addTarget(target: self, action: #selector(takePhoto))
        SetSalValu.isHidden = true
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async { [self] in
                setOutletLocation()
            }
        }
        imgOutlet.image = UIImage(named: "camera")
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
        eKey = String(format: "N-%@-%i", SFCode,Int(Date().timeIntervalSince1970))
        
        let HQData: String=LocalStoreage.string(forKey: "HQ_Master")!
        let DistData: String = LocalStoreage.string(forKey: "Distributors_Master_" + SFCode)!
        let RouteData: String = LocalStoreage.string(forKey: "Route_Master_" + SFCode)!
        let CatData: String = LocalStoreage.string(forKey: "Channel_Master")!
        let ClassData: String = LocalStoreage.string(forKey: "Class_Master")!
        
        if let list = GlobalFunc.convertToDictionary(text: HQData) as? [AnyObject] {
            lstHQs = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
            lstDist = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
            lstAllRoutes = list
        }
        if let list = GlobalFunc.convertToDictionary(text: CatData) as? [AnyObject] {
            lstCat = list
        }
        if let list = GlobalFunc.convertToDictionary(text: ClassData) as? [AnyObject] {
            lstCls = list
        }
        
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        
        lblHQ.addTarget(target: self, action: #selector(selHeadquaters))
        lblDist.addTarget(target: self, action: #selector(selDistributor))
        lblRoute.addTarget(target: self, action: #selector(selRoutes))
        lblDOB.addTarget(target: self, action: #selector(selDOB))
        lblCls.addTarget(target: self, action: #selector(selCls))
        lblCats.addTarget(target: self, action: #selector(selCats))
        
        tbDataSelect.delegate=self
        tbDataSelect.dataSource=self
        
       // imgOutlet.image = UIImage(imageLiteralResourceName: "")
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        vwScroll = nil
        vwContent = nil
        btnBack = nil
        lblDist = nil
        lblHQ = nil
        lblRoute = nil
        lblDOB = nil
        lblCats = nil
        lblCls = nil
        
        txOutletAdd = nil
        txStreet = nil
        txCity = nil
        txPinCode = nil
        imgOutlet = nil
        calendar = nil
        
        lblTitleCap = nil
        vwSelWindow = nil
        txSearchSel = nil
        
        lblSelTitle = nil
        tbDataSelect.delegate = nil
        tbDataSelect.dataSource = nil
        tbDataSelect = nil
        mapOutletLoc.delegate = nil
        mapOutletLoc.removeFromSuperview()
        mapOutletLoc = nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lObjSel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
        cell.lblText?.text = item["name"] as? String
        cell.imgSelect?.image = nil
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
        let name=item["name"] as! String
        let id=String(format: "%@", item["id"] as! CVarArg)
        print(id)
        if SelMode == "DIS" {
            lblDist.text = name
            NewOutlet.shared.Dist.id = id
            NewOutlet.shared.Dist.name = name
            
            lstRoutes = lstAllRoutes.filter({(fitem) in
                let StkId: String = String(format: ",%@,", fitem["stockist_code"] as! CVarArg)
                return Bool(StkId.range(of: String(format: ",%@,", id))?.lowerBound != nil )
            })
        } else if SelMode == "RUT" {
            lblRoute.text = name  //+(item["id"] as! String)
            NewOutlet.shared.Route.id = id
            NewOutlet.shared.Route.name = name
        }else if SelMode == "HQ" {
            lblHQ.text = name  //+(item["id"] as! String)
            NewOutlet.shared.HQ.id = id
            NewOutlet.shared.HQ.name = name
            
            let LocalStoreage = UserDefaults.standard
           // let DistData: String=LocalStoreage.string(forKey: "Distributors_Master_"+id)!
            //new
            if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+id),
               let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
                lstDist = list
            }
            
            if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+id),
               let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
                lstAllRoutes = list
                lstRoutes = list
            }
            //new
            //let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+id)!
//            if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
//                lstDist = list;
//            }
//            if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
//                lstAllRoutes = list
//                lstRoutes = list
//            }
        }else if SelMode == "CLS" {
            lblCls.text = name  //+(item["id"] as! String)
            NewOutlet.shared.Class.id = id
            NewOutlet.shared.Class.name = name
        }else if SelMode == "CAT" {
            lblCats.text = name  //+(item["id"] as! String)
            NewOutlet.shared.Category.id = id
            NewOutlet.shared.Category.name = name
        }
        outletData.updateValue(lItem(id: id, name: name), forKey: SelMode)
        closeWin(self)
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
        lblDOB.text = selectedDates[0]
        formatter.dateFormat = "yyyy/MM/dd"
        sDOB = formatter.string(from: date)
        outletData.updateValue(lItem(id: sDOB, name: lblDOB.text!), forKey: SelMode)
        NewOutlet.shared.DOB.id = sDOB
        NewOutlet.shared.DOB.name = lblDOB.text!
        closeWin(self)
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
       
    }
    
    @objc private func selHeadquaters() {
        isDate=false
        lObjSel=lstHQs
        openWin(Mode: "HQ")
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Headquarter"
    }
    
    @objc private func selDistributor() {
        isDate=false
        lObjSel = lstDist
        openWin(Mode: "DIS")
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Distributor"
    }
    
    @objc private func selRoutes() {
        isDate=false
        lObjSel=lstRoutes
        openWin(Mode: "RUT")
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Route"
    }
    @objc private func selCats() {
        isDate=false
        lObjSel=lstCat
        openWin(Mode: "CAT")
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Category"
    }
    
    @objc private func selCls() {
        isDate=false
        lObjSel=lstCls
        openWin(Mode: "CLS")
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Class"
    }
    
    @objc private func selDOB() {
        isDate = true
        openWin(Mode: "DOB")
        lblSelTitle.text="Select the DOB"
    }
    
    func openWin(Mode:String){
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
    
    @IBAction func closeWin(_ sender:Any){
        vwSelWindow.isHidden=true
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
    func setOutletLocation(){
        autoreleasepool{
        
        LocationService.sharedInstance.getNewLocation(location: { location in
            let sLocation: String = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
            
            NewOutlet.shared.Lat = location.coordinate.latitude.description
            NewOutlet.shared.Lng = location.coordinate.longitude.description
            lazy var geocoder = CLGeocoder()
            var sAddress: String = ""
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if(placemarks != nil){
                    if(placemarks!.count>0){
                        let placemark = placemarks?[0]
                        let jAddress:[String] = placemark?.addressDictionary!["FormattedAddressLines"] as! [String]
                        for i in 0...jAddress.count-1 {
                            print(jAddress[i])
                            if i==0{
                                sAddress = String(format: "%@", jAddress[i])
                            }else{
                                sAddress = String(format: "%@, %@", sAddress,jAddress[i])
                            }
                        }
                        self.txOutletAdd.text = sAddress
                        self.txStreet.text = placemark?.thoroughfare
                        self.txCity.text = placemark?.locality
                        self.txPinCode.text = placemark?.postalCode
                        let marker: MKPlacemark = MKPlacemark(coordinate: location.coordinate, addressDictionary:nil)
                        self.mapOutletLoc.addAnnotation(marker)
                        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake( location.coordinate.latitude,  location.coordinate.longitude)
                        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                        let region: MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
                        self.mapOutletLoc.setRegion(region, animated: true)
                        /*
                        let Addess=placemark?.debugDescription.components(separatedBy:"@")
                        
                        
                        sAddress = "\(placemark?.subThoroughfare ?? ""), \(placemark?.thoroughfare ?? ""), \(placemark?.locality ?? ""), \(placemark?.subLocality ?? ""), \(placemark?.administrativeArea ?? ""), \(placemark?.postalCode ?? ""), \(placemark?.country ?? "")"*/
                                        
                    }
                }
            }
        }, error:{ errMsg in
            print (errMsg)
        })
        }
    }
    @objc private func GotoHome() {
        self.dismiss(animated: true, completion: nil)
        GlobalFunc.MovetoMainMenu()
    }
    @objc private func takePhoto() {
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "CameraVwCtrl") as!  CameraService
        vc.modalPresentationStyle = .overCurrentContext
        vc.callback = { (photo, fileName) -> Void in
            print("callback")
            print(photo)
            self.imgOutlet.image = photo
            NewOutlet.shared.Image = photo
            NewOutlet.shared.ImgFileName = fileName
            ImageUploader().uploadImage(SFCode: self.SFCode, image: photo, fileName: fileName)
        }
        self.present(vc, animated: true, completion: nil)
    }
    func validateForm() -> Bool {
        if NewOutlet.shared.HQ.id == "" {
            Toast.show(message: "Select the Headquarter", controller: self)
            return false
        }
        if NewOutlet.shared.Dist.id == "" {
            Toast.show(message: "Select the Distributor", controller: self)
            return false
        }
        if NewOutlet.shared.Route.id == "" {
            Toast.show(message: "Select the Route", controller: self)
            return false
        }
        
        if NewOutlet.shared.OutletName == "" {
            Toast.show(message: "Enter the Outlet Name", controller: self)
            return false
        }
        if(NewOutlet.shared.ImgFileName == ""){
            Toast.show(message: "Take Retailer Photo", controller: self)
            return false
        }
        if NewOutlet.shared.OwnerName == "" {
            Toast.show(message: "Enter the Owner Name", controller: self)
            return false
        }
        
        if NewOutlet.shared.Address == "" {
            Toast.show(message: "Enter the Address", controller: self)
            return false
        }
        if NewOutlet.shared.Street == "" {
            Toast.show(message: "Enter the Street", controller: self)
            return false
        }
        if NewOutlet.shared.City == ""{
            Toast.show(message: "Enter the City", controller: self)
            return false
        }
        if NewOutlet.shared.Pincode == "" {
            Toast.show(message: "Enter the Pincode", controller: self)
            return false
        }
        
        if NewOutlet.shared.Class.id == "" {
            Toast.show(message: "Select the Class", controller: self)
            return false
        }
        if NewOutlet.shared.Category.id == "" {
            Toast.show(message: "Select the Category", controller: self)
            return false
        }
        if NewOutlet.shared.Lat == "" {
            Toast.show(message: "Location can't capture right now", controller: self)
            
            let alert = UIAlertController(title: "Information", message: "Location can't capture right now. do you want create without tag this place. cancel to refresh location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                self.setOutletLocation()
                return
            })
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                self.fnCreateNewOutlet()
                return
            })
            self.present(alert, animated: true)
            return false
        }
        /*if NewOutlet.shared.OwnerName == "" {
            Toast.show(message: "Enter the Retailer", controller: self)
            return false
        }*/
        return true
        
    }
    @IBAction func CreateNewOutlet(_ sender: Any) {
        NewOutlet.shared.Address = self.txOutletAdd.text
        NewOutlet.shared.Street = self.txStreet.text ?? ""
        NewOutlet.shared.City = self.txCity.text ?? ""
        NewOutlet.shared.Pincode = self.txPinCode.text ?? ""
        
        NewOutlet.shared.OutletName = txOutletNm.text ?? ""
        NewOutlet.shared.OwnerName = txOwnerNm.text ?? ""
        
        NewOutlet.shared.Mobile = txMobile.text ?? ""
        if validateForm() == false {
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
        self.ShowLoading(Message: "Data Submitting Please wait...")
        fnCreateNewOutlet()
        
    }
    func fnCreateNewOutlet(){
        let CDate: String = GlobalFunc.getCurrDateAsString()

        let jsonString = "[{\"unlisted_doctor_master\":{\"town_code\":\"'" + NewOutlet.shared.Route.id + "'\",\"wlkg_sequence\":\"null\",\"Retailerphoto\":{\"imgurl\":\"" + NewOutlet.shared.ImgFileName + "\"},\"unlisted_doctor_name\":\"'" + NewOutlet.shared.OutletName + "'\",\"unlisted_doctor_address\":\"'" + NewOutlet.shared.Address + "'\",\"unlisted_doctor_phone\":\"'" + NewOutlet.shared.Mobile + "'\",\"unlisted_doctor_cityname\":\"'" + NewOutlet.shared.City + "'\",\"unlisted_doctor_landmark\":\"''\",\"lat\":\"'" + NewOutlet.shared.Lat + "'\",\"long\":\"'" + NewOutlet.shared.Lng + "'\",\"unlisted_doctor_areaname\":\"'" + NewOutlet.shared.Street + "'\",\"unlisted_doctor_contactperson\":\"'" + NewOutlet.shared.OwnerName + "'\",\"unlisted_doctor_designation\":\"''\",\"unlisted_doctor_gst\":\"''\",\"unlisted_doctor_pincode\":\"'" + NewOutlet.shared.Pincode + "'\",\"unlisted_doctor_email\":\"''\",\"unlisted_doctor_phone2\":\"''\",\"unlisted_doctor_phone3\":\"''\",\"unlisted_doctor_contactperson2\":\"''\",\"unlisted_doctor_contactperson3\":\"''\",\"unlisted_doctor_designation2\":\"''\",\"unlisted_cat_code\":\"null\",\"unlisted_specialty_code\":" + NewOutlet.shared.Category.id + ",\"unlisted_qulifi\":\"'samp'\",\"unlisted_class\":" + NewOutlet.shared.Class.id + ",\"DrKeyId\":\"'" + eKey + "'\",\"ListedDr_DOB\":\"'" + NewOutlet.shared.DOB.id + "'\",\"ListedDr_DOW\":\"''\",\"layer\":\"''\",\"breeder\":\"''\",\"broiler\":\"''\"}}]"
        
        let params: Parameters = [
            "data": jsonString //"["+jsonString+"]"//
        ]
        print(params)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode +  "&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            self.LoadingDismiss()
            switch AFdata.result
            {
               
            case .success(let value):
                print(value)
                if value is [String: Any] {
                    Toast.show(message: "Customer Added submitted successfully", controller: self)
                    NewOutlet.shared.Clear()
                    self.MasSync(apiKey:  "table/list&divisionCode=" + self.DivCode +  "&rSF="+self.SFCode+"&sfCode="+self.SFCode, aFormData: [
                        "tableName":"vwDoctor_Master_APP","coloumns":"[\"doctor_code as id\", \"doctor_name as name\",\"town_code\",\"town_name\",\"lat\",\"long\",\"addrs\",\"ListedDr_Address1\",\"ListedDr_Sl_No\",\"Mobile_Number\",\"Doc_cat_code\",\"ContactPersion\",\"Doc_Special_Code\",\"Distributor_Code\",\"Doctor_Code\",\"gst\",\"createdDate\",\"Doctor_Active_flag\",\"ListedDr_Email\",\"Spec_Doc_Code\",\"debtor_code\"]","where":"[\"isnull(Doctor_Active_flag,0)=0\"]","orderBy":"[\"name asc\"]","desig":"mgr"
                        ], aStoreKey: "Retail_Master_"+self.SFCode)
    
                    self.GotoHome()
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
    
    func MasSync(apiKey: String,aFormData: [String: Any],aStoreKey:String) {
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
                   LocalStoreage.set(prettyPrintedJson, forKey: aStoreKey)
               case .failure(let error):
                   print(error.errorDescription!)
            }
        }
    }
}

