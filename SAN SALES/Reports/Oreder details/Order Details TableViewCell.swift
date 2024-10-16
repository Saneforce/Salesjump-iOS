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
    
    
    let data = Order_Details()
    var insideTable1Data: [Order_Details.OrderDetail] = []
    
    @IBOutlet weak var View_height: NSLayoutConstraint!
    @IBOutlet weak var Tbale2_height: NSLayoutConstraint!
    
    @IBOutlet weak var Route_name: UILabel!
    @IBOutlet weak var Stockets_Name: UILabel!
    
    @IBOutlet weak var Store_Name_with_order_No: UILabel!
    
    @IBOutlet weak var Addres: UILabel!
    
    @IBOutlet weak var Volumes: UILabel!
    
    @IBOutlet weak var Phone: UILabel!
    
    
    @IBOutlet weak var Netamt: UILabel!
    
    @IBOutlet weak var Remark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        insideTable1.register(UITableViewCell.self, forCellReuseIdentifier: "InnerCell")
        insideTable1.dataSource = self
        insideTable1.delegate = self
        Tbale2_height.constant = 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(insideTable1Data)
            return insideTable1Data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InnerCell", for: indexPath)
        let flg = insideTable1Data[indexPath.row].Routeflg
        if flg == "1"{
            View_height.constant = 68
        }else{
            View_height.constant = 0
        }
            return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func reloadData() {
        insideTable1.reloadData()
    }
}



class Item_summary_TB:UITableViewCell{
    @IBOutlet weak var Product_Name: UILabel!
    @IBOutlet weak var Qty: UILabel!
    @IBOutlet weak var Free: UILabel!
}

