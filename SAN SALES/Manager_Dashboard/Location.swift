//
//  Location.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//
import Alamofire
import UIKit
import MapKit
struct sflatlog: Codable {
    let lat: String
    let log: String
    let SfCode:String
}
struct Tabldata:Codable{
    let Id:String
    let Name:String
}
class Location: UIViewController,MKMapViewDelegate,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Select_Field: UIView!
    @IBOutlet weak var All_field_Force_View: UIView!
    @IBOutlet weak var Map_View: MKMapView!
    @IBOutlet weak var All_Field_Table: UITableView!
    
    @IBOutlet weak var Field_Force_lable: UILabel!
    @IBOutlet weak var Search: UIView!
    
    @IBOutlet weak var txSearchSel: UITextField!
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    var Userlatlog:[sflatlog] = []
    var FiledName:[Tabldata] = []
    var lAllObjSel: [Tabldata] = []
    var targetId: String = ""
    var First_Map_Open_Mod = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        Search.backgroundColor = .white
        Search.layer.cornerRadius = 10.0
        Search.layer.shadowColor = UIColor.gray.cgColor
        Search.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Search.layer.shadowRadius = 3.0
        Search.layer.shadowOpacity = 0.5
        
        Map_View.delegate = self
        All_Field_Table.delegate=self
        All_Field_Table.dataSource=self
        Select_Field.addTarget(target: self, action: #selector(OpenView))
        getUserDetails()
        Get_All_Field_Force()
        
       // Map_View.frame = view.bounds
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FiledName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText?.text = FiledName[indexPath.row].Name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = FiledName[indexPath.row].Id
        if id == ""{
           print("No Id")
            Field_Force_lable.text = FiledName[indexPath.row].Name
            First_Map_Open_Mod = "1"
            Get_All_Field_Force()
            All_field_Force_View.isHidden = true
        }else{
            Field_Force_lable.text = FiledName[indexPath.row].Name
            First_Map_Open_Mod = "2"
            //let filteredData = Userlatlog.filter { $0.SfCode == id }
            Get_All_Field_Force()
            print(Userlatlog)
            Userlatlog =  Userlatlog.filter { $0.SfCode.contains(id) }
            print(Userlatlog)
            addMarkersToMap()
            All_field_Force_View.isHidden = true
            if Userlatlog.isEmpty{
                let allAnnotations = Map_View.annotations
                  Map_View.removeAnnotations(allAnnotations)
                Toast.show(message: "No Location Found", controller: self)
            }
        }
        txSearchSel.text = ""
    }
    @objc func OpenView(){
        All_field_Force_View.isHidden = false
    }
    @IBAction func Close_View(_ sender: Any) {
        txSearchSel.text = ""
        All_field_Force_View.isHidden = true
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
    func Get_All_Field_Force(){
        FiledName.removeAll()
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
                    //print(prettyPrintedJson)
                   
                        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []),
                           let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
    
                            var All_Id = [String]()
                            FiledName.append(Tabldata(Id: "", Name: "All FIELD FORCE"))
                            for item in jsonArray {
                                if  let id = item["id"] as? String,let name = item["name"] as? String{
                                    
                                    FiledName.append(Tabldata(Id: id, Name: name))
                                    All_Id.append(id)
                                    
                                }
                            }
                            FiledName = FiledName.filter { $0.Id != SFCode }
                            print(FiledName)
                            All_Field_Table.reloadData()
                            let filteredIds = All_Id.filter { $0 != SFCode }
                            let encodedData = filteredIds.map { element in
                                return "%27\(element)%27"
                            }
                            
                            let joinedString = encodedData.joined(separator: "%2C")
                            //print(joinedString)
                            GetUser_Lat_Log(sfdata:joinedString)
                            // SfData.append(sfDetails(id: joinedString, name: "All Field Force"))
                        }else{
                            print("Error: Unable to parse JSON")
                        }
                    self.lAllObjSel = FiledName
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    func GetUser_Lat_Log(sfdata:String) {
        Userlatlog.removeAll()
         let formatters = DateFormatter()
         formatters.dateFormat = "yyyy-MM-dd"
        let apiKey: String = "get/locations&date=\(formatters.string(from: Date()))&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfcode=\(sfdata)&sfCode=\(SFCode)&stateCode=\(StateCode)"
        
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            response in
            switch response.result {
                
            case .success(let value):
               // print(value)
                if let json = value as? [String: AnyObject] {
                    if let resultArray = json["result"] as? [[String: AnyObject]] {
                        for result in resultArray {
                            if let lat = result["lat"] as? String,
                               let long = result["long"] as? String,let sfcode = result["sfcode"] as? String {
                                Userlatlog.append(sflatlog(lat: lat, log: long, SfCode: sfcode))
                            }
                        }
                    }
                }
                if (First_Map_Open_Mod == "1") {
                    addMarkersToMap()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    func addMarkersToMap() {
        let allAnnotations = Map_View.annotations
        Map_View.removeAnnotations(allAnnotations)
        print(Userlatlog)

        for latLog in Userlatlog {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latLog.lat)!, longitude: Double(latLog.log)!)
            annotation.title = "Your Title"
            Map_View.addAnnotation(annotation)
            let circle = MKCircle(center: annotation.coordinate, radius: 500)
                Map_View.addOverlay(circle)
        }

        // Add custom markers with custom images
        for latLog in Userlatlog {
            let annotation = CustomAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latLog.lat)!, longitude: Double(latLog.log)!)
            annotation.title = "Your Title"
            Map_View.addAnnotation(annotation)
        }

        // You can set the region to fit all markers
        if let firstLatLog = Userlatlog.first {
            let span = MKCoordinateSpan(latitudeDelta: 8.0, longitudeDelta: 8.0)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(firstLatLog.lat)!, longitude: Double(firstLatLog.log)!), span: span)
            Map_View.setRegion(region, animated: true)
        }
    }

    // CustomAnnotation class to use custom marker images
    class CustomAnnotation: MKPointAnnotation {
        var imageName: String = "mark"
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else {
            return nil
        }

        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotationView")
        annotationView.image = UIImage(named: customAnnotation.imageName)
        annotationView.canShowCallout = true
        return annotationView
    }


        // MARK: - MKMapViewDelegate
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//           guard annotation is MKPointAnnotation else { return nil }
//
//           let identifier = "marker"
//           var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
//           if annotationView == nil {
//               annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//               annotationView?.canShowCallout = true
//               let btn = UIButton(type: .detailDisclosure)
//               annotationView?.rightCalloutAccessoryView = btn
//           } else {
//               annotationView?.annotation = annotation
//           }
//
//           return annotationView
//       }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MKPointAnnotation else { return }

        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.first, error == nil else {
                print("Error reverse geocoding")
                return
            }

            var addressString = ""
            if let thoroughfare = placemark.thoroughfare {
                addressString += thoroughfare + ", "
            }
            if let locality = placemark.locality {
                addressString += locality + ", "
            }
            if let administrativeArea = placemark.administrativeArea {
                addressString += administrativeArea + " "
            }
            if let postalCode = placemark.postalCode {
                addressString += postalCode + ", "
            }
            if let country = placemark.country {
                addressString += country
            }

            print("Address: \(addressString)")

            annotation.subtitle = addressString

            DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) {
                      mapView.deselectAnnotation(annotation, animated: true)
                  }
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let title = view.annotation?.title, let subtitle = view.annotation?.subtitle {
                print("Title: \(title ?? ""), Subtitle: \(subtitle ?? "")")
            }
        }
    }
    
    @IBAction func searchBytext(_ sender: Any) {
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            FiledName = lAllObjSel
        }else{
            FiledName = lAllObjSel.filter({(product) in
                let name: String = product.Name
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        All_Field_Table.reloadData()
    }
}

