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
        var Stkid:String
        var Date:String
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
        Calender_View.isHidden = true
    }
    
    

    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
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
                    let Order_date = Oredr["Order_date"] as? String ?? ""
                    
                    
                    var outputDate:String = ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    if let date = dateFormatter.date(from: Order_date) {
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                    outputDate = dateFormatter.string(from: date)
                    }
                    
                    
                    if let i = Invoice_Detils.firstIndex(where: { (item) in
                        if item.id == id {
                            return true
                        }
                        return false
                    })
                    {
                        Invoice_Detils[i].Invoice.append(Invoice(orderid: Order_No, invoice_Status: Status,Stkid: id,Date: outputDate, total_amt: Order_Value))
                        
                    }else{
                        Invoice_Detils.append(Dsitdetils(Name: StockistName, id: id, Invoice: [Invoice(orderid: Order_No, invoice_Status: Status,Stkid: id,Date: outputDate, total_amt: Order_Value)]))
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
       return 70
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
            Oredrdatadetisl2 =  Oredrdatadetisl.filter { order in
                order.nameid == item.orderid
            }
            let storyboard = UIStoryboard(name: "Reports 2", bundle: nil)
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "Distributor_Order_Details_cell") as! Distributor_Order_Details_cell
            myDyPln.CodeDate = item.Date
            myDyPln.Orderid = item.orderid
            myDyPln.Stkid = item.Stkid
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
