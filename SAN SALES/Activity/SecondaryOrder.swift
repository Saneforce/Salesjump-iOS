//
//  SecondaryOrder.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 09/04/22.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

class SecondaryOrder: IViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

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
    @IBOutlet weak var lblRetailName: UILabel!
    @IBOutlet weak var lblTitleCap: UILabel!
    @IBOutlet weak var lblDistNm: UILabel!
    @IBOutlet weak var lblPrvDistNm: UILabel!
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
    
    let axn="get/vwOrderDetails"
    
   
    
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
    
    var lstDistList: [AnyObject] = []
    var ProdImages:[String: Any] = [:]
    var BrandImages:[String: Any] = [:]
    var selBrand: String = ""
    var selUOM: String = ""
    var selUOMNm: String = ""
    var isMulti: Bool = false
    var SFCode: String = ""
    var DataSF: String = ""
    var DivCode: String = ""
    var Desig: String = ""
    var StateCode: String = ""
    var eKey: String = ""
    var pCatIndexPath = IndexPath()
   // var product: Product?
    let LocalStoreage = UserDefaults.standard
    override func viewDidLoad() {
        loadViewIfNeeded()
        getUserDetails()
        EditSecondaryordervalue()
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
        Desig=prettyJsonData["desigCode"] as? String ?? ""
        eKey = String(format: "EK%@-%i", SFCode,Int(Date().timeIntervalSince1970))
        
        let lstCatData: String=LocalStoreage.string(forKey: "Brand_Master")!
        let lstProdData: String = LocalStoreage.string(forKey: "Products_Master")!
        let lstUnitData: String = LocalStoreage.string(forKey: "UnitConversion")!
        let lstSchemData: String = LocalStoreage.string(forKey: "Schemes_Master")!
        let lstRateData: String = LocalStoreage.string(forKey: "ProductRate_Master")!
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
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
        DataSF = self.lstPlnDetail[0]["subordinateid"] as! String
        
            if let lstDistData = LocalStoreage.string(forKey: "Distributors_Master_"+DataSF),
               let list = GlobalFunc.convertToDictionary(text:  lstDistData) as? [AnyObject] {
                lstDistList = list
            }
            
//        if let list = GlobalFunc.convertToDictionary(text: lstDistData) as? [AnyObject] {
//            lstDistList = list;
//        }
//
        if(lstPlnDetail.count > 0){
            let id=String(format: "%@", lstPlnDetail[0]["stockistid"] as! CVarArg)
            if let indexToDelete = lstDistList.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == id }) {
                let name: String = lstDistList[indexToDelete]["name"] as! String
                lblDistNm.text = name
                lblPrvDistNm.text = name
                VisitData.shared.Dist.name = name
                VisitData.shared.Dist.id = id
            }
        }
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        
        lblDistNm.addTarget(target: self, action: #selector(selOrdDistName))
        lblTitleCap.text = UserSetup.shared.SecondaryCaption
        lblRetailName.text = VisitData.shared.CustName
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
        /*if (pCatIndexPath.count<=0){
            collectionView.reloadItems(at: [indexPath])
        }else{
            collectionView.reloadItems(at: [pCatIndexPath,indexPath])
        }*/
            
        pCatIndexPath = indexPath
        tbProduct.reloadData()
        collectionView.reloadData()
            //collectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredVertically, animated: false)
            
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
           // cell.txtQty.text = 
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tbDataSelect == tableView {
            let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
            let name=item["name"] as! String
            let id=String(format: "%@", item["id"] as! CVarArg)
            if SelMode=="DIS" {
                lblDistNm.text = name
                lblPrvDistNm.text = name
                VisitData.shared.Dist.name = name
                VisitData.shared.Dist.id = id
                
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
                updateQty(id: selectProd, sUom: id, sUomNm: name, sUomConv: ConvQty,sNetUnt: selNetWt, sQty: String(sQty),ProdItem: lProdItem,refresh: 1)
            }
            closeWin(self)
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
    func openWin(Mode:String){
        SelMode=Mode
        lAllObjSel = lObjSel
        txSearchSel.text = ""
        vwSelWindow.isHidden=false
        
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
    @objc private func selOrdDistName(){
        isMulti=false
        lObjSel=lstDistList
        self.tbDataSelect.reloadData()
        lblSelTitle.text="Select the Distributor"
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
        return number
    }
    
    func updateQty(id: String,sUom: String,sUomNm: String,sUomConv: String,sNetUnt: String,sQty: String,ProdItem:[String: Any],refresh: Int){
        
        let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (item) in
            if item["id"] as! String == id {
                return true
            }
            return false
        })
        
        print(ProdItem)
        
        let TotQty: Double = Double((sQty as! NSString).intValue * (sUomConv as! NSString).intValue)
        
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
        if(RateItems.count>0){
            Rate = (RateItems[0]["Retailor_Price"] as! NSString).doubleValue
        }
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
        lstPrvOrder = VisitData.shared.ProductCart.filter ({ (Cart) in
            
            if (Cart["SalQty"] as! Double) > 0 {
                return true
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
        
        lblTotItem.text = String(format: "%i",  lstPrvOrder.count)
        lblPrvTotItem.text = String(format: "%i",  lstPrvOrder.count)
        if(refresh == 1){
            tbPrvOrderProduct.reloadData()
            tbProduct.reloadData()
        }
    }
    
    func validateForm() -> Bool {
        if VisitData.shared.Dist.id == "" {
            Toast.show(message: "Select the Distributor", controller: self)
            return false
        }
        lstPrvOrder = VisitData.shared.ProductCart.filter ({ (Cart) in
            if (Cart["SalQty"] as! Double) > 0 {
                return true
            }
            return false
        })
        if(lstPrvOrder.count<1){
            Toast.show(message: "Cart is Empty.", controller: self)
            return false
        }
        return true
    }
    
    @IBAction func SubmitCall(_ sender: Any) {
        if validateForm() == false {
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
                        self.OrderSubmit(sLocation: sLocation, sAddress: sAddress)
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
            
            sPItems = sPItems + "{\"product_code\":\""+id+"\", \"product_Name\":\""+(ProdItems[0]["name"] as! String)+"\","
            sPItems = sPItems + " \"Product_Rx_Qty\":" + (String(format: "%.0f", item["SalQty"] as! Double)) + ","
            sPItems = sPItems + " \"UnitId\": \"" + (item["UOM"] as! String) + "\","
            sPItems = sPItems + " \"UnitName\": \"" + (item["UOMNm"] as! String) + "\","
            sPItems = sPItems + " \"rx_Conqty\":" + (item["Qty"] as! String) + ","
            sPItems = sPItems + " \"Product_Rx_NQty\": 0,"
            sPItems = sPItems + " \"Product_Sample_Qty\": \"" + (String(format: "%.2f", item["NetVal"] as! Double)) + "\","
            sPItems = sPItems + " \"net_weight\": " + (item["NetWt"] as! String) + ","
            sPItems = sPItems + " \"free\": " + (String(format: "%i", item["OffQty"] as! Int)) + ","
            sPItems = sPItems + " \"FreePQty\": " + (String(format: "%i", item["FQ"] as! Int32)) + ","
            sPItems = sPItems + " \"FreeP_Code\": \"" + (item["OffProd"] as! String) + "\","
            sPItems = sPItems + " \"Fname\": \"" + (item["OffProdNm"] as! String) + "\","
            sPItems = sPItems + " \"discount\": " + Disc + ","
            sPItems = sPItems + " \"discount_price\": " +  DisVal + ","
            sPItems = sPItems + " \"tax\": 0,"
            sPItems = sPItems + " \"tax_price\": 0,"
            sPItems = sPItems + " \"Rate\": " + (String(format: "%.2f", item["Rate"] as! Double)) + ","
            sPItems = sPItems + " \"Mfg_Date\": \"\","
            sPItems = sPItems + " \"cb_qty\": 0,"
            sPItems = sPItems + " \"RcpaId\": \"\","
            sPItems = sPItems + " \"Ccb_qty\": 0,"
            sPItems = sPItems + " \"PromoVal\": 0,"
            sPItems = sPItems + " \"rx_remarks\": 0,"
            sPItems = sPItems + " \"rx_remarks_Id\": 0,"
            sPItems = sPItems + " \"OrdConv\":" + (item["UOMConv"] as! String) + ","
            sPItems = sPItems + " \"selectedScheme\":" + (String(format: "%.0f", item["Scheme"] as! Double)) + ","
            sPItems = sPItems + " \"selectedOffProCode\": \"" + (item["OffProd"] as! String) + "\","
            sPItems = sPItems + " \"selectedOffProName\":\"PIECE\","
            sPItems = sPItems + " \"selectedOffProUnit\": \"1\","
            sPItems = sPItems + " \"f_key\": {\"Activity_MSL_Code\": \"Activity_Doctor_Report\"}}"
            
        }
        var sImgItems:String = ""
        if(PhotosCollection.shared.PhotoList.count>0){
            for i in 0...PhotosCollection.shared.PhotoList.count-1{
                let item: [String: Any] = PhotosCollection.shared.PhotoList[i] as! [String : Any]
                if i > 0 { sImgItems = sImgItems + "," }
                sImgItems = sImgItems + "{\"imgurl\":\"'" + (item["FileName"]  as! String) + "'\",\"title\":\"''\",\"remarks\":\"''\",\"f_key\":{\"Activity_Report_Code\":\"Activity_Report_APP\"}}"
            }
        }
        
        
        let jsonString = "[{\"Activity_Report_APP\":{\"dcr_activity_date\":\"\'" + VisitData.shared.cInTime + "\'\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"Daywise_Remarks\":\"\'" + VisitData.shared.VstRemarks.name + "\'\",\"RateEditable\":\"\'\'\",\"Worktype_code\":\"\'" + (self.lstPlnDetail[0]["worktype"] as! String) + "\'\",\"Town_code\":\"\'" + (self.lstPlnDetail[0]["clusterid"] as! String) + "\'\",\"DataSF\":\"\'" + DataSF + "\'\",\"eKey\":\"" + self.eKey + "\"}},{\"Activity_Doctor_Report\":{\"modified_time\":\"\'" + VisitData.shared.cInTime + "\'\",\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"rateMode\":\"Nil\",\"visit_name\":\"\'\'\",\"CheckoutTime\":\"" + VisitData.shared.cOutTime + "\",\"Order_No\":\"\'0\'\",\"Doc_Meet_Time\":\"\'" + VisitData.shared.cInTime + "\'\",\"Worked_With\":\"\'\'\",\"discount_price\":\"0\",\"Discountpercent\":\"0\",\"PhoneOrderTypes\":\"" + VisitData.shared.OrderMode.id + "\",\"net_weight_value\":\"0\",\"stockist_name\":\"\'\'\",\"location\":\"\'" + sLocation + "\'\",\"stockist_code\":\"\'" + (VisitData.shared.Dist.id as! String) + "\'\",\"Order_Stk\":\"\'\'\",\"superstockistid\":\"\'\'\",\"geoaddress\":\"" + sAddress + "\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"},\"doctor_name\":\"\'" + VisitData.shared.CustName + "\'\",\"visit_id\":\"\'\'\",\"Doctor_POB\":\"0\",\"doctor_code\":\"\'" + VisitData.shared.CustID + "\'\"}},{\"Activity_Sample_Report\":[" + sPItems +  "]},{\"Trans_Order_Details\":[]},{\"Activity_Event_Captures\":[" + sImgItems +  "]},{\"Activity_Input_Report\":[]},{\"Compititor_Product\":[]},{\"PENDING_Bills\":[]}]"
        
        let params: Parameters = [
            "data": jsonString //"["+jsonString+"]"//
        ]
        print(params)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode=" + self.DivCode + "&rSF=" + self.SFCode + "&sfCode=" + self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            self.LoadingDismiss()
            PhotosCollection.shared.PhotoList = []
            switch AFdata.result
            {
               
            case .success(let value):
                print(value)
                if let json = value as? [String: Any] {
                    
                    Toast.show(message: "Order has been submitted successfully", controller: self)
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
    func EditSecondaryordervalue() {
       
      // let item = product
            
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&divisionCode=\(DivCode)&sfCode=\(SFCode)&DCR_Code=SEF1-171"
        let aFormData: [String: Any] = [
            "orderBy":"[\"name asc\"]","desig":"mgr"
        ]
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
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
                    //self. lblTotAmt.text = json[0][""]
                    self.lblTotAmt.text = String(json[0]["POB_Value"] as! Double)
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
        
    }
     
    @objc private func GotoHome() {
        self.resignFirstResponder()
        //let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbSecondaryVisit") as!  SecondaryVisit
        //self.navigationController?.pushViewController(vc, animated: true)
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
}
