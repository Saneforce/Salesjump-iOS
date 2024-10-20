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
//import YourModuleName
//import YourModuleName
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
    
   // var productData: ProductData?
   
    
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
    var indexToDeletesecond: String = ""
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
    var Editobjcalls: [AnyObject]=[]
    var productData : String?
    var ProdTrans_Sl_No : String?
    var areypostion: Int?
    var Order_Out: String?
    var disbuttername : String?
    var lbltotalamunt: Double = 0
    let LocalStoreage = UserDefaults.standard
    var net_weight_value: Int = 0
    var Cust_Code: String = ""
    var DCR_Code: String = ""
    var Trans_Sl_No: String = ""
    var Route: String = ""
    var Stockist_Code: String = ""
    var Edit_Order_Count = 0
    var lstJWNms: [AnyObject] = []
    var strJWCd: String = ""
    var strJWNm: String = ""
    var lstJoint: [AnyObject] = []
    var net_weight_data = ""
    var ImgName:String = ""
    
    var isFromMissedEntry : Bool = false
    var selectedSf : String!
    var missedDateSubmit : (String) -> () = { _ in}
    var missedDateEditData : ([SecondaryOrderSelectedList]) -> () = { _  in}
    var products = [SecondaryOrderSelectedList]()
    var selectedProducts = [SecondaryOrderSelectedList]()
    
    override func viewDidLoad() {
        loadViewIfNeeded()
       
        
        getUserDetails()
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
            print(lstProdData)
        }
        if let list = GlobalFunc.convertToDictionary(text: lstUnitData) as? [AnyObject] {
            lstAllUnitList = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: lstSchemData) as? [AnyObject] {
            lstSchemList = list;
            print(lstSchemData)
            print(lstAllProducts)
        }
        if let list = GlobalFunc.convertToDictionary(text: lstRateData) as? [AnyObject] {
            lstRateList = list;
            print(lstRateList)
        }
        if lstBrands.count>0{
            let item: [String: Any]=lstBrands[0] as! [String : Any]
            selBrand=String(format: "%@", item["id"] as! CVarArg)
            autoreleasepool{
            lstProducts = lstAllProducts.filter({(product) in
                let CatId: String = String(format: "%@", product["cateid"] as! CVarArg)
                print(CatId)
                print(selBrand)
                return Bool(CatId == selBrand)
            })
                print(lstProducts.count)
            }
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
            
//        if let list = GlobalFunc.convertToDictionary(text: lstDistData) as? [AnyObject] {
//            lstDistList = list;
//        }
//
        if(lstPlnDetail.count > 0){
            let id=String(format: "%@", lstPlnDetail[0]["stockistid"] as! CVarArg)
            if let indexToDelete = lstDistList.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == id }) {
                let name: String = lstDistList[indexToDelete]["name"] as! String
                print(name)
                //lblDistNm.text = name
                lblPrvDistNm.text = name
                //VisitData.shared.Dist.name = name
                //disbuttername =  VisitData.shared.Dist.name
                //VisitData.shared.Dist.id = id
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
        
        EditSecondaryordervalue()

        self.editMissedDateOrder()
        print(isFromMissedEntry)
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
            print(lstProducts)
        lstProducts = lstAllProducts.filter({(product) in
            let CatId: String = String(format: "%@", product["cateid"] as! CVarArg)
            return Bool(CatId == selBrand)
        })
        /*if (pCatIndexPath.count<=0){
            collectionView.reloadItems(at: [indexPath])
        }else{
            collectionView.reloadItems(at: [pCatIndexPath,indexPath])
        }*/
           print(lstProducts)
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
        return 120
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==tbProduct { return lstProducts.count }
        print(lstProducts)
        if tableView==tbPrvOrderProduct { return lstPrvOrder.count }
        if tableView == tbProduct {return Editobjcalls.count}
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
            print(lstPrvOrder)
            let item: [String: Any]=lstPrvOrder[indexPath.row] as! [String : Any]
            print(item)
            print([indexPath.row])
            let id=String(format: "%@", item["id"] as! CVarArg)
            print(id)
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
                print(Cart)
                print(id    )
                if Cart["id"] as! String == id {
                    return true
                }
                return false
            })
            cell.lblFreeCap.isHidden = true
            cell.lblFreeQty.isHidden = true
           // cell.lblFreeProd.isHidden = true
            if items.count>0 {
                let FQ: Int = items[0]["OffQty"] as! Int
                cell.lblFreeQty?.text = String(format: "%i", FQ)
                if FQ>0 {
                    cell.lblFreeCap.isHidden = false
                    cell.lblFreeQty.isHidden = false
                    //cell.lblFreeProd.isHidden = false
                }
                //cell.lblUOM?.text = items[0]["OffProd"] as? String
                if FQ != 0 && items[0]["OffProdNm"] as? String == ""{
                    cell.lblFreeProd?.text = ProdItems[0]["name"] as? String
                }else{
                    
                    cell.lblFreeProd?.text = items[0]["OffProdNm"] as? String
                }
                
                //cell.lblFreeProd?.text = items[0]["OffProdNm"] as? String
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
            else{
//
//            var secondPrd = ""
//           var matchingIDs = [String]()
//           print(lstProducts)
//         //  print(lstAllProducts)
//           let Additional_Prod_Dtls = Editobjcalls[0]["Additional_Prod_Code1"] as? String
//           let productArray = Additional_Prod_Dtls?.components(separatedBy: "#")
//           if let products = productArray {
//               for product in products {
//
//
//                       let productData = product.components(separatedBy: "~")
//                       print(productData[0])
//                   let price = productData[1].components(separatedBy: "$")[0]
//                   let price1 = productData[1].components(separatedBy: "$")[1]
//                   print(price)
//                   print(price1)
//                   secondPrd = productData[0].trimmingCharacters(in: .whitespacesAndNewlines)
//                   print(secondPrd)
//
//                   if (lstAllProducts.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == "\(secondPrd)" }) != nil) {
//                       cell.txtQty.text = String(price1)
//                       cell.lblMRP.text = String(price)
//
//
//                   } else {
//                       print("No Data")
//                   }
//
//               }
//           }
            
            

           
            let item: [String: Any]=lstProducts[indexPath.row] as! [String : Any]
            print(lstProducts)
            print(item)
            
            
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
                        print(imgurl)
                        if imgurl != "" {
                            let imageUrlString=String(format: "%@%@", APIClient.shared.ProdImgURL,(item["Product_Image"] as! String).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                           // if(NSURL(string: imageUrlString) != nil){
                            print(imageUrlString)
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
           // cell.lblFreeProd.isHidden = true
            if items.count>0 {
                cell.txtQty?.text = items[0]["Qty"] as? String
                cell.lblUOM?.text = items[0]["UOMNm"] as? String
                let FQ: Int = items[0]["OffQty"] as! Int
                cell.lblFreeQty?.text = String(format: "%i", FQ)
                if FQ>0 {
                    cell.lblFreeCap.isHidden = false
                    cell.lblFreeQty.isHidden = false
                    //cell.lblFreeProd.isHidden = false
                }
                //cell.lblUOM?.text = items[0]["OffProd"] as? String
                
                if FQ != 0 && items[0]["OffProdNm"] as? String == ""{
                    cell.lblFreeProd?.text = item["name"] as? String
                }else{
                    
                    cell.lblFreeProd?.text = items[0]["OffProdNm"] as? String
                }
                
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
            print(lObjSel)
            let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
            let name=item["name"] as! String
            let id=String(format: "%@", item["id"] as! CVarArg)
            if SelMode=="DIS" {
                lblDistNm.text = name
                lblPrvDistNm.text = name
                VisitData.shared.Dist.name = name
                VisitData.shared.Dist.id = id
                Stockist_Code = id
                
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
              
                //mani
                updateQty(id: selectProd, sUom: id, sUomNm: name, sUomConv: ConvQty,sNetUnt: selNetWt, sQty: String(sQty),ProdItem: lProdItem,refresh: 1)
            }
            closeWin(self)
        }
    }
    
//    func setSecEditeOrder(){
//      var  cell: cellListItem
//         var secondPrd = ""
//        var matchingIDs = [String]()
//        print(lstProducts)
//      //  print(lstAllProducts)
//        let Additional_Prod_Dtls = Editobjcalls[0]["Additional_Prod_Code1"] as? String
//        let productArray = Additional_Prod_Dtls?.components(separatedBy: "#")
//        if let products = productArray {
//            for product in products {
//
//
//                    let productData = product.components(separatedBy: "~")
//                    print(productData[0])
//                let price = productData[1].components(separatedBy: "$")[0]
//                let price1 = productData[1].components(separatedBy: "$")[1]
//                print(price)
//                print(price1)
//                secondPrd = productData[0].trimmingCharacters(in: .whitespacesAndNewlines)
//                print(secondPrd)
//
//                if let indexToDelete = lstAllProducts.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == "\(secondPrd)" }) {
//                    //cell.lblQty.text = price1
//
//                    let idmatch: () =  matchingIDs.append(indexToDeletesecond)
//                    let secprice = (indexToDelete)
//                    print(idmatch)
//                    print(indexToDelete)
//
//                } else {
//                    print("No Data")
//                }
//
//            }
//        }
//
//    }
    
    
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
        VisitData.shared.ProductCart = VisitData.shared.ProductCart.filter ({ (Cart) in
            
            if (Cart["SalQty"] as! Double) > 0 {
                return true
            }
            return false
        })
        if validateForm() {
            lstPrvOrder = VisitData.shared.ProductCart.filter ({ (Cart) in
                
                if (Cart["SalQty"] as! Double) > 0 {
                    return true
                }
                return false
            })
            
            tbPrvOrderProduct.reloadData()
            vwPrvOrderCtrl.isHidden = false
            tbProduct.isHidden = true
        }
    }
    @IBAction func closePreview(_ sender: Any) {
        VisitData.shared.ProductCart = VisitData.shared.ProductCart.filter ({ (Cart) in
            
            if (Cart["SalQty"] as! Double) > 0 {
                return true
            }
            return false
        })
        vwPrvOrderCtrl.isHidden = true
        tbProduct.isHidden = false
        tbProduct.reloadData()
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
            print(item)
            let selProdID=String(format: "%@", item["id"] as! CVarArg)
            print(lstAllUnitList)
            lstUnitList = lstAllUnitList.filter({(product) in
                let ProdId: String = String(format: "%@", product["Product_Code"] as! CVarArg)
                return Bool(ProdId == selProdID)
            })
        }
        print(lstUnitList)
        lObjSel=lstUnitList
        self.tbDataSelect.tag = indxPath.row
        self.tbDataSelect.reloadData()
        lblSelTitle.text="Select the UOM"
        openWin(Mode: "UOM")
    }
    @objc private func changeQty(_ txtQty: UITextField){
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: txtQty) as! cellListItem
        let tbView:UITableView = GlobalFunc.getTableView(view: txtQty) as! UITableView
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        
        var sQty: Int =  integer(from: cell.txtQty)
        print(sQty)
        let id: String
        let lProdItem:[String: Any]
        lstPrvOrder = VisitData.shared.ProductCart
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
        var Refresh = 1
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView:UITableView = GlobalFunc.getTableView(view: sender.view!) as! UITableView
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        print(indxPath)
        var sQty: Int =  integer(from: cell.txtQty)
        sQty = sQty+1
        let id: String
        let lProdItem:[String: Any]
        print(tbPrvOrderProduct as Any)
        lstPrvOrder = VisitData.shared.ProductCart
        if(tbView==tbPrvOrderProduct)
        {
            lProdItem = lstPrvOrder[indxPath.row] as! [String : Any]
            print(lProdItem)
            id=String(format: "%@", lstPrvOrder[indxPath.row]["id"] as! CVarArg)
            print(id)
        }else{
            lProdItem = lstProducts[indxPath.row] as! [String : Any]
            print(lProdItem)
            id=String(format: "%@", lstProducts[indxPath.row]["id"] as! CVarArg)
            print(id)
        }
        print(VisitData.shared.ProductCart)
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
            print(selUOM)
            selUOMNm=String(format: "%@", items[0]["UOMNm"] as! CVarArg)
            print(selUOMNm)
            selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
            print(selUOMConv)
            selNetWt=String(format: "%@", items[0]["NetWt"] as! CVarArg)
            print(selNetWt)
        }else{
            selUOM=String(format: "%@", lstProducts[indxPath.row]["Base_Unit_code"] as! CVarArg)
            print(selUOM)
            selUOMNm=String(format: "%@", lstProducts[indxPath.row]["Product_Sale_Unit"] as! CVarArg)
            print(selUOMNm)
            selUOMConv=String(format: "%@", lstProducts[indxPath.row]["OrdConvSec"] as! CVarArg)
            print(selUOMConv)
            selNetWt=String(format: "%@", lstProducts[indxPath.row]["product_netwt"] as! CVarArg)
            print(selNetWt)
        }
        cell.txtQty.text = String(sQty)
        if (sQty == 0){
            Refresh = 2
        }
        updateQty(id: id, sUom: selUOM, sUomNm: selUOMNm, sUomConv: selUOMConv,sNetUnt: selNetWt, sQty: String(sQty),ProdItem: lProdItem,refresh: Refresh)
        //tbView.reloadRows(at: [indxPath], with: .fade)
    }
    
    @objc private func minusQty(_ sender: UITapGestureRecognizer) {
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView:UITableView = GlobalFunc.getTableView(view: sender.view!) as! UITableView
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        var sQty: Int =  integer(from: cell.txtQty)
        
        let id: String
        let lProdItem:[String: Any]
        lstPrvOrder = VisitData.shared.ProductCart
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
        print(sQty)
        var Refresh = 1
        if (sQty == 0){
            Refresh = 2
        }
        
        updateQty(id: id, sUom: selUOM, sUomNm: selUOMNm, sUomConv: selUOMConv, sNetUnt: selNetWt, sQty: String(sQty),ProdItem: lProdItem,refresh: 2)
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
    
    func updateQty(id: String,sUom: String,sUomNm: String,sUomConv: String,sNetUnt: String,sQty: String,ProdItem:[String: Any],refresh: Int){
        var ReFresh:Int =  refresh
        let items: [AnyObject] = VisitData.shared.ProductCart.filter ({(item) in
            if item["id"] as! String == id {
                return true
            }
            return false
        })
        print(items)
        print(id)
        print(sUom)
        print(sUomNm)
        print(sUomConv)
        print(sNetUnt)
        print(sQty)
        print(refresh)
        print(ProdItem)
        
        let TotQty: Double = Double((sQty as! NSString).intValue * (sUomConv as! NSString).intValue)
        print(lstSchemList)
        let Schemes: [AnyObject] = lstSchemList.filter ({ (item) in
            print(item)
            print(id)
            print(TotQty)
            if item["PCode"] as! String == id && (item["Scheme"] as! NSString).doubleValue <= TotQty {
                return true
            }
            return false
        })
        if Schemes.isEmpty{
            print("No Schem")
            ReFresh = 3
        }
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
        if Rate == 0 {
            Toast.show(message: "Please Select Product With Rate Value", controller: self)
            return
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
                print(dis)
            }
            Schmval = String(format: "%.02f", dis);
            ItmValue = ItmValue - dis;
        }
        
        print(Scheme)
        print(FQ)
        print(OffQty)
        print(OffProd)
        print(OffProdNm)
        print(Rate)
        print(Schmval)
        print(Disc)
        print(refresh)
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
            print(itm)
            VisitData.shared.ProductCart.append(jitm)
            
        }
        print(VisitData.shared.ProductCart)
        updateOrderValues(refresh: ReFresh)
    }
    @objc private func deleteItem(_ sender: UITapGestureRecognizer) {
        print(lstPrvOrder)
        var totAmt: Double = 0
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
        if lstPrvOrder.count>0 {
            for i in 0...lstPrvOrder.count-1 {
                let item: AnyObject = lstPrvOrder[i]
                totAmt = totAmt + (item["NetVal"] as! Double)
            }
        }
        lblTotAmt.text = String(format: "Rs. %.02f", totAmt)
        lbltotalamunt = Double(totAmt)
        lblPrvTotAmt.text = String(format: "Rs. %.02f", totAmt)
        
        lblTotItem.text = String(format: "%i",  lstPrvOrder.count)
        lblPrvTotItem.text = String(format: "%i",  lstPrvOrder.count)
        tbPrvOrderProduct.reloadData()
        //updateOrderValues(refresh: 1)
    }
    func updateOrderValues(refresh: Int){
        print(refresh)
        var lstPrvOrders: [AnyObject] = []
        var Upadet_table = 0
        print(lstPrvOrder)
        print(VisitData.shared.ProductCart)
        var totAmt: Double = 0
        lstPrvOrder = VisitData.shared.ProductCart.filter ({ (Cart) in
            
            if (Cart["SalQty"] as! Double) > 0 {
                if (refresh == 1 || refresh == 3 ){
                  //  tbPrvOrderProduct.reloadData()
                }
                return true
            }else{
                Upadet_table = 2
                print("No data")
            }
            return false
        })
        lstPrvOrders = VisitData.shared.ProductCart.filter ({ (Cart) in
            
            if (Cart["SalQty"] as! Double) > 0 {
                return true
            }
            return false
        })
        lstPrvOrder = VisitData.shared.ProductCart
        print(lstPrvOrder)
        if lstPrvOrders.count>0 {
            for i in 0...lstPrvOrders.count-1 {
                let item: AnyObject = lstPrvOrders[i]
                totAmt = totAmt + (item["NetVal"] as! Double)
                //(item["SalQty"] as! NSString).doubleValue
                
            }
        }
        lblTotAmt.text = String(format: "Rs. %.02f", totAmt)
        print(totAmt)
        lbltotalamunt = Double(totAmt)
        lblPrvTotAmt.text = String(format: "Rs. %.02f", totAmt)
        
        lblTotItem.text = String(format: "%i",  lstPrvOrders.count)
        lblPrvTotItem.text = String(format: "%i",  lstPrvOrders.count)
        if (refresh == 1 || Upadet_table == 2 || refresh == 3){
            // tbProduct.reloadData()
        }
        
//        if (refresh == 3 ){
//            tbPrvOrderProduct.reloadData()
//        }
       
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
        }else {
            for i in 0..<lstPrvOrder.count {
                if (lstPrvOrder[i]["Rate"] as! Double) > 0 {
                    return true
                }
            }
            Toast.show(message: "Please select atleast one product with rate", controller: self)
            return false
        }
        return true
    }
    
    @IBAction func SubmitCall(_ sender: Any) {
        var OrderSub = "OD"
        var Count = 0
        print(SubmittedDCR.Order_Out_Time)
        print(lstPrvOrder.count)
        lstPrvOrder = VisitData.shared.ProductCart.filter ({ (Cart) in
            
            if (Cart["SalQty"] as! Double) > 0 {
                return true
            }
            return false
        })
        print(lstPrvOrder.count)
        if validateForm() == false {
            lstPrvOrder = VisitData.shared.ProductCart
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
                       
                    }
                    Count = Count+1
                    if (OrderSub == "OD"){
                        
                        if self.isFromMissedEntry == true {
                            self.OrderSubmitMissedDate(sLocation: sLocation, sAddress: sAddress)
                        }else {
                            self.OrderSubmit(sLocation: sLocation, sAddress: sAddress)
                        }
                        
                        
                        OrderSub  = ""
                        print(Count)
                    }else{
                        print(Count)
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
    
    func OrderSubmitMissedDate(sLocation: String,sAddress: String) {
        
        
        var productString = ""
        
        for i in 0..<self.lstPrvOrder.count {
            
            print(self.lstPrvOrder[i])
            let item: [String: Any]=self.lstPrvOrder[i] as! [String : Any]
            let id=String(format: "%@", item["id"] as! CVarArg)
            let uom=String(format: "%@", item["UOM"] as! CVarArg)
            let uomName=String(format: "%@", item["UOMNm"] as! CVarArg)
            let uomConv=String(format: "%@", item["UOMConv"] as! CVarArg)
            let netWt=String(format: "%@", item["NetWt"] as! CVarArg)
            
            let Qty=String(format: "%@", item["Qty"] as? CVarArg ?? "")
            
            
            
            
            
            let ProdItems = self.lstAllProducts.filter({(product) in
                let ProdId: String = String(format: "%@", product["id"] as! CVarArg)
                return Bool(ProdId == id)
            })
            print(ProdItems)
            
            let name =  ProdItems.first?["name"] as? String ?? ""
            
            print(VisitData.shared.Dist.id)
            print(VisitData.shared.Dist.name)
            
            self.products.append(SecondaryOrderSelectedList(productId: id, productName: name, unitId: uom, unitName: uomName, unitConversion: uomConv, rate: netWt, Qty: Qty, product: ProdItems.first, distributorId: VisitData.shared.Dist.id, distributorName: VisitData.shared.Dist.name, item: self.lstPrvOrder[i], subtotal: "\(lbltotalamunt)"))
            
        }
        
        if productString.hasSuffix(","){
            productString.removeLast()
        }
        
        
        let jsonString = "[{\"Activity_Report_APP\":{\"Worktype_code\":\"\'1\'\",\"Town_code\":\"\'699\'\",\"RateEditable\":\"\'\'\",\"dcr_activity_date\":\"\'2024-04-19 00:00:00\'\",\"workTypFlag_Missed\":\"F\",\"mydayplan\":1,\"mypln_town\":\"\'Aligarh\'\",\"mypln_town_id\":\"\'699\'\",\"hq_code\":\"\'SJQAMGR0005\'\",\"hq_name\":\"\'\'\",\"missed_date_entry\":1,\"Daywise_Remarks\":\"\",\"eKey\":\"EKSJQAMGR0005-1720613511000\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"DataSF\":\"\'SJQAMGR0005\'\"}},{\"Activity_Doctor_Report\":{\"Doctor_POB\":0,\"Worked_With\":\"\'\'\",\"Doc_Meet_Time\":\"\'2024-04-19 00:00:00\'\",\"modified_time\":\"\'2024-07-10 17:41:50\'\",\"net_weight_value\":\"1\",\"stockist_code\":\"\'693\'\",\"stockist_name\":\"\'ANIL MEDICALS\'\",\"superstockistid\":\"\'\'\",\"Discountpercent\":0,\"CheckinTime\":\"2024-07-10 17:41:49\",\"CheckoutTime\":\"2024-07-10 17:43:48\",\"location\":\"\'1\'\",\"geoaddress\":\"\",\"retLatitude\":\"27.8840796\",\"retLongitude\":\"78.069681\",\"PhoneOrderTypes\":\"0\",\"Order_Stk\":\"\'693\'\",\"Order_No\":\"\'\'\",\"rootTarget\":\"\",\"orderValue\":\"15.75\",\"rateMode\":\"free\",\"discount_price\":0,\"doctor_code\":\"\'684\'\",\"doctor_name\":\"\'Anupama medical store\'\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"}}},{\"Activity_Sample_Report\":[\(productString)]},{\"Trans_Order_Details\":[]},{\"Activity_Input_Report\":[]},{\"Activity_Event_Captures\":[]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]}]"
        
        
        
        
        missedDateEditData(self.products)
        self.LoadingDismiss()
        PhotosCollection.shared.PhotoList = []
        VisitData.shared.clear()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func OrderSubmit(sLocation: String,sAddress: String){
        
        var sPItems:String = ""
        var sPItems2:String = ""
        var netWet = 0.0
        var NetQty = 0.0
        var net_weight_data2 = 0.0
        var lstPlnDetail: [AnyObject] = []
        if self.LocalStoreage.string(forKey: "Mydayplan") == nil { return }
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        
    
        print(VisitData.shared.ProductCart.count)
        print(lstPrvOrder.count)
        self.ShowLoading(Message: "Data Submitting Please wait...")
        for i in 0...self.lstPrvOrder.count-1{
            let item: [String: Any]=self.lstPrvOrder[i] as! [String : Any]
            print(item)
            let id=String(format: "%@", item["id"] as! CVarArg)
            let ProdItems = self.lstAllProducts.filter({(product) in
                let ProdId: String = String(format: "%@", product["id"] as! CVarArg)
                return Bool(ProdId == id)
            })
            //let itm: [String: Any]=["id": id,"Qty": sQty,"UOM": sUom, "UOMNm": sUomNm, "UOMConv": sUomConv, "SalQty": TotQty,"Scheme": Scheme,"FQ": FQ,"OffQty": OffQty,"OffProd":OffProd,"OffProdNm":OffProdNm, "Value": (TotQty*Rate)];
           // if i>0 { sPItems = sPItems + "," }
            var Disc: String = item["Disc"] as! String
            if Disc == "" { Disc = "0"}
            var DisVal: String = item["DisVal"] as! String
            if DisVal == "" { DisVal="0" }
            
            if(item["Qty"] as! String == ""){
                NetQty = 0
            }else{
                NetQty = Double(item["Qty"] as! String)!
            }
            
            if(item["NetWt"] as! String == ""){
                netWet = 0
            }else{
                netWet = Double(item["NetWt"] as! String)!
            }
           let UomConvData = item["UOMConv"] as! String
            print(item)
            let uOM_Conv_NetWight = Double(NetQty) * Double(UomConvData)!
            let Wight_Data = uOM_Conv_NetWight * netWet
            net_weight_data2 = net_weight_data2 + Wight_Data
            net_weight_data = String(format: "%.2f",net_weight_data2)
            print(net_weight_data)
            
            sPItems = sPItems + "{\"product_code\":\""+id+"\", \"product_Name\":\""+(ProdItems[0]["name"] as! String)+"\","
            sPItems = sPItems + " \"Product_Rx_Qty\":" + (String(format: "%.0f", item["SalQty"] as! Double)) + ","
            sPItems = sPItems + " \"UnitId\": \"" + (item["UOM"] as! String) + "\","
            sPItems = sPItems + " \"UnitName\": \"" + (item["UOMNm"] as! String) + "\","
            sPItems = sPItems + " \"rx_Conqty\":" + (item["Qty"] as! String) + ","
            sPItems = sPItems + " \"Product_Rx_NQty\": 0,"
            sPItems = sPItems + " \"Product_Sample_Qty\": \"" + (String(format: "%.2f", item["NetVal"] as! Double)) + "\","
            sPItems = sPItems + " \"vanSalesOrder\":0,"
            //sPItems = sPItems + " \"net_weight\": " + (item["NetWt"] as! String) + ","
            sPItems = sPItems + " \"net_weight\": 0.0,"
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
            //sPItems = sPItems + " \"rx_remarks\": 0,"
            // sPItems = sPItems + " \"rx_remarks_Id\": 0,"
            sPItems = sPItems + " \"rx_remarks\":\"\","
            sPItems = sPItems + " \"rx_remarks_Id\": \"\","
            sPItems = sPItems + " \"OrdConv\":" + (item["UOMConv"] as! String) + ","
            sPItems = sPItems + " \"selectedScheme\":" + (String(format: "%.0f", item["Scheme"] as! Double)) + ","
            // sPItems = sPItems + " \"selectedOffProCode\": \"" + (item["OffProd"] as! String) + "\","
            sPItems = sPItems + " \"selectedOffProCode\": \"" + (item["UOM"] as! String) + "\","
            sPItems = sPItems + " \"selectedOffProName\":\"" + (item["UOMNm"] as! String) + "\","
            sPItems = sPItems + " \"selectedOffProUnit\": \"1\","
            sPItems = sPItems + " \"f_key\": {\"Activity_MSL_Code\": \"Activity_Doctor_Report\"}},"
            
        }
            for i in 0...self.lstPrvOrder.count-1{
                let item: [String: Any]=self.lstPrvOrder[i] as! [String : Any]
                print(item)
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
            
            sPItems2 = sPItems2 + "{\"product\":\""+id+"\", \"product_Nm\":\""+(ProdItems[0]["name"] as! String)+"\","
            sPItems2 = sPItems2 + " \"UnitId\": \"" + (item["UOM"] as! String) + "\","
            sPItems2 = sPItems2 + " \"UnitName\": \"" + (item["UOMNm"] as! String) + "\","
            sPItems2 = sPItems2 + " \"OrdConv\":" + (item["UOMConv"] as! String) + ","
            sPItems2 = sPItems2 + " \"free\": " + (String(format: "%i", item["OffQty"] as! Int)) + ","
            sPItems2 = sPItems2 + " \"HSN\": \"\","
            sPItems2 = sPItems2 + " \"Rate\": " + (String(format: "%.2f", item["Rate"] as! Double)) + ","
            sPItems2 = sPItems2 + " \"imageUri\": \"\","
            sPItems2 = sPItems2 + " \"Schmval\": 0,"
            sPItems2 = sPItems2 + " \"rx_qty\": " + (String(format: "%.0f", item["SalQty"] as! Double)) + ","
            sPItems2 = sPItems2 + " \"recv_qty\": 0,"
            sPItems2 = sPItems2 + " \"product_netwt\": 0,"
            sPItems2 = sPItems2 + " \"netweightvalue\": 0,"
            sPItems2 = sPItems2 + " \"conversionQty\": 3,"
            sPItems2 = sPItems2 + " \"cateid\": 1011,"
            sPItems2 = sPItems2 + " \"UcQty\": 3,"
            sPItems2 = sPItems2 + " \"rx_Conqty\":" + (item["Qty"] as! String) + ","
            sPItems2 = sPItems2 + " \"id\":\""+id+"\", \"name\":\""+(ProdItems[0]["name"] as! String)+"\","
            sPItems2 = sPItems2 + " \"rx_remarks\":\"\","
            sPItems2 = sPItems2 + " \"rx_remarks_Id\": \"\","
            sPItems2 = sPItems2 + " \"sample_qty\": \"" + (String(format: "%.2f", item["NetVal"] as! Double)) + "\","
            sPItems2 = sPItems2 + " \"FreeP_Code\": \"" + (item["OffProd"] as! String) + "\","
            sPItems2 = sPItems2 + " \"Fname\": \"" + (item["OffProdNm"] as! String) + "\","
            sPItems2 = sPItems2 + " \"PromoVal\": 0,"
            sPItems2 = sPItems2 + " \"discount\": " + Disc + ","
            sPItems2 = sPItems2 + " \"discount_price\": " +  DisVal + ","
            sPItems2 = sPItems2 + " \"tax\": 0,"
            sPItems2 = sPItems2 + " \"tax_price\": 0,"
            sPItems2 = sPItems2 + " \"selectedScheme\":" + (String(format: "%.0f", item["Scheme"] as! Double)) + ","
            sPItems2 = sPItems2 + " \"selectedOffProCode\": \"" + (item["UOM"] as! String) + "\","
            sPItems2 = sPItems2 + " \"selectedOffProName\":\"" + (item["UOMNm"] as! String) + "\","
            sPItems2 = sPItems2 + " \"selectedOffProUnit\": \"3\"},"
            
          
        }
        
        print(sPItems)
        print(sPItems2)
        
        
        
        
//        for i in 0...self.lstPrvOrder.count-1{
//
//            let item: [String: Any]=self.lstPrvOrder[i] as! [String : Any]
//            print(item)
//            let id=String(format: "%@", item["id"] as! CVarArg)
//            let ProdItems = self.lstAllProducts.filter({(product) in
//                let ProdId: String = String(format: "%@", product["id"] as! CVarArg)
//                return Bool(ProdId == id)
//            })
//            //let itm: [String: Any]=["id": id,"Qty": sQty,"UOM": sUom, "UOMNm": sUomNm, "UOMConv": sUomConv, "SalQty": TotQty,"Scheme": Scheme,"FQ": FQ,"OffQty": OffQty,"OffProd":OffProd,"OffProdNm":OffProdNm, "Value": (TotQty*Rate)];
//            if i>0 { sPItems2 = sPItems2 + "," }
//            var Disc: String = item["Disc"] as! String
//            if Disc == "" { Disc = "0"}
//            var DisVal: String = item["DisVal"] as! String
//            if DisVal == "" { DisVal="0" }
//
//
//
//        }
        print(lstPlnDetail)
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
        
        let Subtotal = lbltotalamunt
        print(Subtotal)
        
        var sPItems4: String = ""
        if sPItems.hasSuffix(",") {
            while sPItems.hasSuffix(",") {
                sPItems.removeLast()
            }
            sPItems4 = sPItems
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
        if (VisitData.shared.VstRemarks.name == "Enter the Remarks"){
            VisitData.shared.VstRemarks.name = ""
        }
        let jsonString = "[ {\"Activity_Report_APP\":{\"Worktype_code\":\"\'" + (self.lstPlnDetail[0]["worktype"] as! String) + "\'\",\"Town_code\":\"\'" + (self.lstPlnDetail[0]["clusterid"] as! String) + "\'\",\"RateEditable\":\"''\",\"dcr_activity_date\":\"\'" + VisitData.shared.cInTime + "\'\",\"Daywise_Remarks\":\"" + VisitData.shared.VstRemarks.name.trimmingCharacters(in: .whitespacesAndNewlines) + "\",\"eKey\":\"" + self.eKey + "\",\"rx\":\"'1'\",\"rx_t\":\"''\",\"DataSF\":\"\'" + DataSF + "\'\"}},{\"Activity_Doctor_Report\":{\"Doctor_POB\":0,\"Worked_With\":\"'"+Join_Works+"'\",\"Doc_Meet_Time\":\"\'" + VisitData.shared.cInTime + "\'\",\"modified_time\":\"\'" + VisitData.shared.cInTime + "\'\",\"net_weight_value\":\"\(net_weight_data)\",\"stockist_code\":\"\'" + (VisitData.shared.Dist.id ) + "\'\",\"stockist_name\":\"''\",\"superstockistid\":\"''\",\"Discountpercent\":0,\"CheckinTime\":\"" + VisitData.shared.cInTime + "\",\"CheckoutTime\":\"" + VisitData.shared.cOutTime + "\",\"location\":\"\'" + sLocation + "\'\",\"geoaddress\":\"" + sAddress + "\",\"PhoneOrderTypes\":\"" + VisitData.shared.OrderMode.id + "\",\"Order_Stk\":\"'15560'\",\"Order_No\":\"''\",\"rootTarget\":\"0\",\"orderValue\":\(Subtotal),\"disPercnt\":0.0,\"disValue\":0.0,\"finalNetAmt\":\(Subtotal),\"taxTotalValue\":0,\"discTotalValue\":0.0,\"subTotal\":0,\"No_Of_items\":\(lstPrvOrder.count),\"rateMode\":\"free\",\"discount_price\":0,\"doctor_code\":\"\'" + VisitData.shared.CustID + "\'\",\"doctor_name\":\"\'" + VisitData.shared.CustName + "\'\",\"doctor_route\":\"'mylapore'\",\"f_key\":{\"Activity_Report_Code\":\"'Activity_Report_APP'\"}}},{\"Activity_Sample_Report\":[" + sPItems4 +  "]},{\"Trans_Order_Details\":[]},{\"Activity_Input_Report\":[]}, {\"Activity_Event_Captures\":[" + sImgItems +  "]},{\"PENDING_Bills\":[]},{\"Compititor_Product\":[]},{\"Activity_Event_Captures_Call\":[]}]"
        
       
        let params: Parameters = [
            "data": jsonString //"["+jsonString+"]"//
        ]
   //     print(params)
        print(VisitData.shared.cInTime)
        print(SubmittedDCR.Order_Out_Time)
        
        if isFromMissedEntry {
            missedDateSubmit(jsonString)
            self.LoadingDismiss()
            PhotosCollection.shared.PhotoList = []
            VisitData.shared.clear()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        if VisitData.shared.cInTime.isEmpty {
          
            var sPItems3: String = ""
            if sPItems2.hasSuffix(",") {
                // Remove the last comma from sPItems2
                sPItems2.removeLast()
                sPItems3 = sPItems2
            }
            
            print("No data")
            let jsonString2 = "{\"Products\":[" + sPItems3 +  "],\"Activity_Event_Captures\":[],\"POB\":\"0\",\"Value\":\"\(Subtotal)\",\"disPercnt\":0.0,\"disValue\":0.0,\"finalNetAmt\":\(Subtotal),\"taxTotalValue\":\"0\",\"discTotalValue\":\"0.0\",\"subTotal\":\"\(Subtotal)\",\"No_Of_items\":\"\(lstPrvOrder.count)\",\"Cust_Code\":\"'\(Cust_Code)'\",\"DCR_Code\":\"\(DCR_Code)\",\"Trans_Sl_No\":\"\(Trans_Sl_No)\",\"Route\":\"\(Route)\",\"net_weight_value\":\"\(net_weight_data)\",\"Discountpercent\":0.0,\"discount_price\":0.0,\"target\":\"0\",\"rateMode\":\"free\",\"Stockist\":\"\(Stockist_Code)\",\"RateEditable\":\"\",\"PhoneOrderTypes\":0}"
            
            
            let params2: Parameters = [
                "data": jsonString2 //"["+jsonString+"]"//
            ]
            print(params2)
            
            
            
            if (Edit_Order_Count == 0){
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/updateProducts" + "&divisionCode=" + self.DivCode + "&sfCode=" + self.SFCode + "&desig=" + self.Desig, method: .post, parameters: params2, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
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
                        print(json)
                        if  let success = json["success"] as? Int{
                            self.Edit_Order_Count = success
                        }
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
     else{
         print(params)
         print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode + "&rSF=" + self.SFCode + "&sfCode=" + self.SFCode)
         
         AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode + "&rSF=" + self.SFCode + "&sfCode=" + self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
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
    
    func editMissedDateOrder() {
        
        if !self.selectedProducts.isEmpty {
            for product in selectedProducts {
                updateQty(id: product.productId, sUom: product.unitId, sUomNm: product.unitName, sUomConv: product.unitConversion,sNetUnt: product.rate, sQty: product.Qty,ProdItem: product.product as! [String : Any],refresh: 1)
            }
            
            let filteredArray = lstDistList.filter {($0["id"] as? Int) == Int(self.selectedProducts.first?.distributorId ?? "0")}
            if (filteredArray.isEmpty){
                VisitData.shared.Dist.id = ""
                lblDistNm.text = ""
            }else{
                VisitData.shared.Dist.id = String((filteredArray[0]["id"] as? Int)!)
                VisitData.shared.Dist.name = filteredArray[0]["name"] as? String ?? ""
                lblDistNm.text = filteredArray[0]["name"] as? String
            }
        }
    }
    
    func EditSecondaryordervalue() {
        let product = productData
        print(product as Any)
    
        //let product = SubmittedDCR.objcalls_SelectSecondaryorder2
       
//        var item = ""
//        if !product?.isEmpty {
//
//            let targetValue = product[0]["DCR_Code"] as! String
//            if targetValue == nil {
//                item = "0"
//            } else  {item = targetValue
//            }
//        }
       
            
//            let item = product[0]["DCR_Code"] as! String
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
    
    let button = UIButton()
    func Editoredr(sender: AnyObject) {
                print(Editobjcalls)
                print(lstAllProducts)
                print(lstAllProducts.count)
             let indxPath = lstAllProducts
               print(indxPath)
        print(areypostion as Any)
        var ary: Int = 0
        if let unwrappedProduct = areypostion {
            print(unwrappedProduct)
            ary = unwrappedProduct
        } else {
            // The optional value is nil
            print("Product is nil")
        }
       // let product = Editobjcalls[ary]
      
                let Additional_Prod_Dtls = Editobjcalls[0]["Additional_Prod_Code1"] as? String
                let productArray = Additional_Prod_Dtls?.components(separatedBy: "#")
                if let products = productArray {
                    for product in products {


                            let productData = product.components(separatedBy: "~")
                           
                        let trimmedString = productData[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        print(trimmedString)

                            let price = productData[1].components(separatedBy: "$")[0]
                            let price1 = Int(productData[1].components(separatedBy: "$")[1])
                        print(price1 as Any)
                           // print(price1)
                       // lstAllProducts
                        print(lstProducts)
                        
                        let sQty : Int = price1!
                        print(sQty)
                let id: String
                let lProdItem:[String: Any]
                        var BasUnitCode: Int = 0
                        //var BasUnitCode2: Int = 0
                        if let indexToDelete = lstAllProducts.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == "\(String(describing: trimmedString))" }) {
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
                            print(items)
                        if(items.count>0)
                        {
                            selUOM=String(format: "%@", items[0]["UOM"] as! CVarArg)
                            print(selUOM)
                            selUOMNm=String(format: "%@", items[0]["UOMNm"] as! CVarArg)
                            print(selUOMNm)
                           // selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
                            print(selUOMConv)
                            selNetWt=String(format: "%@", items[0]["NetWt"] as! CVarArg)
                            print(selNetWt)
                        }else{
                            selUOM=String(BasUnitCode)
                            print(selUOM)
                            selUOMNm=String(stkname["Product_Sale_Unit"] as! String)
                            print(selUOMNm)
                            //selUOMConv=String(stkname["conversionQty"] as! Int)
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
                        tbProduct.reloadData()

                        } else {
                            print("Item not found in lstAllProducts.")
                        }
                    }
                }
    }
    func DemoEdite(){
        print(Editobjcalls)
        print(lstAllUnitList)
        for item in Editobjcalls {
            if let stock_Code =  Editobjcalls[0]["Stockist_Code"] as? String{
                print(lstDistList)
               
                let filteredArray = lstDistList.filter { ($0["id"] as? Int) == Int(stock_Code) }
                print(filteredArray)
                if (filteredArray.isEmpty){
                    VisitData.shared.Dist.id = ""
                    lblDistNm.text = ""
                }else{
                    VisitData.shared.Dist.id = String((filteredArray[0]["id"] as? Int)!)
                    VisitData.shared.Dist.name = filteredArray[0]["name"] as? String ?? ""
                    lblDistNm.text = filteredArray[0]["name"] as? String
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

                    var Uomdata = lstAllUnitList.filter({(product) in
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
                
                    updateQty(id: Prod_Id, sUom: Uomid2, sUomNm: selUOMNm, sUomConv: UomConQtydata2,sNetUnt: selNetWt, sQty: sQty,ProdItem: lProdItem,refresh: 1)
            }
        }
    }
    }
     
    @objc private func GotoHome() {
        self.resignFirstResponder()
        print(self.resignFirstResponder())
//        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbSecondaryVisit") as!  SecondaryVisit
//        self.navigationController?.pushViewController(vc, animated: true)
        if(vwPrvOrderCtrl.isHidden==false){
                vwPrvOrderCtrl.isHidden = true
                tbProduct.isHidden = false
                tbProduct.reloadData()
        }else{
            let alert = UIAlertController(title: "Confirmation", message: "Do you want to cancel this order draft ?", preferredStyle: .alert)
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

struct SecondaryOrderSelectedList {
    
    var productId : String!
    var productName : String!
    var unitId : String!
    var unitName : String!
    var unitConversion : String!
    var rate : String!
    var Qty : String!
    var product: AnyObject!
    var distributorId : String!
    var distributorName : String!
    var item : AnyObject!
    var subtotal : String!
    
    init(productId: String!,productName: String!, unitId: String!, unitName: String!, unitConversion: String!, rate: String!, Qty: String!, product: AnyObject!,distributorId:String!,distributorName:String!,item:AnyObject!,subtotal:String!) {
        self.productId = productId
        self.productName = productName
        self.unitId = unitId
        self.unitName = unitName
        self.unitConversion = unitConversion
        self.rate = rate
        self.Qty = Qty
        self.product = product
        self.distributorId = distributorId
        self.distributorName = distributorName
        self.item = item
        self.subtotal = subtotal
    }
    
    
}
