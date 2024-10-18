//
//  Order Details TableViewCell.swift
//  SAN SALES
//
//  Created by Anbu j on 15/10/24.
//

import Foundation
import UIKit

protocol OrderDetailsCellDelegate: AnyObject {
    func didTapButton(in cell: Order_Details_TableViewCell)
}

class Order_Details_TableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var insideTable1: UITableView!
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
    
    // MARK: - Properties
    weak var delegate: OrderDetailsCellDelegate?
    let data = Order_Details()
    
    var insideTable1Data: [Order_Details.OrderDetail] = []
    var OrderDetils: [Order_Details.OrderItemModel] = []

    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        insideTable1.dataSource = self
        insideTable1.delegate = self

        // Register cell for the inner table view
      //  insideTable1.register(UINib(nibName: "Inside_TB", bundle: nil), forCellReuseIdentifier: "Cell")

        // Setup initial constraints
       // Tbale2_height.constant = 1000
        
        // Use tap gesture recognizer for UIImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        View_Detils.isUserInteractionEnabled = true
        View_Detils.addGestureRecognizer(tapGesture)
    }

    // MARK: - Tap Action Handler
    @objc private func buttonTapped() {
        // Animate tap feedback
        UIView.animate(withDuration: 0.1,
                       animations: {
                           self.View_Detils.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                       },
                       completion: { _ in
                           UIView.animate(withDuration: 0.1) {
                               self.View_Detils.transform = CGAffineTransform.identity
                           }
                       })

        // Notify the delegate
        delegate?.didTapButton(in: self)
    }

    // MARK: - UITableView DataSource & Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderDetils.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Inside_TB else {
            return UITableViewCell()
        }
        
        let item = OrderDetils[indexPath.row]
        cell.Product_Name.text = item.productName
        cell.Rate.text = String(item.rateValue)
        cell.Qty.text = String(item.qtyValue)
        cell.CL.text = String(item.clValue)
        cell.Free.text = String(item.freeValue)
        cell.Disc.text = String(item.discValue)
        cell.Tax.text = String(item.taxValue)
        cell.Value.text = String(item.totalValue)

        return cell
    }

    // MARK: - Reload Data
    func reloadData() {
        OrderDetils.removeAll()

        guard let firstDetail = insideTable1Data.first else { return }

        // Adjust view height based on Route flag
        View_height.constant = (firstDetail.Routeflg == "1") ? 68 : 10

        // Example order item for testing
        let orderItem = Order_Details.OrderItemModel(
            productName: "Product Name", ProductID: "",
            rateValue: "Rate",
            qtyValue: "Qty",
            freeValue: "Free",
            discValue: "Disc",
            totalValue: "Value",
            taxValue: "Tax",
            clValue: "CL",
            uomName: "",
            eQtyValue: "",
            litersVal: "",
            freeProductName: ""
        )
        
        // Add the test item and the actual order list items
        OrderDetils.append(orderItem)
        OrderDetils.append(contentsOf: firstDetail.Orderlist)

        // Reload the inner table view
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

