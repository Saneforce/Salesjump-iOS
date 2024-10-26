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
    @IBOutlet weak var Calender_back: UIImageView!
    @IBOutlet weak var Sel_Wid: UIView!
    @IBOutlet weak var Sel_Back: UIImageView!
    @IBOutlet weak var Text_Search: UITextField!
    @IBOutlet weak var Hq_Table: UITableView!
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
        
        var Orderlist:[OrderItemModel]
    }
    
    struct Itemwise_Summary:Any{
        let productName: String
        let ProductID:String
        var Qty:Int
        var Free:Int
    }
    
    var Itemwise_Summary_Data:[Itemwise_Summary] = []
    
    var Orderdata:[Id] = []
    var Oredrdatadetisl:[OrderDetail] = []
    var Orderlist:[OrderItemModel] = []
    let cardViewInstance = CardViewdata()
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
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
    
    @IBOutlet weak var Text_Share: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        let selectdate = DateFormatter()
        selectdate.dateFormat = "yyyy-MM-dd"
        let dates = selectdate.string(from: Date())
        Select_Dtae = dates
        date_sel.text = dates
        Sf_Id = SFCode
        hq_name_sel.text = sfName
        
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
        Date_View.addTarget(target: self, action: #selector(Opend_Calender))
        Calender_back.addTarget(target: self, action: #selector(Close_Calender))
        Hq_View.addTarget(target: self, action: #selector(Open_Hq))
        Sel_Back.addTarget(target: self, action: #selector(Close_Hq))
        HQ_and_Route_TB.dataSource = self
        HQ_and_Route_TB.delegate = self
        Item_Summary_table.dataSource = self
        Item_Summary_table.delegate = self
        Day_Report_TB.delegate = self
        Day_Report_TB.dataSource = self
        Hq_Table.dataSource = self
        Hq_Table.delegate = self
        appendDashedBorder(to: das_Border_Line_View)
        appendDashedBorder(to: Strik_Line)
        
        Share_Pdf.addTarget(target: self, action: #selector(cURRENT_iMG))
        Share_Orde_Detils.addTarget(target: self, action: #selector(Share_Order_Bill))
        
        
        Text_Share.addTarget(target: self, action: #selector(Textshare))
        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list;
            lObjSel=lstHQs
            print(lObjSel)
            
            if UserSetup.shared.SF_type == 1{
                Hq_Name_lbl.text = lstHQs[0]["name"] as? String ?? ""
            }else{
                Hq_Name_lbl.text = UserSetup.shared.SF_Name
            }
        }
        OrderDayReport()
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
    }
    
    func OrderDayReport(){
        Oredrdatadetisl.removeAll()
        Orderdata.removeAll()
        Itemwise_Summary_Data.removeAll()
        Total_Value_Amt.text = "0.0"
        self.ShowLoading(Message: "Loading...")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Foundation.Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        print(formattedDate)
        
        
        let ACode = ""
        
        let axn = "get/vwVstDet"
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&divisionCode=\(DivCode)&ACd=\(ACode)&rSF=\(SFCode)&typ=1&sfCode=\(SFCode)&RsfCode=\(Sf_Id)"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                print(value)
                if let json = value as? [AnyObject]{
                    for j in json{
                        let id = j["id"] as? String ?? ""
                        let Route = j["Territory"] as? String ?? ""
                        let Stockist = j["stockist_name"] as? String ?? ""
                        let name = j["name"] as? String ?? ""
                        let nameid = j["Order_No"] as? String ?? ""
                        let Adress = j["Address"] as? String ?? ""
                        let liters = j["liters"] as? Double ?? 0
                        let Volumes = (liters * 100).rounded() / 100
                        let Phone = j["phoneNo"] as? String ??  ""
                        let netAmount = j["finalNetAmnt"] as? String ?? ""
                        let Remarks = j["secOrdRemark"] as? String ?? ""
                        let Stkid = j["stockist_code"] as? String ?? ""
                        let tlDisAmt = j["tlDisAmt"] as? String ?? ""
                        
                        if nameid == "GLLMR0007-24-25-SO-87"{
                            print("jn")
                        }
                        
                        let minsAmount = Double(netAmount.isEmpty ? "0" : netAmount)! - Double(j["tlDisAmt"] as? String ?? "0")!
                        
                      let  Net_amount = netAmount.isEmpty ? "0" : netAmount
                       let Final_Amt = String(format: "%.2f", minsAmount)
                        
                        print(minsAmount)
                       
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
                            let Additional_Prod_Code = j["Additional_Prod_Code"] as? String ?? ""
                            let Additional_Prod_Code_Array = products.split(separator: "~").map {String($0)}
                            let productArray = products.split(separator: ",").map { String($0) }
                            
                            let tax_price = j["tax_price"] as? String ?? ""
                            var taxArray: [String] = []
                            if !tax_price.isEmpty {
                                taxArray = tax_price.split(separator: "#").map { String($0) }
                            }
                            print(taxArray)
                            
                            let Order_date = j["Order_date"] as? String ?? ""
                            
                            
                            let itemList = parseProducts(products, Additional_Prod_Code, taxArray: taxArray)
                            
                            for item in itemList {
                                let qty = Int(item.qtyValue) ?? 0
                                let free = Int(item.freeValue) ?? 0
                                let productID = item.ProductID.trimmingCharacters(in: .whitespacesAndNewlines)

                                if let index = Itemwise_Summary_Data.firstIndex(where: {
                                    $0.ProductID.trimmingCharacters(in: .whitespacesAndNewlines) == productID
                                }) {
                                    Itemwise_Summary_Data[index].Qty += qty
                                    Itemwise_Summary_Data[index].Free += free
                                } else {
                                   
                                    
                                    let newItem = Itemwise_Summary(
                                        productName: item.productName,
                                        ProductID: productID,
                                        Qty: qty,
                                        Free: free
                                    )
                                    Itemwise_Summary_Data.append(newItem)
                                }
                            }
                            
                            let Order_Count = Oredrdatadetisl[i].Order_Count + 1

                            var Total_discValue = 0.0
                            var Total_taxValue = 0.0
                            
                            for k in itemList{
                                Total_discValue = Total_discValue + Double(k.discValue)!
                                Total_taxValue = Total_taxValue + Double(k.taxValue)!
                            }
                            
                            print(Orderdata[i].Orderdata)
                            
                            Orderdata[i].Orderdata.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: "\(Order_Count). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: Order_Count,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount (10%)", Final_Amt: Final_Amt, Orderlist: itemList))
                            
                            Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: "\(Order_Count). "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: Order_Count,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount (10%)", Final_Amt: Final_Amt,Orderlist: itemList))
                            
                            
                            print(Total_Value)
                            // second
                            print(Net_amount)
                            Total_Value = Total_Value + Double(Net_amount)!
                            
                            print(Total_Value)

                        }else{
                            
                            let Additional_Prod_Code = j["Additional_Prod_Code"] as? String ?? ""
                            
                            let products = j["products"] as? String ?? ""
                            let productArray = products.split(separator: ",").map { String($0) }
                            print(productArray)
                            let tax_price = j["tax_price"] as? String ?? ""
                            var taxArray: [String] = []
                            if !tax_price.isEmpty {
                                taxArray = tax_price.split(separator: "#").map { String($0) }
                            }
                            print(taxArray)
                            print(products)
                            let Order_date = j["Order_date"] as? String ?? ""
                            let itemList = parseProducts(products, Additional_Prod_Code, taxArray: taxArray)
                                 
                            for item in itemList {
                                let qty = Double(item.qtyValue) ?? 0
                                let free = Double(item.freeValue) ?? 0
                                let productID = item.ProductID.trimmingCharacters(in: .whitespacesAndNewlines)

                                if let index = Itemwise_Summary_Data.firstIndex(where: {
                                    $0.ProductID.trimmingCharacters(in: .whitespacesAndNewlines) == productID
                                }) {
                                    Itemwise_Summary_Data[index].Qty += Int(qty)
                                    Itemwise_Summary_Data[index].Free += Int(free)
                                } else {
                                    let newItem = Itemwise_Summary(
                                        productName: item.productName,
                                        ProductID: productID,
                                        Qty: Int(qty),
                                        Free: Int(free)
                                    )
                                    Itemwise_Summary_Data.append(newItem)
                                }
                            }
                            
                            print(itemList)
                            var Total_discValue = 0.0
                            var Total_taxValue = 0.0
                            
                            for k in itemList{
                                Total_discValue = Total_discValue + Double(k.discValue)!
                                Total_taxValue = Total_taxValue + Double(k.taxValue)!
                            }
                            
                            Orderdata.append(Id(id: id, Stkid: Stockist, RouteId: Route, Orderdata: [OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: "1. "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: 1,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount (10%)", Final_Amt: Final_Amt, Orderlist: itemList)]))
                            
                            Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: "1. "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: 1,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount (10%)", Final_Amt: Final_Amt,Orderlist: itemList))
                            
                            Total_Value += Double(Net_amount) ?? 0.0
                            
                        }
                    }
                    
                    var QtyTotal = 0
                    var FreeTota = 0
                    for item in Itemwise_Summary_Data{
                        QtyTotal = QtyTotal + Int(item.Qty)
                        FreeTota = FreeTota + Int(item.Free)
                        
                    }
                    
                    Itemwise_Summary_Data.append(Itemwise_Summary(productName: "Total", ProductID: "", Qty: Int(Double(QtyTotal)), Free: Int(Double(FreeTota))))

                    let formatter = NumberFormatter()
                    formatter.numberStyle = .currency
                    formatter.locale = Locale(identifier: "en_IN") // Indian locale
                    print(Total_Value)
                    
                    if let formattedValue = formatter.string(from: NSNumber(value: Total_Value)) {
                        Total_Value_Amt.text = formattedValue
                    }
                    
                    
                    print(Oredrdatadetisl)
                    Scroll_and_Tb_Height()
                    HQ_and_Route_TB.reloadData()
                    Item_Summary_table.reloadData()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
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
        var prodcode = [String]()
        for j in Additional_Prod_Code_Array{
            let Product_Id = j.split(separator: "~").map { String($0) }
            prodcode.append(Product_Id[0])
        }
        
        for (i, product) in productArray.enumerated() {
            var taxAmt = "0"
            
            if let taxAmount = taxArray?[i] {
                taxAmt = taxAmount
            }
            let ProductId = prodcode[i]
            let qtyValue = extractDouble(from: product, start: ") (", end: "@")
            let freeValue = extractDouble(from: product, start: "+", end: "%")
          
            
            let splitdisc = product.split(separator: "*").map { String($0) }
            let splitdisc2 = splitdisc[0].split(separator: "-").map { String($0) }
            let discValue = Double(splitdisc2.last ?? "0") ?? 0
            let taxValue = Double(taxAmt) ?? 0
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
            let freeProductName = extractFreeProductName(product)

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

    func extractFreeProductName(_ product: String) -> String {
        guard let startIndex = product.range(of: "^")?.upperBound else { return "" }
        return String(product[startIndex...]).trimmingCharacters(in: .whitespaces)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Item_Summary_table == tableView {
            return 30
        }
        if Day_Report_TB ==  tableView{
            return 50
        }
        if Hq_Table == tableView{
            return 50
        }
        
        if HQ_and_Route_TB == tableView{
            let Row_Height = Oredrdatadetisl[indexPath.row].Orderlist.count * 50
            
            let height:CGFloat = (Oredrdatadetisl[indexPath.row].tlDisAmt == "0") ? 20 : 70
            
            let Height = CGFloat(Row_Height + 340)
            return Height + height
        }
        return 0
    }
    
    func Scroll_and_Tb_Height(){
        Table_height.constant = 0
        for i in Oredrdatadetisl{
            print(Table_height.constant)
            print(Scroll_height .constant)
            let Row_Height = i.Orderlist.count * 55
            let Height = CGFloat(Row_Height + 340)
            let height:CGFloat = (i.tlDisAmt == "0") ? 20 : 70
            Table_height.constant = Table_height.constant + CGFloat(Height)
            Table_height.constant = Table_height.constant + height
            Scroll_height .constant = Table_height.constant

            print(Table_height.constant)
            print(Scroll_height .constant)
        }
        print(Item_Summary_View.constant)
        print(Item_Summary_TB_hEIGHT.constant)
        
        
        let Height = Item_Summary_View.constant -   Item_Summary_TB_hEIGHT.constant
        let Scroll_Height = CGFloat(Height) + CGFloat(Itemwise_Summary_Data.count * 32)
        Item_Summary_TB_hEIGHT.constant = CGFloat(Itemwise_Summary_Data.count * 32)
        Item_Summary_View.constant = Scroll_Height
        Scroll_height .constant =  Scroll_height .constant  +  Item_Summary_View.constant + 100
        print(Item_Summary_View.constant)
        print(Item_Summary_TB_hEIGHT.constant)
        
        
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
        
        if Hq_Table == tableView{
            return lObjSel.count
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
               cell.Volumes.text = "Volumes: \(Oredrdatadetisl[indexPath.row].Volumes)"
               cell.Phone.text = "Phone:"+Oredrdatadetisl[indexPath.row].Phone
               if  let NetValue = Float(Oredrdatadetisl[indexPath.row].Net_amount){
                   
                   cell.Netamt.text = "₹\(NetValue)"
               }else{
                   cell.Netamt.text = "₹\(Oredrdatadetisl[indexPath.row].Net_amount)"
               }
               
               cell.Total_Disc_Val_lbl.text = Oredrdatadetisl[indexPath.row].Total_disc_lbl
               cell.Total_Disc.text = Oredrdatadetisl[indexPath.row].tlDisAmt
               cell.Final_Amout.text = Oredrdatadetisl[indexPath.row].Final_Amt
               
               
               
               cell.Remark.text =  Oredrdatadetisl[indexPath.row].Remarks
               cell.insideTable1Data = [Oredrdatadetisl[indexPath.row]]
               
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
               let cellReport = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Day_Reportdetils
               let item = Orderlist[indexPath.row]
               print(item)
               cellReport.Item.text = item.productName
               cellReport.Uom.text = item.uomName
               cellReport.Qty.text = item.qtyValue
               cellReport.Price.text = item.rateValue
               cellReport.Free.text = item.freeValue
               cellReport.Disc.text = item.discValue
               cellReport.Tax.text = item.taxValue
               cellReport.Total.text = item.totalValue
               return cellReport
           }else if Hq_Table == tableView{
               let cellText = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! cellListItem
               let Item = lObjSel[indexPath.row]
               cellText.lblText.text = Item["name"] as? String ?? ""
               return cellText
           }else{
               let cellS = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Item_summary_TB
 
               if Itemwise_Summary_Data[indexPath.row].productName == "Total" && Itemwise_Summary_Data[indexPath.row].ProductID == "" {
                   // Set the text properties first
                   cellS.Product_Name.text = Itemwise_Summary_Data[indexPath.row].productName
                   cellS.Qty.text = String(Itemwise_Summary_Data[indexPath.row].Qty)
                   cellS.Free.text = String(Itemwise_Summary_Data[indexPath.row].Free)
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
                   cellS.Product_Name?.attributedText = attributedText
                   cellS.Qty?.attributedText = attributedqty
                   cellS.Free?.attributedText = attributedRate
               } else {
                   cellS.Product_Name.text = Itemwise_Summary_Data[indexPath.row].productName
                   cellS.Qty.text = String(Itemwise_Summary_Data[indexPath.row].Qty)
                   cellS.Free.text = String(Itemwise_Summary_Data[indexPath.row].Free)
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
                   cellS.Product_Name?.attributedText = attributedText
                   cellS.Qty?.attributedText = attributedqty
                   cellS.Free?.attributedText = attributedRate
                   
               }
               
               
               return cellS
           }
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Hq_Table == tableView{
            let Item = lObjSel[indexPath.row]
            Sf_Id = Item["id"] as? String ?? SFCode
            hq_name_sel.text = Item["name"] as? String ?? ""
            Hq_Name_lbl.text = Item["name"] as? String ?? ""
            Text_Search.text = ""
            OrderDayReport()
            Sel_Wid.isHidden = true
        }
    }
    
    // MARK: - OrderDetailsCellDelegate Method
      func didTapButton(in cell: Order_Range_TableViewCell) {
          guard let indexPath = HQ_and_Route_TB.indexPath(for: cell) else { return }
          print("Button tapped in cell at index path: \(indexPath.row)")
          let Item =  Oredrdatadetisl[indexPath.row]
          print(Item)
          Day_View_Stk.text = Item.Stockist
          From_no.text = Item.Phone
          To_Retiler.text = Item.name
          To_Addres.text = Item.Adress
          To_No.text = Item.Phone
          Order_No.text = Item.nameid
          Order_Date.text = Item.Order_date
          Total_item.text = String(Item.Orderlist.count)
          Orderlist = Item.Orderlist
          Tax.text = String(Item.Total_Tax)
          Sch_Disc.text = String(Item.Total_Dic)
          Cas_disc.text = Item.tlDisAmt
          Net_Amt.text = "₹ " + Item.Final_Amt
          Day_Report_TB.reloadData()
          Day_Report_View.isHidden = false
      }

    
    
    @objc func Back_View(){
        Day_Report_View.isHidden = true
    }
    
    @objc func Opend_Calender(){
        Calender_View.isHidden = false
    }
    
    @objc func Close_Calender(){
        Calender_View.isHidden = true
    }
    
    @objc func Open_Hq(){
        lObjSel = lstHQs
        Text_Search.text = ""
        Hq_Table.reloadData()
        Sel_Wid.isHidden = false
    }
    @objc func Close_Hq(){
        Sel_Wid.isHidden = true
    }
    
    @objc private func GotoHome() {
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    
    @IBAction func TextSerch(_ sender: Any) {
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
                lObjSel = lstHQs
        }else{
            lObjSel = lstHQs.filter({(product) in
                let name: String = String(format: "%@", product["name"] as! CVarArg)
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        
        }
        Hq_Table.reloadData()
    }
    
    
    
    
    @objc func Textshare() {
        let data: String = formatOrdersForSharing(orders: Oredrdatadetisl)
        
        // Share to WhatsApp if available
        if let urlEncodedText = data.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let whatsappURL = URL(string: "whatsapp://send?text=\(urlEncodedText)"),
           UIApplication.shared.canOpenURL(whatsappURL) {
            
            // Open WhatsApp with the formatted text
            UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
        } else {
            // If WhatsApp is not installed, use UIActivityViewController
            let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            
            // Exclude unnecessary activity types (optional)
            activityViewController.excludedActivityTypes = [
                .postToFacebook,
                .postToTwitter,
                .assignToContact,
                .print
            ]
            
            // Present the activity view controller
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                topController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    
    // Function to format the orders for sharing
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
        
      //  formattedText += "Order Taken By : \(hq_name_sel.text)"
        
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
