//
//  Secondary_Order_Details_CustomTableViewCell.swift
//  SAN SALES
//
//  Created by Anbu j on 06/12/24.
//

import Foundation
import UIKit

class Secondary_Order_Details_Customcell: UITableViewCell{
    @IBOutlet weak var Card_View: UIView!
    @IBOutlet weak var Orderid: UILabel!
    @IBOutlet weak var amt: UILabel!
    @IBOutlet weak var Retiler_Nmae: UILabel!
    @IBOutlet weak var Retiler_Address: UILabel!
    
    
    
    // Secondary Order Details
    @IBOutlet weak var Name_and_idlbl: UILabel!
    @IBOutlet weak var Addresslbl: UILabel!
    @IBOutlet weak var Routelbl: UILabel!
    @IBOutlet weak var Supply_fromlbl: UILabel!
    @IBOutlet weak var Phonelbl: UILabel!
    @IBOutlet weak var Volumlbl: UILabel!
    @IBOutlet weak var Product_Details_table: UITableView!
    @IBOutlet weak var Netamtlbl: UILabel!
    @IBOutlet weak var TotalDislbl: UILabel!
    @IBOutlet weak var Finalamtlbl: UILabel!
    @IBOutlet weak var Remarklbl: UILabel!
    
}