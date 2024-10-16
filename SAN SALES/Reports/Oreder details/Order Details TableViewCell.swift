//
//  Order Details TableViewCell.swift
//  SAN SALES
//
//  Created by Anbu j on 15/10/24.
//

import Foundation
import UIKit

class Order_Details_TableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var insideTable1: UITableView!
    var insideTable1Data: [String] = []
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up insideTable1 (the outer table)
        insideTable1.register(UITableViewCell.self, forCellReuseIdentifier: "InnerCell")
        insideTable1.dataSource = self
        insideTable1.delegate = self
        
    }
    
    // DataSource for the outer table (insideTable1)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return insideTable1Data.count
    }

    // Cell creation for both tables
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InnerCell", for: indexPath)
            cell.textLabel?.text = insideTable1Data[indexPath.row]
            return cell
       
    }

    // Delegate method for height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    // Reload Data method for the outer table
    func reloadData() {
        insideTable1.reloadData()
    }
}



