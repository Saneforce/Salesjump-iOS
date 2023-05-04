//
//  GEOTagging.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 08/10/22.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation
import MapKit

class GEOTagging: IViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    @IBOutlet weak var vwSelWindow: UIView!
    @IBOutlet weak var lblSelTitle: UILabel!
    @IBOutlet weak var tbPopDataSelect: UITableView!
    @IBOutlet weak var txSelSearchSel: UITextField!
    var tlObjSel: [AnyObject] = []
    var tlAllObjSel: [AnyObject] = []
    
    @IBOutlet weak var txSearchSel: UITextField!
    @IBOutlet weak var lblLatLng: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblAddr: UILabel!
    @IBOutlet weak var lblHQ: UILabel!
    @IBOutlet weak var tbDataSelect: UITableView!
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var btntag: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segui: UISegmentedControl!
    
    @IBOutlet weak var vwMapTag: UIView!
    
    var lObjSel: [AnyObject] = []
    var lAllObjSel: [AnyObject] = []
    var lstRetails: [AnyObject] = []
    var lstDists: [AnyObject] = []
    var lstHQs: [AnyObject] = []
    
    var SFCode: String = ""
    var DivCode: String = ""
    var DataSF: String = ""
    var CustCode: String = ""
    var CurrLoc: String = ""
    var sAddress: String = ""
    var sMode: String = ""
    var eKey: String = ""
    let LocalStoreage = UserDefaults.standard
    override func viewDidLoad() {
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        DataSF = prettyJsonData["sfCode"] as? String ?? ""
        let SFName: String=prettyJsonData["sfName"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        eKey = String(format: "EK%@-%i", SFCode,Int(Date().timeIntervalSince1970))
        
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
                let RetailData: String=LocalStoreage.string(forKey: "Retail_Master_"+id)!
                if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                    lstDists = list;
                }
                if let list = GlobalFunc.convertToDictionary(text: RetailData) as? [AnyObject] {
                    lstRetails = list;
                }
            }
            else
            {
                lblHQ.addTarget(target: self, action: #selector(selHeadquaters))
            }
        }
        
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        getTaggData()
        btntag.isHidden = true
        tbDataSelect.delegate=self
        tbDataSelect.dataSource=self
        tbPopDataSelect.delegate=self
        tbPopDataSelect.dataSource=self
        self.mapView.delegate=self
    }
    @objc private func selHeadquaters() {
        tlObjSel=lstHQs
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Headquarter"
        openWin(Mode: "HQ")
    }
    func openWin(Mode:String){
        tlAllObjSel = tlObjSel
        txSelSearchSel.text = ""
        vwSelWindow.isHidden=false
        tbPopDataSelect.reloadData()
    }
    @IBAction func searchSelBytext(_ sender: Any) {
        
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            tlObjSel = tlAllObjSel
        }else{
            tlObjSel = tlAllObjSel.filter({(product) in
                let name: String = String(format: "%@", product["name"] as! CVarArg)
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        tbDataSelect.reloadData()
        
    }
    @IBAction func closeWin(_ sender:Any){
        vwSelWindow.isHidden=true
    }
    func getTaggData(){
        if(LocalStoreage.string(forKey: "Distributors_Master_"+DataSF)==nil){
            GlobalFunc.FieldMasterSync(SFCode: DataSF) {
                
                //new
                if let lstRetailData = self.LocalStoreage.string(forKey: "Retail_Master_"+self.DataSF),
                   let list = GlobalFunc.convertToDictionary(text:  lstRetailData) as? [AnyObject] {
                    self.lstRetails = list;
                }
                //new
                
                //let lstRetailData: String = self.LocalStoreage.string(forKey: "Retail_Master_"+self.DataSF)!
                let lstDistData: String = self.LocalStoreage.string(forKey: "Distributors_Master_"+self.DataSF)!
                    
//                if let list = GlobalFunc.convertToDictionary(text: lstRetailData) as? [AnyObject] {
//                    self.lstRetails = list;
//                }
                if let list = GlobalFunc.convertToDictionary(text: lstDistData) as? [AnyObject] {
                    self.lstDists = list;
                }
                
                self.CustTypeChange(self.segui as Any)
            }
            return
        }else{
            let lstRetailData: String = LocalStoreage.string(forKey: "Retail_Master_"+DataSF)!
            let lstDistData: String = LocalStoreage.string(forKey: "Distributors_Master_"+DataSF)!
            
            if let list = GlobalFunc.convertToDictionary(text: lstRetailData) as? [AnyObject] {
                lstRetails = list;
            }
            if let list = GlobalFunc.convertToDictionary(text: lstDistData) as? [AnyObject] {
                lstDists = list;
            }
            self.CustTypeChange(self.segui as Any)
        }
       // lAllObjSel=lstRetails
       // lObjSel = lAllObjSel
    }
    @objc private func GotoHome() {
        if(self.vwMapTag.isHidden == false){
            self.vwMapTag.isHidden = true
            btntag.isHidden = true
        }else{
            self.dismiss(animated: true, completion: nil)
            GlobalFunc.movetoHomePage()
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView==tbPopDataSelect{
            return 42
        }
        return 61
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==tbPopDataSelect{
            return tlObjSel.count
        }
        return lObjSel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        let item: [String: Any]
        if tableView==tbPopDataSelect{
            item = tlObjSel[indexPath.row] as! [String : Any]
        }else{
            item = lObjSel[indexPath.row] as! [String : Any]
        }
        cell.lblText?.text = item["name"] as? String
        if tableView != tbPopDataSelect{
            cell.lblValue.text = String(format: "%@", item["town_name"] as! CVarArg)
            var sStrloc: String = String(format: "%@, %@", item["lat"] as! CVarArg,item["long"] as! CVarArg)
            cell.imgSelect?.image = UIImage(named: "marker50")?.withRenderingMode(.alwaysTemplate)
            cell.imgSelect.tintColor = .systemGreen
            if sStrloc==", " { sStrloc = ""
                cell.imgSelect?.image = UIImage(named: "markeroff50")?.withRenderingMode(.alwaysTemplate)
                cell.imgSelect.tintColor = .systemGray4
            }
            cell.lblUOM.text = sStrloc
        }else{cell.imgSelect.isHidden=true}
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbPopDataSelect{
            let item: [String: Any] = tlObjSel[indexPath.row] as! [String : Any]
            DataSF = String(format: "%@", item["id"] as! CVarArg)
            lblHQ.text = String(format: "%@", item["name"] as! CVarArg)
            getTaggData()
            closeWin(self)
        }else{
            let item: [String: Any] = lObjSel[indexPath.row] as! [String : Any]
            
            var sStrloc: String = String(format: "%@, %@", item["lat"] as! CVarArg,item["long"] as! CVarArg)
            
            let id=String(format: "%@", item["id"] as! CVarArg)
            CustCode = id
            var flag: String = "1"
            if sStrloc==", " {
                sStrloc = ""
                flag="0"
            }
            self.CurrLoc = sStrloc
            
            self.lblLatLng.text = sStrloc
            self.lblText?.text = item["name"] as? String
            btntag.isHidden = false
            openMapView(flag: flag)
            
        }
    }
    @IBAction func CustTypeChange(_ sender: Any) {
        let CustTyp: UISegmentedControl = sender as! UISegmentedControl
        if(CustTyp.selectedSegmentIndex == 1){
            lAllObjSel=lstDists
            sMode = "D"
        } else {
            lAllObjSel=lstRetails
            sMode = "R"
        }
        lObjSel = lAllObjSel
        tbDataSelect.reloadData()
        
    }
    @IBAction func svGeoTag(_ sender: Any) {
        
        if(NetworkMonitor.Shared.isConnected != true){
            let alert = UIAlertController(title: "Information", message: "Check the Internet Connection", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                     return
                 })
                 self.present(alert, animated: true)
                return
        }
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to Tag this location ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
        self.ShowLoading(Message: "Data Submitting Please wait...")
                
        let jsonString = "{\"Cust_Code\":\"\'" + self.CustCode + "\'\",\"latlng\":\"" + self.CurrLoc + "\",\"Addr\":\"" + self.sAddress + "\",\"Mode\":\"" + self.sMode + "\",\"eKey\":\"" + self.eKey + "\"}"
        let params: Parameters = [
                    "data": jsonString //"["+jsonString+"]"//
        ]
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"save/geotag&divisionCode=" + self.DivCode + "&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            self.LoadingDismiss()
            switch AFdata.result
            {
                   
                case .success(let value):
                    if let json = value as? [String: Any] {
                        Toast.show(message: "Successfully Tagged ", controller: self)
                        if (self.sMode=="R"){
                            self.MasSync(apiKey:  "table/list&divisionCode=" + self.DivCode +  "&rSF=" + self.SFCode + "&sfCode="+self.SFCode, aFormData: [
                                "tableName":"vwDoctor_Master_APP","coloumns":"[\"doctor_code as id\", \"doctor_name as name\",\"town_code\",\"town_name\",\"lat\",\"long\",\"addrs\",\"ListedDr_Address1\",\"ListedDr_Sl_No\",\"Mobile_Number\",\"Doc_cat_code\",\"ContactPersion\",\"Doc_Special_Code\"]","where":"[\"isnull(Doctor_Active_flag,0)=0\"]","orderBy":"[\"name asc\"]","desig":"mgr"
                            ], aStoreKey: "Retail_Master_"+self.SFCode)
                        }else{
                            self.MasSync(apiKey: "table/list&divisionCode=" + self.DivCode + "&rSF=" + self.SFCode + "&sfCode=" + self.SFCode,aFormData: [
                                "tableName":"vwstockiest_Master_APP","coloumns":"[\"distributor_code as id\", \"stockiest_name as name\",\"town_code\",\"town_name\",\"Addr1\",\"Addr2\",\"City\",\"Pincode\",\"GSTN\",\"lat\",\"long\",\"addrs\",\"Tcode\",\"Dis_Cat_Code\"]","where":"[\"isnull(Stockist_Status,0)=0\"]","orderBy":"[\"name asc\"]","desig":"mgr"
                            ],aStoreKey: "Distributors_Master_"+self.SFCode)
                        }
                        self.mapView.isHidden = false
                        self.btntag.isHidden = true
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription ?? "", controller: self)
                }
            }
            
                
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    func openMapView(flag: String){
        self.vwMapTag.isHidden = false
        self.mapView.showsUserLocation = true
        if(flag=="1"){
            self.btntag.isHidden = true
            self.mapView.removeOverlays(mapView.overlays)
            var str: [String] = self.CurrLoc.replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
            let lat: Double = Double("\(str[0] as! String)")!
            let lon: Double = Double("\(str[1] as! String)")!
            let center = CLLocationCoordinate2D(latitude: lat , longitude: lon)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            self.lblLatLng.text = self.CurrLoc
            
            var circle = MKCircle(center: center, radius: 500 as CLLocationDistance)
            var placemrk = MKPlacemark(coordinate:center)
            self.mapView.addOverlay(circle)
        }else{
            LocationService.sharedInstance.getNewLocation(location: { location in
                let sLocation: String = location.coordinate.latitude.description + ", " + location.coordinate.longitude.description
                lazy var geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
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
                            
                            self.lblAddr.text = self.sAddress
                            
                        }
                    }
                }
                
                self.lblLatLng.text = sLocation
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                self.mapView.setRegion(region, animated: true)
                self.lblLatLng.text = sLocation
                self.CurrLoc = sLocation
                self.btntag.isHidden = false
            }, error:{ errMsg in
                self.LoadingDismiss()
                Toast.show(message: errMsg, controller: self)
            })
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let sLocation: String = mapView.centerCoordinate.latitude.description + ", " + mapView.centerCoordinate.longitude.description
        lazy var geocoder = CLGeocoder()
        var userLoc: CLLocation = CLLocation.init(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        geocoder.reverseGeocodeLocation(userLoc) { (placemarks, error) in
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
                    
                    self.lblAddr.text = self.sAddress

                }
            }
        }
        
        self.lblLatLng.text = sLocation
        self.CurrLoc = sLocation
    }
    private func addCustompin(){
        let pin = MKPointAnnotation()
        pin.title = ""
        pin.subtitle = ""
        mapView.addAnnotation(pin)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage (named: "marker50")
        return annotationView
    }
    
    //to be replace Common function
    func MasSync(apiKey: String,aFormData: [String: Any],aStoreKey:String) {
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

                   print(prettyPrintedJson)
                   let LocalStoreage = UserDefaults.standard
                   LocalStoreage.set(prettyPrintedJson, forKey: aStoreKey)
               case .failure(let error):
                   print(error.errorDescription!)
            }
            
            self.vwMapTag.isHidden = true
            self.getTaggData()
        }
    }
}
