//
//  MissedDateRouteSelection.swift
//  SAN SALES
//
//  Created by Naga Prasath on 18/06/24.
//

import Foundation
import UIKit

class MissedDateRouteSelection : IViewController , UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var lblHeadquarters: LabelSelect!
    @IBOutlet weak var lblDistributor: LabelSelect!
    @IBOutlet weak var lblRoutes: LabelSelect!
    @IBOutlet weak var tableViewOrderList: UITableView!
    
    
    @IBOutlet weak var vwHeadquartes: UIView!
    @IBOutlet weak var vwDistributors: UIView!
    @IBOutlet weak var vwRoutes: UIView!
    
    
    
    @IBOutlet weak var heightVwheadquartersConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightVwDistributorsConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightVwRoutesConstraints: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var topHeightVwHeadquartersConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var topHeightVwDistributorsConstraints: NSLayoutConstraint!
    
    var missedDateSubmit : ([RetailerList]) -> () = { _ in}
    var isFromSecondary : Bool!
    
    var lstHQs: [AnyObject] = []
    
    var lstDist: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    var lstRmksTmpl: [AnyObject] = []
    var lstAllRetails: [AnyObject] = []
    var lstRetails : [AnyObject] = []
    
    var sfCode = "",divCode = "",desig = "", sfName = "",stateCode = "",eKey=""
    let LocalStoreage = UserDefaults.standard
    
    var retailerList = [RetailerList]()
    var selectedList = [RetailerList]()
    var allRetailerList = [RetailerList]()
    
    var selectedHeadquarter : AnyObject! {
        didSet {
            self.lblHeadquarters.text = selectedHeadquarter["name"] as? String
            
            self.selectedDistributor = nil
            lblDistributor.text = "Select the \(UserSetup.shared.StkCap)"
            
            
            self.selectedRoute = nil
            self.lblRoutes.text = "Select the \(UserSetup.shared.StkRoute)"
            self.retailerList.removeAll()
            self.tableViewOrderList.reloadData()
            
        }
    }
    
    var selectedDistributor : AnyObject? {
        didSet {
            self.lblDistributor.text = selectedDistributor?["name"] as? String
            
            
        }
    }
    
    var selectedRoute : AnyObject! {
        didSet {
            self.lblRoutes.text = selectedRoute?["name"] as? String
        }
    }
    
    var route : AnyObject!
    var distributor : AnyObject?
    var headquarter : AnyObject!
    
    var selectedWorktype : AnyObject!
    
    var selectedDate : AnyObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBack.addTarget(target: self, action: #selector(backVC))
        lblHeadquarters.addTarget(target: self, action: #selector(headquarterAction))
        lblDistributor.addTarget(target: self, action: #selector(distributorAction))
        lblRoutes.addTarget(target: self, action: #selector(routeAction))
        getUserDetails()
        updateDisplay()
        if UserSetup.shared.SF_type != 1 {
            if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
               let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
                lstHQs = list
                
                self.selectedHeadquarter = list.first
                self.updateRoutes(id: selectedHeadquarter["id"] as? String ?? "")
            }
        }
        
//        selectedHeadquarter = headquarter
//        selectedDistributor = distributor
        selectedRoute = route
        
        
        if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+sfCode),
           let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
            lstDist = list;
            if self.isFromSecondary == false {
                updateDistributor(distributors: list, sfcode: sfCode)
            }
        }
        
        if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+sfCode),
           let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
            lstRoutes = list
            
        }
        
        if let RetailData = LocalStoreage.string(forKey: "Retail_Master_"+sfCode),
           let list = GlobalFunc.convertToDictionary(text:  RetailData) as? [AnyObject] {
            lstAllRetails = list
            
            if self.isFromSecondary == true {
                self.updateRetailer(retailers: list, sfcode: sfCode)
            }
            
        }
        
        let RmkDatas: String=LocalStoreage.string(forKey: "Templates_Master")!
        
        if let list = GlobalFunc.convertToDictionary(text: RmkDatas) as? [AnyObject] {
            lstRmksTmpl = list;
        }
        
        if UserSetup.shared.SrtEndKMNd == 2 {
            if UserSetup.shared.SF_type != 1 {
                selectedHeadquarter = headquarter
                self.updateRoutes(id: selectedHeadquarter["id"] as? String ?? "")
            }
            if UserSetup.shared.distributorBased != 0{
                selectedDistributor = distributor
            }
            
            selectedRoute = route
            self.update()
        }
    }
    
    func update() {
        if self.isFromSecondary == true {
            self.retailerList = self.allRetailerList.filter{$0.townCode == "\(self.selectedRoute["id"] as? String ?? "")"}
        }
        
        if self.isFromSecondary == false {
            if UserSetup.shared.SF_type != 1{
                self.retailerList = self.allRetailerList.filter{$0.mapId == self.selectedHeadquarter["id"] as? String ?? ""}
            }else {
                self.retailerList = self.allRetailerList
            }
        }
        self.tableViewOrderList.reloadData()
    }
    
    func getUserDetails(){
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        sfCode = prettyJsonData["sfCode"] as? String ?? ""
        stateCode = prettyJsonData["State_Code"] as? String ?? ""
        divCode = prettyJsonData["divisionCode"] as? String ?? ""
        desig=prettyJsonData["desigCode"] as? String ?? ""
      //  eKey = String(format: "EK%@-%i", sfCode,Int(Date().timeIntervalSince1970))
    }
    
    func updateDisplay() {
        if UserSetup.shared.SF_type == 1 {
            self.vwHeadquartes.isHidden = true
            self.topHeightVwHeadquartersConstraint.constant = 0
            self.heightVwheadquartersConstraint.constant = 0
        }
        
        if UserSetup.shared.distributorBased == 0 {
            self.vwDistributors.isHidden = true
            self.topHeightVwDistributorsConstraints.constant = 0
            self.heightVwDistributorsConstraint.constant = 0
            
        }
    }
    
    func updateDistributor(distributors : [AnyObject],sfcode : String){
        let lists = self.allRetailerList.filter{$0.mapId == sfcode}
        
        
        print(lists)
        if !lists.isEmpty {
            return
        }
        
        print(distributors)
        for distributor in distributors {
            let name = String(format: "%@", distributor["name"] as! CVarArg)
            let id = String(format: "%@", distributor["id"] as! CVarArg)
            let townCode = String(format: "%@", distributor["town_code"] as! CVarArg)
            
            print(townCode)
            if !selectedList.isEmpty {
                let selectedRetailer = selectedList.filter{$0.id == id}
                
                if !selectedRetailer.isEmpty {
                    
                    print(selectedRetailer)
                    self.allRetailerList.append(RetailerList(id: selectedRetailer.first?.id ?? "",name: selectedRetailer.first?.name ?? "",townCode: selectedRetailer.first?.townCode ?? "", isSelected: true,routeName: selectedRetailer.first?.routeName ?? "", routeCode: selectedRetailer.first?.routeCode ?? "",hqCode: selectedRetailer.first?.hqCode ?? "",hqName: selectedRetailer.first?.hqName ?? "",distributorCode: selectedRetailer.first?.distributorCode ?? "",distributorName: selectedRetailer.first?.distributorName ?? "",orderList: selectedRetailer.first?.orderList ?? [],secOrderList: selectedRetailer.first?.secOrderList ?? [], params: selectedRetailer.first?.params ?? "", remarks: selectedRetailer.first?.remarks ?? "",remarksId: selectedRetailer.first?.remarksId ?? "",mapId: sfcode))
                }else{
                    self.allRetailerList.append(RetailerList(id: id,name: name,townCode: townCode, isSelected: false,mapId: sfcode))
                }
                
            }else {
                self.allRetailerList.append(RetailerList(id: id,name: name,townCode: townCode, isSelected: false,mapId: sfcode))
            }
            
           // print(distributor)
        }
    }
    
    func updateRetailer(retailers : [AnyObject],sfcode : String) {
        
        let lists = self.allRetailerList.filter{$0.mapId == sfcode}
        
        if !lists.isEmpty {
            return
        }
        
        for retailer in retailers {
            
            let name = String(format: "%@", retailer["name"] as! CVarArg)
            let id = String(format: "%@", retailer["id"] as! CVarArg)
            let townCode = String(format: "%@", retailer["town_code"] as! CVarArg)
            
            if !selectedList.isEmpty {
                let selectedRetailer = selectedList.filter{$0.id == id}
                
                if !selectedRetailer.isEmpty {
                    
                    print(selectedRetailer.first)
                    self.allRetailerList.append(RetailerList(id: selectedRetailer.first?.id ?? "",name: selectedRetailer.first?.name ?? "",townCode: selectedRetailer.first?.townCode ?? "", isSelected: true,routeName: selectedRetailer.first?.routeName ?? "", routeCode: selectedRetailer.first?.routeCode ?? "",hqCode: selectedRetailer.first?.hqCode ?? "",hqName: selectedRetailer.first?.hqName ?? "",distributorCode: selectedRetailer.first?.distributorCode ?? "",distributorName: selectedRetailer.first?.distributorName ?? "",orderList: selectedRetailer.first?.orderList ?? [],secOrderList: selectedRetailer.first?.secOrderList ?? [], params: selectedRetailer.first?.params ?? "", remarks: selectedRetailer.first?.remarks ?? "",remarksId: selectedRetailer.first?.remarksId ?? "",mapId: sfcode))
                }else{
                    self.allRetailerList.append(RetailerList(id: id,name: name,townCode: townCode, isSelected: false,mapId: sfcode))
                }
                
            }else {
                self.allRetailerList.append(RetailerList(id: id,name: name,townCode: townCode, isSelected: false,mapId: sfcode))
            }
            
            
        }
    }
    
    func updateRoutes(id : String) {
        if(LocalStoreage.string(forKey: "Distributors_Master_"+id)==nil){
            self.ShowLoading(Message: "       Sync Data Please wait...")
            GlobalFunc.FieldMasterSync(SFCode: id){ [self] in
                let DistData = self.LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                let RouteData: String=self.LocalStoreage.string(forKey: "Route_Master_"+id)!
                let RetailData: String=LocalStoreage.string(forKey: "Retail_Master_"+id)!
                if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                    self.lstDist = list;
                    print(list)
                    if self.isFromSecondary == false {
                        updateDistributor(distributors: list, sfcode: id)
                    }
                }
                if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                    self.lstRoutes = list
                }
                
                if let list = GlobalFunc.convertToDictionary(text: RetailData) as? [AnyObject] {
                    lstAllRetails = list
                    if self.isFromSecondary == true {
                        self.updateRetailer(retailers: list, sfcode: id)
                    }
                    
                }
                lblDistributor.text = "Select the Distributor"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.LoadingDismiss()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else {
            if let DistData = LocalStoreage.string(forKey: "Distributors_Master_" + id) {
                if let RouteData = LocalStoreage.string(forKey: "Route_Master_" + id) {
                    if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                        lstDist = list
                        print(list)
                        if self.isFromSecondary == false {
                            updateDistributor(distributors: list, sfcode: id)
                        }
                    }
                    
                    if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                        lstRoutes = list
                    }
                }
                
                if let lstRetailData = LocalStoreage.string(forKey: "Retail_Master_"+id),
                   let list = GlobalFunc.convertToDictionary(text:  lstRetailData) as? [AnyObject] {
                    lstAllRetails = list
                    if self.isFromSecondary == true {
                        self.updateRetailer(retailers: list, sfcode: id)
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        if self.selectedRoute == nil {
            Toast.show(message: "Please Select Route", controller: self)
            return
        }
        
        print(self.allRetailerList.count)
      
        let retailerLists = self.allRetailerList.filter{$0.isSelected}
        
        print(retailerLists)
        print(retailerLists.count)
        
        if self.retailerList.isEmpty && retailerLists.isEmpty{
            Toast.show(message: "No Retailer for this route", controller: self)
            return
        }
        
        if retailerLists.isEmpty {
            Toast.show(message: "Please select Order", controller: self)
            return
        }
        
//        for retailerList in retailerLists {
//            if retailerList.orderList.isEmpty && retailerList.remarks == nil {
//                Toast.show(message: "Please select Remarks or order for \(retailerList.name ?? "")", controller: self)
//                return
//            }
//        }
        
        if self.isFromSecondary == true {
            
            for retailerList in retailerLists {
                if retailerList.secOrderList.isEmpty && retailerList.remarks == nil {
                    Toast.show(message: "Please select Remarks or order for \(retailerList.name ?? "")", controller: self)
                    return
                }
            }
            
            saveSecondaryOrder1()
            // saveSecondaryOrder()
        }else {
            for retailerList in retailerLists {
                if retailerList.orderList.isEmpty && retailerList.remarks == nil {
                    Toast.show(message: "Please select Remarks or order for \(retailerList.name ?? "")", controller: self)
                    return
                }
            }
            
            savePrimaryOrder()
        }
        
        
    }
    
    func saveSecondaryOrder1(){
        let retailerLists = self.allRetailerList.filter{$0.isSelected}
        
        for retailerList in retailerLists {
            
            var productString = ""
            
            var stkcode = ""
            var stkName = ""
            
            for i in 0..<retailerList.secOrderList.count {
                
                print(i)
                
                stkcode = retailerList.secOrderList[i].distributorId ?? ""
                stkName = retailerList.secOrderList[i].distributorName ?? ""
                
                
                
                let qty = retailerList.secOrderList[i].product.unitCount * (Int(retailerList.secOrderList[i].product.sampleQty) ?? 0)
                var scheme : Int = 0
                var offerProductCode : String = ""
                var offerProductName:String = ""
                var freePCount = retailerList.secOrderList[i].product.productId
                var freePName = retailerList.secOrderList[i].product.productName
                let sampleQty = (Int(retailerList.secOrderList[i].product.sampleQty) ?? 0)
                let clQty = (Int(retailerList.secOrderList[i].product.clQty) ?? 0)
                let totalCount = retailerList.secOrderList[i].product.totalCount
                
                if UserSetup.shared.SchemeBased == 1 && UserSetup.shared.offerMode == 1 {
                    scheme = retailerList.secOrderList[i].product.scheme
                    offerProductCode = retailerList.secOrderList[i].product.offerProductCode
                    offerProductName = retailerList.secOrderList[i].product.offerProductName
                    freePCount = retailerList.secOrderList[i].product.offerProductCode
                    freePName = retailerList.secOrderList[i].product.productName
                }
                
                
                var competitorProductString = ""
                if !retailerList.secOrderList[i].product.competitorProduct.isEmpty {
                    
                    for i in 0..<retailerList.secOrderList[i].product.competitorProduct.count {
                        
                        let sampleQty = (Int(retailerList.secOrderList[i].product.competitorProduct[i].qty) ?? 0)
                        let competitorProductStr = "{\"Competitor_Name\":\"\(retailerList.secOrderList[i].product.competitorProduct[i].competitorName)\",\"Competitor_Product_Name\":\"\(retailerList.secOrderList[i].product.competitorProduct[i].competitorProductName)\",\"Prod_Qty\":\(sampleQty),\"Prod_Rate\":\(retailerList.secOrderList[i].product.competitorProduct[i].rate),\"Prod_Value\":\"\(retailerList.secOrderList[i].product.competitorProduct[i].value)\"},"
                        
                        competitorProductString = competitorProductString + competitorProductStr
                    }
                    
                    if competitorProductString.hasSuffix(","){
                        competitorProductString.removeLast()
                    }
                }
                
                let rxQty = (Int(retailerList.secOrderList[i].product.sampleQty) ?? 0)
                let productStr =   "{\"product_code\":\"\(retailerList.secOrderList[i].product.productId)\",\"product_Name\":\"\(retailerList.secOrderList[i].product.productName)\",\"Product_Rx_Qty\":\(qty),\"UnitId\":\"\(retailerList.secOrderList[i].product.unitId)\",\"UnitName\":\"\(retailerList.secOrderList[i].product.unitName)\",\"rx_Conqty\":\(rxQty),\"Product_Rx_NQty\":0,\"Product_Sample_Qty\":\"\(totalCount)\",\"vanSalesOrder\":0,\"sale_erp_code\":\"\(retailerList.secOrderList[i].product.saleErpCode)\",\"rateedited\":0,\"retailer_price\":\(retailerList.secOrderList[i].product.retailerPrice),\"net_weight\":\(retailerList.secOrderList[i].product.newWt),\"free\":\(retailerList.secOrderList[i].product.freeCount),\"FreePQty\":\(retailerList.secOrderList[i].product.offerAvailableCount),\"FreeP_Code\":\"\(freePCount)\",\"Fname\":\"\(freePName)\",\"discount\":\(retailerList.secOrderList[i].product.disCountPer),\"discount_price\":\(retailerList.secOrderList[i].product.disCountAmount),\"tax\":\(retailerList.secOrderList[i].product.taxper),\"tax_price\":\(retailerList.secOrderList[i].product.taxAmount),\"Rate\":\(retailerList.secOrderList[i].product.rate),\"Mfg_Date\":\"\",\"cb_qty\":\(clQty),\"RcpaId\":0,\"Ccb_qty\":0,\"PromoVal\":0,\"rx_remarks\":\"\(retailerList.secOrderList[i].product.remarks)\",\"rx_remarks_Id\":\"\(retailerList.secOrderList[i].product.remarksId)\",\"OrdConv\":\(retailerList.secOrderList[i].product.unitCount),\"selectedScheme\":\(scheme),\"selectedOffProCode\":\"\(offerProductCode)\",\"selectedOffProName\":\"\(offerProductName)\",\"selectedOffProUnit\":\"\(retailerList.secOrderList[i].product.unitCount)\",\"CompetitorDet\":[\(competitorProductString)],\"f_key\":{\"Activity_MSL_Code\":\"Activity_Doctor_Report\"}},"
                
                productString = productString + productStr
            }
            
            
            
            print(productString)
            if productString.hasSuffix(","){
                productString.removeLast()
            }
            
            let workType = (String(format: "%@", self.selectedWorktype["id"] as? CVarArg ?? ""))
            let date = (selectedDate["name"] as? String ?? "") + " 00:00:00"
            let routeCode = retailerList.routeCode ?? ""
            let routeName = retailerList.routeName ?? ""
            let hqCode = retailerList.hqCode ?? ""
            let hqName = retailerList.hqName ?? ""
            
            let currentDate = GlobalFunc.getCurrDateAsString()
            
            eKey = String(format: "EK%@-%i", sfCode,Int((Date().timeIntervalSince1970)+Double(Int.random(in: 0..<500))))
            
            let dataSF = hqCode == "" ? self.sfCode : hqCode
            
            let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"\'\(workType)\'\",\"Town_code\":\"\'\(routeCode)\'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'\(date)\'\",\"workTypFlag_Missed\":\"\(selectedWorktype["FWFlg"] as? String ?? "")\",\"mydayplan\":1,\"mypln_town\":\"\'\(routeName)\'\",\"mypln_town_id\":\"\'\(routeCode)\'\",\"hq_code\":\"\'\(hqCode)\'\",\"hq_name\":\"\'\(hqName)\'\",\"missed_date_entry\":1,\"Daywise_Remarks\":\"\(retailerList.remarks ?? "")\",\"eKey\":\"\(self.eKey)\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"DataSF\":\"\'\(dataSF)\'\"}},{\"Activity_Doctor_Report\":{\"Doctor_POB\":0,\"Worked_With\":\"\'\'\",\"Doc_Meet_Time\":\"\'\(date)\'\",\"modified_time\":\"\'\(currentDate)\'\",\"net_weight_value\":\"1\",\"stockist_code\":\"\'\(stkcode)\'\",\"stockist_name\":\"\'\(stkName)\'\",\"superstockistid\":\"\'\'\",\"Discountpercent\":0,\"CheckinTime\":\"\(currentDate)\",\"CheckoutTime\":\"\(currentDate)\",\"location\":\"\'1\'\",\"geoaddress\":\"\",\"retLatitude\":\"\",\"retLongitude\":\"\",\"PhoneOrderTypes\":\"0\",\"Order_Stk\":\"\'\'\",\"Order_No\":\"\'\'\",\"rootTarget\":\"\",\"orderValue\":\"\(retailerList.secOrderList.first?.subtotal ?? "")\",\"rateMode\":\"free\",\"discount_price\":0,\"doctor_code\":\"\'\(retailerList.id)\'\",\"doctor_name\":\"\'\(retailerList.name ?? "")\'\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"}}},{\"Activity_Sample_Report\":[\(productString)]},{\"Trans_Order_Details\":[]},{\"Activity_Input_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]}]"
            
            
           // retailerList.params = jsonString
            if let index = self.allRetailerList.firstIndex(where: { (productInfo) -> Bool in
                return retailerList.id == productInfo.id
            }){
               // self.allRetailerList[index] = (RetailerList(id: retailerList.id,name: retailerList.name,townCode: retailerList.townCode, isSelected: retailerList.isSelected,orderList: retailerList.orderList,params: jsonString,mapId: retailerList.mapId))
                self.allRetailerList[index] = (RetailerList(id: retailerList.id,name: retailerList.name,townCode: retailerList.townCode, isSelected: retailerList.isSelected,routeName: retailerList.routeName,routeCode: retailerList.routeCode,hqCode: retailerList.hqCode,hqName: retailerList.hqName,distributorCode: retailerList.distributorCode,distributorName: retailerList.distributorName,orderList: retailerList.orderList,secOrderList: retailerList.secOrderList,params: jsonString,remarks: retailerList.remarks,remarksId: retailerList.remarksId,mapId: retailerList.mapId))
            }
            
            
            
        }
        
        print(retailerLists)
        
        missedDateSubmit(self.allRetailerList.filter{$0.isSelected})
    }
    
    func saveSecondaryOrder() {
        let retailerLists = self.allRetailerList.filter{$0.isSelected}
        
        
        for retailerList in retailerLists {
            
            var productString = ""
            
            var stkcode = ""
            var stkName = ""
            
            for i in 0..<retailerList.orderList.count {
                
                print(i)
                let item : [String:Any] = retailerList.orderList[i].item as! [String:Any]
                
                let id=String(format: "%@", item["id"] as! CVarArg)
                let uom=String(format: "%@", item["UOM"] as! CVarArg)
                let uomName=String(format: "%@", item["UOMNm"] as! String)
                let uomConv=String(format: "%@", item["UOMConv"] as! CVarArg)
                let netWt=String(format: "%@", item["NetWt"] as! CVarArg)
                let netVal=(String(format: "%.2f", item["NetVal"] as! Double))
                let Qty=String(format: "%@", item["Qty"] as? String ?? "")
                let saleQty=String(format: "%.0f", item["SalQty"] as! Double)
                let offQty=(String(format: "%.2f", item["OffQty"] as! Int))
                let fq=String(format: "%@", item["FQ"] as? Int ?? "")
                let offProd=String(format: "%@", item["OffProd"] as? CVarArg ?? "")
                let rate=(String(format: "%.2f", item["Rate"] as! Double))
                let offProdNm=String(format: "%@", item["OffProdNm"] as? CVarArg ?? "")
                let scheme=String(format: "%@", item["Scheme"] as? Int ?? "")
                let disc=String(format: "%@", item["Disc"] as? CVarArg ?? "")
                let disVal=String(format: "%@", item["DisVal"] as? CVarArg ?? "")
                
                stkcode = retailerList.orderList[i].distributorId ?? ""
                stkName = retailerList.orderList[i].distributorName ?? ""
                
                let productStr = "{\"product_code\":\"\(id)\",\"product_Name\":\"\(retailerList.orderList[i].productName ?? "")\",\"Product_Rx_Qty\":\(saleQty),\"UnitId\":\"\(uom)\",\"UnitName\":\"\(uomName)\",\"rx_Conqty\":\(Qty),\"Product_Rx_NQty\":\"0\",\"Product_Sample_Qty\":\"\(netVal)\",\"vanSalesOrder\":0,\"net_weight\":\"0.0\",\"free\":\"\(offQty)\",\"FreePQty\":\"\(fq)\",\"FreeP_Code\":\"\(offProd)\",\"Fname\":\"\(offProdNm)\",\"discount\":\"\(disc)\",\"discount_price\":\"\(disVal)\",\"tax\":\"0.0\",\"tax_price\":\"0.0\",\"Rate\":\"\(rate)\",\"Mfg_Date\":\"\",\"cb_qty\":\"0\",\"RcpaId\":\"\",\"Ccb_qty\":0,\"PromoVal\":0,\"rx_remarks\":\"\",\"rx_remarks_Id\":\"\",\"OrdConv\":\"\(uomConv)\",\"selectedScheme\":\"\(scheme)\",\"selectedOffProCode\":\"\(uom)\",\"selectedOffProName\":\"\(uomName)\",\"selectedOffProUnit\":\"1\",\"f_key\":{\"Activity_MSL_Code\":\"Activity_Doctor_Report\"}},"
                
                productString = productString + productStr
            }
            
            print(productString)
            if productString.hasSuffix(","){
                productString.removeLast()
            }
            
            let workType = (String(format: "%@", self.selectedWorktype["id"] as? CVarArg ?? ""))
            let date = (selectedDate["name"] as? String ?? "") + " 00:00:00"
            let routeCode = retailerList.routeCode ?? ""
            let routeName = retailerList.routeName ?? ""
            let hqCode = retailerList.hqCode ?? ""
            let hqName = retailerList.hqName ?? ""
            
            let currentDate = GlobalFunc.getCurrDateAsString()
            
            eKey = String(format: "EK%@-%i", sfCode,Int((Date().timeIntervalSince1970)+Double(Int.random(in: 0..<500))))
            
            let dataSF = hqCode == "" ? self.sfCode : hqCode
            
            let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"\'\(workType)\'\",\"Town_code\":\"\'\(routeCode)\'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'\(date)\'\",\"workTypFlag_Missed\":\"\(selectedWorktype["FWFlg"] as? String ?? "")\",\"mydayplan\":1,\"mypln_town\":\"\'\(routeName)\'\",\"mypln_town_id\":\"\'\(routeCode)\'\",\"hq_code\":\"\'\(hqCode)\'\",\"hq_name\":\"\'\(hqName)\'\",\"missed_date_entry\":1,\"Daywise_Remarks\":\"\(retailerList.remarks ?? "")\",\"eKey\":\"\(self.eKey)\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"DataSF\":\"\'\(dataSF)\'\"}},{\"Activity_Doctor_Report\":{\"Doctor_POB\":0,\"Worked_With\":\"\'\'\",\"Doc_Meet_Time\":\"\'\(date)\'\",\"modified_time\":\"\'\(currentDate)\'\",\"net_weight_value\":\"1\",\"stockist_code\":\"\'\(stkcode)\'\",\"stockist_name\":\"\'\(stkName)\'\",\"superstockistid\":\"\'\'\",\"Discountpercent\":0,\"CheckinTime\":\"\(currentDate)\",\"CheckoutTime\":\"\(currentDate)\",\"location\":\"\'1\'\",\"geoaddress\":\"\",\"retLatitude\":\"\",\"retLongitude\":\"\",\"PhoneOrderTypes\":\"0\",\"Order_Stk\":\"\'\'\",\"Order_No\":\"\'\'\",\"rootTarget\":\"\",\"orderValue\":\"\(retailerList.orderList.first?.subtotal ?? "")\",\"rateMode\":\"free\",\"discount_price\":0,\"doctor_code\":\"\'\(retailerList.id)\'\",\"doctor_name\":\"\'\(retailerList.name ?? "")\'\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"}}},{\"Activity_Sample_Report\":[\(productString)]},{\"Trans_Order_Details\":[]},{\"Activity_Input_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]}]"
            
            
            
            
           // retailerList.params = jsonString
            if let index = self.allRetailerList.firstIndex(where: { (productInfo) -> Bool in
                return retailerList.id == productInfo.id
            }){
                self.allRetailerList[index] = (RetailerList(id: retailerList.id,name: retailerList.name,townCode: retailerList.townCode, isSelected: retailerList.isSelected,orderList: retailerList.orderList,params: jsonString,mapId: retailerList.mapId))
            }
            
            
            
        }
        print(retailerLists)
        
        missedDateSubmit(self.allRetailerList.filter{$0.isSelected})
    
        
        
        
    }
    
    func savePrimaryOrder() {
        let retailerLists = self.allRetailerList.filter{$0.isSelected}
        
        for retailerList in retailerLists {
            
            var productString = ""
            
            var stkcode = ""
            var stkName = ""
            
            for i in 0..<retailerList.orderList.count {
                
                let item : [String:Any] = retailerList.orderList[i].item as! [String:Any]
                let id=String(format: "%@", item["id"] as! CVarArg)
                let uom=String(format: "%@", item["UOM"] as! String)
                let uomName=String(format: "%@", item["UOMNm"] as! String)
                let uomConv=String(format: "%@", item["UOMConv"] as! String)
                let netWt=String(format: "%@", item["NetWt"] as! CVarArg)
                let netVal=(String(format: "%.2f", item["NetVal"] as! Double))
                let Qty=String(format: "%@", item["Qty"] as? String ?? "")
                let saleQty=String(format: "%.0f", item["SalQty"] as! Double)
                let offQty=(String(format: "%.2f", item["OffQty"] as! Int))
               // let fq=String(format: "%@", item["FQ"] as? Int ?? 0)
                let offProd=String(format: "%@", item["OffProd"] as? String ?? "")
                let rate=(String(format: "%.2f", item["Rate"] as! Double))
                let offProdNm=String(format: "%@", item["OffProdNm"] as? String ?? "")
                let scheme=(String(format: "%.0f", item["Scheme"] as! Double))
                let disc=String(format: "%@", item["Disc"] as? String ?? "")
                let disVal=String(format: "%@", item["DisVal"] as? String ?? "")
                
                stkcode = retailerList.orderList[i].distributorId ?? ""
                stkName = retailerList.orderList[i].distributorName ?? ""
                
              //  let productStr = "{\"product_code\":\"\(id)\",\"product_Name\":\"\(retailerList.orderList[i].productName ?? "")\",\"Product_Rx_Qty\":\(saleQty),\"UnitId\":\"\(uom)\",\"UnitName\":\"\(uomName)\",\"rx_Conqty\":\(Qty),\"Product_Rx_NQty\":\"0\",\"Product_Sample_Qty\":\"\(netVal)\",\"vanSalesOrder\":0,\"net_weight\":\"0.0\",\"free\":\"\(offQty)\",\"FreePQty\":\"\(fq)\",\"FreeP_Code\":\"\(offProd)\",\"Fname\":\"\(offProdNm)\",\"discount\":\"\(disc)\",\"discount_price\":\"\(disVal)\",\"tax\":\"0.0\",\"tax_price\":\"0.0\",\"Rate\":\"\(rate)\",\"Mfg_Date\":\"\",\"cb_qty\":\"0\",\"RcpaId\":\"\",\"Ccb_qty\":0,\"PromoVal\":0,\"rx_remarks\":\"\",\"rx_remarks_Id\":\"\",\"OrdConv\":\"\(uomConv)\",\"selectedScheme\":\"\(scheme)\",\"selectedOffProCode\":\"\(uom)\",\"selectedOffProName\":\"\(uomName)\",\"selectedOffProUnit\":\"1\",\"f_key\":{\"Activity_MSL_Code\":\"Activity_Doctor_Report\"}},"
                
                
                let productStr = "{\"product_code\":\"\(id)\",\"product_Name\":\"\(retailerList.orderList[i].productName ?? "")\",\"rx_Conqty\":\"\(Qty)\",\"Qty\":\"\(saleQty)\",\"PQty\":0,\"cb_qty\":0,\"free\":\"\(offQty)\",\"Pfree\":0,\"Rate\":\"\(rate)\",\"PieseRate\":\"\(rate)\",\"discount\":\"\(disc)\",\"FreeP_Code\":\"\(offProd)\",\"Fname\":\"\(offProdNm)\",\"discount_price\":\"\(disVal)\",\"tax\":\"0.0\",\"tax_price\":\"0.0\",\"OrdConv\":\"\(uomConv)\",\"product_unit_name\":\"\(uomName)\",\"selectedScheme\":\"\(scheme)\",\"selectedOffProCode\":\"\(uom)\",\"selectedOffProName\":\"\(uomName)\",\"selectedOffProUnit\":\"\(uomConv)\",\"f_key\":{\"activity_stockist_code\":\"Activity_Stockist_Report\"}},"
                
                
                
                
                productString = productString + productStr
            }
            
            print(productString)
            if productString.hasSuffix(","){
                productString.removeLast()
            }
            
            let workType = (String(format: "%@", self.selectedWorktype["id"] as? CVarArg ?? ""))
            let date = (selectedDate["name"] as? String ?? "") + " 00:00:00"
            let routeCode = retailerList.routeCode ?? ""
            let routeName = retailerList.routeName ?? ""
            let hqCode = retailerList.hqCode ?? ""
            let hqName = retailerList.hqName ?? ""
            
            let dataSF = hqCode == "" ? self.sfCode : hqCode
            
            let currentDate = GlobalFunc.getCurrDateAsString()
            
            eKey = String(format: "EK%@-%i", sfCode,Int((Date().timeIntervalSince1970)+Double(Int.random(in: 0..<500))))
            
            let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"'\(workType)'\",\"Town_code\":\"'\(routeCode)'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'\(date)\'\",\"workTypFlag_Missed\":\"\(selectedWorktype["FWFlg"] as? String ?? "")\",\"mydayplan\":1,\"mypln_town\":\"\'\(routeName)\'\",\"mypln_town_id\":\"\'\(routeCode)\'\",\"hq_code\":\"\'\(hqCode)\'\",\"hq_name\":\"\'\(hqName)\'\",\"missed_date_entry\":1,\"Daywise_Remarks\":\"\(retailerList.remarks ?? "")\",\"eKey\":\"\(self.eKey)\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"DataSF\":\"\'\(dataSF)\'\"}},{\"Activity_Stockist_Report\":{\"Worked_With\":\"\'\'\",\"Stk_Meet_Time\":\"\'\(date)\'\",\"modified_time\":\"\'\(currentDate)\'\",\"net_weight_value\":\"0.0\",\"stockist_code\":\"\'\(retailerList.id)\'\",\"stockist_name\":\"\'\(retailerList.name ?? "")\'\",\"superstockistid\":\"\'\'\",\"Discountpercent\":0,\"CheckinTime\":\"\(currentDate)\",\"CheckoutTime\":\"\(currentDate)\",\"location\":\"\'1.5\'\",\"geoaddress\":\"\",\"Super_Stck_code\":\"\'\(stkcode)\'\",\"Stockist_POB\":\"0\",\"date_of_intrument\":\"\",\"intrumenttype\":\"\",\"orderValue\":\"\(retailerList.orderList.first?.subtotal ?? "")\",\"Aob\":0,\"PhoneOrderTypes\":\"0\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"}}},{\"Activity_Stk_POB_Report\":[\(productString)]},{\"Activity_Stk_Sample_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]}]"
            
            
            
           // retailerList.params = jsonString
            if let index = self.allRetailerList.firstIndex(where: { (productInfo) -> Bool in
                return retailerList.id == productInfo.id
            }){
               // self.allRetailerList[index] = (RetailerList(id: retailerList.id,name: retailerList.name,townCode: retailerList.townCode, isSelected: retailerList.isSelected,orderList: retailerList.orderList,params: jsonString,mapId: retailerList.mapId))
                self.allRetailerList[index] = (RetailerList(id: retailerList.id,name: retailerList.name,townCode: retailerList.townCode, isSelected: retailerList.isSelected,routeName: retailerList.routeName,routeCode: retailerList.routeCode,hqCode: retailerList.hqCode,hqName: retailerList.hqName,distributorCode: retailerList.distributorCode,distributorName: retailerList.distributorName,orderList: retailerList.orderList,secOrderList: retailerList.secOrderList,params: jsonString,remarks: retailerList.remarks,remarksId: retailerList.remarksId,mapId: retailerList.mapId))
            }
            
            
            
        }
        
        
        missedDateSubmit(self.allRetailerList.filter{$0.isSelected})
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retailerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MissedDateOrderSelectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MissedDateOrderSelectionTableViewCell
       
        cell.lblName.text = retailerList[indexPath.row].name
        cell.btnSelect.isSelected = retailerList[indexPath.row].isSelected
        cell.btnOrder.addTarget(self, action: #selector(orderAction(_:)), for: .touchUpInside)
        cell.btnSelect.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
        cell.heightVwRemarksConstrainst.constant = retailerList[indexPath.row].isSelected == true ? 125 : 0
        cell.btnOrder.isHidden = retailerList[indexPath.row].isSelected == true ? false : true
        
        if isFromSecondary == true {
            if retailerList[indexPath.row].secOrderList.count != 0 {
                cell.btnOrder.setTitle("Edit", for: .normal)
            }else {
                cell.btnOrder.setTitle("Order", for: .normal)
            }
        }else{
            if retailerList[indexPath.row].orderList.count != 0 {
                cell.btnOrder.setTitle("Edit", for: .normal)
            }else {
                cell.btnOrder.setTitle("Order", for: .normal)
            }
        }
        
        cell.btnTemplates.addTarget(self, action: #selector(remarksTemplatesAction(_:)), for: .touchUpInside)
        if self.retailerList[indexPath.row].remarks != nil{
            cell.txtRemarks.textColor = .black
            cell.txtRemarks.text = self.retailerList[indexPath.row].remarks
        }else {
            cell.txtRemarks.textColor = .lightGray
            cell.txtRemarks.text = "Enter the remarks"
        }
        cell.txtRemarks.tag = indexPath.row
        cell.txtRemarks.delegate = self
        return cell
    }
    
    
    @objc func remarksTemplatesAction(_ sender : UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableViewOrderList)
        guard let indexPath = self.tableViewOrderList.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        
        let remarksVC = ItemViewController(items: lstRmksTmpl, configure: { (Cell : SingleSelectionTableViewCell, remark) in
            Cell.textLabel?.text = remark["name"] as? String
        })
        remarksVC.title = "Select the Reason"
        remarksVC.didSelect = { selectedRmk in
            print(selectedRmk)
            
            self.retailerList[indexPath.row].remarks = selectedRmk["name"] as? String ?? ""
            self.retailerList[indexPath.row].remarksId = selectedRmk["id"] as? String ?? ""
            
            
            if let index = self.allRetailerList.firstIndex(where: { (productInfo) -> Bool in
                return self.retailerList[indexPath.row].id == productInfo.id
            }){
                self.allRetailerList[index] = self.retailerList[indexPath.row]
            }
            
            self.tableViewOrderList.reloadRows(at: [indexPath], with: .automatic)
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(remarksVC, animated: true)
        
    }
    
    @objc func selectAction(_ sender : UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableViewOrderList)
        guard let indexPath = self.tableViewOrderList.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        
        retailerList[indexPath.row].isSelected = !retailerList[indexPath.row].isSelected
        
        retailerList[indexPath.row].routeName = selectedRoute?["name"] as? String ?? ""
        
        retailerList[indexPath.row].routeCode = selectedRoute?["id"] as? String ?? ""
        
        retailerList[indexPath.row].hqName = selectedHeadquarter?["name"] as? String ?? ""
        retailerList[indexPath.row].hqCode = selectedHeadquarter?["id"] as? String ?? ""
        
        
        self.tableViewOrderList.reloadRows(at: [indexPath], with: .automatic)
        self.tableViewOrderList.reloadData()
        
        if let index = self.allRetailerList.firstIndex(where: { (productInfo) -> Bool in
            return self.retailerList[indexPath.row].id == productInfo.id
        }){
            self.allRetailerList[index] = self.retailerList[indexPath.row]
        }
        
        self.tableViewOrderList.beginUpdates()
        self.tableViewOrderList.setNeedsDisplay()
        self.tableViewOrderList.endUpdates()
    }
    
    @objc func orderAction(_ sender : UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableViewOrderList)
        guard let indexPath = self.tableViewOrderList.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        
        if isFromSecondary == true {

//            let secondaryOrder = UIStoryboard.secondaryOrder
//            secondaryOrder.isFromMissedEntry = true
//            secondaryOrder.selectedProducts = self.retailerList[indexPath.row].orderList
//            secondaryOrder.selectedSf = self.retailerList[indexPath.row].mapId
////            secondaryOrder.missedDateSubmit = { paramString in
////                print(paramString)
////                self.tableViewOrderList.reloadRows(at: [indexPath], with: .automatic)
////            }
//            secondaryOrder.missedDateEditData = { products in
//                
//                self.retailerList[indexPath.row].orderList = products
//                
//                if let index = self.allRetailerList.firstIndex(where: { (productInfo) -> Bool in
//                    return self.retailerList[indexPath.row].id == productInfo.id
//                }){
//                    self.allRetailerList[index] = self.retailerList[indexPath.row]
//                }
//                
//                self.tableViewOrderList.reloadRows(at: [indexPath], with: .automatic)
//            }
//            self.navigationController?.pushViewController(secondaryOrder, animated: true)
            
            let secondaryOrderNew = UIStoryboard.SecondaryOrderNew
            secondaryOrderNew.isFromMissedEntry = true
            secondaryOrderNew.selectedProductsforMissed = self.retailerList[indexPath.row].secOrderList
            secondaryOrderNew.selectedSf = self.retailerList[indexPath.row].mapId
            VisitData.shared.CustID = retailerList[indexPath.row].id
            print(retailerList[indexPath.row])
            secondaryOrderNew.missedDateEditData = { products in
                
                self.retailerList[indexPath.row].secOrderList = products
                
                if let index = self.allRetailerList.firstIndex(where: { (productInfo) -> Bool in
                    return self.retailerList[indexPath.row].id == productInfo.id
                }){
                    self.allRetailerList[index] = self.retailerList[indexPath.row]
                }
                
                self.tableViewOrderList.reloadRows(at: [indexPath], with: .automatic)
            }
            self.navigationController?.pushViewController(secondaryOrderNew, animated: true)
            
        }else {

            
            let primaryOrder = UIStoryboard.primaryOrder
            primaryOrder.isFromMissedEntry = true
            primaryOrder.selectedProducts = self.retailerList[indexPath.row].orderList
            primaryOrder.missedDateEditData = { paramString in
                print(paramString)
                self.retailerList[indexPath.row].orderList = paramString
                
                if let index = self.allRetailerList.firstIndex(where: { (productInfo) -> Bool in
                    return self.retailerList[indexPath.row].id == productInfo.id
                }){
                    self.allRetailerList[index] = self.retailerList[indexPath.row]
                }
                
                self.tableViewOrderList.reloadRows(at: [indexPath], with: .automatic)
            }
            self.navigationController?.pushViewController(primaryOrder, animated: true)
        }
     
    }
    
    @objc private func headquarterAction() {
        
        
        let headquarterVC = ItemViewController(items: lstHQs, configure: { (Cell : SingleSelectionTableViewCell, headquarter) in
            Cell.textLabel?.text = headquarter["name"] as? String
        })
        headquarterVC.title = "Select the Headquarter"
        headquarterVC.didSelect = { selectedHeadquarter in
            print(selectedHeadquarter)
            self.selectedHeadquarter = selectedHeadquarter
            self.updateRoutes(id: selectedHeadquarter["id"] as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(headquarterVC, animated: true)
    }
    
    @objc private func distributorAction() {
        let distributorVC = ItemViewController(items: lstDist, configure: { (Cell : SingleSelectionTableViewCell, distributor) in
            Cell.textLabel?.text = distributor["name"] as? String
        })
        distributorVC.title = "Select the \(UserSetup.shared.StkCap)"
        distributorVC.didSelect = { selectedDistributor in
            print(selectedDistributor)
            self.selectedDistributor = selectedDistributor
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(distributorVC, animated: true)
    }
    
    @objc private func routeAction() {
        let routeVC = ItemViewController(items: lstRoutes, configure: { (Cell : SingleSelectionTableViewCell, route) in
            Cell.textLabel?.text = route["name"] as? String
        })
        routeVC.title = "Select the \(UserSetup.shared.StkRoute)"
        routeVC.didSelect = { selectedRoute in
            print(selectedRoute)
            self.selectedRoute = selectedRoute
            self.navigationController?.popViewController(animated: true)
            
            if self.isFromSecondary == true {
                self.retailerList = self.allRetailerList.filter{$0.townCode == "\(self.selectedRoute["id"] as? String ?? "")"}
            }
            
            if self.isFromSecondary == false {
                if UserSetup.shared.SF_type != 1{
                    self.retailerList = self.allRetailerList.filter{$0.mapId == self.selectedHeadquarter["id"] as? String ?? ""}
                }else {
                    self.retailerList = self.allRetailerList
                }
            }
            self.tableViewOrderList.reloadData()
        }
        self.navigationController?.pushViewController(routeVC, animated: true)
    }
    
    @objc private func backVC() {
        let alert = UIAlertController(title: "Confirm Exit", message: "Do you want to Close?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
        
    }
}

extension MissedDateRouteSelection: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter the remarks"
            textView.textColor = UIColor.lightGray
        }else{
            self.retailerList[textView.tag].remarks = textView.text
            
            
            if let index = self.allRetailerList.firstIndex(where: { (productInfo) -> Bool in
                return self.retailerList[textView.tag].id == productInfo.id
            }){
                self.allRetailerList[index] = self.retailerList[textView.tag]
            }
        }
    }
}

class MissedDateOrderSelectionTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnOrder: UIButton!
    
    
    @IBOutlet weak var btnTemplates: UIButton!
    @IBOutlet weak var txtRemarks: UITextView!
    
    @IBOutlet weak var heightVwRemarksConstrainst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


struct SecondaryOrderList {
    
    var headquarterId : String!
    var distributorId : String!
    var routeId : String!
    
    var params : String!
}


struct code : Codable {
    var string : String!
}

struct RetailerList {
    
    var id : String
    var name : String!
    var townCode : String!
    var isSelected : Bool!
   // var retailer : [String:Any]!
    
    var routeName : String!
    var routeCode : String!
    var hqCode : String!
    var hqName : String!
    var distributorCode : String!
    var distributorName : String!
    
    var orderList = [SecondaryOrderSelectedList]()
    var secOrderList = [SecondaryOrderNewSelectedList]()
    var params : String!
    var remarks : String!
    var remarksId : String!
    
    var mapId : String!
}






extension UIStoryboard {
    
    static var adminForms: UIStoryboard {
        return UIStoryboard(name: "AdminForms", bundle: nil)
    }
    
    static var main : UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    
    static var secondaryOrder:SecondaryOrder {
        guard let secondaryOrder = UIStoryboard.main.instantiateViewController(withIdentifier: "sbSecondaryOrder") as? SecondaryOrder else {
            fatalError("SecondaryOrder couldn't be found in Storyboard file")
        }
        return secondaryOrder
    }
    
    static var SecondaryOrderNew:SecondaryOrderNew {
        guard let secondaryOrderNew = UIStoryboard.main.instantiateViewController(withIdentifier: "sbSecondaryOrderNew") as? SecondaryOrderNew else {
            fatalError("SecondaryOrderNew couldn't be found in Storyboard file")
        }
        return secondaryOrderNew
    }
    
    static var primaryOrder: PrimaryOrder {
        guard let primaryOrder = UIStoryboard.main.instantiateViewController(withIdentifier: "sbPrimaryOrder") as? PrimaryOrder else {
            fatalError("primaryOrder couldn't be found in Storyboard file")
        }
        return primaryOrder
    }
}
