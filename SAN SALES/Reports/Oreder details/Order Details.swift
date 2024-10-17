//
//  Order Details.swift
//  SAN SALES
//
//  Created by Mani V on 09/10/24.
//

import UIKit
import Alamofire
import Foundation



class Order_Details: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var Hq_View: UIView!
    @IBOutlet weak var Date_View: UIView!
    
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
    
    @IBOutlet weak var Strik_Line: UIView!
    
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
        var Orderlist:[AnyObject]
    }
    var Orderdata:[Id] = []
    var Oredrdatadetisl:[OrderDetail] = []
    let cardViewInstance = CardViewdata()
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    let LocalStoreage = UserDefaults.standard
    var ProductDetils: [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
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
        
        
        appendDashedBorder(to: das_Border_Line_View)
        
        appendDashedBorder(to: Strik_Line)
        print(das_Border_Line_View.layer.frame.width)
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
            yourViewShapeLayer.path = UIBezierPath(roundedRect: yourViewShapeRect, cornerRadius: 10).cgPath
            view.layer.addSublayer(yourViewShapeLayer)
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
    }
    
    func OrderDayReport() {
        self.ShowLoading(Message: "Loading...")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Foundation.Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        print(formattedDate)
        
        let axn = "get/OrderDayReport"
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&divisionCode=\(DivCode)&rSF=MR4126&sfCode=MR4126&RsfCode=MR4126&rptDt=2024-10-09"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                print(value)
                
                if let json = value as? [String: AnyObject],
                   let dayrepArray = json["dayrep"] as? [[String: AnyObject]] {
                    
                    print(dayrepArray)
                    let ACode = dayrepArray[0]["ACode"] as? String ?? ""
                    
                    let axn = "get/vwVstDet"
                    let apiKey: String = "\(axn)&State_Code=\(StateCode)&divisionCode=\(DivCode)&ACd=\(ACode)&rSF=MR4126&typ=1&sfCode=MR4126&RsfCode=MR4126"
                    
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
                                        ProductDetils.removeAll()
                                        var Detils:[String:Any]=["Product_Name":"Product Name","Rate":"Rate","Qty":"Qty","CL":"CL","Free":"Free","Disc":"Disc","Tax":"Tax","Value":"Value","UOM":"UOM","uomQty":"Qty","Price":"Price","UomFree":"Free","UomDisc":"Disc","UomTax":"Tax","UomTotal":"Total"]
                                        
                                        let jitm: AnyObject = Detils as AnyObject
                                        ProductDetils.append(jitm)
                                        Orderdata[i].Orderdata.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: ProductDetils))
                                        
                                        Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: ProductDetils))

                                    }else{
                                        ProductDetils.removeAll()
                                        
                                        var Detils:[String:Any]=["Product_Name":"Product Name","Rate":"Rate","Qty":"Qty","CL":"CL","Free":"Free","Disc":"Disc","Tax":"Tax","Value":"Value","UOM":"UOM","uomQty":"Qty","Price":"Price","UomFree":"Free","UomDisc":"Disc","UomTax":"Tax","UomTotal":"Total"]
                                        
                                        let jitm: AnyObject = Detils as AnyObject
                                        ProductDetils.append(jitm)
                                        
                                        Orderdata.append(Id(id: id, Stkid: Stkid, Orderdata: [OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: ProductDetils)]))
                                        
                                        Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: ProductDetils))
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

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Item_Summary_table == tableView {
            return 30
        }
        if Day_Report_TB ==  tableView{
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
            return 3
        }
        return Oredrdatadetisl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           if tableView == HQ_and_Route_TB {
               let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Order_Details_TableViewCell
               cell.Route_name.text = Oredrdatadetisl[indexPath.row].Route
               cell.Stockets_Name.text = Oredrdatadetisl[indexPath.row].Stockist
               cell.Store_Name_with_order_No.text = Oredrdatadetisl[indexPath.row].name + "(\(Oredrdatadetisl[indexPath.row].nameid))"
               cell.Addres.text = Oredrdatadetisl[indexPath.row].Adress
               cell.Volumes.text = "Volumes: \(Oredrdatadetisl[indexPath.row].Volumes)"
               cell.Phone.text = "Phone:"+Oredrdatadetisl[indexPath.row].Phone
               cell.Netamt.text = Oredrdatadetisl[indexPath.row].Net_amount
               cell.Remark.text =  Oredrdatadetisl[indexPath.row].Remarks
               
               cell.View_Detils.tag = indexPath.row
               cell.View_Detils.addTarget(target: self, action: #selector(buttonClicked(_:)))
               cell.insideTable1Data = [Oredrdatadetisl[indexPath.row]]
               cell.reloadData()
               return cell
           }else if Day_Report_TB == tableView{
               let cellReport = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Day_Reportdetils
               return cellReport
           }else{
               let cellS = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Item_summary_TB
               cellS.Product_Name.text = "Test"
               cellS.Qty.text = "test qty"
               cellS.Free.text = "test free"
               return cellS
           }
       }
    
    @objc func buttonClicked(_ sender: UIButton) {
        Day_Report_View.isHidden = false
        print("jnj")
    }
    @objc func Back_View(){
        Day_Report_View.isHidden = true
    }
    
    @objc private func GotoHome() {
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
