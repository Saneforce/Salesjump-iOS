//
//  DAY REPORT WITH DATE RANGE.swift
//  SAN SALES
//
//  Created by Anbu j on 21/10/24.
//

import UIKit



class DAY_REPORT_WITH_DATE_RANGE: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var BtBack: UIImageView!
    @IBOutlet weak var Hq_View: UIView!
    @IBOutlet weak var Date_View: UIView!
    @IBOutlet weak var Table_View: UITableView!
    
    
    @IBOutlet weak var Total_Call_View: UIView!
    
    let cardViewInstance = CardViewdata()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Hq_View.layer.cornerRadius = 10
        Date_View.layer.cornerRadius = 10
        Table_View.layer.cornerRadius = 10
        Total_Call_View.layer.cornerRadius = 10
        
        Table_View.delegate =  self
        Table_View.dataSource = self
        
        BtBack.addTarget(target: self, action: #selector(GotoHome))
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DAY_REPORT_WITH_DATE_RANGE_CELL = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DAY_REPORT_WITH_DATE_RANGE_CELL
        
        
        return cell
    }
    
    
    @objc private func GotoHome() {
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
