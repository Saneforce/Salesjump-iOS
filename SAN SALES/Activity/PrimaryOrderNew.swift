//
//  PrimaryOrderNew.swift
//  SAN SALES
//
//  Created by Naga Prasath on 01/10/24.
//

import Foundation
import Alamofire
import CoreLocation

class PrimaryOrderNew : IViewController, UITableViewDelegate, UITableViewDataSource ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
   
    
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    
    @IBOutlet weak var lblDistributorName: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    
    
    @IBOutlet weak var lblStockist: LabelSelect!
    
    
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
    
    
    
    
    @IBOutlet weak var supplierHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var selectedTableViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var freeQtyTableViewHeightConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var viewSuperStocistHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var vwSubmit: UIView!
    
    
    var axnEdit = "get/pmOrderDetails"
    
    struct lItem: Any {
        let id: String
        let name: String
    }
    
    var selectedBrand = ""
    var Trans_POrd_No = ""
    var vstDets: [String: lItem] = [:]
    
    var lObjSel: [AnyObject] = []
    var lAllObjSel: [AnyObject] = []
    
    var SelMode: String = ""
    
    var lstPlnDetail: [AnyObject] = []
    
    var lstBrands: [AnyObject] = []
    var lstAllProducts: [AnyObject] = []
    var lstProducts: [AnyObject] = []
    var lstPrvOrder: [AnyObject] = []
    var lstAllUnitList: [AnyObject] = []
    var lstUnitList: [AnyObject] = []
    var lstStockistSchemes: [AnyObject] = []
    var lstRateList: [AnyObject] = []
    var lstRandomNumbers : [AnyObject] = []
    var lstAllUnits : [AnyObject] = []
    var lstUnits : [AnyObject] = []
    var lstProductTax : [AnyObject] = []
    
    var lstSuppList: [AnyObject] = []
    var ProdImages:[String: Any] = [:]
    var BrandImages:[String: Any] = [:]
    var selBrand: String = ""
    var selUOM: String = ""
    var selUOMNm: String = ""
    var isMulti: Bool = false
    var eKey: String = ""
    var productData1 : String?
    var productData2 : String?
    var stockistCode : String?
    var objcallsprimary :[AnyObject] = []
    var TotaAmout: String=""
    var areypostion: Int?
    var lstJWNms: [AnyObject] = []
    var strJWCd: String = ""
    var strJWNm: String = ""
    var lstJoint: [AnyObject] = []
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    var net_weight_data = ""
    
    var products = [ProductList]()
    var selectedProducts = [ProductList]()
    var freeProducts = [ProductList]()
    var allProducts = [ProductList]()
    
    
    var isFromEdit : Bool!
    
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
        getUserDetails()
        
        if let sCode = stockistCode{
            VisitData.shared.CustID = sCode
        }
        
        let lstCatData: String=LocalStoreage.string(forKey: "Brand_Master")!
        let lstProdData: String = LocalStoreage.string(forKey: "Products_Master")!
        let lstUnitData: String = LocalStoreage.string(forKey: "UnitConversion")!
        let lstSchemData: String = LocalStoreage.string(forKey: "Schemes_Master")!
        let lstRateData: String = LocalStoreage.string(forKey: "Distributor_Rate")!
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        let lstRandomNumberData: String = LocalStoreage.string(forKey: "Random_Number")!
        let lstProductTaxData : String = LocalStoreage.string(forKey: "ProductTax_Master")!
        
        if let JointWData = LocalStoreage.string(forKey: "Jointwork_Master"),
           let list = GlobalFunc.convertToDictionary(text:  JointWData) as? [AnyObject] {
            lstJoint = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: lstCatData) as? [AnyObject] {
            lstBrands = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: lstRateData) as? [AnyObject] {
            lstRateList = list;
            print(lstRateList)
        }
        
        if let list = GlobalFunc.convertToDictionary(text: lstUnitData) as? [AnyObject] {
            lstAllUnits = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: lstSchemData) as? [AnyObject] {
            lstStockistSchemes = list;
            lstStockistSchemes = lstStockistSchemes.filter{($0["schemeFor"] as? String ?? "") == "P"}
            print(lstStockistSchemes)
        }
        
        if let list = GlobalFunc.convertToDictionary(text: lstProductTaxData) as? [AnyObject] {
            lstProductTax = list
        }
        
        if lstBrands.count>0{
            let item: [String: Any]=lstBrands[0] as! [String : Any]
            selBrand=String(format: "%@", item["id"] as! CVarArg)
            autoreleasepool{
                lstProducts = lstAllProducts.filter({(product) in
                    let CatId: String = String(format: "%@", product["cateid"] as! CVarArg)
                    return Bool(CatId == selBrand)
                })
            }
        }
        let lstDistData: String = LocalStoreage.string(forKey: "Supplier_Master_"+SFCode)!
        
        if let list = GlobalFunc.convertToDictionary(text: lstDistData) as? [AnyObject] {
            lstSuppList = list;
        }
        
        if let list = GlobalFunc.convertToDictionary(text: lstRandomNumberData) as? [AnyObject]{
            lstRandomNumbers = list
        }
        
        if let list = GlobalFunc.convertToDictionary(text: lstProdData) as? [AnyObject] {
            lstAllProducts = list;
            print(lstAllProducts)
            print(lstAllProducts.count)
            self.ShowLoading(Message: "Loading")
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                self.updateProduct(products: list)
                self.editMissedDateOrder()
                self.DemoEdite()
            }
//            DispatchQueue.main.async {
//                
//            }
        }
        
        lblStockist.addTarget(target: self, action: #selector(stkSelection))
        imgBack.addTarget(target: self, action: #selector(backVC))
        
        lblTitle.text = UserSetup.shared.PrimaryCaption
        lblName.text = VisitData.shared.CustName
        lblDate.text = VisitData.shared.OrderMode.name
        
        self.updateEditOrderValues()
        
        
        if UserSetup.shared.SuperStockistNeed != 1 {
            self.lblDistributorName.isHidden = true
            self.supplierHeightConstraints.constant = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
            
            let filteredArray = lstSuppList.filter {($0["id"] as? Int) == Int(self.selectedProductsforMissed.first?.distributorId ?? "0")}
            if (filteredArray.isEmpty){
                VisitData.shared.Dist.id = ""
                lblStockist.text = ""
            }else{
                VisitData.shared.Dist.id = String((filteredArray[0]["id"] as? Int)!)
                VisitData.shared.Dist.name = filteredArray[0]["name"] as? String ?? ""
                lblDistributorName.text = filteredArray[0]["name"] as? String
                lblName.text = filteredArray[0]["name"] as? String
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
    }
    
    
    func updateProduct( products: [AnyObject]) {
        
        
        for product in products {
            
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
                unitName = String(format: "%@", Units.first!["name"] as! CVarArg)
                unitId = String(format: "%@", Units.first!["id"] as! CVarArg)
                let conQty = String(format: "%@", Units.first!["ConQty"] as! CVarArg)
                unitCount = Int(conQty) ?? 0
            }
            
            let RateItems: [AnyObject] = lstRateList.filter ({ (Rate) in
                if Rate["Product_Detail_Code"] as! String == productId {
                    return true
                }
                return false
            })
            
            var rate : Double = 0
            var retailorPrice : Double = 0
//            if(RateItems.count>0){
//                print(lstRateList)
//                print(RateItems)
//                rate = (RateItems.first!["Distributor_Price"] as! NSString).doubleValue
//                retailorPrice = (RateItems.first!["Distributor_Price"] as! NSString).doubleValue
//
//                if let distLists = RateItems.first!["distList"] as? [AnyObject] {
//                    print(rateCards)
//
//                    print(VisitData.shared.Dist.id)
//                    print(VisitData.shared.CustID)
//                    let rateCards: [AnyObject] = distLists.filter ({ (Rate) in
//                        if Rate["Stockist_Code"] as! String == VisitData.shared.CustID {
//                            return true
//                        }
//                        return false
//                    })
//
//                    if (rateCards.count>0) {
//                        rate = (RateItems.first!["price"] as! NSString).doubleValue
//                        retailorPrice = (RateItems.first!["price"] as! NSString).doubleValue
//                    }
//                }
//            }
            
            
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
            var disCountValue : Double = 0
            var isSchemeActive = false
            
            var isMultiSchemeActive = false
            var multiScheme = [Scheme]()
            
            var scheme : Int = 0
            var offerAvailableCount : Int = 0
            var offerUnitName : String = ""
            var offerProductCode : String = ""
            var offerProductName:String = ""
            var package : String = ""
            var schemeType : String = ""
            var discountType : String = "%"
            var stockistCode : String = ""
            
            if UserSetup.shared.primarySchemeBased == "1" && UserSetup.shared.offerMode == 1 {
                
                let schemesItems = lstStockistSchemes.filter({ (product) in
                    let ProdId = String(format: "%@", product["PCode"] as! CVarArg)
                    return Bool(ProdId == productId)
                })
                
                if schemesItems.count > 0 {
                    
                    isSchemeActive = true
                    if let schValue = schemesItems.first!["Scheme"] as? String {
                        scheme = Int(schValue) ?? 0
                    }else if let schValue = schemesItems.first!["Scheme"] as? Int {
                        scheme = schValue
                    }
                    if let freeValue = schemesItems.first!["FQ"] as? String {
                        offerAvailableCount = Int(freeValue) ?? 0
                    }else if let freeValue = schemesItems.first!["FQ"] as? Int {
                        offerAvailableCount = freeValue
                    }
                    offerUnitName = schemesItems.first!["FreeUnit"] as? String ?? ""
                    offerProductCode = schemesItems.first!["OffProd"] as? String ?? ""
                    offerProductName = schemesItems.first!["OffProdNm"] as? String ?? ""
                    package = schemesItems.first!["pkg"] as? String ?? ""
                    schemeType = schemesItems.first!["schemeType"] as? String ?? ""
                    discountType = schemesItems.first!["Discount_Type"] as? String ?? ""
                    stockistCode = schemesItems.first!["Stockist_Code"] as? String ?? ""
                    
                    if discountType == "%" {
                        disCountPer = (schemesItems.first!["Disc"] as! NSString).doubleValue
                        disCountPer = Double(round(100 * disCountPer) / 100)
                    }else{
                        disCountValue = (schemesItems.first!["Disc"] as! NSString).doubleValue
                        disCountValue = Double(round(100 * disCountValue) / 100)
                    }
                    
                    if schemesItems.count > 1 {
                        
                        for schemesItem in schemesItems {
                            isMultiSchemeActive = true
                            
                            var scheme = 0 //(schemesItem["Scheme"] as? NSString ?? "").integerValue
                            if let schValue = schemesItem["Scheme"] as? String {
                                scheme = Int(schValue) ?? 0
                            }else if let schValue = schemesItem["Scheme"] as? Int {
                                scheme = schValue
                            }
                            var offerAvailableCount = 0 // (schemesItem["FQ"] as? NSString ?? "").integerValue
                            if let freeValue = schemesItem["FQ"] as? String {
                                offerAvailableCount = Int(freeValue) ?? 0
                            }else if let freeValue = schemesItem["FQ"] as? Int {
                                offerAvailableCount = freeValue
                            }
                            let offerUnitName = schemesItem["FreeUnit"] as? String ?? ""
                            let offerProductCode = schemesItem["OffProd"] as? String ?? ""
                            let offerProductName = schemesItem["OffProdNm"] as? String ?? ""
                            let package = schemesItem["pkg"] as? String ?? ""
                            let schemeType = schemesItem["schemeType"] as? String ?? ""
                            let discountType = schemesItem["Discount_Type"] as? String ?? ""
                            let stockistCode = schemesItems.first!["Stockist_Code"] as? String ?? ""
                            
                            var disCountPert : Double = 0
                            var discountValue : Double = 0
                            if discountType == "%" {
                                disCountPert = (schemesItem["Disc"] as! NSString).doubleValue
                                disCountPert = Double(round(100 * disCountPer) / 100)
                            }else {
                                discountValue = (schemesItem["Disc"] as! NSString).doubleValue
                                discountValue = Double(round(100 * discountValue) / 100)
                            }
                            
                            multiScheme.append(Scheme(disCountPer: disCountPert,disCountValue: discountValue, scheme: scheme, offerAvailableCount: offerAvailableCount, offerUnitName: offerUnitName, offerProductCode: offerProductCode, offerProductName: offerProductName, package: package, stockistCode: stockistCode,schemeType: schemeType,discountType: discountType))
                        }
                    }
                    
                }
            }
            
            
            if(RateItems.count>0){
                
                for item in RateItems {
                    print("Gooood")
                    rate = (item["Distributor_Price"] as! NSString).doubleValue
                    retailorPrice = (item["Distributor_Price"] as! NSString).doubleValue
                    
                    if let distLists = item["distList"] as? [AnyObject] {
                        print(distLists)
                        
                        let rateCards: [AnyObject] = distLists.filter ({ (Rate) in
                            if Rate["Stockist_Code"] as! String == VisitData.shared.CustID {
                                return true
                            }
                            return false
                        })
                        
                        if (rateCards.count>0) {
                            
                            if let rateValue = rateCards.first?["price"] as? String {
                                rate = Double(rateValue) ?? 0
                                retailorPrice = Double(rateValue) ?? 0
                            }else if let rateValue = rateCards.first?["price"] as? Int {
                                rate = Double(rateValue)
                                retailorPrice = Double(rateValue)
                            }else if let rateValue = rateCards.first?["price"] as? Double {
                                rate = rateValue
                                retailorPrice = rateValue
                            }
                        }
                    }
                    
                    self.allProducts.append(ProductList(product: product, productName: productName, productId: productId,cateId: cateId, rate: rate,rateEdited: "0",retailerPrice: retailorPrice,saleErpCode: saleErpCode,newWt: newWt, sampleQty: "",clQty: "",remarks: "",remarksId: "", selectedRemarks: [], disCountPer: disCountPer, disCountValue: disCountValue, disCountAmount: 0.0, freeCount: 0, unitId: unitId, unitName: unitName, unitCount: unitCount, taxper: tax, taxAmount: 0.0, totalCount: 0.0, isSchemeActive: isSchemeActive,scheme: scheme,offerAvailableCount: offerAvailableCount,offerUnitName: offerUnitName,offerProductCode: offerProductCode,offerProductName: offerProductName,package: package,schemeType: schemeType,discountType: discountType, isMultiSchemeActive: isMultiSchemeActive, stockistCode: stockistCode, multiScheme: multiScheme, competitorProduct: []))
                }
                
            }
           
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                    self.LoadingDismiss()
           // self.DemoEdite()
        }
    }
    
    func isValid() -> Bool {
        if UserSetup.shared.SuperStockistNeed == 1 {
            if VisitData.shared.Dist.id == "" {
                Toast.show(message: "Select the Supplier", controller: self)
                return false
            }
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
        } else {
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
            print(UserSetup.shared.primarySchemeBased)
            print(UserSetup.shared.offerMode)
            if UserSetup.shared.primarySchemeBased == "1" && UserSetup.shared.offerMode == 1{
                Cell.txtDisPer.borderStyle = .none
                Cell.txtDisPer.isUserInteractionEnabled = false
                Cell.txtFreeQty.isUserInteractionEnabled = false
            }else {
                Cell.txtDisPer.borderStyle = .none
                Cell.txtDisPer.isUserInteractionEnabled = false
                Cell.txtFreeQty.isUserInteractionEnabled = false
            }
            Cell.txtTaxPer.isUserInteractionEnabled = false
            Cell.imgScheme.addTarget(target: self, action: #selector(schemeAction))
            Cell.imgRateEdit.addTarget(target: self, action: #selector(rateEditAction))
            if UserSetup.shared.primaryRateEditable == 0 {
                Cell.imgRateEdit.isHidden = true
                Cell.imgRateEditWidthConstraint.constant = 0
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
            let distId = VisitData.shared.CustID
            if UserSetup.shared.primarySchemeBased == "1" && UserSetup.shared.offerMode == 1{
                if self.products[indexPath.row].stockistCode.contains(distId) && self.products[indexPath.row].isSchemeActive == true {
                    Cell.imgScheme.isHidden = false
                    Cell.imgSchemeWidthConstraint.constant = 25
                }else {
                    if products[indexPath.row].isSchemeActive == true{
                        Cell.imgScheme.isHidden = true
                        Cell.imgSchemeWidthConstraint.constant = 0
                        Cell.product.freeCount = 0
                        Cell.product.disCountPer = 0
                        Cell.product.disCountAmount = 0
                        Cell.product.disCountValue = 0
                        self.products[indexPath.row].freeCount = 0
                        self.products[indexPath.row].disCountPer = 0
                        self.products[indexPath.row].disCountAmount = 0
                        self.products[indexPath.row].disCountValue = 0
                    }
                }
            }else {
                Cell.imgScheme.isHidden = true
                Cell.imgSchemeWidthConstraint.constant = 0
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

            if UserSetup.shared.primarySchemeBased == "1" && UserSetup.shared.offerMode == 1{
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
        
        if sQty == 0 {
            if UserSetup.shared.primarySchemeBased == "0" &&  UserSetup.shared.offerMode == 1{
                cell.product.disCountPer = 0
                cell.product.freeCount = 0
            }
        }
        
        let id = VisitData.shared.CustID
        
        if cell.product.isMultiSchemeActive == true && cell.product.stockistCode.contains(id) {
            let totalQty = unitCount * sQty
            let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty,rate: rate)
            if scheme != nil {
                discountPer = scheme!.disCountPer
                cell.product.disCountPer = scheme!.disCountPer
            }
        }else {
            discountPer = cell.product.disCountPer
        }
        
        
        if cell.product.isSchemeActive == true && cell.product.stockistCode.contains(id) {
            let totalQty = unitCount * sQty
            
            if cell.product.package == "N" {
                if cell.product.isMultiSchemeActive == true {
                    
                    let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty, rate: rate)
                    
                    if scheme != nil {
                        print(scheme)
                        if scheme!.schemeType == "Q" {
                            if scheme!.discountType == "%" {
                                let schQty = scheme!.scheme
                                let value = Double(totalQty) /  Double(schQty)
                                cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
                            }else {
                                let schQty = scheme!.scheme
                                let value = Double(totalQty) /  Double(schQty)
                                cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
                                if Double(totalQty) >= Double(schQty){
                                    cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
                                    
                                    let total = Double(sQty) * rate * Double(unitCount)
                                    
                                    let amt = Int(Double(totalQty) / Double(scheme!.scheme))
                                    let disCountValuePer = Double(amt)  * scheme!.disCountValue
                                    
                                    let disCountPercentage = (disCountValuePer / total) * 100
                                    print(disCountPercentage)
                                    let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                    cell.product.disCountPer = discountPerRound
                                    cell.product.disCountAmount = disCountValuePer
                                    discountPer = discountPerRound
                                }else {
                                    cell.product.freeCount = 0
                                    cell.product.disCountPer = 0
                                    cell.product.disCountAmount = 0
                                }
                            }
                            
                        }else {
                            if scheme!.discountType == "%" {
                                let schQty = scheme!.scheme
                                let value = Double(totalQty) /  Double(schQty)
                                cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
                            }else {
//                                let schQty = scheme!.scheme
//                                let value = Double(totalQty) /  Double(schQty)
//                                cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
                                
                                let schQty = scheme!.scheme
                                let total = Double(sQty) * rate * Double(unitCount)
                                let value = Int(Double(total) /  Double(schQty))
                                if Double(total) >= Double(schQty){
                                    cell.product.freeCount = Int(Double(value) * Double(scheme!.offerAvailableCount))
                                    
                                    let total = Double(sQty) * rate * Double(unitCount)
                                    
                                    let amt = Int(Double(total) / Double(scheme!.scheme))
                                    let disCountValuePer = Double(amt)  * scheme!.disCountValue
                                    
                                    let disCountPercentage = (disCountValuePer / total) * 100
                                    print(disCountPercentage)
                                    let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                    cell.product.disCountPer = discountPerRound
                                    cell.product.disCountAmount = disCountValuePer
                                    discountPer = discountPerRound
                                }else {
                                    cell.product.freeCount = 0
                                    cell.product.disCountPer = 0
                                    cell.product.disCountAmount = 0
                                }
                            }
                        }
                        
                    }else{
                        cell.product.freeCount = 0
                    }
                }else {
                    if cell.product.schemeType == "Q" {
                        if cell.product.discountType == "%" {
                            let schQty = cell.product.scheme
                            let value = Double(totalQty) /  Double(schQty)
                            if Double(totalQty) >= Double(schQty){
                                cell.product.freeCount = Int(value * Double(cell.product.offerAvailableCount))
                            }else {
                                cell.product.freeCount = 0
                            }
                        }else {
                            let schQty = cell.product.scheme
                            let value = Double(totalQty) /  Double(schQty)
                            if Double(totalQty) >= Double(schQty){
                                cell.product.freeCount = Int(value * Double(cell.product.offerAvailableCount))
                                
                                let total = Double(sQty) * rate * Double(unitCount)
                                
                                let amt = Int(Double(totalQty) / Double(cell.product.scheme))
                                let disCountValuePer = Double(amt)  * cell.product.disCountValue
                                
                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                cell.product.disCountPer = discountPerRound
                                cell.product.disCountAmount = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                cell.product.freeCount = 0
                                cell.product.disCountPer = 0
                                cell.product.disCountAmount = 0
                            }
                        }
                    }else if cell.product.schemeType == "V" {
                        if cell.product.discountType == "%" {
                            let schQty = cell.product.scheme
                            let total = Double(sQty) * rate * Double(unitCount)
                            let value = Int(Double(total) /  Double(schQty))
                            if Double(total) >= Double(schQty){
                                cell.product.freeCount = Int(Double(value) * Double(cell.product.offerAvailableCount))
                            }else{
                                cell.product.freeCount = 0
                                cell.product.disCountPer = 0
                                cell.product.disCountAmount = 0
                            }
                        }else {
                            let schQty = cell.product.scheme
                            let total = Double(sQty) * rate * Double(unitCount)
                            let value = Int(Double(total) /  Double(schQty))
                            if Double(total) >= Double(schQty){
                                cell.product.freeCount = Int(Double(value) * Double(cell.product.offerAvailableCount))
                                
                                let total = Double(sQty) * rate * Double(unitCount)
                                
                                let amt = Int(Double(total) / Double(cell.product.scheme))
                                let disCountValuePer = Double(amt)  * cell.product.disCountValue
                                
                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                cell.product.disCountPer = discountPerRound
                                cell.product.disCountAmount = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                cell.product.freeCount = 0
                                cell.product.disCountPer = 0
                                cell.product.disCountAmount = 0
                            }
                        }
                    }
                    
                }
            }else {
                if cell.product.isMultiSchemeActive == true {
                    let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty, rate: rate)
                    
                    if scheme != nil {
                        if scheme?.schemeType == "Q" {
                            let schemeQty = totalQty / scheme!.scheme
                            cell.product.freeCount = schemeQty * scheme!.offerAvailableCount //  Int(value * Double(scheme!.offerAvailableCount))
                        }else {
                            let total = Double(sQty) * rate * Double(unitCount)
                            
                            print(total)
                            if Int(total / Double(cell.product.scheme)) >= 1 {
                                print(Int(total / Double(cell.product.scheme)))
                                cell.product.freeCount = Int(total / Double(cell.product.scheme)) * cell.product.offerAvailableCount
                                
                                let amt = Int(total / Double(cell.product.scheme))
                                let disCountValuePer = Double(amt)  * cell.product.disCountValue
                                
                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                cell.product.disCountPer = discountPerRound
                                cell.product.disCountAmount = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                cell.product.freeCount = 0
                                cell.product.disCountPer = 0
                                cell.product.disCountAmount = 0
                            }
                        }
                        
                    }else{
                        cell.product.freeCount = 0
                    }
                }else {
                    
                    if cell.product.schemeType == "Q" {
                        
                        if cell.product.discountType == "%" {
                            let schemeQty = totalQty / cell.product.scheme
                            if totalQty >= cell.product.scheme{
                                cell.product.freeCount = schemeQty * cell.product.offerAvailableCount
                            }else {
                                cell.product.freeCount = 0
                            }
                        }else {
                            let total = Double(sQty) * rate * Double(unitCount)
                            
                            print(total)
                            if Int(Double(totalQty) / Double(cell.product.scheme)) >= 1 {
                                print(Int(total / Double(cell.product.scheme)))
                                cell.product.freeCount = Int(Double(totalQty) / Double(cell.product.scheme)) * cell.product.offerAvailableCount
                                
                                let amt = Int(Double(totalQty) / Double(cell.product.scheme))
                                let disCountValuePer = Double(amt)  * cell.product.disCountValue
                                
                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                cell.product.disCountPer = discountPerRound
                                cell.product.disCountAmount = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                cell.product.freeCount = 0
                                cell.product.disCountPer = 0
                                cell.product.disCountAmount = 0
                            }
                        }
                        
                    }else {
                        if cell.product.discountType == "%" {
                            let schemeQty = totalQty / cell.product.scheme
                            if totalQty >= cell.product.scheme{
                                cell.product.freeCount = schemeQty * cell.product.offerAvailableCount
                            }else {
                                cell.product.freeCount = 0
                            }
                        }else {
                            let total = Double(sQty) * rate * Double(unitCount)
                            
                            print(total)
                            if Int(total / Double(cell.product.scheme)) >= 1 {
                                print(Int(total / Double(cell.product.scheme)))
                                cell.product.freeCount = Int(total / Double(cell.product.scheme)) * cell.product.offerAvailableCount
                                
                                let amt = Int(total / Double(cell.product.scheme))
                                let disCountValuePer = Double(amt)  * cell.product.disCountValue
                                
                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                cell.product.disCountPer = discountPerRound
                                cell.product.disCountAmount = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                cell.product.freeCount = 0
                                cell.product.disCountPer = 0
                                cell.product.disCountAmount = 0
                            }
                        }
                        
                    }
                    
                    
                }
                
            }
        }else {
            cell.product.freeCount = 0
            cell.product.disCountPer = 0
            cell.product.disCountAmount = 0
        }
        
        if cell.product.isSchemeActive == true {
            if cell.product.schemeType == "Q" {
                
                if cell.product.discountType == "%" {
                    let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100
                    
                    
                    
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
                }else {
                    let discountAmount = cell.product.disCountAmount // discountPer * Double(unitCount) * rate * Double(sQty) / 100
                    
                    
                    
                    let discountPerOneUnit = discountPer *  rate / 100
                    
                    let rateMinusDiscount = rate - discountPerOneUnit
                    
                    let taxAmount = taxPer * Double(unitCount) * rate * Double(sQty) / 100
                    
                    var total = Double(sQty) * rate * Double(unitCount)
                    total = total - discountAmount
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
                }
                
            }else {
                
                if cell.product.discountType == "%" {
                    let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100
                    
                    
                    
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
                }else {
                    let discountAmount = cell.product.disCountAmount // discountPer * Double(unitCount) * rate * Double(sQty) / 100
                    
                    
                    
                    let discountPerOneUnit = discountPer *  rate / 100
                    
                    let rateMinusDiscount = rate - discountPerOneUnit
                    
                    let taxAmount = taxPer * Double(unitCount) * rate * Double(sQty) / 100
                    
                    var total = Double(sQty) * rate * Double(unitCount)
                    total = total - discountAmount
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
                }
                
            }
        }else {
            let discountAmount = cell.product.disCountAmount
            
            
            
            let discountPerOneUnit = discountPer *  rate / 100
            
            let rateMinusDiscount = rate - discountPerOneUnit
            
            let taxAmount = taxPer * Double(unitCount) * rate * Double(sQty) / 100
            
            var total = Double(sQty) * rate * Double(unitCount)
            total = total - discountAmount
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
        }
        
        
        if let index = self.allProducts.firstIndex(where: { (productInfo) -> Bool in
            return cell.product.productId == productInfo.productId && cell.product.retailerPrice == productInfo.retailerPrice
        }){
            self.allProducts[index] = cell.product
        }
        if let index = self.products.firstIndex(where: { (productInfo) -> Bool in
            return cell.product.productId == productInfo.productId && cell.product.retailerPrice == productInfo.retailerPrice
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
                return cell.product.productId == productInfo.productId && cell.product.retailerPrice == productInfo.retailerPrice
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
            return cell.product.productId == productInfo.productId && cell.product.retailerPrice == productInfo.retailerPrice
        }){
            self.allProducts[index] = cell.product
        }
        
        self.updateTotal()
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
    
    @objc private func schemeAction(_ sender : UITapGestureRecognizer){
        let cell: SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderListTableViewCell
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        print("success")
        print(cell.product.productId)
        print(lstStockistSchemes)
        if cell.product.isMultiSchemeActive == true {
            AlertData.shared.title = cell.product.productName
            
            AlertData.shared.scheme = cell.product.multiScheme
            
        }else {
            
            AlertData.shared.title = cell.product.productName
            
            let scheme = Scheme(disCountPer: cell.product.disCountPer, disCountValue: cell.product.disCountValue, scheme: cell.product.scheme, offerAvailableCount: cell.product.offerAvailableCount, offerUnitName: cell.product.offerUnitName, offerProductCode: cell.product.offerProductCode, offerProductName: cell.product.offerProductName, package: cell.product.package, stockistCode: cell.product.stockistCode,schemeType: cell.product.schemeType,discountType: cell.product.discountType)
            
            var schemes = [Scheme]()
            schemes.append(scheme)
            
            AlertData.shared.scheme = schemes
            
        }
        let alertView = CustomAlertVCViewController()
        alertView.show()
        
    }
    
    @objc private func rateEditAction(_ sender : UITapGestureRecognizer) {
        let cell: SuperStockistOrderListTableViewCell = GlobalFunc.getTableViewCell(view: sender.view!) as! SuperStockistOrderListTableViewCell
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        let editView = RateEditViewController<Any>()
        editView.rate = cell.product.rate
        editView.updateRate = { rate in
            
            cell.product.rateEdited = "1"
            cell.product.rate = rate as! Double
            
            self.calculationForOrderCell(cell: cell)
            self.dismiss(animated: true)
        }
        editView.show()
    }
    
    func nextLessThanValue(in array: [Scheme], comparedTo value: Int,rate : Double) -> Scheme? {
        var nextLessThan: Scheme?
        
        for element in array {
            print(element)
            if element.schemeType == "V" {
                print(Double(element.scheme))
                print((Double(value) * rate))
                if Double(element.scheme) <= (Double(value) * rate) {
                    if nextLessThan == nil || element.scheme >= (nextLessThan?.scheme ?? 0) {
                        nextLessThan = element
                    }
                }
            }else {
                print(value)
                print(element.scheme)
                print((nextLessThan?.scheme ?? 0))
                if element.scheme <= value {
                    if nextLessThan?.schemeType == "V" {
                        nextLessThan = nil
                    }
                    if nextLessThan == nil || element.scheme >= (nextLessThan?.scheme ?? 0) {
                        nextLessThan = element
                    }
                }
            }
            
        }
        
        return nextLessThan
    }
    
    func calculationForSelectedOrderCell(cell : SuperStockistOrderSelectedListViewCell) {
        
        var discountPer : Double = 0
        
        let taxPer = cell.product.taxper
        
        let unitCount = cell.product.unitCount
        let rate = cell.product.rate
        let sQty = Int(cell.product.sampleQty) ?? 0
        print("QTYYYY \(sQty)")
        let id = VisitData.shared.CustID
        
        if cell.product.isMultiSchemeActive == true && cell.product.stockistCode.contains(id) {
            let totalQty = unitCount * sQty
            let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty, rate: rate)
            if scheme != nil {
                discountPer = scheme!.disCountPer
                cell.product.disCountPer = scheme!.disCountPer
            }
        }else {
            discountPer = cell.product.disCountPer
        }
        
        
        
        if cell.product.isSchemeActive == true  && cell.product.stockistCode.contains(id){
            let totalQty = unitCount * sQty
            
            if cell.product.package == "N" {
                if cell.product.isMultiSchemeActive == true {
                    
                    let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty, rate: rate)
                    
                    if scheme != nil {
                        print(scheme)
                        if scheme!.schemeType == "Q" {
                            if scheme!.discountType == "%" {
                                let schQty = scheme!.scheme
                                let value = Double(totalQty) /  Double(schQty)
                                cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
                            }else {
                                let schQty = scheme!.scheme
                                let value = Double(totalQty) /  Double(schQty)
                                cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
                            }
                            
                        }else {
                            if scheme!.discountType == "%" {
                                let schQty = scheme!.scheme
                                let value = Double(totalQty) /  Double(schQty)
                                cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
                            }else {
                                let schQty = scheme!.scheme
                                let value = Double(totalQty) /  Double(schQty)
                                cell.product.freeCount = Int(value * Double(scheme!.offerAvailableCount))
                            }
                        }
                        
                    }else{
                        cell.product.freeCount = 0
                    }
                }else {
                    if cell.product.schemeType == "Q" {
                        if cell.product.discountType == "%" {
                            let schQty = cell.product.scheme
                            let value = Double(totalQty) /  Double(schQty)
                            if Double(totalQty) >= Double(schQty){
                                cell.product.freeCount = Int(value * Double(cell.product.offerAvailableCount))
                            }else {
                                cell.product.freeCount = 0
                            }
                        }else {
                            let schQty = cell.product.scheme
                            let value = Double(totalQty) /  Double(schQty)
                            if Double(totalQty) >= Double(schQty){
                                cell.product.freeCount = Int(value * Double(cell.product.offerAvailableCount))
                                
                                let total = Double(sQty) * rate * Double(unitCount)
                                
                                let amt = Int(Double(totalQty) / Double(cell.product.scheme))
                                let disCountValuePer = Double(amt)  * cell.product.disCountValue
                                
                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                cell.product.disCountPer = discountPerRound
                                cell.product.disCountAmount = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                cell.product.freeCount = 0
                                cell.product.disCountPer = 0
                                cell.product.disCountAmount = 0
                            }
                        }
                    }else if cell.product.schemeType == "V" {
                        if cell.product.discountType == "%" {
                            let schQty = cell.product.scheme
                            let total = Double(sQty) * rate * Double(unitCount)
                            let value = Int(Double(total) /  Double(schQty))
                            if Double(total) >= Double(schQty){
                                cell.product.freeCount = Int(Double(value) * Double(cell.product.offerAvailableCount))
                            }
                        }else {
                            let schQty = cell.product.scheme
                            let total = Double(sQty) * rate * Double(unitCount)
                            let value = Int(Double(total) /  Double(schQty))
                            if Double(total) >= Double(schQty){
                                cell.product.freeCount = Int(Double(value) * Double(cell.product.offerAvailableCount))
                                
                                let total = Double(sQty) * rate * Double(unitCount)
                                
                                let amt = Int(Double(total) / Double(cell.product.scheme))
                                let disCountValuePer = Double(amt)  * cell.product.disCountValue
                                
                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                cell.product.disCountPer = discountPerRound
                                cell.product.disCountAmount = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                cell.product.freeCount = 0
                                cell.product.disCountPer = 0
                                cell.product.disCountAmount = 0
                            }
                        }
                    }
                    
                }
            }else {
                if cell.product.isMultiSchemeActive == true {
                    let scheme = self.nextLessThanValue(in: cell.product.multiScheme, comparedTo: totalQty, rate: rate)
                    
                    if scheme != nil {
                        if scheme?.schemeType == "Q" {
                            let schemeQty = totalQty / scheme!.scheme
                            cell.product.freeCount = schemeQty * scheme!.offerAvailableCount //  Int(value * Double(scheme!.offerAvailableCount))
                        }else {
                            let total = Double(sQty) * rate * Double(unitCount)
                            
                            print(total)
                            if Int(total / Double(cell.product.scheme)) > 1 {
                                print(Int(total / Double(cell.product.scheme)))
                                cell.product.freeCount = Int(total / Double(cell.product.scheme)) * cell.product.offerAvailableCount
                                
                                let amt = Int(total / Double(cell.product.scheme))
                                let disCountValuePer = Double(amt)  * cell.product.disCountValue
                                
                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                cell.product.disCountPer = discountPerRound
                                cell.product.disCountAmount = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                cell.product.freeCount = 0
                                cell.product.disCountPer = 0
                                cell.product.disCountAmount = 0
                            }
                        }
                        
                    }else{
                        cell.product.freeCount = 0
                    }
                }else {
                    
                    if cell.product.schemeType == "Q" {
                        
                        if cell.product.discountType == "%" {
                            let schemeQty = totalQty / cell.product.scheme
                            if totalQty >= cell.product.scheme{
                                cell.product.freeCount = schemeQty * cell.product.offerAvailableCount
                            }
                        }else {
                            let total = Double(sQty) * rate * Double(unitCount)
                            
                            print(total)
                            if Int(Double(totalQty) / Double(cell.product.scheme)) >= 1 {
                                print(Int(total / Double(cell.product.scheme)))
                                cell.product.freeCount = Int(Double(totalQty) / Double(cell.product.scheme)) * cell.product.offerAvailableCount
                                
                                let amt = Int(Double(totalQty) / Double(cell.product.scheme))
                                let disCountValuePer = Double(amt)  * cell.product.disCountValue
                                
                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                cell.product.disCountPer = discountPerRound
                                cell.product.disCountAmount = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                cell.product.freeCount = 0
                                cell.product.disCountPer = 0
                                cell.product.disCountAmount = 0
                            }
                        }
                        
                    }else {
                        if cell.product.discountType == "%" {
                            let schemeQty = totalQty / cell.product.scheme
                            if totalQty >= cell.product.scheme{
                                cell.product.freeCount = schemeQty * cell.product.offerAvailableCount
                            }
                        }else {
                            let total = Double(sQty) * rate * Double(unitCount)
                            
                            print(total)
                            if Int(total / Double(cell.product.scheme)) > 1 {
                                print(Int(total / Double(cell.product.scheme)))
                                cell.product.freeCount = Int(total / Double(cell.product.scheme)) * cell.product.offerAvailableCount
                                
                                let amt = Int(total / Double(cell.product.scheme))
                                let disCountValuePer = Double(amt)  * cell.product.disCountValue
                                
                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                cell.product.disCountPer = discountPerRound
                                cell.product.disCountAmount = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                cell.product.freeCount = 0
                                cell.product.disCountPer = 0
                                cell.product.disCountAmount = 0
                            }
                        }
                        
                    }
                    
                    
                }
                
            }
        }
        
        if cell.product.schemeType == "Q" {
            if cell.product.discountType == "%" {
                let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100
                
                let discountPerOneUnit = discountPer *  rate / 100
                
                let rateMinusDiscount = rate - discountPerOneUnit
                
                let taxAmount = taxPer * Double(unitCount) * rateMinusDiscount * Double(sQty) / 100
                
                var total = Double(sQty) * rateMinusDiscount * Double(unitCount)
                
                total = total + taxAmount
                
                let discountAmountRound = Double(round(100 * discountAmount) / 100)
                let taxAmountRound = Double(round(100 * taxAmount) / 100)
                let totalAmountRound = Double(round(100 * total) / 100)
                
                cell.lblDisc.text =   CurrencyUtils.formatCurrency(amount: (discountAmountRound), currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.lblTax.text =  CurrencyUtils.formatCurrency(amount: taxAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.product.taxAmount = taxAmountRound
                cell.product.disCountAmount = discountAmountRound
                cell.product.totalCount = totalAmountRound
                
                cell.lblTotal.text = CurrencyUtils.formatCurrency(amount: totalAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
            }else {
                let discountAmount = cell.product.disCountValue
                
                let discountPerOneUnit = discountPer *  rate / 100
                
                let rateMinusDiscount = rate - discountPerOneUnit
                
                let taxAmount = taxPer * Double(unitCount) * rate * Double(sQty) / 100
                
                var total = Double(sQty) * rate * Double(unitCount)
                total = total - discountAmount
                total = total + taxAmount
                
                let discountAmountRound = Double(round(100 * discountAmount) / 100)
                let taxAmountRound = Double(round(100 * taxAmount) / 100)
                let totalAmountRound = Double(round(100 * total) / 100)
                
                cell.lblDisc.text = CurrencyUtils.formatCurrency(amount: discountAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.lblTax.text = CurrencyUtils.formatCurrency(amount: taxAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                cell.product.taxAmount = taxAmountRound
                cell.product.disCountAmount = discountAmountRound
                cell.product.totalCount = totalAmountRound
                
                
                cell.lblTotal.text = CurrencyUtils.formatCurrency(amount: totalAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
            }
            
        }else if UserSetup.shared.primarySchemeBased == "0" && UserSetup.shared.offerMode == 1{
            if cell.product.discountType == "%" {
                let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100
                
                let discountPerOneUnit = discountPer *  rate / 100
                
                let rateMinusDiscount = rate - discountPerOneUnit
                
                let taxAmount = taxPer * Double(unitCount) * rateMinusDiscount * Double(sQty) / 100
                
                var total = Double(sQty) * rateMinusDiscount * Double(unitCount)
                
                total = total + taxAmount
                
                let discountAmountRound = Double(round(100 * discountAmount) / 100)
                let taxAmountRound = Double(round(100 * taxAmount) / 100)
                let totalAmountRound = Double(round(100 * total) / 100)
            
                cell.lblDisc.text = CurrencyUtils.formatCurrency(amount: discountAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.lblTax.text = CurrencyUtils.formatCurrency(amount: taxAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.product.taxAmount = taxAmountRound
                cell.product.disCountAmount = discountAmountRound
                cell.product.totalCount = totalAmountRound
                
                cell.lblTotal.text = CurrencyUtils.formatCurrency(amount: totalAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
            }else {
                let discountAmount = cell.product.disCountPer
                
                let discountPerOneUnit = discountPer *  rate / 100
                
                let rateMinusDiscount = rate - discountPerOneUnit
                
                let taxAmount = taxPer * Double(unitCount) * rate * Double(sQty) / 100
                
                var total = Double(sQty) * rate * Double(unitCount)
                total = total - discountAmount
                total = total + taxAmount
                
                let discountAmountRound = Double(round(100 * discountAmount) / 100)
                let taxAmountRound = Double(round(100 * taxAmount) / 100)
                let totalAmountRound = Double(round(100 * total) / 100)
                
                cell.lblDisc.text = CurrencyUtils.formatCurrency(amount: discountAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.lblTax.text = CurrencyUtils.formatCurrency(amount: taxAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.product.taxAmount = taxAmountRound
                cell.product.disCountAmount = discountAmountRound
                cell.product.totalCount = totalAmountRound
                
                cell.lblTotal.text = CurrencyUtils.formatCurrency(amount: totalAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
            }
        }else  {
            if cell.product.discountType == "%" {
                let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100
                
                let discountPerOneUnit = discountPer *  rate / 100
                
                let rateMinusDiscount = rate - discountPerOneUnit
                
                let taxAmount = taxPer * Double(unitCount) * rateMinusDiscount * Double(sQty) / 100
                
                var total = Double(sQty) * rateMinusDiscount * Double(unitCount)
                
                total = total + taxAmount
                
                let discountAmountRound = Double(round(100 * discountAmount) / 100)
                let taxAmountRound = Double(round(100 * taxAmount) / 100)
                let totalAmountRound = Double(round(100 * total) / 100)
                
                
                cell.lblDisc.text = CurrencyUtils.formatCurrency(amount: discountAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.lblTax.text = CurrencyUtils.formatCurrency(amount: taxAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.product.taxAmount = taxAmountRound
                cell.product.disCountAmount = discountAmountRound
                cell.product.totalCount = totalAmountRound
                
                cell.lblTotal.text = CurrencyUtils.formatCurrency(amount: totalAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
            }else {
                let discountAmount = cell.product.disCountValue
                
                let discountPerOneUnit = discountPer *  rate / 100
                
                let rateMinusDiscount = rate - discountPerOneUnit
                
                let taxAmount = taxPer * Double(unitCount) * rate * Double(sQty) / 100
                
                var total = Double(sQty) * rate * Double(unitCount)
                total = total - discountAmount
                total = total + taxAmount
                
                let discountAmountRound = Double(round(100 * discountAmount) / 100)
                let taxAmountRound = Double(round(100 * taxAmount) / 100)
                let totalAmountRound = Double(round(100 * total) / 100)
                
                cell.lblDisc.text = CurrencyUtils.formatCurrency(amount: discountAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.lblTax.text = CurrencyUtils.formatCurrency(amount: taxAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
                
                cell.product.taxAmount = taxAmountRound
                cell.product.disCountAmount = discountAmountRound
                cell.product.totalCount = totalAmountRound
                
                cell.lblTotal.text = CurrencyUtils.formatCurrency(amount: totalAmountRound, currencySymbol: UserSetup.shared.currency_symbol)
            }
            
        }
        
        
        
        
        if let index = self.allProducts.firstIndex(where: { (productInfo) -> Bool in
            return cell.product.productId == productInfo.productId && cell.product.retailerPrice == productInfo.retailerPrice
        }){
            self.allProducts[index] = cell.product
        }
        if let index = self.selectedProducts.firstIndex(where: { (productInfo) -> Bool in
            return cell.product.productId == productInfo.productId && cell.product.retailerPrice == productInfo.retailerPrice
        }){
            self.selectedProducts[index] = cell.product
        }
        self.updateTotalPriceList()
        self.freeQtyTableView.reloadData()
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
    
    @objc private func deleteProduct (_ sender : UIButton) {
        let cell:SuperStockistOrderSelectedListViewCell = GlobalFunc.getTableViewCell(view: sender) as! SuperStockistOrderSelectedListViewCell
        
        self.selectedProducts.removeAll{$0.productId == cell.product.productId}
        self.allProducts.removeAll{$0.productId == cell.product.productId}
        
        self.allProducts.append(ProductList(product: cell.product.product, productName: cell.product.productName, productId: cell.product.productId,cateId: cell.product.cateId, rate: cell.product.rate,rateEdited: cell.product.rateEdited,retailerPrice: cell.product.retailerPrice,saleErpCode: cell.product.saleErpCode,newWt: cell.product.newWt, sampleQty: "",clQty: "",remarks: "",remarksId: "", selectedRemarks: cell.product.selectedRemarks, disCountPer: cell.product.disCountPer, disCountValue: cell.product.disCountValue, disCountAmount: 0.0, freeCount: 0, unitId: cell.product.unitId, unitName: cell.product.unitName, unitCount: cell.product.unitCount, taxper: cell.product.taxper, taxAmount: 0.0, totalCount: 0.0, isSchemeActive: cell.product.isSchemeActive,scheme: cell.product.scheme,offerAvailableCount: cell.product.offerAvailableCount,offerUnitName: cell.product.offerUnitName,offerProductCode: cell.product.offerProductCode,offerProductName: cell.product.offerProductName,package: cell.product.package,schemeType: cell.product.schemeType,discountType: cell.product.discountType,isMultiSchemeActive: cell.product.isMultiSchemeActive, stockistCode: cell.product.stockistCode,multiScheme: cell.product.multiScheme, competitorProduct: []))
        
        
        self.SelectedProductTableView.reloadData()
        self.updateTotalPriceList()
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
    
    func updateTotalPriceList(){
        
        let selectedProducts = self.allProducts.filter({ product in
            let productQty = Int(product.sampleQty) ?? 0
            return productQty > 0
        })
                
        self.lblPriceItems.text = "Price (\(selectedProducts.count)) items"
        
        let totalAmount = self.allProducts.map{$0.totalCount}.reduce(0){$0 + $1}
       
        self.lblPriceAmount.text = CurrencyUtils.formatCurrency(amount:(Double(round(100 * totalAmount) / 100)), currencySymbol: UserSetup.shared.currency_symbol)
        
        let totalUnits = selectedProducts.map{$0.totalUnits()}.reduce(0){$0 + $1}
        self.lblTotalQty.text = "\(totalUnits)"
        
        
        self.lblTotalPayment.text = CurrencyUtils.formatCurrency(amount:(Double(round(100 * totalAmount) / 100)), currencySymbol: UserSetup.shared.currency_symbol)
        
        self.lblFinalItems.text = "Items : \(selectedProducts.count)"
        
        
        self.lblFinalRate.text = CurrencyUtils.formatCurrency(amount:(Double(round(100 * totalAmount) / 100)), currencySymbol: UserSetup.shared.currency_symbol)
        
    }
    
    func updateTotal() {
        
        let totalAmount = self.allProducts.map{$0.totalCount}.reduce(0){$0 + $1}
        
        self.lblTotalRate.text =  CurrencyUtils.formatCurrency(amount: (Double(round(100 * totalAmount) / 100)), currencySymbol: UserSetup.shared.currency_symbol)
        let totalItems = self.allProducts.filter({ product in
            let productQty = Int(product.sampleQty) ?? 0
            return productQty > 0
        })
        
        self.lblTotalItems.text = "Items : \(totalItems.count)"
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
    
    func validateDoubleInput(textField: UITextField) -> Double? {
      guard let text = textField.text, !text.isEmpty else {
        return nil
      }
      return Double(text)
    }
    
    @objc private func stkSelection(){
        let distributorVC = ItemViewController(items: lstSuppList, configure: { (Cell : SingleSelectionTableViewCell, distributor) in
            Cell.textLabel?.text = distributor["name"] as? String
        })
        distributorVC.title = "Select the Distributor"
        distributorVC.didSelect = { selectedDistributor in
            let item: [String: Any]=selectedDistributor as! [String : Any]
            let name=item["name"] as! String
            let id=String(format: "%@", item["id"] as! CVarArg)
            
            self.lblStockist.text = name
            self.lblDate.text = name
            VisitData.shared.Dist.name = name
            VisitData.shared.Dist.id = id
           // self.Stockist_Code = id
            
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(distributorVC, animated: true)
    }
    
    @objc func backVC() {
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
    
    
    func OrderSubmit(sLocation: String,sAddress: String){
        var lstPlnDetail: [AnyObject] = []
        var DataSF = ""
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
            
            
            if UserSetup.shared.primarySchemeBased == "1" && UserSetup.shared.offerMode == 1 {
                scheme = product.scheme
                offerProductCode = product.offerProductCode
                offerProductName = product.offerProductName
                freePCount = product.offerProductCode
                freePName = product.productName
            }
            
             
            let productStr =   "{\"product_code\":\"\(product.productId)\",\"product_Name\":\"\(product.productName)\",\"rx_Conqty\":\(product.sampleQty),\"Qty\":\(qty),\"PQty\":0,\"cb_qty\":0,\"free\":\(product.freeCount),\"Pfree\":0,\"Rate\":\(product.rate),\"PieseRate\":\(product.rate),\"discount\":\(product.disCountPer),\"FreeP_Code\":\"\(freePCount)\",\"Fname\":\"\(freePName)\",\"discount_price\":\(product.disCountAmount),\"tax\":\(product.taxper),\"tax_price\":\((product.taxAmount)),\"OrdConv\":\(product.unitCount),\"product_unit_name\":\"\(product.unitName)\",\"rateedited\":\(product.rateEdited),\"distributor_price\":\(product.retailerPrice),\"selectedScheme\":\(scheme),\"selectedOffProCode\":\"\(product.unitId)\",\"selectedOffProName\":\"\(product.unitName)\",\"selectedOffProUnit\":\"\(product.unitCount)\",\"f_key\":{\"activity_stockist_code\":\"Activity_Stockist_Report\"}},"
            
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
        
        let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"'\(self.lstPlnDetail[0]["worktype"] as! String)'\",\"Town_code\":\"'" + (self.lstPlnDetail[0]["clusterid"] as! String) + "'\",\"RateEditable\":\"''\",\"dcr_activity_date\":\"'" + VisitData.shared.cInTime + "'\",\"Daywise_Remarks\":\"" + VisitData.shared.VstRemarks.name.trimmingCharacters(in: .whitespacesAndNewlines) + "\",\"eKey\":\"" + self.eKey + "\",\"rx\":\"'1'\",\"rx_t\":\"''\",\"DataSF\":\"'" + DataSF + "'\"}},{\"Activity_Stockist_Report\":{\"Stockist_POB\":\"" + VisitData.shared.PayValue + "\",\"Worked_With\":\"'" + (lstPlnDetail[0]["worked_with_code"] as! String) + "'\",\"location\":\"'" + sLocation + "'\",\"geoaddress\":\"" + sAddress + "\",\"superstockistid\":\"''\",\"Stk_Meet_Time\":\"'" + VisitData.shared.cInTime + "'\",\"modified_time\":\"'" + VisitData.shared.cInTime + "'\",\"date_of_intrument\":\"" + VisitData.shared.DOP.id + "\",\"intrumenttype\":\""+VisitData.shared.PayType.id+"\",\"orderValue\":\(totalAmount),\"Aob\":0,\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"CheckoutTime\":\"" + VisitData.shared.cOutTime + "\",\"PhoneOrderTypes\":" + VisitData.shared.OrderMode.id + ",\"Super_Stck_code\":\"'\(VisitData.shared.Dist.id)'\",\"stockist_code\":\"'" + VisitData.shared.CustID + "'\",\"stockist_name\":\"''\",\"f_key\":{\"Activity_Report_Code\":\"'Activity_Report_APP'\"}}},{\"Activity_Stk_POB_Report\":[" + productString +  "]},{\"Activity_Stk_Sample_Report\":[]},{\"Activity_Event_Captures\":[" + sImgItems +  "]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]},{\"Activity_Event_Captures_Call\":[]}]"
        
        
        
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
    
    func EditSubmit(sLocation: String,sAddress: String){
        
        var lstPlnDetail: [AnyObject] = []
        var DataSF = ""
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
            
            let id = VisitData.shared.Dist.id
            
            if UserSetup.shared.primarySchemeBased == "1" && UserSetup.shared.offerMode == 1 {
                scheme = product.scheme
                offerProductCode = product.offerProductCode
                offerProductName = product.offerProductName
                freePCount = product.offerProductCode
                freePName = product.productName
            }
            
            
            let productStr = "{\"product_code\":\"\(product.productId)\",\"product_Name\":\"\(product.productName)\",\"rx_Conqty\":\"\(product.sampleQty)\",\"Qty\":\"\(qty)\",\"PQty\":0,\"cb_qty\":0,\"free\":\"\(product.freeCount)\",\"Pfree\":0,\"Rate\":\"\(product.rate)\",\"PieseRate\":\"\(product.rate)\",\"discount\":\(product.disCountPer),\"FreeP_Code\":\"\(freePCount)\",\"Fname\":\"\(freePName)\",\"discount_price\":\(product.disCountAmount),\"tax\":\(product.taxper),\"tax_price\":\(product.taxAmount),\"OrdConv\":\(product.unitCount),\"product_unit_name\":\"\(product.unitName)\",\"Trans_POrd_No\":\"\",\"Order_Flag\":\"0\",\"Division_code\":\"0\",\"rateedited\":\(product.rateEdited),\"distributor_price\":\(product.retailerPrice),\"selectedScheme\":\(scheme),\"selectedOffProCode\":\"\(offerProductCode)\",\"selectedOffProName\":\"\(offerProductName)\",\"selectedOffProUnit\":\"\(product.unitCount)\",\"sample_qty\":\"\(product.totalCount)\"},"
            
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
        
        let dateString = "2023-07-28 14:39:09"
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var Date_Time =  ""
        if let date = dateFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formattedDate = outputFormatter.string(from: date)
            Date_Time = formattedDate
            print("Formatted Date and Time: \(formattedDate)")
        } else {
            print("Failed to convert the string to a date.")
        }
        
        
        let jsonString = "{\"Products\":[" + productString + "],\"Activity_Event_Captures\":[],\"POB\":\"0\",\"Value\":\"\(totalAmountRound)\",\"order_No\":\"\(objcallsprimary[0]["Order_No"] as! String)\",\"DCR_Code\":\"\(objcallsprimary[0]["DCR_Code"] as! String)\",\"Trans_Sl_No\":\"\(objcallsprimary[0]["DCR_Code"] as! String)\",\"Trans_Detail_slNo\":\"\(objcallsprimary[0]["Trans_Detail_SlNo"] as! String)\",\"Route\":\"\",\"net_weight_value\":\"\(net_weight_data)\",\"target\":\"\",\"rateMode\":null,\"Stockist\":\"\(objcallsprimary[0]["stockist_code"] as! String)\",\"RateEditable\":\"\",\"orderValue\":\"\(totalAmountRound)\",\"Stockist_POB\":\"" + VisitData.shared.PayValue + "\",\"Stk_Meet_Time\":\"\(Date_Time)\",\"modified_time\":\"\(Date_Time)\",\"CheckoutTime\":\"\(Date_Time)\",\"PhoneOrderTypes\":0,\"dcr_activity_date\":\"\(Date_Time)\",\"Super_Stck_code\":\"\(VisitData.shared.Dist.id)\"}"

        
        let params: Parameters = [ "data": jsonString ]
        
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/updatePrimaryProducts&divisionCode=" + self.DivCode + "&sfCode=" + self.SFCode + "&desig=" + self.Desig) // http://appssjdev.salesjump.in/server/native_Db_V13.php?axn=dcr%2FupdatePrimaryProducts&divisionCode=258%2C&sfCode=SJQAMGR0005&desig=MR
        print(params)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/updatePrimaryProducts&divisionCode=" + self.DivCode + "&sfCode=" + self.SFCode + "&desig=" + self.Desig, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseData {
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
    
    func OrderSubmitMissedDate(sLocation: String, sAddress: String){
        
        for i in 0..<products.count {
            
            let totalAmount = self.allProducts.map{$0.totalCount}.reduce(0){$0 + $1}
            let totalAmountRound = Double(round(100 * totalAmount) / 100)
            
            self.productsforMissed.append(SecondaryOrderNewSelectedList(product: products[i], distributorId: VisitData.shared.Dist.id, distributorName: VisitData.shared.Dist.name, subtotal: "\(totalAmountRound)"))
            
        }
        
        missedDateEditData(self.productsforMissed)
        self.LoadingDismiss()
        PhotosCollection.shared.PhotoList = []
        VisitData.shared.clear()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateEditOrderValues(){
        let item = productData1
        let item2 = productData2
        
        if let unwrappedProduct = item,let unwrappedProduct2 = item2 {
            
            let apiKey: String = "\(axnEdit)&State_Code=\(StateCode)&Trans_Detail_SlNo=\(unwrappedProduct)&Order_No=\(unwrappedProduct2)"
            
            
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                AFdata in
                switch AFdata.result
                {
                    
                case .success(let value):
                    //print(value)
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
                        if let Super_Stockist_Code = json[0]["Super_Stockist_Code"] as? String{
                            let FilterData  = lstSuppList.filter{ ($0["id"] as? String) == Super_Stockist_Code}
                            lblStockist.text = FilterData.first?["name"] as? String ?? ""
                            VisitData.shared.Dist.name = FilterData.first?["name"] as? String ?? ""
                            VisitData.shared.Dist.id = FilterData.first?["id"] as? String ?? ""
                        }
                        self.objcallsprimary = json
                        DemoEdite()
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)  //, controller: self
                }
            }
        } else {
            // The optional value is nil
            print("Product is nil")
        }
    }
    
    
    func DemoEdite(){
        
        print(objcallsprimary)
        
        for item in objcallsprimary{
            print(item)
            print(lstSuppList)
            let id: String
            let lProdItem:[String: Any]
            let Product_Code = item["Product_Code"] as! String
            
            var BasUnitCode: Int = 0
            let indexToDelete = lstAllProducts.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == "\(String(describing: Product_Code))" })
            let stkname = lstAllProducts[indexToDelete!]
            lProdItem = stkname as! [String : Any]
            id=String(format: "%@", lstAllProducts[indexToDelete!]["id"] as! CVarArg)
            let sUom = item["Product_Code"] as? String
            if let baseUnitCodeStr = lstAllProducts[indexToDelete!]["Base_Unit_code"] as? String,
               let baseUnitCodeInt = Int(baseUnitCodeStr) {
                BasUnitCode = baseUnitCodeInt
                
            }
            let sUomNm = item["Product_Unit_Name"] as? String
            let sUomConv = String((item["Product_Unit_Value"] as? Int)!)
            let sNetUnt = ""
            let sQty = item["Qty"] as? Int
            var Uomdata = lstAllUnits.filter({(product) in
                let ProdId: String = String(format: "%@", product["Product_Code"] as! CVarArg)
                return Bool(ProdId == sUom)
            })
            var Uomdata2 = Uomdata.filter({(product) in
                let ProdId: String = String(format: "%@", product["name"] as! CVarArg)
                return Bool(ProdId == sUomNm)
            })
            var Uomid2 = ""
            if let Uomiddata = Uomdata2.first?["id"] {
                Uomid2 = Uomiddata as! String
            }
            var rate = ""
            if let rateValue = item["Rate"] as? String {
                rate = rateValue
            }else if let rateValue = item["Rate"] as? Double {
                rate = "\(rateValue)"
            }else if let rateValue = item["Rate"] as? Int {
                rate = "\(rateValue)"
            }
            
            var distributorPrice = ""
            if let distributorPriceValue = item["distributor_price"] as? String {
                distributorPrice = distributorPriceValue
            }else if let distributorPriceValue = item["distributor_price"] as? Double {
                distributorPrice = "\(distributorPriceValue)"
            }else if let distributorPriceValue = item["distributor_price"] as? Int {
                distributorPrice = "\(distributorPriceValue)"
            }
            
            let rateEdited = item["rateedited"] as? String ?? "0"
       //     updateQty(id: sUom!, sUom: Uomid2, sUomNm: sUomNm!, sUomConv: sUomConv,sNetUnt: sNetUnt, sQty: String(sQty!),ProdItem: lProdItem)
            
            updateQty(id: sUom!, sUom: Uomid2, sUomNm: sUomNm!, sUomConv: sUomConv, sNetUnt: sNetUnt, sQty: String(sQty!), ProdItem: lProdItem, rateValue: rate,rateEdited: rateEdited, retailerPriceValue: distributorPrice, disPer: "", disValue: "", disType: "", freecnt: "")
        }
    }
    
    func updateQty (id: String,sUom: String,sUomNm: String,sUomConv: String,sNetUnt: String,sQty: String,ProdItem:[String: Any],rateValue : String,rateEdited: String,retailerPriceValue : String,disPer : String,disValue : String,disType : String,freecnt : String) {

        print(disType)


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

        }

        let RateItems: [AnyObject] = lstRateList.filter ({ (Rate) in
            if Rate["Product_Detail_Code"] as! String == productId {
                return true
            }
            return false
        })

        var rate : Double = 0
        var retailorPrice : Double = 0
        if(RateItems.count>0){
            rate = (RateItems.first!["Distributor_Price"] as! NSString).doubleValue
            retailorPrice = (RateItems.first!["Distributor_Price"] as! NSString).doubleValue
            
            if let distLists = RateItems.first?["distList"] as? [AnyObject] {
                print(distLists)
                
                let rateCards: [AnyObject] = distLists.filter ({ (Rate) in
                    if Rate["Stockist_Code"] as! String == VisitData.shared.CustID {
                        return true
                    }
                    return false
                })
                
                if (rateCards.count>0) {
                    
                    if let rateValue = rateCards.first?["price"] as? String {
                        rate = Double(rateValue) ?? 0
                        retailorPrice = Double(rateValue) ?? 0
                    }else if let rateValue = rateCards.first?["price"] as? Int {
                        rate = Double(rateValue)
                        retailorPrice = Double(rateValue)
                    }else if let rateValue = rateCards.first?["price"] as? Double {
                        rate = rateValue
                        retailorPrice = rateValue
                    }
                }
            }
        }

        rate = Double(rateValue) ?? 0
        retailorPrice = Double(retailerPriceValue) ?? 0

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
        var disCountValue : Double = 0
        var isSchemeActive = false

        var isMultiSchemeActive = false
        var multiScheme = [Scheme]()

        var scheme : Int = 0
        var offerAvailableCount : Int = 0
        var offerUnitName : String = ""
        var offerProductCode : String = ""
        var offerProductName:String = ""
        var package : String = ""
        var schemeType : String = ""
        var discountType : String = ""
        var stockistCode : String = ""

        if UserSetup.shared.primarySchemeBased == "1" && UserSetup.shared.offerMode == 1 {

            let schemesItems = lstStockistSchemes.filter({ (product) in
                let ProdId = String(format: "%@", product["PCode"] as! CVarArg)
                return Bool(ProdId == productId)
            })

            if schemesItems.count > 0 {

                isSchemeActive = true
                if let schValue = schemesItems.first!["Scheme"] as? String {
                    scheme = Int(schValue) ?? 0
                }else if let schValue = schemesItems.first!["Scheme"] as? Int {
                    scheme = schValue
                }
                if let freeValue = schemesItems.first!["FQ"] as? String {
                    offerAvailableCount = Int(freeValue) ?? 0
                }else if let freeValue = schemesItems.first!["FQ"] as? Int {
                    offerAvailableCount = freeValue
                }
                // offerAvailableCount = (schemesItems.first!["FQ"] as! NSString).integerValue
                offerUnitName = schemesItems.first!["FreeUnit"] as? String ?? ""
                offerProductCode = schemesItems.first!["OffProd"] as? String ?? ""
                offerProductName = schemesItems.first!["OffProdNm"] as? String ?? ""
                package = schemesItems.first!["pkg"] as? String ?? ""
                schemeType = schemesItems.first!["schemeType"] as? String ?? ""
                discountType = schemesItems.first!["Discount_Type"] as? String ?? ""
                stockistCode = schemesItems.first!["Stockist_Code"] as? String ?? ""

                if discountType == "%" {
                    disCountPer = (schemesItems.first!["Disc"] as! NSString).doubleValue
                    disCountPer = Double(round(100 * disCountPer) / 100)
                }else {
                    disCountValue = (schemesItems.first!["Disc"] as! NSString).doubleValue
                    disCountValue = Double(round(100 * disCountValue) / 100)
                }

                if schemesItems.count > 1 {

                    for schemesItem in schemesItems {
                        isMultiSchemeActive = true

                        var scheme = 0
                        if let schValue = schemesItem["Scheme"] as? String {
                            scheme = Int(schValue) ?? 0
                        }else if let schValue = schemesItem["Scheme"] as? Int {
                            scheme = schValue
                        }
                        var offerAvailableCount = 0
                        if let freeValue = schemesItem["FQ"] as? String {
                            offerAvailableCount = Int(freeValue) ?? 0
                        }else if let freeValue = schemesItem["FQ"] as? Int {
                            offerAvailableCount = freeValue
                        }
                        let offerUnitName = schemesItem["FreeUnit"] as? String ?? ""
                        let offerProductCode = schemesItem["OffProd"] as? String ?? ""
                        let offerProductName = schemesItem["OffProdNm"] as? String ?? ""
                        let package = schemesItem["pkg"] as? String ?? ""
                        let schemeType = schemesItem["schemeType"] as? String ?? ""
                        let discountType = schemesItem["Discount_Type"] as? String ?? ""
                        let stockistCode = schemesItems.first!["Stockist_Code"] as? String ?? ""

                        var disCountPert : Double = 0
                        var discountValue : Double = 0
                        if discountType == "%" {
                            disCountPert = (schemesItem["Disc"] as! NSString).doubleValue
                            disCountPert = Double(round(100 * disCountPer) / 100)
                        }else {
                            discountValue = (schemesItem["Disc"] as! NSString).doubleValue
                            discountValue = Double(round(100 * discountValue) / 100)
                        }

                        multiScheme.append(Scheme(disCountPer: disCountPert, disCountValue: discountValue, scheme: scheme, offerAvailableCount: offerAvailableCount, offerUnitName: offerUnitName, offerProductCode: offerProductCode, offerProductName: offerProductName, package: package, stockistCode: stockistCode,schemeType: schemeType,discountType: discountType))
                    }
                }

            }
        }


        var discountPer : Double = 0
        let taxPer = tax

        let sQty = Int(sQty) ?? 0

        if isMultiSchemeActive == true {
            let totalQty = unitCount * sQty
            let scheme = self.nextLessThanValue(in: multiScheme, comparedTo: totalQty, rate: rate)
            if scheme != nil {
                discountPer = scheme!.disCountPer

            }
        }else {
            discountPer = Double(disPer) ?? 0
        }



        var freeCount : Int = 0


        if isSchemeActive == true {
            let totalQty = unitCount * sQty

            if package == "N" {
                if isMultiSchemeActive == true {

                    let scheme = self.nextLessThanValue(in: multiScheme, comparedTo: totalQty, rate: rate)

                    if scheme != nil {
                        print(scheme)
                        if scheme!.schemeType == "Q" {
                            if scheme!.discountType == "%" {
                                let schQty = scheme!.scheme
                                let value = Double(totalQty) /  Double(schQty)
                                freeCount = Int(value * Double(scheme!.offerAvailableCount))
                            }else {
                                let schQty = scheme!.scheme
                                let value = Double(totalQty) /  Double(schQty)
                                freeCount = Int(value * Double(scheme!.offerAvailableCount))
                            }

                        }else {
                            if scheme!.discountType == "%" {
                                let schQty = scheme!.scheme
                                let value = Double(totalQty) /  Double(schQty)
                                freeCount = Int(value * Double(scheme!.offerAvailableCount))
                            }else {
                                let schQty = scheme!.scheme
                                let value = Double(totalQty) /  Double(schQty)
                                freeCount = Int(value * Double(scheme!.offerAvailableCount))
                            }
                        }

                    }else{
                        freeCount = 0
                    }
                }else {
                    if schemeType == "Q" {
                        if discountType == "%" {
                            let schQty = scheme
                            let value = Double(totalQty) /  Double(schQty)
                            if Double(totalQty) >= Double(schQty){
                                freeCount = Int(value * Double(offerAvailableCount))
                            }else {
                                freeCount = 0
                            }
                        }else {
                            let schQty = scheme
                            let value = Double(totalQty) /  Double(schQty)
                            if Double(totalQty) >= Double(schQty){
                                freeCount = Int(value * Double(offerAvailableCount))

                                let total = Double(sQty) * rate * Double(unitCount)

                                let amt = Int(Double(totalQty) / Double(scheme))
                                let disCountValuePer = Double(amt)  * disCountValue

                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                disCountPer = discountPerRound
                                disCountValue = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                freeCount = 0
                                disCountPer = 0
                                disCountValue = 0
                            }
                        }
                    }else if schemeType == "V" {
                        if discountType == "%" {
                            let schQty = scheme
                            let total = Double(sQty) * rate * Double(unitCount)
                            let value = Int(Double(total) /  Double(schQty))
                            if Double(total) >= Double(schQty){
                                freeCount = Int(Double(value) * Double(offerAvailableCount))
                            }
                        }else {
                            let schQty = scheme
                            let total = Double(sQty) * rate * Double(unitCount)
                            let value = Int(Double(total) /  Double(schQty))
                            if Double(total) >= Double(schQty){
                                freeCount = Int(Double(value) * Double(offerAvailableCount))

                                let total = Double(sQty) * rate * Double(unitCount)

                                let amt = Int(Double(total) / Double(scheme))
                                let disCountValuePer = Double(amt)  * disCountValue

                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                disCountPer = discountPerRound
                                disCountValue = disCountValuePer
                                discountPer = discountPerRound
                            }
                        }
                    }

                }
            }else {
                if isMultiSchemeActive == true {
                    let scheme = self.nextLessThanValue(in: multiScheme, comparedTo: totalQty, rate: rate)

                    if scheme != nil {
                        if scheme?.schemeType == "Q" {
                            let schemeQty = totalQty / scheme!.scheme
                            freeCount = schemeQty * scheme!.offerAvailableCount //  Int(value * Double(scheme!.offerAvailableCount))
                        }else {
                            let total = Double(sQty) * rate * Double(unitCount)

                            print(total)
                            if Int(total / Double(scheme!.scheme)) > 1 {
                                print(Int(total / Double(scheme!.scheme)))
                                freeCount = Int(total / Double(scheme!.scheme)) * offerAvailableCount

                                let amt = Int(total / Double(scheme!.scheme))
                                let disCountValuePer = Double(amt)  * disCountValue

                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                disCountPer = discountPerRound
                                disCountValue = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                freeCount = 0
                                disCountPer = 0
                                disCountValue = 0
                            }
                        }

                    }else{
                        freeCount = 0
                    }
                }else {

                    if schemeType == "Q" {

                        if discountType == "%" {
                            let schemeQty = totalQty / scheme
                            if totalQty >= scheme{
                                freeCount = schemeQty * offerAvailableCount
                            }
                        }else {
                            let total = Double(sQty) * rate * Double(unitCount)

                            print(total)
                            if Int(Double(totalQty) / Double(scheme)) >= 1 {
                                print(Int(total / Double(scheme)))
                                freeCount = Int(Double(totalQty) / Double(scheme)) * offerAvailableCount

                                let amt = Int(Double(totalQty) / Double(scheme))
                                let disCountValuePer = Double(amt)  * disCountValue

                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                disCountPer = discountPerRound
                                disCountValue = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                freeCount = 0
                                disCountPer = 0
                                disCountValue = 0
                            }
                        }

                    }else {
                        if discountType == "%" {
                            let schemeQty = totalQty / scheme
                            if totalQty >= scheme{
                                freeCount = schemeQty * offerAvailableCount
                            }
                        }else {
                            let total = Double(sQty) * rate * Double(unitCount)

                            print(total)
                            if Int(total / Double(scheme)) > 1 {
                                print(Int(total / Double(scheme)))
                                freeCount = Int(total / Double(scheme)) * offerAvailableCount

                                let amt = Int(total / Double(scheme))
                                let disCountValuePer = Double(amt)  * disCountValue

                                let disCountPercentage = (disCountValuePer / total) * 100
                                print(disCountPercentage)
                                let discountPerRound =   Double(round(100 * disCountPercentage) / 100)
                                disCountPer = discountPerRound
                                disCountValue = disCountValuePer
                                discountPer = discountPerRound
                            }else {
                                freeCount = 0
                                disCountPer = 0
                                disCountValue = 0
                            }
                        }

                    }


                }

            }
        }else {
            disCountPer = Double(disPer) ?? 0
            discountType = disType == "" ? "%" : disType
            freeCount = Int(freecnt) ?? 0
        }
        var discountAmountRound : Double = 0
        var taxAmountRound : Double = 0
        var totalAmountRound : Double = 0

        if isSchemeActive == true {
            if schemeType == "Q" {

                let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100

                let discountPerOneUnit = discountPer *  rate / 100

                let rateMinusDiscount = rate - discountPerOneUnit

                let taxAmount = taxPer * Double(unitCount) * rateMinusDiscount * Double(sQty) / 100

                var total = Double(sQty) * rateMinusDiscount * Double(unitCount)

                total = total + taxAmount

                discountAmountRound = Double(round(100 * discountAmount) / 100)
                taxAmountRound = Double(round(100 * taxAmount) / 100)
                totalAmountRound = Double(round(100 * total) / 100)
            }else {
                let discountAmount = disCountValue

                let discountPerOneUnit = discountPer *  rate / 100

                let rateMinusDiscount = rate - discountPerOneUnit

                let taxAmount = taxPer * Double(unitCount) * rateMinusDiscount * Double(sQty) / 100

                var total = Double(sQty) * rate * Double(unitCount)
                total = total - discountAmount
                total = total + taxAmount

                discountAmountRound = Double(round(100 * discountAmount) / 100)
                taxAmountRound = Double(round(100 * taxAmount) / 100)
                totalAmountRound = Double(round(100 * total) / 100)
            }
        }else {
            if disType == "%" {
                let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100

                let discountPerOneUnit = discountPer *  rate / 100

                let rateMinusDiscount = rate - discountPerOneUnit

                let taxAmount = taxPer * Double(unitCount) * rateMinusDiscount * Double(sQty) / 100

                var total = Double(sQty) * rateMinusDiscount * Double(unitCount)

                total = total + taxAmount

                discountAmountRound = Double(round(100 * discountAmount) / 100)
                taxAmountRound = Double(round(100 * taxAmount) / 100)
                totalAmountRound = Double(round(100 * total) / 100)
            }else {
                let discountAmount = discountPer

                let discountPerOneUnit = discountPer *  rate / 100

                let rateMinusDiscount = rate - discountPerOneUnit

                let taxAmount = taxPer * Double(unitCount) * rateMinusDiscount * Double(sQty) / 100

                var total = Double(sQty) * rate * Double(unitCount)
                total = total - discountAmount
                total = total + taxAmount

                discountAmountRound = Double(round(100 * discountAmount) / 100)
                taxAmountRound = Double(round(100 * taxAmount) / 100)
                totalAmountRound = Double(round(100 * total) / 100)
            }
        }





        print(discountAmountRound)
        print(discountPer)
        let EditProduct = ProductList(product: product.first!, productName: productName, productId: productId,cateId: cateId, rate: rate,rateEdited: rateEdited,retailerPrice: retailorPrice,saleErpCode: saleErpCode,newWt: newWt, sampleQty: "\(sQty)",clQty: "0",remarks: "",remarksId: "", selectedRemarks: [], disCountPer: disCountPer, disCountValue: disCountValue, disCountAmount: discountAmountRound, freeCount: freeCount, unitId: unitId, unitName: unitName, unitCount: unitCount, taxper: tax, taxAmount: taxAmountRound, totalCount: totalAmountRound, isSchemeActive: isSchemeActive,scheme: scheme,offerAvailableCount: offerAvailableCount,offerUnitName: offerUnitName,offerProductCode: offerProductCode,offerProductName: offerProductName,package: package,schemeType: schemeType,discountType: discountType, isMultiSchemeActive: isMultiSchemeActive, stockistCode: stockistCode, multiScheme: multiScheme, competitorProduct: [])


        print(EditProduct)
        print(allProducts)
        if let index = self.allProducts.firstIndex(where: { (productInfo) -> Bool in
            return id == productInfo.productId  && retailorPrice == productInfo.retailerPrice
        }){
            self.allProducts[index] = EditProduct
        }

        self.updateTotal()
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
    
    
    
    @IBAction func AddProductAction(_ sender: UIButton) {
        tbProductTableView.isHidden = false
        vwSubmit.isHidden = true
        collectionView.reloadData()
        self.products = self.allProducts.filter{$0.cateId == selectedBrand}
        tbProductTableView.reloadData()
        updateTotal()
    }
    
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
        if !self.selectedProducts.isEmpty {
            SelectedProductTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
        }
        
    }
    
}
