//
//  Brand Availability.swift
//  SAN SALES
//
//  Created by San eforce on 12/05/23.
//

import UIKit
import Alamofire
import FSCalendar


class Brand_Availability: IViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate {
  
    @IBOutlet weak var BrandAV: UITableView!
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var Titview: UIView!
    @IBOutlet weak var veselwindow: UIView!
    @IBOutlet weak var HeadquarterTable: UITableView!
    @IBOutlet weak var vwHQCtrl: UIView!
    @IBOutlet weak var lblRptDt: UILabel!
    @IBOutlet weak var lblSelTitle: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var lblHQ: LabelSelect!
    @IBOutlet weak var ImageSc: UIView!
    @IBOutlet weak var ImgViewtb: UITableView!
    @IBOutlet weak var Retimg: UIImageView!
    @IBOutlet weak var BackBT: UIImageView!
    @IBOutlet weak var Ret_and_img_Hed: UIView!
    @IBOutlet weak var CallesTbHig: NSLayoutConstraint!
    @IBOutlet weak var imgtbhig: NSLayoutConstraint!
    @IBOutlet weak var Scroolviehig: NSLayoutConstraint!
    @IBOutlet weak var TCLbl: UILabel!
    
    let axn="get/brandavail"
    
    struct lItem: Any {
        let id: String
        let name: String
        let FWFlg: String
    }
    struct BrandAvil: Any {
        let BrandName: String
        let TC: Int
        let AC: Int
        let EC: Int
    }
    
    struct imgcp: Any {
        let Ret: String
        let Img: UIImage
        let Rmks: String
    }
    var imagevw: [imgcp] = []
    var myDyTp: [String: lItem] = [:]
    var BrandList : [BrandAvil] = []
    var SelMode: String = ""
    var lAllObjSel: [AnyObject] = []
    var lObjSel: [AnyObject] = []
    var lstDist: [AnyObject] = []
    var lstAllRoutes: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    var lstWType: [AnyObject] = []
    var lstHQs: [AnyObject] = []
    var lstJoint: [AnyObject] = []
    var lstJWNms: [AnyObject] = []
    var event: [AnyObject] = []
    var strJWCd: String = ""
    var strJWNm: String = ""
    var strSelJWCd: String = ""
    var strSelJWNm: String = ""
    var isMulti: Bool = false
    var isDate: Bool = false
    let LocalStoreage = UserDefaults.standard
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",StrRptDt: String="",StrMode: String=""
    var objcalls: [AnyObject]=[]
    var urlImages: URL?
    var data : [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TCLbl.isHidden = true
        getUserDetails()
        Brandavailability()
        
        
        BrandAV.delegate=self
        BrandAV.dataSource=self
        ImgViewtb.delegate=self
        ImgViewtb.dataSource=self
//        HeadquarterTable.delegate=self
//        HeadquarterTable.dataSource=self
        
        calendar.dataSource=self
        calendar.delegate=self
    
        BTback.addTarget(target: self, action: #selector(GotoHome))
        BackBT.addTarget(target: self, action: #selector(closebt))
        lblRptDt.addTarget(target: self, action: #selector(selDORpt))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = Date()
        lblRptDt.text = formatter.string(from: date)
        formatter.dateFormat = "yyyy-MM-dd"
        StrRptDt = formatter.string(from: date)
        
        Titview.layer.cornerRadius=10.0
        
     
        
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        let SFName: String=prettyJsonData["sfName"] as? String ?? ""
        
        let HQData: String=LocalStoreage.string(forKey: "HQ_Master")!
        
        if let list = GlobalFunc.convertToDictionary(text: HQData) as? [AnyObject] {
            lstHQs = list;
            var id: String = SFCode
            var name: String = SFName
            if lstHQs.count > 0 {
                let item: [String: Any]=lstHQs[0] as! [String : Any]
                name = item["name"] as! String
                id=String(format: "%@", item["id"] as! CVarArg)
            }
            if(lstHQs.count < 2){
                lblHQ.text = name
                let DistData: String=LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+id)!
                if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                    lstDist = list;
                }
                if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                    lstAllRoutes = list
                    lstRoutes = list
                }
            }
            else
            {
                //lblHQ.addTarget(target: self, action: #selector(selHeadquaters))
            }
        }
        // Do any additional setup after loading the view.
        Ret_and_img_Hed.isHidden = true
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        print("did select date \(formatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({formatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        lblRptDt.text = selectedDates[0]
        formatter.dateFormat = "yyyy-MM-dd"
        StrRptDt = formatter.string(from: date)
        BrandList.removeAll()
        imagevw.removeAll()
        Brandavailability()
        
        closeWin(self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if BrandAV == tableView { return 55}
        if ImgViewtb==tableView {
            return 100
        }
        return 42
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==BrandAV { return BrandList.count }
        if tableView==HeadquarterTable {return lObjSel.count}
        if tableView==ImgViewtb{return imagevw.count}
      
       
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
            if BrandAV == tableView{
//                let item: [String: Any] = objcalls[indexPath.row] as! [String : Any]
//                let value = item["value"] as! [[String : Any]]
//
//                if !value.isEmpty {
//                    cell.lblText?.text = value[0]["BName"] as? String
//                    cell.TC?.text = String( value[0]["tc"] as! Int)
//
//                    cell.ACC?.text =  String( value[0]["Avail"] as! Int)
//                    cell.ECC?.text = String(value[0]["EC"] as! Int)
//                }

                
                //New
                print(BrandList)
                print(ImgViewtb)
                cell.lblText?.text = BrandList[indexPath.row].BrandName
                cell.TC?.text = String(BrandList[indexPath.row].TC)
                cell.ACC?.text = String(BrandList[indexPath.row].AC)
                cell.ECC?.text = String(BrandList[indexPath.row].EC)
                cell.TC.isHidden = true
               
            }else if tableView == ImgViewtb {
                cell.ImgRet.text = imagevw[indexPath.row].Ret
                cell.retimg.image = imagevw[indexPath.row].Img
                cell.Rmks.text = imagevw[indexPath.row].Rmks
                //cell.imgBtnDel.addTarget(target: self, action: #selector(self.delJWK(_:)))
                //cell.retimg.addTarget(target: self, action:#selector(imgwind))
            }
        
        else{
                let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
                cell.lblText?.text = item["name"] as? String
            }
            
            return cell
            
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if tableView == ImgViewtb {
             print("You selected cell #\(indexPath.row)!")
             let product = event[indexPath.row]["imgurl"] as! String
             if product != "" {
                 print(product)
                 let apiKey: String = "\(SFCode)_\(product)"
                 let url = URL(string:APIClient.shared.imgurl+apiKey)
                 print(url as Any)
                 ImageSc.isHidden = false
                 let imageData = try? Data(contentsOf: url!)
                 let image = UIImage(data: imageData!)
                 self.Retimg.image = image
             }else{
                 ImageSc.isHidden = false
                 self.Retimg.image = UIImage(named:"no-image-available")!
             }
             
         }
     }

    func setTodayPlan(){
        var lstPlnDetail: [AnyObject] = []
        if self.LocalStoreage.string(forKey: "Mydayplan") == nil { return }
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        if(lstPlnDetail.count < 1){ return }
        let wtid=String(format: "%@", lstPlnDetail[0]["worktype"] as! CVarArg)
        if let indexToDelete = lstWType.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == wtid }) {

            let typ: String = lstWType[indexToDelete]["FWFlg"] as! String
            let id=String(format: "%@", lstWType[indexToDelete]["id"] as! CVarArg)
            let name: String = lstWType[indexToDelete]["name"] as! String
            
            vwHQCtrl.isHidden=false

            if typ != "F" {
                vwHQCtrl.isHidden=true
               
            }else{
                
                let sfid=String(format: "%@", lstPlnDetail[0]["subordinateid"] as! CVarArg)
                if let indexToDelete = lstHQs.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == sfid }) {
                    lblHQ.text = lstHQs[indexToDelete]["name"] as? String
                    let sfname: String = lstHQs[indexToDelete]["name"] as! String
                    //new
                    if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+sfid),
                       let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
                        lstDist = list
                    }
                    if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+sfid),
                       let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
                        lstAllRoutes = list
                        lstRoutes = list
                    }
                    
                    
                    myDyTp.updateValue(lItem(id: sfid, name: sfname,FWFlg: ""), forKey: "HQ")
                }
                let stkid=String(format: "%@", lstPlnDetail[0]["stockistid"] as! CVarArg)
                let rtid=String(format: "%@", lstPlnDetail[0]["clusterid"] as! CVarArg)
                if let indexToDelete = lstRoutes.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == rtid }) {
                    let rtname: String = lstRoutes[indexToDelete]["name"] as! String
                    
                    myDyTp.updateValue(lItem(id: rtid, name: rtname,FWFlg: ""), forKey: "RUT")
                }
                let jwids=(String(format: "%@", lstPlnDetail[0]["worked_with_code"] as! CVarArg)).replacingOccurrences(of: ",", with: ";")
                    .components(separatedBy: ";")
                for k in 0...jwids.count-1 {
                    if let indexToDelete = lstJoint.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == jwids[k] }) {
                        let jwid: String = lstJoint[indexToDelete]["id"] as! String
                        let jwname: String = lstJoint[indexToDelete]["name"] as! String
                        
                        strJWCd += jwid+";"
                        strJWNm += jwname+";"
                        let jitm: AnyObject = lstJoint[indexToDelete] as AnyObject
                        lstJWNms.append(jitm)
                    }
                }
            }
            
            myDyTp.updateValue(lItem(id: id, name: name,FWFlg: typ), forKey: "WT")
        }else{
            print(" No Data")
        }
        
    }
    @objc private func selHeadquaters() {
        calendar.isHidden = true
        HeadquarterTable.isHidden = false
        isMulti=false
        lObjSel=lstHQs
        HeadquarterTable.reloadData()
        lblSelTitle.text="Select the Headquarter"
        openWin(Mode: "HQ")
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
        StrRptDt=GlobalFunc.getCurrDateAsString().replacingOccurrences(of: " ", with: "%20")
    }
    
    func Brandavailability(){
        let Date  = StrRptDt
print(Date)
        let productArray = Date.components(separatedBy: "%")
        print(productArray)
        let StrDATE = productArray[0]
        self.ShowLoading(Message: "    Loading...")
        let apiKey: String = "\(axn)&activityDate=\(StrDATE)&sfCode=\(SFCode)"


        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result
            {
               
                case .success(let value):
               // print(value)
                if let json = value as? [AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    self.LoadingDismiss()
                    // let Brand:[String: Any] = json["value"] as! [String: Any]
                    // self.objcalls = json
                    
                    //                    let value = json["value"] as? [[String : Any]]
                    //                    print(value)
                    
                    //var BrandList = [Brand_Availability.BrandAvil]()
                    // if let imgevent = event as? [AnyObject], !imgevent.isEmpty {
                    
                    if !json.isEmpty{
                    
                    event = json[0]["event"] as! [AnyObject]
                    
                    
                    
                    let jsonArray = json as? [[String: Any]]
                    let branddata = jsonArray?[0]["value"] as! [[String : Any]]
                    print(branddata)
                    for item in branddata {
                        
                        var Bname = ""
                        if let targetValue = item["BName"] as? String {
                            
                            Bname = targetValue
                        } else {
                            Bname = "No Bname"
                        }
                        
                        BrandList.append(BrandAvil(BrandName: Bname, TC: item["tc"] as! Int, AC: item["Avail"] as! Int, EC: item["EC"] as! Int))
                        self.BrandAV.reloadData()
                    }
                    }else{
                        BrandList.removeAll()
                        BrandAV.reloadData()

                        Toast.show(message: "No calls on this date.")
                    }
//                    CallesTbHig.constant = 100+CGFloat(200*BrandList.count)
//                    self.view.layoutIfNeeded()
//                    print(CallesTbHig.constant)
                    updateTableViewAndSubview()
                    

            
                    
                    
                    
                    EvenCap((Any).self)
//                    vstHeight.constant = CGFloat(55*self.objcalls.count)
//                    self.view.layoutIfNeeded()
                    
                }
               case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    func updateTableViewAndSubview() {
        // Step 1: Calculate the new height for the tableView
        let tableViewHeight = 100 + CGFloat(45 * BrandList.count)

        // Assuming you have a reference to your tableView and viewBelowTableView
        // Replace 'YourTableView' and 'YourViewBelowTableView' with the appropriate class names.
        guard let tableView = BrandAV,
              let viewBelowTableView = Ret_and_img_Hed else {
            return
        }

        // Step 2: Calculate the new frame for the view below the tableView
        let viewBelowTableViewY = tableView.frame.origin.y + tableViewHeight
        let viewBelowTableViewNewFrame = CGRect(x: viewBelowTableView.frame.origin.x,
                                                y: viewBelowTableViewY,
                                                width: viewBelowTableView.frame.size.width,
                                                height: viewBelowTableView.frame.size.height)

        // Step 3: Update the tableView height and view's frame
        UIView.animate(withDuration: 0.3) {
            // Update tableView height
            tableView.frame = CGRect(x: tableView.frame.origin.x,
                                     y: tableView.frame.origin.y,
                                     width: tableView.frame.size.width,
                                     height: tableViewHeight)

            // Update the view below tableView's frame
            viewBelowTableView.frame = viewBelowTableViewNewFrame

            // Make sure other UI elements are updated correctly
            self.view.layoutIfNeeded()
        }
    }
    func EvenCap(_ sender: Any){
        //let imgevent = event
        //print(imgevent)
        
//        if let cusMobile = list[0]["CusMobile"] as? String {
//            self.lblFrmMob.text = cusMobile
//        } else {
//            self.lblFrmMob.text = ""
//        }
        self.ShowLoading(Message: "    Loading...")
        print(event)
        if let imgevent = event as? [AnyObject], !imgevent.isEmpty {
            for img in imgevent {
                print(img)
                let imgurl = img["imgurl"] as! String
                
                //let ListedDr_Name = img["ListedDr_Name"]
                if imgurl != "" {
                    
                    
                    let apiKey: String = "\(SFCode)_\(imgurl)"
                    
                    let url = URL(string:APIClient.shared.imgurl+apiKey)
                    urlImages = url
                    print(url as Any)
                    
                    
                    let imageData = try? Data(contentsOf: url!)
                    // Create a UIImage from the downloaded data
                    let image = UIImage(data: imageData!)
                    Ret_and_img_Hed.isHidden = false
                    ImgViewtb.isHidden=false
                    imagevw.append(imgcp(Ret:img["ListedDr_Name"] as! String , Img: image!, Rmks: img["Rmks"] as! String))
                    
                    
                    ImgViewtb.reloadData()
                }else{
                    imagevw.append(imgcp(Ret:img["ListedDr_Name"] as! String , Img: UIImage(named:"no-image-available")!, Rmks: img["Rmks"] as! String))
                    ImgViewtb.reloadData()
                }
                
            }
        }else {
            
            
            ImgViewtb.isHidden = true
            Ret_and_img_Hed.isHidden=true
        }
        self.LoadingDismiss()
        imgtbhig.constant = 100 + CGFloat(97*self.imagevw.count)
            self.view.layoutIfNeeded()
        Scroolviehig.constant = 100 + CGFloat(70*self.BrandList.count) + CGFloat(120*self.imagevw.count)
            self.view.layoutIfNeeded()
        print(Scroolviehig.constant)
        print(imgtbhig.constant)
    }
    func btpress(_ sender: Any){
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.ImgViewtb)
        guard let indexPath = self.ImgViewtb.indexPathForRow(at: buttonPosition) else{
            return
        }
            let product = SubmittedDCR.objcalls_SelectSecondaryorder2[indexPath.row]
        print(product)
    }
    
    
    
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }
    @objc func closebt(){
        ImageSc.isHidden = true
    }
    @objc private func selDORpt() {
        calendar.isHidden = false
        //HeadquarterTable.isHidden = true
        isDate = true
        openWin(Mode: "DOP")
        lblSelTitle.text="Select the Date"
    }
    func openWin(Mode:String){
        SelMode=Mode
        lAllObjSel = lObjSel
        veselwindow.isHidden=false
        self.view.endEditing(true)
    }
    
    @IBAction func setSelValues(_ sender: Any) {
        strJWCd=strSelJWCd
        strJWNm=strSelJWNm
//        lstJWNms=lstSelJWNms
//        tbJWKSelect.reloadData()
        closeWin(self)
    }
    
    @IBAction func searchBytext(_ sender: Any) {
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            lObjSel = lAllObjSel
        }else{
            lObjSel = lAllObjSel.filter({(product) in
                let name: String = String(format: "%@", product["name"] as! CVarArg)
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        HeadquarterTable.reloadData()
    }
    
    
    @IBAction func closeWin(_ sender: Any) {
        veselwindow.isHidden=true
    }
    
}
