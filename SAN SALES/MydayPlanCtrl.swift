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
class MydayPlanCtrl: IViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
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
    @IBOutlet weak var Applylev: UIImageView!
    @IBOutlet weak var vwWTCtrl: UIView!
    @IBOutlet weak var vwHQCtrl: UIView!
    @IBOutlet weak var vwDistCtrl: UIView!
    @IBOutlet weak var vwRouteCtrl: UIView!
    @IBOutlet weak var vwJointCtrl: UIView!
    @IBOutlet weak var vwRmksCtrl: UIView!
    @IBOutlet weak var Setval: UIButton!
    
    
    
    @IBOutlet weak var vwDeviationLock: UIView!
    
    @IBOutlet weak var lblRejectReason: UILabel!
    
    
    @IBOutlet weak var vwRejectReason: UIView!
    
    @IBOutlet weak var vwDeviationCtrl: UIView!
    @IBOutlet weak var switchDeviate: UISwitch!
    
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
    var ImgName:String = ""

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
    var Leaveid: String = ""
   // var selfieLoginActive = 1
    public static var SfidString: String=""
    var leavWorktype: String = ""
    let LocalStoreage = UserDefaults.standard
    var exp_Need:Int = 0
    var lstPlnDetail: [AnyObject] = []
    var attendanceView:Int = 0
    var tpDatas : JSON!
    override func viewDidLoad(){
        super.viewDidLoad()
        txRem.text = "Enter the Remarks"
        txRem.textColor = UIColor.lightGray
        txRem.returnKeyType = .done
        txRem.delegate = self
        txRem.contentSize = CGSize(width:view.frame.width, height: vwContent.frame.height)
        self.vwContent.frame.size = CGSize(width: self.vwContent.frame.width, height: 930)
        self.vwMainScroll.contentSize = CGSize(width: self.vwContent.frame.width, height: 930)
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
        attendanceView = prettyJsonData["attendanceView"] as? Int ?? 0
      //  let WorkTypeData: String=LocalStoreage.string(forKey: "Worktype_Master")!
       // let HQData: String=LocalStoreage.string(forKey: "HQ_Master")!
        //let DistData: String=LocalStoreage.string(forKey: "Distributors_Master_"+SFCode)!
      // let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+SFCode)!
       // let JointWData: String=LocalStoreage.string(forKey: "Jointwork_Master")!
        
        //new
        if let WorkTypeData = LocalStoreage.string(forKey: "Worktype_Master"),
           let list = GlobalFunc.convertToDictionary(text:  WorkTypeData) as? [AnyObject] {
            lstWType = list
        }
        
        if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+SFCode),
           let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
            lstDist = list;
        }
        if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+SFCode),
           let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
            lstAllRoutes = list
            lstRoutes = list
        }
        if let JointWData = LocalStoreage.string(forKey: "Jointwork_Master"),
           let list = GlobalFunc.convertToDictionary(text:  JointWData) as? [AnyObject] {
            lstJoint = list;
        }

        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list;
            var id: String = SFCode
            var name: String = SFName
            if (lstHQs.count > 0) {
                let item: [String: Any]=lstHQs[0] as! [String : Any]
                name = item["name"] as! String
                id=String(format: "%@", item["id"] as! CVarArg)
                
                lblHQ.addTarget(target: self, action: #selector(selHeadquaters))
          
            }
            if lstHQs.count < 2{
                lblHQ.text = name
                
              
                if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+id),
                   let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
                    lstDist = list;
                    print("DistData  ___________________________")
                }
                if let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+id),
                 let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                    lstAllRoutes = list
                    lstRoutes = list
                    print("RouteData  ___________________________")                }
                
                if let jointWorkData = LocalStoreage.string(forKey: "Jointwork_Master_"+id){
                    if let list = GlobalFunc.convertToDictionary(text: jointWorkData) as? [AnyObject] {
                        lstJoint = list
                    }
                }
            }
            else
            {
                lblHQ.addTarget(target: self, action: #selector(selHeadquaters))
            }
        }
        
        
        //new
        
        
        
//        if let list = GlobalFunc.convertToDictionary(text: WorkTypeData) as? [AnyObject] {
//            lstWType = list;
//        }
//        if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
//            lstDist = list;
//        }
//        if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
//            lstAllRoutes = list;
//            if UserSetup.shared.DistBased == 0 {
//                lstRoutes = list
//            }
//        }
//        if let list = GlobalFunc.convertToDictionary(text: JointWData) as? [AnyObject] {
//            lstJoint = list;
//        }
//        if let list = GlobalFunc.convertToDictionary(text: HQData) as? [AnyObject] {
//            lstHQs = list;
//            var id: String = SFCode
//            var name: String = SFName
//            if lstHQs.count > 0 {
//                let item: [String: Any]=lstHQs[0] as! [String : Any]
//                name = item["name"] as! String
//                id=String(format: "%@", item["id"] as! CVarArg)
//            }
//            if(lstHQs.count < 2){
//                lblHQ.text = name
//                let DistData: String=LocalStoreage.string(forKey: "Distributors_Master_"+id)!
//                let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+id)!
//                if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
//                    lstDist = list;
//                }
//                if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
//                    lstAllRoutes = list
//                    lstRoutes = list
//                }
//            }
//            else
//            {
//                lblHQ.addTarget(target: self, action: #selector(selHeadquaters))
//            }34251350977
//        }
//
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
        print(UserSetup.shared.DistBased)
        if UserSetup.shared.DistBased == 0 {
            self.vwDistCtrl.isHidden = true
            self.vwRouteCtrl.frame.origin.y = vwRouteCtrl.frame.origin.y+vwRouteCtrl.frame.height-160
            self.vwJointCtrl.frame.origin.y = vwJointCtrl.frame.origin.y+vwJointCtrl.frame.height-300
            if UserSetup.shared.tpDcrDeviationNeed == 0 {
                
                self.vwRmksCtrl.frame.origin.y = vwRmksCtrl.frame.origin.y+vwRmksCtrl.frame.height-155
                self.vwDeviationCtrl.frame.origin.y = vwDeviationCtrl.frame.origin.y+vwDeviationCtrl.frame.height-155
                self.vwRejectReason.frame.origin.y = vwRejectReason.frame.origin.y+vwRejectReason.frame.height-155
                
            }else {
                self.vwRmksCtrl.frame.origin.y = vwRmksCtrl.frame.origin.y+vwRmksCtrl.frame.height-155
                self.vwDeviationCtrl.isHidden = true
                self.vwRejectReason.isHidden = true
            }
            
               }
        if (UserSetup.shared.DistBased == 1){
            vwDistCtrl.isHidden = false
        }
        if (UserSetup.shared.DistBased == 2){
            vwDistCtrl.isHidden = false
        }
        
        Applylev.addTarget(target: self, action: #selector(levedata))
        
        setTodayPlan()
       //selectedid()

        if UserSetup.shared.tpDcrDeviationNeed == 0 {
            self.tpDeviation()
        }else {
            self.vwDeviationCtrl.isHidden = true
            self.vwRejectReason.isHidden = true
            self.vwMainScroll.contentSize = CGSize(width: self.vwContent.frame.width, height: 750)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter the Remarks"{
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Enter the Remarks"
            textView.textColor = UIColor.lightGray
        }
    }
//
    func selectedid(){

        var lstPlnDetail: [AnyObject] = []
        if self.LocalStoreage.string(forKey: "Mydayplan") == nil { return }
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list;
        }
        let sfid=String(format: "%@", lstPlnDetail[0]["subordinateid"] as! CVarArg)
        //MydayPlanCtrl.SfidString = sfid
        print(sfid)
       // print(MydayPlanCtrl.SfidString)
        var DistData: String=""
        if(LocalStoreage.string(forKey: "Distributors_Master_"+sfid)==nil){
           // Toast.show(message: "No Distributors found. Please will try to sync", controller: self)
            GlobalFunc.FieldMasterSync(SFCode: sfid){
                DistData = self.LocalStoreage.string(forKey: "Distributors_Master_"+sfid)!
                let RouteData: String=self.LocalStoreage.string(forKey: "Route_Master_"+sfid)!
                let jointWorkData : String = self.LocalStoreage.string(forKey: "Jointwork_Master_"+sfid)!
                if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                    self.lstDist = list;
                }
                if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                    self.lstAllRoutes = list
                    self.lstRoutes = list
                }
                if let list  =  GlobalFunc.convertToDictionary(text: jointWorkData) as? [AnyObject] {
                    self.lstJoint = list
                }
            }
            return
        }else {
            if let DistData = LocalStoreage.string(forKey: "Distributors_Master_" + sfid) {
                if let RouteData = LocalStoreage.string(forKey: "Route_Master_" + sfid) {
                    if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                        lstDist = list
                    }

                    if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                        lstAllRoutes = list
                        lstRoutes = list
                    }
                    
                    if let jointWorkData = LocalStoreage.string(forKey: "Jointwork_Master_"+sfid){
                        if let list = GlobalFunc.convertToDictionary(text: jointWorkData) as? [AnyObject] {
                            lstJoint = list
                        }
                    }
                }
            }
        }
        if(UserSetup.shared.DistBased == 1){
        }
    }
    @objc func levedata () {
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMainmnu") as!  MainMenu
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve //.crossDissolve
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func TimeDisplay(){
        
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
            print(item)
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
        print(item)
        if let need = item["exp_needed"] as? Int{
            exp_Need = need
        }
        var id = ""
        if let ids=item["id"] as? String {
            id = ids
        }else{
            id = String((item["id"] as? Int)!)
        }
        if let Flg_id = item["FWFlg"] as? String{
            Leaveid = Flg_id
        }
        
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
               // vwDistCtrl.isHidden=false
                vwRouteCtrl.isHidden=false
                vwJointCtrl.isHidden=false
                
                self.vwRmksCtrl.frame.origin.y = vwJointCtrl.frame.origin.y+vwJointCtrl.frame.height+8
                self.vwDeviationCtrl.frame.origin.y = vwRmksCtrl.frame.origin.y+vwRmksCtrl.frame.height+8
                self.vwRejectReason.frame.origin.y = vwDeviationCtrl.frame.origin.y+vwDeviationCtrl.frame.height+8
                if typ != "F" {
                    vwHQCtrl.isHidden=true
                   // vwDistCtrl.isHidden=true
                    vwRouteCtrl.isHidden=true
                    vwJointCtrl.isHidden=true
        
                    
                    self.vwRmksCtrl.frame.origin.y = vwWTCtrl.frame.origin.y+vwWTCtrl.frame.height+8
                    self.vwDeviationCtrl.frame.origin.y = vwRmksCtrl.frame.origin.y+vwRmksCtrl.frame.height+8
                    self.vwRejectReason.frame.origin.y = vwDeviationCtrl.frame.origin.y+vwDeviationCtrl.frame.height+8
                    
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
                    //Toast.show(message: "No Distributors found. Please will try to sync", controller: self)
                    self.ShowLoading(Message: "       Sync Data Please wait...")
                    GlobalFunc.FieldMasterSync(SFCode: id){ [self] in
                        DistData = self.LocalStoreage.string(forKey: "Distributors_Master_"+id)!
                        let RouteData: String=self.LocalStoreage.string(forKey: "Route_Master_"+id)!
                        if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                            self.lstDist = list;
                        }
                        if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                            self.lstAllRoutes = list
                            self.lstRoutes = list
                        }
                        if let jointWorkData = LocalStoreage.string(forKey: "Jointwork_Master_"+id){
                            if let list = GlobalFunc.convertToDictionary(text: jointWorkData) as? [AnyObject] {
                                lstJoint = list
                            }
                        }
                        lblDist.text = "Select the Distributor"
                        lblRoute.text = "Select the Route"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.LoadingDismiss()
                            self.vwSelWindow.isHidden=true
                         //   self.navigationController?.popViewController(animated: true)
                            
                        }
                    }
                    
                }else {
                    self.ShowLoading(Message: "       Sync Data Please wait...")
                    GlobalFunc.FieldMasterSync(SFCode: id){ [self] in
                    if let DistData = LocalStoreage.string(forKey: "Distributors_Master_" + id) {
                        if let RouteData = LocalStoreage.string(forKey: "Route_Master_" + id) {
                            if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                                lstDist = list
                            }
                            
                            if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                                lstAllRoutes = list
                                lstRoutes = list
                            }
                            
                            if let jointWorkData = LocalStoreage.string(forKey: "Jointwork_Master_"+id){
                                if let list = GlobalFunc.convertToDictionary(text: jointWorkData) as? [AnyObject] {
                                    lstJoint = list
                                }
                            }
                        }
                    }
                        self.LoadingDismiss()
                }
                }
//                else{
//                    DistData = LocalStoreage.string(forKey: "Distributors_Master_"+id)!
//
//                    let RouteData: String=LocalStoreage.string(forKey: "Route_Master_"+id)!
//                    if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
//                        lstDist = list;
//                    }
//                    if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
//                        lstAllRoutes = list
//                        lstRoutes = list
//                    }
//                }
                if(UserSetup.shared.DistBased == 1){
                    
                }
            }
            
            myDyTp.updateValue(lItem(id: id, name: name,FWFlg: typ), forKey: SelMode)
            print(myDyTp)
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
        print(lstPlnDetail)
        if(lstPlnDetail.count < 1){ return }
        let wtid=String(format: "%@", lstPlnDetail[0]["worktype"] as! CVarArg)
        if let indexToDelete = lstWType.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == wtid }) {
           // print(indexToDelete)
            //print(lstWType)

            let typ: String = lstWType[indexToDelete]["FWFlg"] as! String
            lblWorktype.text = lstWType[indexToDelete]["name"] as? String
            leavWorktype = lstWType[indexToDelete]["name"] as! String
            //print(leavWorktype)
            Leaveid = typ
            let id=String(format: "%@", lstWType[indexToDelete]["id"] as! CVarArg)
            let name: String = lstWType[indexToDelete]["name"] as! String
            
            txRem.text = lstPlnDetail[0]["remarks"] as? String
            vwHQCtrl.isHidden=false
           // vwDistCtrl.isHidden=false
            vwRouteCtrl.isHidden=false
            vwJointCtrl.isHidden=false
            self.vwRmksCtrl.frame.origin.y  = vwJointCtrl.frame.origin.y+vwJointCtrl.frame.height+8
            self.vwDeviationCtrl.frame.origin.y = vwRmksCtrl.frame.origin.y+vwRmksCtrl.frame.height+8
            self.vwRejectReason.frame.origin.y = vwDeviationCtrl.frame.origin.y+vwDeviationCtrl.frame.height+8
            if typ != "F" {
                vwHQCtrl.isHidden=true
                vwDistCtrl.isHidden=true
                vwRouteCtrl.isHidden=true
                vwJointCtrl.isHidden=true
                
                self.vwRmksCtrl.frame.origin.y  = vwWTCtrl.frame.origin.y+vwWTCtrl.frame.height+8
                self.vwDeviationCtrl.frame.origin.y = vwRmksCtrl.frame.origin.y+vwRmksCtrl.frame.height+8
                self.vwRejectReason.frame.origin.y = vwDeviationCtrl.frame.origin.y+vwDeviationCtrl.frame.height+8
                
                myDyTp.updateValue(lItem(id: id, name: name,FWFlg: typ), forKey: "WT")
            }else{
                
                let sfid=String(format: "%@", lstPlnDetail[0]["subordinateid"] as! CVarArg)
                print(lstPlnDetail)
                print(sfid)
                MydayPlanCtrl.SfidString = sfid
                if let indexToDelete = lstHQs.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == sfid }) {
                    lblHQ.text = lstHQs[indexToDelete]["name"] as? String
                    let sfname: String = lstHQs[indexToDelete]["name"] as! String
                    //new
                    
                    var DistData: String=""
                    if(LocalStoreage.string(forKey: "Distributors_Master_"+sfid)==nil){
                        //Toast.show(message: "No Distributors found. Please will try to sync", controller: self)
                        self.ShowLoading(Message: "       Sync Data Please wait...")
                        GlobalFunc.FieldMasterSync(SFCode: sfid){ [self] in
                            DistData = self.LocalStoreage.string(forKey: "Distributors_Master_"+sfid)!
                            let RouteData: String=self.LocalStoreage.string(forKey: "Route_Master_"+sfid)!
                            let jointWorkData : String = self.LocalStoreage.string(forKey: "Jointwork_Master_"+sfid)!
                            if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                                self.lstDist = list;
                            }
                            if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                                self.lstAllRoutes = list
                                self.lstRoutes = list
                            }
                            if let list  =  GlobalFunc.convertToDictionary(text: jointWorkData) as? [AnyObject] {
                                self.lstJoint = list
                            }
//                            lblDist.text = "Select the Distributor"
//                            lblRoute.text = "Select the Route"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.LoadingDismiss()
                                self.vwSelWindow.isHidden = true
                               // self.navigationController?.popViewController(animated: true)
                                
                            }
                        }
                        
                      //  return
                    }else {
                        if let DistData = LocalStoreage.string(forKey: "Distributors_Master_" + sfid) {
                            if let RouteData = LocalStoreage.string(forKey: "Route_Master_" + sfid) {
                                if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                                    lstDist = list
                                }
                                
                                if let list = GlobalFunc.convertToDictionary(text: RouteData) as? [AnyObject] {
                                    lstAllRoutes = list
                                    lstRoutes = list
                                }
                                if let jointWorkData = LocalStoreage.string(forKey: "Jointwork_Master_"+sfid){
                                    if let list = GlobalFunc.convertToDictionary(text: jointWorkData) as? [AnyObject] {
                                        lstJoint = list
                                    }
                                }
                            }
                        }
                    }
                    
                    
//                    if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+sfid),
//                       let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
//                        lstDist = list
//                        //print(DistData)
//                    }
//
//
//                    if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+sfid),
//                       let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
//                         lstAllRoutes = list
//                        lstRoutes = list
//                        //print(RouteData)
//                    }
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
                    print(myDyTp)
                }
                let stkid=String(format: "%@", lstPlnDetail[0]["stockistid"] as! CVarArg)
                print(lstPlnDetail)
                print(stkid)
                print(lstDist)
                if let indexToDelete = lstDist.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == stkid }) {
                    lblDist.text = lstDist[indexToDelete]["name"] as? String
                    let stkname: String = lstDist[indexToDelete]["name"] as! String
                    
                    lstRoutes = lstAllRoutes.filter({(fitem) in
                        let StkId: String = String(format: ",%@,", fitem["stockist_code"] as! CVarArg)
                        return StkId.contains(String(format: ",%@,", stkid))
                        //return Bool(StkId.range(of: String(format: ",%@,", id))?.lowerBound != nil )
                    })
                    myDyTp.updateValue(lItem(id: stkid, name: stkname,FWFlg: ""), forKey: "DIS")
                    print(myDyTp)
                }
                let rtid=String(format: "%@", lstPlnDetail[0]["clusterid"] as! CVarArg)
                print(lstPlnDetail)
                print(rtid)
                print(lstRoutes)
                if let indexToDelete = lstRoutes.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == rtid }) {
                    lblRoute.text = lstRoutes[indexToDelete]["name"] as? String
                    HomePageViewController.selfieLoginActive = 0
                    let rtname: String = lstRoutes[indexToDelete]["name"] as! String
                    print(rtname)
                   myDyTp.updateValue(lItem(id: rtid, name: rtname,FWFlg: ""), forKey: "RUT")
                    print(myDyTp)
                }
                let jwids=(String(format: "%@", lstPlnDetail[0]["worked_with_code"] as! CVarArg)).replacingOccurrences(of: "$$", with: ";")
                    .replacingOccurrences(of: "$", with: ";")
                    .components(separatedBy: ";")
                print(lstPlnDetail[0]["worked_with_code"] as! CVarArg)
                for k in 0...jwids.count-1 {
                    if let indexToDelete = lstJoint.firstIndex(where: { String(format: "%@", $0["id"] as! CVarArg) == jwids[k] }) {
                        print(lstJoint)
                        let jwid: String = lstJoint[indexToDelete]["id"] as! String
                        let jwname: String = lstJoint[indexToDelete]["name"] as! String
                        print(lstJoint)
                        print(jwid)
                        strJWCd += jwid+";"
                        strJWNm += jwname+";"
                        let jitm: AnyObject = lstJoint[indexToDelete] as AnyObject
                        lstJWNms.append(jitm)
                    }
                }
                print(lstJWNms)
                myDyTp.updateValue(lItem(id: id, name: name,FWFlg: typ), forKey: "WT")
                print(myDyTp)
                tbJWKSelect.reloadData()
            }
            
            
        }else{
            print(" No Data")
        }
        
    }
    @objc private func GotoHome() {
        self.dismiss(animated: true, completion: nil)
        GlobalFunc.MovetoMainMenu()
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
        
        if UserSetup.shared.tpDcrDeviationNeed == 0 && !switchDeviate.isOn {
            
            let code = self.tpDatas.tp.first?.worktype_code.int ?? 0
            
            lObjSel=lstWType.filter{($0["id"] as? Int ?? 0) == code}
        }else {
            lObjSel=lstWType
        }
       // lObjSel=lstWType
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
        
        if UserSetup.shared.tpDcrDeviationNeed == 0 && !switchDeviate.isOn {
            
            if UserSetup.shared.SF_type == 1 {
                lObjSel=lstHQs
            }else{
                let code = self.tpDatas.tp.first?.HQ_Code.string ?? ""
                
                lObjSel=lstHQs.filter{($0["id"] as? String ?? "") == code}
            }
            
            
        }else{
            lObjSel=lstHQs
        }
       // lObjSel=lstHQs
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Headquarter"
        openWin(Mode: "HQ")
    }
    @objc private func selDistributor() {
        isMulti=false
        if UserSetup.shared.tpDcrDeviationNeed == 0 && !switchDeviate.isOn{
            let code = self.tpDatas.tp.first?.Worked_with_Code.string ?? ""
            
            lObjSel=lstDist.filter{($0["id"] as? Int ?? 0) == Int(code)}
        }else {
            lObjSel=lstDist
        }
        
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Distributor"
        openWin(Mode: "DIS")
    }
    
    @objc private func selRoutes() {
        isMulti=false
        if UserSetup.shared.tpDcrDeviationNeed == 0 && !switchDeviate.isOn{
            
            let code = self.tpDatas.tp.first?.RouteCode.string ?? ""
            
            lObjSel = lstRoutes.filter{code.contains((String(format: "%@", $0["id"] as! CVarArg)))}
        }else {
            lObjSel=lstRoutes
        }
        
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Route"
        openWin(Mode: "RUT")
    }
    @objc private func selJointWK() {
        isMulti=true
        if UserSetup.shared.tpDcrDeviationNeed == 0 && !switchDeviate.isOn{

            let code = self.tpDatas.tp.first?.JointWork_Name.string ?? ""
            lObjSel=lstJoint.filter{code.contains((String(format: "%@", $0["id"] as! CVarArg)))}
        }else {
            lObjSel=lstJoint
        }
        
        strSelJWCd=strJWCd
        strSelJWNm=strJWNm
        lstSelJWNms=lstJWNms
        tbDataSelect.reloadData()
        lblSelTitle.text="Select the Jointwork"
        openWin(Mode: "JWK")
    }
    @objc private func delJWK(_ sender: UITapGestureRecognizer){
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
        Setval.isHidden = true
        if (Mode == "JWK"){
            Setval.isHidden = false
        }
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
            if UserSetup.shared.DistBased == 1 || UserSetup.shared.DistBased == 2{
            if (myDyTp["DIS"]?.id ?? "") == "" {
                Toast.show(message: "Select the Distributor", controller: self)
                return false
            }
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
    
    
    @IBAction func deviateAction(_ sender: UISwitch) {
      //  self.tpDeviation()
        
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbDeviationRemarks") as!  DeviationRemarks
        vc.tpDatas = self.tpDatas
        vc.isDeviationOn = { isenabled in
            self.switchDeviate.isOn = isenabled
            
            if isenabled == true {
                self.tpDeviation()
            }
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func SaveMyDayPlan(_ sender: Any) {
        print(HomePageViewController.selfieLoginActive)
        print(PhotosCollection.shared.PhotoList.count)
        if (HomePageViewController.selfieLoginActive == 1){
            if(PhotosCollection.shared.PhotoList.count>0){
               print("In Data")
            }else{
                if UserSetup.shared.Selfie == 1{
                    if Leaveid != "L"{
                        if validateForm() == false {
                            return
                        }
                        openCamera()
                    }
                   
                }
                if UserSetup.shared.Selfie == 0{
                    getLocatio()
                }
            }
                if(PhotosCollection.shared.PhotoList.count>0){
                    for i in 0...PhotosCollection.shared.PhotoList.count-1{
                        let item: [String: Any] = PhotosCollection.shared.PhotoList[i] as! [String : Any]
                        print(item["FileName"]  as! String)
                        let sep = item["FileName"]  as! String
                        let fullNameArr = sep.components(separatedBy: "_")
                        
                        let phono = fullNameArr[2]
                        var fullid = "_\(phono)"
                        print(fullid)
                        ImgName = ",\"profilepic\":{\"imgurl\":\"\(fullid)\"}"
                        getLocatio()
                
                    }
                }
            
            if (Leaveid == "L" && PhotosCollection.shared.PhotoList.count == 0 ){
                getLocatio()
            }
                print("My Day Plan Not Sumbite")
        }else{
           //openCamera()
            print(Leaveid)
            getLocatio()
            print("My Day Plan Sumbite")
        }
       /* */
    }
    func getLocatio(){
        var OrderSub = "MyDay"
        var Count = 0
        let Leavtyp = leavWorktype
        if Leaveid != "L"{
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
                Count = Count+1
                if (OrderSub == "MyDay"){
                    self.saveDayTP(location: location)
                    OrderSub  = ""
                    print(Count)
                }else{
                    print(Count)
                }
            }, error:{ errMsg in
                self.LoadingDismiss()
                print (errMsg)
                let alert = UIAlertController(title: "Information", message: errMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                    return
                })
                
            })
        }else{
            LocalStoreage.set("1", forKey: "attendanceView")
            let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
            let myDyPln = storyboard.instantiateViewController(withIdentifier: "sbLeaveFrm") as! LeaveForm
            self.navigationController?.pushViewController(myDyPln, animated: true)
            UIApplication.shared.windows.first?.rootViewController = navigationController
        }
    }
    
    func tpDeviation() {
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"get/tpdetails&sfCode=\(SFCode)&rSF=\(SFCode)&divisionCode=\(DivCode)").validate(statusCode: 200..<209).responseData { AFData in
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                
                do {
                    let objects = try JSON(data: AFData.data!)
                    
                    print(objects)
                
                    self.tpDatas = objects
                    let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                    
                    if objects.tp.isEmpty && (UserSetup.shared.tpNeed == 1 || UserSetup.shared.tpDcrDeviationNeed == 0){
                        let tpMnuVc = storyboard.instantiateViewController(withIdentifier: "sbAdminMnu") as! AdminMenus
                        let trPln = storyboard.instantiateViewController(withIdentifier: "sbTourPlanCalenderScreen") as! TourPlanCalenderScreen
                        trPln.date = Date()
                        trPln.isBackEnabled = false
                        viewController.setViewControllers([tpMnuVc,trPln], animated: false)
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
                        return
                    }
                    
                    var status = 0
                    
                    guard let statusVal = objects.status.first?.Status.int else{
                        self.vwDeviationCtrl.isHidden = false
                        self.vwRejectReason.isHidden = true
                        
                        self.switchDeviate.isOn = false
                        let fwflg = self.myDyTp["WT"]?.FWFlg ?? ""
                        if fwflg != "F" {
                            self.vwMainScroll.contentSize = CGSize(width: self.vwContent.frame.width, height: 650)
                        }else{
                            self.vwMainScroll.contentSize = CGSize(width: self.vwContent.frame.width, height: 1000)
                        }
                        // self.vwMainScroll.contentSize = CGSize(width: self.vwContent.frame.width, height: 850)
                        return
                    }
                    status = statusVal
                    
                    if status != 6 {
                        self.vwDeviationCtrl.isHidden = true
                        self.switchDeviate.isOn = true
                        self.vwRejectReason.isHidden = true
                        
                    }else {
                        
                        let reason = (objects.status.first?.reject_reason.string ?? "")
                        
                        if reason != ""{
                            self.lblRejectReason.text = "Reject Reason: " + (objects.status.first?.reject_reason.string ?? "")
                        }else {
                            self.lblRejectReason.text = ""
                        }
                        
                      
                    }
                    
                    if objects.status.isEmpty {
                        status = 0
                    }
                    
                    if status == 3 {
                        self.vwDeviationLock.isHidden = false
                        return
                    }else {
                        self.vwDeviationLock.isHidden = true
                       // self.switchDeviate.isOn = true
                    }
                    
                    if !objects.tp.isEmpty && (status == 0 || status == 6){
                        self.vwDeviationCtrl.isHidden = false
                        self.vwRejectReason.isHidden = false
                        self.switchDeviate.isOn = false
                        
                        let fwflg = self.myDyTp["WT"]?.FWFlg ?? ""
                        
                        if fwflg != "F" {
                            self.vwMainScroll.contentSize = CGSize(width: self.vwContent.frame.width, height: 750)
                        }else{
                            self.vwMainScroll.contentSize = CGSize(width: self.vwContent.frame.width, height: 1000)
                        }
                        
                    }else {
                        self.vwMainScroll.contentSize = CGSize(width: self.vwContent.frame.width, height: 750)
                    } // || status == 6)
                    
                }catch {
                    print("error")
                }
                
                
                
                
//                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data!, options: JSONSerialization.ReadingOptions.allowFragments)
//
//                print(apiResponse)
//
//                guard let response = apiResponse as? AnyObject else {
//                    return
//                }
//                print(response)
//
//                guard let tpResponse = response["tp"] as? [AnyObject] else{
//                    return
//                }
//                guard let statusResponse = response["status"] as? [AnyObject] else{
//                    return
//                }
//                print("Ggg")
//                print(statusResponse)
//                print("first")
//
//                self.tpData = tpResponse.first
//
//
//                print(tpResponse.first)
//
//                print(self.tpData)
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    func saveDayTP(location: CLLocation){
        if (VisitData.shared.VstRemarks.name == "Enter the Remarks"){
            VisitData.shared.VstRemarks.name = ""
        }
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
            let JointData = strJWCd
            var Join_Works = JointData.replacingOccurrences(of: ";", with: "$$")
            if Join_Works.hasSuffix("$") {
//                while Join_Works.hasSuffix("$$") {
//                    Join_Works.removeLast()
//                }
                Join_Works.removeLast()
                print(Join_Works)
            }
            var remarks:String = ""
            if let trimmedText = txRem.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                
                print(trimmedText)
                remarks = trimmedText
            }
            if (remarks == "Enter the Remarks"){
                remarks = ""
            }
            print(myDyTp)
            let jsonString = "[{\"tbMyDayPlan\":{\"wtype\":\"'" + (myDyTp["WT"]?.id ?? "") + "'\",\"sf_member_code\":\"'" + (myDyTp["HQ"]?.id ?? SFCode) + "'\",\"stockist\":\"'" + (myDyTp["DIS"]?.id ?? "") + "'\",\"stkName\":\"" + (myDyTp["DIS"]?.name ?? "") + "\",\"dcrtype\":\"App\",\"cluster\":\"'" + (myDyTp["RUT"]?.id ?? "") + "'\",\"custid\":\"" + (myDyTp["RUT"]?.id ?? "") + "\",\"custName\":\"" + (myDyTp["RUT"]?.name ?? "") + "\",\"address\":\"" + sAddress + "\",\"remarks\":\"'" + (remarks) + "'\",\"OtherWors\":\"\",\"FWFlg\":\"'" + (myDyTp["WT"]?.FWFlg ?? "") + "'\",\"SundayWorkigFlag\":\"''\",\"Place_Inv\":\"\",\"WType_SName\":\"" + (myDyTp["WT"]?.name ?? "") + "\",\"ClstrName\":\"'" + (myDyTp["RUT"]?.name ?? "") + "'\",\"AppVersion\":\"Vi_\(Bundle.main.appVersionLong).\(Bundle.main.appBuild)\",\"self\":1,\"location\":\"" + slocation + "\",\"dcr_activity_date\":\"'" + dateString + "'\",\"worked_with\":\"'\(Join_Works)'\"\(ImgName)}}]"
       // let jsonString: String = ""
        //AppVersion\":\"Vi1.1.0\

        let params: Parameters = [
            "data": jsonString //"["+jsonString+"]"
        ]
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode="+self.DivCode+"&rSF="+self.SFCode+"&sfCode="+self.SFCode)
        print(params)
            print(self.SFCode) // APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode="+self.DivCode+"&rSF="+self.SFCode+"&sfCode="+self.SFCode
            // http://fmcg.sanfmcg.com/server/native_Db_V13- `  1q.php?axn=dcr/save&divisionCode=29,&rSF=MR4126&sfCode=MR4126
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"dcr/save&divisionCode="+self.DivCode+"&rSF="+self.SFCode+"&sfCode="+self.SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            self.LoadingDismiss()
            switch AFdata.result {
            case .success(let value):
                print(value)
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
                        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
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
                                let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
                                if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
                                    lstPlnDetail = list;
                                }
                                   let LocalStoreage = UserDefaults.standard
                                   LocalStoreage.set(prettyPrintedJson, forKey: "Mydayplan")
                                print(prettyPrintedJson)
                                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                                    UIApplication.shared.windows.first?.rootViewController = viewController
                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                if let flag = myDyTp["WT"]?.FWFlg {
                                    if flag == "W" || flag == "L" || flag == "H" {
                                        print(flag)
                                        LocalStoreage.set("1", forKey: "attendanceView")
                                    }
                                    
                                }

                                   
                                    LocalStoreage.set("1", forKey: "dayplan")
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
    @objc private func openCamera(){
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "PhotoGallary") as!  PhotoGallary

        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}
