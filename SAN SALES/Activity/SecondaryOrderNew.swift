//
//  SecondaryOrderNew.swift
//  SAN SALES
//
//  Created by Naga Prasath on 20/08/24.
//

import UIKit
import Alamofire
import CoreLocation

class SecondaryOrderNew : IViewController, UITableViewDelegate, UITableViewDataSource ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    
    @IBOutlet weak var lblRetailerName: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    
    
    @IBOutlet weak var lblDistributor: LabelSelect!
    
    @IBOutlet weak var lblTotalRate: UILabel!
    @IBOutlet weak var lblTotalItems: UILabel!
    
    
    @IBOutlet weak var lblFinalRate: UILabel!
    @IBOutlet weak var lblFinalItems: UILabel!
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var lblPriceItems: UILabel!
    @IBOutlet weak var lblPriceAmount: UILabel!
    
    
    @IBOutlet weak var lblTotalQty: UILabel!
    @IBOutlet weak var lblTotalPayment: UILabel!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tbProductTableView: UITableView!
    
    
    @IBOutlet weak var SelectedProductTableView: UITableView!
    
    
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
    var lstDistList: [AnyObject] = []
    var lstPlnDetail: [AnyObject] = []
    var lstProductRemarks : [AnyObject] = []
    var lstSelectedProductRemarks : [AnyObject] = []
    
    var products = [ProductList]()
    var selectedProducts = [ProductList]()
    var freeProducts = [ProductList]()
    var allProducts = [ProductList]()
    
    
    var productData : String?
    var ProdTrans_Sl_No : String?
    var areypostion: Int?
    var isFromEdit : Bool!
    
    
    var Editobjcalls: [AnyObject]=[]
    var Cust_Code: String = ""
    var DCR_Code: String = ""
    var Trans_Sl_No: String = ""
    var Route: String = ""
    var Stockist_Code: String = ""
    
    var ProdImages:[String: Any] = [:]
    
    let axn="get/vwOrderDetails"
    
    var net_weight_data = ""
    
    var isFromMissedEntry : Bool = false
    var selectedSf : String!
    var missedDateSubmit : (String) -> () = { _ in}
    var missedDateEditData : ([SecondaryOrderNewSelectedList]) -> () = { _  in}
    var productsforMissed = [SecondaryOrderNewSelectedList]()
    var selectedProductsforMissed = [SecondaryOrderNewSelectedList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwSubmit.isHidden = true
        
        freeQtyTableViewHeightConstraint.constant = 0
        loadViewIfNeeded()
        
        getUserDetails()
        
        self.lblTitle.text = UserSetup.shared.SecondaryCaption
        self.lblRetailerName.text = VisitData.shared.CustName
        self.lblName.text = VisitData.shared.CustName
        
        self.lblDate.text = Date().toString(format: "dd-MMM-yyyy")
        
        imgBack.addTarget(target: self, action: #selector(backVC))
        lblDistributor.addTarget(target: self, action: #selector(distributorSelection))
        
        tbProductTableView.estimatedRowHeight = 200
        tbProductTableView.rowHeight = UITableView.automaticDimension
        
//        selectedListTableView.estimatedRowHeight = UITableView.automaticDimension
//        selectedListTableView.rowHeight = UITableView.automaticDimension
        
        let lstCatData: String=LocalStoreage.string(forKey: "Brand_Master")!
        let lstProdData: String = LocalStoreage.string(forKey: "Products_Master")!
        let lstUnitData: String = LocalStoreage.string(forKey: "UnitConversion")!
        let lstRandomNumberData: String = LocalStoreage.string(forKey: "Random_Number")!
        let lstProductRateData : String = LocalStoreage.string(forKey: "ProductsRates_Master")!
        let lstProductTaxData : String = LocalStoreage.string(forKey: "ProductTax_Master")!
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        let lstStockistSchemeData : String = LocalStoreage.string(forKey: "Stockist_Schemes")!
        let lstProductRemarksData : String = LocalStoreage.string(forKey: "Product_Remarks")!
        
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        
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
        if let list = GlobalFunc.convertToDictionary(text: lstProductRemarksData) as? [AnyObject] {
            lstProductRemarks = list
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
        
        if self.isFromMissedEntry == false {
            DataSF = self.lstPlnDetail[0]["subordinateid"] as! String
        }else {
            DataSF = self.selectedSf
        }
        
        if let lstDistData = LocalStoreage.string(forKey: "Distributors_Master_"+DataSF),
           let list = GlobalFunc.convertToDictionary(text:  lstDistData) as? [AnyObject] {
            lstDistList = list
            print(lstDistList)
        }
        
        self.EditSecondaryordervalue()
        self.editMissedDateOrder()
        print(lstStockistSchemes)
    }
    
    @objc private func distributorSelection(){
        let distributorVC = ItemViewController(items: lstDistList, configure: { (Cell : SingleSelectionTableViewCell, distributor) in
            Cell.textLabel?.text = distributor["name"] as? String
        })
        distributorVC.title = "Select the Distributor"
        distributorVC.didSelect = { selectedDistributor in
            let item: [String: Any]=selectedDistributor as! [String : Any]
            let name=item["name"] as! String
            let id=String(format: "%@", item["id"] as! CVarArg)
            
            self.lblDistributor.text = name
            self.lblDate.text = name
            VisitData.shared.Dist.name = name
            VisitData.shared.Dist.id = id
            self.Stockist_Code = id
            
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(distributorVC, animated: true)
    }
    
    func editMissedDateOrder() {
        
        if !self.selectedProductsforMissed.isEmpty {
            for product in selectedProductsforMissed {
                
                if let index = self.allProducts.firstIndex(where: { (productInfo) -> Bool in
                    return product.product.productId == productInfo.productId
                }){
                    self.allProducts[index] = product.product
                }
            }
            
            let filteredArray = lstDistList.filter {($0["id"] as? Int) == Int(self.selectedProductsforMissed.first?.distributorId ?? "0")}
            if (filteredArray.isEmpty){
                VisitData.shared.Dist.id = ""
                lblDistributor.text = ""
            }else{
                VisitData.shared.Dist.id = String((filteredArray[0]["id"] as? Int)!)
                VisitData.shared.Dist.name = filteredArray[0]["name"] as? String ?? ""
                lblDistributor.text = filteredArray[0]["name"] as? String
                lblDate.text = filteredArray[0]["name"] as? String
            }
        }
        
        self.updateTotal()
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
    
    func EditSecondaryordervalue() {
        let product = productData
        print(product as Any)
        if let unwrappedProduct = product {
    
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&desig=\(self.Desig)&divisionCode=\(DivCode)&sfCode=\(SFCode)&DCR_Code=\(String(describing: unwrappedProduct))"
            print (apiKey)
      //
            let aFormData: [String: Any] = [
                "orderBy":"[\"name asc\"]","desig":"mgr"
            ]
            print(aFormData)
            let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            let params: Parameters = [
                "data": jsonString
            ]
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                AFdata in
                switch AFdata.result
                {
                    
                case .success(let value):
                    print(value)
                    if let json = value as? [AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        print(prettyPrintedJson)
//                        self.lblTotAmt.text = String(json[0]["POB_Value"] as! Double)
//                        var amount = String(json[0]["POB_Value"] as! Double)
//                        print(amount)
//                        \"No_Of_items\":\"3\",\"Cust_Code\":\"'2149655'\",\"DCR_Code\":\"SEF1-279\",\"Trans_Sl_No\":\"MGR1018-23-24-SO-126\",\"Route\":\"114726\",\"net_weight_value\":\"0\"
                        
                        print(json)

                        let Additional_Prod_Dtls = json[0]["Additional_Prod_Dtls1"] as? String
                        let productArray = Additional_Prod_Dtls?.components(separatedBy: "#")
                        if let products = productArray {
                            for product in products {
                                    let productData = product.components(separatedBy: "~")
                                    let price = productData[1].components(separatedBy: "$")[0]
                                    let price1 = productData[1].components(separatedBy: "$")[1]
                            }
                        }
                        if let ProdCode = ProdTrans_Sl_No {
                            let filteredArray = json.filter { ($0["Trans_Sl_No"] as? String) == ProdCode }
                            self.Editobjcalls = filteredArray
                            print(filteredArray)
                           // net_weight_value = filteredArray[0]["net_weight_value"] as! Int
                            Cust_Code = filteredArray[0]["Cust_Code"] as! String
                            DCR_Code = filteredArray[0]["DCR_Code"] as! String
                            Trans_Sl_No = filteredArray[0]["Trans_Sl_No"] as! String
                           
                            if let route = filteredArray[0]["Route"] as? String {
                                Route = route
                            } else {
                                Route = ""
                            }
                           Stockist_Code = filteredArray[0]["Stockist_Code"] as! String
                        }
                        DemoEdite()
                       // setSecEditeOrder()
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)
                }
            }
    } else {
        // The optional value is nil
        print("Product is nil")
    }
       
        }
    
    func DemoEdite(){
        print(Editobjcalls)
      //  print(lstAllUnitList)
            for item in Editobjcalls {
                if let stock_Code =  Editobjcalls[0]["Stockist_Code"] as? String{
                    print(lstDistList)
                   
                    let filteredArray = lstDistList.filter { ($0["id"] as? Int) == Int(stock_Code) }
                    print(filteredArray)
                    if (filteredArray.isEmpty){
                        VisitData.shared.Dist.id = ""
                        lblDistributor.text = ""
                    }else{
                        VisitData.shared.Dist.id = String((filteredArray[0]["id"] as? Int)!)
                        VisitData.shared.Dist.name = filteredArray[0]["name"] as? String ?? ""
                        lblDistributor.text = filteredArray[0]["name"] as? String
                    }
                }
                if let Additional_Prod_Dtls = item["Additional_Prod_Dtls"] as? String, let Additional_Prod_Code = item["Additional_Prod_Code"] as? String{
                   
                    
                    let  separates = Additional_Prod_Dtls.components(separatedBy: "#")
                    let  separte_Prod_Code = Additional_Prod_Code.components(separatedBy: "#")
                    
                    for (separt_item, separte_Prod_Code_item) in zip(separates, separte_Prod_Code) {
                        let id: String
                        var BasUnitCode: Int = 0
                        var selNetWt: String = ""
                        let trimmedString = ""
                        let lProdItem:[String: Any]
                        var sQty : String = ""
                        var selUOMNm:String = ""
                        var selUOMConv:String = ""
                        let prod_components = separte_Prod_Code_item.components(separatedBy: "~")
                        print(prod_components)
                        let Prod_Id = prod_components[0].trimmingCharacters(in: .whitespacesAndNewlines)

                        var Uomdata = lstAllUnits.filter({(product) in
                            let ProdId: String = String(format: "%@", product["Product_Code"] as! CVarArg)
                            return Bool(ProdId == Prod_Id)
                        })
                        
                        print(Uomdata)
                        let Separt_UomConv = prod_components[1].components(separatedBy: "$")
                        let Separt_UomConv2 = Separt_UomConv[1].components(separatedBy: "@")
                        let components = separt_item.components(separatedBy: "@")
                        print(components)
                        
                        let qtycon = components[3].components(separatedBy: "?")
                        print(qtycon)
                        sQty = qtycon[0]
                        let Uomid = qtycon[1].components(separatedBy: "-")
                        let Uomid2 = Uomid[0]
                        var Uomdata2 = Uomdata.filter({(product) in
                            let ProdId: String = String(format: "%@", product["id"] as! CVarArg)
                            return Bool(ProdId == Uomid2)
                        })
                        print(Uomdata2)
                        print(Uomdata2)
                        var UomConQtydata2 = ""
                        if  let UomConQtydata = Uomdata2[0]["ConQty"] as? Int {
                            UomConQtydata2 = String(UomConQtydata)
                        }
                        print(UomConQtydata2)
                        let Cod_and_uom = components[3]
                        let selUnit = Cod_and_uom.components(separatedBy: "?")
                        
                        selUOMConv = selUnit[0]
                        selUOMNm = selUnit[0]
                        let separt_id_and_Uom = selUnit[1].components(separatedBy: "-")
                        selUOMNm = separt_id_and_Uom[1]
                     
                    let indexToDelete = lstAllProducts.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == Prod_Id })
                        let stkname = lstAllProducts[indexToDelete!]
                        lProdItem = stkname as! [String : Any]
                    if let baseUnitCodeStr = lstAllProducts[indexToDelete!]["Base_Unit_code"] as? String,
                       let baseUnitCodeInt = Int(baseUnitCodeStr) {
                        BasUnitCode = baseUnitCodeInt
                    }
                        var clQty : String = "0"
                    
                        if let product =  item["Additional_Prod_Code2"] as? String {
                            let clqty = product.components(separatedBy: "*")
                            clQty = clqty[0]
                        }
                    
                        
                        let rateCom = separte_Prod_Code_item.components(separatedBy: "*")
                        var rate = rateCom[1]
                    
                        updateQty(id: Prod_Id, sUom: Uomid2, sUomNm: selUOMNm, sUomConv: UomConQtydata2,sNetUnt: selNetWt, sQty: sQty,ProdItem: lProdItem, rateValue: rate, clQty: clQty)
                }
            }
        }
    }
    
    func updateQty (id: String,sUom: String,sUomNm: String,sUomConv: String,sNetUnt: String,sQty: String,ProdItem:[String: Any],rateValue : String,clQty : String) {
        
        
        print(rateValue)
        let product = lstAllProducts.filter{String(format: "%@", $0["id"] as! CVarArg) == id}
        
        if product.isEmpty {
            return
        }
        
        
        let productName = String(format: "%@", product.first!["name"] as! CVarArg)
        let productId = String(format: "%@", product.first!["id"] as! CVarArg)
        let cateId = String(format: "%@", product.first!["cateid"] as! CVarArg)
        let saleErpCode = String(format: "%@", product.first!["Sale_Erp_Code"] as! CVarArg)
        let newWt = String(format: "%@", product.first!["product_netwt"] as! CVarArg)
        
        
        let Units = lstAllUnits.filter({(product) in
            let ProdId = String(format: "%@", product["Product_Code"] as! CVarArg)
            return Bool(ProdId == productId)
        })
        
        var unitName = ""
        var unitId = ""
        var unitCount = 0
        if Units.count > 0 {
            
            print(Units)
            print(sUom)
            print(sUomNm)
            print(sUomConv)
            let selectedUnits = Units.filter({(product) in
                let unitId = String(format: "%@", product["id"] as! CVarArg)
                return Bool(unitId == sUom)
            })
            if !selectedUnits.isEmpty {
                unitName = String(format: "%@", selectedUnits.first!["name"] as! CVarArg)
                unitId = String(format: "%@", selectedUnits.first!["id"] as! CVarArg)
                let conQty = String(format: "%@", selectedUnits.first!["ConQty"] as! CVarArg)
                unitCount = Int(conQty) ?? 0
            }else {
                unitName = String(format: "%@", Units.first!["name"] as! CVarArg)
                unitId = String(format: "%@", Units.first!["id"] as! CVarArg)
                let conQty = String(format: "%@", Units.first!["ConQty"] as! CVarArg)
                unitCount = Int(conQty) ?? 0
            }
            print(Units)
            
        }
        
        let RateItems: [AnyObject] = lstProductsRates.filter ({ (Rate) in
            if Rate["Product_Detail_Code"] as! String == productId {
                return true
            }
            return false
        })
        
        var rate : Double = 0
        var retailorPrice : Double = 0
        if(RateItems.count>0){
            print(RateItems)
            rate = (RateItems.first!["Retailor_Price"] as! NSString).doubleValue
            retailorPrice = (RateItems.first!["Retailor_Price"] as! NSString).doubleValue
        }
        
        rate = Double(rateValue) ?? 0
        
        
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
        
        
        var discountPer : Double = 0
        let taxPer = tax
        
        let sQty = Int(sQty) ?? 0
        
//        if cell.product.isMultiSchemeActive == true {
//            let totalQty = unitCount * sQty
//            let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty)
//            if scheme != nil {
//                discountPer = scheme!.disCountPer
//                cell.product.disCountPer = scheme!.disCountPer
//            }
//        }else {
//            discountPer = cell.product.disCountPer
//        }
        
        let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100
        
//        if cell.product.isSchemeActive == true {
//            let totalQty = unitCount * sQty
//            
//            if cell.product.package == "N" {
//                if cell.product.isMultiSchemeActive == true {
//                    
//                    let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty)
//                    
//                    if scheme != nil {
//                        let schQty = scheme!.scheme
//                        let value = Double(totalQty) /  Double(schQty)
//                        cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
//                    }else{
//                        cell.product.freeCount = 0
//                    }
//                }else {
//                    let schQty = cell.product.scheme
//                    let value = Double(totalQty) /  Double(schQty)
//                    if Double(totalQty) >= Double(schQty){
//                        cell.product.freeCount = Int(value * Double(cell.product.offerAvailableCount))
//                    }
//                    
//                }
//            }else {
//                if cell.product.isMultiSchemeActive == true {
//                    let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty)
//                    
//                    if scheme != nil {
//                        let schemeQty = totalQty / scheme!.scheme
//                        cell.product.freeCount = schemeQty * scheme!.offerAvailableCount //  Int(value * Double(scheme!.offerAvailableCount))
//                    }else{
//                        cell.product.freeCount = 0
//                    }
//                }else {
//                    let schemeQty = totalQty / cell.product.scheme
//                    if totalQty >= cell.product.scheme{
//                        cell.product.freeCount = schemeQty * cell.product.offerAvailableCount
//                    }
//                    
//                }
//                
//            }
//        }
        
        let discountPerOneUnit = discountPer *  rate / 100
        
        let rateMinusDiscount = rate - discountPerOneUnit
        
        let taxAmount = taxPer * Double(unitCount) * rateMinusDiscount * Double(sQty) / 100
        
        var total = Double(sQty) * rateMinusDiscount * Double(unitCount)
        
        total = total + taxAmount
        
        let discountAmountRound = Double(round(100 * discountAmount) / 100)
        let taxAmountRound = Double(round(100 * taxAmount) / 100)
        let totalAmountRound = Double(round(100 * total) / 100)
        
        
        
        let EditProduct = ProductList(product: product.first!, productName: productName, productId: productId,cateId: cateId, rate: rate,rateEdited: "0",retailerPrice: retailorPrice,saleErpCode: saleErpCode,newWt: newWt, sampleQty: "\(sQty)",clQty: clQty,remarks: "",remarksId: "", selectedRemarks: [], disCountPer: disCountPer, disCountAmount: discountAmountRound, freeCount: 0, unitId: unitId, unitName: unitName, unitCount: unitCount, taxper: tax, taxAmount: taxAmountRound, totalCount: totalAmountRound, isSchemeActive: isSchemeActive,scheme: scheme,offerAvailableCount: offerAvailableCount,offerUnitName: offerUnitName,offerProductCode: offerProductCode,offerProductName: offerProductName,package: package, isMultiSchemeActive: isMultiSchemeActive, multiScheme: multiScheme)
        

        
        
        if let index = self.allProducts.firstIndex(where: { (productInfo) -> Bool in
            return id == productInfo.productId
        }){
            self.allProducts[index] = EditProduct
        }
        
        self.updateTotal()
    }
    
    func updateProduct( products: [AnyObject]) {
        
        for product in products {
            
            print(product)
            let productName = String(format: "%@", product["name"] as! CVarArg)
            let productId = String(format: "%@", product["id"] as! CVarArg)
            let cateId = String(format: "%@", product["cateid"] as! CVarArg)
            let saleErpCode = String(format: "%@", product["Sale_Erp_Code"] as! CVarArg)
            let newWt = String(format: "%@", product["product_netwt"] as! CVarArg)
            
            
            let Units = lstAllUnits.filter({(product) in
                let ProdId = String(format: "%@", product["Product_Code"] as! CVarArg)
                return Bool(ProdId == productId)
            })
            
            var unitName = ""
            var unitId = ""
            var unitCount = 0
            if Units.count > 0 {
                print(Units)
                unitName = String(format: "%@", Units.first!["name"] as! CVarArg)
                unitId = String(format: "%@", Units.first!["id"] as! CVarArg)
                let conQty = String(format: "%@", Units.first!["ConQty"] as! CVarArg)
                unitCount = Int(conQty) ?? 0
            }
            
            let RateItems: [AnyObject] = lstProductsRates.filter ({ (Rate) in
                if Rate["Product_Detail_Code"] as! String == productId {
                    return true
                }
                return false
            })
            
            var rate : Double = 0
            var retailorPrice : Double = 0
            if(RateItems.count>0){
                print(RateItems)
                rate = (RateItems.first!["Retailor_Price"] as! NSString).doubleValue
                retailorPrice = (RateItems.first!["Retailor_Price"] as! NSString).doubleValue
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
            
            
            self.allProducts.append(ProductList(product: product, productName: productName, productId: productId,cateId: cateId, rate: rate,rateEdited: "0",retailerPrice: retailorPrice,saleErpCode: saleErpCode,newWt: newWt, sampleQty: "",clQty: "",remarks: "",remarksId: "", selectedRemarks: [], disCountPer: disCountPer, disCountAmount: 0.0, freeCount: 0, unitId: unitId, unitName: unitName, unitCount: unitCount, taxper: tax, taxAmount: 0.0, totalCount: 0.0, isSchemeActive: isSchemeActive,scheme: scheme,offerAvailableCount: offerAvailableCount,offerUnitName: offerUnitName,offerProductCode: offerProductCode,offerProductName: offerProductName,package: package, isMultiSchemeActive: isMultiSchemeActive, multiScheme: multiScheme))
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
        tbProductTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == SelectedProductTableView {
            selectedTableViewHeightConstraint.constant = CGFloat(selectedProducts.count * 115)
            return self.selectedProducts.count
        }else if tableView == self.tbProductTableView {
            return self.products.count
        }else {
            let freeQtyCount = self.allProducts.filter{$0.freeCount != 0}
            freeQtyTableViewHeightConstraint.constant = CGFloat(freeQtyCount.count * 55) + 20
            let height = CGFloat(selectedProducts.count * 120) + CGFloat(freeQtyCount.count * 60) + 350
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: height)
            return freeQtyCount.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(tableView)
        if tableView == self.tbProductTableView {
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
            Cell.imgRateEdit.addTarget(target: self, action: #selector(rateEditAction))
            Cell.txtClQty.addTarget(self, action: #selector(changeClQty(_:)), for: .editingChanged)
            Cell.btnTemplate.addTarget(self, action: #selector(templateAction(_:)), for: .touchUpInside)
            // Cell.imgRateEdit.isHidden = true
            Cell.imgCompetitorProduct.isHidden = true
            if UserSetup.shared.clCap  == "CB"{
                Cell.lblCl.text = "CB : "
                Cell.lblQty.text = "Sale : "
            }else if UserSetup.shared.clCap  == "CL"{
                Cell.lblCl.text = "CL : "
                Cell.lblQty.text = "Qty : "
            }
            if UserSetup.shared.rateEditable == 0 {
                Cell.imgRateEdit.isHidden = true
                Cell.imgRateEditWidthConstraint.constant = 0
            }
            if UserSetup.shared.productRemark == 0 {
                Cell.viewRemarks.isHidden = true
                Cell.vwRemarkHeightConstraint.constant = 0
            }
            if UserSetup.shared.clFilter == "0" {
                Cell.viewCl.isHidden = true
                Cell.vwClQtyHeightConstraint.constant = 0
            }
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
        }else if tableView == SelectedProductTableView {
            
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
    
    @objc private func changeQty (_ txtQty : UITextField) {
        let cell:SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: txtQty) as! SuperStockistOrderListTableViewCell
        let tbView:UITableView = GlobalFunc.getTableView(view: txtQty)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        let qty: Int =  integer(from: cell.txtQty)
        cell.txtQty.text = "\(qty)"
        cell.product.sampleQty = "\(qty)"
        
        self.calculationForOrderCell(cell: cell)
        
        
        tbProductTableView.beginUpdates()
        tbProductTableView.endUpdates()
        tbProductTableView.scrollToRow(at: indxPath, at: .none, animated:false)
    }
    
    @objc private func changeClQty (_ txtQty : UITextField) {
        let cell:SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: txtQty) as! SuperStockistOrderListTableViewCell
        let tbView:UITableView = GlobalFunc.getTableView(view: txtQty)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        let qty: Int =  integer(from: cell.txtClQty)
        cell.txtClQty.text = "\(qty)"
        cell.product.clQty = "\(qty)"
        
        self.calculationForOrderCell(cell: cell)
        
        
        tbProductTableView.beginUpdates()
        tbProductTableView.endUpdates()
        tbProductTableView.scrollToRow(at: indxPath, at: .none, animated:false)
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
        
        tbProductTableView.beginUpdates()
        tbProductTableView.endUpdates()
        tbProductTableView.scrollToRow(at: indxPath, at: .none, animated:false)
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
        
        self.tbProductTableView.beginUpdates()
        self.tbProductTableView.endUpdates()
        self.tbProductTableView.scrollToRow(at: indxPath, at: .none, animated:false)
        
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
            
            self.tbProductTableView.beginUpdates()
            self.tbProductTableView.endUpdates()
            self.tbProductTableView.scrollToRow(at: indxPath, at: .none, animated:false)
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(countVC, animated: true)
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
            self.tbProductTableView.beginUpdates()
            self.tbProductTableView.endUpdates()
            self.tbProductTableView.scrollToRow(at: indxPath, at: .none, animated:false)
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(countVC, animated: true)
    }
    @objc private func templateAction(_ sender : UIButton) {
        let cell:SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: sender) as! SuperStockistOrderListTableViewCell
        let tbView:UITableView = GlobalFunc.getTableView(view: sender)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        
//        let remarksVC = ItemMultipleSelectionViewController(items: lstProductRemarks, configure: { (Cell : MultipleSelectionTableViewCell, remark) in
//            Cell.lblName.text = remark["name"] as? String
//            
//            let selectedRemarks = self.lstSelectedProductRemarks.filter{$0["id"] as? String == remark["id"] as? String}
//            
//            if !selectedRemarks.isEmpty {
//                Cell.button.isSelected = true
//            }else{
//                Cell.button.isSelected = false
//            }
//        })
//        remarksVC.title = "Select the Remarks"
//        remarksVC.didSelect = { selectedItem in
//            print(selectedItem)
//            
//            if let index = self.lstSelectedProductRemarks.firstIndex(where: { (item) -> Bool in
//                return selectedItem["id"] as? String == item["id"] as? String
//            }){
//                self.lstSelectedProductRemarks.remove(at: index)
//            }else{
//                self.lstSelectedProductRemarks.append(selectedItem)
//            }
//        }
//        remarksVC.save = { items in
//            let remarks = self.lstSelectedProductRemarks.map{$0["name"] as? String ?? ""}.joined(separator: ",")
//            let remarksId = self.lstSelectedProductRemarks.map{$0["id"] as? String ?? ""}.joined(separator: ",")
//            
//            print(remarks)
//            print(remarksId)
//            
//            cell.product.remarks = remarks
//            cell.product.remarksId = remarksId
//            
//            
//            self.calculationForOrderCell(cell: cell)
//            
//            self.tbProductTableView.reloadData()
//        }
//        self.navigationController?.pushViewController(remarksVC, animated: true)
        
        let remarksVC = ItemMultipleSelectionViewController(items: lstProductRemarks, configure: { (Cell : MultipleSelectionTableViewCell, remark) in
            Cell.lblName.text = remark["name"] as? String
            
            let selectedRemarks = cell.product.selectedRemarks.filter{$0["id"] as? String == remark["id"] as? String}
            
            if !selectedRemarks.isEmpty {
                Cell.button.isSelected = true
            }else{
                Cell.button.isSelected = false
            }
        })
        remarksVC.title = "Select the Remarks"
        remarksVC.didSelect = { selectedItem in
            print(selectedItem)
            
            if let index = cell.product.selectedRemarks.firstIndex(where: { (item) -> Bool in
                return selectedItem["id"] as? String == item["id"] as? String
            }){
                cell.product.selectedRemarks.remove(at: index)
            }else{
                cell.product.selectedRemarks.append(selectedItem)
            }
        }
        remarksVC.save = { items in
            let remarks = cell.product.selectedRemarks.map{$0["name"] as? String ?? ""}.joined(separator: ",")
            let remarksId = cell.product.selectedRemarks.map{$0["id"] as? String ?? ""}.joined(separator: ",")
            
            print(remarks)
            print(remarksId)
            
            cell.product.remarks = remarks
            cell.product.remarksId = remarksId
            cell.product.selectedRemarks = items
            
            
            self.calculationForOrderCell(cell: cell)
            
            self.tbProductTableView.reloadData()
        }
        self.navigationController?.pushViewController(remarksVC, animated: true)
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
            
            self.tbProductTableView.beginUpdates()
            self.tbProductTableView.endUpdates()
            self.tbProductTableView.scrollToRow(at: indxPath, at: .none, animated:false)
            
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(unitVC, animated: true)
    }
    
    @objc private func rateEditAction(_ sender : UITapGestureRecognizer) {
        let cell: SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderListTableViewCell
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        let editView = RateEditViewController<Any>()
        editView.rate = cell.product.rate
        editView.updateRate = { rate in
            
            cell.product.rate = rate as! Double
            
            self.calculationForOrderCell(cell: cell)
            self.dismiss(animated: true)
        }
        editView.show()
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
    
    @objc private func deleteProduct (_ sender : UIButton) {
        let cell:SuperStockistOrderSelectedListViewCell = GlobalFunc.getTableViewCell(view: sender) as! SuperStockistOrderSelectedListViewCell
        
        self.selectedProducts.removeAll{$0.productId == cell.product.productId}
        self.allProducts.removeAll{$0.productId == cell.product.productId}
        
        self.allProducts.append(ProductList(product: cell.product.product, productName: cell.product.productName, productId: cell.product.productId,cateId: cell.product.cateId, rate: cell.product.rate,rateEdited: cell.product.rateEdited,retailerPrice: cell.product.retailerPrice,saleErpCode: cell.product.saleErpCode,newWt: cell.product.newWt, sampleQty: "",clQty: "",remarks: "",remarksId: "", selectedRemarks: cell.product.selectedRemarks, disCountPer: cell.product.disCountPer, disCountAmount: 0.0, freeCount: 0, unitId: cell.product.unitId, unitName: cell.product.unitName, unitCount: cell.product.unitCount, taxper: cell.product.taxper, taxAmount: 0.0, totalCount: 0.0, isSchemeActive: cell.product.isSchemeActive,scheme: cell.product.scheme,offerAvailableCount: cell.product.offerAvailableCount,offerUnitName: cell.product.offerUnitName,offerProductCode: cell.product.offerProductCode,offerProductName: cell.product.offerProductName,package: cell.product.package,isMultiSchemeActive: cell.product.isMultiSchemeActive,multiScheme: cell.product.multiScheme))
        
        
        self.SelectedProductTableView.reloadData()
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
    
    func validateDoubleInput(textField: UITextField) -> Double? {
      guard let text = textField.text, !text.isEmpty else {
        return nil
      }
      return Double(text)
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
    
    func updateTotal() {
        
        let totalAmount = self.allProducts.map{$0.totalCount}.reduce(0){$0 + $1}
        self.lblTotalRate.text = "₹ " + "\(Double(round(100 * totalAmount) / 100))"
        
        
        let totalItems = self.allProducts.filter({ product in
            let productQty = Int(product.sampleQty) ?? 0
            return productQty > 0
        })
        
        self.lblTotalItems.text = "Items : \(totalItems.count)"
    }
    
    func isValid() -> Bool {
        if VisitData.shared.Dist.id == "" {
            Toast.show(message: "Select the Distributor", controller: self)
            return false
        }
        
        self.selectedProducts = self.allProducts.filter({ product in
            let productQty = Int(product.sampleQty) ?? 0
            return productQty > 0
        })
        
        if(selectedProducts.count<1){
            Toast.show(message: "Cart is Empty.", controller: self)
            return false
        }else {
            for i in 0..<selectedProducts.count {
                if selectedProducts[i].rate > 0 {
                    return true
                }
            }
            Toast.show(message: "Please select atleast one product with rate", controller: self)
            return false
        }
        return true
    }
    
    @IBAction func AddProductAction(_ sender: UIButton) {
        tbProductTableView.isHidden = false
        vwSubmit.isHidden = true
        collectionView.reloadData()
        self.products = self.allProducts.filter{$0.cateId == selectedBrand}
        tbProductTableView.reloadData()
        updateTotal()
    }
    
    
    
    @IBAction func filterProduct(_ sender: UITextField) {
        if sender.text!.isEmpty {
            products = allProducts.filter{$0.cateId == selectedBrand}
        }else{
            products = allProducts.filter{$0.productName.lowercased().contains(sender.text!.lowercased())}
        }
        tbProductTableView.reloadData()
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
                    if self.isFromEdit == true {
                        self.EditSubmit(sLocation: sLocation, sAddress: sAddress)
                    }else if self.isFromMissedEntry == true {
                        self.OrderSubmitMissedDate(sLocation: sLocation, sAddress: sAddress)
                    }else {
                        self.OrderSubmit(sLocation: sLocation, sAddress: sAddress)
                    }
                    
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
    
    func OrderSubmitMissedDate(sLocation: String, sAddress: String){
        
        var productString = ""
        
        for i in 0..<self.selectedProducts.count {
            
            let totalAmount = self.allProducts.map{$0.totalCount}.reduce(0){$0 + $1}
            let totalAmountRound = Double(round(100 * totalAmount) / 100)
            
            self.productsforMissed.append(SecondaryOrderNewSelectedList(product: selectedProducts[i], distributorId: VisitData.shared.Dist.id, distributorName: VisitData.shared.Dist.name, subtotal: "\(totalAmountRound)"))
            
        }
        
        missedDateEditData(self.productsforMissed)
        self.LoadingDismiss()
        PhotosCollection.shared.PhotoList = []
        VisitData.shared.clear()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func EditSubmit(sLocation: String,sAddress: String){
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
            let sampleQty = (Int(product.sampleQty) ?? 0)
            let clQty = (Int(product.clQty) ?? 0)
            let totalCount = product.totalCount
            
            if UserSetup.shared.SchemeBased == 1 && UserSetup.shared.offerMode == 1 {
                scheme = product.scheme
                offerProductCode = product.offerProductCode
                offerProductName = product.offerProductName
                freePCount = product.offerProductCode
                freePName = product.productName
            }
             
//            let w =   "{\"product_code\":\"\(product.productId)\",\"product_Name\":\"\(product.productName)\",\"Product_Rx_Qty\":\(qty),\"UnitId\":\"\(product.unitId)\",\"UnitName\":\"\(product.unitName)\",\"rx_Conqty\":\(product.sampleQty),\"Product_Rx_NQty\":0,\"Product_Sample_Qty\":\"\(totalCount)\",\"vanSalesOrder\":0,\"sale_erp_code\":\"\(product.saleErpCode)\",\"rateedited\":0,\"retailer_price\":\(product.retailerPrice),\"net_weight\":\(product.newWt),\"free\":\(product.freeCount),\"FreePQty\":\(product.offerAvailableCount),\"FreeP_Code\":\"\(freePCount)\",\"Fname\":\"\(freePName)\",\"discount\":\(product.disCountPer),\"discount_price\":\(product.disCountAmount),\"tax\":\(product.taxper),\"tax_price\":\(product.taxAmount),\"Rate\":\(product.rate),\"Mfg_Date\":\"\",\"cb_qty\":\(clQty),\"RcpaId\":0,\"Ccb_qty\":0,\"PromoVal\":0,\"rx_remarks\":\"\(product.remarks)\",\"rx_remarks_Id\":\"\(product.remarksId)\",\"OrdConv\":\(product.unitCount),\"selectedScheme\":\(scheme),\"selectedOffProCode\":\"\(offerProductCode)\",\"selectedOffProName\":\"\(offerProductName)\",\"selectedOffProUnit\":\"\(product.unitCount)\",\"CompetitorDet\":[],\"f_key\":{\"Activity_MSL_Code\":\"Activity_Doctor_Report\"}},"
            
            
            let productStr = "{\"product\":\"\(product.productId)\",\"UnitId\":\"\(product.unitId)\",\"UnitName\":\"\(product.unitName)\",\"product_Nm\":\"\(product.productName)\",\"OrdConv\":\(product.unitCount),\"free\":\(product.freeCount),\"HSN\":\"\",\"Rate\":\(product.rate),\"imageUri\":\"\",\"Schmval\":0,\"rx_qty\":\(qty),\"recv_qty\":0,\"product_netwt\":\(product.newWt),\"netweightvalue\":0,\"conversionQty\":\(product.unitCount),\"cateid\":\(product.cateId),\"UcQty\":\(product.unitCount),\"rx_Conqty\":\(sampleQty),\"id\":\"\(product.productId)\",\"name\":\"\(product.productName)\",\"rateedited\":0,\"retailer_price\":\(product.retailerPrice),\"rx_remarks\":\"\(product.remarks)\",\"rx_remarks_Id\":\"\(product.remarksId)\",\"sample_qty\":\"\(product.totalCount)\",\"FreeP_Code\":\"\(freePCount)\",\"Fname\":\"\(freePName)\",\"PromoVal\":0,\"discount\":\(product.disCountPer),\"discount_price\":\(product.disCountAmount),\"tax\":\(product.taxper),\"tax_price\":\(product.taxAmount),\"selectedScheme\":0,\"selectedOffProCode\":\"2\",\"selectedOffProName\":\"Piece\",\"selectedOffProUnit\":\"1\"},"
            
            
            productString = productString + productStr
        }
        
        
        if productString.hasSuffix(","){
            productString.removeLast()
        }
        
        var sImgItems:String = ""
        if(PhotosCollection.shared.PhotoList.count>0){
            for i in 0...PhotosCollection.shared.PhotoList.count-1{
                let item: [String: Any] = PhotosCollection.shared.PhotoList[i] as! [String : Any]
                if i > 0 { sImgItems = sImgItems + "," }
                let sep = item["FileName"]  as! String
                let fullNameArr = sep.components(separatedBy: "_")
                
                let phono = fullNameArr[2]
                var fullid = "_\(phono)"
                print(fullid)
                sImgItems = sImgItems + "{\"imgurl\":\"'" + fullid + "'\",\"title\":\"''\",\"remarks\":\"''\",\"f_key\":{\"Activity_Report_Code\":\"Activity_Report_APP\"}}"
            }
        }
        
        
        let totalAmount = self.allProducts.map{$0.totalCount}.reduce(0){$0 + $1}
        
        let taxAmount = self.allProducts.map{$0.taxAmount}.reduce(0){$0 + $1}
        
        let discountAmount = self.allProducts.map{$0.disCountAmount}.reduce(0){$0 + $1}
        
        let totalAmountRound = Double(round(100 * totalAmount) / 100)
        
        let taxAmountRound = Double(round(100 * taxAmount) / 100)
        
        let discountAmountRound = Double(round(100 * discountAmount) / 100)
        
        let subTotal = totalAmountRound - taxAmountRound
        
        
        let jsonString = "{\"Products\":[" + productString + "],\"Activity_Event_Captures\":[],\"POB\":\"0\",\"Value\":\"\(totalAmountRound)\",\"disPercnt\":0.0,\"disValue\":0.0,\"finalNetAmt\":\(totalAmountRound),\"taxTotalValue\":\"\(taxAmountRound)\",\"discTotalValue\":\"\(discountAmountRound)\",\"subTotal\":\"\(subTotal)\",\"No_Of_items\":\"\(self.selectedProducts.count)\",\"Cust_Code\":\"'\(Cust_Code)'\",\"DCR_Code\":\"\(DCR_Code)\",\"Trans_Sl_No\":\"\(Trans_Sl_No)\",\"Route\":\"\(Route)\",\"net_weight_value\":\"\(net_weight_data)\",\"Discountpercent\":0.0,\"discount_price\":0.0,\"target\":\"0\",\"rateMode\":\"free\",\"Stockist\":\"\(Stockist_Code)\",\"RateEditable\":\"\",\"PhoneOrderTypes\":0}"
        
        
        // net_weight_value
        
        let params: Parameters = [ "data": jsonString ]
        
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/updateProducts&divisionCode=" + self.DivCode + "&sfCode=" + self.SFCode + "&desig=" + self.Desig)
        print(params)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/updateProducts&divisionCode=" + self.DivCode + "&sfCode=" + self.SFCode + "&desig=" + self.Desig, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseData {
        AFdata in
        self.LoadingDismiss()
        PhotosCollection.shared.PhotoList = []
        switch AFdata.result
        {
            
        case .success(let value):
            print(value)
            
            let apiResponse = try? JSONSerialization.jsonObject(with: AFdata.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
            print(apiResponse as Any)
            
            
            Toast.show(message: "Order has been submitted successfully", controller: self)
            VisitData.shared.clear()
            GlobalFunc.movetoHomePage()
            
        case .failure(let error):
            let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                return
            })
            self.present(alert, animated: true)
        }
    }
        
    }
    
    func OrderSubmit(sLocation: String,sAddress: String){
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
            let sampleQty = (Int(product.sampleQty) ?? 0)
            let clQty = (Int(product.clQty) ?? 0)
            let totalCount = product.totalCount
            
            if UserSetup.shared.SchemeBased == 1 && UserSetup.shared.offerMode == 1 {
                scheme = product.scheme
                offerProductCode = product.offerProductCode
                offerProductName = product.offerProductName
                freePCount = product.offerProductCode
                freePName = product.productName
            }
             
            let productStr =   "{\"product_code\":\"\(product.productId)\",\"product_Name\":\"\(product.productName)\",\"Product_Rx_Qty\":\(qty),\"UnitId\":\"\(product.unitId)\",\"UnitName\":\"\(product.unitName)\",\"rx_Conqty\":\(product.sampleQty),\"Product_Rx_NQty\":0,\"Product_Sample_Qty\":\"\(totalCount)\",\"vanSalesOrder\":0,\"sale_erp_code\":\"\(product.saleErpCode)\",\"rateedited\":0,\"retailer_price\":\(product.retailerPrice),\"net_weight\":\(product.newWt),\"free\":\(product.freeCount),\"FreePQty\":\(product.offerAvailableCount),\"FreeP_Code\":\"\(freePCount)\",\"Fname\":\"\(freePName)\",\"discount\":\(product.disCountPer),\"discount_price\":\(product.disCountAmount),\"tax\":\(product.taxper),\"tax_price\":\(product.taxAmount),\"Rate\":\(product.rate),\"Mfg_Date\":\"\",\"cb_qty\":\(clQty),\"RcpaId\":0,\"Ccb_qty\":0,\"PromoVal\":0,\"rx_remarks\":\"\(product.remarks)\",\"rx_remarks_Id\":\"\(product.remarksId)\",\"OrdConv\":\(product.unitCount),\"selectedScheme\":\(scheme),\"selectedOffProCode\":\"\(offerProductCode)\",\"selectedOffProName\":\"\(offerProductName)\",\"selectedOffProUnit\":\"\(product.unitCount)\",\"CompetitorDet\":[],\"f_key\":{\"Activity_MSL_Code\":\"Activity_Doctor_Report\"}},"
            
            productString = productString + productStr
        }
      
        
        if productString.hasSuffix(","){
            productString.removeLast()
        }
        
        var sImgItems:String = ""
        if(PhotosCollection.shared.PhotoList.count>0){
            for i in 0...PhotosCollection.shared.PhotoList.count-1{
                let item: [String: Any] = PhotosCollection.shared.PhotoList[i] as! [String : Any]
                if i > 0 { sImgItems = sImgItems + "," }
                let sep = item["FileName"]  as! String
                let fullNameArr = sep.components(separatedBy: "_")
                
                let phono = fullNameArr[2]
                var fullid = "_\(phono)"
                print(fullid)
                sImgItems = sImgItems + "{\"imgurl\":\"'" + fullid + "'\",\"title\":\"''\",\"remarks\":\"''\",\"f_key\":{\"Activity_Report_Code\":\"Activity_Report_APP\"}}"
            }
        }
        
        self.lblPriceItems.text = "Price (\(self.selectedProducts.count)) items"
        
        let totalAmount = self.allProducts.map{$0.totalCount}.reduce(0){$0 + $1}
        
        let taxAmount = self.allProducts.map{$0.taxAmount}.reduce(0){$0 + $1}
        
        let discountAmount = self.allProducts.map{$0.disCountAmount}.reduce(0){$0 + $1}
        
        let totalAmountRound = Double(round(100 * totalAmount) / 100)
        
        let taxAmountRound = Double(round(100 * taxAmount) / 100)
        
        let discountAmountRound = Double(round(100 * discountAmount) / 100)
        
        let subTotal = totalAmountRound - taxAmountRound
        
        let jsonString = "[ {\"Activity_Report_APP\":{\"Worktype_code\":\"\'" + (lstPlnDetail[0]["worktype"] as! String) + "\'\",\"Town_code\":\"\'" + (lstPlnDetail[0]["clusterid"] as! String) + "\'\",\"RateEditable\":\"''\",\"dcr_activity_date\":\"\'" + VisitData.shared.cInTime + "\'\",\"Daywise_Remarks\":\"" + VisitData.shared.VstRemarks.name.trimmingCharacters(in: .whitespacesAndNewlines) + "\",\"eKey\":\"" + self.eKey + "\",\"rx\":\"'1'\",\"rx_t\":\"''\",\"DataSF\":\"\'" + DataSF + "\'\"}},{\"Activity_Doctor_Report\":{\"Doctor_POB\":0,\"Worked_With\":\"'" + (lstPlnDetail[0]["worked_with_code"] as! String) + "'\",\"Doc_Meet_Time\":\"\'" + VisitData.shared.cInTime + "\'\",\"modified_time\":\"\'" + VisitData.shared.cInTime + "\'\",\"net_weight_value\":\"\(net_weight_data)\",\"stockist_code\":\"\'" + (VisitData.shared.Dist.id ) + "\'\",\"stockist_name\":\"''\",\"superstockistid\":\"''\",\"Discountpercent\":0,\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"CheckoutTime\":\"" + VisitData.shared.cOutTime + "\",\"location\":\"\'" + sLocation + "\'\",\"geoaddress\":\"" + sAddress + "\",\"PhoneOrderTypes\":\"" + VisitData.shared.OrderMode.id + "\",\"Order_Stk\":\"'15560'\",\"Order_No\":\"''\",\"rootTarget\":\"0\",\"orderValue\":\(totalAmount),\"disPercnt\":0.0,\"disValue\":0.0,\"finalNetAmt\":\(totalAmount),\"taxTotalValue\":0,\"discTotalValue\":0.0,\"subTotal\":0,\"No_Of_items\":\(selectedProducts.count),\"rateMode\":\"free\",\"discount_price\":0,\"doctor_code\":\"\'" + VisitData.shared.CustID + "\'\",\"doctor_name\":\"\'" + VisitData.shared.CustName + "\'\",\"doctor_route\":\"'mylapore'\",\"f_key\":{\"Activity_Report_Code\":\"'Activity_Report_APP'\"}}},{\"Activity_Sample_Report\":[" + productString +  "]},{\"Trans_Order_Details\":[]},{\"Activity_Input_Report\":[]}, {\"Activity_Event_Captures\":[" + sImgItems +  "]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]},{\"Activity_Event_Captures_Call\":[]}]"
        
        let params: Parameters = [
            "data": jsonString
        ]
        
        print(params)
        
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
            
//            VisitData.shared.selectedOrders = self.allProducts.filter({ product in
//                let productQty = Int(product.sampleQty) ?? 0
//                return productQty > 0
//            })
            
            
            Toast.show(message: "Order has been submitted successfully", controller: self)
            VisitData.shared.clear()
            GlobalFunc.movetoHomePage()
            
        case .failure(let error):
            let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                return
            })
            self.present(alert, animated: true)
        }
    }
    }
    
    
//    func  finalSubmit (sLocation: String,sAddress: String) {
//        
//        var lstPlnDetail: [AnyObject] = []
//        if self.LocalStoreage.string(forKey: "Mydayplan") == nil { return }
//        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
//        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
//            lstPlnDetail = list
//            DataSF = lstPlnDetail[0]["subordinateid"] as! String
//        }
//        
//        
//        var productString = ""
//        
//        for product in selectedProducts {
//            
//            let qty = product.unitCount * (Int(product.sampleQty) ?? 0)
//            var scheme : Int = 0
//            var offerProductCode : String = ""
//            var offerProductName:String = ""
//            var freePCount = product.productId
//            var freePName = product.productName
//            
//            if UserSetup.shared.SchemeBased == 1 && UserSetup.shared.offerMode == 1 {
//                scheme = product.scheme
//                offerProductCode = product.offerProductCode
//                offerProductName = product.offerProductName
//                freePCount = product.offerProductCode
//                freePName = product.productName
//            }
//            
//            let productStr = "{\"product_code\":\"\(product.productId)\",\"product_Name\":\"\(product.productName) \",\"rx_Conqty\":\(product.sampleQty),\"Qty\":\(qty),\"PQty\":0,\"cb_qty\":0,\"free\":\(product.freeCount),\"Pfree\":0,\"Rate\":\(product.rate),\"PieseRate\":\(product.rate),\"discount\":\(product.disCountPer),\"FreeP_Code\":\"\(freePCount)\",\"Fname\":\"\(freePName)\",\"discount_price\":\(product.disCountAmount),\"tax\":\(product.taxper),\"tax_price\":\(product.taxAmount),\"OrdConv\":\(product.unitCount),\"product_unit_name\":\"\(product.unitName)\",\"selectedScheme\":\(scheme),\"selectedOffProCode\":\"\(offerProductCode)\",\"selectedOffProName\":\"\(offerProductName)\",\"selectedOffProUnit\":\"\(product.unitCount)\",\"f_key\":{\"activity_stockist_code\":\"Activity_Stockist_Report\"}},"
//            
//            productString = productString + productStr
//            
//        }
//        
//        if productString.hasSuffix(","){
//            productString.removeLast()
//        }
//        
//        self.lblPriceItems.text = "Price (\(self.selectedProducts.count)) items"
//        
//        let totalAmount = self.allProducts.map{$0.totalCount}.reduce(0){$0 + $1}
//        
//        let taxAmount = self.allProducts.map{$0.taxAmount}.reduce(0){$0 + $1}
//        
//        let discountAmount = self.allProducts.map{$0.disCountAmount}.reduce(0){$0 + $1}
//        
//        let totalAmountRound = Double(round(100 * totalAmount) / 100)
//        
//        let taxAmountRound = Double(round(100 * taxAmount) / 100)
//        
//        let discountAmountRound = Double(round(100 * discountAmount) / 100)
//        
//        let subTotal = totalAmountRound - taxAmountRound
//        
//        print("Ekey===\(self.eKey)") // worked_with_code
//        
//        let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"\'" + (lstPlnDetail[0]["worktype"] as! String) + "\'\",\"Town_code\":\"\'" + (lstPlnDetail[0]["ClstrName"] as! String) + "\'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'" + VisitData.shared.cInTime + "\'\",\"Daywise_Remarks\":\" " + VisitData.shared.VstRemarks.name.trimmingCharacters(in: .whitespacesAndNewlines) + " \",\"eKey\":\"" + self.eKey + "\",\"rx\":\"\'\'\",\"rx_t\":\"\'\'\",\"DataSF\":\"\'" + self.DataSF + "\'\"}},{\"Activity_Stockist_Report\":{\"Stockist_POB\":\"\",\"Worked_With\":\"\'" + (lstPlnDetail[0]["worked_with_code"] as! String) + "\'\",\"location\":\"\'" + sLocation + "\'\",\"geoaddress\":\"" + sAddress + " \",\"superstockistid\":\"\'\'\",\"Stk_Meet_Time\":\"\'" + VisitData.shared.cInTime + "\'\",\"modified_time\":\"\'" + VisitData.shared.cInTime + "\'\",\"date_of_intrument\":\"\",\"intrumenttype\":\"\",\"orderValue\":\"\(totalAmountRound)\",\"Aob\":0,\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"CheckoutTime\":\"" + VisitData.shared.cInTime + "\",\"taxTotalValue\":\"\(taxAmountRound)\",\"discTotalValue\":\"\(discountAmountRound)\",\"subTotal\":\"\(subTotal)\",\"No_Of_items\":\"\(selectedProducts.count)\",\"PhoneOrderTypes\":1,\"doctor_id\":\"\'" + VisitData.shared.CustID + "\'\",\"stockist_code\":\"\'" + VisitData.shared.CustID + "\'\",\"version\":8,\"stockist_name\":\"\'" + VisitData.shared.CustName + " \'\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"}}},{\"Activity_Stk_POB_Report\":[\(productString)]},{\"Activity_Stk_Sample_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]},{\"Activity_Event_Captures_Call\":[]}]"
//        
//        print(jsonString)
//        
//        let params: Parameters = [
//            "data": jsonString
//        ]
//        
//        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode + "&rSF=" + self.SFCode + "&sfCode=" + self.SFCode)
//        
//            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode + "&rSF=" + self.SFCode + "&sfCode=" + self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseData {
//            AFdata in
//            self.LoadingDismiss()
//            PhotosCollection.shared.PhotoList = []
//            switch AFdata.result
//            {
//                
//            case .success(let value):
//                print(value)
//                
//                let apiResponse = try? JSONSerialization.jsonObject(with: AFdata.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
//                print(apiResponse as Any)
//                
//                VisitData.shared.selectedOrders = self.allProducts.filter({ product in
//                    let productQty = Int(product.sampleQty) ?? 0
//                    return productQty > 0
//                })
//                
//                
//                Toast.show(message: "Order has been submitted successfully", controller: self)
//                print(AFdata.response?.statusCode)
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    
//                    let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbCallPreview") as!  CallPreview
//                    vc.eKey = self.eKey
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    return
//                }
//                
//            case .failure(let error):
//                let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
//                    return
//                })
//                self.present(alert, animated: true)
//            }
//        }
//    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        if isValid() == false {
            return
        }
        
        vwSubmit.isHidden = false
        tbProductTableView.isHidden = true
        
        self.freeProducts = self.allProducts.filter{$0.freeCount != 0}
        SelectedProductTableView.reloadData()
        self.updateTotalPriceList()
        freeQtyTableView.reloadData()
        SelectedProductTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
    }
    
    
    @IBAction func homeAction(_ sender: UIButton) {
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
            tbProductTableView.isHidden = false
            
            self.products = self.allProducts.filter{$0.cateId == selectedBrand}
            tbProductTableView.reloadData()
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


struct SecondaryOrderNewSelectedList {
    
//    var productId : String!
//    var productName : String!
//    var unitId : String!
//    var unitName : String!
//    var unitConversion : String!
//    var rate : String!
//    var Qty : String!
    
    var product: ProductList!
    var distributorId : String!
    var distributorName : String!
    var subtotal : String!
    
  //  var selectedProduct : ProductList!
    
    init(product: ProductList!, distributorId: String!, distributorName: String!, subtotal: String!) {
        self.product = product
        self.distributorId = distributorId
        self.distributorName = distributorName
        self.subtotal = subtotal
    }
    
//    init(productId: String!,productName: String!, unitId: String!, unitName: String!, unitConversion: String!, rate: String!, Qty: String!, product: AnyObject!,distributorId:String!,distributorName:String!,item:AnyObject!,subtotal:String!,selectedProduct : ProductList!) {
//        self.productId = productId
//        self.productName = productName
//        self.unitId = unitId
//        self.unitName = unitName
//        self.unitConversion = unitConversion
//        self.rate = rate
//        self.Qty = Qty
//        self.product = product
//        self.distributorId = distributorId
//        self.distributorName = distributorName
//        self.item = item
//        self.subtotal = subtotal
//    }
    
    
}
