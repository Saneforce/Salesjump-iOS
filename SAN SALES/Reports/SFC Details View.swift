//
//  SFC Details View.swift
//  SAN SALES
//
//  Created by Anbu j on 30/07/24.
//

import UIKit

class SFC_Details_View: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var viewdetils:Expense_View_SFC.ExpenseDatas?
    var viewdetils_approv:Expense_approval_SFC.ExpenseDatas?
    var ExpenseDetils:[Expense_View_SFC.ExpenseDatas] = []
    var ExpenseDetils2:[Expense_approval_SFC.ExpenseDatas] = []
    var Naveapprovel_scr:Int?
    @IBOutlet weak var Mod_of_trv_TB: UITableView!
    @IBOutlet weak var Exp_status: UILabel!
    @IBOutlet weak var Exp_date: UILabel!
    @IBOutlet weak var Mod_of_trv_hig: NSLayoutConstraint!
    @IBOutlet weak var Scroll_View_hig: NSLayoutConstraint!
    @IBOutlet weak var Status_view: UIView!
    @IBOutlet weak var Travel_Det_View: UIView!
    @IBOutlet weak var Close_Bt_View: UIButton!
    @IBOutlet weak var Amount: UILabel!
    
    @IBOutlet weak var Return_km: UILabel!
    @IBOutlet weak var Place_Typ: UILabel!
    
    
    @IBOutlet weak var Total_Dis_KM: UILabel!
    @IBOutlet weak var Total_Fare: UILabel!
    @IBOutlet weak var Total_amt: UILabel!
    @IBOutlet weak var Wor_typ: UILabel!
    @IBOutlet weak var Mod_Of_Trvel: UILabel!
    
    
    let cardViewInstance = CardViewdata()
    var lstWType: [AnyObject] = []
    let LocalStoreage = UserDefaults.standard
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    var lstAllRoutes: [AnyObject] = []
    var lstHQs: [AnyObject] = []
    var Sf_Typ:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        cardViewInstance.styleSummaryView(Status_view)
        cardViewInstance.styleSummaryView(Travel_Det_View)
        cardViewInstance.styleSummaryView(Close_Bt_View)
        Mod_of_trv_TB.dataSource = self
        Mod_of_trv_TB.delegate = self
        
        if let data = viewdetils{
            ExpenseDetils.append(data)
               }
        
        if let data = viewdetils_approv{
            ExpenseDetils2.append(data)
               }
        
        
        if let WorkTypeData = LocalStoreage.string(forKey: "Worktype_Master"),
           let list = GlobalFunc.convertToDictionary(text:  WorkTypeData) as? [AnyObject] {
            lstWType = list
        }
        
        
        if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+SFCode),
           let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
            lstAllRoutes = list
        }

        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list;
        }
        
        
        print(viewdetils)
        print(viewdetils_approv)

        if ExpenseDetils.count == 0{
            var Work_Typ = ""
            var Total_Km = 0
            var Total_Far = 0.0
            for i in ExpenseDetils2[0].SFCdetils{
                print(i)
                if let Dis = i["Dist"] as? Int{
                    Total_Km = Total_Km + Dis
                }
            }
            let Fare = Double(ExpenseDetils2[0].Fuel_amount) ?? 0.0
            let ReturnKM = Int(ExpenseDetils2[0].Returnkm) ?? 0
            Total_Km = Total_Km + ReturnKM
            Total_Far = Double(Total_Km) * Fare
            let Get_work_typ = ExpenseDetils2[0].Work_typ
            let Filter_work = lstWType.filter{$0["FWFlg"] as? String == Get_work_typ}
            print(Filter_work)
            if Filter_work.isEmpty{
                Wor_typ.text = ""
            }else{
                Wor_typ.text = Filter_work[0]["name"] as? String ?? ""
            }
            Total_Dis_KM.text = String(Total_Km)
            Total_Fare.text = String(Total_Far)
            Exp_status.text = ExpenseDetils2[0].status
            Exp_date.text = ExpenseDetils2[0].date
            Mod_Of_Trvel.text = ExpenseDetils2[0].Mot_Name
            Amount.text = ExpenseDetils2[0].miscellaneous_exp
            Total_amt.text = ExpenseDetils2[0].Total_Amt
            Mod_of_trv_hig.constant = CGFloat(ExpenseDetils2[0].SFCdetils.count * 80)
            Scroll_View_hig.constant = CGFloat(ExpenseDetils2[0].SFCdetils.count * 80) + 600
        }else{
            var Work_Typ = ""
            var Total_Km = 0
            var Total_Far = 0.0
            for i in ExpenseDetils[0].SFCdetils{
                print(i)
                if let Dis = i["Dist"] as? Int{
                    Total_Km = Total_Km + Dis
                }
            }
            let Fare = Double(ExpenseDetils[0].Fuel_amount) ?? 0.0
            let ReturnKM = Int(ExpenseDetils[0].Returnkm) ?? 0
            Total_Km = Total_Km + ReturnKM
            Total_Far = Double(Total_Km) * Fare
            let Get_work_typ = ExpenseDetils[0].Work_typ
            let Filter_work = lstWType.filter{$0["FWFlg"] as? String == Get_work_typ}
            print(Filter_work)
            if Filter_work.isEmpty{
                Wor_typ.text = ""
            }else{
                Wor_typ.text = Filter_work[0]["name"] as? String ?? ""
            }
            
            Return_km.text = ExpenseDetils[0].Returnkm
            Place_Typ.text = ExpenseDetils[0].Plc_typ
            Mod_Of_Trvel.text = ExpenseDetils[0].Mot_Name
            Total_Dis_KM.text = String(Total_Km)
            Total_Fare.text = String(Total_Far)
            Exp_status.text = ExpenseDetils[0].status
            Exp_date.text = ExpenseDetils[0].date
            Amount.text = ExpenseDetils[0].miscellaneous_exp
            Total_amt.text = ExpenseDetils[0].Total_Amt
            Mod_of_trv_hig.constant = CGFloat(ExpenseDetils[0].SFCdetils.count * 80)
            Scroll_View_hig.constant = CGFloat(ExpenseDetils[0].SFCdetils.count * 80) + 600
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Mod_of_trv_TB == tableView{
            if ExpenseDetils.count == 0{
                return ExpenseDetils2[0].SFCdetils.count
            }else{
                return ExpenseDetils[0].SFCdetils.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if ExpenseDetils.count == 0{
            let getitem = ExpenseDetils2[0].SFCdetils
            print(getitem)
            var Fromplace =  getitem[indexPath.row]["Cls_From"] as? String ?? ""
            var Toplace = getitem[indexPath.row]["Cls_To"] as? String ?? ""
            let Mod_of_Travel =  getitem[indexPath.row]["modeoftravel"] as? String ?? ""
            let Km = String(getitem[indexPath.row]["Dist"] as? Int ?? 0)
            let per_km_fare = getitem[indexPath.row]["per_km_fare"] as? String ?? ""
            let fare = getitem[indexPath.row]["fare"] as? String ?? ""
            
            cell.Fromlbsfc.text = Fromplace
            cell.TolblSFC.text = Toplace
            cell.Km_sfc.text = Km
            cell.Fare_sfc.text = per_km_fare
            cell.Amount_sfc.text = fare
        }else{
            let getitem = ExpenseDetils[0].SFCdetils
            print(getitem)
            var Fromplace = getitem[indexPath.row]["fromplace"] as? String ?? ""
            var Toplace = getitem[indexPath.row]["Toplace"] as? String ?? ""
            let Mod_of_Travel =  getitem[indexPath.row]["modeoftravel"] as? String ?? ""
            let Km = String(getitem[indexPath.row]["Dist"] as? Int ?? 0)
            let per_km_fare = getitem[indexPath.row]["per_km_fare"] as? String ?? ""
            let fare = getitem[indexPath.row]["fare"] as? String ?? ""
            
            let From_FilterRoute = lstAllRoutes.filter{$0["id"] as? String == Fromplace}
            print(From_FilterRoute)
            if From_FilterRoute.isEmpty{
                Fromplace = lstHQs[0]["name"] as? String ?? SFCode
                
            }else{
                Fromplace = From_FilterRoute[0]["name"] as? String ?? ""
            }
            
            let To_FilterRoute = lstAllRoutes.filter{$0["id"] as? String == Toplace}
            
            if To_FilterRoute.isEmpty{
                Toplace = getitem[indexPath.row]["Toplace"] as? String ?? ""
            }else{
                Toplace = To_FilterRoute[0]["name"] as? String ?? ""
            }
            
            if Sf_Typ == 2{
                var Cls_Fromplace = getitem[indexPath.row]["Cls_From"] as? String ?? ""
                var Cls_Toplace = getitem[indexPath.row]["Cls_To"] as? String ?? ""
                cell.Fromlbsfc.text = Cls_Fromplace
                cell.TolblSFC.text = Cls_Toplace
            }else{
                cell.Fromlbsfc.text = Fromplace
                cell.TolblSFC.text = Toplace
            }

            cell.Km_sfc.text = Km
            cell.Fare_sfc.text = per_km_fare
            cell.Amount_sfc.text = fare
        }
        return cell
    }

    @IBAction func Close_View(_ sender: Any) {
        
        if let Nave_code = Naveapprovel_scr, Nave_code == 1{
            let storyboard = UIStoryboard(name: "Approval", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ExpenseapprovalSFC") as! Expense_approval_SFC
            UIApplication.shared.windows.first?.rootViewController = viewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }else{
            let storyboard = UIStoryboard(name: "Reports", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ExpenseviewSFC") as! Expense_View_SFC
            UIApplication.shared.windows.first?.rootViewController = viewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
}
