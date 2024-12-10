//
//  Secondary_Order_Details_CustomTableViewCell.swift
//  SAN SALES
//
//  Created by Anbu j on 06/12/24.
//

import Foundation
import UIKit

class Secondary_Order_Details_Customcell: UITableViewCell, UITableViewDataSource, UITableViewDelegate{
    // Secondary Order Details
    @IBOutlet weak var Name_and_idlbl: UILabel!
    @IBOutlet weak var Addresslbl: UILabel!
    @IBOutlet weak var Routelbl: UILabel!
    @IBOutlet weak var Supply_fromlbl: UILabel!
    @IBOutlet weak var Phonelbl: UILabel!
    @IBOutlet weak var Volumlbl: UILabel!
    @IBOutlet weak var Product_Details_table: UITableView!
    
    @IBOutlet weak var Product_Details_table_height: NSLayoutConstraint!

    @IBOutlet weak var Netamtlbl: UILabel!
    @IBOutlet weak var TotalDislbl: UILabel!
    @IBOutlet weak var Finalamtlbl: UILabel!
    @IBOutlet weak var Remarklbl: UILabel!
    
    @IBOutlet weak var Discount_Height: NSLayoutConstraint!
    
    
    var insideTable1Data: [Secondary_order_details_view.Distobutor_OrderDetail] = []
    var OrderDetils: [Secondary_order_details_view.OrderItemModels] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Product_Details_table.dataSource = self
        Product_Details_table.delegate = self
        Product_Details_table.rowHeight = UITableView.automaticDimension
        Product_Details_table.estimatedRowHeight = 150

    }
    override func layoutSubviews(){
        super.layoutSubviews()
        adjustTableViewHeight()
    }
    
   
    func adjustTableViewHeight() {
        Product_Details_table_height.constant = Product_Details_table.contentSize.height
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderDetils.count
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellHeight = cell.frame.height
        print("Cell height at \(indexPath): \(cellHeight)")
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Secondary_Order_Inside_TB
        else {
            return UITableViewCell()
        }
        let item = OrderDetils[indexPath.row]
        cell.Product_Namelbl.text = item.productName
        cell.Ratelbl.text = String(item.rateValue)
        cell.Qtylbl.text = String(item.qtyValue)
        cell.CLlbl.text = String(item.clValue)
        cell.Freelbl.text = String(item.freeValue)
        cell.Disclbl.text = String(item.discValue)
        cell.Taxlbl.text = String(item.taxValue)
        cell.Valuelbl.text = String(item.totalValue)
        return cell
    }
    func reloadData() {
        guard let firstDetail = insideTable1Data.first else { return }
        let orderItem = Secondary_order_details_view.OrderItemModels(
            productName: "Product Name", productId: "",
            rateValue: "Rate",
            qtyValue: "Qty",
            freeValue: "Free",
            discValue: "Disc",
            totalValue: "Value",
            taxValue: "Tax",
            clValue: "CL",
            uomName: "",
            eQtyValue: "",
            liter: "",
            freeProductName: ""
        )
        OrderDetils.append(orderItem)
        OrderDetils.append(contentsOf: firstDetail.Orderitem)
        if OrderDetils.count == 1 {
            OrderDetils.removeAll()
        }
        Product_Details_table.reloadData()
       
        self.layoutSubviews()
        DispatchQueue.main.async {
            self.printVisibleCellHeights(tableView: self.Product_Details_table)
        }
    }
    func printVisibleCellHeights(tableView: UITableView) {
        var height = 0.0
        for (index, cell) in tableView.visibleCells.enumerated() {
            let cellHeight = cell.frame.height
          //  print("Visible cell \(index) height: \(cellHeight)")
            height = height + cellHeight
        }
        DispatchQueue.main.async {
            self.Product_Details_table_height.constant = height
        }
        
    }
}

class Secondary_Order_Inside_TB:UITableViewCell{
    @IBOutlet weak var Product_Namelbl: UILabel!
    @IBOutlet weak var Ratelbl: UILabel!
    @IBOutlet weak var Qtylbl: UILabel!
    @IBOutlet weak var CLlbl: UILabel!
    @IBOutlet weak var Freelbl: UILabel!
    @IBOutlet weak var Disclbl: UILabel!
    @IBOutlet weak var Taxlbl: UILabel!
    @IBOutlet weak var Valuelbl: UILabel!
}
