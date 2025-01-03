//
//  DAY REPORT WITH DATE RANGE DETAILSViewController.swift
//  SAN SALES
//
//  Created by Anbu j on 26/10/24.
//

import UIKit
import Alamofire


class DAY_REPORT_WITH_DATE_RANGE_DETAILSViewController:UIViewController, UITableViewDataSource, UITableViewDelegate,  OrderRangeCellDelegate{
    
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var Hq_View: UIView!
    
    @IBOutlet weak var Hq_View_height: NSLayoutConstraint!
    
    @IBOutlet weak var hq_name_sel: UILabel!
    @IBOutlet weak var Date_View: UIView!
    @IBOutlet weak var date_sel: UILabel!
    @IBOutlet weak var HQ_and_Route_TB: UITableView!
    @IBOutlet weak var Scroll_height: NSLayoutConstraint!
    @IBOutlet weak var Table_height: NSLayoutConstraint!
    @IBOutlet weak var Item_Summary_table: UITableView!
    @IBOutlet weak var Day_Report_View: UIView!
    
    @IBOutlet weak var Scroll_View: UIScrollView!
    
    
    @IBOutlet weak var Hq_Name_lbl: UILabel!
    
    //Order Detils
    
    @IBOutlet weak var View_Back: UIImageView!
    @IBOutlet weak var Addres_View: UIView!
    @IBOutlet weak var Detils_Scroll_View: UIScrollView!
    @IBOutlet weak var das_Border_Line_View: UIView!
    @IBOutlet weak var Day_Report_TB: UITableView!
    @IBOutlet weak var Day_Report_TB_height: NSLayoutConstraint!
    @IBOutlet weak var Strik_Line: UIView!
    @IBOutlet weak var Scroll_Height_TB: NSLayoutConstraint!
    @IBOutlet weak var Calender_View: UIView!
    @IBOutlet weak var Sel_Wid: UIView!
    @IBOutlet weak var Text_Search: UITextField!
    @IBOutlet weak var Day_View_Stk: UILabel!
    @IBOutlet weak var From_no: UILabel!
    @IBOutlet weak var To_Retiler: UILabel!
    @IBOutlet weak var To_Addres: UILabel!
    @IBOutlet weak var To_No: UILabel!
    @IBOutlet weak var Total_item: UILabel!
    @IBOutlet weak var Tax: UILabel!
    @IBOutlet weak var Sch_Disc: UILabel!
    @IBOutlet weak var Cas_disc: UILabel!
    @IBOutlet weak var Net_Amt: UILabel!
    @IBOutlet weak var Order_No: UILabel!
    @IBOutlet weak var Order_Date: UILabel!
    @IBOutlet weak var Item_Summary_View: NSLayoutConstraint!
    @IBOutlet weak var Item_Summary_TB_hEIGHT: NSLayoutConstraint!
    @IBOutlet weak var Total_Value_Amt: UILabel!
    @IBOutlet weak var Share_Pdf: UIImageView!
    @IBOutlet weak var Share_Orde_Detils: UIImageView!
    @IBOutlet weak var Cash_Discount_Height: NSLayoutConstraint!
    @IBOutlet weak var Free_TB: UITableView!
    @IBOutlet weak var height_for_Free_Tb: NSLayoutConstraint!
    @IBOutlet weak var free_view: UIView!
    
    
    @IBOutlet weak var Free_Table_Height: NSLayoutConstraint!
    
    // View Open BY Primary Order
    
    
    @IBOutlet weak var Stk_lbl_hi: NSLayoutConstraint!
    @IBOutlet weak var Stk_Mob_Sym_Hi: NSLayoutConstraint!
    @IBOutlet weak var Stk_From_Mob_Hi: NSLayoutConstraint!
    @IBOutlet weak var phone_img: UIImageView!
    @IBOutlet weak var Address_Hi: NSLayoutConstraint!
    
    @IBOutlet weak var Bill_To_hi: NSLayoutConstraint!
    @IBOutlet weak var To_Addres_hi: NSLayoutConstraint!
    
    
    @IBOutlet weak var Zero_Billing_summary: UITableView!
    

    @IBOutlet weak var Zero_Billing_addres_Tb_Hi: NSLayoutConstraint!
    
    
    @IBOutlet weak var Zero_Billing_Summary_View_Hi: NSLayoutConstraint!
    
    
    @IBOutlet weak var Zero_Billing_View: UIView!
    
    struct Id:Any{
        var id:String
        var Stkid:String
        var RouteId:String
        var Orderdata:[OrderDetail]
    }
    
    struct OrderDetail:Any{
        var id:String
        var Route:String
        var Routeflg:String
        var Stockist:String
        var name:String
        var nameid:String
        var Adress:String
        var Volumes:String
        var Phone:String
        var Net_amount:String
        var Remarks:String
        var Total_Item:String
        var Tax:String
        var Scheme_Discount:String
        var Cash_Discount:String
        var tlDisAmt:String
        var Order_date:String
        var Order_Count:Int
        var Total_Dic:Double
        var Total_Tax:Double
        
        var Total_disc_lbl:String
        var Final_Amt:String
        var stkmob:String
        var Orderlist:[OrderItemModel]
    }
    
    struct Itemwise_Summary:Any{
        let productName: String
        let ProductID:String
        var Qty:Int
        var Free:Int
        var Vol:Double
    }
    
    var Itemwise_Summary_Data:[Itemwise_Summary] = []
    var Zero_Billing_Product:[Itemwise_Summary] = []
    
    var Orderdata:[Id] = []
    var Oredrdatadetisl:[OrderDetail] = []
    var Orderlist:[OrderItemModel] = []
    let cardViewInstance = CardViewdata()
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    var Desig: String=""
    var sfName:String = ""
    let LocalStoreage = UserDefaults.standard
    var ProductDetils: [AnyObject] = []
    var lstHQs: [AnyObject] = []
    var lObjSel: [AnyObject] = []
    struct OrderItemModel {
        let productName: String
        let ProductID:String
        let rateValue: String
        let qtyValue: String
        let freeValue: String
        let discValue: String
        let totalValue: String
        let taxValue: String
        let clValue: String
        let uomName: String
        let eQtyValue: String
        let litersVal: String
        let freeProductName: String
    }
    
    var Select_Dtae:String = ""
    var Sf_Id :String = ""
    var Total_Value:Double = 0
    
    
    var axn:String?
    var ACCode:String?
    var Typ:String?
    var CodeDate:String?
    var Hqname:String?
    var Total_and_Non_Total:String?
    
    var getaxn:String = ""
    var GetCode:String = ""
    var GetTyp:String = ""
    var GetDate:String = ""
    
    var Pc_Id:String = ""
    
    var FreeDetils:[Itemwise_Summary] = []
    
    @IBOutlet weak var Text_Share: UIImageView!
    var lstAllProducts: [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        let selectdate = DateFormatter()
        selectdate.dateFormat = "yyyy-MM-dd"
        let dates = selectdate.string(from: Date())
        Select_Dtae = dates
        date_sel.text = dates
        Sf_Id = SFCode
        
        
        if let a = axn,let A = ACCode,let Typ = Typ, let date = CodeDate, let name = Hqname,let Pc = Total_and_Non_Total {
            getaxn = a
            GetCode = A
            GetTyp = Typ
            GetDate = date
            Hq_Name_lbl.text = name
            Pc_Id = Pc
            
            if GetTyp == "3"{
                Cash_Discount_Height.constant = 0
                Stk_lbl_hi.constant = 0
                Stk_Mob_Sym_Hi.constant = 0
                Stk_From_Mob_Hi.constant = 0
                phone_img.isHidden = true
                Address_Hi.constant = 90
                Bill_To_hi.constant = 0
                To_Addres_hi.constant = 0
                
            }else{
                
            if UIDevice.current.userInterfaceIdiom == .phone {
                    appendDashedBorder(to: das_Border_Line_View)
                    appendDashedBorder(to: Strik_Line)
                }
            }
        }
        date_sel.text = GetDate
        
        let lstProdData: String = LocalStoreage.string(forKey: "Products_Master")!
        
        if let list = GlobalFunc.convertToDictionary(text: lstProdData) as? [AnyObject] {
            lstAllProducts = list;
            print(lstProdData)
        }
        
        
        if UserSetup.shared.SF_type == 1{
            Hq_View.isHidden = true
            Hq_View_height.constant = 0
        }
        
        
        cardViewInstance.styleSummaryView(Hq_View)
        cardViewInstance.styleSummaryView(Date_View)
        Addres_View.layer.cornerRadius = 10
        Addres_View.layer.shadowRadius = 2
        Detils_Scroll_View.layer.cornerRadius = 10
        BTback.addTarget(target: self, action: #selector(GotoHome))
        View_Back.addTarget(target: self, action: #selector(Back_View))
        HQ_and_Route_TB.dataSource = self
        HQ_and_Route_TB.delegate = self
        Item_Summary_table.dataSource = self
        Item_Summary_table.delegate = self
        Day_Report_TB.delegate = self
        Day_Report_TB.dataSource = self
        
        Free_TB.delegate = self
        Free_TB.dataSource = self
      
        
        Zero_Billing_summary.delegate = self
        Zero_Billing_summary.dataSource = self
        
        Share_Pdf.addTarget(target: self, action: #selector(cURRENT_iMG))
        Share_Orde_Detils.addTarget(target: self, action: #selector(Share_Order_Bill))
        
        
        Text_Share.addTarget(target: self, action: #selector(Textshare))
        
      
        Hq_View.isHidden = true
        Hq_View_height.constant = 0
        
        
      //  OrderDayReport()
        ViewOrder()
        
    }
    func appendDashedBorder(to view: UIView) {
        let borderColor = UIColor.gray.cgColor
            let yourViewShapeLayer: CAShapeLayer = CAShapeLayer()
            let yourViewSize = view.frame.size
            let yourViewShapeRect = CGRect(x: 0, y: 0, width: yourViewSize.width - 10, height: yourViewSize.height)
            yourViewShapeLayer.bounds = yourViewShapeRect
            yourViewShapeLayer.position = CGPoint(x: yourViewSize.width / 2.1, y: yourViewSize.height / 2)
            yourViewShapeLayer.fillColor = UIColor.clear.cgColor
            yourViewShapeLayer.strokeColor = borderColor
            yourViewShapeLayer.lineWidth = 1
            yourViewShapeLayer.lineJoin = .round
            yourViewShapeLayer.lineDashPattern = [4, 2]
            yourViewShapeLayer.path = UIBezierPath(roundedRect: yourViewShapeRect, cornerRadius: 3).cgPath
            view.layer.addSublayer(yourViewShapeLayer)
        }
    
    func getUserDetails(){
    let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
    let data = Data(prettyPrintedJson!.utf8)
    guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
    print("Error: Cannot convert JSON object to Pretty JSON data")
    return
    }
        print(prettyJsonData)
    SFCode = prettyJsonData["sfCode"] as? String ?? ""
    StateCode = prettyJsonData["State_Code"] as? String ?? ""
    DivCode = prettyJsonData["divisionCode"] as? String ?? ""
    sfName = prettyJsonData["sfName"] as? String ?? ""
    Desig=prettyJsonData["desigCode"] as? String ?? ""
    }
    
    
    func ViewOrder(){
        Oredrdatadetisl.removeAll()
        Orderdata.removeAll()
        Itemwise_Summary_Data.removeAll()
        Total_Value_Amt.text = "0.0"
        Total_Value = 0
       // self.ShowLoading(Message: "Loading...")
        
        var get_Hq_Id = SFCode
       // if GetTyp == "3"{
            get_Hq_Id =  RangeData.shared.Hq_Id
        //}
        
        
       let apiKey: String = "\(getaxn)&desig=\(Desig)&divisionCode=\(DivCode)&ACd=\(GetCode)&rSF=\(SFCode)&typ=\(GetTyp)&sfCode=\(get_Hq_Id)&State_Code=\(StateCode)"
        
            let aFormData: [String: Any] = [
                "orderBy":"[\"name asc\"]","desig":"mgr"
            ]
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
                    if let json = value as? [AnyObject]{
                        
                        var Sf_Count = 0
                        
                        for j in json{
                            Sf_Count = Sf_Count + 1
                            let id = j["id"] as? String ?? ""
                            let Route = j["Territory"] as? String ?? ""
                            let Stockist = j["stockist_name"] as? String ?? ""
                            let name = j["name"] as? String ?? ""
                            let nameid = j["Order_No"] as? String ?? ""
                            let Adress = j["Address"] as? String ?? ""
                            let liters = j["liters"] as? Double ?? 0
                            let Volumes = (liters * 100).rounded() / 100
                            let Phone = j["phoneNo"] as? String ??  ""
                            var netAmount = ""
                            
                            if nameid == "SJQAMGR0024-24-25-SO-168"{
                                print("v")
                            }
                            
                            
                            if GetTyp == "1"{
                                netAmount = j["finalNetAmnt"] as? String ?? ""
                            }else{
                                netAmount = String(j["orderValue"] as? Double ?? 0)
                            }
                            
                            var Remarks = ""

                            if let secRemark = j["secOrdRemark"] as? String, !secRemark.isEmpty {
                                Remarks = secRemark
                            } else {
                                Remarks = j["remarks"] as? String ?? ""
                            }

                            
                            
                            let Stkid = j["stockist_code"] as? String ?? ""
                            let tlDisAmt = j["tlDisAmt"] as? String ?? ""
                            let Order_date = j["Order_date"] as? String ?? ""
                            
                            
                            
                            var minsAmount = Double(netAmount.isEmpty ? "0" : netAmount)! - Double(tlDisAmt.isEmpty ? "0" :tlDisAmt)!
                            
                            var  Net_amount = netAmount.isEmpty ? "0" : netAmount
                            var Final_Amt = String(format: "%.2f", minsAmount)
                            
                            print(minsAmount)
                            
                            if GetTyp == "1"{
                                
                               
                                let Getproducts = j["products"] as? String ?? ""
                                
                            if let i = Orderdata.firstIndex(where: { (item) in
                                
                                print(item.Stkid)
                                print(Stkid)
                                if item.Stkid == Stockist && item.RouteId == Route {
                                    return true
                                }
                                return false
                            }){
                                print(i)
                                print(j)
                                let products = j["products"] as? String ?? ""
                                var Additional_Prod_Code = ""
                               
                                
                                var taxArray: [String] = []
                                if GetTyp == "1"{
                                    let tax_price = j["tax_price"] as? String ?? ""
                                    
                                    if !tax_price.isEmpty {
                                        taxArray = tax_price.split(separator: "#").map { String($0) }
                                    }
                                    
                                    Additional_Prod_Code =  j["Additional_Prod_Code"] as? String ?? ""
                                    if nameid == "SJQAMGR0024-24-25-SO-176"{
                                        print(taxArray)
                                    }
                                    
                                    
                                }else{
                                    let tax_price = j["tax_price_free"] as? String ?? ""
                                    if !tax_price.isEmpty {
                                        taxArray = tax_price.split(separator: "$").map { String($0) }
                                    }
                                    print(taxArray)
                                    Additional_Prod_Code =  j["Product_Code"] as? String ?? ""
                                }
                                
                                print(Additional_Prod_Code)
                                
                               // let itemList = parseProducts(products, Additional_Prod_Code, taxArray: taxArray)
                                
                                let Additional_Prod_Dtls = j["productList"] as! [AnyObject]
                                var itemModelList = [OrderItemModel]()
                                for Item2 in Additional_Prod_Dtls {
                                    let orderItem = OrderItemModel(
                                        productName: Item2["Product_Name"] as? String ?? "",
                                        ProductID: Item2["Product_Code"] as? String ?? "",
                                        rateValue: String(Item2["Rate"] as? Double ?? 0),
                                        qtyValue: String(Item2["Quantity"] as? Int ?? 0),
                                        freeValue: String(Item2["Free"] as? Int ?? 0),
                                        discValue: String(Item2["discount_price"] as? Double ?? 0),
                                        totalValue: String(Item2["sub_total"] as?  Double ?? 0),
                                        taxValue: String(Item2["taxval"] as? Double ?? 0),
                                        clValue: String(Item2["cl_value"] as? Double ?? 0),
                                        uomName: Item2["Product_Unit_Name"] as? String ?? "",
                                        eQtyValue:String(Item2["eqty"] as? Int ?? 0),
                                        litersVal: String(Item2["liters"] as? Double ?? 0),
                                        freeProductName: Item2["Offer_ProductNm"] as? String ?? ""
                                    )
                                    print(orderItem)
                                    itemModelList.append(orderItem)
                                }
                                
                                let itemList = itemModelList
                                
                                
                                
                                let Order_Count = Oredrdatadetisl[i].Order_Count + 1
                                
                                var Total_discValue = 0.0
                                var Total_taxValue = 0.0
                                var Total_Amount = 0.0
                                for k in itemList{
                                    Total_discValue = Total_discValue + Double(k.discValue)!
                                    Total_taxValue = Total_taxValue + Double(k.taxValue)!
                                    Total_Amount = Total_Amount + Double(k.totalValue)!
                                }
                                
                                if minsAmount == 0{
                                    minsAmount =  Total_Amount
                                    Final_Amt = String(Total_Amount)
                                    Net_amount = String(Total_Amount)
                                }
                               
                                let stkMobNo = j["stkMobNo"] as? String ?? ""
                                
                                if !Getproducts.isEmpty && Pc_Id == "PC:"{
                                    
                                    Orderdata[i].Orderdata.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: "\(Sf_Count). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: Order_Count,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount ()", Final_Amt: Final_Amt, stkmob: stkMobNo, Orderlist: itemList))
                                    
                                    Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: "\(Sf_Count)). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: Order_Count,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount ()", Final_Amt: Final_Amt, stkmob: stkMobNo,Orderlist: itemList))
                                }else if Pc_Id == "TC:"{
                                    Orderdata[i].Orderdata.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: "\(Sf_Count). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: Order_Count,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount ()", Final_Amt: Final_Amt, stkmob: stkMobNo, Orderlist: itemList))
                                    
                                    Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: "\(Sf_Count). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: Order_Count,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount ()", Final_Amt: Final_Amt, stkmob: stkMobNo,Orderlist: itemList))
                                }
                         
                                Total_Value = Total_Value + minsAmount
                                
                            }else{
                                
                                var Additional_Prod_Code = ""
                                
                                let products = j["products"] as? String ?? ""
                                let productArray = products.split(separator: ",").map { String($0) }
                                print(productArray)
                                var taxArray: [String] = []
                                if GetTyp == "1"{
                                    let tax_price = j["tax_price"] as? String ?? ""
                                    
                                    if !tax_price.isEmpty {
                                        taxArray = tax_price.split(separator: "#").map { String($0) }
                                    }
                                    
                                    Additional_Prod_Code =  j["Additional_Prod_Code"] as? String ?? ""
                                    print(taxArray)
                                }else{
                                    let tax_price = j["tax_price_free"] as? String ?? ""
                                    if !tax_price.isEmpty {
                                        taxArray = tax_price.split(separator: "$").map { String($0) }
                                    }
                                    Additional_Prod_Code =  j["Product_Code"] as? String ?? ""
                                }
                                let Order_date = j["Order_date"] as? String ?? ""
                               // let itemList = parseProducts(products, Additional_Prod_Code, taxArray: taxArray)
                                
                                
                                let Additional_Prod_Dtls = j["productList"] as! [AnyObject]
                                print(Additional_Prod_Dtls)
                                var itemModelList = [OrderItemModel]()
                                for Item2 in Additional_Prod_Dtls {
                                    let orderItem = OrderItemModel(
                                        productName: Item2["Product_Name"] as? String ?? "",
                                        ProductID: Item2["Product_Code"] as? String ?? "",
                                        rateValue: String(Item2["Rate"] as? Double ?? 0),
                                        qtyValue: String(Item2["Quantity"] as? Int ?? 0),
                                        freeValue: String(Item2["Free"] as? Int ?? 0),
                                        discValue: String(Item2["discount_price"] as? Double ?? 0),
                                        totalValue: String(Item2["sub_total"] as?  Double ?? 0),
                                        taxValue: String(Item2["taxval"] as? Double ?? 0),
                                        clValue: String(Item2["cl_value"] as? Double ?? 0),
                                        uomName: Item2["Product_Unit_Name"] as? String ?? "",
                                        eQtyValue:String(Item2["eqty"] as? Int ?? 0),
                                        litersVal: String(Item2["liters"] as? Double ?? 0),
                                        freeProductName: Item2["Offer_ProductNm"] as? String ?? ""
                                    )
                                    print(orderItem)
                                    itemModelList.append(orderItem)
                                }
                                
                                let itemList = itemModelList
                                
                                
                                print(itemList)
                                var Total_discValue = 0.0
                                var Total_taxValue = 0.0
                                var Total_Amount = 0.0
                                for k in itemList{
                                    Total_discValue = Total_discValue + Double(k.discValue)!
                                    Total_taxValue = Total_taxValue + Double(k.taxValue)!
                                    Total_Amount = Total_Amount + Double(k.totalValue)!
                                }
                                if minsAmount == 0{
                                    minsAmount =  Total_Amount
                                    Final_Amt = String(Total_Amount)
                                    Net_amount = String(Total_Amount)
                                }
                                
                                
                                let stkMobNo = j["stkMobNo"] as? String ?? ""
                                
                                if !Getproducts.isEmpty && Pc_Id == "PC:"{
                                    
                                    
                                    Orderdata.append(Id(id: id, Stkid: Stockist, RouteId: Route, Orderdata: [OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: "\(Sf_Count). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: 1,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount ()", Final_Amt: Final_Amt, stkmob: stkMobNo, Orderlist: itemList)]))
                                    
                                    Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: "\(Sf_Count). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: 1,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount ()", Final_Amt: Final_Amt, stkmob: stkMobNo,Orderlist: itemList))
                                }else if Pc_Id == "TC:"{
                                    Orderdata.append(Id(id: id, Stkid: Stockist, RouteId: Route, Orderdata: [OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: "\(Sf_Count). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: 1,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount ()", Final_Amt: Final_Amt, stkmob: stkMobNo, Orderlist: itemList)]))
                                    
                                    Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: "\(Sf_Count). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: 1,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount ()", Final_Amt: Final_Amt, stkmob: stkMobNo,Orderlist: itemList))
                                }
                           
                                Total_Value += minsAmount
                                
                            }
                                
                              
                                
                        }else{
                            let Additional_Prod_Dtls = j["productList"] as! [AnyObject]
                            let stkMobNo = j["mobNo"] as? String ?? ""
                            var itemModelList = [OrderItemModel]()
                            for Item2 in Additional_Prod_Dtls {
                                let orderItem = OrderItemModel(
                                    productName: Item2["Product_Name"] as? String ?? "",
                                    ProductID: Item2["Product_Code"] as? String ?? "",
                                    rateValue: String(Item2["Rate"] as? Double ?? 0),
                                    qtyValue: String(Item2["Quantity"] as? Int ?? 0),
                                    freeValue: String(Item2["Free"] as? Int ?? 0),
                                    discValue: String(Item2["discount_price"] as? Double ?? 0),
                                    totalValue: String(Item2["sub_total"] as?  Double ?? 0),
                                    taxValue: String(Item2["taxval"] as? Double ?? 0),
                                    clValue: String(Item2["cl_value"] as? Double ?? 0),
                                    uomName: Item2["Product_Unit_Name"] as? String ?? "",
                                    eQtyValue:String(Item2["eqty"] as? Int ?? 0),
                                    litersVal: String(0),
                                    freeProductName: {
                                          let name = Item2["Offer_ProductNm"] as? String ?? ""
                                          return name.isEmpty ? Item2["Product_Name"] as? String ?? "" : name
                                      }()
                                )
                                itemModelList.append(orderItem)
                            }
                            
                            let itemList = itemModelList
                            
                            
                            var Total_discValue = 0.0
                            var Total_taxValue = 0.0
                            
                            for k in itemList{
                                Total_discValue = Total_discValue + Double(k.discValue)!
                                Total_taxValue = Total_taxValue + Double(k.taxValue)!
                            }
                            
                            
                            Orderdata.append(Id(id: id, Stkid: Stockist, RouteId: Route, Orderdata: [OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: "\(Sf_Count). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: stkMobNo, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: 1,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount (10%)", Final_Amt: Final_Amt, stkmob: "", Orderlist: itemList)]))
                            
                            Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: "\(Sf_Count). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: stkMobNo, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: 1,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount ()", Final_Amt: Final_Amt, stkmob: "",Orderlist: itemList))
                            
                            Total_Value += Double(Net_amount) ?? 0.0
                            
                        }
                            
                        }
                        
                        
                        
                        
                        
                        for item in Oredrdatadetisl{
                            for j in item.Orderlist{
                                    let qty = Double(j.qtyValue) ?? 0
                                    let free = Double(j.freeValue) ?? 0
                                    let value = Double(j.litersVal) ?? 0
                                    let productID = j.ProductID.trimmingCharacters(in: .whitespacesAndNewlines)

                                    if let index = Itemwise_Summary_Data.firstIndex(where: {
                                        $0.ProductID.trimmingCharacters(in: .whitespacesAndNewlines) == productID
                                    }) {
                                        Itemwise_Summary_Data[index].Qty += Int(qty)
                                        Itemwise_Summary_Data[index].Free += Int(free)
                                        Itemwise_Summary_Data[index].Vol += Double(value)
                                    } else {
                                        let newItem = Itemwise_Summary(
                                            productName: j.productName,
                                            ProductID: productID,
                                            Qty: Int(qty),
                                            Free: Int(free), Vol: Double(value)
                                        )
                                        Itemwise_Summary_Data.append(newItem)
                                    }
                            }
                        }
                        
                      //  Add Free ProductDetils here
                        
                        for item in Oredrdatadetisl{
                            for j in item.Orderlist{
                                if j.freeValue != "0"{
                                let qty = Double(j.qtyValue) ?? 0
                                let free = Double(j.freeValue) ?? 0
                                let productID = j.ProductID.trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                if let index = Zero_Billing_Product.firstIndex(where: {
                                    $0.ProductID.trimmingCharacters(in: .whitespacesAndNewlines) == productID
                                }) {
                                    Zero_Billing_Product[index].Qty += Int(qty)
                                    Zero_Billing_Product[index].Free += Int(free)
                                } else {
                                    let newItem = Itemwise_Summary(
                                        productName: j.freeProductName,
                                        ProductID: productID,
                                        Qty: Int(qty),
                                        Free: Int(free), Vol: 0
                                    )
                                    Zero_Billing_Product.append(newItem)
                                }
                            }
                            }
                        }
                        
                        print(Itemwise_Summary_Data)
                        
                        var QtyTotal:Int = 0
                        var FreeTota:Int = 0
                        var Liter:Double = 0
                        for item in Itemwise_Summary_Data{
                            QtyTotal = QtyTotal + Int(item.Qty)
                            FreeTota = FreeTota + Int(item.Free)
                            Liter = Liter + Double(item.Vol)
                        }
                        Itemwise_Summary_Data.append(Itemwise_Summary(productName: "Total", ProductID: "", Qty: Int(Double(QtyTotal)), Free: Int(Double(FreeTota)), Vol: Liter))

//                        let formatter = NumberFormatter()
//                        formatter.numberStyle = .currency
//                        formatter.locale = Locale(identifier: "en_IN") // Indian locale
//                        print(Total_Value)
//                        
//                        if let formattedValue = formatter.string(from: NSNumber(value: Total_Value)) {
//                            Total_Value_Amt.text = formattedValue
//                        }
//                        
                        Total_Value_Amt.text =   CurrencyUtils.formatCurrency(amount: Total_Value, currencySymbol: UserSetup.shared.currency_symbol)
                        
                        print(Oredrdatadetisl)
                       
                        Zero_Billing_summary.reloadData()
                        HQ_and_Route_TB.reloadData()
                        Item_Summary_table.reloadData()
                        Scroll_and_Tb_Height()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.LoadingDismiss()
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.LoadingDismiss()
                    }
                }
            }
    }
    
    func parseProducts(_ products: String,_ Idproducts: String, taxArray: [String]?) -> [OrderItemModel] {
        print(products)
        print(taxArray)
        var itemModelList = [OrderItemModel]()
        var netAmount: Double = 0
        let productArray = products.split(separator: ",").map { String($0) }
        let Additional_Prod_Code_Array = Idproducts.split(separator: "#")
        print(Additional_Prod_Code_Array)
        var prodcode = [String]()
        for j in Additional_Prod_Code_Array{
            let Product_Id = j.split(separator: "~").map { String($0) }
            prodcode.append(Product_Id[0])
        }
        
        for (i, product) in productArray.enumerated() {
            var taxAmt = "0"
            
            if let taxAmount = taxArray?[i] {
                taxAmt = taxAmount.trimmingCharacters(in: .whitespaces)
            }
            let ProductId = prodcode[i]
            let qtyValue = extractDouble(from: product, start: ") (", end: "@")
            let freeValue = extractDouble(from: product, start: "+", end: "%")
          
            
            let splitdisc = product.split(separator: "*").map { String($0) }
            let splitdisc2 = splitdisc[0].split(separator: "-").map { String($0) }
            let discValue = Double(splitdisc2.last ?? "0") ?? 0
            let taxValue = taxAmt
            let rateValue = extractDouble(from: product, start: "*", end: "!")
            let litersVal = extractDouble(from: product, start: "@", end: "+")
            let clValue = Int(extractString(from: product, start: "!", end: "!") ?? "0") ?? 0
            let uomNames = extractString(from: product, start: "!", end: "%") ?? ""
            let name = uomNames.split(separator: "!").map { String($0) }
            let uomName = name[1]
            let eQtyValue = extractDouble(from: product, start: "%", end: "*")
            let Value =  extractDouble(from: product, start: "(", end: ")")
            
            
            //let totalValue = Value + taxValue - discValue
            
            let totalValue = Value
            netAmount += totalValue
            
            
            let productName = extractProductName(product, totalValue: Value)
            let freeProductName = extractFreeProductName(product, name: productName)

            print(productName)
            
            let orderItem = OrderItemModel(
                productName: productName,
                ProductID: ProductId,
                rateValue: String(rateValue),
                qtyValue: String(qtyValue),
                freeValue: String(freeValue),
                discValue: String(discValue),
                totalValue: String(totalValue),
                taxValue: String(taxValue),
                clValue: String(clValue),
                uomName: String(uomName),
                eQtyValue: String(eQtyValue),
                litersVal: String(litersVal),
                freeProductName: freeProductName
            )
            print(orderItem)

            itemModelList.append(orderItem)
        }

        print("Net Amount: \(String(format: "%.2f", netAmount))")
        return itemModelList
    }

    // Helper functions
    func extractDouble(from text: String, start: String, end: String) -> Double {
        guard let range = extractString(from: text, start: start, end: end),
              let value = Double(range.filter { "0123456789.".contains($0) }) else {
            return 0
        }
        return value
    }

    func extractString(from text: String, start: String, end: String) -> String? {
        guard let startIndex = text.range(of: start)?.upperBound,
              let endIndex = text.range(of: end, range: startIndex..<text.endIndex)?.lowerBound else {
            return nil
        }
        return String(text[startIndex..<endIndex])
    }

    func extractProductName(_ product: String, totalValue: Double) -> String {
        let splitprod = product.split(separator: "(").map { String($0) }
        return splitprod[0].trimmingCharacters(in: .whitespaces)
    }

    func extractFreeProductName(_ product: String,name:String) -> String {
        let parts = product.components(separatedBy: "^")
        let Get_id = parts[1]
        let sort_id = Get_id.components(separatedBy: ")")
        let without_whitespace = sort_id[0].trimmingCharacters(in: .whitespacesAndNewlines)
        print(without_whitespace)
        print(lstAllProducts)
        
        let filterProduct = lstAllProducts.filter { ($0["id"] as? String ?? "") == without_whitespace }
       var free_product_name = ""
        if !filterProduct.isEmpty{
            free_product_name = filterProduct[0]["name"] as? String ?? ""
        }else{
            free_product_name = name
        }
        return free_product_name
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Item_Summary_table == tableView {
            return 40
        }
        if Day_Report_TB ==  tableView{
            return 50
        }
        
        if HQ_and_Route_TB == tableView{
            let Row_Height = Oredrdatadetisl[indexPath.row].Orderlist.count * 50
            
            let height:CGFloat = (Oredrdatadetisl[indexPath.row].tlDisAmt == "0") ? 10 : 70
            
            var row_height = 0
            if Oredrdatadetisl[indexPath.row].Orderlist.isEmpty{
                row_height = 290
            }else{
                row_height = 360
            }
            
            let Height = CGFloat(Row_Height + row_height)
            return Height + height
        }
        
        if Zero_Billing_summary == tableView{
            return 30
        }
        
        return 30
    }
    
    func Scroll_and_Tb_Height(){
        Table_height.constant = 0
        for i in Oredrdatadetisl{
            print(Table_height.constant)
            print(Scroll_height .constant)
            let Row_Height = i.Orderlist.count * 55
            var Row_hight_tb = 0
            
            if  i.Orderlist.isEmpty {
                Row_hight_tb = 290
            }else{
                Row_hight_tb = 360
            }
            
            let Height = CGFloat(Row_Height + Row_hight_tb)
            let height:CGFloat = (i.tlDisAmt == "0") ? 10 : 70
            Table_height.constant = Table_height.constant + CGFloat(Height)
            Table_height.constant = Table_height.constant + height
            Scroll_height .constant = Table_height.constant

            print(Table_height.constant)
            print(Scroll_height .constant)
        }
        print(Item_Summary_View.constant)
        print(Item_Summary_TB_hEIGHT.constant)
        
        
        let Height = Item_Summary_View.constant -   Item_Summary_TB_hEIGHT.constant
        let Scroll_Height = CGFloat(Height) + CGFloat(Itemwise_Summary_Data.count * 42)
        Item_Summary_TB_hEIGHT.constant = CGFloat(Itemwise_Summary_Data.count * 42)
        Item_Summary_View.constant = Scroll_Height
        Scroll_height .constant =  Scroll_height .constant  +  Item_Summary_View.constant + 100
        print(Item_Summary_View.constant)
        print(Item_Summary_TB_hEIGHT.constant)
        
        
        //Zero Billing addres height
        
        if Zero_Billing_Product.isEmpty{
            Zero_Billing_View.isHidden = true
            Zero_Billing_Summary_View_Hi.constant = 0
            Scroll_height .constant =  Scroll_height .constant  +  Zero_Billing_Summary_View_Hi.constant
        }else{
            Zero_Billing_View.isHidden = false
            let Zero_Billing_Height = Zero_Billing_Summary_View_Hi.constant -   Zero_Billing_addres_Tb_Hi.constant
            let Zero_Scroll_Height = CGFloat(Height) + CGFloat(Zero_Billing_Product.count * 32)
            Zero_Billing_addres_Tb_Hi.constant =  CGFloat(Zero_Billing_Product.count * 32)
            Zero_Billing_Summary_View_Hi.constant =  Zero_Scroll_Height
            Scroll_height .constant =  Scroll_height .constant  +  Zero_Billing_Summary_View_Hi.constant + 100
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            Scroll_height .constant =  Scroll_height .constant  + 60
        }
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for i in Orderdata{
            count = count + i.Orderdata.count
        }
        if Day_Report_TB == tableView {
            Day_Report_TB_height.constant = CGFloat(Orderlist.count * 50)
            Scroll_Height_TB.constant =  Day_Report_TB_height.constant + 300
            return Orderlist.count
        }
        if Item_Summary_table == tableView{
            return Itemwise_Summary_Data.count
        }
        if Free_TB == tableView{
           return FreeDetils.count
         }
        if Zero_Billing_summary == tableView{
            return Zero_Billing_Product.count
        }
        
        return Oredrdatadetisl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           if tableView == HQ_and_Route_TB {
               let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Order_Range_TableViewCell
               cell.delegate = self
               cell.Route_name.text = Oredrdatadetisl[indexPath.row].Route
               cell.Stockets_Name.text = Oredrdatadetisl[indexPath.row].Stockist
               cell.Store_Name_with_order_No.text = Oredrdatadetisl[indexPath.row].name + "(\(Oredrdatadetisl[indexPath.row].nameid))"
               cell.Addres.text = Oredrdatadetisl[indexPath.row].Adress
               
               cell.Sftyp = GetTyp
               if GetTyp == "3"{
                   cell.Volumes.text = "Supply From: \(Oredrdatadetisl[indexPath.row].Stockist)"
               }else{
                   cell.Volumes.text = "Volumes: \(Oredrdatadetisl[indexPath.row].Volumes)"
               }
               
               
               cell.Phone.text = "Phone:"+Oredrdatadetisl[indexPath.row].Phone
               if  let NetValue = Float(Oredrdatadetisl[indexPath.row].Net_amount){
                   
                   //cell.Netamt.text = "₹\(String(format: "%.2f",NetValue))"
                   cell.Netamt.text = CurrencyUtils.formatCurrency(amount: NetValue, currencySymbol: UserSetup.shared.currency_symbol)
                   
               }else{
                  // cell.Netamt.text = "₹\(Oredrdatadetisl[indexPath.row].Net_amount)"
                   cell.Netamt.text = CurrencyUtils.formatCurrency(amount: Oredrdatadetisl[indexPath.row].Net_amount, currencySymbol: UserSetup.shared.currency_symbol)
                   
               }
               
               cell.Total_Disc_Val_lbl.text = Oredrdatadetisl[indexPath.row].Total_disc_lbl
               cell.Total_Disc.text = Oredrdatadetisl[indexPath.row].tlDisAmt
               cell.Final_Amout.text = Oredrdatadetisl[indexPath.row].Final_Amt
               
               
               
               cell.Remark.text =  Oredrdatadetisl[indexPath.row].Remarks
               cell.insideTable1Data = [Oredrdatadetisl[indexPath.row]]
               
//               print(Oredrdatadetisl[indexPath.row].Remarks)
//               
//               if Oredrdatadetisl[indexPath.row].Remarks != ""{
//                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                       cell.Remark_View_height.constant = cell.Remark.layer.frame.height
//                   }
//               }
               
               if Oredrdatadetisl[indexPath.row].Orderlist.count == 0 {
                   cell.View_Detils.isHidden = true
                   cell.Start_Image.isHidden = true
               }else{
                   cell.View_Detils.isHidden = false
                   cell.Start_Image.isHidden = false
               }
               
               cell.reloadData()
               return cell
           }else if Day_Report_TB == tableView{
               let cellReport = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Range_Day_Reportdetils
               let item = Orderlist[indexPath.row]
               print(item)
               cellReport.Item.text = item.productName
               cellReport.Uom.text = item.uomName
               cellReport.Qty.text = item.eQtyValue
               cellReport.Price.text = item.rateValue
               cellReport.Free.text = item.freeValue
               cellReport.Disc.text = item.discValue
               cellReport.Tax.text = item.taxValue
              // cellReport.Total.text = item.totalValue
               
               cellReport.Total.text = CurrencyUtils.formatCurrency_WithoutSymbol(amount: item.totalValue, currencySymbol: UserSetup.shared.currency_symbol)
               return cellReport
           }else if Free_TB == tableView{
               let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! cellListItem
               print(FreeDetils[indexPath.row].productName)
               
               cell.lblText.text = FreeDetils[indexPath.row].productName
               cell.lblText2.text = String(FreeDetils[indexPath.row].Free)
               
               return cell
           }else if Zero_Billing_summary == tableView {
               let cellS = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Range_Item_summary_TB
               cellS.Product_Name.text = Zero_Billing_Product[indexPath.row].productName
               cellS.Vol.text =  String(Zero_Billing_Product[indexPath.row].Free)
               return cellS
               
           }else{
               let cellS = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Range_Item_summary_TB
 
               if Itemwise_Summary_Data[indexPath.row].productName == "Total" && Itemwise_Summary_Data[indexPath.row].ProductID == "" {
                   // Set the text properties first
                   cellS.Product_Name.text = Itemwise_Summary_Data[indexPath.row].productName
                   cellS.Qty.text = String(Itemwise_Summary_Data[indexPath.row].Qty)
                   cellS.Free.text = String(Itemwise_Summary_Data[indexPath.row].Free)
                   cellS.Vol.text = String(Itemwise_Summary_Data[indexPath.row].Vol)
                   
                   // Apply attributed text (font color in this case)
                   let font = UIFont.systemFont(ofSize: 14, weight: .bold)
                   let attributedText = NSAttributedString(
                       string: cellS.Product_Name?.text ?? "",
                       attributes: [
                           .foregroundColor: UIColor.black,
                           .font: font
                       ]
                   )
                   let attributedqty = NSAttributedString(string: cellS.Qty?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.09, green: 0.64, blue: 0.29, alpha: 1.00)])
                   let attributedRate = NSAttributedString(string:  cellS.Free?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.09, green: 0.64, blue: 0.29, alpha: 1.00)])
                   let attributedVol = NSAttributedString(string:  cellS.Vol?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.09, green: 0.64, blue: 0.29, alpha: 1.00)])
                   cellS.Product_Name?.attributedText = attributedText
                   cellS.Qty?.attributedText = attributedqty
                   cellS.Free?.attributedText = attributedRate
                   cellS.Vol?.attributedText = attributedVol
               } else {
                   cellS.Product_Name.text = Itemwise_Summary_Data[indexPath.row].productName
                   cellS.Qty.text = String(Itemwise_Summary_Data[indexPath.row].Qty)
                   cellS.Free.text = String(Itemwise_Summary_Data[indexPath.row].Free)
                   cellS.Vol.text = String(Itemwise_Summary_Data[indexPath.row].Vol)
                   // Apply attributed text (font color in this case)
                   let font = UIFont.systemFont(ofSize: 14, weight: .regular)
                   let attributedText = NSAttributedString(
                       string: cellS.Product_Name?.text ?? "",
                       attributes: [
                           .foregroundColor: UIColor.black,
                           .font: font
                       ]
                   )
                   let attributedqty = NSAttributedString(string: cellS.Qty?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                   let attributedRate = NSAttributedString(string:  cellS.Free?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                   let attributedVol = NSAttributedString(string:  cellS.Vol?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                   
                   cellS.Product_Name?.attributedText = attributedText
                   cellS.Qty?.attributedText = attributedqty
                   cellS.Free?.attributedText = attributedRate
                   cellS.Vol?.attributedText = attributedVol
                   
               }
               return cellS
           }
       }
    // MARK: - OrderDetailsCellDelegate Method
      func didTapButton(in cell: Order_Range_TableViewCell) {
          guard let indexPath = HQ_and_Route_TB.indexPath(for: cell) else { return }
          print("Button tapped in cell at index path: \(indexPath.row)")
          let Item =  Oredrdatadetisl[indexPath.row]
          print(Item)
          FreeDetils.removeAll()
          Day_View_Stk.text = Item.Stockist
          From_no.text = Item.stkmob
          To_Retiler.text = Item.name
          To_Addres.text = Item.Adress
          To_No.text = Item.Phone
          Order_No.text = Item.nameid
          Order_Date.text = Item.Order_date
          if Item.Order_date.contains("00:00:00"){
              let dateTimeString = Item.Order_date
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              if let fullDate = dateFormatter.date(from: dateTimeString) {
                  let dateOnlyFormatter = DateFormatter()
                  dateOnlyFormatter.dateFormat = "yyyy-MM-dd"
                  let dateOnlyString = dateOnlyFormatter.string(from: fullDate)
                  print(dateOnlyString)
                  Order_Date.text = dateOnlyString
              }
          }
          
          Total_item.text = String(Item.Orderlist.count)
          Orderlist = Item.Orderlist
          Tax.text = String(Item.Total_Tax)
          Sch_Disc.text = String(Item.Total_Dic)
          Cas_disc.text = Item.tlDisAmt
         // Net_Amt.text = "₹ " + Item.Final_Amt
          
          Net_Amt.text = CurrencyUtils.formatCurrency(amount: Item.Final_Amt, currencySymbol: UserSetup.shared.currency_symbol)
          
          Day_Report_TB.reloadData()
          
          for i in Item.Orderlist{
              let free: Double = Double(i.freeValue) ?? 0
              let Volumes:Double = Double(i.litersVal) ?? 0
              if free != 0 {
                  FreeDetils.append(Itemwise_Summary(productName: i.freeProductName, ProductID: "", Qty: 0, Free: Int(free), Vol: Volumes))
              }}
          
          print(FreeDetils)
          
          if FreeDetils.isEmpty {
              height_for_Free_Tb.constant = 0
              free_view.isHidden = true
          }else{
              height_for_Free_Tb.constant = height_for_Free_Tb.constant - Free_Table_Height.constant
            Free_Table_Height.constant = 0
                Free_Table_Height.constant = CGFloat(FreeDetils.count * 30)
                height_for_Free_Tb.constant =  height_for_Free_Tb.constant + Free_Table_Height.constant
                Scroll_Height_TB.constant =  Scroll_Height_TB.constant + height_for_Free_Tb.constant + 100
              free_view.isHidden = false
          }
          Free_TB.reloadData()
          
          Day_Report_View.isHidden = false
      }

    @objc func Back_View(){
        Day_Report_View.isHidden = true
    }
    
    
    
    @objc func Close_Calender(){
        Calender_View.isHidden = true
    }
  
    @objc func Close_Hq(){
        Sel_Wid.isHidden = true
    }
    
    @objc private func GotoHome() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Reports 2", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "DAY_REPORT_WITH_DATE_RANGE") as! DAY_REPORT_WITH_DATE_RANGE
            let navController = UINavigationController(rootViewController: viewController)
            
            UIApplication.shared.windows.first?.rootViewController = navController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }

    @objc func Textshare() {
        let data: String = formatOrdersForSharing(orders: Oredrdatadetisl)
        if let urlEncodedText = data.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let whatsappURL = URL(string: "whatsapp://send?text=\(urlEncodedText)"),
           UIApplication.shared.canOpenURL(whatsappURL) {
            
            UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
        } else {
            let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [
                .postToFacebook,
                .postToTwitter,
                .assignToContact,
                .print
            ]
            
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                // For iPad, set the popover presentation details
                if let popoverPresentationController = activityViewController.popoverPresentationController {
                    popoverPresentationController.sourceView = topController.view
                    popoverPresentationController.sourceRect = CGRect(
                        x: topController.view.bounds.midX,
                        y: topController.view.bounds.midY,
                        width: 0,
                        height: 0
                    )
                    popoverPresentationController.permittedArrowDirections = [] // No arrow
                }
                topController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }

    
    func formatOrdersForSharing(orders: [OrderDetail]) -> String {
        var formattedText = ""
        
        for order in orders {
            if order.Orderlist.count == 0{
                break
            }
            
            formattedText += "Distributor : \(order.Stockist)\n"
            formattedText += "Retailer : \(order.name)\n"
            formattedText += "Route : \(order.Route)\n"
            
            for item in order.Orderlist {
                formattedText += "\(item.productName)\n"
                formattedText += "Rate : \(item.rateValue) Qty : \(item.qtyValue) Value : \(item.totalValue)\n"
            }
            
            formattedText += "Net Amount : \(order.Net_amount)\n"
            formattedText += "------------**------------\n"
        }
        
        
        return formattedText
    }
    
    
    // MARK: -  Full screan Share
    
    @objc func cURRENT_iMG(){
        sharePDF(from: Scroll_View)
    }
    
    
    // MARK: - Capture Scroll View Content as Image

    func captureScrollViewContent(scrollView: UIScrollView) -> UIImage? {
        // Start image context with the full content size of the scroll view
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, 0.0)
        
        // Save the original scroll position to restore later
        let originalOffset = scrollView.contentOffset
        scrollView.contentOffset = .zero
        
        // Loop through all subviews in the scroll view
        for subview in scrollView.subviews {
            // Render each subview into the current context
            subview.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        // Capture the generated image from the context
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the image context to release resources
        UIGraphicsEndImageContext()
        
        // Restore the original scroll position
        scrollView.contentOffset = originalOffset
        
        return capturedImage
    }



    // MARK: - Create PDF from Image
    func createPDF(from image: UIImage) -> Data? {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(origin: .zero, size: image.size), nil)
        UIGraphicsBeginPDFPage()
        image.draw(in: CGRect(origin: .zero, size: image.size))
        UIGraphicsEndPDFContext()
        return pdfData as Data
    }

    // MARK: - Share PDF using UIActivityViewController
    func sharePDF(from scrollView: UIScrollView) {
        guard let image = captureScrollViewContent(scrollView: scrollView),
              let pdfData = createPDF(from: image) else { return }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("OrderDetails.pdf")
        do {
            try pdfData.write(to: tempURL)
        } catch {
            print("Error writing PDF: \(error)")
            return
        }

        let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)

        // For iPads: Set source view to avoid crashes
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.frame.size.width / 2,
                                                  y: self.view.frame.size.height / 2,
                                                  width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    
        //MARK: -  Order Detils Share
    
    @objc func Share_Order_Bill() {
        sharePDF_Detils()
    }

    func captureViewsAsImage() -> UIImage? {
        // Create a new graphics context with the size of both views combined
        let totalHeight = Addres_View.frame.height + Detils_Scroll_View.contentSize.height
        let totalSize = CGSize(width: max(Addres_View.frame.width, Detils_Scroll_View.frame.width), height: totalHeight)

        UIGraphicsBeginImageContextWithOptions(totalSize, false, 0.0)

        // Save the current graphics context
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // Render the Addres_View
        context.saveGState()
        context.translateBy(x: 0, y: 0) // Position the Addres_View at the top
        Addres_View.layer.render(in: context)
        context.restoreGState()

        // Set the correct position for Detils_Scroll_View
        let originalOffset = Detils_Scroll_View.contentOffset
        Detils_Scroll_View.contentOffset = .zero

        // Render the Detils_Scroll_View below the Addres_View
        context.saveGState()
        context.translateBy(x: 0, y: Addres_View.frame.height) // Position below Addres_View
        for subview in Detils_Scroll_View.subviews {
            subview.layer.render(in: context)
        }
        context.restoreGState()

        // Restore the original scroll position
        Detils_Scroll_View.contentOffset = originalOffset

        // Capture the generated image from the context
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()

        // End the image context to release resources
        UIGraphicsEndImageContext()

        return capturedImage
    }


    func sharePDF_Detils() {
        guard let image = captureViewsAsImage(),
              let pdfData = createPDF(from: image) else { return }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("OrderDetails.pdf")
        do {
            try pdfData.write(to: tempURL)
        } catch {
            print("Error writing PDF: \(error)")
            return
        }

        let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)

        // For iPads: Set source view to avoid crashes
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.frame.size.width / 2,
                                                  y: self.view.frame.size.height / 2,
                                                  width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityVC, animated: true, completion: nil)
    }

    
}
