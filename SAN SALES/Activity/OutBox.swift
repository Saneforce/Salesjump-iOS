//
//  OutBox.swift
//  SAN SALES
//
//  Created by Naga Prasath on 20/11/24.
//

import UIKit


class OutBox : IViewController , UITableViewDelegate , UITableViewDataSource{
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var totalCalls : [[String : Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        
        totalCalls = UserDefaults.standard.object(forKey: "SecondaryOrderData") as? [[String : Any]]
        
        if totalCalls == nil {
            Toast.show(message: "Outbox Empty")
        }
        self.tableView.reloadData()
    }
    
    @objc func backVC() {
        GlobalFunc.MovetoMainMenu()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCalls == nil ? 0 : totalCalls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = self.totalCalls[indexPath.row]["name"] as? String ?? ""
        cell.lblText2.text = self.totalCalls[indexPath.row]["distributorName"] as? String ?? ""
        cell.lblValue.text = self.totalCalls[indexPath.row]["route"] as? String ?? ""
        cell.lblremark.text = self.totalCalls[indexPath.row]["date"] as? String ?? ""
        
        return cell
    }
    
    
}
