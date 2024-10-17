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
    
    @IBOutlet weak var View_Detils: UIImageView!
    
    var OrderDetils:[AnyObject] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // insideTable1.register(UITableViewCell.self, forCellReuseIdentifier: "InnerCell")
        insideTable1.dataSource = self
        insideTable1.delegate = self
        //Tbale2_height.constant = 150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return OrderDetils.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Inside_TB
        let Item = OrderDetils[indexPath.row]
        print(Item)
        cell.Product_Name.text = Item["Product_Name"] as? String ?? ""
        cell.Rate.text = Item["Rate"] as? String ?? ""
        cell.Qty.text = Item["Qty"] as? String ?? ""
        cell.CL.text = Item["CL"] as? String ?? ""
        cell.Free.text = Item["Disc"] as? String ?? ""
        cell.Tax.text = Item["Tax"] as? String ?? ""
        cell.Value.text = Item["Value"] as? String ?? ""
            return cell
    }

 
    
    func reloadData() {
        print(insideTable1Data)
        let flg = insideTable1Data[0].Routeflg
        if flg == "1"{
            View_height.constant = 68
        }else{
            View_height.constant = 0
        }
        OrderDetils = insideTable1Data[0].Orderlist
        
        print(OrderDetils)
        
        insideTable1.reloadData()
    }
}



class Inside_TB:UITableViewCell{
    @IBOutlet weak var Product_Name: UILabel!
    @IBOutlet weak var Rate: UILabel!
    @IBOutlet weak var Qty: UILabel!
    @IBOutlet weak var CL: UILabel!
    @IBOutlet weak var Free: UILabel!
    @IBOutlet weak var Disc: UILabel!
    @IBOutlet weak var Tax: UILabel!
    @IBOutlet weak var Value: UILabel!
    
}


class Day_Reportdetils:UITableViewCell{
    @IBOutlet weak var Item: UILabel!
    @IBOutlet weak var Uom: UILabel!
    @IBOutlet weak var Qty: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Free: UILabel!
    @IBOutlet weak var Disc: UILabel!
    @IBOutlet weak var Tax: UILabel!
    @IBOutlet weak var Total: UILabel!
    
}



class Item_summary_TB:UITableViewCell{
    @IBOutlet weak var Product_Name: UILabel!
    @IBOutlet weak var Qty: UILabel!
    @IBOutlet weak var Free: UILabel!
}

