//
//  MydayPlanCtrl.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 06/03/22.
//
import Foundation
import UIKit
import AVFoundation
import CoreLocation
import Alamofire


extension UIView {
  func addTarget(target: Any, action: Selector) {
    let tap = UITapGestureRecognizer(target: target, action: action)
    tap.numberOfTapsRequired = 1
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
}
class MydayPlanCtrl: IViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var vwMainScroll: UIScrollView!
    @IBOutlet weak var vwContent: UIView!
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblWorktype: LabelSelect!
    @IBOutlet weak var lblHQ: LabelSelect!
    @IBOutlet weak var lblDist: LabelSelect!
    @IBOutlet weak var lblRoute: LabelSelect!
    @IBOutlet weak var txSearchSel: UITextField!
    @IBOutlet weak var vwSelWindow: UIView!
    @IBOutlet weak var lblSelTitle: UILabel!
    @IBOutlet weak var tbDataSelect: UITableView!
    @IBOutlet weak var tbJWKSelect: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var txRem: UITextView!
    
    
    @IBOutlet weak var vwWTCtrl: UIView!
    @IBOutlet weak var vwHQCtrl: UIView!
    @IBOutlet weak var vwDistCtrl: UIView!
    @IBOutlet weak var vwRouteCtrl: UIView!
    @IBOutlet weak var vwJointCtrl: UIView!
    @IBOutlet weak var vwRmksCtrl: UIView!
    
    
    
    struct lItem: Any {
        let id: String
        let name: String
        let FWFlg: String
    }
    var myDyTp: [String: lItem] = [:]
    
    var CamSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    
    var SelMode: String = ""
    var strSelJWCd: String = ""
    var strSelJWNm: String = ""
    
    var strJWCd: String = ""
    var strJWNm: String = ""

    var lAllObjSel: [AnyObject] = []
    var lObjSel: [AnyObject] = []
    var lstWType: [AnyObject] = []
    var lstHQs: [AnyObject] = []
    var lstAllRoutes: [AnyObject] = []
    
    var lstDist: [AnyObject] = []
    var lstRoutes: [AnyObject] = []
    var lstJoint: [AnyObject] = []
    var lstSelJWNms: [AnyObject] = []
    var lstJWNms: [AnyObject] = []
   
    var isMulti: Bool = false
    
    var SFCode: String=""
    var DivCode: String=""
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwMainScroll.contentSize = CGSize(width:view.frame.width, height: vwContent.frame.height)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimeDisplay), userInfo: nil, repeats: true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate: String = formatter.string(from: Date())
        print("Date :\(strDate)")
        
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        LocationService.sharedInstance.getNewLocation(location: { location in
        }, error:{ errMsg in
        })
        
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        let SFName: String=prettyJsonData["sfName"] as? String ?? ""
        
        let WorkTypeData: String=LocalStoreage.string(forKey: "Worktype_Master")!
        let HQData: String=LocalStoreage.string(forKey: "HQ_Master")!
        let DistData: String=LocalStoreage.string(forKey: "Distributors_Master_"+SFCode)!
        let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+SFCode)!
        let JointWData: String=LocalStoreage.string(forKey: "Jointwork_Master")!
        
        if let list = GlobalFunc.convertToDictionary(text: WorkTypeData) as? [AnyObject] {
            lstWType = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
            lstDist = list;
        }
        if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
            lstAllRoutes = list;
            if UserSetup.shared.DistBased == 0 {
                lstRoutes = list
            }
        }
        if let list = GlobalFunc.convertToDictionary(text: JointWData) as? [AnyObject] {
            lstJoint = list;
        }
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
                lblHQ.addTarget(target: self, action: #selector(selHeadquaters))
            }
        }
        
        //MARK:- Remove the Slashes
      //  let text = stringJson.replacingOccurrences(of: "\\", with: "")
        
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        
        lblWorktype.addTarget(target: self, action: #selector(selWorktype))
        lblDist.addTarget(target: self, action: #selector(selDistributor))
        lblRoute.addTarget(target: self, action: #selector(selRoutes))
        btnAdd.addTarget(target: self, action: #selector(selJointWK))
        
        tbDataSelect.delegate=self
        tbDataSelect.dataSource=self
        
        tbJWKSelect.delegate=self
        tbJWKSelect.dataSource=self
        
        setTodayPlan()
    }
    
    @objc func TimeDisplay()
    {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let someDateTime = formatter.string(from: Date())
        lblTimer.text = "eTime: "+someDateTime
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==tbJWKSelect { return lstJWNms.count }
        return lObjSel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if tableView == tbJWKSelect {
            let item: [String: Any]=lstJWNms[indexPath.row] as! [String : Any]
            cell.lblText?.text = item["name"] as? String
            cell.imgBtnDel.addTarget(target: self, action: #selector(self.delJWK(_:)))
        }else{
            let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
            cell.lblText?.text = item["name"] as? String
            cell.imgSelect?.image = nil
            if SelMode == "JWK" {
                let sid=(item["id"] as! String)
                let sfind: String = (";"+sid+";")
                if let range: Range<String.Index> = (";"+strSelJWCd).range(of: sfind) {
                    cell.imgSelect?.image = UIImage(named: "Select")
                }
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
        let name=item["name"] as! String
        let id=String(format: "%@", item["id"] as! CVarArg)
        print(id)
        var typ: String = ""
        if isMulti==true {
            if SelMode == "JWK" {
                let sid=(item["id"] as! String)
                let sfind: String = (";"+sid+";")
                
                if let range: Range<String.Index> = (";"+strSelJWCd).range(of: sfind) {
                    strSelJWCd=strSelJWCd.replacingOccurrences(of: sid+";", with: "")
                    strSelJWNm=strSelJWNm.replacingOccurrences(of: name+";", with: "")
                    if let indexToDelete = lstSelJWNms.firstIndex(where: { $0["id"] as? String == sid}) {
                        lstSelJWNms.remove(at: indexToDelete)
                    }
                    tableView.reloadData()
                }else{
                    strSelJWCd += sid+";"
                    strSelJWNm += name+";"
                    let jitm: AnyObject = item as AnyObject
                    lstSelJWNms.append(jitm)
                    tableView.reloadData()
                }
            }
        }else{
            if SelMode=="WT" {
                typ=item["FWFlg"] as! String
                lblWorktype.text = name
                vwHQCtrl.isHidden=false
                vwDistCtrl.isHidden=false
                vwRouteCtrl.isHidden=false
                vwJointCtrl.isHidden=false
                self.vwRmksCtrl.frame.origin.y = vwJointCtrl.frame.origin.y+vwJointCtrl.frame.height+8
                if typ != "F" {
                    vwHQCtrl.isHidden=true
                    vwDistCtrl.isHidden=true
                    vwRouteCtrl.isHidden=true
                    vwJointCtrl.isHidden=true
                    
                    self.vwRmksCtrl.frame.origin.y = vwWTCtrl.frame.origin.y+vwWTCtrl.frame.height+8
                    
                }
            } else if SelMode == "DIS" {
                lblDist.text = name
                lstRoutes = lstAllRoutes.filter({(fitem) in
                    let StkId: String = String(format: ",%@,", fitem["stockist_code"] as! CVarArg)
                    return Bool(StkId.range(of: String(format: ",%@,", id))?.lowerBound != nil )
                })
            } else if SelMode == "RUT" {
                lblRoute.text = name  //+(item["id"] as! String)
            }else if SelMode == "HQ" {
                lblHQ.text = name  //+(item["id"] as! String)
                var DistData: String=""
                if(LocalStoreage.string(forKey: "Distributors_Master_"+id)==nil){
                    Toast.show(message: "No Distributors found. Please will try to sync", controller: self)
                    GlobalFunc.FieldMasterSync(SFCode: id){
                        DistData = self.LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                        let RouteData: String=self.LocalStoreage.string(forKey: "Route_Master_"+id)!
                        if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                            self.lstDist = list;
                        }
                        if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                            self.lstAllRoutes = list
                            self.lstRoutes = list
                        }
                    }
                    return
                }else{
                    DistData = LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                    
                    let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+id)!
                    if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                        lstDist = list;
                    }
                    if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                        lstAllRoutes = list
                        lstRoutes = list
                    }
                }
                if(UserSetup.shared.DistBased == 1){
                    
                }
            }
            
            myDyTp.updateValue(lItem(id: id, name: name,FWFlg: typ), forKey: SelMode)
            closeWin(self)
        }
    
    }
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
        let name=item["name"] as! String
        let id=String(format: "%@", item["id"] as! CVarArg)
        print(id)
        if SelMode=="WT" {
            lblWorktype.text = name
        } else if SelMode == "DIS" {
            lblDist.text = name
        } else if SelMode == "RUT" {
            lblRoute.text = name  //+(item["id"] as! String)
        }
        else if SelMode == "JWK" {
            let sid=(item["id"] as! String)
            let sfind: String = (";"+sid+";")
            
            if let range: Range<String.Index> = (";"+strSelJWCd).range(of: sfind) {
                strSelJWCd=strSelJWCd.replacingOccurrences(of: sid+";", with: "")
                strSelJWNm=strSelJWNm.replacingOccurrences(of: name+";", with: "")
                if let indexToDelete = lstSelJWNms.firstIndex(where: { $0["id"] as? String == sid}) {
                    lstSelJWNms.remove(at: indexToDelete)
                }
                tableView.reloadData()
            }else{
                strSelJWCd += sid+";"
                strSelJWNm += name+";"
                let jitm: AnyObject = item as AnyObject
                lstSelJWNms.append(jitm)
                tableView.reloadData()
            }
        }
        
        if isMulti==false{
            closeWin(self)
        }
        
    }*/
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
            lblWorktype.text = lstWType[indexToDelete]["name"] as? String
            let id=String(format: "%@", lstWType[indexToDelete]["id"] as! CVarArg)
            let name: String = lstWType[indexToDelete]["name"] as! String
            
            txRem.text = lstPlnDetail[0]["remarks"] as? String
            vwHQCtrl.isHidden=false
            vwDistCtrl.isHidden=false
            vwRouteCtrl.isHidden=false
            vwJointCtrl.isHidden=false
            self.vwRmksCtrl.frame.origin.y = vwJointCtrl.frame.origin.y+vwJointCtrl.frame.height+8
            if typ != "F" {
                vwHQCtrl.isHidden=true
                vwDistCtrl.isHidden=true
                vwRouteCtrl.isHidden=true
                vwJointCtrl.isHidden=true
                
                self.vwRmksCtrl.frame.origin.y = vwWTCtrl.frame.origin.y+vwWTCtrl.frame.height+8
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
                    //new
        
//                    let DistData: String=LocalStoreage.string(forKey: "Distributors_Master_"+sfid)!
//                    let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+sfid)!
//                    if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
//                        lstDist = list;
//                    }
//                    if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
//                        lstAllRoutes = list
//                        lstRoutes = list
//                    }
                    
                    myDyTp.updateValue(lItem(id: sfid, name: sfname,FWFlg: ""), forKey: "HQ")
                }
                let stkid=String(format: "%@", lstPlnDetail[0]["stockistid"] as! CVarArg)
                if let indexToDelete = lstDist.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == stkid }) {
                    lblDist.text = lstDist[indexToDelete]["name"] as? String
                    let stkname: String = lstDist[indexToDelete]["name"] as! String
                    
                    lstRoutes = lstAllRoutes.filter({(fitem) in
                        let StkId: String = String(format: ",%@,", fitem["stockist_code"] as! CVarArg)
                        return StkId.contains(String(format: ",%@,", stkid))
                        //return Bool(StkId.range(of: String(format: ",%@,", id))?.lowerBound != nil )
                    })
                    myDyTp.updateValue(lItem(id: stkid, name: stkname,FWFlg: ""), forKey: "DIS")
                }
                let rtid=String(format: "%@", lstPlnDetail[0]["clusterid"] as! CVarArg)
                if let indexToDelete = lstRoutes.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == rtid }) {
                    lblRoute.text = lstRoutes[indexToDelete]["name"] as? String
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
                tbJWKSelect.reloadData()
            }
            
            myDyTp.updateValue(lItem(id: id, name: name,FWFlg: typ), forKey: "WT")
        }else{
            print(" No Data")
        }
        
    }
    @objc private func GotoHome() {
        self.dismiss(animated: true, completion: nil)
        GlobalFunc.movetoHomePage()
    }
    @IBAction func setSelValues(_ sender: Any) {
        strJWCd=strSelJWCd
        strJWNm=strSelJWNm
        lstJWNms=lstSelJWNms
        tbJWKSelect.reloadData()
        closeWin(self)
    }
    @objc private func selWorktype() {
        isMulti=false
        lObjSel=lstWType
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Worktype"
        openWin(Mode: "WT")
        
        /*let locm = CLocationService()
        locm.getNewLocation(location: { location in
            print ("New  : \(location)")
        })*/
        
    }
    
    @objc private func selHeadquaters() {
        isMulti=false
        lObjSel=lstHQs
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Headquarter"
        openWin(Mode: "HQ")
    }
    @objc private func selDistributor() {
        isMulti=false
        lObjSel=lstDist
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Distributor"
        openWin(Mode: "DIS")
    }
    
    @objc private func selRoutes() {
        isMulti=false
        lObjSel=lstRoutes
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Routes"
        openWin(Mode: "RUT")
    }
    @objc private func selJointWK() {
        isMulti=true
        lObjSel=lstJoint
        strSelJWCd=strJWCd
        strSelJWNm=strJWNm
        lstSelJWNms=lstJWNms
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Jointwork"
        openWin(Mode: "JWK")
    }
    @objc private func delJWK(_ sender: UITapGestureRecognizer) {
        let cell:cellListItem = GlobalFunc.getTableViewCell(view: sender.view!) as! cellListItem
        let tbView: UITableView = GlobalFunc.getTableView(view: sender.view!)
        let indx:NSIndexPath = tbView.indexPath(for: cell)! as NSIndexPath
        removeJWk(indx: indx.row)
     }
    
    func removeJWk(indx: Int){
        let sItem: [String: Any] = lstJWNms[indx] as! [String: Any]
        
        let sid: String = sItem["id"] as! String
        let name: String = sItem["name"] as! String
        
        strJWCd=strJWCd.replacingOccurrences(of: sid+";", with: "")
        strJWNm=strJWNm.replacingOccurrences(of: name+";", with: "")
        
        lstJWNms.remove(at: indx)
        tbJWKSelect.reloadData()
    }
    func openWin(Mode:String){
        SelMode=Mode
        lAllObjSel = lObjSel
        txSearchSel.text = ""
        vwSelWindow.isHidden=false
        
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
        tbDataSelect.reloadData()
        
    }
    @IBAction func closeWin(_ sender:Any){
        vwSelWindow.isHidden=true
    }
    
    func validateForm() -> Bool {
        if (myDyTp["WT"]?.id ?? "") == "" {
            Toast.show(message: "Select the Worktype", controller: self)
            return false
        }
        if myDyTp["WT"]?.FWFlg == "F" {
            if (myDyTp["DIS"]?.id ?? "") == "" {
                Toast.show(message: "Select the Distributor", controller: self)
                return false
            }
            if (myDyTp["RUT"]?.id ?? "") == "" {
                Toast.show(message: "Select the Route", controller: self)
                return false
            }
        }
        /*
        if NewOutlet.shared.Lat == "" {
            Toast.show(message: "Location can't capture right now", controller: self)
            
            let alert = UIAlertController(title: "Information", message: "Location can't capture right now. do you want create without tag this place. cancel to refresh location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                self.setOutletLocation()
                return
            })
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                self.fnCreateNewOutlet()
                return
            })
            self.present(alert, animated: true)
            return false
        }*/
        /*if NewOutlet.shared.OwnerName == "" {
            Toast.show(message: "Enter the Retailer", controller: self)
            return false
        }*/
        return true
        
    }
    
    @IBAction func SaveMyDayPlan(_ sender: Any) {
        if validateForm() == false {
            return
        }
        if(NetworkMonitor.Shared.isConnected != true){
            let alert = UIAlertController(title: "Information", message: "Check the Internet Connection", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                     return
                 })
                 self.present(alert, animated: true)
                return
        }
        self.ShowLoading(Message: "Getting Device Location...")
        LocationService.sharedInstance.getNewLocation(location: { location in 
            print ("New  : "+location.coordinate.latitude.description + ":" + location.coordinate.longitude.description)
            self.ShowLoading(Message: "Submitting Please wait...")
            self.saveDayTP(location: location)
        }, error:{ errMsg in
            self.LoadingDismiss()
            print (errMsg)
            let alert = UIAlertController(title: "Information", message: errMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                return
            })
            
        })
        
       /* */
    }
    
    
    func saveDayTP(location: CLLocation){
        let dateString = GlobalFunc.getCurrDateAsString()
        lazy var geocoder = CLGeocoder()
        var sAddress: String = ""
        var slocation = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
        geocoder.reverseGeocodeLocation(location) { [self] (placemarks, error) in
            if(placemarks != nil ){
                if(placemarks!.count>0){
                    let jAddress:[String] = placemarks![0].addressDictionary!["FormattedAddressLines"] as! [String]
                    for i in 0...jAddress.count-1 {
                        print(jAddress[i])
                        if i==0{
                            sAddress = String(format: "%@", jAddress[i])
                        }else{
                            sAddress = String(format: "%@, %@", sAddress,jAddress[i])
                        }
                    }
                }
            }
            
            let jsonString = "[{\"tbMyDayPlan\":{\"wtype\":\"'" + (myDyTp["WT"]?.id ?? "") + "'\",\"sf_member_code\":\"'" + (myDyTp["HQ"]?.id ?? SFCode) + "'\",\"stockist\":\"'" + (myDyTp["DIS"]?.id ?? "") + "'\",\"stkName\":\"" + (myDyTp["DIS"]?.name ?? "") + "\",\"dcrtype\":\"App\",\"cluster\":\"'" + (myDyTp["RUT"]?.id ?? "") + "'\",\"custid\":\"" + (myDyTp["RUT"]?.id ?? "") + "\",\"custName\":\"" + (myDyTp["RUT"]?.name ?? "") + "\",\"address\":\"" + sAddress + "\",\"remarks\":\"'" + (txRem.text as! String ?? "" ) + "'\",\"OtherWors\":\"\",\"FWFlg\":\"'" + (myDyTp["WT"]?.FWFlg ?? "") + "'\",\"SundayWorkigFlag\":\"''\",\"Place_Inv\":\"\",\"WType_SName\":\"" + (myDyTp["WT"]?.name ?? "") + "\",\"ClstrName\":\"'" + (myDyTp["RUT"]?.name ?? "") + "'\",\"AppVersion\":\"Vi1.1.0\",\"self\":1,\"location\":\"" + slocation + "\",\"dcr_activity_date\":\"'" + dateString + "'\",\"worked_with\":\"'" + strJWCd.replacingOccurrences(of: ";", with: ",") + "'\"}}]"
       // let jsonString: String = ""

        let params: Parameters = [
            "data": jsonString //"["+jsonString+"]"
        ]
        print(params)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode="+self.DivCode+"&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            self.LoadingDismiss()
            switch AFdata.result
            {
               
            case .success(let value):
                if let json = value as? [String: Any] {
                    if((json["success"] as! Bool) == false){
                        Toast.show(message: json["msg"] as! String, controller: self)
                        return
                    }else{
                        let apiKey: String = "table/list&divisionCode="+self.DivCode+"&rSF="+self.SFCode+"&sfCode="+self.SFCode
                        let aFormData: [String: Any] = [
                           "tableName":"vwMyDayPlan","coloumns":"[\"worktype\",\"FWFlg\",\"sf_member_code as subordinateid\",\"cluster as clusterid\",\"ClstrName\",\"remarks\",\"stockist as stockistid\",\"worked_with_code\",\"worked_with_name\",\"dcrtype\",\"location\",\"name\",\"Sprstk\",\"Place_Inv\",\"WType_SName\",\"convert(varchar,Pln_date,20) plnDate\"]","desig":"mgr"
                        ]
                        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
                        let jsonString = String(data: jsonData!, encoding: .utf8)!
                        let params: Parameters = [
                            "data": jsonString
                        ]
                        
                        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                            AFdata in
                            switch AFdata.result
                            {
                               
                                case .success(let json):
                                   guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                                       print("Error: Cannot convert JSON object to Pretty JSON data")
                                       return
                                   }
                                   guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                                       print("Error: Could print JSON in String")
                                       return
                                   }

                                   print(prettyPrintedJson)
                                   let LocalStoreage = UserDefaults.standard
                                   LocalStoreage.set(prettyPrintedJson, forKey: "Mydayplan")
                                
                                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                                    UIApplication.shared.windows.first?.rootViewController = viewController
                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
                                    Toast.show(message: "My day plan submitted successfully", controller: self)
                               case .failure(let error):
                                   print(error.errorDescription!)
                            }
                        }
                    }
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                         return
                     })
                     self.present(alert, animated: true)
            }
            }
        }
    }
}
