//
//  Order Details.swift
//  SAN SALES
//
//  Created by Mani V on 09/10/24.
//

import UIKit
import Alamofire



class Order_Details: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var Hq_View: UIView!
    @IBOutlet weak var Date_View: UIView!
    
    @IBOutlet weak var HQ_and_Route_TB: UITableView!
    @IBOutlet weak var Scroll_height: NSLayoutConstraint!
    @IBOutlet weak var Table_height: NSLayoutConstraint!
    
    @IBOutlet weak var Item_Summary_table: UITableView!
    
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
        var Orderlist:[String:Any]
    }
    var Orderdata:[Id] = []
    var Oredrdatadetisl:[OrderDetail] = []
    let cardViewInstance = CardViewdata()
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    let LocalStoreage = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        cardViewInstance.styleSummaryView(Hq_View)
        cardViewInstance.styleSummaryView(Date_View)
        BTback.addTarget(target: self, action: #selector(GotoHome))
        HQ_and_Route_TB.dataSource = self
        HQ_and_Route_TB.delegate = self
        Item_Summary_table.dataSource = self
        Item_Summary_table.delegate = self
        OrderDayReport()
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
                                        var Detils:[String:Any]=["":3]
                                        Orderdata[i].Orderdata.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: Detils))
                                        
                                        Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "0", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: Detils))

                                    }else{
                                        var Detils:[String:Any]=["":3]
                                        Orderdata.append(Id(id: id, Stkid: Stkid, Orderdata: [OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: Detils)]))
                                        
                                        Oredrdatadetisl.append(OrderDetail(id: id, Route: Route, Routeflg: "1", Stockist: Stockist, name: name, nameid: nameid, Adress: Adress, Volumes: String(Volumes), Phone: Phone, Net_amount: Net_amount, Remarks: Remarks, Total_Item: "3", Tax: "0", Scheme_Discount: "", Cash_Discount: "", Orderlist: Detils))
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
            return 100
        }
        return 500
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for i in Orderdata{
            count = count + i.Orderdata.count
        }
        Table_height.constant = CGFloat(Oredrdatadetisl.count * 557)
        Scroll_height .constant = Table_height.constant + 100
        
        
        if Item_Summary_table == tableView{
            return 5
        }
        return Oredrdatadetisl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Order_Details_TableViewCell
           if tableView == HQ_and_Route_TB {
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
           }else{
               cell.Product_Name.text = "Test"
               cell.Qty.text = "test qty"
               cell.Free.text = "test free"
           }
           return cell
       }
    
    @objc private func GotoHome() {
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
