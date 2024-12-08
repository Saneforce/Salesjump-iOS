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
    @IBOutlet weak var lblText2: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblUOM: UILabel!
    @IBOutlet weak var lblFreeCap: UILabel!
    @IBOutlet weak var lblFreeProd: UILabel!
    @IBOutlet weak var lblActRate: UILabel!
    @IBOutlet weak var lblremark: UILabel!
    @IBOutlet weak var Address: UILabel!
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
    
    @IBOutlet weak var Route_Caption: UILabel!
    
    @IBOutlet weak var DistributerName: UILabel!
    @IBOutlet weak var Retailer_caption: UILabel!
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
    @IBOutlet weak var Levtype: UILabel!
    @IBOutlet weak var Leveligibility: UILabel!
    @IBOutlet weak var Levtaken: UILabel!
    @IBOutlet weak var Levavailable: UILabel!
    @IBOutlet weak var retimg: UIImageView!
    @IBOutlet weak var ImgRet: UILabel!
    @IBOutlet weak var Rmks: UILabel!
    @IBOutlet weak var InpuKey: UILabel!
    @IBOutlet weak var inputvalu: UILabel!
    
    @IBOutlet weak var EditBton: UIButton!
    @IBOutlet weak var Viewbt: UIButton!
    @IBOutlet weak var Delet_Pho: UIImageView!
    @IBOutlet weak var Image_View: UIImageView!
    @IBOutlet weak var Enter_Title: UITextField!
    @IBOutlet weak var Enter_Rmk: UITextField!
    @IBOutlet weak var Ent_Amt: UITextField!
    @IBOutlet weak var Card_View: UIView!
    @IBOutlet weak var Cam: UIImageView!
    
    
    // Expense View
    @IBOutlet weak var Exp_Dis_KM: UILabel!
    @IBOutlet weak var Exp_Fare: UILabel!
    @IBOutlet weak var Exp_Date: UILabel!
    @IBOutlet weak var Exp_Mod: UILabel!
    @IBOutlet weak var Exp_Work_Typ: UILabel!
    @IBOutlet weak var Exp_Work_Plc: UILabel!
    @IBOutlet weak var Exp_From: UILabel!
    @IBOutlet weak var Exp_To: UILabel!
    @IBOutlet weak var Exp_Da_Typ: UILabel!
    @IBOutlet weak var Exp_DA_Exp: UILabel!
    @IBOutlet weak var Exp_Amount: UILabel!
    @IBOutlet weak var Exp_DAddi: UILabel!
    @IBOutlet weak var Exp_Hotal: UILabel!
    @IBOutlet weak var Exp_Total: UILabel!
    @IBOutlet weak var Exp_Status: UILabel!
    
    
    // Expense View SFC
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var ViewBT: UIButton!
    
    @IBOutlet weak var Fromlbsfc: UILabel!
    @IBOutlet weak var TolblSFC: UILabel!
    @IBOutlet weak var Mod_of_trv_SFC: UILabel!
    @IBOutlet weak var Km_sfc: UILabel!
    @IBOutlet weak var Fare_sfc: UILabel!
    @IBOutlet weak var Amount_sfc: UILabel!
    
    // Expense Approval
    @IBOutlet weak var Apr_Date: UILabel!
    @IBOutlet weak var Apr_Work_Typ: UILabel!
    @IBOutlet weak var Apr_Plc: UILabel!
    @IBOutlet weak var Apr_Dis: UILabel!
    @IBOutlet weak var Apr_Rem: UILabel!
    @IBOutlet weak var Apr_Tot: UILabel!
    @IBOutlet weak var Apr_Reject: UILabel!
    
    // New Expense Approval
    @IBOutlet weak var Sf_Name: UILabel!
    @IBOutlet weak var Date_Sf: UILabel!
    @IBOutlet weak var new_Exp_Tot: UILabel!
    @IBOutlet weak var New_Exp_View_Bt: UIButton!
    
    // Leave Approve Button
    @IBOutlet weak var Leave_Apr: UIButton!
    
    
    @IBOutlet weak var DATE: UILabel!
    @IBOutlet weak var NA_Name: UILabel!
    @IBOutlet weak var NA_fROM: UILabel!
    @IBOutlet weak var NA_To: UILabel!
    @IBOutlet weak var NA_WORK: UILabel!
    @IBOutlet weak var NA_Work: UILabel!
    @IBOutlet weak var NA_Daily: UILabel!
    @IBOutlet weak var NA_DAdd: UILabel!
    @IBOutlet weak var NA_Hotal_Bill: UILabel!
    @IBOutlet weak var NA_Travel: UILabel!
    @IBOutlet weak var NA_Addit: UILabel!
    @IBOutlet weak var NA_Total: UILabel!
    @IBOutlet weak var NA_Reject_BT: UIButton!
    @IBOutlet weak var NA_Approve_BT: UIButton!
    @IBOutlet weak var NA_Daily_Allowance_Heda: UILabel!
    @IBOutlet weak var NA_Travel_Expense_Head: UILabel!
    
    @IBOutlet weak var Mode_of_trave_in_apr: UILabel!
    
    
    // Closing Stock Entry (DB)
    
    @IBOutlet weak var Case_Entry: UITextField!
    @IBOutlet weak var Piece_Entry: UITextField!
    @IBOutlet weak var DB_Value: UILabel!
    @IBOutlet weak var Batch_No: UITextField!
    @IBOutlet weak var Date_Entry: UITextField!
    
    // Closing Stock Entry (DB)
    
    @IBOutlet weak var Case_Text: UILabel!
    @IBOutlet weak var Piece_Text: UILabel!
    @IBOutlet weak var DB_Value_Text: UILabel!
    @IBOutlet weak var Batch_No_Text: UILabel!
    @IBOutlet weak var Date_Entry_Text: UILabel!
    
    
    // Target vs Sales Analysis
    @IBOutlet weak var T_qty: UILabel!
    @IBOutlet weak var t_val: UILabel!
    @IBOutlet weak var S_qty: UILabel!
    @IBOutlet weak var S_val: UILabel!
    
    
    // Secondary Order details
    
    @IBOutlet weak var Orderid: UILabel!
    @IBOutlet weak var amt: UILabel!
    @IBOutlet weak var Retiler_Nmae: UILabel!
    @IBOutlet weak var Retiler_Address: UILabel!
    
    
    
    var ischeck = false
}
