//
//  SuperStockistOrder.swift
//  SAN SALES
//
//  Created by Naga Prasath on 04/03/24.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

class SuperStockistOrder : IViewController {
    
    
    
    @IBOutlet weak var img_back: UIImageView!
    
    @IBOutlet weak var txtRemarks: UITextView!
    
    @IBOutlet weak var lblSuperStockist: UILabel!
    
    @IBOutlet weak var vwOrder: RoundedCornerView!
    
    
    var lstRmksTmpl: [AnyObject] = []
    var lstSuperStockist : [AnyObject] = []
    var sAddress: String = ""
    var Location : String = ""
    var DataSF: String = ""
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String="", rSF: String = "", eKey: String = ""
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtRemarks.delegate = self
        txtRemarks.textColor = .darkGray
        
        img_back.addTarget(target: self, action: #selector(GotoHome))
        
        vwOrder.addTarget(target: self, action: #selector(openOrder))
        
        lblSuperStockist.addTarget(target: self, action: #selector(superStockis))
        getUserDetails()
        
        let RmkDatas: String=LocalStoreage.string(forKey: "Templates_Master")!
        let stockistDatas : String =  LocalStoreage.string(forKey: "Supplier_Master_"+SFCode)!
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: RmkDatas) as? [AnyObject] {
            lstRmksTmpl = list;
        }
        
        if let stockistList = GlobalFunc.convertToDictionary(text: stockistDatas) as? [AnyObject] {
            lstSuperStockist = stockistList
        }
        
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
        eKey = String(format: "EK%@-%i", SFCode,Int(Date().timeIntervalSince1970))
    }
    
    func isValid() -> Bool {
        VisitData.shared.VstRemarks.name = txtRemarks.textColor == .darkGray ? "" : txtRemarks.text
        if VisitData.shared.CustID == "" {
            Toast.show(message: "Select Super Stockist Name", controller: self)
            return false
        }
        return true
    }
    
    @IBAction func templateAction(_ sender: UIButton) {
        
        
        let remarksVC = ItemViewController(items: lstRmksTmpl, configure: { (Cell : SingleSelectionTableViewCell, remark) in
            Cell.textLabel?.text = remark["name"] as? String
        })
        remarksVC.title = "Select the Reason"
        remarksVC.didSelect = { selectedRmk in
            print(selectedRmk)
            self.txtRemarks.text = selectedRmk["name"] as? String
            self.txtRemarks.textColor = UIColor(cgColor: CGColor(red: 54/255, green: 53/255, blue: 53/255, alpha: 1.0))
            VisitData.shared.VstRemarks.name = selectedRmk["name"] as? String ?? ""
            VisitData.shared.VstRemarks.id = selectedRmk["id"] as? String ?? ""
            
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(remarksVC, animated: true)
        
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        if isValid() == false {
            return
        }
        
        if LocationService.sharedInstance.isLocationPermissionEnable() == false{
            Toast.show(message: "Please Enable Location", controller: self)
            return
        }
        print(VisitData.shared.VstRemarks.name)
        
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
                            }
                        }
                        self.ShowLoading(Message: "Data Submitting Please wait...")
                        
                        let sessionManager = Session(configuration: URLSessionConfiguration.default)
                        
                        sessionManager.session.configuration.httpMaximumConnectionsPerHost = 1
                        
                        self.submitWithoutOrder()
                        
                    }
                    
                }, error:{ errMsg in
                    self.LoadingDismiss()
                    Toast.show(message: errMsg, controller: self)
                    
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
        
    }
    
    
    func submitWithoutOrder() {
        let sLocation = Location
        
        var lstPlnDetail: [AnyObject] = []
        if self.LocalStoreage.string(forKey: "Mydayplan") == nil { return }
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
            DataSF = lstPlnDetail[0]["subordinateid"] as! String
        }
        
        let date = Date().toString(format: "yyyy-MM-dd hh:mm:ss")
        
        print(date)
        
        let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"\'" + (lstPlnDetail[0]["worktype"] as! String) + "\'\",\"Town_code\":\"\'" + (lstPlnDetail[0]["ClstrName"] as! String) + "\'\",\"Territory_code\":\"\'\'\",\"area_name\":\"\'\'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'" + VisitData.shared.cInTime + "\'\",\"Daywise_Remarks\":\"" + VisitData.shared.VstRemarks.name.trimmingCharacters(in: .whitespacesAndNewlines) + "\",\"eKey\":\"" + self.eKey + "\",\"rx\":\"\'\'\",\"rx_t\":\"\'\'\",\"DataSF\":\"\'" + self.DataSF + "\'\"}},{\"Activity_Stockist_Report\":{\"Stockist_POB\":\"\",\"Worked_With\":\"\'\'\",\"location\":\"\'" + sLocation + "\'\",\"geoaddress\":\"" + sAddress + "\",\"stockist_code\":\"\'" + VisitData.shared.CustID + "\'\",\"superstockistid\":\"\'\'\",\"stockist_name\":\"\'" + VisitData.shared.CustName + "\'\",\"version\":8,\"doctor_id\":\"\'" + VisitData.shared.CustID + "\'\",\"Stk_Meet_Time\":\"\'" + VisitData.shared.cInTime + "\'\",\"modified_time\":\"\'" + VisitData.shared.cInTime + "\'\",\"date_of_intrument\":\"\",\"intrumenttype\":\"\",\"orderValue\":0,\"Aob\":0,\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"CheckoutTime\":\"" + VisitData.shared.cInTime + "\",\"audioFileName\":\"\'\'\",\"audioFilePath\":\"\'\'\",\"PhoneOrderTypes\":1,\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"}}},{\"Activity_Stk_POB_Report\":[]},{\"Activity_Stk_Sample_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]},{\"Activity_Event_Captures_Call\":[]}]"
        
        
        let params: Parameters = [
            "data": jsonString //"["+jsonString+"]"//
        ]
        print(params)
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode=" + self.DivCode + "&sfCode="+self.SFCode)
        let url = "http://fmcg.sanfmcg.com/server/native_Db_V13.php?axn=dcr/save&divisionCode=29,&sfCode=SEFMR0040"
        
        print(url) //APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode=" + self.DivCode + "&sfCode="+self.SFCode
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode=" + self.DivCode + "&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseData { AFdata in
            self.LoadingDismiss()
            switch AFdata.result
            {
                
            case .success(let value):
                print(value)
                let apiResponse = try? JSONSerialization.jsonObject(with: AFdata.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                print(apiResponse as Any)
                VisitData.shared.clear()
                Toast.show(message: "Super Stockist Order has been submitted successfully", controller: self)
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                UIApplication.shared.windows.first?.rootViewController = viewController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    @objc private  func superStockis() {
        
        let stockistVC = ItemViewController(items: lstSuperStockist, configure: { (Cell : SingleSelectionTableViewCell, stockist) in
            Cell.textLabel?.text = stockist["name"] as? String
        })
        stockistVC.title = "Select the Name"
        stockistVC.didSelect = { selectedStk in
            print(selectedStk)
            self.lblSuperStockist.text = selectedStk["name"] as? String
            
            VisitData.shared.CustID = selectedStk["id"] as? String ?? ""
            VisitData.shared.CustName = selectedStk["name"] as? String ?? ""
            print(Date().toString(format: "yyyy-MM-dd hh:mm:ss"))
            VisitData.shared.cInTime = Date().toString(format: "yyyy-MM-dd hh:mm:ss")
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(stockistVC, animated: true)
    }
    
    
    @objc private func openOrder(){
        if isValid() == false {
            return
        }
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbSuperStockistOrderList") as!  SuperStockistOrderList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func GotoHome() {
        self.dismiss(animated: true, completion: nil)
        GlobalFunc.movetoHomePage()
    }
    
}

extension SuperStockistOrder: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = UIColor(cgColor: CGColor(red: 54/255, green: 53/255, blue: 53/255, alpha: 1.0))
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter the Remarks ( or ) Select from Template"
            textView.textColor = UIColor.darkGray
        }
    }
}


extension Date{
    func toString(format: String = "hh:mm a") -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
