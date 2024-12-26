//
//  AddNewCustomer_New.swift
//  SAN SALES
//
//  Created by Anbu j on 23/12/24.
//


import UIKit
import MapKit
import Alamofire
import FSCalendar
class AddNewCustomer_New: IViewController,CustomCheckboxViewDelegate,CustomFieldUploadViewDelegate,CustomSelectionLabelViewDelegate,CustomTextFieldDelegate,UITableViewDelegate, UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource{
    
    @IBOutlet weak var mapOutletLoc: MKMapView!
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
    
    
    
    // Dynamic Caption
    
    @IBOutlet weak var Outlet_Nmae: UILabel!
    @IBOutlet weak var Outlet_Class: UILabel!
    @IBOutlet weak var Outlet_Category: UILabel!
    
    @IBOutlet weak var Dis: UILabel!
    
    // placeHolder
    
    @IBOutlet weak var Select_dis: LabelSelect!
    @IBOutlet weak var Mobile_Mandator: UILabel!
    
    @IBOutlet weak var ViewDistributor: UIView!
    
    @IBOutlet weak var ViewDis_height: NSLayoutConstraint!
    
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
    var StateCode:String = ""
    var Desig:String = ""

    
    // MARK: Add dynamic field
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var Outlet_Category_View: UIView!
   
    let customTextField = CustomTextField()
    
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var Scroll_View_Height: NSLayoutConstraint!
    
    @IBOutlet weak var Stack_view_height: NSLayoutConstraint!
    
    struct CustomGroup:Any{
         let FGTableName:String
         let FGroupName:String
         let FieldGroupId:String
         let Customdetails_data:[Customdetails]
     }
     
     struct Customdetails:Any{
         let ModuleId:Int
         let Field_Name:String
         let Fld_Type:String
         let Fld_Symbol:String
         let Field_Col:String
         let Fld_Length:Int
         let Mandate:Int
         let flag:Int
         let Fld_Src_Name:String
         let Fld_Src_Field:String
         let FieldGroupId:Int
         let FGTableName:String
     }
     var CustomGroupData:[CustomGroup] = []
    //var SFCode: String = "", StateCode: String = "", DivCode: String = "",attendanceViews = 0,Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        
        
        
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
        lblRoute.addTarget(target: self, action: #selector(selRoutes))
        lblDOB.addTarget(target: self, action: #selector(selDOB))
        lblCls.addTarget(target: self, action: #selector(selCls))
        lblCats.addTarget(target: self, action: #selector(selCats))
        Select_dis.addTarget(target: self, action: #selector(selDistributor))
        
        tbDataSelect.delegate=self
        tbDataSelect.dataSource=self
        
       // imgOutlet.image = UIImage(imageLiteralResourceName: "")
        
        lblTitleCap.text = "Add New \(UserSetup.shared.DrCap)"
        
        Outlet_Nmae.text = "\(UserSetup.shared.DrCap) Name"
        
        Outlet_Class.text = "\(UserSetup.shared.DrCap) Class"
        Outlet_Category.text = "\(UserSetup.shared.DrCap) Category"
        Dis.text =   UserSetup.shared.StkCap
        
        Select_dis.text = "Select the \(UserSetup.shared.StkCap)"
        txOutletNm.placeholder = "Enter the \(UserSetup.shared.DrCap) Name"
        lblCls.text = "Select the \(UserSetup.shared.DrCap) Class"
        lblCats.text = "Select the \(UserSetup.shared.DrCap) Category"
        
        if UserSetup.shared.Mandator != "phone"{
            Mobile_Mandator.isHidden = true
        }else{
            Mobile_Mandator.isHidden = false
        }
        
        if UserSetup.shared.DistBased == 0{
            ViewDistributor.isHidden = true
            ViewDis_height.constant = 0
        }
        
        CustomDetails()
        
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
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        btnBack = nil
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
            NewOutlet.shared.Dist.id = id
            NewOutlet.shared.Dist.name = name
            Select_dis.text = name
            
            lstRoutes = lstAllRoutes.filter({(fitem) in
                let StkId: String = String(format: ",%@,", fitem["stockist_code"] as! CVarArg)
                return Bool(StkId.range(of: String(format: ",%@,", id))?.lowerBound != nil )
            })
        } else if SelMode == "RUT" {
            print(item)
            
            lblRoute.text = name  //+(item["id"] as! String)
            NewOutlet.shared.Route.id = id
            NewOutlet.shared.Route.name = name
            NewOutlet.shared.Route.Stk_Id = item["stockist_code"] as! String
        }else if SelMode == "HQ" {
            lblHQ.text = name  //+(item["id"] as! String)
            NewOutlet.shared.HQ.id = id
            NewOutlet.shared.HQ.name = name
            
            let LocalStoreage = UserDefaults.standard
           // let DistData: String=LocalStoreage.string(forKey: "Distributors_Master_"+id)!
            //new
            
            if(LocalStoreage.string(forKey: "Distributors_Master_"+id)==nil){
                self.ShowLoading(Message: "       Sync Data Please wait...")
                GlobalFunc.FieldMasterSync(SFCode: id){ [self] in
                    let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                    let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+id)!
                    if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                        self.lstDist = list;
                    }
                    if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                        lstAllRoutes = list
                        lstRoutes = list
                    }
                    self.LoadingDismiss()
                }
            }else {
                if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+id),
                   let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
                    lstDist = list
                }
                
                if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+id),
                   let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
                    lstAllRoutes = list
                    lstRoutes = list
                }
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
        formatter.dateFormat = "yyyy-MM-dd"
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
//        lstDist = lstDist.filter({(fitem) in
//                        let StkId: String = String(format: ",%@,", fitem["id"] as! CVarArg)
//            return Bool(StkId.range(of: String(format: ",%@,", NewOutlet.shared.Route.Stk_Id as CVarArg))?.lowerBound != nil )
//                    })
        lObjSel = lstDist
        openWin(Mode: "DIS")
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the \(UserSetup.shared.StkCap)"
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
        
        if UserSetup.shared.DistBased == 1{
            if NewOutlet.shared.Dist.id == "" {
                Toast.show(message: "Select the \(UserSetup.shared.StkCap)", controller: self)
                return false
            }
        }
       
        if NewOutlet.shared.Route.id == "" {
            Toast.show(message: "Select the Route", controller: self)
            return false
        }
        
        if NewOutlet.shared.OutletName == "" {
            Toast.show(message: "Enter the \(UserSetup.shared.DrCap) Name", controller: self)
            return false
        }
        if(NewOutlet.shared.ImgFileName == ""){
            Toast.show(message: "Take \(UserSetup.shared.DrCap) Photo", controller: self)
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
        
        if UserSetup.shared.Mandator == "phone" && txMobile.text == "" {
            Toast.show(message: "Enter the Mobile Number", controller: self)
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
        
        
//        if(NetworkMonitor.Shared.isConnected != true){
//            let alert = UIAlertController(title: "Information", message: "Check the Internet Connection", preferredStyle: .alert)
//                 alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
//                     return
//                 })
//                 self.present(alert, animated: true)
//                return
//        }
        
        if !GlobalFunc().hasInternet() {
                    Toast.show(message: "Internet is disconnected...Now in offline mode", controller: self)
                    return
                }
        self.ShowLoading(Message: "Data Submitting Please wait...")
        fnCreateNewOutlet()
        
    }
    func fnCreateNewOutlet(){
        let CDate: String = GlobalFunc.getCurrDateAsString()

        let jsonString = "[{\"unlisted_doctor_master\":{\"town_code\":\"'" + NewOutlet.shared.Route.id + "'\",\"wlkg_sequence\":\"null\",\"Retailerphoto\":{\"imgurl\":\"" + NewOutlet.shared.ImgFileName + "\"},\"unlisted_doctor_name\":\"'" + NewOutlet.shared.OutletName + "'\",\"unlisted_doctor_address\":\"'" + NewOutlet.shared.Address + "'\",\"unlisted_doctor_phone\":\"'" + NewOutlet.shared.Mobile + "'\",\"unlisted_doctor_cityname\":\"'" + NewOutlet.shared.City + "'\",\"unlisted_doctor_landmark\":\"''\",\"lat\":\"'" + NewOutlet.shared.Lat + "'\",\"long\":\"'" + NewOutlet.shared.Lng + "'\",\"unlisted_doctor_areaname\":\"'" + NewOutlet.shared.Street + "'\",\"unlisted_doctor_contactperson\":\"'" + NewOutlet.shared.OwnerName + "'\",\"unlisted_doctor_designation\":\"''\",\"unlisted_doctor_gst\":\"''\",\"unlisted_doctor_pincode\":\"'" + NewOutlet.shared.Pincode + "'\",\"unlisted_doctor_email\":\"''\",\"unlisted_doctor_phone2\":\"''\",\"unlisted_doctor_phone3\":\"''\",\"unlisted_doctor_contactperson2\":\"''\",\"unlisted_doctor_contactperson3\":\"''\",\"unlisted_doctor_designation2\":\"''\",\"unlisted_cat_code\":\"null\",\"unlisted_specialty_code\":" + NewOutlet.shared.Category.id + ",\"unlisted_qulifi\":\"'samp'\",\"unlisted_class\":" + NewOutlet.shared.Class.id + ",\"DrKeyId\":\"'" + eKey + "'\",\"ListedDr_DOB\":\"'" + NewOutlet.shared.DOB.id + "'\",\"ListedDr_DOW\":\"''\",\"layer\":\"''\",\"breeder\":\"''\",\"broiler\":\"''\",\"distributor_id\":\"'" +  NewOutlet.shared.Dist.id + "'\"}}]"
        
       
        
        let params: Parameters = [
            "data": jsonString //"["+jsonString+"]"//
        ]
        print(NewOutlet.shared.HQ.id)
        print(params)
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode +  "&rSF="+self.SFCode+"&sfCode="+self.SFCode)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode +  "&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            self.LoadingDismiss()
            switch AFdata.result
            {
               
            case .success(let value):
                print(value)
                print(NewOutlet.shared.HQ.id)
                if value is [String: Any] {
                    Toast.show(message: "Customer Added submitted successfully", controller: self)
                    
                    self.MasSync(apiKey:  "table/list&divisionCode=" + self.DivCode +  "&rSF="+NewOutlet.shared.HQ.id+"&sfCode="+NewOutlet.shared.HQ.id, aFormData: [
                        "tableName":"vwDoctor_Master_APP","coloumns":"[\"doctor_code as id\", \"doctor_name as name\",\"town_code\",\"town_name\",\"lat\",\"long\",\"addrs\",\"ListedDr_Address1\",\"ListedDr_Sl_No\",\"Mobile_Number\",\"Doc_cat_code\",\"ContactPersion\",\"Doc_Special_Code\",\"Distributor_Code\",\"Doctor_Code\",\"gst\",\"createdDate\",\"Doctor_Active_flag\",\"ListedDr_Email\",\"Spec_Doc_Code\",\"debtor_code\"]","where":"[\"isnull(Doctor_Active_flag,0)=0\"]","orderBy":"[\"name asc\"]","desig":"mgr"
                        ], aStoreKey: "Retail_Master_"+NewOutlet.shared.HQ.id)
                    NewOutlet.shared.Clear()
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
    
    

    
    
    
    // MARK: Custom Fields area
    
    func CustomDetails(){
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        let apiKey1: String = "get/CustomDetails&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)&moduleId=3"
        let apiKeyWithoutCommas = apiKey1.replacingOccurrences(of: ",&", with: "&")
        AF.request(APIClient.shared.BaseURL + APIClient.shared.CustomFieldDB + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
            case .success(let value):
                print(value)
                if let json = value as? [String:AnyObject]{
                    if let  customGrp = json["customGrp"] as? [AnyObject], let customData = json["customData"] as? [AnyObject]{
                        for i in customGrp{
                            let id = i["FieldGroupId"] as? String ?? ""
                            let filterFields = customData.filter { ($0["FieldGroupId"] as? Int ?? 0) == Int(id) }
                            let Custom_fields = CustomGroup_details(Custom_fields: filterFields)
                            
                           CustomGroupData.append(CustomGroup(FGTableName: i["FGTableName"] as? String ?? "", FGroupName: i["FGroupName"] as? String ?? "", FieldGroupId: i["FieldGroupId"] as? String ?? "", Customdetails_data: Custom_fields))
                        }
                    }
                }
                print(CustomGroupData)
                    self.AddCustom_Fields()
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    func CustomGroup_details(Custom_fields:[AnyObject]) ->[Customdetails]{
        
        var CustomdetailsModels: [Customdetails] = []
        for j in Custom_fields{
        let ModuleId:Int = j["ModuleId"] as? Int ?? 0
        let Field_Name:String = j["Field_Name"] as? String ?? ""
        let Fld_Type:String = j["Fld_Type"] as? String ?? ""
        let Fld_Symbol:String = j["Fld_Symbol"] as? String ?? ""
        let Field_Col:String = j["Field_Col"] as? String ?? ""
        let Fld_Length:Int = j["Fld_Length"] as? Int ?? 0
        let Mandate:Int = j["Mandate"] as? Int ?? 0
        let flag:Int = j["flag"] as? Int ?? 0
        let Fld_Src_Name:String = j["Fld_Src_Name"] as? String ?? ""
        let Fld_Src_Field:String = j["Fld_Src_Field"] as? String ?? ""
        let FieldGroupId:Int = j["FieldGroupId"] as? Int ?? 0
        let FGTableName:String = j["FGTableName"] as? String ?? ""
     
        let Custom_Model = Customdetails(ModuleId: ModuleId,
                                         Field_Name: Field_Name,
                                         Fld_Type: Fld_Type,
                                         Fld_Symbol: Fld_Symbol,
                                         Field_Col: Field_Col,
                                         Fld_Length: Fld_Length,
                                         Mandate: Mandate,
                                         flag: flag,
                                         Fld_Src_Name: Fld_Src_Name,
                                         Fld_Src_Field: Fld_Src_Field,
                                         FieldGroupId: FieldGroupId,
                                         FGTableName: FGTableName
        )
        CustomdetailsModels.append(Custom_Model)
    }
        
        return CustomdetailsModels
        
    }
    
    
   func AddCustom_Fields() {
//       let stackView = UIStackView()
//          stackView.axis = .vertical
//          stackView.spacing = 16
//          stackView.translatesAutoresizingMaskIntoConstraints = false
//
//          // Add the stack view to the main view
//          Custom_field_view.addSubview(stackView)
//
//          // Set stack view constraints below Outlet_Category_View
//          NSLayoutConstraint.activate([
//              stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//              stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//              stackView.topAnchor.constraint(equalTo: Outlet_Category_View.bottomAnchor, constant: 20), // Positioned below Outlet_Category_View
//              stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20) // Optional, ensures stackView doesn't overflow
//          ])
       
       // Populate the stack view with custom fields
//       StackView.axis = .vertical
//       StackView.distribution = .fill
//       StackView.alignment = .fill
       StackView.spacing = 10
       var index = 0
       var height:Double = 0
       for AddedFields_Title in CustomGroupData {
           
           if !AddedFields_Title.Customdetails_data.isEmpty{
               let header = HeaderLabel()
               header.configure(title: AddedFields_Title.FGroupName)
               header.layoutIfNeeded()

               // Calculate height
               let fittingSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
               print("Calculated height: \(fittingSize.height)")
               height = height+fittingSize.height + 10
               
               StackView.addArrangedSubview(header)
           }
          
           var index2 = 0
           for AddedFields in AddedFields_Title.Customdetails_data {
               if AddedFields.Fld_Type == "TAS" {
                   let customTextField = CustomTextField()
                   customTextField.configure(title: AddedFields.Field_Name, placeholder: "Enter the \(AddedFields.Field_Name)")
                   
                   customTextField.tag = index
                   customTextField.tags = [index,index2]
                   customTextField.delegate = self
                   customTextField.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customTextField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                
                   StackView.addArrangedSubview(customTextField)
               } else if AddedFields.Fld_Type == "NP" {
                   let customTextField = CustomTextNumberField()
                   customTextField.configure(title: AddedFields.Field_Name, placeholder: "Enter the \(AddedFields.Field_Name)")
                   customTextField.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customTextField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customTextField)
               } else if AddedFields.Fld_Type == "CO" {
                   let customCheckboxView = CustomCheckboxView()
                   customCheckboxView.configure(
                       title: AddedFields.Field_Name,
                       checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
                   )
                   
                   customCheckboxView.tag = index
                   customCheckboxView.tags = [index,index2]
                   
                   customCheckboxView.delegate = self
                   customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                   customCheckboxView.backgroundColor = .white
                   customCheckboxView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customCheckboxView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customCheckboxView)
               } else if AddedFields.Fld_Type == "SSO"{
                   let customCheckboxView = CustomCheckboxView()
                   customCheckboxView.configure(
                       title: AddedFields.Field_Name,
                       checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10", "Option 11", "Option 12", "Option 12", "Option 13", "Option 14"]
                   )
                   customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                   customCheckboxView.backgroundColor = .white
                   customCheckboxView.tag = index
                   customCheckboxView.tags = [index,index2]
                   customCheckboxView.delegate = self
                   customCheckboxView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customCheckboxView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customCheckboxView)
               }else if AddedFields.Fld_Type == "RO"{
                   let radioButtonView = CustomRadioButtonView()
                   radioButtonView.configure(title: AddedFields.Field_Name, radioButtonTitles: ["Option 1", "Option 2", "Option 3"])

                   // Add to the parent view and set frame or constraints
                   radioButtonView.translatesAutoresizingMaskIntoConstraints = false
                   
                   radioButtonView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = radioButtonView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(radioButtonView)
                   
               }else if AddedFields.Fld_Type == "RM"{
                   let radioButtonView = CustomRadioButtonView()
                   radioButtonView.configure(title: AddedFields.Field_Name, radioButtonTitles: ["Option 1 ", "Option 2", "Option 3"])
                   radioButtonView.translatesAutoresizingMaskIntoConstraints = false
                   
                   radioButtonView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = radioButtonView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(radioButtonView)
                   
               }else if AddedFields.Fld_Type == "D"{
                   let customLabel = CustomSelectionLabel()
                   customLabel.configure(title: AddedFields.Field_Name, value: "John Doe")
                   customLabel.tags = [index,index2]
                   customLabel.Typ = AddedFields.Fld_Type
                   customLabel.delegate = self
                   
                   customLabel.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customLabel)
                   
               }else if AddedFields.Fld_Type == "SSM"{
                   let customLabel = CustomSelectionLabel()
                   customLabel.configure(title: AddedFields.Field_Name, value: "Select Data")
                   customLabel.tags = [index,index2]
                   customLabel.Typ = AddedFields.Fld_Type
                   customLabel.delegate = self
                   
                   customLabel.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customLabel)
                   
               }else if AddedFields.Fld_Type == "FSC" || AddedFields.Fld_Type == "FC" {
                   let customField = CustomFieldUpload()
                   customField.setTitleText(AddedFields.Field_Name)
                   customField.setDynamicLabelText("Dynamic Content")
                   customField.hideCheckImage(true)
                   customField.tags = [index,index2]
                   customField.delegate = self
                   customField.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customField)
               }else if AddedFields.Fld_Type == "SMO"{
                   let customCheckboxView = CustomCheckboxView()
                   customCheckboxView.configure(
                       title: AddedFields.Field_Name,
                       checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 2", "Option 3", "Option 4"]
                   )
                   customCheckboxView.tag = index
                   customCheckboxView.delegate = self
                   customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                   customCheckboxView.backgroundColor = .white
                   customCheckboxView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customCheckboxView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customCheckboxView)
                   
               }else if AddedFields.Fld_Type == "CM"{
                   let customCheckboxView = CustomCheckboxView()
                   customCheckboxView.configure(
                       title: AddedFields.Field_Name,
                       checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 2", "Option 3", "Option 4"]
                   )
                   customCheckboxView.tag = index
                   customCheckboxView.delegate = self
                   customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                   customCheckboxView.backgroundColor = .white
                   
                   customCheckboxView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customCheckboxView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customCheckboxView)
                   
               }else if AddedFields.Fld_Type == "T"{
                   let customLabel = CustomSelectionLabel()
                   customLabel.configure(title: AddedFields.Field_Name, value: "Select \(AddedFields.Field_Name)")
                   customLabel.tags = [index,index2]
                   customLabel.Typ = AddedFields.Fld_Type
                   customLabel.delegate = self
                   customLabel.layoutIfNeeded()
                   // Calculate height
                   let fittingSize = customLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customLabel)
                   
               }else if AddedFields.Fld_Type == "TR"{
                   let CustomRange = CustomRangeField()
                   CustomRange.configure(title: AddedFields.Field_Name, from: "Select From Time", to: "Select To Time", mandatory: AddedFields.Mandate)
                   CustomRange.layoutIfNeeded()
                   let fittingSize = CustomRange.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(CustomRange)
               }else{
                   let customTextField = CustomTextNumberField()
                   customTextField.configure(title: AddedFields.Field_Name, placeholder: "Enter the \(AddedFields.Field_Name)")
                   
                   customTextField.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customTextField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customTextField)
               }
               index2 += 1
           }
           index += 1
       }
      // Scroll_View_Height.constant = Scroll_View_Height.constant + 5000
       
       print(height)
       Stack_view_height.constant = height
      Scroll_View_Height.constant = Scroll_View_Height.constant + Stack_view_height.constant
       StackView.layoutIfNeeded()
   }
    
 

   // MARK: - CustomCheckboxViewDelegate
   func checkboxViewDidSelect(_ title: String, isSelected: Bool, tag: Int, tags: [Int], Selectaheckbox: [String : Bool]) {
       print("Checkbox '\(title)' with tag \(tag) is \(isSelected ? "selected" : "deselected")")
       print(tags)
       print(Selectaheckbox)
   }
   
   func CustomFieldUploadDidSelect(tags: [Int]) {
       print(tags)
       let ShowPopup = UploadPopUpController()
       ShowPopup.didSelect = { data in
           
           print(data)
               self.ChangeText(text: "\(tags)", tags: tags)
       }
       ShowPopup.show()
   }
   
   
   func ChangeText(text:String,tags: [Int]){
       guard let stackView = StackView else {
              print("StackView is not connected")
              return
          }
           
           // Iterate through stackView's arrangedSubviews
           for subview in stackView.arrangedSubviews {
               if let customField = subview as? CustomFieldUpload, customField.tags == tags {
                   customField.setDynamicLabelText(text)
                   customField.hideCheckImage(false)
               }
           }
   }
   
   
   func CustomSelectionLabelDidSelect(tags: [Int], typ: String) {
       print(tags,typ)
       
       if typ == "D"{
           
           let ShowPopup = SelectDatePopUpController()
           ShowPopup.didSelect = { data in
               guard let stackView = self.StackView else {
                   print("StackView is not connected")
                   return
               }
               
               // Iterate through stackView's arrangedSubviews
               for subview in stackView.arrangedSubviews {
                   if let customField = subview as? CustomSelectionLabel, customField.tags == tags {
                       customField.SetDatetext(Date:data )
                       
                   }
               }
               
           }
           ShowPopup.show()
       }else if typ == "T"{
           let ShowPopup = DatePickerPopUPController()
           ShowPopup.didSelect = { data in
               guard let stackView = self.StackView else {
                   print("StackView is not connected")
                   return
               }
               
               // Iterate through stackView's arrangedSubviews
               for subview in stackView.arrangedSubviews {
                   if let customField = subview as? CustomSelectionLabel, customField.tags == tags {
                       customField.SetDatetext(Date:data )
                       
                   }
               }
               
           }
           ShowPopup.show()
       }
       
   }
   
   func customTextField(_ customTextField: CustomTextField, didUpdateText text: String, tags: [Int]) {
       print(tags)
       print(text)
   }
    

}
