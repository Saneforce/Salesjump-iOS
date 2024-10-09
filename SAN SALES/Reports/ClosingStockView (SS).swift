//
//  ClosingStockView (SS).swift
//  SAN SALES
//
//  Created by Anbu j on 07/10/24.
//

import UIKit
import Alamofire
import FSCalendar

class ClosingStockView__SS_:  IViewController, FSCalendarDelegate, FSCalendarDataSource,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Date_View: UIView!
    @IBOutlet weak var Detils_TB: UITableView!
    @IBOutlet weak var Hq_View: UIView!
    @IBOutlet weak var Stockist_View: UIView!
    @IBOutlet weak var Stockist_Name: UILabel!
    @IBOutlet weak var Select_HQ: UILabel!
    @IBOutlet weak var Select_Stockist: UILabel!
    @IBOutlet weak var Tit_lbl: UILabel!
    @IBOutlet weak var Update_Date: UILabel!
    @IBOutlet weak var Vw_Sel: UIView!
    @IBOutlet weak var sel_table_view: UITableView!
    @IBOutlet weak var Total_View: UIView!
    @IBOutlet weak var Total_Amt: UILabel!
    @IBOutlet weak var StkCap: UILabel!
    @IBOutlet weak var Calendr_View: UIView!
    @IBOutlet weak var Calender: FSCalendar!
    
    @IBOutlet weak var txSearchSel: UITextField!
    
    let cardViewInstance = CardViewdata()
    var SelMode: String = ""
    var lObjSel: [AnyObject] = []
    var lstHQs: [AnyObject] = []
    let LocalStoreage = UserDefaults.standard
    var lstDis: [AnyObject] = []
    var lstDist: [AnyObject] = []
    var lstAllDis: [AnyObject] = []
    
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    var Scode:String = ""
    var Hq_Id:String = ""
    var Calender_Select_Date:String = ""
    var Total_val:Double = 0.0
    
    struct detils:Any{
        let product_Nm:String
        let sample_qty:String
        let cb_qty:String
        let pieces:String
        let batch_no:String
        let Mgf_date:String
    }
    var Detils_Data:[detils] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        cardViewInstance.styleSummaryView(Date_View)
        cardViewInstance.styleSummaryView(Hq_View)
        cardViewInstance.styleSummaryView(Stockist_View)
        cardViewInstance.styleSummaryView(Total_View)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = Foundation.Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        Date.text = formattedDate
        
        StkCap.text = "Super Stockist"
        Select_Stockist.text = "Select Super Stockist"
        
        BTback.addTarget(target: self, action: #selector(GotoHome))
        Select_HQ.addTarget(target: self, action: #selector(Vw_open))
        Select_Stockist.addTarget(target: self, action: #selector(Vw_open_rou))
        Date_View.addTarget(target: self, action: #selector(Calender_Open))
        Calender.placeholderType = .none
        
        sel_table_view.delegate = self
        sel_table_view.dataSource = self
        Detils_TB.delegate = self
        Detils_TB.dataSource = self
        Calender.delegate=self
        Calender.dataSource=self
        Total_Amt.text = String(Total_val)
        let DateFormatter = DateFormatter()
        DateFormatter.dateFormat = "yyyy-MM-dd"
        let CurrentDate = Foundation.Date()
        let FormattedDate = DateFormatter.string(from: CurrentDate)
        Calender_Select_Date = FormattedDate
        // Local Data
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list;
            if UserSetup.shared.SF_type == 1 && !lstHQs.isEmpty{
                self.Select_HQ.text = lstHQs[0]["name"] as? String ?? ""
                Hq_Id = lstHQs[0]["id"] as? String ?? SFCode
                
                self.ShowLoading(Message: "       Sync Data Please wait...")
                GlobalFunc.FieldMasterSync(SFCode: Hq_Id){ [self] in
                        if let DistData = LocalStoreage.string(forKey: "Supplier_Master_" + SFCode) {
                            if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                                lstAllDis = list
                                lstDis = list
                            }
                        }
                    self.LoadingDismiss()
                }
            }
        }
        
        if let DistData = LocalStoreage.string(forKey: "Supplier_Master_"+SFCode),
           let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
            lstDist = list;
        }
    }
    
    func getUserDetails(){
    let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
    let data = Data(prettyPrintedJson!.utf8)
    guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
    print("Error: Cannot convert JSON object to Pretty JSON data")
    return
    }
    SFCode = prettyJsonData["sfCode"] as? String ?? ""
    StateCode = prettyJsonData["State_Code"] as? String ?? ""
    DivCode = prettyJsonData["divisionCode"] as? String ?? ""
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let selectdate = DateFormatter()
        selectdate.dateFormat = "yyyy-MM-dd"
        let dates = selectdate.string(from: date)
        print(dates)
        
        if Calender_Select_Date == dates {
            Calendr_View.isHidden = true
            return
        }
        Calender_Select_Date = dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = date
        let formattedDate = dateFormatter.string(from: currentDate)
        Date.text = formattedDate
        View_Data()
        Calendr_View.isHidden = true
    }
    
    public func maximumDate(for calendar: FSCalendar) -> Date {
        return Foundation.Date()
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == sel_table_view{return 50}

        if UserSetup.shared.hideClosingStockBatch == 1 &&  UserSetup.shared.hideClosingStockMfg == 1 {
            return 80
        }else{
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sel_table_view{return lObjSel.count}
        return Detils_Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if tableView == sel_table_view{
            let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
            cell.lblText?.text = item["name"] as? String
            
        }else if tableView == Detils_TB{
            cell.lblText.text = Detils_Data[indexPath.row].product_Nm
            cell.Case_Text.text =  Detils_Data[indexPath.row].cb_qty
            cell.Piece_Text.text = Detils_Data[indexPath.row].pieces
            cell.DB_Value_Text.text = Detils_Data[indexPath.row].sample_qty
            cell.Batch_No_Text.text = Detils_Data[indexPath.row].batch_no
            cell.Date_Entry_Text.text = Detils_Data[indexPath.row].Mgf_date
            
            if UserSetup.shared.hideClosingStockBatch == 1{
                cell.Batch_No_Text.isHidden = true
            }
            if UserSetup.shared.hideClosingStockMfg == 1 {
                cell.Date_Entry_Text.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView == sel_table_view{
            let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
            print(item)
            var name=item["name"] as! String
            
            if SelMode == "HQ"{
               let Hq_Select_ID = item["id"] as? String ?? SFCode
                
                if Hq_Id == Hq_Select_ID{
                    Vw_Sel.isHidden = true
                    return
                }
                Select_Stockist.text = "Select Super Stockist"
                Scode = ""
                Hq_Id = Hq_Select_ID
                Select_HQ.text = name
                Total_Amt.text = "0.00"
                Detils_Data.removeAll()
                Detils_TB.reloadData()
                Update_Date.text = "Last Updation :"
                self.ShowLoading(Message: "       Sync Data Please wait...")
                GlobalFunc.FieldMasterSync(SFCode: Hq_Select_ID){ [self] in
                        if let DistData = LocalStoreage.string(forKey: "Supplier_Master_" + SFCode) {
                            if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                                lstAllDis = list
                                lstDis = list
                                print(lstAllDis)
                            }
                        }
                    self.LoadingDismiss()
                }
                
            }else if SelMode == "DIS"{
                Select_Stockist.text = name
                Stockist_Name.text = name
                Scode = item["id"] as? String ?? ""
                View_Data()
            }
        }
        Vw_Sel.isHidden = true
    }
    
    func View_Data(){
        
        if  Hq_Id == "" {
            Toast.show(message: "Select the Headquarter", controller: self)
            return
        }
        if  Scode == "" {
            Toast.show(message: "Select the Stockist", controller: self)
            return
        }
        
        self.ShowLoading(Message: "Loading...")
        Total_val = 0.0
        Detils_Data.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Foundation.Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        print(formattedDate)
        let axn = "get/StockDetailsSS"
        let apiKey: String = "\(axn)&State_Code=\(StateCode)&divisionCode=\(DivCode)&scode=\(Scode)&rSF=\(SFCode)&cldt=\(Calender_Select_Date)&sfCode=\(Hq_Id)&stateCode=\(StateCode)"
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                print(value)
                if let json = value as? [AnyObject]{
                    print(json)
                    
                    var Updatedate = ""
                    
                    if !json.isEmpty{
                        if let updateDate = json[0]["updateDate"] as? [String:Any]{
                            
                            if let date = updateDate["date"] as? String{
                                
                                let dateString = date
                                let inputFormatter = DateFormatter()
                                inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                if let date = inputFormatter.date(from: dateString) {
                                    let outputFormatter = DateFormatter()
                                    outputFormatter.dateFormat = "yyyy-MM-dd"
                                    let formattedDateString = outputFormatter.string(from: date)
                                    Update_Date.text = "Last Updation : \(formattedDateString)"
                                    Updatedate = formattedDateString
                                } else {
                                    print("Invalid date format")
                                }
                            }
                        }
                    }else{
                        Update_Date.text = "Last Updation :"
                    }
                    if Calender_Select_Date == Updatedate{
                        
                        
    
                        for i in json{
                            let product_Nm = i["product_Nm"] as? String ?? ""
                            let cb_qty = i["cb_qty"] as? Int ?? 0
                            let pieces = i["pieces"] as? Int ?? 0
                            let sample_qty = i["sample_qty"] as? Double ?? 0.0
                            let batch_no = i["batch_no"] as? String ?? ""
                            let Mgf_date = i["Mgf_date"] as? String ?? ""
                            
                            Total_val = Total_val + sample_qty
                            
                            Detils_Data.append(detils(product_Nm:product_Nm , sample_qty:"Value: \(sample_qty)", cb_qty: "Case: \(cb_qty)", pieces: "Piece: \(pieces)", batch_no: "Batch: \(batch_no)", Mgf_date: "Mgf: \(Mgf_date)"))
                        }
                        
                        Total_Amt.text = String(Total_val)
                        Detils_TB.reloadData()
                    }else{
                        Total_Amt.text = "0.00"
                        Detils_Data.removeAll()
                        Detils_TB.reloadData()
                    }
                    
                } else {
                    print("Invalid response format")
                    Total_Amt.text = "0.00"
                    Update_Date.text = "Last Updation :"
                    Detils_Data.removeAll()
                    Detils_TB.reloadData()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.LoadingDismiss()
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.LoadingDismiss()
                }
            }
        }
        
    }
    @objc func Vw_open(){
        SelMode = "HQ"
        self.Tit_lbl.text = "Select the Headquarter"
        lObjSel = lstHQs
        self.txSearchSel.text = ""
        sel_table_view.reloadData()
        Vw_Sel.isHidden = false
    }
    @objc func Vw_open_rou(){
        if  Hq_Id == "" {
            Toast.show(message: "Select the Headquarter", controller: self)
            return
        }
        self.Tit_lbl.text = "Select the Super Stockist"
        SelMode = "DIS"
        lObjSel = lstDis
        self.txSearchSel.text = ""
        sel_table_view.reloadData()
        Vw_Sel.isHidden = false
    }

    
    @IBAction func Vw_Clos(_ sender: Any) {
        Vw_Sel.isHidden = true
    }
    
    @objc func Calender_Open(){
        Calendr_View.isHidden = false
    }
    
    @IBAction func Calender_View_Close(_ sender: Any) {
        Calendr_View.isHidden = true
        
    }
    
    
    @objc private func GotoHome() {
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func searchBytext(_ sender: Any){
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            if SelMode == "HQ"{
                lObjSel = lstHQs
            }else if SelMode == "DIS"{
                lObjSel = lstDis
            }
        }else{
            if SelMode == "HQ"{
                lObjSel = lstHQs.filter({(product) in
                    let name: String = String(format: "%@", product["name"] as! CVarArg)
                    return name.lowercased().contains(txtbx.text!.lowercased())
                })
            } else if SelMode == "DIS"{
                lObjSel = lstDis.filter({(product) in
                    let name: String = String(format: "%@", product["name"] as! CVarArg)
                    return name.lowercased().contains(txtbx.text!.lowercased())
                })
            }
        }
        sel_table_view.reloadData()
    }
}
