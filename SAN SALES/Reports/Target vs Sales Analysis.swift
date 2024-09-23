//
//  Target vs Sales Analysis.swift
//  SAN SALES
//
//  Created by Anbu j on 19/09/24.
//

import UIKit
import Alamofire
import Foundation
class Target_vs_Sales_Analysis: IViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var HQ_View: UIView!
    @IBOutlet weak var Vw_Sel: UIView!
    @IBOutlet weak var Detils_TB: UITableView!
    @IBOutlet weak var HQ_TB: UITableView!
    @IBOutlet weak var Search_Text: UITextField!
    @IBOutlet weak var Hq_name: UILabel!
    
    struct Datas:Any{
        var Product:String
        var T_qty:String
        var t_val:String
        var S_Qty:String
        var S_Val:String
        var P_Code:String
    }
    
    struct lst_hq:Any{
        var Name:String
        var id:String
    }
    var Hq_Det:[lst_hq] = []
    var Hq_Det2:[lst_hq] = []
    var Target_Data:[Datas] = []
    let cardViewInstance = CardViewdata()
    let LocalStoreage = UserDefaults.standard
    
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    var sfName:String = ""
    var Hq_Id:String = ""
    var lstAllProducts: [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        cardViewInstance.styleSummaryView(HQ_View)
        BTback.addTarget(target: self, action: #selector(GotoHome))
        HQ_View.addTarget(target: self, action: #selector(Vw_open))
       // Vw_Sel.addTarget(target: self, action: #selector(Vw_open))
        
        Detils_TB.delegate = self
        Detils_TB.dataSource = self
        HQ_TB.delegate = self
        HQ_TB.dataSource = self
        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            for i in list{
               let name = i["name"] as? String ?? ""
                let id = i["id"] as? String ?? ""
                if let range = name.range(of: "\\(.*?\\)", options: .regularExpression) {
                    let substring = String(name[range])
                    let droppedString = substring.dropFirst().dropLast()
                    Hq_Det.append(lst_hq(Name:String(droppedString), id:id))
                }else{
                    Hq_Det.append(lst_hq(Name:name, id:id))
                }
            }
            if UserSetup.shared.SF_type == 2{
                Hq_Det.append(lst_hq(Name:sfName, id:SFCode))
                Hq_Id = SFCode
                Hq_name.text = sfName
            }else{
                if Hq_Det.isEmpty{
                    Hq_Det.append(lst_hq(Name:sfName, id:SFCode))
                }
                Hq_Id = Hq_Det[0].id
                Hq_name.text = Hq_Det[0].Name
            }
            Hq_Det=Hq_Det.sorted { $0.Name.lowercased() < $1.Name.lowercased() }
            Hq_Det2 = Hq_Det
        }
        
        let lstProdData: String = LocalStoreage.string(forKey: "Products_Master")!
        if let list = GlobalFunc.convertToDictionary(text: lstProdData) as? [AnyObject] {
            lstAllProducts = list;
            print(lstProdData)
        }
        
        for i in lstAllProducts{
            print(i)
            Target_Data.append(Datas(Product: i["name"] as? String ?? "", T_qty:"0", t_val: "0", S_Qty: "0", S_Val: "0", P_Code: i["id"] as? String ?? ""))
        }
        TargetSales()
    }
    
    func getUserDetails(){
    let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
    let data = Data(prettyPrintedJson!.utf8)
    guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
    print("Error: Cannot convert JSON object to Pretty JSON data")
    return
    }
        print(prettyJsonData)
    sfName = prettyJsonData["sfName"] as? String ?? ""
    SFCode = prettyJsonData["sfCode"] as? String ?? ""
    StateCode = prettyJsonData["State_Code"] as? String ?? ""
    DivCode = prettyJsonData["divisionCode"] as? String ?? ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == Detils_TB{return 70}
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Detils_TB == tableView{
            return Target_Data.count
        }
        return Hq_Det2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if Detils_TB == tableView{
            let I = Target_Data[indexPath.row]
            cell.lblText.text = Target_Data[indexPath.row].Product
            cell.T_qty.text = Target_Data[indexPath.row].T_qty
            cell.t_val.text = Target_Data[indexPath.row].t_val
            cell.S_qty.text = Target_Data[indexPath.row].S_Qty
            cell.S_val.text = Target_Data[indexPath.row].S_Val
            if I.T_qty=="0"&&I.t_val=="0"&&I.S_Qty=="0"&&I.S_Val=="0"{
                
                let attributedText = NSAttributedString(string: cell.lblText?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                let attributedqty = NSAttributedString(string: cell.T_qty?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                let attributedt_val = NSAttributedString(string: cell.t_val?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                let attributedS_Qty = NSAttributedString(string: cell.S_qty?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                let attributedS_val = NSAttributedString(string: cell.S_val?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                cell.lblText?.attributedText = attributedText
                cell.T_qty?.attributedText = attributedqty
                cell.t_val?.attributedText = attributedt_val
                cell.S_qty?.attributedText = attributedS_Qty
                cell.S_val?.attributedText = attributedS_val
                
            }else{
                let attributedText = NSAttributedString(string: cell.lblText?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
                let attributedqty = NSAttributedString(string: cell.T_qty?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
                let attributedt_val = NSAttributedString(string: cell.t_val?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
                let attributedS_Qty = NSAttributedString(string: cell.S_qty?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
                let attributedS_val = NSAttributedString(string: cell.S_val?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
                cell.lblText?.attributedText = attributedText
                cell.T_qty?.attributedText = attributedqty
                cell.t_val?.attributedText = attributedt_val
                cell.S_qty?.attributedText = attributedS_Qty
                cell.S_val?.attributedText = attributedS_val
            }
            
        }else{
            let item=Hq_Det[indexPath.row]
            cell.lblText?.text = item.Name
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView == HQ_TB{
            Target_Data.removeAll()
            let item=Hq_Det2[indexPath.row]
            let name=item.Name
            Hq_name.text = name
            Hq_Id = item.id
            for i in lstAllProducts{
                print(i)
                Target_Data.append(Datas(Product: i["name"] as? String ?? "", T_qty:"0", t_val: "0", S_Qty: "0", S_Val: "0", P_Code: i["id"] as? String ?? ""))
            }
            TargetSales()
        }
        Vw_Sel.isHidden = true
        
    }
    
//    @objc private func hqSelection(){
//        
//        let distributorVC = ItemViewController(items: Hq_Det2, configure: { (Cell : SingleSelectionTableViewCell, distributor) in
//            Cell.textLabel?.text = distributor.Name
//        })
//        
//    }
    
    func TargetSales(){
        self.ShowLoading(Message: "Loading...")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Foundation.Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        let axn = "get/TargetSales"
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(Hq_Id)&rptDt=\(formattedDate)"
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                print(value)
                if let json = value as? [String: Any], let targetSales = json["target_sales"] as? [[String: Any]] {
                    print(targetSales)
                    for j in targetSales{
                        let Product_Code = j["Product_Code"] as? String ?? ""
                        if let index = Target_Data.firstIndex(where: { $0.P_Code == Product_Code }){
                            print("Found at position: \(index)")
                            let tarQty = String(describing: j["tarQty"] as? NSNumber ?? 0)
                            let target = (j["target"] as? NSNumber)?.stringValue ?? (j["target"] as? String) ?? "0"
                            let Quantity = String(describing: j["Quantity"] as? NSNumber ?? 0)
                            let ord_val = String(describing: j["ord_val"] as? NSNumber ?? 0)
                            Target_Data[index].T_qty = tarQty
                            Target_Data[index].t_val = target
                            Target_Data[index].S_Qty = Quantity
                            Target_Data[index].S_Val = ord_val
                        }
                    }
                    Detils_TB.reloadData()
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
    
    @objc func Vw_open(){
        Search_Text.text = ""
        Hq_Det2 = Hq_Det
        HQ_TB.reloadData()
        Vw_Sel.isHidden = false
    }
    
    @IBAction func Vw_Clos(_ sender: Any) {
        Vw_Sel.isHidden = true
    }
    
    @objc private func GotoHome() {
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    @IBAction func searchBytext(_ sender: Any){
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            Hq_Det2 = Hq_Det
        }else{
            Hq_Det2 = Hq_Det.filter({(product) in
                let name: String = product.Name
                    return name.lowercased().contains(txtbx.text!.lowercased())
                })
        }
        HQ_TB.reloadData()
    }
}
