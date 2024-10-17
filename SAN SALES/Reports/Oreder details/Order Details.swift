//
//  Order Details.swift
//  SAN SALES
//
//  Created by Mani V on 09/10/24.
//

import UIKit
import Alamofire
import Foundation
import FSCalendar


class Order_Details: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegate, FSCalendarDataSource,OrderDetailsCellDelegate{
  
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var Hq_View: UIView!
    
    @IBOutlet weak var hq_name_sel: UILabel!
    @IBOutlet weak var Date_View: UIView!
    
    @IBOutlet weak var date_sel: UILabel!
    
    @IBOutlet weak var HQ_and_Route_TB: UITableView!
    @IBOutlet weak var Scroll_height: NSLayoutConstraint!
    @IBOutlet weak var Table_height: NSLayoutConstraint!
    @IBOutlet weak var Item_Summary_table: UITableView!
    @IBOutlet weak var Day_Report_View: UIView!
    
    
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
    @IBOutlet weak var Calender: FSCalendar!
    
    
    
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
    
    struct Id:Any{
        var id:String
        var Stkid:String
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
        var Orderlist:[OrderItemModel]
    }
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
        Calender.delegate = self
        Calender.dataSource = self
        Hq_Table.dataSource = self
        Hq_Table.delegate = self
        appendDashedBorder(to: das_Border_Line_View)
        appendDashedBorder(to: Strik_Line)
        
        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list;
            lObjSel=lstHQs
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
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let selectdate = DateFormatter()
        selectdate.dateFormat = "yyyy-MM-dd"
        let dates = selectdate.string(from: date)
        Select_Dtae = dates
        date_sel.text = dates
        OrderDayReport()
        Calender_View.isHidden = true
    }
    
    
    func OrderDayReport() {
        
        Oredrdatadetisl.removeAll()
        Orderdata.removeAll()
        self.ShowLoading(Message: "Loading...")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Foundation.Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        print(formattedDate)
        
        let axn = "get/OrderDayReport"
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&RsfCode=\(Sf_Id)&rptDt=\(Select_Dtae)"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                print(value)
                
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
                    
                    let axn = "get/vwVstDet"
                    let apiKey: String = "\(axn)&State_Code=\(StateCode)&divisionCode=\(DivCode)&ACd=\(ACode)&rSF=\(SFCode)&typ=1&sfCode=\(SFCode)&RsfCode=\(Sf_Id)"
                    
                    AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
                        print(AFdata)
                        switch AFdata.result {
                        case .success(let value):
                            print(value)
                            if let json = value as? [AnyObject]{
                                print(json)
                                
                                for j in json{
                                  print(j)
                                    let id = j["id"] as? String ?? ""
                                    let Route = j["Territory"] as? String ?? ""
                                    let Stockist = j["stockist_name"] as? String ?? ""
                                    let name = j["name"] as? String ?? ""
                                    let nameid = j["Order_No"] as? String ?? ""
                                    let Adress = j["Address"] as? String ?? ""
                                    let Volumes = j["liters"] as? Double ?? 0
                                    let Phone = j["phoneNo"] as? String ??  ""
                                    let Net_amount = j["finalNetAmnt"] as? String ?? ""
                                    let Remarks = j["remarks"] as? String ?? ""
                                    let Stkid = j["stockist_code"] as? String ?? ""
                                 
                                    
                                    if let i = Orderdata.firstIndex(where: { (item) in
                                        if item.Stkid == Stkid {
                                            return true
                                        }
                                        return false
                                    }){
                                      print(i)
                                        print(j)
                                        let products = j["products"] as? String ?? ""
                                                  let productArray = products.split(separator: ",").map { String($0) }
                                           print(productArray)
                                        let taxArray: [String]? = ["0.0", "0.0."]
                                       let itemList = parseProducts(products, taxArray: taxArray)
                                        Orderdata[i].Orderdata.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: itemList))
                                        
                                        Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: itemList))

                                    }else{
                                        
                                        let products = j["products"] as? String ?? ""
                                        let productArray = products.split(separator: ",").map { String($0) }
                                        print(productArray)
                                        let taxArray: [String]? = ["0.0", "0.0."]
                                        let itemList = parseProducts(products, taxArray: taxArray)
                                        
                                        
                                        print(itemList)
                                        
                                        
                                        
                                        Orderdata.append(Id(id: id, Stkid: Stkid, Orderdata: [OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: itemList)]))
                                        
                                        Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: itemList))
                                    }
                                }
                                
                                print(Orderdata)
                                HQ_and_Route_TB.reloadData()
                            }
                            
                            
                        case .failure(let error):
                            Toast.show(message: error.errorDescription ?? "", controller: self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.LoadingDismiss()
                            }
                        }
                    }
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

    
    func parseProducts(_ products: String, taxArray: [String]?) -> [OrderItemModel] {
        var itemModelList = [OrderItemModel]()
        var netAmount: Double = 0

        let productArray = products.split(separator: ",").map { String($0) }
        print(productArray)

        for (i, product) in productArray.enumerated() {
            let taxAmt = taxArray?.indices.contains(i) == true ? taxArray![i] : "0"

            let qtyValue = extractDouble(from: product, start: ") (", end: "@")
            let freeValue = extractDouble(from: product, start: "+", end: "%")
            let discValue = extractDouble(from: product, start: "-", end: "*")
            let taxValue = Double(taxAmt.filter { "0123456789.".contains($0) }) ?? 0
            let rateValue = extractDouble(from: product, start: "*", end: "!")
            let litersVal = extractDouble(from: product, start: "@", end: "+")
            let clValue = Int(extractString(from: product, start: "!", end: "!") ?? "0") ?? 0
            let uomName = extractString(from: product, start: "!", end: "%") ?? ""
            let eQtyValue = extractDouble(from: product, start: "%", end: "*")

            let totalValue = (rateValue * qtyValue) + taxValue - discValue
            netAmount += totalValue

            let productName = extractProductName(product, totalValue: totalValue)
            let freeProductName = extractFreeProductName(product)

            let orderItem = OrderItemModel(
                productName: productName,
                rateValue: String(rateValue),
                qtyValue: String(qtyValue),
                freeValue:  String(freeValue),
                discValue:  String(discValue),
                totalValue:  String(totalValue),
                taxValue:  String(taxValue),
                clValue:  String(clValue),
                uomName:  String(uomName),
                eQtyValue:  String(eQtyValue),
                litersVal:  String(litersVal),
                freeProductName: freeProductName
            )

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
        let marker = "( \(Int(totalValue))"
        guard let range = product.range(of: marker) else { return "" }
        return String(product[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
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
        return 500
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for i in Orderdata{
            count = count + i.Orderdata.count
        }
        Table_height.constant = CGFloat(Oredrdatadetisl.count * 520)
        Scroll_height .constant = Table_height.constant + 100
        
        
        if Item_Summary_table == tableView{
            return 5
        }
        
        if Day_Report_TB == tableView {
            Scroll_Height_TB.constant = Scroll_Height_TB.constant -  Day_Report_TB_height.constant
            
            Day_Report_TB_height.constant = CGFloat(Orderlist.count * 50)
            Scroll_Height_TB.constant = Scroll_Height_TB.constant + CGFloat(Day_Report_TB_height.constant)
            return Orderlist.count
        }
        if Hq_Table == tableView{
            return lObjSel.count
        }
        return Oredrdatadetisl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           if tableView == HQ_and_Route_TB {
               let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Order_Details_TableViewCell
               cell.delegate = self
               cell.Route_name.text = Oredrdatadetisl[indexPath.row].Route
               cell.Stockets_Name.text = Oredrdatadetisl[indexPath.row].Stockist
               cell.Store_Name_with_order_No.text = Oredrdatadetisl[indexPath.row].name + "(\(Oredrdatadetisl[indexPath.row].nameid))"
               cell.Addres.text = Oredrdatadetisl[indexPath.row].Adress
               cell.Volumes.text = "Volumes: \(Oredrdatadetisl[indexPath.row].Volumes)"
               cell.Phone.text = "Phone:"+Oredrdatadetisl[indexPath.row].Phone
               cell.Netamt.text = Oredrdatadetisl[indexPath.row].Net_amount
               cell.Remark.text =  Oredrdatadetisl[indexPath.row].Remarks
               cell.insideTable1Data = [Oredrdatadetisl[indexPath.row]]
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
               cellS.Product_Name.text = "Test"
               cellS.Qty.text = "test qty"
               cellS.Free.text = "test free"
               return cellS
           }
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Hq_Table == tableView{
            let Item = lObjSel[indexPath.row]
            Sf_Id = Item["id"] as? String ?? SFCode
            hq_name_sel.text = Item["name"] as? String ?? ""
            Text_Search.text = ""
            OrderDayReport()
            Sel_Wid.isHidden = true
        }
    }
    
    // MARK: - OrderDetailsCellDelegate Method
      func didTapButton(in cell: Order_Details_TableViewCell) {
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
          Total_item.text = String(Item.Orderlist.count)
          Orderlist = Item.Orderlist
          Tax.text = "0"
          Sch_Disc.text = "0"
          Cas_disc.text = "0"
          Net_Amt.text = "0"
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
        Text_Search.text = ""
        Sel_Wid.isHidden = true
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
    
}
