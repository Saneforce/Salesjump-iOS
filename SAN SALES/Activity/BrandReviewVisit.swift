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

class BrandReviewVisit: IViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var btrmktp: UIButton!
    @IBOutlet weak var txvRmks: UITextView!
    @IBOutlet weak var lblSelTitle: UILabel!
    @IBOutlet weak var tbDataSelect: UITableView!
    @IBOutlet weak var txSearchSel: UITextField!
    @IBOutlet weak var veselwindow: UIView!
    @IBOutlet weak var lblselectcustomer: LabelSelect!
    @IBOutlet weak var ActionTable: UITableView!
    @IBOutlet weak var ActionTable2: UITableView!
    @IBOutlet weak var Checkboxtable: UITableView!
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var BTcam: UIView!
    @IBOutlet weak var itmSmryHeight: NSLayoutConstraint!
    @IBOutlet weak var BrandTit: UIView!
    @IBOutlet weak var textField: UITextField!
    
    
    let product:[String] = ["Start Time","Retailer Channel","Address","GST"]
    
    struct SVCallRevw: Codable {
        let svCallRevw: SVCallRevwDetails
    }
    
    struct SVCallRevwDetails: Codable {
        let brandList: [BrandDetails]
    }
    struct mnuItem: Any {
        let MasId: Int
        let MasName: String
        let MasLbl : String
    }
    struct BrandDetails: Codable {
        let id: String
        let name: String
        let avai: Bool
        let ec: Bool
    }
    struct lItem: Any {
        let id: String
        let name: String
    }
    let axn="get/precall"
    let axndbsave="dcr/save"
    var barand: [String: SVCallRevw] = [:]
    var barand1: [String: SVCallRevwDetails] = [:]
    var barnrev: [String : BrandDetails] = [:]
    var objgetprecall: [AnyObject]=[]
    var lstAllProducts: [AnyObject] = []
    var lstBrands: [AnyObject] = []
    var lstSelBrands: [AnyObject] = []
    
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
    var lstAllRoutes: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    var lstDist: [AnyObject] = []

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
    var strMasList:[mnuItem]=[]
    
    var strSelAvl :String = ""
    var strSelEc :String = ""
    
    var brandListData = [brandReviewDataList]()

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
        let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+SFCode)!
        // let precall: String=LocalStoreage.string(forKey: "precall")!
        
        var objname = "Brand_Master"
        if UserSetup.shared.BrndRvwNd == 2 {
            objname = "Products_Master"
        }
        
        
        let lstCatData: String=LocalStoreage.string(forKey: objname)!
        if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
            lstAllRoutes = list;
            if UserSetup.shared.DistBased == 0 {
                lstRoutes = list
            }
        }
        
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
        //        if let list = GlobalFunc.convertToDictionary(text: precall) as? [AnyObject] {
        //            objgetprecall = list;
        //        }
        
      //  BrandTit.layer.cornerRadius=10.0
       // BrandTit.layer.borderWidth=1.0
        
        getUserDetails()
        Checkboxtable.delegate=self
        Checkboxtable.dataSource=self
        
        ActionTable.delegate=self
        ActionTable.dataSource=self
        
        ActionTable2.delegate=self
        ActionTable2.dataSource=self
        
        tbDataSelect.delegate=self
        tbDataSelect.dataSource=self
        
        btrmktp.addTarget(target: self, action: #selector(selRmksTemp))
        lblselectcustomer.addTarget(target: self, action: #selector(selRetails))
        BTback.addTarget(target: self, action: #selector(GotoHome))
        BTcam.addTarget(target: self, action: #selector(openCamera))
        
        self.ActionTable.register(UINib(nibName: "cellListItem", bundle: nil), forCellReuseIdentifier: "cellListItem")
        
        self.updateData()
        
        // Do any additional setup after loading the view.
    }
    

    @objc private func selRmksTemp() {
        //isDate = false
        isMulti=false
        lObjSel=lstRmksTmpl
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Reason"
        openWin(Mode: "RMK")
        
    }
    
    func updateData () {
        
        for brand in lstBrands {
            
            self.brandListData.append(brandReviewDataList(isSelectedAvail: false, isSelectedEC: false, brandData: brand))
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Checkboxtable == tableView { return brandListData.count }
        if ActionTable == tableView {return strMasList.count }
        if tbDataSelect == tableView {return lObjSel.count}
        if ActionTable2 == tableView {return product.count}
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:cellListItem
        if Checkboxtable == tableView{
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            let item: [String: Any]=lstBrands[indexPath.row] as! [String : Any]
            //let productitem: [String: Any]=lstAllProducts[indexPath.row] as! [String : Any]
            cell.imgSelect.addTarget(target: self, action: #selector(self.checkboxTappedAvl(_:)))
            cell.imgSelect2.addTarget(target: self, action: #selector(self.checkboxTappedEc(_:)))
            let proName = item["name"] as? String
            let uppercasedProName = proName?.uppercased()
            cell.lblText?.text = uppercasedProName
            // cell.lblText?.text = productitem["name"] as? String
            cell.imgSelect.image = UIImage(named:"uncheckbox")
            cell.selectionStyle = .none
        }
        else if  ActionTable == tableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
//            cell.lblText.text = self.strMasList[indexPath.row].MasName
//            cell.ActionTB.text = Self.strMasList[indexPath.rew].MasLbl
            //cell.lblText.text = self.product [indexPath.row]
            cell.lblText.text = strMasList[indexPath.row].MasName
            cell.ActionTB.text = strMasList[indexPath.row].MasLbl
            cell.ActionTB.numberOfLines = 0
            cell.ActionTB.lineBreakMode = .byWordWrapping
            
            ActionTable.isHidden = false
            ActionTable2.isHidden = true
            

        }
        else if ActionTable2 == tableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            cell.lblText.text = product[indexPath.row]
            ActionTable2.isHidden = false
        }
        
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            let item: [String: Any] = lObjSel[indexPath.row] as! [String : Any]
            cell.lblText?.text = item["name"] as? String
//            cell.imgSelect?.image = nil
//            if SelMode == "JWK" {
//                let sid=(item["id"] as! String)
//                let sfind: String = (";"+sid+";")
//                if let range: Range<String.Index> = (";"+strSelJWCd).range(of: sfind) {
//                    cell.imgSelect?.image = UIImage(named: "Select")
//                }
//            }
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
    
    func validateForm() -> Bool {
        VisitData.shared.VstRemarks.name = txvRmks.text
//        if VisitData.shared.AV.id == "" {
//            Toast.show(message: "Click Checkbox", controller: self)
//            return false
//        }
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
            let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
        self.ShowLoading(Message: "Getting Device Location...")
        VisitData.shared.cOutTime = GlobalFunc.getCurrDateAsString()
                self.ShowLoading(Message: "Data Submitting Please wait...")
                //let DataSF: String = self.lstPlnDetail[0]["subordinateid"] as! String
                var sImgItems:String = ""
                if(PhotosCollection.shared.PhotoList.count>0){
                    for i in 0...PhotosCollection.shared.PhotoList.count-1{
                        let item: [String: Any] = PhotosCollection.shared.PhotoList[i] as! [String : Any]
                        print(item["FileName"]  as! String)
                        let sep = item["FileName"]  as! String
                        let fullNameArr = sep.components(separatedBy: "_")
                        
                        let phono = fullNameArr[2]
                        var fullid = "_\(phono)"
                        print(fullid)
                     
                        if i > 0 { sImgItems = sImgItems + "," }
                        sImgItems = sImgItems + "{\\\"imgurl\\\":\\\"'" + (fullid) + "'\\\",\\\"title\\\":\\\"''\\\",\\\"remarks\\\":\\\"''\\\"}"
                    }
                }
        //             \"photosList\":\"[{\\\"imgurl\\\":\\\"'_1689760957.jpg'\\\",\\\"title\\\":\\\"''\\\",\\\"remarks\\\":\\\"''\\\"}]\"
                    
                var brndlst: String = ""
        //                for brand in lstBrands {
        //                    let id = brand["id"] as? String ?? ""
        //                    let name = brand["name"] as? String ?? ""
        //                    let strSelAcl = brand["Avai"] as? Bool ?? false
        //                    let strSelEc = brand["EC"] as? Bool ?? false
        //
        //                    brndlst = brndlst + "{\"id\":\"\(id)\",\"name\":\"\(name)\",\"Avai\":\(strSelAcl),\"EC\":\(strSelEc)},"
        //                }
                
                let brands = self.brandListData.filter{$0.isSelectedEC || $0.isSelectedAvail}
                
               for i in 0..<brands.count {
                   let id = brands[i].brandData["id"] as? Int ?? 0
                    let name = brands[i].brandData["name"] as? String ?? ""
                    let strSelAcl = brands[i].isSelectedAvail
                   let strSelEc = brands[i].isSelectedEC
                   print(id)

                    brndlst = brndlst + "{\\\"id\\\":\\\"\(id)\\\",\\\"name\\\":\\\"\(name)\\\",\\\"Avai\\\":\(strSelAcl),\\\"EC\\\":\(strSelEc)},"
                   
               }
                
                brndlst = String(brndlst.dropLast())
                
                let jsonString = "[{\"svCallRevw\":{\"worktype\":\"" + (self.lstPlnDetail[0]["worktype"] as! String) + "\",\"entryDate\":\"" + VisitData.shared.cInTime + "\",\"eDt\":\"" + VisitData.shared.cInTime + "\",\"subordinate\":\"MR4126\",\"stockist\":\"32539\",\"cluster\":\"114727\",\"clusterNm\":\"SAIDAPET\",\"doctorid\":\"" + VisitData.shared.CustID + "\",\"remarks\":\"" + VisitData.shared.VstRemarks.name + "\",\"BrandList\":\"[" + brndlst + "]\",\"photosList\":\"[" + sImgItems + "]\"}}]";
                
        //                print("____________")
        //                let jsonString = "[{\"svCallRevw\":{\"worktype\":\"1386\",\"entryDate\":\"2023-07-19 16:32:47\",\"eDt\":\"2023-07-19 00:00:00\",\"subordinate\":\"MR4126\",\"stockist\":\"32538\",\"cluster\":\"114726\",\"clusterNm\":\"SAIDAPET\",\"doctorid\":\"2372978\",\"remarks\":\"NOT INTERESTED\",\"BrandList\":\"[{\\\"id\\\":\\\"1698\\\",\\\"name\\\":\\\"Palkova\\\",\\\"Avai\\\":true,\\\"EC\\\":false},{\\\"id\\\":\\\"1649\\\",\\\"name\\\":\\\"Prestige Cooker\\\",\\\"Avai\\\":false,\\\"EC\\\":true}]\",\"photosList\":\"[{\\\"imgurl\\\":\\\"'_1689760957.jpg'\\\",\\\"title\\\":\\\"''\\\",\\\"remarks\\\":\\\"''\\\"}]\"}}]"
                
                
        //                let jsonString = "[{\"svCallRevw\":{\"worktype\":\"1386\",\"entryDate\":\"2023-04-27 10:48:21\",\"eDt\":\"2023-04-27 00:00:00\",\"subordinate\":\"mgr1018\",\"stockist\":\"32538\",\"cluster\":\"114726\",\"clusterNm\":\"SAIDAPET\",\"doctorid\":\"2051498\",\"remarks\":\"OWNER NOT AVAILABLE\",\"BrandList\":\"[{\\\"id\\\":\\\"1658\\\",\\\"name\\\":\\\"Brittania\\\",\\\"Avai\\\":false,\\\"EC\\\":true},{\\\"id\\\":\\\"909\\\",\\\"name\\\":\\\"BUTTERFLY FAN\\\",\\\"Avai\\\":true,\\\"EC\\\":false}]\",\"photosList\":\"[]\"}}]";
        //                print(jsonString)
            
                let params: Parameters = [
                    "data": jsonString
                ]
                print(params)
                AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode + "&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                    
                    AFdata in
                    print(AFdata)
                    self.LoadingDismiss()
                    switch AFdata.result
                    {
                    case .success(let value):
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
                    }
                }
     
                return
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                return
            })
            self.present(alert, animated: true)
        //subcall()
    }
    func subcall(){
        self.ShowLoading(Message: "Data Submitting Please wait...")
        //let DataSF: String = self.lstPlnDetail[0]["subordinateid"] as! String
        var sImgItems:String = ""
        if(PhotosCollection.shared.PhotoList.count>0){
            for i in 0...PhotosCollection.shared.PhotoList.count-1{
                let item: [String: Any] = PhotosCollection.shared.PhotoList[i] as! [String : Any]
                print(item["FileName"]  as! String)
                let sep = item["FileName"]  as! String
                let fullNameArr = sep.components(separatedBy: "_")
                
                let phono = fullNameArr[2]
                var fullid = "_\(phono)"
                print(fullid)
             
                if i > 0 { sImgItems = sImgItems + "," }
                sImgItems = sImgItems + "{\\\"imgurl\\\":\\\"'" + (fullid) + "'\\\",\\\"title\\\":\\\"''\\\",\\\"remarks\\\":\\\"''\\\"}"
            }
        }
//             \"photosList\":\"[{\\\"imgurl\\\":\\\"'_1689760957.jpg'\\\",\\\"title\\\":\\\"''\\\",\\\"remarks\\\":\\\"''\\\"}]\"
            
        var brndlst: String = ""
//                for brand in lstBrands {
//                    let id = brand["id"] as? String ?? ""
//                    let name = brand["name"] as? String ?? ""
//                    let strSelAcl = brand["Avai"] as? Bool ?? false
//                    let strSelEc = brand["EC"] as? Bool ?? false
//
//                    brndlst = brndlst + "{\"id\":\"\(id)\",\"name\":\"\(name)\",\"Avai\":\(strSelAcl),\"EC\":\(strSelEc)},"
//                }
        
        let brands = self.brandListData.filter{$0.isSelectedEC || $0.isSelectedAvail}
        
       for i in 0..<brands.count {
           let id = brands[i].brandData["id"] as? Int ?? 0
            let name = brands[i].brandData["name"] as? String ?? ""
            let strSelAcl = brands[i].isSelectedAvail
           let strSelEc = brands[i].isSelectedEC
           print(id)

            brndlst = brndlst + "{\\\"id\\\":\\\"\(id)\\\",\\\"name\\\":\\\"\(name)\\\",\\\"Avai\\\":\(strSelAcl),\\\"EC\\\":\(strSelEc)},"
           
       }
        
        brndlst = String(brndlst.dropLast())
        
        let jsonString = "[{\"svCallRevw\":{\"worktype\":\"" + (self.lstPlnDetail[0]["worktype"] as! String) + "\",\"entryDate\":\"" + VisitData.shared.cInTime + "\",\"eDt\":\"" + VisitData.shared.cInTime + "\",\"subordinate\":\"MR4126\",\"stockist\":\"32539\",\"cluster\":\"114727\",\"clusterNm\":\"SAIDAPET\",\"doctorid\":\"" + VisitData.shared.CustID + "\",\"remarks\":\"" + VisitData.shared.VstRemarks.name + "\",\"BrandList\":\"[" + brndlst + "]\",\"photosList\":\"[" + sImgItems + "]\"}}]";
        
    
        let params: Parameters = [
            "data": jsonString
        ]
        print(params)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode + "&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            
            AFdata in
            print(AFdata)
            self.LoadingDismiss()
            switch AFdata.result
            {
            case .success(let value):
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
            }
        }
    }
    
    
    func selectcustomer(mslno : String , sfcode : String ){
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&Msl_No=\(mslno)&sfCode=\(SFCode)&Mode=\(StrMode)"

        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result
            {
               
                case .success(let value):
                print(value)
                if let json = value as? [String:AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                      strMasList=[]
                    if(json.count>1){
                        strMasList.append(mnuItem.init(MasId: 1, MasName: "Start Time", MasLbl:VisitData.shared.cInTime))
                        strMasList.append(mnuItem.init(MasId: 2, MasName: "Retailer Channel", MasLbl:json["DrSpl"] as! String))//Doc_Spec_ShortName
                        strMasList.append(mnuItem.init(MasId: 3, MasName: "Address", MasLbl:json["Address"] as! String))
                        strMasList.append(mnuItem.init(MasId: 4, MasName: "GST", MasLbl:json["GST"] as! String))
                       // strMasList.append(mnuItem(MasId:5, MasName: "Last Order Date", MasLbl: json["Last_Order_Date"] as! String))
                        

                    }

                    print(prettyPrintedJson)
                   // self.objgetprecall = json
                 self.ActionTable.reloadData()
                    ActionTable.isHidden = false
                    
                                        
                }
               case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    @objc func checkboxTappedAvl(_ sender: UITapGestureRecognizer) {
            let cell: cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
            let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
            let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        var item: [String: Any]=lstBrands[indxPath.row] as! [String : Any]
        let sid=String(format: "%@", item["id"] as! CVarArg)
//        if lstBrands[indxPath.row].boolValue["Avai"] == false {
//            (lstBrands[indxPath.row]?["Avai"])
//        }
            if cell.ischeck == false
            {
                cell.ischeck = true
                cell.imgSelect.image = UIImage(named:"checkbox")
                strSelAvl=strSelAvl + sid+";"
                
                self.brandListData[indxPath.row].isSelectedAvail = true
            }
            else
            {
                cell.ischeck = false
                cell.imgSelect.image = UIImage(named:"uncheckbox")
                strSelAvl=strSelAvl.replacingOccurrences(of: sid+";", with: "")
                
                
                self.brandListData[indxPath.row].isSelectedAvail = false
            }
        }
    
    @objc func checkboxTappedEc (_ sender: UITapGestureRecognizer){
            let cell: cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
            let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
            let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        
        var item: [String: Any]=lstBrands[indxPath.row] as! [String : Any]
        let sid=String(format: "%@", item["id"] as! CVarArg)
        if cell.ischeck == false
            {
                cell.ischeck = true
                cell.imgSelect2.image = UIImage(named:"checkbox")
                print("\(lstBrands[indxPath.row])")
                strSelEc=strSelEc + sid+";"

                self.brandListData[indxPath.row].isSelectedEC = true
            }
            else
            {
                cell.ischeck = false
                cell.imgSelect2.image = UIImage(named:"uncheckbox")
                strSelEc=strSelEc.replacingOccurrences(of: sid+";", with: "")
                
                self.brandListData[indxPath.row].isSelectedEC = false
            }
        
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
        //let cell:UIUserInterfaceStyle = false
        let name=item["name"] as! String
        let id=String(format: "%@", item["id"] as! CVarArg)
        
        //lblselectcustomer.text = name
       // txvRmks.text = name
       
        if SelMode == "RET"{
            selectcustomer(mslno: id , sfcode: SFCode)
            VisitData.shared.CustID = id
            VisitData.shared.CustName = name
            VisitData.shared.cInTime = GlobalFunc.getCurrDateAsString()
            lblselectcustomer.text = name
        }
         if SelMode == "DIS" {
            lstRoutes = lstAllRoutes.filter({(fitem) in
                let StkId: String = String(format: ",%@,", fitem["stockist_code"] as! CVarArg)
                return Bool(StkId.range(of: String(format: ",%@,", id))?.lowerBound != nil )
            })
        }
        if SelMode == "HQ" {
            var DistData: String=""
            if(LocalStoreage.string(forKey: "Distributors_Master_"+id)==nil){
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
        }
        if SelMode=="RMK" {
            txvRmks.text = name
            VisitData.shared.VstRemarks.name = name
            VisitData.shared.VstRemarks.id = id
            
        }
    clswindow(self)
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
    @objc private func selRetails(){
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
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clswindow(_ sender: Any) {
        veselwindow.isHidden=true
    }
}


struct brandReviewDataList {
    
    var isSelectedAvail : Bool
    var isSelectedEC : Bool
    var brandData : AnyObject
}

