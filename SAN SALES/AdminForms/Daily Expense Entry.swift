//
//  Daily Expense Entry.swift
//  SAN SALES
//
//  Created by San eforce on 13/03/24.
//

import UIKit
import MobileCoreServices
import Alamofire
class Daily_Expense_Entry: IViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var ButtonBack: UIImageView!
    @IBOutlet weak var Add_Hotal_Bill: UIImageView!
    @IBOutlet var blureView: UIVisualEffectView!
    @IBOutlet var PopUpView: UIView!
    @IBOutlet weak var SelWindo: UIView!
    @IBOutlet weak var Close_Sel_Windo: UIImageView!
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var paperclip: UIImageView!
    @IBOutlet weak var eye: UIImageView!
    @IBOutlet weak var Photo_List: UITableView!
    @IBOutlet var PopUpView2: UIView!
    @IBOutlet weak var Daily_Exp_Cam: UIImageView!
    @IBOutlet weak var Daily_Exp_photos: UIImageView!
    @IBOutlet var IMG_Scr: UIView!
    @IBOutlet weak var imgs: UICollectionView!
    @IBOutlet weak var Set_Date: LabelSelectWithout!
    @IBOutlet weak var SetWork_Typ: LabelSelectWithout!
    @IBOutlet weak var Set_work_plc: LabelSelectWithout!
    @IBOutlet weak var Allo_Typ: LabelSelect!
    @IBOutlet weak var From_Text: EditTextField!
    @IBOutlet weak var To_Text: EditTextField!
    @IBOutlet weak var DropDown: UIView!
    @IBOutlet weak var Drop_Down_Title: UILabel!
    @IBOutlet weak var Search_lbl: UITextField!
    @IBOutlet weak var sel_TB: UITableView!
    @IBOutlet weak var Stayingtyp: LabelSelect!
    @IBOutlet weak var Scrollview: UIScrollView!
    @IBOutlet weak var Scrollview_Height: NSLayoutConstraint!
    @IBOutlet weak var Main_Scrollview_Height: NSLayoutConstraint!
    @IBOutlet weak var sub_Scrollview: UIView!
    @IBOutlet weak var Travel_Det: UIView!
    @IBOutlet weak var Travel_Det_Height: NSLayoutConstraint!
    @IBOutlet weak var Allowance_type: UIView!
    @IBOutlet weak var Enter_KM: UIView!
    @IBOutlet weak var Enter_KM_hig: NSLayoutConstraint!
    @IBOutlet weak var Staying_typ: UIView!
    @IBOutlet weak var Staying_typ_hig: NSLayoutConstraint!
    @IBOutlet weak var Bill_Amount_view: UIView!
    @IBOutlet weak var Bill_Amount_view_hig: NSLayoutConstraint!
    @IBOutlet weak var Hotal_Bill_Img_View: UIView!
    @IBOutlet weak var Hotal_Bill_Img_View_hig: NSLayoutConstraint!
    @IBOutlet weak var Daily_EX_Head: UILabel!
    @IBOutlet weak var Daily_Expense_TB: UITableView!
    @IBOutlet weak var Daily_Expense_TB_hig: NSLayoutConstraint!
    
    
    @IBOutlet weak var Mod_Of_Travel: UIView!
    @IBOutlet weak var Mod_of_travel_height: NSLayoutConstraint!
    @IBOutlet weak var Select_Mod_of_Travel: LabelSelect!
    
    @IBOutlet weak var CloseBt: UILabel!
    @IBOutlet weak var Travemoad_View: UIView!
    @IBOutlet weak var Sta_Km_View: UIView!
    @IBOutlet weak var Tot_Km_View: UIView!
    @IBOutlet weak var Calim_Km_View: UIView!
    @IBOutlet weak var Calim_Amt_View: UIView!
    @IBOutlet weak var Travel_Mod: UILabel!
    @IBOutlet weak var Starting_KM: UILabel!
    @IBOutlet weak var eND_KM: UILabel!
    @IBOutlet weak var Tota_KM: UILabel!
    @IBOutlet weak var Per_KM: UILabel!
    @IBOutlet weak var cALIM_KM: UILabel!
    @IBOutlet weak var Pers_KM: UILabel!
    @IBOutlet weak var Claim_Amt: UILabel!
    @IBOutlet weak var EnterKM: EditTextField!
    @IBOutlet weak var Enter_Bill_Amount: EditTextField!
    @IBOutlet weak var KM_TIT: UILabel!
    
    
    @IBOutlet weak var Start_Km_Img: UIImageView!
    @IBOutlet weak var End_Km_Img: UIImageView!
    @IBOutlet weak var Edit_Km: UIImageView!
    
    @IBOutlet weak var Image_Sc: UIView!
    @IBOutlet weak var Image_View: UIImageView!
    @IBOutlet weak var Image_Sc_Close: UIButton!
    @IBOutlet weak var From_Km_Text: UITextField!
    @IBOutlet weak var To_Km_Text: UITextField!
    
    
    
    @IBOutlet var Edit_Km_sc: UIView!
    @IBOutlet weak var Edit_Save_BT: UIButton!
    
    
    struct exData:Codable{
    let id:String
    let name:String
    let newname:String
    let StEndNeed:Int
    let farset:Int
    }
    struct Pho_ND:Any{
        let ID : Int
        let Name:String
        let Photo_Mandatory:Int
        var Photo_Nd:Int
        var remark:String
        var amount:String
        var image:[UIImage]
        var image_name:[String]
    }
    struct Bill_Photo:Any{
        let imgurl:String
        var title:String
        var remarks:String
        let img:UIImage
    }
    struct Expense_New:Any{
            var WorkType : String
        var mydayplanWorkPlace:String
        var Routename:String
        var Enterdate:String
        var KM:String
        var Billamount:String
        var HQ:String
        var stayingtype:String
        var MOT:String
        var mot_id:String
        let st_endNeed:String
        var max_km:String
        var fuel_charge:Double
        let exp_km:String
        let exp_amount:String
        var TotalAmount:String
        var Toworkplace:String
        var period_name:String
        var period_id:String
        var from_date:String
        var to_date:String
        var srt_km:String
        var end_km:String
        var exp_auto:Int
        var exp_process_type:String
        var fare:String
    }
    var imagePicker = UIImagePickerController()
    var images: [UIImage] = []
    var bus:[UIImage] = []
    var food:[UIImage] = []
    var snk:[UIImage] = []
    let LocalStoreage = UserDefaults.standard
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    var SelMod = ""
    var day_Plan:[AnyObject]?
    var PeriodicData:[AnyObject]?
    var ExpEditNeed:Int?
    var set_Date:String?
    var Exp_Data:[exData] = []
    var Exp_Datas:[exData]=[]
    var Needs_Entry:[Pho_ND]=[]
    var scroll_hig:Double = 0
    var Select_index_row:Int = 0
    var Bill_photo_Ned:[Bill_Photo] = []
    var Expense_data:[Expense_New] = []
    var Select_index_Del:Int = 0
    var select_allow:String = ""
    var StEndNeed:Int = 0
    var farset:Int = 0
    var need_mode_of_trav = 0
    var st_Km_Img:URL?
    var Ed_Km_Img:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Expense_data.append(Expense_New(WorkType: "", mydayplanWorkPlace: "", Routename: "", Enterdate: "", KM: "0", Billamount: "", HQ: "", stayingtype: "0", MOT: "", mot_id: "", st_endNeed: "", max_km: "", fuel_charge: 0, exp_km: "", exp_amount: "", TotalAmount: "", Toworkplace: "", period_name: "", period_id: "", from_date: "", to_date: "", srt_km: "", end_km: "", exp_auto: UserSetup.shared.exp_auto, exp_process_type: "\(UserSetup.shared.exp_process_type)",fare:""))
        getUserDetails()
        blureView.bounds = self.view.bounds
        PopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.2)
        PopUpView.layer.cornerRadius = 10
        
        Edit_Km_sc.layer.cornerRadius = 10
    
        Photo_List.delegate = self
        Photo_List.dataSource = self
        Daily_Expense_TB.delegate = self
        Daily_Expense_TB.dataSource = self
        sel_TB.delegate = self
        sel_TB.dataSource = self
        imgs.dataSource = self
        imgs.delegate = self
        
        From_Text.returnKeyType = .done
        To_Text.returnKeyType = .done
        From_Text.delegate = self
        To_Text.delegate = self
    
        EnterKM.keyboardType = UIKeyboardType.numberPad
        EnterKM.returnKeyType = .done
        EnterKM.delegate = self
    
        Enter_Bill_Amount.keyboardType = UIKeyboardType.numberPad
        Enter_Bill_Amount.returnKeyType = .done
        Enter_Bill_Amount.delegate = self
        
        scroll_hig =  sub_Scrollview.frame.size.height
        ButtonBack.addTarget(target: self, action: #selector(GotoHome))
        Add_Hotal_Bill.addTarget(target: self, action: #selector(imageTapped))
        Close_Sel_Windo.addTarget(target: self, action: #selector(Close_Wind))
        camera.addTarget(target: self, action: #selector(Camra))
        Daily_Exp_Cam.addTarget(target: self, action: #selector(Camra))
        paperclip.addTarget(target: self, action: #selector(Add_Pho))
        eye.addTarget(target: self, action: #selector(View_Photo))
        Daily_Exp_photos.addTarget(target: self, action: #selector(Add_Pho))
        Allo_Typ.addTarget(target: self, action: #selector(openAllowance))
        
        Select_Mod_of_Travel.addTarget(target: self, action: #selector(open_Mod_Of_Travel))
        
        Stayingtyp.addTarget(target: self, action: #selector(openStaying_Typ))
        CloseBt.addTarget(target: self, action: #selector(CloseImag))
        EnterKM.addTarget(self, action: #selector(self.changeQty(_:)), for: .editingChanged)
        
        Start_Km_Img.addTarget(target: self, action: #selector(Start_Km_Img_View))
        End_Km_Img.addTarget(target: self, action: #selector(End_Km_Img_View))
        
        Edit_Km.addTarget(target: self, action: #selector(Edit_Km_Scr))
        
        print(ExpEditNeed)
        if let Editimg = ExpEditNeed, Editimg != 1 {
            Edit_Km.isHidden = false
        } else {
            Edit_Km.isHidden = true
        }
        
        set_form()
        travel_data(date: set_Date!)
        DAExp_ND()
//        Enter_KM.isHidden = true
//        Enter_KM_hig.constant = 0
        //let Enter_KM_h = Enter_KM.frame.size.height
        Staying_typ.isHidden = true
        Staying_typ_hig.constant = 0
        let Staying_typ_h = Staying_typ.frame.size.height
        Bill_Amount_view.isHidden = true
        Bill_Amount_view_hig.constant = 0
        let Bill_Amount_view_h = Bill_Amount_view.frame.size.height
        Hotal_Bill_Img_View.isHidden = true
        Hotal_Bill_Img_View_hig.constant = 0
        let Hotal_Bill_Img_View_h = Hotal_Bill_Img_View.frame.size.height
        let Mod_Of_Travel_h = Mod_Of_Travel.frame.size.height
        print(scroll_hig)
        scroll_hig = scroll_hig - (Staying_typ_h + Bill_Amount_view_h + Hotal_Bill_Img_View_h + Mod_Of_Travel_h)
        print(scroll_hig)
        Scrollview_Height.constant = scroll_hig //+ 100
        Main_Scrollview_Height.constant = scroll_hig
        
        if (UserSetup.shared.SrtEndKMNd > 0){
            Mod_of_travel_height.constant = 0
            Mod_Of_Travel.isHidden = true
        }
        
        if let data = PeriodicData as? [PeriodicData] {
            for periodicData in data {
                    let from_date = "\(periodicData.Eff_Year)-\(periodicData.Eff_Month)-\(periodicData.From_Date)"
                    var  To_date = ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let from_date = dateFormatter.date(from: from_date) {
                        if periodicData.To_Date == "end of month" {
                            let calendar = Calendar.current
                            if let monthRange = calendar.range(of: .day, in: .month, for: from_date) {
                                print(monthRange)
                                let lastDayOfMonth = monthRange.upperBound - 1
                                if let lastDateOfMonth = calendar.date(bySetting: .day, value: lastDayOfMonth, of: from_date) {
                                    print("Last date of the month: \(lastDateOfMonth)")
                                    print(lastDateOfMonth)
                                    let formatters = DateFormatter()
                                    formatters.dateFormat = "yyyy-MM-dd"
                                    To_date = formatters.string(from: lastDateOfMonth)
                                }
                            }
                        } else {
                             To_date = "\(periodicData.Eff_Year)-\(periodicData.Eff_Month)-\(periodicData.To_Date)"
                        }
                    } else {
                        print("Error: Unable to convert from_date string to Date.")
                    }
               print(To_date)
                Expense_data[0].from_date = from_date
                Expense_data[0].to_date = To_date
                Expense_data[0].period_id = periodicData.Period_Id
                Expense_data[0].period_name = periodicData.Period_Name
            }
        }
        Start_Km_Img.isHidden = true
        End_Km_Img.isHidden = true
        
        
        Image_Sc_Close.layer.cornerRadius = 10
        let shadowPath = UIBezierPath(roundedRect: Image_Sc_Close.bounds, cornerRadius: 10)
        Image_Sc_Close.layer.masksToBounds = false
        var shadowColor: UIColor? = UIColor.black
        Image_Sc_Close.layer.shadowColor = shadowColor?.cgColor
        Image_Sc_Close.layer.shadowOffset = CGSize(width: 0, height: 3);
        Image_Sc_Close.layer.shadowOpacity = 0.5
        Image_Sc_Close.layer.shadowPath = shadowPath.cgPath
        
        
        
        Edit_Save_BT.layer.cornerRadius = 10
        let shadowPaths = UIBezierPath(roundedRect: Edit_Save_BT.bounds, cornerRadius: 10)
        Edit_Save_BT.layer.masksToBounds = false
        var shadowColors: UIColor? = UIColor.black
        Edit_Save_BT.layer.shadowColor = shadowColors?.cgColor
        Edit_Save_BT.layer.shadowOffset = CGSize(width: 0, height: 3);
        Edit_Save_BT.layer.shadowOpacity = 0.5
        Edit_Save_BT.layer.shadowPath = shadowPaths.cgPath
        
        APIClient.shared.imgurl = "\(APIClient.shared.BaseURL)/Photos/"
    }
    func getUserDetails(){
    let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
    let data = Data(prettyPrintedJson!.utf8)
    guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
    print("Error: Cannot convert JSON object to Pretty JSON data")
    return
    }
        print(prettyJsonData)
    SFCode = prettyJsonData["sfCode"] as? String ?? ""
    StateCode = prettyJsonData["State_Code"] as? String ?? ""
    DivCode = prettyJsonData["divisionCode"] as? String ?? ""
    Desig=prettyJsonData["desigCode"] as? String ?? ""
        
        
    }
    
    func set_form(){
        Set_Date.text = set_Date
        if let settyp = day_Plan{
            print(Expense_data)
            print(settyp)
            SetWork_Typ.text = settyp[0]["WorkType"] as? String ?? ""
            Set_work_plc.text = settyp[0]["ClstrName"] as? String ?? ""
            Expense_data[0].WorkType = settyp[0]["WorkType"] as? String ?? ""
            Expense_data[0].mydayplanWorkPlace = settyp[0]["ClstrName"] as? String ?? ""
            Expense_data[0].Enterdate = set_Date!
            //Allo_Typ.text = settyp[0]["Allowance_Type"] as? String
        }
    }
    func animateIn(desiredView: UIView){
        let  backGroundView = self.view
        backGroundView?.addSubview(desiredView)
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center=backGroundView!.center
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }
    func animateOut(desiredView:UIView){
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        },completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(SelMod)
            if (SelMod == "Cam"){
                var images_name: [String] = []
                images = Needs_Entry[Select_index_row].image
                images_name = Needs_Entry[Select_index_row].image_name
                images.append(pickedImage)
                let fileName: String = String(Int(Date().timeIntervalSince1970))
                let filenameno="\(fileName).jpg"
                print(filenameno)
                images_name.append(filenameno)
                Needs_Entry[Select_index_row].image_name = images_name
                Needs_Entry[Select_index_row].image = images
                Daily_Expense_TB.reloadData()
                animateOut(desiredView:blureView)
                animateOut(desiredView:PopUpView2)
            }else if (SelMod == "Bill_Pho"){
                let fileName: String = String(Int(Date().timeIntervalSince1970))
                let filenameno="\(fileName).jpg"
                Bill_photo_Ned.append(Bill_Photo(imgurl: filenameno, title: "", remarks: "", img: pickedImage))
                print(Bill_photo_Ned)
                Photo_List.reloadData()
                SelWindo.isHidden = false
                animateOut(desiredView:blureView)
                animateOut(desiredView:PopUpView)
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snk.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        print(snk)
        cell.imgProduct.image = snk[indexPath.row]
        cell.Del_Img.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Delet_Img(sender:)))
        cell.Del_Img.isUserInteractionEnabled = true
        cell.Del_Img.addGestureRecognizer(tapGesture)
        return cell
    }
    
    @objc func Delet_Img(sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        snk.remove(at: view.tag)
        Needs_Entry[Select_index_Del].image = snk
        imgs.reloadData()
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Photo_List == tableView{
            return 100
        }else if (Daily_Expense_TB == tableView){
            return 100
        }
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sel_TB == tableView{
            return Exp_Datas.count
        }
        if Photo_List == tableView{
            return Bill_photo_Ned.count
        }
        if Daily_Expense_TB == tableView {
            return Needs_Entry.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
       
        if Photo_List == tableView{
            print(Bill_photo_Ned)
            cell.Image_View.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            cell.Image_View.image = Bill_photo_Ned[indexPath.row].img
            cell.Enter_Rmk.returnKeyType = .done
            cell.Enter_Title.returnKeyType = .done
            cell.Enter_Rmk.delegate = self
            cell.Enter_Title.delegate = self
            cell.Enter_Title.addTarget(self, action: #selector(self.Rem_Tit_Bill(_:)), for: .editingChanged)
            cell.Enter_Rmk.addTarget(self, action: #selector(self.Rem_Text_Bill(_:)), for: .editingChanged)
            cell.Delet_Pho.tag = indexPath.row
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Img_Tap(sender:)))
            cell.Delet_Pho.isUserInteractionEnabled = true
            cell.Delet_Pho.addGestureRecognizer(tapGesture)
            
        }else if (sel_TB == tableView){
            cell.lblText.text = Exp_Datas[indexPath.row].name
            Search_lbl.returnKeyType = .done
            Search_lbl.delegate = self
        }else if (Daily_Expense_TB == tableView){
            let item = Needs_Entry[indexPath.row]
            cell.lblText.text = Needs_Entry[indexPath.row].Name
            print(Needs_Entry)
            if item.Photo_Nd == 0 {
                cell.Cam.isHidden = true
            }else{
                cell.Cam.isHidden = false
            }
            if item.remark == "" {
                cell.Enter_Rmk.placeholder = "Remarks"
                cell.Enter_Rmk.text = ""
            }else{
                print(item.remark)
                cell.Enter_Rmk.text = item.remark
            }
            if item.amount == "" {
                //cell.Ent_Amt.text = "0"
                cell.Ent_Amt.placeholder = "Amount"
                cell.Ent_Amt.text = ""
            }else{
                print(item.amount)
                cell.Ent_Amt.text = item.amount
            }
            if item.image.isEmpty{
                cell.Image_View.isHidden = true
            }else{
                cell.Image_View.isHidden = false
                cell.Image_View.image = item.image.first
            }
            
            cell.Enter_Rmk.addTarget(self, action: #selector(self.Rem_Text(_:)), for: .editingChanged)
            cell.Enter_Rmk.returnKeyType = .done
            cell.Enter_Rmk.delegate = self
            cell.Ent_Amt.addTarget(self, action: #selector(self.Amt_Text(_:)), for: .editingChanged)
            cell.Ent_Amt.keyboardType = UIKeyboardType.numberPad
            cell.Ent_Amt.returnKeyType = .done
            cell.Ent_Amt.delegate = self
            cell.Cam.tag = indexPath.row
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(alertClicked(sender:)))
            cell.Cam.isUserInteractionEnabled = true
            cell.Cam.addGestureRecognizer(tapGesture)
            
            cell.Image_View.tag = indexPath.row
            let tapimg = UITapGestureRecognizer(target: self, action: #selector(Click_Cam_img(sender:)))
            cell.Image_View.isUserInteractionEnabled = true
            cell.Image_View.addGestureRecognizer(tapimg)
        }
        return cell
    }
    @objc private func Rem_Text(_ txtQty: UITextField){
        let cell: cellListItem = GlobalFunc.getTableViewCell(view: txtQty) as! cellListItem
        let tbView:UITableView = GlobalFunc.getTableView(view: txtQty)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        let Remark: String = cell.Enter_Rmk.text ?? ""
        Needs_Entry[indxPath.row].remark = Remark
    }
    @objc private func Amt_Text(_ txtQty: UITextField){
        let cell: cellListItem = GlobalFunc.getTableViewCell(view: txtQty) as! cellListItem
        let tbView:UITableView = GlobalFunc.getTableView(view: txtQty)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        let Amt: String = cell.Ent_Amt.text ?? ""
        Needs_Entry[indxPath.row].amount = Amt
    }
    @objc func alertClicked(sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        if Needs_Entry[view.tag].amount == ""{
            return Toast.show(message: "Please enter the amount first.")
        }
        SelMod = "Cam"
        Select_index_row = view.tag
        OpenpopUp()
    }
    
    @objc func Click_Cam_img(sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        Select_index_Del = view.tag
        snk=Needs_Entry[view.tag].image
        imgs.reloadData()
        openImag()
    }
    @objc private func Rem_Tit_Bill(_ txtQty: UITextField){
        let cell: cellListItem = GlobalFunc.getTableViewCell(view: txtQty) as! cellListItem
        let tbView:UITableView = GlobalFunc.getTableView(view: txtQty)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        let Remark_Tit: String = cell.Enter_Title.text ?? ""
        Bill_photo_Ned[indxPath.row].title = Remark_Tit
    }
    
    @objc private func Rem_Text_Bill(_ txtQty: UITextField){
        let cell: cellListItem = GlobalFunc.getTableViewCell(view: txtQty) as! cellListItem
        let tbView:UITableView = GlobalFunc.getTableView(view: txtQty)
        let indxPath: IndexPath = tbView.indexPath(for: cell)!
        let Remark: String = cell.Enter_Rmk.text ?? ""
        Bill_photo_Ned[indxPath.row].remarks = Remark
    }
    @objc func Img_Tap(sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        Bill_photo_Ned.remove(at: view.tag)
        Photo_List.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = Exp_Datas[indexPath.row]
        print(item)
        if (SelMod == "Allowance"){
            print(item)
            select_allow = item.name
            Expense_data[0].HQ = item.newname
            if item.name == "OS" || item.name == "EX" {
                Stayingtyp.text = "Select Type"
                Staying_typ.isHidden = false
                Staying_typ_hig.constant = 80
                scroll_hig = scroll_hig + 80
                Scrollview_Height.constant = scroll_hig
                Main_Scrollview_Height.constant = scroll_hig
                
            }else{
                Stayingtyp.text = "Select Type"
                Staying_typ.isHidden = true
                Staying_typ_hig.constant = 0
                let Staying_typ_h = Staying_typ.frame.size.height
                Bill_Amount_view.isHidden = true
                Bill_Amount_view_hig.constant = 0
                let Bill_Amount_view_h = Bill_Amount_view.frame.size.height
                Hotal_Bill_Img_View.isHidden = true
                Hotal_Bill_Img_View_hig.constant = 0
                let Hotal_Bill_Img_View_h = Hotal_Bill_Img_View.frame.size.height
                scroll_hig = scroll_hig - (Staying_typ_h + Bill_Amount_view_h + Hotal_Bill_Img_View_h)
                Scrollview_Height.constant = scroll_hig
                Main_Scrollview_Height.constant = scroll_hig
            }
            Allo_Typ.text = item.name
            set_data_TB(openMod: "Travel")
        }else if (SelMod == "Staying"){
             Expense_data[0].stayingtype = item.id
            if item.name == "With Hotel"{
                Bill_Amount_view.isHidden = false
                Bill_Amount_view_hig.constant = 80
                scroll_hig = scroll_hig + 80
                Hotal_Bill_Img_View.isHidden = false
                Hotal_Bill_Img_View_hig.constant = 80
                scroll_hig = scroll_hig + 80
                Scrollview_Height.constant = scroll_hig
                Main_Scrollview_Height.constant = scroll_hig
            }else{
                Bill_Amount_view.isHidden = true
                Bill_Amount_view_hig.constant = 0
                let Bill_Amount_view_h = Bill_Amount_view.frame.size.height
                Hotal_Bill_Img_View.isHidden = true
                Hotal_Bill_Img_View_hig.constant = 0
                let Hotal_Bill_Img_View_h = Hotal_Bill_Img_View.frame.size.height
                scroll_hig = scroll_hig - (Bill_Amount_view_h + Hotal_Bill_Img_View_h)
                Scrollview_Height.constant = scroll_hig
                Main_Scrollview_Height.constant = scroll_hig
            }
            Stayingtyp.text = item.name
        }else if (SelMod == "Travel"){
            print(item)
            Select_Mod_of_Travel.text = item.name
            Expense_data[0].MOT = item.name
            Expense_data[0].mot_id = item.id
            StEndNeed = item.StEndNeed
            farset = item.farset
            if (item.StEndNeed == 1){
                EnterKM.placeholder = "Enter the KM"
                KM_TIT.text = "KM"
            }else if (item.StEndNeed == 0){
                EnterKM.placeholder = "Enter the fare amount"
                KM_TIT.text = "Fare"
            }
            EnterKM.text = ""
        }
        self.resignFirstResponder()
        Search_lbl.text = ""
        DropDown.isHidden = true
    }
 
    @objc func imageTapped() {
        SelMod = "Bill_Pho"
        animateIn(desiredView:blureView)
        animateIn(desiredView:PopUpView)
    }
    @IBAction func ClosePopUP(_ sender: Any) {
        animateOut(desiredView:blureView)
        animateOut(desiredView:PopUpView)
        animateOut(desiredView:PopUpView2)
    }
    @objc private func Camra(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func Add_Pho(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    @objc private func View_Photo(_ sender: Any) {
        if Bill_photo_Ned.isEmpty{
            Toast.show(message: "Please Select Hotel Bill")
            return
        }
        SelWindo.isHidden = false
        animateOut(desiredView:blureView)
        animateOut(desiredView:PopUpView)
    }
    @objc private func Close_Wind() {
        view.endEditing(true)
        SelWindo.isHidden = true
    }
    @objc private func GotoHome() {
        VisitData.shared.Nav_id = 1
        self.resignFirstResponder()
   
        self.navigationController?.popViewController(animated: true)
        return
       
    }
    @objc private func OpenpopUp() {
        animateIn(desiredView:blureView)
        animateIn(desiredView:PopUpView2)
    }
    @objc private func openImag() {
        animateIn(desiredView:blureView)
        animateIn(desiredView:IMG_Scr)
    }
    @objc private func CloseImag() {
        Daily_Expense_TB.reloadData()
        animateOut(desiredView:blureView )
        animateOut(desiredView:IMG_Scr)
    }
    @objc private func openAllowance(){
        Drop_Down_Title.text = "Select Allowance Type"
        DropDown.isHidden = false
        SelMod = "Allowance"
        Select_Mod_of_Travel.text = "Select Mode of Travel"
        set_data_TB(openMod: "Allowance")
    }
    @objc private func open_Mod_Of_Travel(){
        if (Allo_Typ.text == "Allowance Type"){
            Toast.show(message: "Select Allowance Type")
            return
        }
        Drop_Down_Title.text = "Select Mode of Travel"
        DropDown.isHidden = false
        SelMod = "Travel"
        set_data_TB(openMod: "Travel")
    }
    @objc private func openStaying_Typ(){
        Drop_Down_Title.text = "Select Staying Type"
        DropDown.isHidden = false
        SelMod = "Staying"
        set_data_TB(openMod: "Staying")
    }
    @objc private func Start_Km_Img_View(){
        let imageData = try? Data(contentsOf: st_Km_Img!)
        let image = UIImage(data: imageData!)
        Image_View.image = image
        Image_Sc.isHidden = false
    }
    @objc private func End_Km_Img_View(){
        let imageData = try? Data(contentsOf: Ed_Km_Img!)
        let image = UIImage(data: imageData!)
        Image_View.image = image
        Image_Sc.isHidden = false
    }
    
    @objc private func Edit_Km_Scr(){
        animateIn(desiredView:blureView)
        animateIn(desiredView:Edit_Km_sc)
        From_Km_Text.text = Starting_KM.text
        To_Km_Text.text = eND_KM.text
        
        
    }
    
    func set_data_TB(openMod:String){
        self.view.endEditing(true)
        self.ShowLoading(Message: "Loading...")
        Exp_Data.removeAll()
        if(openMod == "Allowance"){
            let axn = "get/Allow_Type"
            
            let apiKey = "\(axn)&division_code=\(DivCode)"
            var result = apiKey
                if let lastCommaIndex = result.lastIndex(of: ",") {
                    result.remove(at: lastCommaIndex)
                }
            let apiKeyWithoutCommas = result.replacingOccurrences(of: ",&", with: "&")
            let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
           // self.ShowLoading(Message: "Loading...")
            AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<299)
                .responseJSON { [self] response in
                    switch response.result {
                    case .success(let value):
                        print(value)
                        if let json = value as? [AnyObject] {
                            do {
                                let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                                if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                    print(prettyPrintedJson)
                                    if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [AnyObject]{
                                        print(jsonObject)
                                        for i in jsonObject{
                                            Exp_Data.append(exData(id: (i["id"] as? String)!, name: (i["name"] as? String)!, newname: (i["newname"] as? String)!,StEndNeed: 0,farset: 0))
                                        }
                                        Exp_Datas = Exp_Data
                                        sel_TB.reloadData()
                                    } else {
                                        print("Error: Could not convert JSON to Dictionary or access 'data'")
                                    }
                                } else {
                                    print("Error: Could not convert JSON to String")
                                }
                            } catch {
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                        
                    case .failure(let error):
                        Toast.show(message: error.errorDescription ?? "Unknown Error")
                }
            }
        }else if (openMod == "Staying"){
            Exp_Data.append(exData(id: "1", name:"With Hotel", newname: "With Hotel",StEndNeed: 0,farset: 0))
            Exp_Data.append(exData(id: "2", name:"Without Hotel", newname: "Without Hotel",StEndNeed: 0,farset: 0))
            Exp_Datas = Exp_Data
            sel_TB.reloadData()
        }else if (openMod == "Travel"){
            let axn = "get/travelmode"
            let apiKey = "\(axn)&State_Code=\(StateCode)&Division_Code=\(DivCode)"
            var result = apiKey
            if let lastCommaIndex = result.lastIndex(of: ",") {
                result.remove(at: lastCommaIndex)
            }
            let apiKeyWithoutCommas = result.replacingOccurrences(of: ",&", with: "&")
            let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
            AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<299)
                .responseJSON { [self] response in
                    switch response.result {
                    case .success(let value):
                        print(value)
                        if let json = value as? [AnyObject] {
                            do {
                                let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                                if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                    print(prettyPrintedJson)
                                    if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [AnyObject]{
                                        print(jsonObject)
                                        for item in jsonObject{
                                            let Alw_Eligibilty = item["Alw_Eligibilty"] as? String
                                            let spriteArray = Alw_Eligibilty!.components(separatedBy: ",")
                                            if spriteArray.contains(select_allow) {
                                                Exp_Data.append(exData(id: String((item["Sl_No"] as? Int)!), name:(item["MOT"] as? String)!, newname: (item["MOT"] as? String)!,StEndNeed:(item["StEndNeed"] as? Int)!,farset:(item["MaxKm"] as? Int)!))
                                            }
                                        }
                                        Exp_Datas = Exp_Data
                                        print(Exp_Datas)
                                        if Exp_Data.isEmpty {
                                            need_mode_of_trav = 1
                                            Mod_Of_Travel.isHidden = true
                                            Mod_of_travel_height.constant = 0
                                            Enter_KM.isHidden = true
                                            Enter_KM_hig.constant = 0
                                            
                                        }else{
                                            if (UserSetup.shared.SrtEndKMNd != 0 && UserSetup.shared.exp_auto == 2 ){
                                                need_mode_of_trav = 1
                                                Mod_Of_Travel.isHidden = true
                                                Mod_of_travel_height.constant = 0
                                                Enter_KM.isHidden = true
                                                Enter_KM_hig.constant = 0
                                            }else{
                                                need_mode_of_trav = 0
                                                Mod_Of_Travel.isHidden = false
                                                Mod_of_travel_height.constant = 80
                                                Enter_KM.isHidden = false
                                                Enter_KM_hig.constant = 80
                                            }
                                        }
                                        sel_TB.reloadData()
                                    } else {
                                        print("Error: Could not convert JSON to Dictionary or access 'data'")
                                    }
                                } else {
                                    print("Error: Could not convert JSON to String")
                                }
                            } catch {
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                        
                    case .failure(let error):
                        Toast.show(message: error.errorDescription ?? "Unknown Error")
                    }
                }
        }
        self.LoadingDismiss()
    }
    func travel_data(date:String){
        let axn = "get/travel_data"
        let apiKey = "\(axn)&date=\(date)&desig=\(Desig)&divisionCode=\(DivCode)&div_code=\(DivCode)&rSF=\(SFCode)&dsg_code=\(UserSetup.shared.dsg_code)&sfCode=\(SFCode)&stateCode=\(StateCode)&state_code=\(StateCode)&sf_code=\(SFCode)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        self.ShowLoading(Message: "Loading...")
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    print(value)
                    self.LoadingDismiss()
                    if let json = value as? [String:Any] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String:Any]{
                                    print(jsonObject)
                                    if  let travel_data = jsonObject["travel_data"] as? [AnyObject]{
                                        print(travel_data)
                                        if travel_data.isEmpty{
                                            Enter_KM.isHidden = false
                                            Enter_KM_hig.constant = 80
                                            let Enter_KM_h = Enter_KM.frame.size.height
                                            scroll_hig = scroll_hig + Enter_KM_h
                                            Scrollview_Height.constant = scroll_hig
                                            Main_Scrollview_Height.constant = scroll_hig
                                            Travel_Det.isHidden = true
                                            let viewHeight = Travel_Det.frame.size.height
                                            scroll_hig = sub_Scrollview.frame.size.height + 40
                                            Travel_Det_Height.constant = 0
                                            print(viewHeight)
                                            print(scroll_hig)
                                            scroll_hig = scroll_hig - viewHeight
                                            print(scroll_hig)
                                            print(Scrollview_Height)
                                            Scrollview_Height.constant = scroll_hig
                                            Main_Scrollview_Height.constant = scroll_hig
                                            print(Scrollview_Height)
                                        }else{
                                            // New Height For KM Enter
                                            Enter_KM.isHidden = true
                                            Enter_KM_hig.constant = 0
                                            let Enter_KM_h = Enter_KM.frame.size.height
                                            scroll_hig = scroll_hig + Enter_KM_h + 40
                                            Scrollview_Height.constant = scroll_hig
                                            Main_Scrollview_Height.constant = scroll_hig
                                            
                                        
                                            if travel_data[0]["StEndNeed"] as? String == "0" {
                                                Travel_Det_Height.constant = 35
                                                scroll_hig = scroll_hig - 250
                                                Scrollview_Height.constant = scroll_hig
                                                Main_Scrollview_Height.constant = scroll_hig
                                                Sta_Km_View.isHidden = true
                                                Tot_Km_View.isHidden = true
                                                Calim_Km_View.isHidden = true
                                                Calim_Amt_View.isHidden = true
                                            }
                                          print(travel_data)
                                            if let Image_Url = travel_data[0]["Image_Url"] as? String,Image_Url != ""{
                                                Start_Km_Img.isHidden = false
                                                let apiKey: String = "\(SFCode)_\(Image_Url)"
                                                let url = URL(string:APIClient.shared.imgurl+apiKey)
                                                st_Km_Img = url
                                                if let url = url {
                                                    if let imageData = try? Data(contentsOf: url) {
                                                        if let image = UIImage(data: imageData) {
                                                            Start_Km_Img.image = image
                                                        } else {
                                                            Start_Km_Img.isHidden = true
                                                        }
                                                    } else {
                                                        Start_Km_Img.isHidden = true
                                                    }
                                                } else {
                                                    Start_Km_Img.isHidden = true
                                                }

                                               
                                                
                                            }else{
                                                Start_Km_Img.isHidden = true
                                            }
                                            
                                            if let Image_Url = travel_data[0]["End_Image_Url"] as? String, Image_Url != ""{
                                                End_Km_Img.isHidden = false
                                                let apiKey: String = "\(SFCode)_\(Image_Url)"
                                               
                                                if let url = URL(string:APIClient.shared.imgurl+apiKey) {
                                                    do {
                                                        Ed_Km_Img = url
                                                        let imageData = try Data(contentsOf: url)
                                                        if let image = UIImage(data: imageData) {
                                                            End_Km_Img.image = image
                                                        } else {
                                                            End_Km_Img.isHidden = true
                                                        }
                                                    } catch {
                                                        print("Error: \(error.localizedDescription)")
                                                        End_Km_Img.isHidden = true
                                                    }
                                                } else {
                                                    End_Km_Img.isHidden = true
                                                }
                                                
                                            }else{
                                                End_Km_Img.isHidden = true
                                            }
                                            
                                            Travel_Mod.text = travel_data[0]["MOT_Name"] as? String
                                            Starting_KM.text = travel_data[0]["Start_Km"] as? String
                                            eND_KM.text = travel_data[0]["End_Km"] as? String
                                            if let startKm1String = travel_data[0]["Start_Km"] as? String,
                                               let startKm2String = travel_data[0]["End_Km"] as? String,
                                               let startKm1 = Double(startKm1String),
                                               let startKm2 = Double(startKm2String) {
                                                let totalKm = startKm2 - startKm1
                                                Tota_KM.text = String(format: "%.2f",totalKm)
                                                print(totalKm) // Or use the totalKm variable as needed
                                            }else{
                                                Tota_KM.text = "0"
                                            }
                                            if let personalKm = travel_data.first?["Personal_Km"] as? String {
                                                Per_KM.text = personalKm
                                            } else {
                                                Per_KM.text = "0"
                                            }
                                            var clam_km = 0
                                            if let totalKm = Double(Tota_KM.text!), let Personal_Km = Double(Per_KM.text!){
                                                clam_km = Int(totalKm - Personal_Km)
                                            }
                                            
                                        
                                            cALIM_KM.text = String(clam_km)
                                            EnterKM.text = String(clam_km)
                                            Pers_KM.text = String((travel_data[0]["Fuel_Charge"] as? Double)!)
                                            var claim_amounnt = 0
                                            if let clamkm = Double(cALIM_KM.text!), let Fuel_Charge = Double(Pers_KM.text!){
                                                claim_amounnt = Int(clamkm * Fuel_Charge)
                                            }
                                            Claim_Amt.text = String(claim_amounnt)
                                            Expense_data[0].fare = String(claim_amounnt)
                                            From_Text.text = travel_data[0]["From_Place"] as? String
                                            To_Text.text = travel_data[0]["To_Place"] as? String
                                            From_Text.isEnabled = false
                                            To_Text.isEnabled = false
                                            Expense_data[0].MOT = (travel_data[0]["MOT_Name"] as? String)!
                                            Expense_data[0].mot_id = (travel_data[0]["MOT"] as? String)!
                                            Expense_data[0].max_km = (travel_data[0]["MOT"] as? String)!
                                            Expense_data[0].fuel_charge = (travel_data[0]["Fuel_Charge"] as? Double)!
                                            Expense_data[0].srt_km = (travel_data[0]["Start_Km"] as? String)!
                                            Expense_data[0].end_km = (travel_data[0]["End_Km"] as? String)!
                                            
//                                            if let Endkm=travel_data[0]["End_Km"] as? String, Endkm == "0" && Endkm == "null"{
//
//                                            }
                                        }
                                        print(Expense_data)
                                    }
                                } else {
                                    print("Error: Could not convert JSON to Dictionary or access 'data'")
                                }
                            } else {
                                print("Error: Could not convert JSON to String")
                            }
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                    
                case .failure(let error):
                    Toast.show(message: error.errorDescription ?? "Unknown Error")
            }
        }
    }
    
    @IBAction func Save_Exp(_ sender: Any) {
        if validateForm() == false {
            return
        }
        
        if EnterKM.text == "" && need_mode_of_trav == 0{
            if StEndNeed == 1{
                return Toast.show(message: "Enter the KM")
            }else  if StEndNeed == 0{
                return Toast.show(message: "Enter the fare")
            }
        }
        print(Bill_photo_Ned)
        print(Needs_Entry)
        
        for needs in Needs_Entry{
            if needs.Photo_Mandatory == 1 && needs.Photo_Nd == 1 && needs.amount != ""{
                if needs.image.isEmpty{
                    return Toast.show(message: "ADD \(needs.Name) PHOTO")
                }
            }
        }
        
        // Upload Bill img
        for BillUpolad in Bill_photo_Ned{
           // self.ShowLoading(Message: "uploading photos Please wait...")
            ImageUploader().uploadImage(SFCode: self.SFCode, image: BillUpolad.img, fileName: "__\(BillUpolad.imgurl)")
        }
        // Upload cust img
        for imgUpol in Needs_Entry {
            guard imgUpol.image.count == imgUpol.image_name.count else {
                print("Error: Image count does not match image name count")
                continue
            }
            for (img, name) in zip(imgUpol.image, imgUpol.image_name) {
                ImageUploader().uploadImage(SFCode: self.SFCode, image: img, fileName: "__\(name)")
            }
        }
        print(Expense_data[0].fare)
        let KM =  EnterKM.text
        if StEndNeed == 1 {
            if KM == ""{
                Expense_data[0].KM = "0"
            }else{
                Expense_data[0].KM = KM!
            }
        }else if StEndNeed == 0 && Expense_data[0].fare == ""{
            if KM == ""{
                Expense_data[0].fare = "0"
            }else{
                Expense_data[0].fare = KM!
            }
        }
        print(Expense_data[0].fare)
        
        let bill_amt = Enter_Bill_Amount.text
        if bill_amt == "" {
            Expense_data[0].Billamount = "0"
        }else{
            Expense_data[0].Billamount = bill_amt!
        }
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [self] _ in
            
            self.ShowLoading(Message: "Data Submitting Please wait...")
            Expense_data[0].Routename = From_Text.text!
            Expense_data[0].Toworkplace = To_Text.text!
            let axn = "dcr/save"
            let apiKey = "\(axn)&State_Code=\(StateCode)&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
            let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
            let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
            var Activity_img_url2:String = ""
            var CamItem: String = ""
            var Totalamt:Double = 0.0
            if Needs_Entry.isEmpty{
                print("No Data")
            }else{
                for i in Needs_Entry {
                    print(Needs_Entry)
                    print(i.amount)
                    var amount:Double = 0
                    if (i.amount == ""){
                        amount = 0
                    }else{
                        amount = Double(i.amount)!
                    }
                    Totalamt = Totalamt + amount
                    CamItem += "{"
                    CamItem += " \"ID\": " + String(i.ID) + ","
                    CamItem += " \"Name\": \"" + i.Name + "\","
                    CamItem += " \"amt\": \"" + i.amount + "\","
                    CamItem += " \"exp_remarks\": \"" + i.remark + "\","
                    if !i.image.isEmpty {
                        CamItem += " \"imgData\": \""
                        for (index, image) in i.image_name.enumerated() {
                            Activity_img_url2 = Activity_img_url2 + image + ","
                            CamItem += image.description
                            if index < i.image_name.count - 1 {
                                CamItem += ","
                            }
                        }
                        CamItem += "\","
                        CamItem += " \"prvImage\": \""
                        for (index, image) in i.image_name.enumerated() {
                            CamItem += image.description
                            if index < i.image_name.count - 1 {
                                CamItem += ","
                            }
                        }
                        CamItem += "\","
                    } else {
                        CamItem += " \"imgData\": \"\","
                        CamItem += " \"prvImage\": \"\","
                    }
                    CamItem += " \"Photo_Nd\": " + String(i.Photo_Nd) + ""
                    CamItem += "},"
                }
            }
            print(Totalamt)
            CamItem = String(CamItem.dropLast())
            Expense_data[0].TotalAmount = String(format: "%.2f", Totalamt)
            var Bill_Det = ""
            for B in Bill_photo_Ned {
                Activity_img_url2 = Activity_img_url2 + B.imgurl + ","
                Bill_Det += "{\"imgurl\": \"\(B.imgurl)\","
                Bill_Det += " \"title\": \"\(B.title)\","
                Bill_Det += " \"remarks\": \"\(B.remarks)\"},"
            }
            Bill_Det = String(Bill_Det.dropLast())
            Activity_img_url2 = String(Activity_img_url2.dropLast())
            print(Activity_img_url2)
            let jsonString = "[{\"dailyExpenseNew\":[" + CamItem + "]},{\"EA\":{\"MOT\":\"\(Expense_data[0].MOT)\"}},{\"ActivityCaptures\":[{\"imgurl\":\""+Activity_img_url2+"\"}]},{\"Expense_New\":{\"WorkType\":\"\(Expense_data[0].WorkType)\",\"mydayplanWorkPlace\":\"\(Expense_data[0].mydayplanWorkPlace)\",\"Routename\":\"\(Expense_data[0].Routename)\",\"Enterdate\":\"\(Expense_data[0].Enterdate)\",\"KM\":\(Expense_data[0].KM),\"Billamount\":\( Expense_data[0].Billamount),\"HQ\":\"\(Expense_data[0].HQ)\",\"stayingtype\":\(Expense_data[0].stayingtype),\"MOT\":\"\(Expense_data[0].MOT)\",\"mot_id\":\"\(Expense_data[0].mot_id)\",\"st_endNeed\":\"\(Expense_data[0].st_endNeed)\",\"max_km\":\"\(Expense_data[0].max_km)\",\"fuel_charge\":\"\(Expense_data[0].fuel_charge)\",\"exp_km\":\"0.0\",\"exp_amount\":\"\(Expense_data[0].fare)\",\"TotalAmount\":\"\(Expense_data[0].TotalAmount)\",\"Toworkplace\":\"\(Expense_data[0].Toworkplace)\",\"period_name\":\"\(Expense_data[0].period_name)\",\"period_id\":\"\(Expense_data[0].period_id)\",\"from_date\":\"\(Expense_data[0].from_date)\",\"to_date\":\"\(Expense_data[0].to_date)\",\"srt_km\":\"\(Expense_data[0].srt_km)\",\"end_km\":\"\(Expense_data[0].end_km)\",\"exp_auto\":2,\"exp_process_type\":0,\"fare_amt\":\"\(Expense_data[0].fare)\"}},{\"HotelBillAttachment\":[" + Bill_Det + "]}]"
            
            let params: Parameters = [
                "data": jsonString
            ]
            print(params)
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            self.LoadingDismiss()
            switch AFdata.result {
            case .success(let value):
                self.LoadingDismiss()
                if let json = value as? [ String:AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = try? JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: AnyObject] else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    if let Msg = prettyPrintedJson["msg"] as? String{
                        Toast.show(message:Msg, controller: self)
                    }else if(prettyPrintedJson["msg"] as? String == "Expense Submitted Successfully"){
                        GlobalFunc.movetoHomePage()
                        Toast.show(message: (prettyPrintedJson["msg"] as? String)!, controller: self)
                    }else{
                        let mes = prettyPrintedJson["msg"] as? String
                        GlobalFunc.movetoHomePage()
                        Toast.show(message:"Expense Submitted Successfully", controller: self)
                    }
                    let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "Expense") as! Expense_Entry;()
                    UIApplication.shared.windows.first?.rootViewController = viewController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                        }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)
            }
        }
        }
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    @IBAction func Close_Drop(_ sender: Any) {
        self.resignFirstResponder()
        Search_lbl.text = ""
        DropDown.isHidden = true
    }
    
    @IBAction func SearchByText(_ sender: Any) {
        let txtbx: UITextField = sender as! UITextField
        if txtbx.text!.isEmpty {
            Exp_Datas = Exp_Data
        }else{
            Exp_Datas = Exp_Data.filter({(product) in
                let name: String = product.name
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        sel_TB.reloadData()
    }
    func DateofExpense(){
        let axnex = "get/DateofExpense"
        let apiKey = "\(axnex)&State_Code=\(StateCode)&desig=\(Desig)&divisionCode=\(DivCode)&Type=1&div_code=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)&Dateofexp=2024-4-17"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        self.ShowLoading(Message: "Loading...")
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    print(value)
                    self.LoadingDismiss()
                    if let json = value as? [String:Any] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                print(prettyPrintedJson)
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String:Any]{
                                    print(jsonObject)
                                 
                                } else {
                                    print("Error: Could not convert JSON to Dictionary or access 'data'")
                                }
                            } else {
                                print("Error: Could not convert JSON to String")
                            }
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                    
                case .failure(let error):
                    Toast.show(message: error.errorDescription ?? "Unknown Error")
            }
        }
    }
    
    func DAExp_ND(){
        let axn = "get/DAExp"
        let apiKey = "\(axn)&State_Code=\(StateCode)&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)"
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<299)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String:Any] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                               
                                print(prettyPrintedJson)
                                if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String:Any]{
                                    print(jsonObject)
                                    if let ExpenseWeb = jsonObject["ExpenseWeb"] as? [AnyObject]{
                                        print(ExpenseWeb)
                                        var Tab_Hig = 0.0
                                        var scrol = 0.0
                                        for i in ExpenseWeb{
                                            Tab_Hig = Tab_Hig+100
                                            //scrol = scrol+65
                                            Needs_Entry.append(Pho_ND(ID: (i["ID"] as? Int)!, Name: (i["Name"] as? String)!, Photo_Mandatory: (i["Photo_Mandatory"] as? Int)!, Photo_Nd: (i["Photo_Nd"] as? Int)!,remark: "",amount: "", image: [], image_name: []))
                                        }
                                        if Needs_Entry.isEmpty{
                                            Daily_EX_Head.isHidden = true
                                        }else{
                                            Daily_EX_Head.isHidden = false
                                        }
                                        scrol = Double(Needs_Entry.count * 30)
                                        scroll_hig = scroll_hig + scrol
                                        Daily_Expense_TB_hig.constant = Tab_Hig
                                        Scrollview_Height.constant = scroll_hig
                                        Main_Scrollview_Height.constant = scroll_hig
                                        Daily_Expense_TB.reloadData()
                                    }
                                 
                                } else {
                                    print("Error: Could not convert JSON to Dictionary or access 'data'")
                                }
                            } else {
                                print("Error: Could not convert JSON to String")
                            }
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                    
                case .failure(let error):
                    Toast.show(message: error.errorDescription ?? "Unknown Error")
            }
        }
    }
    func validateForm() -> Bool {
        if (From_Text.text == "") {
            Toast.show(message: "Enter From")
            return false
        }
        if (To_Text.text == ""){
            Toast.show(message: "Enter To")
            return false
        }
        
        if (Select_Mod_of_Travel.text == "Select Mode of Travel"){
            if (UserSetup.shared.SrtEndKMNd == 0 && need_mode_of_trav == 0){
                Toast.show(message: "Select Mode of Travel")
                return false
            }
        }
        
        if (Allo_Typ.text == "Allowance Type"){
            Toast.show(message: "Select Allowance Type")
            return false
        }
        
        if (Allo_Typ.text == "OS" || Allo_Typ.text == "EX"){
            
            if (Stayingtyp.text == "Select Type"){
               // if UserSetup.shared.Hotel_Bill_Nd == 1{
                    Toast.show(message: "Select Staying Type")
                    return false
               // }
            }
            if(Stayingtyp.text == "With Hotel"){
                if (Enter_Bill_Amount.text == "") {
                    Toast.show(message: "Enter the Bill Amount")
                    return false
                }
                if (Bill_photo_Ned.count == 0){
                    if UserSetup.shared.Hotel_Bill_Nd == 1{
                        Toast.show(message: "Please Select Hotel expense Photo")
                        return false
                    }
            }
            }
        }
         // Chage Data
      
        return true
    }
    
    @IBAction func Photo_Sub_BT(_ sender: Any) {
        view.endEditing(true)
        SelWindo.isHidden = true
    }
    
    @objc private func changeQty(_ txtQty: UITextField){
        if (Select_Mod_of_Travel.text == "Select Mode of Travel"){
                Toast.show(message: "Select Mode of Travel")
                EnterKM.text?.removeLast()
                return
        }
        if StEndNeed == 0{
            if let amount = EnterKM.text{
                if amount != ""{
                let Amt = Int(amount)
                    print(Amt as Any)
                    print(farset)
                if Amt! > farset{
                    EnterKM.text?.removeLast()
                    return Toast.show(message: "Enter less then \(farset)")
                }
            }
            }
        }
    }
    @IBAction func IMG_cLOS(_ sender: Any) {
        Image_Sc.isHidden = true
    }
    
    
    @IBAction func Km_Save_Data(_ sender: Any) {
        if let start = Double(From_Km_Text.text!), let end = Double(To_Km_Text.text!) {
            if start < end {
                Starting_KM.text = From_Km_Text.text
                eND_KM.text = To_Km_Text.text
                Tota_KM.text = String(end - start)
                
                Expense_data[0].srt_km = From_Km_Text.text!
                Expense_data[0].end_km = To_Km_Text.text!
                
                var clam_km = 0
                if let totalKm = Double(Tota_KM.text!), let Personal_Km = Double(Per_KM.text!){
                    clam_km = Int(totalKm - Personal_Km)
                }
                
                cALIM_KM.text = String(clam_km)
                var claim_amounnt = 0
                if let clamkm = Double(cALIM_KM.text!), let Fuel_Charge = Double(Pers_KM.text!){
                    claim_amounnt = Int(clamkm * Fuel_Charge)
                }
                Claim_Amt.text = String(claim_amounnt)
                Expense_data[0].fare = String(claim_amounnt)
                animateOut(desiredView:blureView)
                animateOut(desiredView:Edit_Km_sc)
            } else {
                Toast.show(message: "Please provide a valid KM")
            }
        } else {
            Toast.show(message: "Please provide a valid KM")
        }

    }
}
