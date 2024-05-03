//
//  SuperStockistOrderList.swift
//  SAN SALES
//
//  Created by Naga Prasath on 05/03/24.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation


class SuperStockistOrderList : IViewController , UITableViewDelegate, UITableViewDataSource ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var img_back: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    
    
    @IBOutlet weak var lblTotalRate: UILabel!
    @IBOutlet weak var lblTotalItems: UILabel!
    
    
    @IBOutlet weak var lblStockistName: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var lblPriceItems: UILabel!
    @IBOutlet weak var lblPriceAmount: UILabel!
    
    
    @IBOutlet weak var lblTotalQty: UILabel!
    @IBOutlet weak var lblTotalPayment: UILabel!
    
    @IBOutlet weak var lblFinalItems: UILabel!
    @IBOutlet weak var lblFinalRate: UILabel!
    
    @IBOutlet weak var lblProceed: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectedListTableView: UITableView!
    @IBOutlet weak var freeQtyTableView: UITableView!
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectedTableViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var freeQtyTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vwSubmit: UIView!
    
    
    let LocalStoreage = UserDefaults.standard
    var selectedBrand = ""
    var SFCode: String = "" , StateCode = ""
    var DataSF: String = ""
    var DivCode: String = ""
    var Desig: String = ""
    var eKey: String = ""
    
    
    var lstBrands: [AnyObject] = []
    var lstAllProducts : [AnyObject] = []
    var lstProducts : [AnyObject] = []
    var lstAllUnits : [AnyObject] = []
    var lstUnits : [AnyObject] = []
    var lstProductTax : [AnyObject] = []
    var lstRandomNumbers : [AnyObject] = []
    var lstProductsRates : [AnyObject] = []
    var lstStockistSchemes : [AnyObject] = []
    
    var products = [ProductList]()
    var selectedProducts = [ProductList]()
    var freeProducts = [ProductList]()
    var allProducts = [ProductList]()
    
    var ProdImages:[String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwSubmit.isHidden = true
        freeQtyTableViewHeightConstraint.constant = 0
        loadViewIfNeeded()
        
        getUserDetails()
        
        self.lblStockistName.text = VisitData.shared.CustName
        self.lblName.text = VisitData.shared.CustName
        
        self.lblDate.text = Date().toString(format: "dd-MMM-yyyy")
        
        img_back.addTarget(target: self, action: #selector(backVC))
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        
//        selectedListTableView.estimatedRowHeight = UITableView.automaticDimension
//        selectedListTableView.rowHeight = UITableView.automaticDimension
        
        let lstCatData: String=LocalStoreage.string(forKey: "Brand_Master")!
        let lstProdData: String = LocalStoreage.string(forKey: "Products_Master")!
        let lstUnitData: String = LocalStoreage.string(forKey: "UnitConversion")!
        let lstRandomNumberData: String = LocalStoreage.string(forKey: "Random_Number")!
        let lstProductRateData : String = LocalStoreage.string(forKey: "ProductsRates_Master")!
        let lstProductTaxData : String = LocalStoreage.string(forKey: "ProductTax_Master")!
        
        let lstStockistSchemeData : String = LocalStoreage.string(forKey: "Stockist_Schemes")!
        
        if let list = GlobalFunc.convertToDictionary(text: lstCatData) as? [AnyObject] {
            lstBrands = list
        }
        if let list = GlobalFunc.convertToDictionary(text: lstUnitData) as? [AnyObject] {
            lstAllUnits = list
        }
        if let list = GlobalFunc.convertToDictionary(text: lstProductRateData) as? [AnyObject]{
            lstProductsRates = list
        }
        
        if let list = GlobalFunc.convertToDictionary(text: lstProductTaxData) as? [AnyObject] {
            lstProductTax = list
        }
        if let list = GlobalFunc.convertToDictionary(text: lstStockistSchemeData) as? [AnyObject] {
            lstStockistSchemes = list
        }
        if let list = GlobalFunc.convertToDictionary(text: lstProdData) as? [AnyObject] {
            lstAllProducts = list
            
            self.updateProduct(products: list)
        }
        
        if lstBrands.count > 0 {
            let item: [String: Any]=lstBrands[0] as! [String : Any]
            selectedBrand=String(format: "%@", item["id"] as! CVarArg)
            
            products = allProducts.filter{$0.cateId == selectedBrand}
        }
        if let list = GlobalFunc.convertToDictionary(text: lstRandomNumberData) as? [AnyObject]{
            lstRandomNumbers = list
        }
        print(lstStockistSchemes)
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
    
    func updateProduct( products: [AnyObject]) {
        
        for product in products {
            
            let productName = String(format: "%@", product["name"] as! CVarArg)
            let productId = String(format: "%@", product["id"] as! CVarArg)
            let cateId = String(format: "%@", product["cateid"] as! CVarArg)
            
            let Units = lstAllUnits.filter({(product) in
                let ProdId = String(format: "%@", product["Product_Code"] as! CVarArg)
                return Bool(ProdId == productId)
            })
            
            var unitName = ""
            var unitId = 0
            if Units.count > 0 {
                
                unitName = String(format: "%@", Units.first!["name"] as! CVarArg)
                
                let conQty = String(format: "%@", Units.first!["ConQty"] as! CVarArg)
                unitId = Int(conQty) ?? 0
            }
            
            let RateItems: [AnyObject] = lstProductsRates.filter ({ (Rate) in
                if Rate["Product_Detail_Code"] as! String == productId {
                    return true
                }
                return false
            })
            
            var rate : Double = 0
            
            if(RateItems.count>0){
                rate = (RateItems.first!["SS_Base_Rate"] as! NSString).doubleValue
            }
            
            var tax : Double = 0
            
            let taxItems = lstProductTax.filter({ (product) in
                let ProdId = String(format: "%@", product["Product_Code"] as! CVarArg)
                return Bool(ProdId == productId)
            })
            
            if taxItems.count > 0 {
                tax = (taxItems.first!["Value"] as! Double)
                tax = Double(round(100 * tax) / 100)
            }
            
            var disCountPer : Double = 0
            var isSchemeActive = false
            
            var isMultiSchemeActive = false
            var multiScheme = [Scheme]()
            
            var scheme : Int = 0
            var offerAvailableCount : Int = 0
            var offerUnitName : String = ""
            var offerProductCode : String = ""
            var offerProductName:String = ""
            var package : String = ""
            
            if UserSetup.shared.SchemeBased == 1 && UserSetup.shared.offerMode == 1 {
                
                let schemesItems = lstStockistSchemes.filter({ (product) in
                    let ProdId = String(format: "%@", product["PCode"] as! CVarArg)
                    return Bool(ProdId == productId)
                })
                
                if schemesItems.count > 0 {
                    disCountPer = (schemesItems.first!["Disc"] as! NSString).doubleValue
                    disCountPer = Double(round(100 * disCountPer) / 100)
                    isSchemeActive = true
                    scheme = (schemesItems.first!["Scheme"] as! NSString).integerValue
                    offerAvailableCount = (schemesItems.first!["FQ"] as! NSString).integerValue
                    offerUnitName = schemesItems.first!["FreeUnit"] as? String ?? ""
                    offerProductCode = schemesItems.first!["OffProd"] as? String ?? ""
                    offerProductName = schemesItems.first!["OffProdNm"] as? String ?? ""
                    package = schemesItems.first!["pkg"] as? String ?? ""
                    print(package)
                    
                    if schemesItems.count > 1 {
                        
                        for schemesItem in schemesItems {
                            isMultiSchemeActive = true
                            var disCountPert = (schemesItem["Disc"] as! NSString).doubleValue
                            disCountPert = Double(round(100 * disCountPer) / 100)
                            let scheme = (schemesItem["Scheme"] as! NSString).integerValue
                            let offerAvailableCount = (schemesItem["FQ"] as! NSString).integerValue
                            let offerUnitName = schemesItem["FreeUnit"] as? String ?? ""
                            let offerProductCode = schemesItem["OffProd"] as? String ?? ""
                            let offerProductName = schemesItem["OffProdNm"] as? String ?? ""
                            let package = schemesItem["pkg"] as? String ?? ""
                            
                            
                            multiScheme.append(Scheme(disCountPer: disCountPert, scheme: scheme, offerAvailableCount: offerAvailableCount, offerUnitName: offerUnitName, offerProductCode: offerProductCode, offerProductName: offerProductName, package: package))
                        }
                    }
                    
                }
            }
            
            self.allProducts.append(ProductList(product: product, productName: productName, productId: productId,cateId: cateId, rate: rate, sampleQty: "", disCountPer: disCountPer, disCountAmount: 0.0, freeCount: 0, unitName: unitName, unitCount: unitId, taxper: tax, taxAmount: 0.0, totalCount: 0.0, isSchemeActive: isSchemeActive,scheme: scheme,offerAvailableCount: offerAvailableCount,offerUnitName: offerUnitName,offerProductCode: offerProductCode,offerProductName: offerProductName,package: package, isMultiSchemeActive: isMultiSchemeActive, multiScheme: multiScheme))
        }
    }
    
     
    @IBAction func homeAction(_ sender: UIButton) {
//        VisitData.shared.selectedOrders = self.allProducts.filter({ product in
//            let productQty = Int(product.sampleQty) ?? 0
//            return productQty > 0
//        })
//
//
//        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbCallPreview") as!  CallPreview
//        vc.eKey = self.eKey
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want cancel this order draft", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
            GlobalFunc.movetoHomePage()
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    
    @IBAction func filterProductList(_ sender: UITextField) {
        if sender.text!.isEmpty {
            products = allProducts.filter{$0.cateId == selectedBrand}
        }else{
            products = allProducts.filter{$0.productName.lowercased().contains(sender.text!.lowercased())}
        }
        tableView.reloadData()
    }
    
    
    @IBAction func proceedAction(_ sender: UIButton) {
        if isValid() == false {
            return
        }
        
        vwSubmit.isHidden = false
        tableView.isHidden = true
        
        self.freeProducts = self.allProducts.filter{$0.freeCount != 0}
        selectedListTableView.reloadData()
        self.updateTotalPriceList()
        freeQtyTableView.reloadData()
        selectedListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
    }
    
    
    @IBAction func addProductAction(_ sender: UIButton) {
        
        tableView.isHidden = false
        vwSubmit.isHidden = true
        collectionView.reloadData()
        self.products = self.allProducts.filter{$0.cateId == selectedBrand}
        tableView.reloadData()
        updateTotal()
    }
    
    func isValid() -> Bool {
        
        self.selectedProducts = self.allProducts.filter({ product in
            let productQty = Int(product.sampleQty) ?? 0
            return productQty > 0
        })
        
        if(selectedProducts.count<1){
            Toast.show(message: "Cart is Empty.", controller: self)
            return false
        }
        return true
    }
    
    @IBAction func finalSubmit(_ sender: UIButton) {
        
        if isValid() == false {
            return
        }
        
        if LocationService.sharedInstance.isLocationPermissionEnable() == false{
            Toast.show(message: "Please Enable Location", controller: self)
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
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit order?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            VisitData.shared.cOutTime = GlobalFunc.getCurrDateAsString()
            self.ShowLoading(Message: "Getting Device Location...")
            var isSubmit = false
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
                        }
                    }
                   
                }
                if isSubmit == false {
                    isSubmit.toggle()
                    self.finalSubmit(sLocation: sLocation, sAddress: sAddress)
                }
                
            }, error:{ errMsg in
                print (errMsg)
                self.LoadingDismiss()
            })
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
        
    }
    
    func  finalSubmit (sLocation: String,sAddress: String) {
        
        var lstPlnDetail: [AnyObject] = []
        if self.LocalStoreage.string(forKey: "Mydayplan") == nil { return }
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list
            DataSF = lstPlnDetail[0]["subordinateid"] as! String
        }
        
        
        var productString = ""
        
        for product in selectedProducts {
            
            let qty = product.unitCount * (Int(product.sampleQty) ?? 0)
            var scheme : Int = 0
            var offerProductCode : String = ""
            var offerProductName:String = ""
            var freePCount = product.productId
            var freePName = product.productName
            
            if UserSetup.shared.SchemeBased == 1 && UserSetup.shared.offerMode == 1 {
                scheme = product.scheme
                offerProductCode = product.offerProductCode
                offerProductName = product.offerProductName
                freePCount = product.offerProductCode
                freePName = product.productName
            }
            
            let productStr = "{\"product_code\":\"\(product.productId)\",\"product_Name\":\"\(product.productName) \",\"rx_Conqty\":\(product.sampleQty),\"Qty\":\(qty),\"PQty\":0,\"cb_qty\":0,\"free\":\(product.freeCount),\"Pfree\":0,\"Rate\":\(product.rate),\"PieseRate\":\(product.rate),\"discount\":\(product.disCountPer),\"FreeP_Code\":\"\(freePCount)\",\"Fname\":\"\(freePName)\",\"discount_price\":\(product.disCountAmount),\"tax\":\(product.taxper),\"tax_price\":\(product.taxAmount),\"OrdConv\":\(product.unitCount),\"product_unit_name\":\"\(product.unitName)\",\"selectedScheme\":\(scheme),\"selectedOffProCode\":\"\(offerProductCode)\",\"selectedOffProName\":\"\(offerProductName)\",\"selectedOffProUnit\":\"\(product.unitCount)\",\"f_key\":{\"activity_stockist_code\":\"Activity_Stockist_Report\"}},"
            
            productString = productString + productStr
            
        }
        
        if productString.hasSuffix(","){
            productString.removeLast()
        }
        
        self.lblPriceItems.text = "Price (\(self.selectedProducts.count)) items"
        
        let totalAmount = self.allProducts.map{$0.totalCount}.reduce(0){$0 + $1}
        
        let taxAmount = self.allProducts.map{$0.taxAmount}.reduce(0){$0 + $1}
        
        let discountAmount = self.allProducts.map{$0.disCountAmount}.reduce(0){$0 + $1}
        
        let totalAmountRound = Double(round(100 * totalAmount) / 100)
        
        let taxAmountRound = Double(round(100 * taxAmount) / 100)
        
        let discountAmountRound = Double(round(100 * discountAmount) / 100)
        
        let subTotal = totalAmountRound - taxAmountRound
        
        print("Ekey===\(self.eKey)") // worked_with_code
        
        let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"\'" + (lstPlnDetail[0]["worktype"] as! String) + "\'\",\"Town_code\":\"\'" + (lstPlnDetail[0]["ClstrName"] as! String) + "\'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'" + VisitData.shared.cInTime + "\'\",\"Daywise_Remarks\":\" " + VisitData.shared.VstRemarks.name.trimmingCharacters(in: .whitespacesAndNewlines) + " \",\"eKey\":\"" + self.eKey + "\",\"rx\":\"\'\'\",\"rx_t\":\"\'\'\",\"DataSF\":\"\'" + self.DataSF + "\'\"}},{\"Activity_Stockist_Report\":{\"Stockist_POB\":\"\",\"Worked_With\":\"\'" + (lstPlnDetail[0]["worked_with_code"] as! String) + "\'\",\"location\":\"\'" + sLocation + "\'\",\"geoaddress\":\"" + sAddress + " \",\"superstockistid\":\"\'\'\",\"Stk_Meet_Time\":\"\'" + VisitData.shared.cInTime + "\'\",\"modified_time\":\"\'" + VisitData.shared.cInTime + "\'\",\"date_of_intrument\":\"\",\"intrumenttype\":\"\",\"orderValue\":\"\(totalAmountRound)\",\"Aob\":0,\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"CheckoutTime\":\"" + VisitData.shared.cInTime + "\",\"taxTotalValue\":\"\(taxAmountRound)\",\"discTotalValue\":\"\(discountAmountRound)\",\"subTotal\":\"\(subTotal)\",\"No_Of_items\":\"\(selectedProducts.count)\",\"PhoneOrderTypes\":1,\"doctor_id\":\"\'" + VisitData.shared.CustID + "\'\",\"stockist_code\":\"\'" + VisitData.shared.CustID + "\'\",\"version\":8,\"stockist_name\":\"\'" + VisitData.shared.CustName + " \'\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"}}},{\"Activity_Stk_POB_Report\":[\(productString)]},{\"Activity_Stk_Sample_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]},{\"Activity_Event_Captures_Call\":[]}]"
        
        print(jsonString)
        
        let params: Parameters = [
            "data": jsonString
        ]
        
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode + "&rSF=" + self.SFCode + "&sfCode=" + self.SFCode)
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode + "&rSF=" + self.SFCode + "&sfCode=" + self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseData {
        AFdata in
        self.LoadingDismiss()
        PhotosCollection.shared.PhotoList = []
        switch AFdata.result
        {
            
        case .success(let value):
            print(value)
            
            let apiResponse = try? JSONSerialization.jsonObject(with: AFdata.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
            print(apiResponse as Any)
            
            VisitData.shared.selectedOrders = self.allProducts.filter({ product in
                let productQty = Int(product.sampleQty) ?? 0
                return productQty > 0
            })
            
            
            Toast.show(message: "Order has been submitted successfully", controller: self)
            print(AFdata.response?.statusCode)
            
//            if  AFdata.response?.statusCode == 200 {
//                if isSubmit == false{
//
//                }
//            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbCallPreview") as!  CallPreview
                vc.eKey = self.eKey
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            print("Ekey===\(self.eKey)")
            
            
            
            
//            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
//            UIApplication.shared.windows.first?.rootViewController = viewController
//            UIApplication.shared.windows.first?.makeKeyAndVisible()
//
//            VisitData.shared.clear()
            
        case .failure(let error):
            let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                return
            })
            self.present(alert, animated: true)
        }
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lstBrands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BrandCollectionViewCell
        
        let item : [String : Any] = lstBrands[indexPath.row] as! [String : Any]
        cell.lblName.text = item["name"] as? String
        cell.vwContent.layer.cornerRadius = 10
        cell.vwContent.clipsToBounds = true
        cell.lblName.textColor = .darkGray
        cell.vwContent.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 251/255, alpha: 1)
        
        let id=String(format: "%@", item["id"] as! CVarArg)
        if selectedBrand == id {
            cell.vwContent.backgroundColor = UIColor(red: 16/255, green: 173/255, blue: 194/255, alpha: 1)
            cell.lblName.textColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item : [String : Any] = lstBrands[indexPath.row] as! [String : Any]
        selectedBrand = String(format: "%@", item["id"] as! CVarArg)
        
        self.products = self.allProducts.filter{$0.cateId == selectedBrand}
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectedListTableView {
            selectedTableViewHeightConstraint.constant = CGFloat(selectedProducts.count * 115)
            return self.selectedProducts.count
        }else if tableView == self.tableView {
            return self.products.count
        }else {
            let freeQtyCount = self.allProducts.filter{$0.freeCount != 0}
            freeQtyTableViewHeightConstraint.constant = CGFloat(freeQtyCount.count * 55) + 20
            let height = CGFloat(selectedProducts.count * 120) + CGFloat(freeQtyCount.count * 60) + 350
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: height)
            return freeQtyCount.count
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(tableView)
        if tableView == self.tableView {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "SuperStockistOrderListTableViewCell", for: indexPath) as! SuperStockistOrderListTableViewCell
            
            Cell.product = self.products[indexPath.row]
            print(self.products[indexPath.row])
            Cell.lblUnit.addTarget(target: self, action: #selector(openUnitList))
            Cell.txtQty.addTarget(self, action: #selector(changeQty(_:)), for: .editingChanged)
            Cell.vwPlus.addTarget(target: self, action: #selector(addQty(_:)))
            Cell.vwSub.addTarget(target: self, action: #selector(subtractQty(_:)))
            Cell.imgCountList.addTarget(target: self, action: #selector(dropDown))
            Cell.txtFreeQty.addTarget(target: self, action: #selector(freeQtySelection(_:)))
            Cell.txtDisPer.addTarget(self, action: #selector(addDiscount(_:)), for: .editingChanged)
            if UserSetup.shared.SchemeBased == 1 && UserSetup.shared.offerMode == 1{
                Cell.txtDisPer.borderStyle = .none
                Cell.txtDisPer.isUserInteractionEnabled = false
                Cell.txtFreeQty.isUserInteractionEnabled = false
            }
            Cell.txtTaxPer.isUserInteractionEnabled = false
            Cell.imgScheme.addTarget(target: self, action: #selector(schemeAction))
            let id = self.products[indexPath.row].productId
            let productImage = self.products[indexPath.row].product["Product_Image"] as? String
            Cell.imgProduct.image = nil
            if self.ProdImages[id] != nil{
                Cell.imgProduct.image = self.ProdImages[id] as? UIImage
            }else{
                if productImage != nil {
                    if let imgurl = productImage {
                        if imgurl != "" {
                            let imageUrlString=String(format: "%@%@", APIClient.shared.ProdImgURL,(productImage as! String).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                            let imageUrl = URL(string: imageUrlString)!
                                
                                DispatchQueue.global(qos: .userInitiated).async {
                                    autoreleasepool{
                                        var imageData: NSData? = nil
                                        do {
                                             imageData = try NSData(contentsOf: imageUrl)
                                        }catch let err{
                                            print(err.localizedDescription)
                                        }
                                        DispatchQueue.main.async {
                                            autoreleasepool{
                                            if(imageData != nil){
                                                var image = UIImage(data: imageData! as Data)
                                                Cell.imgProduct.image = image
                                                self.ProdImages.updateValue(image, forKey: id)
                                                image = nil
                                            }
                                            imageData=nil
                                            }
                                    }
                                    }
                                }
                        }
                    }
                }
            }
            return Cell
        }else if tableView == selectedListTableView {
            
            let Cell = tableView.dequeueReusableCell(withIdentifier: "SuperStockistOrderSelectedListViewCell", for: indexPath) as! SuperStockistOrderSelectedListViewCell
            Cell.product = self.selectedProducts[indexPath.row]
            Cell.vwPlus.addTarget(target: self, action: #selector(addProductQty(_:)))
            Cell.vwSub.addTarget(target: self, action: #selector(subtractProductQty(_:)))
            Cell.btnDelete.addTarget(self, action: #selector(deleteProduct(_:)), for: .touchUpInside)
            Cell.lblUnit.addTarget(target: self, action: #selector(openUnitListinFinalSubmit))
            let id = self.selectedProducts[indexPath.row].productId
            
            Cell.imgView.image = nil
            if self.ProdImages[id] != nil{
                Cell.imgView.image = self.ProdImages[id] as? UIImage
            }
            return Cell
        }else {
            let freeQtyCount = self.allProducts.filter{$0.freeCount != 0}
            let Cell = tableView.dequeueReusableCell(withIdentifier: "FreeQuantityTableViewCell", for: indexPath) as! FreeQuantityTableViewCell

            if UserSetup.shared.SchemeBased == 1 && UserSetup.shared.offerMode == 1{
                Cell.lblName.text = freeQtyCount[indexPath.row].offerProductName == "" ? freeQtyCount[indexPath.row].productName : freeQtyCount[indexPath.row].offerProductName
                Cell.lblQuantity.text = "\(freeQtyCount[indexPath.row].freeCount)"
            }else {
                Cell.lblName.text = freeQtyCount[indexPath.row].productName
                Cell.lblQuantity.text = "\(freeQtyCount[indexPath.row].freeCount)"
            }
            
            return Cell
        }
    }
    
    @objc private func deleteProduct (_ sender : UIButton) {
        let cell:SuperStockistOrderSelectedListViewCell = GlobalFunc.getTableViewCell(view: sender) as! SuperStockistOrderSelectedListViewCell
        
        self.selectedProducts.removeAll{$0.productId == cell.product.productId}
        self.allProducts.removeAll{$0.productId == cell.product.productId}
        
        self.allProducts.append(ProductList(product: cell.product.product, productName: cell.product.productName, productId: cell.product.productId,cateId: cell.product.cateId, rate: cell.product.rate, sampleQty: "", disCountPer: cell.product.disCountPer, disCountAmount: 0.0, freeCount: 0, unitName: cell.product.unitName, unitCount: cell.product.unitCount, taxper: cell.product.taxper, taxAmount: 0.0, totalCount: 0.0, isSchemeActive: cell.product.isSchemeActive,scheme: cell.product.scheme,offerAvailableCount: cell.product.offerAvailableCount,offerUnitName: cell.product.offerUnitName,offerProductCode: cell.product.offerProductCode,offerProductName: cell.product.offerProductName,package: cell.product.package,isMultiSchemeActive: cell.product.isMultiSchemeActive,multiScheme: cell.product.multiScheme))
        
        
        self.selectedListTableView.reloadData()
        self.updateTotalPriceList()
    }
    
    @objc private func addProductQty(_ sender: UITapGestureRecognizer) {
        let cell:SuperStockistOrderSelectedListViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderSelectedListViewCell
        
        var qty = Int(cell.product.sampleQty) ?? 0
        
        qty = qty + 1
        if qty<0 { qty = 0 }
        cell.lblQty.text = String(qty)
        cell.product.sampleQty = String(qty)
        
        self.calculationForSelectedOrderCell(cell: cell)
    }
    
    @objc private func subtractProductQty(_ sender: UITapGestureRecognizer){
        let cell:SuperStockistOrderSelectedListViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderSelectedListViewCell
        let tbView:UITableView = GlobalFunc.getTableView(view: sender.view!)
        
        var qty = Int(cell.product.sampleQty) ?? 0
        
        qty = qty - 1
        if qty<0 { qty = 0 }
        cell.lblQty.text = String(qty)
        cell.product.sampleQty = String(qty)
        
        self.calculationForSelectedOrderCell(cell: cell)
    }
    
    @objc private func openUnitListinFinalSubmit(_ sender: UITapGestureRecognizer) {
        let cell:SuperStockistOrderSelectedListViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderSelectedListViewCell
        let tbView:UITableView = GlobalFunc.getTableView(view: sender.view!)
        
        lstUnits = lstAllUnits.filter({(product) in
            let id = String(format: "%@", product["Product_Code"] as! CVarArg)
            return Bool(id == cell.product.productId)
        })
        
        let unitVC = ItemViewController(items: lstUnits, configure: { (Cell : SingleSelectionTableViewCell, unit) in
            Cell.textLabel?.text = unit["name"] as? String
            Cell.detailTextLabel?.text = "1 X " + String(format: "%@", unit["ConQty"] as! CVarArg)
        })
        unitVC.title = "Select the Name"
        unitVC.didSelect = { unit in
            cell.lblUnit.text = unit["name"] as? String
            cell.product.unitName = unit["name"] as? String ?? ""
            
            let conQty = String(format: "%@", unit["ConQty"] as! CVarArg)
            cell.product.unitCount = Int(conQty) ?? 0
            
            self.calculationForSelectedOrderCell(cell: cell)
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(unitVC, animated: true)
    }
    
    func calculationForSelectedOrderCell(cell : SuperStockistOrderSelectedListViewCell) {
        
        var discountPer : Double = 0
        
        let taxPer = cell.product.taxper
        
        let unitCount = cell.product.unitCount
        let rate = cell.product.rate
        let sQty = Int(cell.product.sampleQty) ?? 0
        print("QTYYYY \(sQty)")
        if cell.product.isMultiSchemeActive == true {
            let totalQty = unitCount * sQty
            let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty)
            if scheme != nil {
                discountPer = scheme!.disCountPer
                cell.product.disCountPer = scheme!.disCountPer
            }
        }else {
            discountPer = cell.product.disCountPer
        }
        
        let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100
        
        if cell.product.isSchemeActive == true {
            let totalQty = unitCount * sQty
            
            if cell.product.package == "N" {
                if cell.product.isMultiSchemeActive == true {
                    
                    let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty)
                    
                    if scheme != nil {
                        
                        let schQty = scheme!.scheme
                        let value = Double(totalQty) /  Double(schQty)
                        cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
                        cell.product.scheme = scheme!.scheme
                        cell.product.offerProductCode = scheme!.offerProductCode
                        cell.product.offerProductName = scheme!.offerProductName
                        
                    }else {
                        cell.product.freeCount = 0
                    }
                }else {
                    
                    let schQty = cell.product.scheme
                    let value = Double(totalQty) /  Double(schQty)
                    if Double(totalQty) >  Double(schQty) {
                        cell.product.freeCount = Int(value * Double(cell.product.offerAvailableCount))
                    }
                    
                }
            }else {
                if cell.product.isMultiSchemeActive == true {
                    let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty)
                    
                    if scheme != nil {
                        let schemeQty = totalQty / scheme!.scheme
                        
                        cell.product.freeCount = schemeQty * scheme!.offerAvailableCount
                        cell.product.scheme = scheme!.scheme
                        cell.product.offerProductCode = scheme!.offerProductCode
                        cell.product.offerProductName = scheme!.offerProductName
                    }else {
                        cell.product.freeCount = 0
                    }
                }else {
                    let schemeQty = totalQty / cell.product.scheme
                    if totalQty >= cell.product.scheme{
                        cell.product.freeCount = schemeQty * cell.product.offerAvailableCount
                    }
                    
                }
                
            }
        }
        
        let discountPerOneUnit = discountPer *  rate / 100
        
        let rateMinusDiscount = rate - discountPerOneUnit
        
        let taxAmount = taxPer * Double(unitCount) * rateMinusDiscount * Double(sQty) / 100
        
        var total = Double(sQty) * rateMinusDiscount * Double(unitCount)
        
        total = total + taxAmount
        
        let discountAmountRound = Double(round(100 * discountAmount) / 100)
        let taxAmountRound = Double(round(100 * taxAmount) / 100)
        let totalAmountRound = Double(round(100 * total) / 100)
        
        cell.lblDisc.text = "₹ " + "\(discountAmountRound)"
        cell.lblTax.text = "₹ " + "\(taxAmountRound)"
        cell.product.taxAmount = taxAmountRound
        cell.product.disCountAmount = discountAmountRound
        cell.product.totalCount = totalAmountRound
        cell.lblTotal.text = "₹ " + "\(totalAmountRound)"
        
        if let index = self.allProducts.firstIndex(where: { (productInfo) -> Bool in
            return cell.product.productId == productInfo.productId
        }){
            self.allProducts[index] = cell.product
        }
        if let index = self.selectedProducts.firstIndex(where: { (productInfo) -> Bool in
            return cell.product.productId == productInfo.productId
        }){
            self.selectedProducts[index] = cell.product
        }
        self.updateTotalPriceList()
        self.freeQtyTableView.reloadData()
    }
    
    func updateTotalPriceList(){
        
        let selectedProducts = self.allProducts.filter({ product in
            let productQty = Int(product.sampleQty) ?? 0
            return productQty > 0
        })
                
        self.lblPriceItems.text = "Price (\(selectedProducts.count)) items"
        
        let totalAmount = self.allProducts.map{$0.totalCount}.reduce(0){$0 + $1}
        self.lblPriceAmount.text = "₹ " + "\(Double(round(100 * totalAmount) / 100))"
        
        
        
        let totalUnits = selectedProducts.map{$0.totalUnits()}.reduce(0){$0 + $1}
        self.lblTotalQty.text = "\(totalUnits)"
        
        self.lblTotalPayment.text = "₹ " + "\(Double(round(100 * totalAmount) / 100))"
        
        self.lblFinalItems.text = "Items : \(selectedProducts.count)"
        
        self.lblFinalRate.text = "₹ " + "\(Double(round(100 * totalAmount) / 100))"
        
    }
    
    @objc private func addDiscount (_ sender : UITextField) {
        let cell:SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: sender) as! SuperStockistOrderListTableViewCell
        let tbView:UITableView = GlobalFunc.getTableView(view: sender)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        let value = validateDoubleInput(textField: sender)
        
        cell.txtDisPer.text = sender.text!
        
        cell.product.disCountPer = Double(sender.text!) ?? 0
        
        let taxPer = cell.product.taxper
        let discountPer = cell.product.disCountPer
        let unitCount = cell.product.unitCount
        let rate = cell.product.rate
        let sQty = Int(cell.product.sampleQty) ?? 0
        let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100
        
        
        
        let discountPerOneUnit = discountPer *  rate / 100
        
        let rateMinusDiscount = rate - discountPerOneUnit
        
        let taxAmount = taxPer * Double(unitCount) * rateMinusDiscount * Double(sQty) / 100
        
        var total = Double(sQty) * rateMinusDiscount * Double(unitCount)
        
        total = total + taxAmount
        
        cell.txtDisAmt.text = "\(discountAmount)"
        cell.txtTaxAmt.text = "\(taxAmount)"
        cell.product.taxAmount = taxAmount
        cell.product.disCountAmount = discountAmount
        cell.product.totalCount = total
        cell.lblRate.text = "\(cell.product.rate) x ( \(unitCount) x \(sQty) )  =  \(total)"
        
        
        if let index = self.allProducts.firstIndex(where: { (productInfo) -> Bool in
            return cell.product.productId == productInfo.productId
        }){
            self.allProducts[index] = cell.product
        }
        
        self.updateTotal()
    }
                              
    @objc private func changeQty (_ txtQty : UITextField) {
        let cell:SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: txtQty) as! SuperStockistOrderListTableViewCell
        let tbView:UITableView = GlobalFunc.getTableView(view: txtQty)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        let qty: Int =  integer(from: cell.txtQty)
        cell.txtQty.text = "\(qty)"
        cell.product.sampleQty = "\(qty)"
        
        self.calculationForOrderCell(cell: cell)
        
        
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToRow(at: indxPath, at: .none, animated:false)
    }
    
    @objc private func freeQtySelection(_ sender : UITapGestureRecognizer) {
        let cell: SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderListTableViewCell
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        let countVC = ItemViewController(items: lstRandomNumbers, configure: { (Cell : SingleSelectionTableViewCell, count) in
            Cell.textLabel?.text = count["name"] as? String
        })
        countVC.title = "Select the Count"
        countVC.didSelect = { cnt in
            cell.txtFreeQty.text = cnt["name"] as? String
            cell.product.freeCount = Int(cell.txtFreeQty.text!) ?? 0
            
            if let index = self.allProducts.firstIndex(where: { (productInfo) -> Bool in
                return cell.product.productId == productInfo.productId
            }){
                self.allProducts[index] = cell.product
            }
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            self.tableView.scrollToRow(at: indxPath, at: .none, animated:false)
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(countVC, animated: true)
    }
    
    @objc private func schemeAction(_ sender : UITapGestureRecognizer){
        let cell: SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderListTableViewCell
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        print("success")
        
        if cell.product.isMultiSchemeActive == true {
            AlertData.shared.title = cell.product.productName
            
            AlertData.shared.scheme = cell.product.multiScheme
            
        }else {
            
            AlertData.shared.title = cell.product.productName
            
            let scheme = Scheme(disCountPer: cell.product.disCountPer, scheme: cell.product.scheme, offerAvailableCount: cell.product.offerAvailableCount, offerUnitName: cell.product.offerUnitName, offerProductCode: cell.product.offerProductCode, offerProductName: cell.product.offerProductName, package: cell.product.package)
            
            var schemes = [Scheme]()
            schemes.append(scheme)
            
            AlertData.shared.scheme = schemes
            
        }
        let alertView = CustomAlertVCViewController()
        alertView.show()
        
    }
    
    @objc private func dropDown(_ sender : UITapGestureRecognizer) {
        let cell: SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderListTableViewCell
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        let countVC = ItemViewController(items: lstRandomNumbers, configure: { (Cell : SingleSelectionTableViewCell, count) in
            Cell.textLabel?.text = count["name"] as? String
        })
        countVC.title = "Select the Count"
        countVC.didSelect = { cnt in
            cell.txtQty.text = cnt["name"] as? String
            cell.product.sampleQty = cnt["name"] as? String ?? ""
            
            self.calculationForOrderCell(cell: cell)
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            self.tableView.scrollToRow(at: indxPath, at: .none, animated:false)
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(countVC, animated: true)
    }
    
    @objc private func addQty(_ sender: UITapGestureRecognizer){
        let cell:SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderListTableViewCell
        let tbView:UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        var qty: Int = integer(from: cell.txtQty)
        
        qty = qty + 1
        
        cell.txtQty.text = String(qty)
        cell.product.sampleQty = String(qty)
       
        calculationForOrderCell(cell: cell)
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: indxPath, at: .none, animated:false)
        
    }
    
    
    func calculationForOrderCell(cell : SuperStockistOrderListTableViewCell) {
        
        var discountPer : Double = 0
        
        let taxPer = cell.product.taxper
        
        let unitCount = cell.product.unitCount
        let rate = cell.product.rate
        let sQty = Int(cell.product.sampleQty) ?? 0
        
        if cell.product.isMultiSchemeActive == true {
            let totalQty = unitCount * sQty
            let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty)
            if scheme != nil {
                discountPer = scheme!.disCountPer
                cell.product.disCountPer = scheme!.disCountPer
            }
        }else {
            discountPer = cell.product.disCountPer
        }
        
        let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100
        
        if cell.product.isSchemeActive == true {
            let totalQty = unitCount * sQty
            
            if cell.product.package == "N" {
                if cell.product.isMultiSchemeActive == true {
                    
                    let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty)
                    
                    if scheme != nil {
                        let schQty = scheme!.scheme
                        let value = Double(totalQty) /  Double(schQty)
                        cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
                    }else{
                        cell.product.freeCount = 0
                    }
                }else {
                    let schQty = cell.product.scheme
                    let value = Double(totalQty) /  Double(schQty)
                    if Double(totalQty) >= Double(schQty){
                        cell.product.freeCount = Int(value * Double(cell.product.offerAvailableCount))
                    }
                    
                }
            }else {
                if cell.product.isMultiSchemeActive == true {
                    let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty)
                    
                    if scheme != nil {
                        let schemeQty = totalQty / scheme!.scheme
                        cell.product.freeCount = schemeQty * scheme!.offerAvailableCount //  Int(value * Double(scheme!.offerAvailableCount))
                    }else{
                        cell.product.freeCount = 0
                    }
                }else {
                    let schemeQty = totalQty / cell.product.scheme
                    if totalQty >= cell.product.scheme{
                        cell.product.freeCount = schemeQty * cell.product.offerAvailableCount
                    }
                    
                }
                
            }
        }
        
        let discountPerOneUnit = discountPer *  rate / 100
        
        let rateMinusDiscount = rate - discountPerOneUnit
        
        let taxAmount = taxPer * Double(unitCount) * rateMinusDiscount * Double(sQty) / 100
        
        var total = Double(sQty) * rateMinusDiscount * Double(unitCount)
        
        total = total + taxAmount
        
        let discountAmountRound = Double(round(100 * discountAmount) / 100)
        let taxAmountRound = Double(round(100 * taxAmount) / 100)
        let totalAmountRound = Double(round(100 * total) / 100)
        
        cell.txtDisAmt.text = "\(discountAmountRound)"
        cell.txtTaxAmt.text = "\(taxAmountRound)"
        cell.product.taxAmount = taxAmountRound
        cell.product.disCountAmount = discountAmountRound
        cell.product.totalCount =  totalAmountRound
        cell.lblRate.text = "\(cell.product.rate) x ( \(unitCount) x \(sQty) )  =  \(totalAmountRound)"
        
        if let index = self.allProducts.firstIndex(where: { (productInfo) -> Bool in
            return cell.product.productId == productInfo.productId
        }){
            self.allProducts[index] = cell.product
        }
        if let index = self.products.firstIndex(where: { (productInfo) -> Bool in
            return cell.product.productId == productInfo.productId
        }){
            self.products[index] = cell.product
        }
        self.updateTotal()
    }
    
    func nextLessThanValue(in array: [Scheme], comparedTo value: Int) -> Scheme? {
        var nextLessThan: Scheme?
        
        for element in array {
            if element.scheme <= value {
                if nextLessThan == nil || element.scheme >= (nextLessThan?.scheme ?? 0) {
                    nextLessThan = element
                }
            }
        }
        
        return nextLessThan
    }
    
    @objc private func subtractQty(_ sender: UITapGestureRecognizer){
        let cell:SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderListTableViewCell
        let tbView:UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        var qty: Int =  integer(from: cell.txtQty)
        
        qty = qty - 1
        if qty<0 { qty = 0 }
        cell.txtQty.text = String(qty)
        cell.product.sampleQty = String(qty)
        
        calculationForOrderCell(cell: cell)
        
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToRow(at: indxPath, at: .none, animated:false)
    }
    
    
    @objc private func openUnitList(_ sender: UITapGestureRecognizer) {
        let cell: SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderListTableViewCell
        let tbView:UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        lstUnits = lstAllUnits.filter({(product) in
            let id = String(format: "%@", product["Product_Code"] as! CVarArg)
            return Bool(id == cell.product.productId)
        })
        
        let unitVC = ItemViewController(items: lstUnits, configure: { (Cell : SingleSelectionTableViewCell, unit) in
            Cell.textLabel?.text = unit["name"] as? String
            Cell.detailTextLabel?.text = "1 X " + String(format: "%@", unit["ConQty"] as! CVarArg)
        })
        unitVC.title = "Select the UOM"
        unitVC.didSelect = { unit in
            cell.lblUnit.text = unit["name"] as? String
            cell.product.unitName = unit["name"] as? String ?? ""
            
            let conQty = String(format: "%@", unit["ConQty"] as! CVarArg)
            cell.product.unitCount = Int(conQty) ?? 0
            
            self.calculationForOrderCell(cell: cell)
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            self.tableView.scrollToRow(at: indxPath, at: .none, animated:false)
            
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(unitVC, animated: true)
    }
    
    func updateTotal() {
        
        let totalAmount = self.allProducts.map{$0.totalCount}.reduce(0){$0 + $1}
        self.lblTotalRate.text = "₹ " + "\(Double(round(100 * totalAmount) / 100))"
        
        
        let totalItems = self.allProducts.filter({ product in
            let productQty = Int(product.sampleQty) ?? 0
            return productQty > 0
        })
        
        self.lblTotalItems.text = "Items : \(totalItems.count)"
    }
    
    func validateDoubleInput(textField: UITextField) -> Double? {
      guard let text = textField.text, !text.isEmpty else {
        return nil // Empty text field
      }
      return Double(text)
    }
    
    func integer(from textField: UITextField) -> Int {
        guard let text = textField.text, let number = Int(text) else {
            return 0
        }
        if text.count > 6 {
               let truncatedText = String(text.prefix(6))
                print(truncatedText)
            var ConvInt2 = 0
            if let ConvInt = Int(truncatedText){
                ConvInt2 = ConvInt
            }
            print(ConvInt2)
               Toast.show(message: "Text count cannot be more than 6 characters.")
            return ConvInt2
            
           }
        return number
    }
    
    @objc private func backVC() {
        self.resignFirstResponder()
        
        if vwSubmit.isHidden == false {
            vwSubmit.isHidden = true
            tableView.isHidden = false
            
            self.products = self.allProducts.filter{$0.cateId == selectedBrand}
            tableView.reloadData()
            updateTotal()
            return
        }

        let alert = UIAlertController(title: "Confirmation", message: "Do you want cancel this order draft", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            VisitData.shared.ProductCart=[]
            self.navigationController?.popViewController(animated: true)
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    
}

// MARK: - SuperStockistOrderSelectedListViewCell


class SuperStockistOrderSelectedListViewCell : UITableViewCell{
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    
    @IBOutlet weak var lblQty: UILabel!
    
    @IBOutlet weak var vwPlus: UIView!
    @IBOutlet weak var vwSub: UIView!
    
    @IBOutlet weak var lblCl: UILabel!
    
    
    @IBOutlet weak var lblFree: UILabel!
    @IBOutlet weak var lblDisc: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    
    var product : ProductList! {
        didSet {
            lblName.text = product.productName
            lblUnit.text = product.unitName
            
            print("Good\(product.sampleQty)")
            lblQty.text = product.sampleQty
            lblRate.text = "₹ " + "\(product.rate)"
            lblCl.text = "0"
            
            lblFree.text = "\(product.freeCount)"
            
            lblDisc.text =  "₹ " + "\(product.disCountAmount)"
            lblTax.text = "₹ " + "\(product.taxAmount)"
            
            lblTotal.text = "₹ " + "\(product.totalCount)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: SuperStockistOrderListTableViewCell

class SuperStockistOrderListTableViewCell : UITableViewCell {
    
    
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblUnit: LabelSelect!
        
    @IBOutlet weak var txtQty: UITextField!
    
    @IBOutlet weak var txtDisPer: UITextField!
    @IBOutlet weak var txtDisAmt: UITextField!
    
    @IBOutlet weak var txtTaxPer: UITextField!
    @IBOutlet weak var txtTaxAmt: UITextField!
    
    
    @IBOutlet weak var txtFreeQty: UITextField!
    
    
    @IBOutlet weak var vwPlus: UIView!
    @IBOutlet weak var vwSub: UIView!
    
    
    @IBOutlet weak var lblRate: UILabel!
    
    @IBOutlet weak var imgCountList: UIImageView!
    
    @IBOutlet weak var imgScheme: UIImageView!
    
    @IBOutlet weak var lblFreeProductName: UILabel!
    
    
    @IBOutlet weak var imgSchemeWidthConstraint: NSLayoutConstraint!
    
    var product : ProductList! {
        didSet {
            lblName.text = product.productName
            lblUnit.text = product.unitName
            
            txtQty.text = product.sampleQty
            txtDisPer.text = "\(product.disCountPer)"
            txtDisAmt.text = "\(product.disCountAmount)"
            
            txtTaxPer.text = "\(product.taxper)"
            txtTaxAmt.text = "\(product.taxAmount)"
            
            txtFreeQty.text = "\(product.freeCount)"
            
            lblRate.text = "\(product.rate) X ( \(product.unitCount) X \(product.sampleQty == "" ? "0" : product.sampleQty) ) = \(product.totalCount) "
            
            print(product.isSchemeActive)
            imgScheme.isHidden = product.isSchemeActive == true ? false : true
            imgSchemeWidthConstraint.constant = product.isSchemeActive ==  true ? 25 : 0
            
            if product.freeCount != 0 {
                lblFreeProductName.text = product.offerProductName != product.productName ? product.offerProductName : ""
            }else {
                lblFreeProductName.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - FreeQuantityTableViewCell

class FreeQuantityTableViewCell : UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class BrandCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwContent: UIView!
    
}


class AlertData{
    static var shared = AlertData()
    
    var title : String = ""
    var scheme = [Scheme]()
    var discount : String = ""
    var freeName : String = ""
    
    func clear() {
        title = ""
        // scheme = [Scheme]()
        discount = ""
        freeName = ""
    }
}


struct ProductList {
    
    var product : AnyObject
    var productName : String
    var productId : String
    var cateId : String
    var rate : Double
    
    var sampleQty : String
    
    var disCountPer : Double
    var disCountAmount : Double
    
    var freeCount : Int
    
    var unitName : String
    var unitCount : Int
    
    var taxper : Double
    var taxAmount : Double
    
    var totalCount : Double
    
    var isSchemeActive : Bool
    
    var isMultiSchemeActive : Bool
    
    var scheme : Int
    var offerAvailableCount : Int
    var offerUnitName : String
    var offerProductCode : String
    var offerProductName : String
    var package : String
    
    var multiScheme = [Scheme]()
        
    
    init(product: AnyObject, productName: String, productId: String,cateId : String, rate: Double, sampleQty: String, disCountPer: Double, disCountAmount: Double, freeCount: Int, unitName: String, unitCount: Int, taxper: Double, taxAmount: Double, totalCount: Double , isSchemeActive : Bool,scheme : Int,offerAvailableCount:Int,offerUnitName: String,offerProductCode:String,offerProductName:String,package: String,isMultiSchemeActive:Bool,multiScheme : [Scheme]) {
        self.product = product
        self.productName = productName
        self.productId = productId
        self.cateId = cateId
        self.rate = rate
        self.sampleQty = sampleQty
        self.disCountPer = disCountPer
        self.disCountAmount = disCountAmount
        self.freeCount = freeCount
        self.unitName = unitName
        self.unitCount = unitCount
        self.taxper = taxper
        self.taxAmount = taxAmount
        self.totalCount = totalCount
        self.isSchemeActive = isSchemeActive
        self.scheme = scheme
        self.offerAvailableCount = offerAvailableCount
        self.offerUnitName = offerUnitName
        self.offerProductCode = offerProductCode
        self.offerProductName = offerProductName
        self.package = package
        self.isMultiSchemeActive = isMultiSchemeActive
        self.multiScheme = multiScheme
    }
    
    func totalUnits() -> Int{
        return unitCount * (Int(sampleQty) ?? 0)
    }
    
}

struct Scheme  {
    var disCountPer : Double
    var scheme : Int
    var offerAvailableCount : Int
    var offerUnitName : String
    var offerProductCode : String
    var offerProductName : String
    var package : String
    
    init(disCountPer : Double,scheme: Int, offerAvailableCount: Int, offerUnitName: String, offerProductCode: String, offerProductName: String, package: String) {
        self.disCountPer = disCountPer
        self.scheme = scheme
        self.offerAvailableCount = offerAvailableCount
        self.offerUnitName = offerUnitName
        self.offerProductCode = offerProductCode
        self.offerProductName = offerProductName
        self.package = package
    }
}




