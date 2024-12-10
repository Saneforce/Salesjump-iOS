//
//  Secondary order details view.swift
//  SAN SALES
//
//  Created by Anbu j on 06/12/24.
//

import UIKit
import Alamofire

class Secondary_order_details_view: IViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var Button_back: UIImageView!
    @IBOutlet weak var Dynamic_Header_lbl: UILabel!
    
    @IBOutlet weak var Total_Value_Amt: UILabel!
    
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    var sfName:String = ""
    var Desig: String=""
    let LocalStoreage = UserDefaults.standard
    
    struct OrderItemModels {
        var productName: String
        var productId:String
        var rateValue: String
        var qtyValue: String
        var freeValue: String
        var discValue: String
        var totalValue: String
        var taxValue: String
        var clValue: String
        var uomName: String
        var eQtyValue: String
        var liter: String
        var freeProductName: String
    }
    struct Distobutor_OrderDetail:Any{
        var Dis_Name: String
        var Order_Id:String
        var Amt:String
        var Remark:String
        var date:String
        var Phone_No:String
        var Tax:String
        var Dis:String
        var stockist_name:String
        var Territory:String
        var Orderitem:[OrderItemModels]
    }
    struct Itemwise_Summary:Any{
        let productName: String
        let ProductID:String
        var Qty:Int
        var Free:Int
    }
    var OrderDetils_For_Distributor:[Distobutor_OrderDetail] = []
    var Itemwise_Summary_Data:[Itemwise_Summary] = []
    var lstAllProducts: [AnyObject] = []
    
    var axn:String?
    var ACCode:String?
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
    
    @IBOutlet weak var Secondary_order_details_table: UITableView!
    @IBOutlet weak var Itemwise_summary: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        getUserDetails()
        Dynamic_Header_lbl.text = "Secondary Order Details For: 2024-12-06"
        Button_back.addTarget(target: self, action: #selector(GotoHome))
        get_localdata()
        if let date = CodeDate,let id = Orderid,let stkid = Stkid,let Get_hq_id = Hqid, let get_hq_name = Hqname{
            GetDate = date
            Orderid2 = id
            Stkid2 = stkid
            Headquarterid = Get_hq_id
            HeadquarterName = get_hq_name
        }
        Secondary_order_details_table.delegate = self
        Secondary_order_details_table.dataSource = self
        Secondary_order_details_table.rowHeight = UITableView.automaticDimension
        Secondary_order_details_table.estimatedRowHeight = 150
        
        Itemwise_summary.delegate = self
        Itemwise_summary.dataSource = self
        Itemwise_summary.rowHeight = UITableView.automaticDimension
        Itemwise_summary.estimatedRowHeight = 150
        
        VstDet_order()
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
    func get_localdata(){
        let lstProdData: String = LocalStoreage.string(forKey: "Products_Master")!
        if let list = GlobalFunc.convertToDictionary(text: lstProdData) as? [AnyObject] {
            lstAllProducts = list;
            print(lstProdData)
        }
    }
    func VstDet_order(){
        
        let apiKey: String = "get%2FvwVstDet_order&State_Code=\(StateCode)&stockist_code=\(Stkid2)&divisionCode=\(DivCode)&orderDt=\(GetDate)&orderNo=\(Orderid2)&code=&%20rSF=\(SFCode)&typ=1&sfCode=\(SFCode)"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            switch AFdata.result {
            case .success(let value):
               let json = (value as? [AnyObject])!
                
                print(json)
                let productDetail = json[0]["Product_Detail"] as? String ?? ""
                let productCode = json[0]["Product_Code"] as? String ?? ""
                
                let reportType = 1
                let orderItems = parseProductDetails(productCode: productCode, productDetail: productDetail, reportType: reportType)
                
                var Total_Tax:Double = 0
                var Total_Dis:Double = 0
                
                for i in orderItems{
                    let taxValue = Double(i.taxValue)
                    Total_Tax = Total_Tax + (taxValue ?? 0)
                    let discValue =  Double(i.discValue)
                    Total_Dis = Total_Dis + (discValue ?? 0)
                }
                
                OrderDetils_For_Distributor.append(Distobutor_OrderDetail(Dis_Name: json[0]["name"] as? String ?? "", Order_Id: json[0]["trans_sl_no"] as? String ?? "", Amt: String(json[0]["orderValue"] as? Double ?? 0), Remark: json[0]["remarks"] as? String ?? "", date: json[0]["Order_date"] as? String ?? "", Phone_No: json[0]["mobNo"] as? String ?? "", Tax: String(Total_Tax), Dis: String(Total_Dis), stockist_name: json[0]["stockist_name"] as? String ?? "", Territory: json[0]["Territory"] as? String ?? "", Orderitem: orderItems))
                
                
                print(OrderDetils_For_Distributor)
                
                
                for item in OrderDetils_For_Distributor{
                    for j in item.Orderitem{
                        let qty = Double(j.qtyValue)
                        let free = Double(j.freeValue)
                            let productID = j.productId.trimmingCharacters(in: .whitespacesAndNewlines)

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
                }
                var QtyTotal = 0
                var FreeTota = 0
                for item in Itemwise_Summary_Data{
                    QtyTotal = QtyTotal + Int(item.Qty)
                    FreeTota = FreeTota + Int(item.Free)
                }
                
                Itemwise_Summary_Data.append(Itemwise_Summary(productName: "Total", ProductID: "", Qty: Int(Double(QtyTotal)), Free: Int(Double(FreeTota))))
                
              //  let Total: Double = Double(OrderDetils_For_Distributor[0].Amt) ?? 0
                
//                Total_Value_Amt.text = CurrencyUtils.formatCurrency(amount: Total, currencySymbol: UserSetup.shared.currency_symbol)
                
                
                
                DispatchQueue.main.async {
                    self.Secondary_order_details_table.reloadData()
                    self.Itemwise_summary.reloadData()
                    self.printVisibleCellHeights(tableView: self.Secondary_order_details_table)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.LoadingDismiss()
                }
                print(OrderDetils_For_Distributor)
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.LoadingDismiss()
                }
            }
        }
    }
    func printVisibleCellHeights(tableView: UITableView) {
        var height = 0.0
        for (index, cell) in tableView.visibleCells.enumerated() {
            let cellHeight = cell.frame.height
            print("Visible cell \(index) height: \(cellHeight)")
            height = height + cellHeight
        }
//        DispatchQueue.main.async {
//            self.Product_Details_table_height.constant = height
//        }
        
    }
    
    
    func parseProductDetails(productCode: String,productDetail: String, reportType: Int) -> [OrderItemModels] {
        var orderItemModelsss: [OrderItemModels] = []

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
        
            let orderItem = OrderItemModels(
                productName: productName, productId: Code[0].trimmingCharacters(in: .whitespacesAndNewlines),
                rateValue: String(rateValue),
                qtyValue: String(qtyValue),
                freeValue: String(freeValue),
                discValue: String(discValue),
                totalValue: String(totalValue),
                taxValue: String(taxValue),
                clValue: String(clValue),
                uomName: String(uomName),
                eQtyValue: String(eQtyValue),
                liter: String(liter),
                freeProductName: freeProductName
            )

            orderItemModelsss.append(orderItem)
        }

        return orderItemModelsss
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Secondary_order_details_table == tableView{
            return UITableView.automaticDimension
        }
        
        if Itemwise_summary == tableView{
            return UITableView.automaticDimension
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  Secondary_order_details_table == tableView{
            return OrderDetils_For_Distributor.count
        }
        
        if Itemwise_summary == tableView{
           return Itemwise_Summary_Data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if Secondary_order_details_table == tableView{
            let cell:Secondary_Order_Details_Customcell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Secondary_Order_Details_Customcell
            let item = OrderDetils_For_Distributor[indexPath.row]
            print(item)
            cell.Name_and_idlbl.text = item.Order_Id
            cell.Addresslbl.text = "gh"
            cell.Routelbl.text = item.Territory
            cell.Supply_fromlbl.text = item.stockist_name
            cell.Phonelbl.text = item.Phone_No
            cell.Volumlbl.text = "199"
            cell.Netamtlbl.text = item.Amt
            cell.Remarklbl.text = ""
            cell.insideTable1Data = [item]
            cell.reloadData()
            return cell
        }else if Itemwise_summary == tableView{
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
        return UITableViewCell()
    }
    
    
    @objc private func GotoHome() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Reports 2", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "DAY_REPORT_WITH_DATE_RANGE") as! DAY_REPORT_WITH_DATE_RANGE
            let navController = UINavigationController(rootViewController: viewController)
            
            UIApplication.shared.windows.first?.rootViewController = navController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
}
