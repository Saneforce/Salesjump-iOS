//
//  Secondary Order Details.swift
//  SAN SALES
//
//  Created by Anbu j on 05/12/24.
//

import UIKit
import Alamofire
import FSCalendar
class Secondary_Order_Details: IViewController, UITableViewDelegate, UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource {
 
    @IBOutlet weak var Button_Back: UIImageView!
    @IBOutlet weak var HeadquarterView: UIView!
    @IBOutlet weak var HeadquarterView_height: NSLayoutConstraint!
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var Select_datelbl: UILabel!
    @IBOutlet weak var Secondary_Order_Table: UITableView!
    @IBOutlet weak var Order_Details_View: UIView!
    @IBOutlet weak var Closeview: UIImageView!
    @IBOutlet weak var Order_Details_Table: UITableView!
    @IBOutlet weak var Calendar_view: UIView!
    @IBOutlet weak var Calendar_view_back_button: UIImageView!
    @IBOutlet weak var Calendar: FSCalendar!
    
    @IBOutlet weak var Retiler_view: UIView!
    @IBOutlet weak var Retilerlbl: UILabel!
    
    
    
    @IBOutlet weak var No_data_lbl: UILabel!
    
    
    let cardViewInstance = CardViewdata()
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    var sfName:String = ""
    var Desig: String=""
    let LocalStoreage = UserDefaults.standard
    var Select_Dtae:String = ""
    struct Dsitdetils:Any{
        var Name:String
        var id:String
        var Invoice:[Invoice] = []
    }
    struct Invoice:Any{
        var orderid:String
        var Sup_Name:String
        var Stkid:String
        var Date:String
        var total_amt:String
        var Address:String
    }
    var Invoice_Detils:[Dsitdetils] = []
    var Retailer_Details:[Invoice] = []
    var Tb_Invoice:[Invoice] = []
    var Retiler_name:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        Button_Back.addTarget(target: self, action: #selector(GotoHome))
        Closeview.addTarget(target: self, action: #selector(CloseView))
        DateView.addTarget(target: self, action: #selector(Open_Calender))
        Calendar_view_back_button.addTarget(target: self, action: #selector(Close_Calender))
        HeadquarterView_height.constant = 0
        HeadquarterView.isHidden = true
        cardViewInstance.styleSummaryView(HeadquarterView)
        cardViewInstance.styleSummaryView(DateView)
        cardViewInstance.styleSummaryView(Retiler_view)
        
        Secondary_Order_Table.delegate = self
        Secondary_Order_Table.dataSource = self
        Order_Details_Table.delegate = self
        Order_Details_Table.dataSource = self
        Order_Details_Table.rowHeight = UITableView.automaticDimension
        Order_Details_Table.estimatedRowHeight = 130.0
        Calendar.delegate = self
        Calendar.dataSource = self
        
        let selectdate = DateFormatter()
        selectdate.dateFormat = "yyyy-MM-dd"
        let dates = selectdate.string(from: Date())
        Select_Dtae = dates
        selectdate.dateFormat = "dd-MM-yyyy"
        let Showing_dateFormat = selectdate.string(from: Date())
        Select_datelbl.text = Showing_dateFormat
        Distords_sec()
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
        selectdate.dateFormat = "dd-MM-yyyy"
        let Showing_dateFormat = selectdate.string(from: date)
        Select_datelbl.text = Showing_dateFormat
        Distords_sec()
        Calendar_view.isHidden = true
    }
    
    func Distords_sec(){
        Invoice_Detils.removeAll()
        let axn = "get/distords_sec"
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&order_date=\(Select_Dtae)&divisionCode=\(DivCode)&code=\(SFCode)&rSF=\(SFCode)&sfCode=\(SFCode)"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            switch AFdata.result {
            case .success(let value):
              let json = (value as? [AnyObject])!
                print(json)
                
                for Oredr in json{
                    let id = Oredr["StkCd"] as? String ?? ""
                    let StockistName = Oredr["stockiest_name"] as? String ?? ""
                    let  Order_No = Oredr["Order_No"] as? String ?? ""
                    let Sup_Name = Oredr["Sup_Name"] as? String ?? ""
                    let Order_Value = String(Oredr["Order_Value"] as? Double ?? 0)
                    let Order_date = Oredr["OrderDDt"] as? String ?? ""
                    let Sup_Code = Oredr["Sup_Code"] as? String ?? ""
                    
                    
                    var outputDate:String = ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    if let date = dateFormatter.date(from: Order_date) {
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                    outputDate = dateFormatter.string(from: date)
                    }
                    var lstRetails: [AnyObject] = []
                    if let lstRetailData = LocalStoreage.string(forKey: "Retail_Master_"+SFCode),
                       let list = GlobalFunc.convertToDictionary(text:  lstRetailData) as? [AnyObject] {
                        lstRetails = list
                    }
                    
                    
                    let filterRetailer = lstRetails.filter { ($0["id"] as? String ?? "") == Sup_Code }
                   var ListedDr_Address1 = ""
                    if !filterRetailer.isEmpty{
                        ListedDr_Address1 = filterRetailer[0]["ListedDr_Address1"] as? String ?? ""
                    }
                    
                    if let i = Invoice_Detils.firstIndex(where: { (item) in
                        if item.id == id {
                            return true
                        }
                        return false
                    })
                    {
                        Invoice_Detils[i].Invoice.append(Invoice(orderid: Order_No, Sup_Name: Sup_Name,Stkid: id,Date: outputDate, total_amt: Order_Value, Address: ListedDr_Address1))
                        
                    }else{
                        Invoice_Detils.append(Dsitdetils(Name: StockistName, id: id, Invoice: [Invoice(orderid: Order_No, Sup_Name: Sup_Name,Stkid: id,Date: outputDate, total_amt: Order_Value, Address: ListedDr_Address1)]))
                    }
                }
                
                if Invoice_Detils.isEmpty{
                    No_data_lbl.isHidden = false
                }else{
                    No_data_lbl.isHidden = true
                }
                Secondary_Order_Table.reloadData()
                
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.LoadingDismiss()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Secondary_Order_Table == tableView{
            return 70
        }
        
        if tableView == Order_Details_Table {
            
            print(UITableView.automaticDimension)
            return UITableView.automaticDimension
       }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Secondary_Order_Table == tableView{
            return Invoice_Detils.count
        }
        return Retailer_Details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Secondary_Order_Table == tableView{
            let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            cell.lblText.text = Invoice_Detils[indexPath.row].Name
            cell.lblText2.text = "\(Invoice_Detils[indexPath.row].Invoice.count) Secondary"
            cardViewInstance.styleSummaryView(cell.Card_View)
            return cell
        }else{
            let Secondary_Order_cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            Secondary_Order_cell.Orderid.text = Retailer_Details[indexPath.row].orderid
            Secondary_Order_cell.Retiler_Nmae.text =  Retailer_Details[indexPath.row].Sup_Name
            Secondary_Order_cell.amt.text = Retailer_Details[indexPath.row].total_amt
            Secondary_Order_cell.Retiler_Address.text = Retailer_Details[indexPath.row].Address
            cardViewInstance.styleSummaryView(Secondary_Order_cell.Card_View)
            return Secondary_Order_cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Secondary_Order_Table == tableView{
            Retilerlbl.text = Invoice_Detils[indexPath.row].Name
            Retailer_Details = Invoice_Detils[indexPath.row].Invoice
            Retiler_name = Invoice_Detils[indexPath.row].Name
            Order_Details_Table.reloadData()
            Order_Details_View.isHidden = false
            
        }else{
            let item = Retailer_Details[indexPath.row]
            let storyboard = UIStoryboard(name: "Reports 2", bundle: nil)
//            let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbSecondary_order_details_view") as! Secondary_order_details_view
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbSecondary_order_details_view") as! Secondary_order_details_view
            
            myDyPln.CodeDate = item.Date
            myDyPln.Orderid = item.orderid
            myDyPln.Stkid = item.Stkid
            myDyPln.Typ = "2"
            myDyPln.Retiler_name = Retiler_name
            myDyPln.Hqid = ""//Headquarterid
            myDyPln.Hqname = ""//Headquarterlbl.text
            
            self.navigationController?.pushViewController(myDyPln, animated: true)
        }
    }
    @objc private func CloseView(){
        Order_Details_View.isHidden = true
    }
    
    @objc private func Open_Calender(){
        Calendar_view.isHidden = false
    }
    
    @objc private func Close_Calender(){
        Calendar_view.isHidden = true
    }
    
    @objc private func GotoHome(){
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
