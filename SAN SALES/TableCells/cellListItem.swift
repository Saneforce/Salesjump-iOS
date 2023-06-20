//
//  cellListItem.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 12/03/22.
//

import Foundation
import UIKit

class cellListItem:UITableViewCell{
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblUOM: UILabel!
    @IBOutlet weak var lblFreeCap: UILabel!
    @IBOutlet weak var lblFreeProd: UILabel!
    @IBOutlet weak var lblActRate: UILabel!
    @IBOutlet weak var lblremark: UILabel!
    @IBOutlet weak var lblDisc: UILabel!
    @IBOutlet weak var lblSellRate: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblMRP: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblAmt: UILabel!
    @IBOutlet weak var lblFreeQty: UITextField!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var imgSelect2: UIImageView!
    @IBOutlet weak var imgBtnDel: UIImageView!
    @IBOutlet weak var btnPlus: UIView!
    @IBOutlet weak var btnMinus: UIView!
    @IBOutlet weak var btnViewDet: UIButton!
    @IBOutlet weak var ActionTB: UILabel!
    @IBOutlet weak var TC: UILabel!
    @IBOutlet weak var ACC: UILabel!
    @IBOutlet weak var ECC: UILabel!
    @IBOutlet weak var OrderTime: UILabel!
    @IBOutlet weak var MeetTime: UILabel!
    @IBOutlet weak var Rou: UILabel!
    @IBOutlet weak var DistributerName: UILabel!
    @IBOutlet weak var RetailerName: UILabel!
    @IBOutlet weak var BTC: UILabel!
    @IBOutlet weak var OrderValue: UILabel!
    @IBOutlet weak var Product: UILabel!
    @IBOutlet weak var Slno: UILabel!
    @IBOutlet weak var DeleteBUTTON: UIButton!
    @IBOutlet weak var Value: UILabel!
    @IBOutlet weak var Qty: UILabel!
    @IBOutlet weak var ProductValue: UILabel!
    @IBOutlet weak var Disbutor: UILabel!
    @IBOutlet weak var rout: UILabel!
    @IBOutlet weak var ordertime: UILabel!
    @IBOutlet weak var meettime: UILabel!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var ViewButton: UIButton!
    @IBOutlet weak var RouteLb: UILabel!
    @IBOutlet weak var PcCalls: UILabel!
    @IBOutlet weak var TotalCalls: UILabel!
    @IBOutlet weak var AvlaCalls: UILabel!
    @IBOutlet weak var BAC: UILabel!
    @IBOutlet weak var Toalvalue: UILabel!
    @IBOutlet weak var Countlbl: UILabel!
    
    var ischeck = false

}

