//
//  PrimaryOrder.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 26/05/22.
//


import Foundation
import UIKit
import Alamofire
import CoreLocation

class PrimaryOrder: IViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var axnEdit = "get/pmOrderDetails"
    @IBOutlet weak var lcLastvistHeight: NSLayoutConstraint!
    @IBOutlet weak var lcContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwRetailCtrl: UIView!
    
    @IBOutlet weak var vwPrvOrderCtrl: UIView!
    @IBOutlet var vwVstContainer: UIView!
    @IBOutlet var vwBuget: UIView!
    @IBOutlet var vwBugetPrv: UIView!
    
    @IBOutlet weak var vwSelWindow: UIView!
    @IBOutlet weak var lblSelTitle: UILabel!
    @IBOutlet weak var lblOrderMode: UILabel!
    @IBOutlet weak var lblCustName: UILabel!
    @IBOutlet weak var lblTitleCap: UILabel!
    @IBOutlet weak var lblSuppNm: UILabel!
    @IBOutlet weak var lblPrvSuppNm: UILabel!
    @IBOutlet weak var lblTotItem: UILabel!
    @IBOutlet weak var lblTotAmt: UILabel!
    @IBOutlet weak var lblPrvTotItem: UILabel!
    @IBOutlet weak var lblPrvTotAmt: UILabel!
    @IBOutlet weak var txSearchSel: UITextField!
    
    @IBOutlet weak var cvCategory: UICollectionView!
    @IBOutlet weak var tbProduct: UITableView!
    @IBOutlet weak var tbDataSelect: UITableView!
    @IBOutlet weak var tbPrvOrderProduct: UITableView!
    
    @IBOutlet weak var imgOrderTyp: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnBack: UIImageView!
    
    @IBOutlet weak var vwBtnOrder: RoundedCornerView!
    @IBOutlet weak var vwBtnCam: RoundedCornerView!
    
    struct lItem: Any {
        let id: String
        let name: String
    }
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
    //    var SFCode: String = ""
    //    var DivCode: String = ""
    var lstJWNms: [AnyObject] = []
    var strJWCd: String = ""
    var strJWNm: String = ""
    var lstJoint: [AnyObject] = []
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    override func viewDidLoad() {
        getUserDetails()
        updateEditOrderValues()
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
        
        let lstCatData: String=LocalStoreage.string(forKey: "Brand_Master")!
        let lstProdData: String = LocalStoreage.string(forKey: "Products_Master")!
        let lstUnitData: String = LocalStoreage.string(forKey: "UnitConversion")!
        let lstSchemData: String = LocalStoreage.string(forKey: "Schemes_Master")!
        let lstRateData: String = LocalStoreage.string(forKey: "ProductRate_Master")!
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let JointWData = LocalStoreage.string(forKey: "Jointwork_Master"),
           let list = GlobalFunc.convertToDictionary(text:  JointWData) as? [AnyObject] {
            lstJoint = list;
            print("JointWData  ___________________________")
        }
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: lstCatData) as? [AnyObject] {
            lstBrands = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: lstProdData) as? [AnyObject] {
            lstAllProducts = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: lstUnitData) as? [AnyObject] {
            lstAllUnitList = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: lstSchemData) as? [AnyObject] {
            lstSchemList = list;
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
        
        lblSuppNm.addTarget(target: self, action: #selector(selOrdSuppName))
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        
        lblTitleCap.text = UserSetup.shared.PrimaryCaption
        lblCustName.text = VisitData.shared.CustName
        lblOrderMode.text = VisitData.shared.OrderMode.name
        vwBuget.layer.cornerRadius = 10
        vwBugetPrv.layer.cornerRadius = 10
        
        imgOrderTyp.image=UIImage(named: "Shop")
        if VisitData.shared.OrderMode.id == "1" {
            imgOrderTyp.image=UIImage(systemName: "phone.fill")
            
        }
        cvCategory.delegate=self
        cvCategory.dataSource=self
        tbProduct.delegate=self
        tbProduct.dataSource=self
        tbPrvOrderProduct.delegate=self
        tbPrvOrderProduct.dataSource=self
        tbDataSelect.delegate=self
        tbDataSelect.dataSource=self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstBrands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        autoreleasepool {
            let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
            let item: [String: Any]=lstBrands[indexPath.row] as! [String : Any]
            cell.vwContent.layer.cornerRadius = 10
            cell.vwContent.clipsToBounds = true
            cell.vwContent.layer.cornerRadius = 10
            cell.vwContent.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 251/255, alpha: 1)
            let id=String(format: "%@", item["id"] as! CVarArg)
            
            if selBrand == id {
                cell.vwContent.backgroundColor = UIColor(red: 16/255, green: 173/255, blue: 194/255, alpha: 1)
            }
            cell.lblText?.text = item["name"] as? String
            
            if self.BrandImages[id] != nil{
                cell.imgProduct.image = self.BrandImages[id] as? UIImage
            }else{
                if item["Cat_Image"] != nil{
                    let imageUrlString=(item["Cat_Image"] as? String)!
                    let imageUrl:NSURL = NSURL(string: imageUrlString)!
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        autoreleasepool{
                            var imageData: NSData? = nil
                            do {
                                imageData = try NSData(contentsOf: imageUrl as! URL)
                            }catch let err{
                                print(err.localizedDescription)
                            }
                            DispatchQueue.main.async {
                                autoreleasepool{
                                    if(imageData != nil){
                                        var image = UIImage(data: imageData! as Data)
                                        cell.imgProduct.image = image
                                        self.BrandImages.updateValue(image, forKey: id)
                                        
                                        image = nil
                                    }
                                    imageData=nil
                                    //cell.imgProduct.contentMode = UIView.ContentMode.scaleAspectFit
                                }
                            }
                        }
                    }
                }
            }
            //cell.imgBtnDel.addTarget(target: self, action: #selector(self.delJWK(_:)))
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        autoreleasepool{
            let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
            let item: [String: Any]=lstBrands[indexPath.row] as! [String : Any]
            selBrand=String(format: "%@", item["id"] as! CVarArg)
            cell.vwContent.backgroundColor = UIColor(red: 16/255, green: 173/255, blue: 194/255, alpha: 1)
            lstProducts = lstAllProducts.filter({(product) in
                let CatId: String = String(format: "%@", product["cateid"] as! CVarArg)
                return Bool(CatId == selBrand)
            })
            
            tbProduct.reloadData()
            collectionView.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        let item: [String: Any]=lstBrands[indexPath.row] as! [String : Any]
        let tx: String = item["name"] as? String ?? ""
        let rect: CGSize = tx.sizeOfString(maxWidth: 250, font: cell.lblText.font)
        
        return CGSize(width: rect.width+70, height: collectionView.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("sholuld Clear Memory")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tbDataSelect == tableView { return 42}
        return 112
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==tbProduct { return lstProducts.count }
        if tableView==tbPrvOrderProduct { return lstPrvOrder.count }
        return lObjSel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        autoreleasepool {
            let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            if tbDataSelect == tableView {
                let item: [String: Any] = lObjSel[indexPath.row] as! [String : Any]
                print(item)
                cell.lblText?.text = item["name"] as? String
                cell.lblUOM?.text = ""
                if SelMode=="UOM" {
                    cell.lblUOM?.text = String(format: "1 x  %@", item["ConQty"] as! CVarArg)
                }
                cell.imgSelect?.image = nil
            } else if tbPrvOrderProduct == tableView {
                let item: [String: Any]=lstPrvOrder[indexPath.row] as! [String : Any]
                let id=String(format: "%@", item["id"] as! CVarArg)
                let ProdItems = lstAllProducts.filter({(product) in
                    let ProdId: String = String(format: "%@", product["id"] as! CVarArg)
                    return Bool(ProdId == id)
                })
                //let itm: [String: Any]=["id": id,"Qty": sQty,"UOM": sUom, "UOMNm": sUomNm, "UOMConv": sUomConv, "SalQty": TotQty,"Scheme": Scheme,"FQ": FQ,"OffQty": OffQty,"OffProd":OffProd,"OffProdNm":OffProdNm, "Value": (TotQty*Rate)];
                cell.lblUOM.text = item["UOMNm"] as? String
                cell.txtQty.text = item["Qty"] as? String
                cell.lblDisc.text = ""
                cell.lblDisc.layer.cornerRadius = 10
                cell.lblDisc.isHidden = true
                cell.lblActRate.isHidden = true
                cell.imgSelect.image = nil
                cell.lblFreeQty.isUserInteractionEnabled=false
                if self.ProdImages[id] != nil{
                    cell.imgSelect.image = self.ProdImages[id] as? UIImage
                }
                if(ProdItems.count>0){
                    cell.lblText?.text = ProdItems[0]["name"] as? String
                }
                cell.lblMRP.text="MRP Rs. 0.00"
                cell.lblSellRate.text="Rs. 0.00"
                let attrRedStrikethroughStyle = [
                    NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)
                ]
                let text = NSAttributedString(string: "Rs. 0.00",
                                              attributes: attrRedStrikethroughStyle)
                cell.lblActRate.attributedText = text
                let RateItems: [AnyObject] = lstRateList.filter ({ (Rate) in
                    
                    if Rate["Product_Detail_Code"] as! String == id {
                        return true
                    }
                    return false
                })
                var rate: Double = 0
                
                if(RateItems.count>0){
                    cell.lblMRP.text = String(format: "MRP Rs. %.02f",(RateItems[0]["Retailor_Price"] as! NSString).doubleValue)
                    rate = (RateItems[0]["Retailor_Price"] as! NSString).doubleValue
                    cell.lblSellRate.text = String(format: "Rs. %.02f", rate)
                    let text = NSAttributedString(string: String(format: "Rs. %.02f", rate),
                                                  attributes: attrRedStrikethroughStyle)
                    cell.lblActRate.attributedText = text
                }
                cell.lblFreeQty.text = "0"
                cell.lblFreeProd.text = ""
                cell.lblUOM.addTarget(target: self, action: #selector(self.openUnit(_:)))
                cell.btnPlus.addTarget(target: self, action: #selector(self.addQty(_:)))
                cell.btnMinus.addTarget(target: self, action: #selector(self.minusQty(_:)))
                cell.imgBtnDel.addTarget(target: self, action: #selector(self.deleteItem(_:)))
                cell.txtQty.addTarget(self, action: #selector(self.changeQty(_:)), for: .editingChanged)
                
                
                let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
                    
                    if Cart["id"] as! String == id {
                        return true
                    }
                    return false
                })
                cell.lblFreeCap.isHidden = true
                cell.lblFreeQty.isHidden = true
                cell.lblFreeProd.isHidden = true
                if items.count>0 {
                    let FQ: Int = items[0]["OffQty"] as! Int
                    cell.lblFreeQty?.text = String(format: "%i", FQ)
                    if FQ>0 {
                        cell.lblFreeCap.isHidden = false
                        cell.lblFreeQty.isHidden = false
                        cell.lblFreeProd.isHidden = false
                    }
                    //cell.lblUOM?.text = items[0]["OffProd"] as? String
                    cell.lblFreeProd?.text = items[0]["OffProdNm"] as? String
                    var Disc: String = items[0]["Disc"] as! String
                    var dis: Double = 0;
                    if (Disc != "" && Disc != "0") {
                        dis = rate * (Double(Disc)! / 100);
                        cell.lblActRate.isHidden = false
                        cell.lblDisc.isHidden = false
                    }
                    rate = rate - dis;
                    if(Disc != "" && Disc != "0") { Disc=String(format: "%@%% OFF",Disc) } else { Disc = "" }
                    cell.lblDisc?.text = Disc
                    cell.lblSellRate.text = String(format: "Rs. %.02f", rate)
                }
                
            }else{
                
                
                let item: [String: Any]=lstProducts[indexPath.row] as! [String : Any]
                
                let id=String(format: "%@", item["id"] as! CVarArg)
                cell.lblText?.text = item["name"] as? String
                cell.lblUOM.text = item["Product_Sale_Unit"] as? String
                cell.btnPlus.layer.cornerRadius = 17
                cell.btnMinus.layer.cornerRadius = 17
                cell.lblMRP.text="MRP Rs. 0.00"
                cell.lblSellRate.text="Rs. 0.00"
                cell.lblDisc.text = ""
                cell.lblDisc.layer.cornerRadius = 10
                cell.lblDisc.isHidden = true
                cell.lblActRate.isHidden = true
                cell.lblFreeQty.isUserInteractionEnabled=false
                let attrRedStrikethroughStyle = [
                    NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)
                ]
                let text = NSAttributedString(string: "Rs. 0.00",
                                              attributes: attrRedStrikethroughStyle)
                cell.lblActRate.attributedText = text
                let RateItems: [AnyObject] = lstRateList.filter ({ (Rate) in
                    
                    if Rate["Product_Detail_Code"] as! String == id {
                        return true
                    }
                    return false
                })
                var rate: Double = 0
                if(RateItems.count>0){
                    cell.lblMRP.text = String(format: "MRP Rs. %.02f",(RateItems[0]["Retailor_Price"] as! NSString).doubleValue)
                    rate = (RateItems[0]["Retailor_Price"] as! NSString).doubleValue
                    cell.lblSellRate.text = String(format: "Rs. %.02f", rate)
                    let text = NSAttributedString(string: String(format: "Rs. %.02f", rate),
                                                  attributes: attrRedStrikethroughStyle)
                    cell.lblActRate.attributedText = text
                }
                cell.lblFreeQty.text = "0"
                cell.lblFreeProd.text = ""
                cell.lblUOM.addTarget(target: self, action: #selector(self.openUnit(_:)))
                cell.btnPlus.addTarget(target: self, action: #selector(self.addQty(_:)))
                cell.btnMinus.addTarget(target: self, action: #selector(self.minusQty(_:)))
                cell.txtQty.addTarget(self, action: #selector(self.changeQty(_:)), for: .editingChanged)
                cell.imgSelect.image = nil
                if self.ProdImages[id] != nil{
                    cell.imgSelect.image = self.ProdImages[id] as? UIImage
                }else{
                    if item["Product_Image"] != nil {
                        if let imgurl = item["Product_Image"] as? String {
                            if imgurl != "" {
                                let imageUrlString=String(format: "%@%@", APIClient.shared.ProdImgURL,(item["Product_Image"] as! String).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                                // if(NSURL(string: imageUrlString) != nil){
                                let imageUrl:NSURL = NSURL(string: imageUrlString)!
                                
                                DispatchQueue.global(qos: .userInitiated).async {
                                    autoreleasepool{
                                        var imageData: NSData? = nil
                                        do {
                                            imageData = try NSData(contentsOf: imageUrl as! URL)
                                        }catch let err{
                                            print(err.localizedDescription)
                                        }
                                        DispatchQueue.main.async {
                                            autoreleasepool{
                                                if(imageData != nil){
                                                    var image = UIImage(data: imageData! as Data)
                                                    cell.imgSelect.image = image
                                                    self.ProdImages.updateValue(image, forKey: id)
                                                    image = nil
                                                }
                                                imageData=nil
                                            }
                                            //cell.imgProduct.contentMode = UIView.ContentMode.scaleAspectFit
                                        }
                                    }
                                }
                                // }
                            }
                        }
                    }
                }
                
                let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
                    
                    if Cart["id"] as! String == id {
                        return true
                    }
                    return false
                })
                cell.txtQty?.text = "0"
                cell.lblFreeCap.isHidden = true
                cell.lblFreeQty.isHidden = true
                cell.lblFreeProd.isHidden = true
                if items.count>0 {
                    cell.txtQty?.text = items[0]["Qty"] as? String
                    cell.lblUOM?.text = items[0]["UOMNm"] as? String
                    let FQ: Int = items[0]["OffQty"] as! Int
                    cell.lblFreeQty?.text = String(format: "%i", FQ)
                    if FQ>0 {
                        cell.lblFreeCap.isHidden = false
                        cell.lblFreeQty.isHidden = false
                        cell.lblFreeProd.isHidden = false
                    }
                    //cell.lblUOM?.text = items[0]["OffProd"] as? String
                    cell.lblFreeProd?.text = items[0]["OffProdNm"] as? String
                    
                    var Disc: String = items[0]["Disc"] as! String
                    var dis: Double = 0;
                    if (Disc != "" && Disc != "0") {
                        dis = rate * (Double(Disc)! / 100);
                        cell.lblActRate.isHidden = false
                        cell.lblDisc.isHidden = false
                    }
                    rate = rate - dis;
                    if(Disc != "" && Disc != "0") { Disc=String(format: "%@%% OFF",Disc) } else { Disc = "" }
                    cell.lblDisc?.text = Disc
                    cell.lblSellRate.text = String(format: "Rs. %.02f", rate)
                }
                
                //cell.imgBtnDel.addTarget(target: self, action: #selector(self.delJWK(_:)))
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tbDataSelect == tableView {
            let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
            let name=item["name"] as! String
            let id=String(format: "%@", item["id"] as! CVarArg)
            if SelMode=="DIS" {
                lblSuppNm.text = name
                print(name)
                lblPrvSuppNm.text = name
                VisitData.shared.Dist.name = name
                VisitData.shared.Dist.id = id
                VisitData.shared.Sup.id = id
                VisitData.shared.Sup.id = name
                print(id)
                print(VisitData.shared.ProductCart)
                
            }
            else if SelMode=="UOM"
            {
                let selectProd: String
                let lProdItem:[String: Any]
                var selNetWt: String = ""
                if lblSelTitle.tag == 1 {
                    lProdItem = lstPrvOrder[tbDataSelect.tag] as! [String : Any]
                    selectProd = String(format: "%@",lstPrvOrder[tbDataSelect.tag]["id"] as! CVarArg)
                    selNetWt = String(format: "%@", lstPrvOrder[tbDataSelect.tag]["NetWt"] as! CVarArg)
                } else {
                    lProdItem = lstProducts[tbDataSelect.tag] as! [String : Any]
                    selectProd = String(format: "%@",lstProducts[tbDataSelect.tag]["id"] as! CVarArg)
                    selNetWt = String(format: "%@", lstProducts[tbDataSelect.tag]["product_netwt"] as! CVarArg)
                }
                let ConvQty=String(format: "%@", item["ConQty"] as! CVarArg)
                let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (item) in
                    if item["id"] as! String == selectProd {
                        return true
                    }
                    return false
                })
                var sQty: Int = 0
                if (items.count>0)
                {
                    sQty = Int((items[0]["Qty"] as! NSString).intValue)
                }
                print(VisitData.shared.ProductCart)
                print(name)
                updateQty(id: selectProd, sUom: id, sUomNm: name, sUomConv: ConvQty, sNetUnt: selNetWt, sQty: String(sQty),ProdItem: lProdItem, refresh: 1)
            }
            closeWin(self)
        }
    }
    
    func updateSchme(cell: cellListItem, id: String){
        
        let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
            
            if Cart["id"] as! String == id {
                return true
            }
            return false
        })
        cell.txtQty?.text = "0"
        cell.lblFreeCap.isHidden = true
        cell.lblFreeQty.isHidden = true
        cell.lblFreeProd.isHidden = true
        var rate: Double = 0
        if items.count>0 {
            cell.txtQty?.text = items[0]["Qty"] as? String
            cell.lblUOM?.text = items[0]["UOMNm"] as? String
            rate = items[0]["Rate"] as? Double ?? 0
            
            let FQ: Int = items[0]["OffQty"] as! Int
            cell.lblFreeQty?.text = String(format: "%i", FQ)
            if FQ>0 {
                cell.lblFreeCap.isHidden = false
                cell.lblFreeQty.isHidden = false
                cell.lblFreeProd.isHidden = false
            }
            //cell.lblUOM?.text = items[0]["OffProd"] as? String
            cell.lblFreeProd?.text = items[0]["OffProdNm"] as? String
            
            var Disc: String = items[0]["Disc"] as! String
            var dis: Double = 0;
            if (Disc != "" && Disc != "0") {
                dis = rate * (Double(Disc)! / 100);
                cell.lblActRate.isHidden = false
                cell.lblDisc.isHidden = false
            }
            rate = rate - dis;
            if(Disc != "" && Disc != "0") { Disc=String(format: "%@%% OFF",Disc) } else { Disc = "" }
            cell.lblDisc?.text = Disc
            cell.lblSellRate.text = String(format: "Rs. %.02f", rate)
        }
    }
    @IBAction func searchBytext(_ sender: Any) {
        
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            lstProducts = lstAllProducts.filter({(product) in
                let CatId: String = String(format: "%@", product["cateid"] as! CVarArg)
                return Bool(CatId == selBrand)
            })
        }else{
            lstProducts = lstAllProducts.filter({(product) in
                let name: String = String(format: "%@", product["name"] as! CVarArg)
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        tbProduct.reloadData()
        
    }
    
    func validateForm() -> Bool {
        if VisitData.shared.Dist.id == "" {
            Toast.show(message: "Select the Supplier")//, controller: self
            return false
        }
        lstPrvOrder = VisitData.shared.ProductCart.filter ({ (Cart) in
            if (Cart["SalQty"] as! Double) > 0 {
                return true
            }
            return false
        })
        if(lstPrvOrder.count<1){
            Toast.show(message: "Cart is Empty.") //, controller: self
            return false
        }
        return true
    }
    @IBAction func openPreview(_ sender: Any) {
        if validateForm() {
            
            tbPrvOrderProduct.reloadData()
            vwPrvOrderCtrl.isHidden = false
            tbProduct.isHidden = true
        }
    }
    @IBAction func closePreview(_ sender: Any) {
        vwPrvOrderCtrl.isHidden = true
        tbProduct.isHidden = false
    }
    @IBAction func searchSelBytext(_ sender: Any) {
        
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
        vwSelWindow.isHidden=false
        
    }
    @objc private func selOrdSuppName(){
        isMulti=false
        lObjSel=lstSuppList
        self.tbDataSelect.reloadData()
        lblSelTitle.text="Select the Supplier"
        openWin(Mode: "DIS")
    }
    @objc private func openUnit(_ sender: UITapGestureRecognizer) {
        let cell: cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!) as! UITableView
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        isMulti=false
        
        if lstBrands.count>0{
            let item: [String: Any]
            if(tbView==tbPrvOrderProduct)
            {
                lblSelTitle.tag = 1
                item = lstPrvOrder[indxPath.row] as! [String : Any]
            }else{
                lblSelTitle.tag = 0
                item = lstProducts[indxPath.row] as! [String : Any]
            }
            let selProdID=String(format: "%@", item["id"] as! CVarArg)
            lstUnitList = lstAllUnitList.filter({(product) in
                let ProdId: String = String(format: "%@", product["Product_Code"] as! CVarArg)
                return Bool(ProdId == selProdID)
            })
        }
        lObjSel=lstUnitList
        self.tbDataSelect.tag = indxPath.row
        self.tbDataSelect.reloadData()
        lblSelTitle.text="Select the UOM"
        openWin(Mode: "UOM")
    }
    @objc private func changeQty(_ txtQty: UITextField)
    {
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: txtQty) as! cellListItem
        let tbView:UITableView = GlobalFunc.getTableView(view: txtQty) as! UITableView
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        var sQty: Int =  integer(from: cell.txtQty)
        
        let id: String
        let lProdItem:[String: Any]
        if(tbView==tbPrvOrderProduct)
        {
            lProdItem = lstPrvOrder[indxPath.row] as! [String : Any]
            id=String(format: "%@", lstPrvOrder[indxPath.row]["id"] as! CVarArg)
        }else{
            lProdItem = lstProducts[indxPath.row] as! [String : Any]
            id=String(format: "%@", lstProducts[indxPath.row]["id"] as! CVarArg)
        }
        let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
            
            if Cart["id"] as! String == id {
                return true
            }
            return false
        })
        
        var selUOMConv: String = "1"
        var selNetWt: String = ""
        if(items.count>0)
        {
            selUOM=String(format: "%@", items[0]["UOM"] as! CVarArg)
            selUOMNm=String(format: "%@", items[0]["UOMNm"] as! CVarArg)
            selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
            selNetWt=String(format: "%@", items[0]["NetWt"] as! CVarArg)
        }else{
            selUOM=String(format: "%@", lstProducts[indxPath.row]["Base_Unit_code"] as! CVarArg)
            selUOMNm=String(format: "%@", lstProducts[indxPath.row]["Product_Sale_Unit"] as! CVarArg)
            selUOMConv=String(format: "%@", lstProducts[indxPath.row]["OrdConvSec"] as! CVarArg)
            selNetWt=String(format: "%@", lstProducts[indxPath.row]["product_netwt"] as! CVarArg)
        }
        updateQty(id: id, sUom: selUOM, sUomNm: selUOMNm, sUomConv: selUOMConv, sNetUnt: selNetWt, sQty: String(sQty),ProdItem: lProdItem,refresh: 0)
        updateSchme(cell: cell, id: id)
    }
    @objc private func addQty(_ sender: UITapGestureRecognizer) {
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView:UITableView = GlobalFunc.getTableView(view: sender.view!) as! UITableView
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        var sQty: Int =  integer(from: cell.txtQty)
        sQty = sQty+1
        let id: String
        let lProdItem:[String: Any]
        if(tbView==tbPrvOrderProduct)
        {
            lProdItem = lstPrvOrder[indxPath.row] as! [String : Any]
            id=String(format: "%@", lstPrvOrder[indxPath.row]["id"] as! CVarArg)
        }else{
            lProdItem = lstProducts[indxPath.row] as! [String : Any]
            id=String(format: "%@", lstProducts[indxPath.row]["id"] as! CVarArg)
        }
        let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
            
            if Cart["id"] as! String == id {
                return true
            }
            return false
        })
        var selUOMConv: String = "1"
        var selNetWt: String = ""
        if(items.count>0)
        {
            selUOM=String(format: "%@", items[0]["UOM"] as! CVarArg)
            selUOMNm=String(format: "%@", items[0]["UOMNm"] as! CVarArg)
            selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
            selNetWt=String(format: "%@", items[0]["NetWt"] as! CVarArg)
        }else{
            selUOM=String(format: "%@", lstProducts[indxPath.row]["Base_Unit_code"] as! CVarArg)
            selUOMNm=String(format: "%@", lstProducts[indxPath.row]["Product_Sale_Unit"] as! CVarArg)
            selUOMConv=String(format: "%@", lstProducts[indxPath.row]["OrdConvSec"] as! CVarArg)
            selNetWt=String(format: "%@", lstProducts[indxPath.row]["product_netwt"] as! CVarArg)
        }
        cell.txtQty.text = String(sQty)
        updateQty(id: id, sUom: selUOM, sUomNm: selUOMNm, sUomConv: selUOMConv,sNetUnt: selNetWt, sQty: String(sQty),ProdItem: lProdItem,refresh: 1)
        //tbView.reloadRows(at: [indxPath], with: .fade)
    }
    
    @objc private func minusQty(_ sender: UITapGestureRecognizer) {
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView:UITableView = GlobalFunc.getTableView(view: sender.view!) as! UITableView
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        var sQty: Int =  integer(from: cell.txtQty)
        
        let id: String
        let lProdItem:[String: Any]
        if(tbView==tbPrvOrderProduct)
        {
            lProdItem = lstPrvOrder[indxPath.row] as! [String : Any]
            id=String(format: "%@", lstPrvOrder[indxPath.row]["id"] as! CVarArg)
        }else{
            lProdItem = lstProducts[indxPath.row] as! [String : Any]
            id=String(format: "%@", lstProducts[indxPath.row]["id"] as! CVarArg)
        }
        let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
            
            if Cart["id"] as! String == id {
                return true
            }
            return false
        })
        var selUOMConv: String = "1"
        var selNetWt: String = ""
        if(items.count>0)
        {
            selUOM=String(format: "%@", items[0]["UOM"] as! CVarArg)
            selUOMNm=String(format: "%@", items[0]["UOMNm"] as! CVarArg)
            selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
            selNetWt=String(format: "%@", items[0]["NetWt"] as! CVarArg)
        }else{
            selUOM=String(format: "%@", lstProducts[indxPath.row]["Base_Unit_code"] as! CVarArg)
            selUOMNm=String(format: "%@", lstProducts[indxPath.row]["Product_Sale_Unit"] as! CVarArg)
            selUOMConv=String(format: "%@", lstProducts[indxPath.row]["OrdConvSec"] as! CVarArg)
            selNetWt=String(format: "%@", lstProducts[indxPath.row]["product_netwt"] as! CVarArg)
        }
        sQty = sQty-1
        if sQty<0 { sQty = 0 }
        cell.txtQty.text = String(sQty)
        updateQty(id: id, sUom: selUOM, sUomNm: selUOMNm, sUomConv: selUOMConv, sNetUnt: selNetWt, sQty: String(sQty),ProdItem: lProdItem,refresh: 1)
        //tbView.reloadRows(at: [indxPath], with: .fade)
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
               //textField.text = truncatedText

               Toast.show(message: "Text count cannot be more than 6 characters.")
            return ConvInt2
            
           }
        return number
    }
    
    func updateQty(id: String,sUom: String,sUomNm: String,sUomConv: String,sNetUnt: String,sQty: String,ProdItem:[String: Any],refresh: Int) {
        let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (item) in
            if item["id"] as! String == id {
                return true
            }
            return false
        })
      //  let TotQty: Double = Double((sQty as! NSString).intValue * (sUomConv as! NSString).intValue)
        let sQtyValue = (sQty as NSString).intValue
        let sUomConvValue = (sUomConv as NSString).intValue

        let multipliedResult: Int64 = Int64(sQtyValue) * Int64(sUomConvValue)
        let TotQty: Double = Double(multipliedResult)
        
        let Schemes: [AnyObject] = lstSchemList.filter ({ (item) in
            if item["PCode"] as! String == id && (item["Scheme"] as! NSString).doubleValue <= TotQty {
                return true
            }
            return false
        })
        var Scheme: Double = 0
        var FQ : Int32 = 0
        var OffQty: Int = 0
        var OffProd: String = ""
        var OffProdNm: String = ""
        var Rate: Double = 0
        var Schmval: String = ""
        var Disc: String = ""
        let RateItems: [AnyObject] = lstRateList.filter ({ (Rate) in
            
            if Rate["Product_Detail_Code"] as! String == id {
                return true
            }
            return false
        })
        print(RateItems)
        print(TotQty)
        if(RateItems.count>0){
            Rate = (RateItems[0]["Retailor_Price"] as! NSString).doubleValue
        }
        print(Rate)
        var ItmValue: Double = (TotQty*Rate)
        if(Schemes.count>0){
            Scheme = (Schemes[0]["Scheme"] as! NSString).doubleValue
            FQ = (Schemes[0]["FQ"] as! NSString).intValue
            let SchmQty: Double
            if(Schemes[0]["pkg"] as! String == "Y"){
                SchmQty=Double(Int(TotQty / Scheme))
            } else {
                SchmQty = (TotQty / Scheme)
            }
            OffQty = Int(SchmQty * Double(FQ))
            OffProd = Schemes[0]["OffProd"] as! String
            OffProdNm = Schemes[0]["OffProdNm"] as! String
            
            
            var dis: Double = 0;
            Disc = Schemes[0]["Disc"] as! String
            if (Disc != "") {
                dis = ItmValue * (Double(Disc)! / 100);
            }
            Schmval = String(format: "%.02f", dis);
            ItmValue = ItmValue - dis;
        }
        if items.count>0 {
            if let i = VisitData.shared.ProductCart.firstIndex(where: { (item) in
                if item["id"] as! String == id {
                    return true
                }
                return false
            })
            {
                let itm: [String: Any]=["id": id,"Qty": sQty,"UOM": sUom, "UOMNm": sUomNm, "UOMConv": sUomConv, "SalQty": TotQty,"NetWt": sNetUnt,"Scheme": Scheme,"FQ": FQ,"OffQty": OffQty,"OffProd":OffProd,"OffProdNm":OffProdNm,"Rate": Rate,"Value": (TotQty*Rate), "Disc": Disc, "DisVal": Schmval, "NetVal": ItmValue];
                let jitm: AnyObject = itm as AnyObject
                VisitData.shared.ProductCart[i] = jitm
                print("\(VisitData.shared.ProductCart[i]) starts with 'A'!")
            }
        }else{
            let itm: [String: Any]=["id": id,"Qty": sQty,"UOM": sUom, "UOMNm": sUomNm, "UOMConv": sUomConv, "SalQty": TotQty,"NetWt": sNetUnt,"Scheme": Scheme,"FQ": FQ,"OffQty": OffQty,"OffProd":OffProd,"OffProdNm":OffProdNm, "Rate": Rate, "Value": (TotQty*Rate), "Disc": Disc, "DisVal": Schmval, "NetVal": ItmValue];
            let jitm: AnyObject = itm as AnyObject
            VisitData.shared.ProductCart.append(jitm)
            
        }
        print(VisitData.shared.ProductCart)
        updateOrderValues(refresh: refresh)
    }
    @objc private func deleteItem(_ sender: UITapGestureRecognizer) {
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView:UITableView = GlobalFunc.getTableView(view: sender.view!) as! UITableView
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        let id=String(format: "%@", lstPrvOrder[indxPath.row]["id"] as! CVarArg)
        lstPrvOrder.remove(at: indxPath.row)
        VisitData.shared.ProductCart.removeAll(where: { (item) in
            if item["id"] as! String == id {
                return true
            }
            return false
        })
        updateOrderValues(refresh: 1)
    }
    func updateOrderValues(refresh: Int){
        var totAmt: Double = 0
        var Upadet_table = 0
        lstPrvOrder = VisitData.shared.ProductCart.filter ({ (Cart) in
            
            if (Cart["SalQty"] as! Double) > 0 {
                return true
            }else{
                Upadet_table = 2
   
                print("No data")
            }
            return false
        })
        if lstPrvOrder.count>0 {
            for i in 0...lstPrvOrder.count-1 {
                let item: AnyObject = lstPrvOrder[i]
                totAmt = totAmt + (item["NetVal"] as! Double)
                //(item["SalQty"] as! NSString).doubleValue
                
            }
        }
        lblTotAmt.text = String(format: "Rs. %.02f", totAmt)
        lblPrvTotAmt.text = String(format: "Rs. %.02f", totAmt)
        print(totAmt)
        TotaAmout = String(totAmt)
        
        lblTotItem.text = String(format: "%i",  lstPrvOrder.count)
        lblPrvTotItem.text = String(format: "%i",  lstPrvOrder.count)
        if (refresh == 1 || Upadet_table == 2){
            tbPrvOrderProduct.reloadData()
            tbProduct.reloadData()
        }
      
    }
    
    @IBAction func SubmitCall(_ sender: Any) {
        var OrderSub = "OD"
        var Count = 0
        if validateForm() == false {
            return
        }
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit order?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.ShowLoading(Message: "Locating Device...")
            VisitData.shared.cOutTime = GlobalFunc.getCurrDateAsString()
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
                    print(sLocation)
                    print(sAddress)
                    if (OrderSub == "OD"){
                        self.OrderSubmit(sLocation: sLocation, sAddress: sAddress)
                        OrderSub  = ""
                        print(Count)
                    }else{
                        print(Count)
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
        var sPItems:String = ""
        var sPItems2:String = ""
        print(VisitData.shared.ProductCart)
        self.ShowLoading(Message: "Data Submitting Please wait...")
        for i in 0...self.lstPrvOrder.count-1{
            let item: [String: Any]=self.lstPrvOrder[i] as! [String : Any]
            let id=String(format: "%@", item["id"] as! CVarArg)
            let ProdItems = self.lstAllProducts.filter({(product) in
                let ProdId: String = String(format: "%@", product["id"] as! CVarArg)
                return Bool(ProdId == id)
            })
            //let itm: [String: Any]=["id": id,"Qty": sQty,"UOM": sUom, "UOMNm": sUomNm, "UOMConv": sUomConv, "SalQty": TotQty,"Scheme": Scheme,"FQ": FQ,"OffQty": OffQty,"OffProd":OffProd,"OffProdNm":OffProdNm, "Value": (TotQty*Rate)];
            if i>0 { sPItems = sPItems + "," }
            var Disc: String = item["Disc"] as! String
            if Disc == "" { Disc = "0"}
            var DisVal: String = item["DisVal"] as! String
            if DisVal == "" { DisVal="0" }
            
            //Thise Old
            
            //            sPItems = sPItems + "{\"product_code\":\""+id+"\",\"product_Name\":\""+(ProdItems[0]["name"] as! String)+"\",\"rx_Conqty\":" + (item["Qty"] as! String) + ",\"Qty\":" + (String(format: "%.0f", item["SalQty"] as! Double)) + ",\"PQty\":0,\"cb_qty\":0,\"free\":" + (String(format: "%i", item["OffQty"] as! Int)) + ",\"Pfree\":0,\"Rate\":" + (String(format: "%.2f", item["Rate"] as! Double)) + ",\"PieseRate\":" + (String(format: "%.2f", item["Rate"] as! Double)) + ",\"discount\":" + Disc + ",\"FreeP_Code\":\"" + (item["OffProd"] as! String) + "\",\"Fname\":\"" + (item["OffProdNm"] as! String) + "\",\"discount_price\":" +  DisVal + ",\"tax\":0.0,\"tax_price\":0.0,\"OrdConv\":\"" + (item["UOMConv"] as! String) + "\",\"selectedScheme\":" + (String(format: "%.0f", item["Scheme"] as! Double)) + ",\"product_unit_Code\":\"" + (item["UOM"] as! String) + "\",\"product_unit_name\":\"" + (item["UOMNm"] as! String) + "\",\"selectedOffProCode\":\"" + (item["UOM"] as! String) + "\",\"selectedOffProName\":\"" + (item["UOMNm"] as! String) + "\",\"selectedOffProUnit\":\"" + (item["UOMConv"] as! String) + "\",\"f_key\":{\"activity_stockist_code\":\"Activity_Stockist_Report\"}}"
            
            // Thise New
            
            sPItems = sPItems + "{\"product_code\":\""+id+"\",\"product_Name\":\""+(ProdItems[0]["name"] as! String)+"\",\"rx_Conqty\":" + (item["Qty"] as! String) + ",\"Qty\":" + (String(format: "%.0f", item["SalQty"] as! Double)) + ",\"PQty\":0,\"cb_qty\":0,\"free\":" + (String(format: "%i", item["OffQty"] as! Int)) + ",\"Pfree\":0,\"Rate\":" + (String(format: "%.2f", item["Rate"] as! Double)) + ",\"PieseRate\":" + (String(format: "%.2f", item["Rate"] as! Double)) + ",\"discount\":" + Disc + ",\"FreeP_Code\":\"" + (item["OffProd"] as! String) + "\",\"Fname\":\"" + (item["OffProdNm"] as! String) + "\",\"discount_price\":" +  DisVal + ",\"tax\":0.0,\"tax_price\":0.0,\"OrdConv\":\"" + (item["UOMConv"] as! String) + "\",\"product_unit_name\":\"" + (item["UOMNm"] as! String) + "\",\"selectedScheme\":" + (String(format: "%.0f", item["Scheme"] as! Double)) + ",\"selectedOffProCode\":\"" + (item["UOM"] as! String) + "\",\"selectedOffProName\":\"" + (item["UOMNm"] as! String) + "\",\"selectedOffProUnit\":\"" + (item["UOMConv"] as! String) + "\",\"f_key\":{\"activity_stockist_code\":\"Activity_Stockist_Report\"}}"
            
            print(item)
            sPItems2 = sPItems2 + "{\"product_code\":\""+id+"\",\"product_Name\":\""+(ProdItems[0]["name"] as! String)+"\",\"rx_Conqty\":" + (item["Qty"] as! String) + ",\"Qty\":" + (String(format: "%.0f", item["SalQty"] as! Double)) + ",\"PQty\":0,\"cb_qty\":0,\"free\":" + (String(format: "%i", item["OffQty"] as! Int)) + ",\"Pfree\":0,\"Pfree\":0,\"PieseRate\":" + (String(format: "%.2f", item["Rate"] as! Double)) + ",\"discount\":" + Disc + ",\"FreeP_Code\":0,\"Fname\":0,\"discount_price\":" +  DisVal + ",\"tax\":0.0,\"tax_price\":0.0,\"OrdConv\":" + (item["UOMConv"] as! String) + ",\"product_unit_name\":\"" + (item["UOMNm"] as! String) + "\",\"Trans_POrd_No\":\"\",\"Order_Flag\":0,\"Division_code\":29,\"selectedScheme\":" + (String(format: "%.0f", item["Scheme"] as! Double)) + ",\"selectedOffProCode\":\"" + (item["UOM"] as! String) + "\",\"selectedOffProName\":\"" + (item["UOMNm"] as! String) + "\",\"selectedOffProUnit\":\"" + (item["UOMConv"] as! String) + "\",\"sample_qty\":" + (String(format: "%.2f", item["Rate"] as! Double)) + "},"

         
          
        }
        
        print(sPItems)
      
        let DataSF: String = self.lstPlnDetail[0]["subordinateid"] as! String
        
        var sImgItems:String = ""
        if(PhotosCollection.shared.PhotoList.count>0){
            for i in 0...PhotosCollection.shared.PhotoList.count-1{
                let item: [String: Any] = PhotosCollection.shared.PhotoList[i] as! [String : Any]
                if i > 0 { sImgItems = sImgItems + "," }
                sImgItems = sImgItems + "{\"imgurl\":\"'" + (item["FileName"]  as! String) + "'\",\"title\":\"''\",\"remarks\":\"''\"}"
            }
        }
        // Thise Old
        
        //        let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"'" + (self.lstPlnDetail[0]["worktype"] as! String) + "'\",\"Town_code\":\"'" + (self.lstPlnDetail[0]["clusterid"] as! String) + "'\",\"RateEditable\":\"''\",\"dcr_activity_date\":\"'" + VisitData.shared.cInTime + "'\",\"Daywise_Remarks\":\"'" + VisitData.shared.VstRemarks.name + "'\",\"eKey\":\"" + self.eKey + "\",\"rx\":\"'1'\",\"rx_t\":\"''\",\"DataSF\":\"'" + DataSF + "'\"}},{\"Activity_Stockist_Report\":{\"Stockist_POB\":\"" + VisitData.shared.PayValue + "\",\"Worked_With\":\"''\",\"location\":\"'" + sLocation + "'\",\"geoaddress\":\"" + sAddress + "\",\"stockist_code\":\"'" + VisitData.shared.CustID + "'\",\"superstockistid\":\"''\",\"Stk_Meet_Time\":\"'" + VisitData.shared.cInTime + "'\",\"modified_time\":\"'" + VisitData.shared.cInTime + "'\",\"date_of_intrument\":\"" + VisitData.shared.DOP.id + "\",\"intrumenttype\":\""+VisitData.shared.PayType.id+"\",\"orderValue\":\"" + (lblTotAmt.text!).replacingOccurrences(of: "Rs. ", with: "") + "\",\"Aob\":0,\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"CheckoutTime\":\"" + VisitData.shared.cOutTime + "\",\"f_key\":{\"Activity_Report_Code\":\"'Activity_Report_APP'\"},\"PhoneOrderTypes\":" + VisitData.shared.OrderMode.id + "}},{\"Activity_Stk_POB_Report\":[" + sPItems +  "]},{\"Activity_Stk_Sample_Report\":[]},{\"Activity_Event_Captures\":[" + sImgItems +  "]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]}]"
        //
        // Thise New
        var lstPlnDetail: [AnyObject] = []
        if self.LocalStoreage.string(forKey: "Mydayplan") == nil { return }
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        let jwids=(String(format: "%@", lstPlnDetail[0]["worked_with_code"] as! CVarArg)).replacingOccurrences(of: "$$", with: ";")
            .replacingOccurrences(of: "$", with: ";")
            .components(separatedBy: ";")
        print(lstPlnDetail[0]["worked_with_code"] as! CVarArg)
        for k in 0...jwids.count-1 {
            if let indexToDelete = lstJoint.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == jwids[k] }) {
                print(lstJoint)
                let jwid: String = lstJoint[indexToDelete]["id"] as! String
                let jwname: String = lstJoint[indexToDelete]["name"] as! String
                
                strJWCd += jwid+";"
                strJWNm += jwname+";"
                let jitm: AnyObject = lstJoint[indexToDelete] as AnyObject
                lstJWNms.append(jitm)
            }
            
        }
        print(lstJWNms)
        print(strJWCd)
        let JointData = strJWCd
        var Join_Works = JointData.replacingOccurrences(of: ";", with: "$$")
        if Join_Works.hasSuffix("$") {

            Join_Works.removeLast()
            print(Join_Works)
        }
        

        if VisitData.shared.cInTime.isEmpty{
            print("No data")
            
            var sPItems3: String = ""
            if sPItems2.hasSuffix(",") {
                // Remove the last comma from sPItems2
                sPItems2.removeLast()
                sPItems3 = sPItems2
            }
            print(sPItems3)
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
            print(Date_Time)
            print(objcallsprimary)
            let jsonString2 = "{\"Products\":[" + sPItems3 + "],\"Activity_Event_Captures\":[],\"POB\":\"\(objcallsprimary[0]["POB"] as! Int)\",\"Value\":\"\(TotaAmout)\",\"order_No\":\"\(objcallsprimary[0]["Order_No"] as! String)\",\"DCR_Code\":\"\(objcallsprimary[0]["DCR_Code"] as! String)\",\"Trans_Sl_No\":\"\(objcallsprimary[0]["DCR_Code"] as! String)\",\"Trans_Detail_slNo\":\"\(objcallsprimary[0]["Trans_Detail_SlNo"] as! String)\",\"Route\":\"\",\"net_weight_value\":\"\",\"target\":\"\",\"rateMode\":null,\"Stockist\":\"\(objcallsprimary[0]["stockist_code"] as! String)\",\"RateEditable\":\"\",\"orderValue\":" + (lblTotAmt.text!).replacingOccurrences(of: "Rs. ", with: "") + ",\"Stockist_POB\":\"" + VisitData.shared.PayValue + "\",\"Stk_Meet_Time\":\"\(Date_Time)\",\"modified_time\":\"\(Date_Time)\",\"CheckoutTime\":\"\(Date_Time)\",\"PhoneOrderTypes\":0,\"dcr_activity_date\":\"\(Date_Time)\"}"
            

            

            
            let params2: Parameters = [
                "data": jsonString2 //"["+jsonString+"]"//
            ]
            print(params2)
            let axn = "dcr/updatePrimaryProducts"
            let apiKeys: String = "\(axn)&divisionCode=\(DivCode)&sfCode=\(SFCode)&desig=\(Desig)"
            print(apiKeys)
        print(SFCode)
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKeys, method: .post, parameters: params2, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            self.LoadingDismiss()
            switch AFdata.result
            {
                
            case .success(let value):
                print(value)
                if let json = value as? [String: Any] {
                    
                    Toast.show(message: "Order has been submitted successfully") //, controller: self
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                    UIApplication.shared.windows.first?.rootViewController = viewController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
                    VisitData.shared.clear()
                }
                
            case .failure(let error):
                let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                    return
                })
                self.present(alert, animated: true)
            }
        }
   
    }else{
        let jsonString =  "[{\"Activity_Report_APP\":{\"Worktype_code\":\"'" + (self.lstPlnDetail[0]["worktype"] as! String) + "'\",\"Town_code\":\"'" + (self.lstPlnDetail[0]["clusterid"] as! String) + "'\",\"RateEditable\":\"''\",\"dcr_activity_date\":\"'" + VisitData.shared.cInTime + "'\",\"Daywise_Remarks\":\"" + VisitData.shared.VstRemarks.name + "\",\"eKey\":\"" + self.eKey + "\",\"rx\":\"'1'\",\"rx_t\":\"''\",\"DataSF\":\"'" + DataSF + "'\"}},{\"Activity_Stockist_Report\":{\"Stockist_POB\":\"" + VisitData.shared.PayValue + "\",\"Worked_With\":\"'"+Join_Works+"'\",\"location\":\"'" + sLocation + "'\",\"geoaddress\":\"" + sAddress + "\",\"superstockistid\":\"''\",\"Stk_Meet_Time\":\"'" + VisitData.shared.cInTime + "'\",\"modified_time\":\"'" + VisitData.shared.cInTime + "'\",\"date_of_intrument\":\"" + VisitData.shared.DOP.id + "\",\"intrumenttype\":\""+VisitData.shared.PayType.id+"\",\"orderValue\":\"" + (lblTotAmt.text!).replacingOccurrences(of: "Rs. ", with: "") + "\",\"Aob\":0,\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"CheckoutTime\":\"" + VisitData.shared.cOutTime + "\",\"PhoneOrderTypes\":" + VisitData.shared.OrderMode.id + ",\"Super_Stck_code\":\"'\(VisitData.shared.Dist.id)'\",\"stockist_code\":\"'" + VisitData.shared.CustID + "'\",\"stockist_name\":\"''\",\"f_key\":{\"Activity_Report_Code\":\"'Activity_Report_APP'\"}}},{\"Activity_Stk_POB_Report\":[" + sPItems +  "]},{\"Activity_Stk_Sample_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]},{\"Activity_Event_Captures_Call\":[]}]"
        
        
        print(objcallsprimary)
   
        
        
        let params: Parameters = [
            "data": jsonString //"["+jsonString+"]"//
        ]
        print(params)

        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode + "&rSF=" + self.SFCode + "&sfCode=" + self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
        AFdata in
        self.LoadingDismiss()
        switch AFdata.result
        {
            
        case .success(let value):
            print(value)
            if let json = value as? [String: Any] {
                
                Toast.show(message: "Order has been submitted successfully") //, controller: self
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                UIApplication.shared.windows.first?.rootViewController = viewController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
                VisitData.shared.clear()
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
        
    }
    @objc private func GotoHome() {
        self.resignFirstResponder()
        if(vwPrvOrderCtrl.isHidden==false){
            vwPrvOrderCtrl.isHidden = true
            tbProduct.isHidden = false
        }else{
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
    @IBAction func closeWin(_ sender:Any){
        vwSelWindow.isHidden=true
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
    func updateEditOrderValues(){
        let item = productData1
        let item2 = productData2
        
        if let unwrappedProduct = item,let unwrappedProduct2 = item2 {
            
            let apiKey: String = "\(axnEdit)&State_Code=\(StateCode)&Trans_Detail_SlNo=\(unwrappedProduct)&Order_No=\(unwrappedProduct2)"
            
            
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
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
                        self.objcallsprimary = json
                        //Editoredr()
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
    
    
    func Editoredr(){
        print(objcallsprimary)
        print(lstAllProducts)
        print(lstAllProducts.count)
        
        let indxPath = lstAllProducts
        print(indxPath)
//        print(areypostion as Any)
//        var ary: Int = 0
//        if let unwrappedProduct = areypostion {
//            print(unwrappedProduct)
//            ary = unwrappedProduct
//        } else {
//            // The optional value is nil
//            print("Product is nil")
//        }
//        print(objcallsprimary)
//        let product = objcallsprimary[ary]
//        print(product)
        let Additional_Prod_Dtls = objcallsprimary[0]["Additional_Prod_Code"] as? String
        
        
        
        //        let price1 = objcallsprimary[0]["CQty"] as! Int
        //        for qtys in objcallsprimary["CQty"] {
        //
        //        }
        
     
        for proditem in objcallsprimary{
            let CQty = proditem["CQty"] as! Int
            print(objcallsprimary)
            let Product_Code = proditem["Product_Code"] as! String
            print(Product_Code)
        
        
        
        let productArray = Additional_Prod_Dtls?.components(separatedBy: "#")
        let filteredArray = productArray?.filter { !$0.isEmpty }
        print(filteredArray as Any)
        print(productArray as Any)
        if let products = filteredArray {
            for product in products {
                let productData = product.components(separatedBy: "~")
                
                let trimmedString = productData[0].trimmingCharacters(in: .whitespacesAndNewlines)
                print(trimmedString)
                let price = productData[1].components(separatedBy: "$")[0]
                print(price)
                
                
                let sQty : Int = Int(exactly: CQty)!
                print(sQty)
                let id: String
                let lProdItem:[String: Any]
                var BasUnitCode: Int = 0
                if let indexToDelete = lstAllProducts.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == "\(String(describing: Product_Code))" }) {
                    let stkname = lstAllProducts[indexToDelete]
                    print(indexToDelete)
                    print(stkname)
                    
                    // Safely unwrap Base_Unit_code and convert it to Int
                    if let baseUnitCodeStr = lstAllProducts[indexToDelete]["Base_Unit_code"] as? String,
                       let baseUnitCodeInt = Int(baseUnitCodeStr) {
                        BasUnitCode = baseUnitCodeInt
                        print(BasUnitCode)
                    } else {
                        print("Base_Unit_code is nil or not convertible to Int.")
                        let baseUnitCodeInt = lstAllProducts[indexToDelete]["Base_Unit_code"]
                        print(baseUnitCodeInt as Any)
                        if let transid = baseUnitCodeInt {
                            
                            if let transid2 = transid{
                                print(transid2)
                                BasUnitCode = transid2 as! Int
                                print(BasUnitCode)
                            } else {
                                print("Value is nil or not a String")
                            }
                        } else {
                            print("Value is nil or not a String")
                        }
                        
                    }
                    
                    lProdItem = stkname as! [String : Any]
                    print(indexToDelete as Any)
                    id=String(format: "%@", lstAllProducts[indexToDelete]["id"] as! CVarArg)
                    print(id)
                    let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
                        
                        if Cart["id"] as! String == productData[0] {
                            return true
                        }
                        return false
                    })
                    var selUOMConv: String = "1"
                    var selNetWt: String = ""
                    
                    if(items.count>0)
                    {
                        print(items)
                        selUOM=String(format: "%@", items[0]["UOM"] as! CVarArg)
                        selUOMNm=String(format: "%@", items[0]["UOMNm"] as! CVarArg)
                        selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
                        selNetWt=String(format: "%@", items[0]["NetWt"] as! CVarArg)
                    }else{
                        print(proditem)
                        
                        selUOM=String(BasUnitCode)
                        print(selUOM)
                        selUOMNm=String(proditem["Product_Unit_Name"] as! String)
                        print(selUOMNm)
                        selUOMConv=String(proditem["Product_Unit_Value"] as! Int)
                        print(selUOMConv)
                        selNetWt=String("")
                        print(selNetWt)
                    }
                    print(id)
                    print(selUOM)
                    print(selUOMNm)
                    print(selUOMConv)
                    print(selNetWt)
                    print(sQty)
                    print(lProdItem)
                    
                    updateQty(id: id, sUom: selUOM, sUomNm: selUOMNm, sUomConv: selUOMConv,sNetUnt: selNetWt, sQty: String(sQty),ProdItem: lProdItem,refresh: 1)
                }
                else {
                    print("Item not found in lstAllProducts.")
                }
                
                
            }
        }
    }
        
    }
    func DemoEdite(){
        for item in objcallsprimary{
            print(item)
            print(lstSuppList)
            let id: String
            let lProdItem:[String: Any]
            let Product_Code = item["Product_Code"] as! String
            var BasUnitCode: Int = 0
            let indexToDelete = lstAllProducts.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == "\(String(describing: Product_Code))" })
            let stkname = lstAllProducts[indexToDelete!]
            print(stkname)
            lProdItem = stkname as! [String : Any]
            id=String(format: "%@", lstAllProducts[indexToDelete!]["id"] as! CVarArg)
            let sUom = item["Product_Code"] as? String
            if let baseUnitCodeStr = lstAllProducts[indexToDelete!]["Base_Unit_code"] as? String,
               let baseUnitCodeInt = Int(baseUnitCodeStr) {
                BasUnitCode = baseUnitCodeInt
                print(BasUnitCode)
            }
            
            let sUomNm = item["Product_Unit_Name"] as? String
            let sUomConv = String((item["Product_Unit_Value"] as? Int)!)
            let sNetUnt = ""
            let sQty = item["Qty"] as? Int
            
            
            updateQty(id: sUom!, sUom: String(BasUnitCode), sUomNm: sUomNm!, sUomConv: sUomConv,sNetUnt: sNetUnt, sQty: String(sQty!),ProdItem: lProdItem,refresh: 1)
        }
    }
    
    
}




