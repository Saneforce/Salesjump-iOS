//
//  Distributor TableViewCell.swift
//  SAN SALES
//
//  Created by Anbu j on 05/11/24.
//

import Foundation
import UIKit

protocol DistobutorCellDelegate: AnyObject {
    func didTapButton(in cell: Distributor_TableViewCell)
}
class Distributor_TableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
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
    @IBOutlet weak var Start_Image: UIImageView!
    @IBOutlet weak var Total_Disc_Val_lbl: UILabel!
    @IBOutlet weak var Total_Disc: UILabel!
    @IBOutlet weak var Final_Amout: UILabel!
    @IBOutlet weak var Final_amt_height: NSLayoutConstraint!
    @IBOutlet weak var Net_amt_height: NSLayoutConstraint!
    @IBOutlet weak var final_net_amt_view: UIView!
    
    
    
    @IBOutlet weak var Net_Amount_View: UIView!
    
    @IBOutlet weak var Net_Amount_View_Height: NSLayoutConstraint!
    
    
    
    // MARK: - Properties
    weak var delegate: DistobutorCellDelegate?
    let data = Distributor_Order_Details()
    
    var insideTable1Data: [Distributor_Order_Details_cell.Distobutor_OrderDetail] = []
    var OrderDetils: [Distributor_Order_Details_cell.OrderItemModels] = []

    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        insideTable1.dataSource = self
        insideTable1.delegate = self

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
        Tbale2_height.constant = CGFloat(50 * OrderDetils.count)
        return OrderDetils.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Dis_Inside_TB
        else {
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
        guard let firstDetail = insideTable1Data.first else { return }
        View_height.constant =  68
        final_net_amt_view .isHidden =  true
        Final_amt_height.constant =  0
        Net_amt_height.constant =  79
        let orderItem = Distributor_Order_Details_cell.OrderItemModels(
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
        
        // Add the test item and the actual order list items
        OrderDetils.append(orderItem)
        OrderDetils.append(contentsOf: firstDetail.Orderitem)
        if OrderDetils.count == 1 {
            OrderDetils.removeAll()
        }
        
        Net_Amount_View.isHidden =  OrderDetils.isEmpty ? true : false
        Net_Amount_View_Height.constant = OrderDetils.isEmpty ? 0 : 23
        
        // Reload the inner table view
        insideTable1.reloadData()
    }
}



class Dis_Inside_TB:UITableViewCell{
    @IBOutlet weak var Product_Name: UILabel!
    @IBOutlet weak var Rate: UILabel!
    @IBOutlet weak var Qty: UILabel!
    @IBOutlet weak var CL: UILabel!
    @IBOutlet weak var Free: UILabel!
    @IBOutlet weak var Disc: UILabel!
    @IBOutlet weak var Tax: UILabel!
    @IBOutlet weak var Value: UILabel!
    
}

class Dis_Reportdetils:UITableViewCell{
    @IBOutlet weak var Item: UILabel!
    @IBOutlet weak var Uom: UILabel!
    @IBOutlet weak var Qty: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Free: UILabel!
    @IBOutlet weak var Disc: UILabel!
    @IBOutlet weak var Tax: UILabel!
    @IBOutlet weak var Total: UILabel!
    
}

class Dis_Item_summary_TB:UITableViewCell{
    @IBOutlet weak var Product_Name: UILabel!
    @IBOutlet weak var Qty: UILabel!
    @IBOutlet weak var Free: UILabel!
}
