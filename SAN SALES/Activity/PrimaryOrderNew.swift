//
//  PrimaryOrderNew.swift
//  SAN SALES
//
//  Created by Naga Prasath on 01/10/24.
//

import Foundation
import UIKit

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
    
    
    
    @IBOutlet weak var selectedTableViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var freeQtyTableViewHeightConstraint: NSLayoutConstraint!
    
    
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
    var lstSchemList: [AnyObject] = []
    var lstRateList: [AnyObject] = []
    var lstRandomNumbers : [AnyObject] = []
    var lstAllUnits : [AnyObject] = []
    var lstUnits : [AnyObject] = []
    
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
        
        
        let lstCatData: String=LocalStoreage.string(forKey: "Brand_Master")!
        let lstProdData: String = LocalStoreage.string(forKey: "Products_Master")!
        let lstUnitData: String = LocalStoreage.string(forKey: "UnitConversion")!
        let lstSchemData: String = LocalStoreage.string(forKey: "Schemes_Master")!
        let lstRateData: String = LocalStoreage.string(forKey: "ProductRate_Master")!
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        let lstRandomNumberData: String = LocalStoreage.string(forKey: "Random_Number")!
        
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
        if let list = GlobalFunc.convertToDictionary(text: lstProdData) as? [AnyObject] {
            lstAllProducts = list;
            print(lstAllProducts)
        }
        if let list = GlobalFunc.convertToDictionary(text: lstUnitData) as? [AnyObject] {
            lstAllUnitList = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: lstSchemData) as? [AnyObject] {
            lstSchemList = list;
            print(lstSchemList)
        }
        if let list = GlobalFunc.convertToDictionary(text: lstRateData) as? [AnyObject] {
            lstRateList = list;
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
        
        lblStockist.addTarget(target: self, action: #selector(stkSelection))
        imgBack.addTarget(target: self, action: #selector(backVC))
        
        lblTitle.text = UserSetup.shared.PrimaryCaption
        lblName.text = VisitData.shared.CustName
        lblDate.text = VisitData.shared.OrderMode.name
        
        
        
        if UserSetup.shared.SuperStockistNeed != 1 {
            self.lblDistributorName.isHidden = true
           // self.supplierHeightConstraints.constant = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
            if UserSetup.shared.SchemeBased == 1 && UserSetup.shared.offerMode == 1{
                Cell.txtDisPer.borderStyle = .none
                Cell.txtDisPer.isUserInteractionEnabled = false
                Cell.txtFreeQty.isUserInteractionEnabled = false
            }
            Cell.txtTaxPer.isUserInteractionEnabled = false
            Cell.imgScheme.addTarget(target: self, action: #selector(schemeAction))
            Cell.imgRateEdit.addTarget(target: self, action: #selector(rateEditAction))
         //   Cell.txtClQty.addTarget(self, action: #selector(changeClQty(_:)), for: .editingChanged)
         //   Cell.btnTemplate.addTarget(self, action: #selector(templateAction(_:)), for: .touchUpInside)
         //   Cell.imgCompetitorProduct.addTarget(target: self, action: #selector(competitorAction))
            if UserSetup.shared.clCap  == "CB"{
                Cell.lblCl.text = "CB : "
                Cell.lblQty.text = "Sale : "
            }else if UserSetup.shared.clCap  == "CL"{
                Cell.lblCl.text = "CL : "
                Cell.lblQty.text = "Qty : "
            }
            Cell.txtClQty.text = self.products[indexPath.row].clQty
            Cell.lblRemarks.text = self.products[indexPath.row].remarks == "" ? "Select the Templete" : self.products[indexPath.row].remarks
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
            if UserSetup.shared.productRCPA == "0" {
                Cell.imgCompetitorProduct.isHidden = true
                Cell.imgCompetitorProductWidthConstraint.constant = 0
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
                    
                    if cell.product.schemeType == "Q" {
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
        
        
        if cell.product.schemeType == "Q" {
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
        
        if cell.product.isMultiSchemeActive == true {
            AlertData.shared.title = cell.product.productName
            
            AlertData.shared.scheme = cell.product.multiScheme
            
        }else {
            
            AlertData.shared.title = cell.product.productName
            
            let scheme = Scheme(disCountPer: cell.product.disCountPer, disCountValue: cell.product.disCountValue, scheme: cell.product.scheme, offerAvailableCount: cell.product.offerAvailableCount, offerUnitName: cell.product.offerUnitName, offerProductCode: cell.product.offerProductCode, offerProductName: cell.product.offerProductName, package: cell.product.package,schemeType: cell.product.schemeType,discountType: cell.product.discountType)
            
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
                    
                    if cell.product.schemeType == "Q" {
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
        
        if cell.product.schemeType == "Q" {
            let discountAmount = discountPer * Double(unitCount) * rate * Double(sQty) / 100
            
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
            
            cell.lblDisc.text = "₹ " + "\(discountAmountRound)"
            cell.lblTax.text = "₹ " + "\(taxAmountRound)"
            cell.product.taxAmount = taxAmountRound
            cell.product.disCountAmount = discountAmountRound
            cell.product.totalCount = totalAmountRound
            cell.lblTotal.text = "₹ " + "\(totalAmountRound)"
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
        
        self.allProducts.append(ProductList(product: cell.product.product, productName: cell.product.productName, productId: cell.product.productId,cateId: cell.product.cateId, rate: cell.product.rate,rateEdited: cell.product.rateEdited,retailerPrice: cell.product.retailerPrice,saleErpCode: cell.product.saleErpCode,newWt: cell.product.newWt, sampleQty: "",clQty: "",remarks: "",remarksId: "", selectedRemarks: cell.product.selectedRemarks, disCountPer: cell.product.disCountPer, disCountValue: cell.product.disCountValue, disCountAmount: 0.0, freeCount: 0, unitId: cell.product.unitId, unitName: cell.product.unitName, unitCount: cell.product.unitCount, taxper: cell.product.taxper, taxAmount: 0.0, totalCount: 0.0, isSchemeActive: cell.product.isSchemeActive,scheme: cell.product.scheme,offerAvailableCount: cell.product.offerAvailableCount,offerUnitName: cell.product.offerUnitName,offerProductCode: cell.product.offerProductCode,offerProductName: cell.product.offerProductName,package: cell.product.package,schemeType: cell.product.schemeType,discountType: cell.product.discountType,isMultiSchemeActive: cell.product.isMultiSchemeActive,multiScheme: cell.product.multiScheme, competitorProduct: []))
        
        
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
        self.dismiss(animated: true, completion: nil)
        GlobalFunc.movetoHomePage()
    }
    
    
    
}
