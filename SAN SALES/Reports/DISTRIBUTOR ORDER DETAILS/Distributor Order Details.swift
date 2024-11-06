//
//  Distributor Order Details.swift
//  SAN SALES
//
//  Created by Anbu j on 28/10/24.
//

import UIKit
import Alamofire
import Foundation
import FSCalendar
class Distributor_Order_Details: IViewController, UITableViewDelegate, UITableViewDataSource,FSCalendarDelegate {
   
    
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var TB_view: UITableView!
    
    
    
    @IBOutlet weak var Invoice_View: UIView!
    @IBOutlet weak var Invoice_BT: UIImageView!
    @IBOutlet weak var iNVOICE_tb: UITableView!
    
    
    @IBOutlet weak var Select_Date: UILabel!
    
    @IBOutlet weak var Date_View: UIView!
    
    
    @IBOutlet weak var Close_Calender: UIImageView!
    let cardViewInstance = CardViewdata()
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    var sfName:String = ""
    var Desig: String=""
    let LocalStoreage = UserDefaults.standard
    var json:[AnyObject] = []
    var Select_Dtae:String = ""
    
    
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
    struct Id:Any{
        var id:String
        var Stkid:String
        var RouteId:String
        var Orderdata:[OrderDetail]
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
    
    struct Dsitdetils:Any{
        var Name:String
        var id:String
        var Invoice:[Invoice] = []
    }
    
    struct Invoice:Any{
        var orderid:String
        var invoice_Status:String
        var total_amt:String
    }
    
    var Invoice_Detils:[Dsitdetils] = []
    
    var Tb_Invoice:[Invoice] = []
    
    var Oredrdatadetisl2:[OrderDetail] = []
    
    
    
    @IBOutlet weak var Calender_View: UIView!
    
    
    @IBOutlet weak var Calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserDetails()
        cardViewInstance.styleSummaryView(Date_View)
        
        let selectdate = DateFormatter()
        selectdate.dateFormat = "yyyy-MM-dd"
        let dates = selectdate.string(from: Date())
        Select_Dtae = dates
        Select_Date.text = dates
        
        BTback.addTarget(target: self, action: #selector(GotoHome))
        Invoice_BT.addTarget(target: self, action: #selector(Close_View))
        Date_View.addTarget(target: self, action: #selector(Open_Calendr))
        Close_Calender.addTarget(target: self, action: #selector(Close_Calendr))
        TB_view.delegate = self
        TB_view.dataSource = self
        iNVOICE_tb.delegate = self
        iNVOICE_tb.dataSource = self
        Calendar.delegate = self
        
        TB_view.sectionHeaderHeight = 10
        TB_view.sectionFooterHeight = 10
        OrderDayReport()
        Afcode()

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
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let selectdate = DateFormatter()
        selectdate.dateFormat = "yyyy-MM-dd"
        let dates = selectdate.string(from: date)
        
        Select_Dtae = dates
        Select_Date.text = dates
        OrderDayReport()
        Afcode()
        Calender_View.isHidden = true
    }
    
    

    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    
    func Afcode(){
      
        self.ShowLoading(Message: "Loading...")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Foundation.Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        print(formattedDate)
        
        let axn = "get/OrderDayReport"
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&RsfCode=\(SFCode)&rptDt=\(Select_Dtae)"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            switch AFdata.result {
            case .success(let value):
                if let json = value as? [String: AnyObject],
                   let dayrepArray = json["dayrep"] as? [[String: AnyObject]] {
                    print(json)
                    print(dayrepArray)
                    if dayrepArray.isEmpty{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.LoadingDismiss()
                        }
                        return
                    }
                    let ACode = dayrepArray[0]["ACode"] as? String ?? ""
                    DisOrder(ACode: ACode)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
    
    
    
    func DisOrder(ACode:String){
        Oredrdatadetisl.removeAll()
        Orderdata.removeAll()
        Itemwise_Summary_Data.removeAll()
    
        self.ShowLoading(Message: "Loading...")
        let axn:String = "get/vwVstDetNative"
       let apiKey: String = "\(axn)&desig=\(Desig)&divisionCode=\(DivCode)&ACd=\(ACode)&rSF=\(SFCode)&typ=3&sfCode=\(SFCode)&State_Code=\(StateCode)"
        
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
                            var netAmount = ""
                            
                           
                                netAmount = String(j["orderValue"] as? Double ?? 0)
                           
                            
                            let Remarks = j["secOrdRemark"] as? String ?? ""
                            let Stkid = j["stockist_code"] as? String ?? ""
                            let tlDisAmt = j["tlDisAmt"] as? String ?? ""
                            let Order_date = j["Order_date"] as? String ?? ""
                            
                            let minsAmount = Double(netAmount.isEmpty ? "0" : netAmount)! - Double(j["tlDisAmt"] as? String ?? "0")!
                            
                            let  Net_amount = netAmount.isEmpty ? "0" : netAmount
                            let Final_Amt = String(format: "%.2f", minsAmount)
                            
                            print(minsAmount)
                            
                           
                            let Additional_Prod_Dtls = j["productList"] as! [AnyObject]
                            var itemModelList = [OrderItemModel]()
                            for Item2 in Additional_Prod_Dtls {
                                let orderItem = OrderItemModel(
                                    productName: Item2["Product_Name"] as? String ?? "",
                                    ProductID: Item2["Product_Code"] as? String ?? "",
                                    rateValue: String(Item2["Rate"] as? Double ?? 0),
                                    qtyValue: String(Item2["Quantity"] as? Int ?? 0),
                                    freeValue: String(Item2["Free"] as? Int ?? 0),
                                    discValue: String(Item2["discount"] as? Double ?? 0),
                                    totalValue: String(Item2["sub_total"] as?  Double ?? 0),
                                    taxValue: String(Item2["taxval"] as? Double ?? 0),
                                    clValue: Item2["Cl_bal"] as? String ?? "",
                                    uomName: Item2["Product_Unit_Name"] as? String ?? "",
                                    eQtyValue:String(Item2["eqty"] as? Int ?? 0),
                                    litersVal: String(0),
                                    freeProductName: Item2["Offer_ProductNm"] as? String ?? ""
                                )
                                print(orderItem)

                                itemModelList.append(orderItem)
                            }
                            
                            let itemList = itemModelList
                            
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
                            
                            
                            var Total_discValue = 0.0
                            var Total_taxValue = 0.0
                            
                            for k in itemList{
                                Total_discValue = Total_discValue + Double(k.discValue)!
                                Total_taxValue = Total_taxValue + Double(k.taxValue)!
                            }
                            
                            
                            Orderdata.append(Id(id: id, Stkid: Stockist, RouteId: Route, Orderdata: [OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: "1. "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: 1,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount (10%)", Final_Amt: Final_Amt, Orderlist: itemList)]))
                            
                            Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: "1. "+name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "\(itemList.count)", Tax: "0", Scheme_Discount: "", Cash_Discount: "", tlDisAmt: tlDisAmt, Order_date: Order_date, Order_Count: 1,Total_Dic: Total_discValue,Total_Tax: Total_taxValue,Total_disc_lbl:"Total Discount ()", Final_Amt: Final_Amt,Orderlist: itemList))
                            
                            
                        }
                        print(Oredrdatadetisl)
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
    
    
    func OrderDayReport(){
        Invoice_Detils.removeAll()
        let axn = "get%2Fdistords"
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&order_date=\(Select_Dtae)&divisionCode=\(DivCode)&code=\(SFCode)&rSF=\(SFCode)&sfCode=\(SFCode)"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            switch AFdata.result {
            case .success(let value):
                json = (value as? [AnyObject])!
                
                print(json)
                
                for Oredr in json{
                    let id = Oredr["StkCd"] as? String ?? ""
                    let StockistName = Oredr["StockistName"] as? String ?? ""
                    let  Order_No = Oredr["Order_No"] as? String ?? ""
                    let Status = Oredr["Status"] as? String ?? ""
                    let Order_Value = String(Oredr["Order_Value"] as? Double ?? 0)
                    
                    if let i = Invoice_Detils.firstIndex(where: { (item) in
                        if item.id == id {
                            return true
                        }
                        return false
                    })
                    {
                        Invoice_Detils[i].Invoice.append(Invoice(orderid: Order_No, invoice_Status: Status, total_amt: Order_Value))
                        
                    }else{
                        Invoice_Detils.append(Dsitdetils(Name: StockistName, id: id, Invoice: [Invoice(orderid: Order_No, invoice_Status: Status, total_amt: Order_Value)]))
                    }
                }
                print(Invoice_Detils)
                TB_view.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if iNVOICE_tb == tableView {
            return 90
        }
       return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if iNVOICE_tb == tableView {
            return Tb_Invoice.count
        }
        return Invoice_Detils.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        
        if iNVOICE_tb == tableView {
            cell.lblText.text = Tb_Invoice[indexPath.row].orderid
            cell.lblText2.text = Tb_Invoice[indexPath.row].invoice_Status
            cell.lblAmt.text = Tb_Invoice[indexPath.row].total_amt
            cell.Card_View.layer.cornerRadius = 10
        }else{
            cell.lblText.text = Invoice_Detils[indexPath.row].Name
            cell.lblText2.text =   "\(Invoice_Detils[indexPath.row].Invoice.count) Primary"
            cardViewInstance.styleSummaryView(cell.Card_View)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if iNVOICE_tb == tableView {
            let item = Tb_Invoice[indexPath.row]
            print(item)
            print(Oredrdatadetisl)
            print(Oredrdatadetisl2)
            Oredrdatadetisl2 =  Oredrdatadetisl.filter { order in
                order.nameid == item.orderid
            }
            print(Oredrdatadetisl2)
            
            print(Oredrdatadetisl)
            
            let storyboard = UIStoryboard(name: "Reports 2", bundle: nil)
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "Distributor_Order_Details_cell") as! Distributor_Order_Details_cell
            myDyPln.CodeDate = Select_Dtae
            myDyPln.Order_Detisl = Oredrdatadetisl2
            self.navigationController?.pushViewController(myDyPln, animated: true)
            
        }else{
            Tb_Invoice = Invoice_Detils[indexPath.row].Invoice
            iNVOICE_tb.reloadData()
            Invoice_View.isHidden = false
        }
    }
    
    
    @objc private func GotoHome() {
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    @objc private func Close_View() {
        Invoice_View.isHidden = true
    }
    
    @objc private func Open_Calendr() {
        Calender_View.isHidden = false
    }
    @objc private func Close_Calendr() {
        Calender_View.isHidden = true
    }
    
}
