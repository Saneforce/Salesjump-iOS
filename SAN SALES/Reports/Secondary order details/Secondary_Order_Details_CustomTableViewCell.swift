//
//  Secondary_Order_Details_CustomTableViewCell.swift
//  SAN SALES
//
//  Created by Anbu j on 06/12/24.
//

import Foundation
import UIKit

class Secondary_Order_Details_Customcell: UITableViewCell {
    
    
    @IBOutlet weak var Card_View: UIView!
    @IBOutlet weak var Orderid: UILabel!
    @IBOutlet weak var amt: UILabel!
    @IBOutlet weak var Retiler_Nmae: UILabel!
    @IBOutlet weak var Retiler_Address: UILabel!
    
    @IBOutlet weak var dynamicLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        Orderid.numberOfLines = 1
        amt.numberOfLines = 1
        Retiler_Nmae.numberOfLines = 1
        Retiler_Address.numberOfLines = 0 // Allow unlimited lines
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        Orderid.preferredMaxLayoutWidth =  Orderid.frame.width
        amt.preferredMaxLayoutWidth = amt.frame.width
        Retiler_Nmae.preferredMaxLayoutWidth = Retiler_Nmae.frame.width
        Retiler_Address.preferredMaxLayoutWidth = Retiler_Address.frame.width
    }
}
