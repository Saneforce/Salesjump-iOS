//
//  Secondary order details view.swift
//  SAN SALES
//
//  Created by Anbu j on 06/12/24.
//

import UIKit
import Alamofire

class Secondary_order_details_view: IViewController, UITableViewDelegate, UITableViewDataSource{
  
    @IBOutlet weak var Dynamic_header_lbl: UILabel!
    @IBOutlet weak var Button_back: UIImageView!
    @IBOutlet weak var Route_Detils_Table: UITableView!
    @IBOutlet weak var Product_Detils_Table: UITableView!
    @IBOutlet weak var Amount_table: UITableView!
    @IBOutlet weak var Item_summary_table: UITableView!
    @IBOutlet weak var Order_id_and_name: UILabel!
    @IBOutlet weak var Remarklbl: UILabel!
    @IBOutlet weak var Total_amount_summary: UILabel!
    @IBOutlet weak var Scroll_View: UIScrollView!
    
    // table View Heights
    
    @IBOutlet weak var Scroll_VieW_HEIGHT: NSLayoutConstraint!
    @IBOutlet weak var Route_table_height: NSLayoutConstraint!
    @IBOutlet weak var Product_detils_table_height: NSLayoutConstraint!
    @IBOutlet weak var Amount_table_View_height: NSLayoutConstraint!
    @IBOutlet weak var Summary_table_view_height: NSLayoutConstraint!
    @IBOutlet weak var Item_summary_view_height: NSLayoutConstraint!
    @IBOutlet weak var Whatsapp_share: UIImageView!
    @IBOutlet weak var Text_share: UIImageView!
    
    
    @IBOutlet weak var Open_view: UIImageView!
    @IBOutlet weak var Details_view: UIView!
    @IBOutlet weak var Details_view_back_button: UIImageView!
    
    
    
    // Day Report
    @IBOutlet weak var FRON_RET_LBL: UILabel!
    @IBOutlet weak var Frommoblbl: UILabel!
    @IBOutlet weak var To_Ret_lbl: UILabel!
    @IBOutlet weak var Addresslbl: UILabel!
    @IBOutlet weak var To_mbolbl: UILabel!
    @IBOutlet weak var Order_no: UILabel!
    @IBOutlet weak var Delivery_date: UILabel!
    @IBOutlet weak var Detils_table: UITableView!
    @IBOutlet weak var Total_item_lbl: UILabel!
    @IBOutlet weak var Taxlbl: UILabel!
    @IBOutlet weak var Schemelbl: UILabel!
    @IBOutlet weak var Cash_did_lbl: UILabel!
    @IBOutlet weak var Net_amountlbl: UILabel!
    @IBOutlet weak var Free_details_table: UITableView!
    
    
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
    
    var Orderdetils: [OrderItemModel] = []
    var Orderdetils2: [OrderItemModel] = []
    
    // Route table data
    struct Route_detils {
        var Route1:String
        var Route2:String
    }
    
    var Route_data:[Route_detils] = []
    
    
    // Amount table data
    struct Amount_Detils{
        var Amount1:String
        var Amount2:String
    }
    
    var Amountdata:[Amount_Detils] = []
    
    struct Itemwise_Summary:Any{
        let productName: String
        let ProductID:String
        var Qty:Int
        var Free:Int
    }
    
    var Itemwise_Summary_Data:[Itemwise_Summary] = []
    
    var FreeDetils:[Itemwise_Summary] = []
    
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    var sfName:String = ""
    let LocalStoreage = UserDefaults.standard
    
    var Typ:String?
    var CodeDate:String?
    var Hqname:String?
    var Hqid:String?
    var GetDate:String = ""
    var Orderid:String?
    var Orderid2:String = ""
    var Stkid:String?
    var Stkid2:String = ""
    var Headquarterid:String = ""
    var HeadquarterName:String = ""
    var GetTyp = ""
    
    var lstAllProducts: [AnyObject] = []
    
    var Retiler_name:String?
    override func viewDidLoad(){
        super.viewDidLoad()
       getUserDetails()
        
        if let date = CodeDate,let id = Orderid,let stkid = Stkid,let Get_hq_id = Hqid, let get_hq_name = Hqname{
            GetDate = date
            Orderid2 = id
            Stkid2 = stkid
            Headquarterid = Get_hq_id
            HeadquarterName = get_hq_name
        }
        
        Dynamic_header_lbl.text = "Secondary Order Details For : \(GetDate)"
        
        let lstProdData: String = LocalStoreage.string(forKey: "Products_Master")!
        
        if let list = GlobalFunc.convertToDictionary(text: lstProdData) as? [AnyObject] {
            lstAllProducts = list;
            print(lstProdData)
        }
        
        Button_back.addTarget(target: self, action: #selector(GotoHome))
        
        calltables()
        
        VstDet_order()
        Whatsapp_share.addTarget(target: self, action: #selector(cURRENT_iMG))
        Text_share.addTarget(target: self, action: #selector(Textshare))
        Open_view.addTarget(target: self, action: #selector(Opendetils))

        Details_view_back_button.addTarget(target: self, action: #selector(Closedetils))
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
    
    func calltables(){
        Route_Detils_Table.delegate = self
        Route_Detils_Table.dataSource = self
        Route_Detils_Table.rowHeight = UITableView.automaticDimension
        Route_Detils_Table.estimatedRowHeight = 150
        
        Product_Detils_Table.delegate = self
        Product_Detils_Table.dataSource = self
        
        Product_Detils_Table.rowHeight = UITableView.automaticDimension
        Product_Detils_Table.estimatedRowHeight = 150
        
        Amount_table.delegate = self
        Amount_table.dataSource = self
        
        Amount_table.rowHeight = UITableView.automaticDimension
        Amount_table.estimatedRowHeight = 150
        
        Item_summary_table.delegate = self
        Item_summary_table.dataSource = self
        
        Item_summary_table.rowHeight = UITableView.automaticDimension
        Item_summary_table.estimatedRowHeight = 150
        
        
        Detils_table.delegate = self
        Detils_table.dataSource = self
        
        Free_details_table.delegate = self
        Free_details_table.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         adjustTableViewHeight()
     }
     
     func adjustTableViewHeight() {
         Route_table_height.constant = Route_Detils_Table.contentSize.height
         Product_detils_table_height.constant = Product_Detils_Table.contentSize.height
         Amount_table_View_height.constant = Amount_table.contentSize.height
         Summary_table_view_height.constant = Item_summary_table.contentSize.height
     }
    
    func VstDet_order(){
        Route_data.removeAll()
        Orderdetils.removeAll()
        Amountdata.removeAll()
        Itemwise_Summary_Data.removeAll()
        let apiKey: String = "get%2FvwVstDet_order&State_Code=\(StateCode)&stockist_code=\(Stkid2)&divisionCode=\(DivCode)&orderDt=\(GetDate)&orderNo=\(Orderid2)&code=&%20rSF=\(SFCode)&typ=1&sfCode=\(SFCode)"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            switch AFdata.result {
            case .success(let value):
               let json = (value as? [AnyObject])!
                
                print(json)
                // set Lbl values
                FRON_RET_LBL.text = json[0]["stockist_name"] as? String ?? ""
                Frommoblbl.text = json[0]["stkMobNo"] as? String ?? ""
                To_Ret_lbl.text = json[0]["name"] as? String ?? ""
                Addresslbl.text = json[0]["retAddr"] as? String ?? ""
                To_mbolbl.text = json[0]["phoneNo"] as? String ?? ""
                Order_no.text = json[0]["trans_sl_no"] as? String ?? ""
                Delivery_date.text = json[0]["Order_date"] as? String ?? ""
                
                
                
                
                
                let productDetail = json[0]["Product_Detail"] as? String ?? ""
                let productCode = json[0]["Product_Code"] as? String ?? ""
                
                let reportType = 1
                let orderItems = parseProductDetails(productCode: productCode, productDetail: productDetail, reportType: reportType)
               
                Order_id_and_name.text = "\(json[0]["name"] as? String ?? "")(\(json[0]["trans_sl_no"] as? String ?? ""))"
                
                
                Route_data.append(Route_detils(Route1: "Route:", Route2: json[0]["Territory"] as? String ?? ""))
                Route_data.append(Route_detils(Route1: "Supply From", Route2: Retiler_name ?? ""))
                Route_data.append(Route_detils(Route1: "Phone", Route2: json[0]["phoneNo"] as? String ?? ""))
                
                
                let TiteleorderItem = OrderItemModel(
                    productName: "Product Name", ProductID: "",
                    rateValue: "Rate",
                    qtyValue: "Qty",
                    freeValue: "Free",
                    discValue: "Disc",
                    totalValue: "Value",
                    taxValue: "Tax",
                    clValue: "CL",
                    uomName: "",
                    eQtyValue: "",
                    litersVal: "",
                    freeProductName: ""
                )
                
                Orderdetils.append(TiteleorderItem)
                Orderdetils.append(contentsOf: orderItems)
                Orderdetils2 = orderItems
                
                for i in Orderdetils2{
                    let free: Double = Double(i.freeValue) ?? 0
                    if free != 0 {
                        FreeDetils.append(Itemwise_Summary(productName: i.freeProductName, ProductID: "", Qty: 0, Free: Int(free)))
                    }}

                
                
                Total_item_lbl.text = String(orderItems.count)
                
                
            
                
                Amountdata.append(Amount_Detils(Amount1: "Net Amount", Amount2:  CurrencyUtils.formatCurrency(amount: json[0]["finalNetAmnt"] as? String ?? "", currencySymbol: UserSetup.shared.currency_symbol)))
                
                Total_amount_summary.text = CurrencyUtils.formatCurrency(amount: json[0]["finalNetAmnt"] as? String ?? "", currencySymbol: UserSetup.shared.currency_symbol)
                
                Remarklbl.text = json[0]["secOrdRemark"] as? String ?? ""
             
                    for j in orderItems{
                        let qty = Double(j.qtyValue)
                        let free = Double(j.freeValue)
                            let productID = j.ProductID.trimmingCharacters(in: .whitespacesAndNewlines)

                            if let index = Itemwise_Summary_Data.firstIndex(where: {
                                $0.ProductID.trimmingCharacters(in: .whitespacesAndNewlines) == productID
                            }) {
                                Itemwise_Summary_Data[index].Qty += Int(qty ?? 0)
                                Itemwise_Summary_Data[index].Free += Int(free ?? 0)
                            } else {
                                let newItem = Itemwise_Summary(
                                    productName: j.productName,
                                    ProductID: productID,
                                    Qty: Int(qty ?? 0),
                                    Free: Int(free ?? 0)
                                )
                                Itemwise_Summary_Data.append(newItem)
                            }
                    }
                
                var QtyTotal = 0
                var FreeTota = 0
                for item in Itemwise_Summary_Data{
                    QtyTotal = QtyTotal + Int(item.Qty)
                    FreeTota = FreeTota + Int(item.Free)
                }
                
                Itemwise_Summary_Data.append(Itemwise_Summary(productName: "Total", ProductID: "", Qty: Int(Double(QtyTotal)), Free: Int(Double(FreeTota))))
                
                var Total_Tax:Double = 0
                var Total_Dis:Double = 0
                
                for i in orderItems{
                    let taxValue = Double(i.taxValue)
                    Total_Tax = Total_Tax + (taxValue ?? 0)
                    let discValue =  Double(i.discValue)
                    Total_Dis = Total_Dis + (discValue ?? 0)
                }
                Taxlbl.text = "\(Total_Tax)"
                Schemelbl.text = "0"
                Cash_did_lbl.text = "0"
                Net_amountlbl.text = json[0]["finalNetAmnt"] as? String ?? ""
                
        
               
                
                
                Route_Detils_Table.reloadData()
                Product_Detils_Table.reloadData()
                Amount_table.reloadData()
                Item_summary_table.reloadData()
                Detils_table.reloadData()
                Free_details_table.reloadData()
                viewDidLayoutSubviews()
             
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    self.printVisibleCellHeights(for: [self.Route_Detils_Table,self.Product_Detils_Table,self.Amount_table,self.Item_summary_table]){
                        print("ok")
                    }
                    self.LoadingDismiss()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.LoadingDismiss()
                }
            }
        }
    }
    
    func printVisibleCellHeights(for tableViews: [UITableView], completion: @escaping () -> Void) {
        var heights: [CGFloat] = []
        
        for tableView in tableViews {
            var height: CGFloat = 0
            for cell in tableView.visibleCells {
                height += cell.frame.height
            }
            heights.append(height)
        }
        DispatchQueue.main.async {
            self.Route_table_height.constant = heights[0]
            self.Product_detils_table_height.constant = heights[1]
            self.Amount_table_View_height.constant = heights[2]
            self.Summary_table_view_height.constant = heights[3]
            
            self.Scroll_VieW_HEIGHT.constant = heights[0]+heights[1]+heights[2]+heights[3]+400
            
            completion()
        }
    }
    
    func parseProductDetails(productCode: String,productDetail: String, reportType: Int) -> [OrderItemModel] {
        var orderItemModelsss: [OrderItemModel] = []

        // Split the main product details using the "#" delimiter
        let productArray = productDetail.split(separator: "#").map { String($0) }
        let product_Code_Array = productCode.split(separator: "#").map { String($0) }
        
        print(product_Code_Array)
        for (product, productCode) in zip(productArray, product_Code_Array) {
            var qtyValue: Double = 0
            var freeValue: Double = 0
            var discValue: Double = 0
            var taxValue: Double = 0
            var rateValue: Double = 0
            var totalValue: Double = 0
            var clValue: Int = 0
            var eQtyValue: Double = 0
            var liter: Double = 0
            var productName = ""
            var uomName = ""
            var freeProductName = ""

            // Extract values using substrings and regex
            do {
                // Extract quantity
                if let qtyRange = product.range(of: "\\$.*?@", options: .regularExpression) {
                    let qty = String(product[qtyRange]).replacingOccurrences(of: ["$", "@"], with: "")
                    qtyValue = Double(qty) ?? 0
                }

                // Extract free value
                if let freeRange = product.range(of: "\\+.*?%", options: .regularExpression) {
                    let free = String(product[freeRange]).replacingOccurrences(of: ["+", "%"], with: "")
                    freeValue = Double(free) ?? 0
                }

                // Extract discount
                if let discRange = product.range(of: "-.*?\\*", options: .regularExpression) {
                    let disc = String(product[discRange]).replacingOccurrences(of: ["-", "*"], with: "")
                    discValue = Double(disc) ?? 0
                }

                // Extract tax amount
                if let taxRange = product.range(of: "%.*?-", options: .regularExpression) {
                    let tax = String(product[taxRange]).replacingOccurrences(of: ["%", "-"], with: "")
                    taxValue = Double(tax) ?? 0
                }

                // Extract rate
                if let rateRange = product.range(of: "\\*.*?!", options: .regularExpression) {
                    let rate = String(product[rateRange]).replacingOccurrences(of: ["*", "!"], with: "")
                    rateValue = Double(rate) ?? 0
                }

                // Extract total value
                if let totalRange = product.range(of: "~.*?\\$", options: .regularExpression) {
                    let total = String(product[totalRange]).replacingOccurrences(of: ["~", "$"], with: "")
                    totalValue = Double(total) ?? 0
                }

                // Extract product name
                if let nameRange = product.range(of: "^.*?~", options: .regularExpression) {
                    productName = String(product[nameRange]).replacingOccurrences(of: "~", with: "").trimmingCharacters(in: .whitespaces)
                }

                // Extract CL value
                if let clRange = product.range(of: "!.*?!", options: .regularExpression) {
                    let cl = String(product[clRange]).replacingOccurrences(of: "!", with: "")
                    clValue = Int(cl) ?? 0
                }

                // Extract UOM name
                if let uomRange = product.range(of: "!.*?%", options: .regularExpression) {
                    uomName = String(product[uomRange]).replacingOccurrences(of: ["!", "%"], with: "").trimmingCharacters(in: .whitespaces)
                    let freeUomName = product.split(separator: "!").map { String($0) }
                    if let lastComponent = freeUomName.last {
                        let getUom = lastComponent.split(separator: "%").map { String($0) }
                        uomName = getUom.first ?? ""
                    }
                }

                // Extract eQty value
                if let eQtyRange = product.range(of: "%.*?\\*", options: .regularExpression) {
                    let eQty = String(product[eQtyRange]).replacingOccurrences(of: ["%", "*"], with: "")
                    eQtyValue = Double(eQty) ?? 0
                }

                // Extract liter value
                if let literRange = product.range(of: "@.*?\\+", options: .regularExpression) {
                    let lit = String(product[literRange]).replacingOccurrences(of: ["@", "+"], with: "")
                    liter = Double(lit) ?? 0
                }

                // Extract free product name (if available)
                if let freeNameRange = product.range(of: "\\?\\?.*?~~", options: .regularExpression) {
                    freeProductName = String(product[freeNameRange]).replacingOccurrences(of: ["??", "~~"], with: "").trimmingCharacters(in: .whitespaces)
                }
                if freeProductName == ""{
                    freeProductName = productName
                }
                if let filteredProduct = lstAllProducts.first(where: { $0["id"] as? String == freeProductName }){
                        freeProductName = filteredProduct["name"] as? String ?? ""
                }
            } catch {
                print("Error parsing product details: \(error)")
            }

            // Calculate liter value if required
            liter = qtyValue * liter

            // Create OrderItemModel and add to list
            let Code = productCode.split(separator: "~").map { String($0) }
            let orderItem = OrderItemModel(
                productName: productName, ProductID: Code[0].trimmingCharacters(in: .whitespacesAndNewlines),
                rateValue: String(rateValue),
                qtyValue: String(qtyValue),
                freeValue: String(freeValue),
                discValue: String(discValue),
                totalValue: String(totalValue),
                taxValue: String(taxValue),
                clValue: String(clValue),
                uomName: String(uomName),
                //eQtyValue: String(eQtyValue),
                eQtyValue: String(qtyValue),
                litersVal: String(liter),
                freeProductName: freeProductName
            )
            orderItemModelsss.append(orderItem)
        }
        return orderItemModelsss
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Detils_table == tableView{
            return 50
        }
        if Free_details_table == tableView{
            return 50
        }
        
      return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Route_Detils_Table == tableView{
            return Route_data.count
        }
        
        if Product_Detils_Table == tableView{
            return Orderdetils.count
        }
        
        if Amount_table == tableView{
            return Amountdata.count
        }
        
        if Item_summary_table == tableView{
            return Itemwise_Summary_Data.count
        }
        
        if Detils_table == tableView{
            return Orderdetils2.count
        }
        
        if Free_details_table == tableView{
            return FreeDetils.count
        }
       
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Secondary_Order_Details_Customcell
        if Route_Detils_Table == tableView{
            cell.Route_lbl.text = Route_data[indexPath.row].Route1
            cell.Route_lbl2.text =  Route_data[indexPath.row].Route2
        }else if Product_Detils_Table == tableView{
            cell.Product_Name.text = Orderdetils[indexPath.row].productName
            cell.Ratelbl.text = Orderdetils[indexPath.row].rateValue
            cell.Qtylbl.text = Orderdetils[indexPath.row].qtyValue
            cell.cllbl.text = Orderdetils[indexPath.row].clValue
            cell.Freelbl.text = Orderdetils[indexPath.row].freeValue
            cell.Dislbl.text = Orderdetils[indexPath.row].discValue
            cell.Taxlbl.text = Orderdetils[indexPath.row].taxValue
            cell.Valuelbl.text = Orderdetils[indexPath.row].totalValue
            cell.Product_Remarklbl.text = ""
            
        }else if Amount_table == tableView{
            cell.Amtlbl.text = Amountdata[indexPath.row].Amount1
            cell.Amtlbl2.text = Amountdata[indexPath.row].Amount2
        }else  if Item_summary_table == tableView{
            
            print(Itemwise_Summary_Data)
            if Itemwise_Summary_Data[indexPath.row].productName == "Total" && Itemwise_Summary_Data[indexPath.row].ProductID == "" {
                // Set the text properties first
                cell.Productname.text = Itemwise_Summary_Data[indexPath.row].productName
                cell.itemqtylbl.text = String(Itemwise_Summary_Data[indexPath.row].Qty)
                cell.Free_lbl.text = String(Itemwise_Summary_Data[indexPath.row].Free)
                // Apply attributed text (font color in this case)
                let font = UIFont.systemFont(ofSize: 14, weight: .bold)
                let attributedText = NSAttributedString(
                    string: cell.Productname?.text ?? "",
                    attributes: [
                        .foregroundColor: UIColor.black,
                        .font: font
                    ]
                )
                let attributedqty = NSAttributedString(string: cell.itemqtylbl?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.09, green: 0.64, blue: 0.29, alpha: 1.00)])
                let attributedRate = NSAttributedString(string:  cell.Free_lbl?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.09, green: 0.64, blue: 0.29, alpha: 1.00)])
                cell.Productname?.attributedText = attributedText
                cell.itemqtylbl?.attributedText = attributedqty
                cell.Free_lbl?.attributedText = attributedRate
            } else {
                cell.Productname.text = Itemwise_Summary_Data[indexPath.row].productName
                cell.itemqtylbl.text = String(Itemwise_Summary_Data[indexPath.row].Qty)
                cell.Free_lbl.text = String(Itemwise_Summary_Data[indexPath.row].Free)
                // Apply attributed text (font color in this case)
                let font = UIFont.systemFont(ofSize: 14, weight: .regular)
                let attributedText = NSAttributedString(
                    string: cell.Productname?.text ?? "",
                    attributes: [
                        .foregroundColor: UIColor.black,
                        .font: font
                    ]
                )
                let attributedqty = NSAttributedString(string: cell.itemqtylbl?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                let attributedRate = NSAttributedString(string:  cell.Free_lbl?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                cell.Productname?.attributedText = attributedText
                cell.itemqtylbl?.attributedText = attributedqty
                cell.Free_lbl?.attributedText = attributedRate
                
            }
        }else  if Detils_table == tableView{
            cell.detils_Product_Name.text = Orderdetils2[indexPath.row].productName
            cell.detils_uom.text = Orderdetils2[indexPath.row].uomName
            cell.detils_Qtylbl.text = Orderdetils2[indexPath.row].qtyValue
            cell.detils_pric.text = Orderdetils2[indexPath.row].rateValue
            cell.detils_Freelbl.text = Orderdetils2[indexPath.row].freeValue
            cell.detils_Dislbl.text = Orderdetils2[indexPath.row].discValue
            cell.detils_Taxlbl.text = Orderdetils2[indexPath.row].taxValue
            cell.detils_Valuelbl.text = Orderdetils2[indexPath.row].totalValue
        } else {
            cell.text1lblb.text = FreeDetils[indexPath.row].productName
            cell.test2lbl.text = String(FreeDetils[indexPath.row].Free)
        }
    
        return cell
    }
    
    @objc private func Opendetils() {
        Details_view.isHidden = false
    }
    @objc private func Closedetils() {
        Details_view.isHidden = true
    }
    
    @objc private func GotoHome() {
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            }
    }
    
    
    
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
    
    
    
    @objc func Textshare() {
        
        print(Orderdetils2)
        
        let data: String = formatOrdersForSharing(orders: Orderdetils2)
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
    
    // Function to format the orders for sharing
    func formatOrdersForSharing(orders: [OrderItemModel]) -> String {
        var formattedText = ""
        
        formattedText += "Distributor : \(Route_data[0].Route2)\n"
       // formattedText += "Retailer : \(Route_data[0].Route2)\n"
       // formattedText += "Route : \(order.Route)\n"
        
        print(Route_data)
        for order in orders {
           
                formattedText += "\(order.productName)\n"
                formattedText += "Rate : \(order.rateValue) Qty : \(order.qtyValue) Value : \(order.totalValue)\n"
            
        }
        formattedText += "Net Amount : \(Amountdata[0].Amount2)\n"
        formattedText += "------------**------------\n"
        
      //  formattedText += "Order Taken By : \(hq_name_sel.text)"
        
        return formattedText
    }
    
}
