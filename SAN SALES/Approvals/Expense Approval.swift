//
//  Expense Approval.swift
//  SAN SALES
//
//  Created by San eforce on 26/04/24.
//

import UIKit

class Expense_Approval: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIImageView!
    
    // UI View
    @IBOutlet weak var Headquarters_View: UIView!
    @IBOutlet weak var Month_year_View: UIView!
    @IBOutlet weak var Approvel_vIEW: UIView!
    // Select Label
    @IBOutlet weak var App_All: UILabel!
    @IBOutlet weak var Rej_All: UILabel!
    
    //TableView
    @IBOutlet weak var App_Data: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Headquarters_View.layer.cornerRadius = 10
        Headquarters_View.layer.shadowColor = UIColor.black.cgColor
        Headquarters_View.layer.shadowOpacity = 0.5
        Headquarters_View.layer.shadowOffset = CGSize(width: 0, height: 2)
        Headquarters_View.layer.shadowRadius = 4
        
        Month_year_View.layer.cornerRadius = 10
        Month_year_View.layer.shadowColor = UIColor.black.cgColor
        Month_year_View.layer.shadowOpacity = 0.5
        Month_year_View.layer.shadowOffset = CGSize(width: 0, height: 2)
        Month_year_View.layer.shadowRadius = 4
        
        Approvel_vIEW.addShadowAndCornerRadius(cornerRadius: 10, shadowColor: UIColor.black, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 4)
        App_All.layer.cornerRadius = 10
        App_All.layer.masksToBounds = true
        Rej_All.layer.cornerRadius = 10
        Rej_All.layer.masksToBounds = true
        
        
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        
        App_Data.delegate = self
        App_Data.dataSource = self
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if App_Data == tableView {return 320}
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (App_Data == tableView){
            return 5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if (App_Data == tableView){
            cell.Card_View.layer.cornerRadius = 10
            cell.Card_View.layer.shadowColor = UIColor.black.cgColor
            cell.Card_View.layer.shadowOpacity = 0.5
            cell.Card_View.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.Card_View.layer.shadowRadius = 4
            
            cell.Apr_Tot.layer.cornerRadius = 10
            cell.Apr_Tot.layer.masksToBounds = true
            
            cell.Apr_Reject.layer.cornerRadius = 10
            cell.Apr_Reject.layer.masksToBounds = true
            
        }
        return cell
    }
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }
}


extension UIView {
    func addShadowAndCornerRadius(cornerRadius: CGFloat, shadowColor: UIColor, shadowOpacity: Float, shadowOffset: CGSize, shadowRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
}
