//
//  SFC Details View.swift
//  SAN SALES
//
//  Created by Anbu j on 30/07/24.
//

import UIKit

class SFC_Details_View: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var viewdetils:Expense_View_SFC.ExpenseDatas?
  
    var ExpenseDetils:[Expense_View_SFC.ExpenseDatas] = []
    
    @IBOutlet weak var Mod_of_trv_TB: UITableView!
    @IBOutlet weak var Exp_status: UILabel!
    @IBOutlet weak var Exp_date: UILabel!
    @IBOutlet weak var Mod_of_trv_hig: NSLayoutConstraint!
    @IBOutlet weak var Scroll_View_hig: NSLayoutConstraint!
    @IBOutlet weak var Status_view: UIView!
    @IBOutlet weak var Travel_Det_View: UIView!
    @IBOutlet weak var Close_Bt_View: UIButton!
    @IBOutlet weak var Amount: UILabel!
    
    @IBOutlet weak var Total_amt: UILabel!
    
    let cardViewInstance = CardViewdata()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardViewInstance.styleSummaryView(Status_view)
        cardViewInstance.styleSummaryView(Travel_Det_View)
        cardViewInstance.styleSummaryView(Close_Bt_View)
        Mod_of_trv_TB.dataSource = self
        Mod_of_trv_TB.delegate = self
        if let data = viewdetils{
            ExpenseDetils.append(data)
               }
        Exp_status.text = "Expense Submitted"
        Exp_date.text = ExpenseDetils[0].date
        Amount.text = ExpenseDetils[0].miscellaneous_exp
        Total_amt.text = ExpenseDetils[0].Total_Amt
        
        print(ExpenseDetils)
        Mod_of_trv_hig.constant = CGFloat(ExpenseDetils[0].SFCdetils.count * 80)
        Scroll_View_hig.constant = CGFloat(ExpenseDetils[0].SFCdetils.count * 80) + 600
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExpenseDetils[0].SFCdetils.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        let getitem = ExpenseDetils[0].SFCdetils
        print(getitem)
        let Fromplace = getitem[indexPath.row]["fromplace"] as? String ?? ""
        let Toplace = getitem[indexPath.row]["Toplace"] as? String ?? ""
        let Mod_of_Travel =  getitem[indexPath.row]["modeoftravel"] as? String ?? ""
        let Km = String(getitem[indexPath.row]["Dist"] as? Int ?? 0)
        let per_km_fare = getitem[indexPath.row]["per_km_fare"] as? String ?? ""
        let fare = getitem[indexPath.row]["fare"] as? String ?? ""
        cell.Fromlbsfc.text = Fromplace
        cell.TolblSFC.text = Toplace
        cell.Mod_of_trv_SFC.text = Mod_of_Travel
        cell.Km_sfc.text = Km
        cell.Fare_sfc.text = per_km_fare
        cell.Amount_sfc.text = fare
        return cell
    }

    @IBAction func Close_View(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ExpenseviewSFC") as! Expense_View_SFC
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}