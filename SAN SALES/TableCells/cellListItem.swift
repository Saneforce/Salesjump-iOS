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

//stockist_name
//Order_Stk
///*
//
//
//
// [{"Activity_Report_APP":{"Worktype_code":"'1308'","Town_code":"'131948'","RateEditable":"''","dcr_activity_date":"'2023-06-06 00:00:00'","Daywise_Remarks":"","eKey":"EKMR4126-1686049654000","rx":"'1'","rx_t":"''","DataSF":"'MR4126'"}},{"Activity_Doctor_Report":{"Doctor_POB":0,"Worked_With":"''","Doc_Meet_Time":"'2023-06-06 16:37:33'","modified_time":"'2023-06-06 16:37:33'","net_weight_value":"0.00","stockist_code":"'15560'","stockist_name":"'BUTTERFLY APPLIANCES'","superstockistid":"''","Discountpercent":0,"CheckinTime":"2023-06-06 16:37:31","CheckoutTime":"2023-06-06 16:39:13","location":"'13.0299658:80.2414'","geoaddress":"","PhoneOrderTypes":0,"Order_Stk":"'15560'","Order_No":"''","rootTarget":"0","orderValue":340.4,"disPercnt":0.0,"disValue":0.0,"finalNetAmt":340.4,"taxTotalValue":0.4,"discTotalValue":0.0,"subTotal":340.0,"No_Of_items":4,"rateMode":"free","discount_price":0,"doctor_code":"'2284918'","doctor_name":"'salem stores'","doctor_route":"'mylapore'","f_key":{"Activity_Report_Code":"'Activity_Report_APP'"}}},{"Activity_Sample_Report":[{"product_code":"SEF11251","product_Name":"Britannia Milk bikis 150g","Product_Rx_Qty":2,"UnitId":"241","UnitName":"PIECE","rx_Conqty":2,"Product_Rx_NQty":0,"Product_Sample_Qty":"20.40","vanSalesOrder":0,"net_weight":0.0,"free":0,"FreePQty":0,"FreeP_Code":"","Fname":"","discount":0.0,"discount_price":0.0,"tax":2.0,"tax_price":0.4,"Rate":10.0,"Mfg_Date":"","cb_qty":0,"RcpaId":"","Ccb_qty":0,"PromoVal":0,"rx_remarks":"","rx_remarks_Id":"","OrdConv":1,"selectedScheme":0,"selectedOffProCode":"241","selectedOffProName":"PIECE","selectedOffProUnit":"1","f_key":{"Activity_MSL_Code":"Activity_Doctor_Report"}},{"product_code":"SAN361518","product_Name":"BUTTERFLY 1.2LTR RICE COOKER","Product_Rx_Qty":1,"UnitId":"241","UnitName":"PIECE","rx_Conqty":1,"Product_Rx_NQty":0,"Product_Sample_Qty":"40.00","vanSalesOrder":0,"net_weight":0.0,"free":0,"FreePQty":0,"FreeP_Code":"","Fname":"","discount":0.0,"discount_price":0.0,"tax":0.0,"tax_price":0.0,"Rate":40.0,"Mfg_Date":"","cb_qty":0,"RcpaId":"","Ccb_qty":0,"PromoVal":0,"rx_remarks":"","rx_remarks_Id":"","OrdConv":1,"selectedScheme":0,"selectedOffProCode":"241","selectedOffProName":"PIECE","selectedOffProUnit":"1","f_key":{"Activity_MSL_Code":"Activity_Doctor_Report"}},{"product_code":"SAN361520","product_Name":"BUTTERFLY PLUS 1.8LTR RICE COOKER","Product_Rx_Qty":1,"UnitId":"241","UnitName":"PIECE","rx_Conqty":1,"Product_Rx_NQty":0,"Product_Sample_Qty":"200.00","vanSalesOrder":0,"net_weight":0.0,"free":0,"FreePQty":0,"FreeP_Code":"","Fname":"","discount":0.0,"discount_price":0.0,"tax":0.0,"tax_price":0.0,"Rate":200.0,"Mfg_Date":"","cb_qty":0,"RcpaId":"","Ccb_qty":0,"PromoVal":0,"rx_remarks":"","rx_remarks_Id":"","OrdConv":1,"selectedScheme":0,"selectedOffProCode":"241","selectedOffProName":"PIECE","selectedOffProUnit":"1","f_key":{"Activity_MSL_Code":"Activity_Doctor_Report"}},{"product_code":"SAN361510","product_Name":"BUTTERFLY 16INCH TABLE FAN","Product_Rx_Qty":2,"UnitId":"241","UnitName":"PIECE","rx_Conqty":2,"Product_Rx_NQty":0,"Product_Sample_Qty":"80.00","vanSalesOrder":0,"net_weight":0.0,"free":0,"FreePQty":0,"FreeP_Code":"","Fname":"","discount":0.0,"discount_price":0.0,"tax":0.0,"tax_price":0.0,"Rate":40.0,"Mfg_Date":"","cb_qty":0,"RcpaId":"","Ccb_qty":0,"PromoVal":0,"rx_remarks":"","rx_remarks_Id":"","OrdConv":1,"selectedScheme":0,"selectedOffProCode":"241","selectedOffProName":"PIECE","selectedOffProUnit":"1","f_key":{"Activity_MSL_Code":"Activity_Doctor_Report"}}]},{"Trans_Order_Details":[]},{"Activity_Input_Report":[]},{"Activity_Event_Captures":[]},{"PENDING_Bills":[]},{"Compititor_Product":[]},{"Activity_Event_Captures_Call":[]}]
//
//
// My
//  [{\"Activity_Report_APP\":{\"dcr_activity_date\":\"\'2023-06-23 16:41:28\'\",\"rx\":\"\'1\'\",\"rx_t\":\"\'\'\",\"Daywise_Remarks\":\"\'\'\",\"RateEditable\":\"\'\'\",\"Worktype_code\":\"\'1308\'\",\"Town_code\":\"\'114726\'\",\"DataSF\":\"\'MR4126\'\",\"eKey\":\"EKMR4126-1687518689\"}},{\"Activity_Doctor_Report\":{\"modified_time\":\"\'2023-06-23 16:41:28\'\",\"CheckinTime\":\"2023-06-23 16:41:28\",\"rateMode\":\"Nil\",\"visit_name\":\"\'\'\",\"CheckoutTime\":\"2023-06-23 16:41:38\",\"Order_No\":\"\'0\'\",\"Doc_Meet_Time\":\"\'2023-06-23 16:41:28\'\",\"Worked_With\":\"\'\'\",\"discount_price\":\"0\",\"Discountpercent\":\"0\",\"PhoneOrderTypes\":\"0\",\"net_weight_value\":\"0\",\"stockist_name\":\"\'\'\",\"location\":\"\'37.785834:-122.406417\'\",\"stockist_code\":\"\'32469\'\",\"Order_Stk\":\"\'\'\",\"superstockistid\":\"\'\'\",\"geoaddress\":\"1 Stockton St, San Francisco, CA  94108, Vereinigte Staaten\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"},\"doctor_name\":\"\'ABIMANYU STORES\'\",\"visit_id\":\"\'\'\",\"Doctor_POB\":\"0\",\"doctor_code\":\"\'729288\'\"}},{\"Activity_Sample_Report\":[{\"product_code\":\"SEF11251\", \"product_Name\":\"Britannia Milk bikis 150g\", \"Product_Rx_Qty\":1, \"UnitId\": \"241\", \"UnitName\": \"PIECE\", \"rx_Conqty\":1, \"Product_Rx_NQty\": 0, \"Product_Sample_Qty\": \"20.00\", \"net_weight\": , \"free\": 0, \"FreePQty\": 0, \"FreeP_Code\": \"\", \"Fname\": \"\", \"discount\": 0, \"discount_price\": 0, \"tax\": 0, \"tax_price\": 0, \"Rate\": 20.00, \"Mfg_Date\": \"\", \"cb_qty\": 0, \"RcpaId\": \"\", \"Ccb_qty\": 0, \"PromoVal\": 0, \"rx_remarks\": 0, \"rx_remarks_Id\": 0, \"OrdConv\":1, \"selectedScheme\":0, \"selectedOffProCode\": \"\", \"selectedOffProName\":\"PIECE\", \"selectedOffProUnit\": \"1\", \"f_key\": {\"Activity_MSL_Code\": \"Activity_Doctor_Report\"}},{\"product_code\":\"SEF11254\", \"product_Name\":\"Parle-G\", \"Product_Rx_Qty\":1, \"UnitId\": \"241\", \"UnitName\": \"PIECE\", \"rx_Conqty\":1, \"Product_Rx_NQty\": 0, \"Product_Sample_Qty\": \"8.00\", \"net_weight\": , \"free\": 0, \"FreePQty\": 0, \"FreeP_Code\": \"\", \"Fname\": \"\", \"discount\": 0, \"discount_price\": 0, \"tax\": 0, \"tax_price\": 0, \"Rate\": 8.00, \"Mfg_Date\": \"\", \"cb_qty\": 0, \"RcpaId\": \"\", \"Ccb_qty\": 0, \"PromoVal\": 0, \"rx_remarks\": 0, \"rx_remarks_Id\": 0, \"OrdConv\":1, \"selectedScheme\":0, \"selectedOffProCode\": \"\", \"selectedOffProName\":\"PIECE\", \"selectedOffProUnit\": \"1\", \"f_key\": {\"Activity_MSL_Code\": \"Activity_Doctor_Report\"}}]},{\"Trans_Order_Details\":[]},{\"Activity_Event_Captures\":[]},{\"Activity_Input_Report\":[]},{\"Compititor_Product\":[]},{\"PENDING_Bills\":[]}]
//
//
//{"Activity_Doctor_Report":{"Doctor_POB":0,"Worked_With":"''","Doc_Meet_Time":"'2023-06-06 16:37:33'","modified_time":"'2023-06-06 16:37:33'","net_weight_value":"0.00","stockist_code":"'15560'","stockist_name":"'BUTTERFLY APPLIANCES'","superstockistid":"''","Discountpercent":0,"CheckinTime":"2023-06-06 16:37:31","CheckoutTime":"2023-06-06 16:39:13","location":"'13.0299658:80.2414'","geoaddress":"","PhoneOrderTypes":0,"Order_Stk":"'15560'","Order_No":"''","rootTarget":"0","orderValue":340.4,"disPercnt":0.0,"disValue":0.0,"finalNetAmt":340.4,"taxTotalValue":0.4,"discTotalValue":0.0,"subTotal":340.0,"No_Of_items":4,"rateMode":"free","discount_price":0,"doctor_code":"'2284918'","doctor_name":"'salem stores'","doctor_route":"'mylapore'","f_key":{"Activity_Report_Code":"'Activity_Report_APP'"}}}
//
//
//my
//
//
//{\"Activity_Doctor_Report\":{\"modified_time\":\"\'2023-06-23 16:41:28\'\",\"CheckinTime\":\"2023-06-23 16:41:28\",\"rateMode\":\"Nil\",\"visit_name\":\"\'\'\",\"CheckoutTime\":\"2023-06-23 16:41:38\",\"Order_No\":\"\'0\'\",\"Doc_Meet_Time\":\"\'2023-06-23 16:41:28\'\",\"Worked_With\":\"\'\'\",\"discount_price\":\"0\",\"Discountpercent\":\"0\",\"PhoneOrderTypes\":\"0\",\"net_weight_value\":\"0\",\"stockist_name\":\"\'\'\",\"location\":\"\'37.785834:-122.406417\'\",\"stockist_code\":\"\'32469\'\",\"Order_Stk\":\"\'\'\",\"superstockistid\":\"\'\'\",\"geoaddress\":\"1 Stockton St, San Francisco, CA  94108, Vereinigte Staaten\",\"f_key\":{\"Activity_Report_Code\":\"\'Activity_Report_APP\'\"},\"doctor_name\":\"\'ABIMANYU STORES\'\",\"visit_id\":\"\'\'\",\"Doctor_POB\":\"0\",\"doctor_code\":\"\'729288\'\"}}
//*/
