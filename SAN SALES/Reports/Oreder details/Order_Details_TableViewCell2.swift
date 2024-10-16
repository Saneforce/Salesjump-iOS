//
//  Order_Details_TableViewCell2.swift
//  SAN SALES
//
//  Created by Anbu j on 16/10/24.
//

import UIKit

class Order_Details_TableViewCell2: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var insideTable2: UITableView!
    var insideTable2Data: [String] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        insideTable2.register(UITableViewCell.self, forCellReuseIdentifier: "InnerCell")
        insideTable2.dataSource = self
        insideTable2.delegate = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insideTable2Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InnerCell", for: indexPath)
        cell.textLabel?.text = insideTable2Data[indexPath.row]
        return cell
    }
    
    func reloadData() {
        print(insideTable2Data)
        insideTable2.reloadData()
    }
}


class Order_Details_TableViewCell3: UITableViewCell{
    
    
}
