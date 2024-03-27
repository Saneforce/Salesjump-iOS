//
//  Daily Expense Entry.swift
//  SAN SALES
//
//  Created by San eforce on 13/03/24.
//

import UIKit
import MobileCoreServices
import Alamofire
class Daily_Expense_Entry: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    struct exData:Codable{
    let id:String
    let name:String
    let newname:String
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
        var fuel_charge:Int
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
    var set_Date:String?
    var Exp_Data:[exData] = []
    var Exp_Datas:[exData]=[]
    var Needs_Entry:[Pho_ND]=[]
    var scroll_hig:Double = 0
    var Select_index_row:Int = 0
    var Bill_photo_Ned:[Bill_Photo] = []
    var Expense_data:[Expense_New] = []
    var Select_index_Del:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        Expense_data.append(Expense_New(WorkType: "", mydayplanWorkPlace: "", Routename: "", Enterdate: "", KM: "", Billamount: "", HQ: "", stayingtype: "", MOT: "", mot_id: "", st_endNeed: "", max_km: "", fuel_charge: 0, exp_km: "", exp_amount: "", TotalAmount: "", Toworkplace: "", period_name: "", period_id: "", from_date: "", to_date: "", srt_km: "", end_km: "", exp_auto: UserSetup.shared.exp_auto, exp_process_type: "\(UserSetup.shared.exp_process_type)"))
        getUserDetails()
        blureView.bounds = self.view.bounds
        PopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.2)
        PopUpView.layer.cornerRadius = 10
    
        Photo_List.delegate = self
        Photo_List.dataSource = self
        Daily_Expense_TB.delegate = self
        Daily_Expense_TB.dataSource = self
        sel_TB.delegate = self
        sel_TB.dataSource = self
        imgs.dataSource = self
        imgs.delegate = self
        scroll_hig =  sub_Scrollview.frame.size.height
        ButtonBack.addTarget(target: self, action: #selector(GotoHome))
        Add_Hotal_Bill.addTarget(target: self, action: #selector(imageTapped))
        Close_Sel_Windo.addTarget(target: self, action: #selector(Close_Wind))
        camera.addTarget(target: self, action: #selector(Camra))
        paperclip.addTarget(target: self, action: #selector(Add_Pho))
        eye.addTarget(target: self, action: #selector(View_Photo))
        //Bus_Cam.addTarget(target: self, action: #selector(Bus_Bill))
        //Food_cam.addTarget(target: self, action: #selector(Food_Bill))
       // Snacks_cam.addTarget(target: self, action: #selector(Snacks_Bill))
       // SNACKS_IMG.addTarget(target: self, action: #selector(openImag))
        Daily_Exp_photos.addTarget(target: self, action: #selector(Add_Pho))
        Allo_Typ.addTarget(target: self, action: #selector(openAllowance))
        Stayingtyp.addTarget(target: self, action: #selector(openStaying_Typ))
        CloseBt.addTarget(target: self, action: #selector(CloseImag))
        set_form()
        travel_data(date: set_Date!)
        DAExp_ND()
        Enter_KM.isHidden = true
        Enter_KM_hig.constant = 0
        let Enter_KM_h = Enter_KM.frame.size.height
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
        
        
        if let data = PeriodicData as? [PeriodicData] {
            print(data)
            for periodicData in data {
                let from_date = "\(periodicData.Eff_Year)-\(periodicData.Eff_Month)-\(periodicData.From_Date)"
                let To_date = "\(periodicData.Eff_Year)-\(periodicData.Eff_Month)-\(periodicData.To_Date)"
                
                Expense_data[0].from_date = from_date
                Expense_data[0].to_date = To_date
                Expense_data[0].period_id = periodicData.Period_Id
                Expense_data[0].period_name = periodicData.Period_Name
            }
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
    Desig=prettyJsonData["desigCode"] as? String ?? ""
    }
    
    func set_form(){
        Set_Date.text = set_Date
        if let settyp = day_Plan{
            print(Expense_data)
            SetWork_Typ.text = settyp[0]["WorkType"] as? String
            Set_work_plc.text = settyp[0]["ClstrName"] as? String
            Expense_data[0].WorkType = (settyp[0]["WorkType"] as? String)!
            Expense_data[0].mydayplanWorkPlace = (settyp[0]["ClstrName"] as? String)!
            Expense_data[0].Enterdate = set_Date!
            Allo_Typ.text = settyp[0]["Allowance_Type"] as? String
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
            }else{
                print(item.remark)
                cell.Enter_Rmk.text = item.remark
            }
            if item.amount == "" {
                cell.Ent_Amt.placeholder = "Amount"
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
        print(Needs_Entry)
    }
    @objc func alertClicked(sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        print(view.tag)
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
        Expense_data[0].HQ = item.newname
        if (SelMod == "Allowance"){
            print(item)
            
            if item.name == "OS" || item.name == "EX" {
                Staying_typ.isHidden = false
                Staying_typ_hig.constant = 80
                scroll_hig = scroll_hig + 80
                Scrollview_Height.constant = scroll_hig
                
            }else{
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
            }
            Allo_Typ.text = item.name
        }else if (SelMod == "Staying"){
             Expense_data[0].stayingtype = item.id
            if item.name == "With Hotel" {
                Bill_Amount_view.isHidden = false
                Bill_Amount_view_hig.constant = 80
                scroll_hig = scroll_hig + 80
                Hotal_Bill_Img_View.isHidden = false
                Hotal_Bill_Img_View_hig.constant = 80
                scroll_hig = scroll_hig + 80
                Scrollview_Height.constant = scroll_hig
            }else{
                Bill_Amount_view.isHidden = true
                Bill_Amount_view_hig.constant = 0
                let Bill_Amount_view_h = Bill_Amount_view.frame.size.height
                Hotal_Bill_Img_View.isHidden = true
                Hotal_Bill_Img_View_hig.constant = 0
                let Hotal_Bill_Img_View_h = Hotal_Bill_Img_View.frame.size.height
                scroll_hig = scroll_hig - (Bill_Amount_view_h + Hotal_Bill_Img_View_h)
                Scrollview_Height.constant = scroll_hig
            }
            Stayingtyp.text = item.name
        }
        Search_lbl.text = ""
        self.resignFirstResponder()
        DropDown.isHidden = true
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        SelWindo.isHidden = false
        animateOut(desiredView:blureView)
        animateOut(desiredView:PopUpView)
    }
    @objc private func Close_Wind() {
        view.endEditing(true)
        SelWindo.isHidden = true
    }
    @objc private func GotoHome() {
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
        set_data_TB(openMod: "Allowance")
    }
    @objc private func openStaying_Typ(){
        Drop_Down_Title.text = "Select Staying Type"
        DropDown.isHidden = false
        SelMod = "Staying"
        set_data_TB(openMod: "Staying")
    }
    func set_data_TB(openMod:String){
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
                        //self.LoadingDismiss()
                        if let json = value as? [AnyObject] {
                            do {
                                let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                                if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                                    print(prettyPrintedJson)
                                    if let jsonObject = try JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [AnyObject]{
                                        print(jsonObject)
                                        for i in jsonObject{
                                            Exp_Data.append(exData(id: (i["id"] as? String)!, name: (i["name"] as? String)!, newname: (i["newname"] as? String)!))
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
            Exp_Data.append(exData(id: "1", name:"With Hotel", newname: "With Hotel"))
            Exp_Data.append(exData(id: "2", name:"Without Hotel", newname: "Without Hotel"))
            Exp_Datas = Exp_Data
            sel_TB.reloadData()
        }
    }
    func travel_data(date:String){
        let axn = "get/travel_data"
        let apiKey = "\(axn)&date=\(date)&desig=\(Desig)&divisionCode=\(DivCode)&div_code=\(DivCode)&rSF=\(SFCode)&dsg_code=547&sfCode=\(SFCode)&stateCode=\(StateCode)&state_code=\(StateCode)&sf_code=\(SFCode)"
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
                                            Travel_Det.isHidden = true
                                            let viewHeight = Travel_Det.frame.size.height
                                            scroll_hig = sub_Scrollview.frame.size.height
                                            Travel_Det_Height.constant = 0
                                            scroll_hig = scroll_hig - viewHeight
                                            Scrollview_Height.constant = scroll_hig
                                        }else{
                                            print(travel_data)
                                            if travel_data[0]["StEndNeed"] as? String == "0" {
                                                Travel_Det_Height.constant = 35
                                                scroll_hig = scroll_hig - 250
                                                Scrollview_Height.constant = scroll_hig
                                                Sta_Km_View.isHidden = true
                                                Tot_Km_View.isHidden = true
                                                Calim_Km_View.isHidden = true
                                                Calim_Amt_View.isHidden = true
                                            }
                                            Travel_Mod.text = travel_data[0]["MOT_Name"] as? String
                                            Starting_KM.text = travel_data[0]["Start_Km"] as? String
                                            eND_KM.text = travel_data[0]["Start_Km"] as? String
                                            Tota_KM.text = travel_data[0]["End_Km"] as? String
                                            if let personalKm = travel_data.first?["Personal_Km"] as? Int {
                                                Per_KM.text = String(personalKm)
                                            } else {
                                                Per_KM.text = "0"
                                            }
                                            cALIM_KM.text = "0"//travel_data[0]["Personal_Km"] as? String
                                            Pers_KM.text = String((travel_data[0]["Fuel_Charge"] as? Int)!)
                                            Claim_Amt.text = "00.0"
                                            
                                            From_Text.text = travel_data[0]["From_Place"] as? String
                                            To_Text.text = travel_data[0]["To_Place"] as? String
                                            From_Text.isEnabled = false
                                            To_Text.isEnabled = false
                                            Expense_data[0].MOT = (travel_data[0]["MOT_Name"] as? String)!
                                            Expense_data[0].mot_id = (travel_data[0]["MOT"] as? String)!
                                            Expense_data[0].max_km = (travel_data[0]["MOT"] as? String)!
                                            Expense_data[0].fuel_charge = (travel_data[0]["Fuel_Charge"] as? Int)!
                                            Expense_data[0].srt_km = (travel_data[0]["Start_Km"] as? String)!
                                            Expense_data[0].end_km = (travel_data[0]["End_Km"] as? String)!
                                            
                                            if let Endkm=travel_data[0]["End_Km"] as? String, Endkm == "0" && Endkm == "null"{
                                                
                                            }
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
        
        var KM =  EnterKM.text
        if KM == ""{
            Expense_data[0].KM = "0"
        }else{
            Expense_data[0].KM = KM!
        }
        var bill_amt = Enter_Bill_Amount.text
        if bill_amt == "" {
            Expense_data[0].Billamount = ""
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
        print(Needs_Entry)
        var Activity_img_url2:String = ""
            var CamItem: String = ""
            var Totalamt:Double = 0.0
            for i in Needs_Entry {
                Totalamt = Totalamt + Double(i.amount)!
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
        let jsonString = "[{\"dailyExpenseNew\":[" + CamItem + "]},{\"EA\":{\"MOT\":\"\(Expense_data[0].MOT)\"}},{\"ActivityCaptures\":[{\"imgurl\":\""+Activity_img_url2+"\"}]},{\"Expense_New\":{\"WorkType\":\"\(Expense_data[0].WorkType)\",\"mydayplanWorkPlace\":\"\(Expense_data[0].mydayplanWorkPlace)\",\"Routename\":\"\(Expense_data[0].Routename)\",\"Enterdate\":\"\(Expense_data[0].Enterdate)\",\"KM\":\(Expense_data[0].KM),\"Billamount\":\( Expense_data[0].Billamount),\"HQ\":\"\(Expense_data[0].HQ)\",\"stayingtype\":\(Expense_data[0].stayingtype),\"MOT\":\"\(Expense_data[0].MOT)\",\"mot_id\":\"\(Expense_data[0].MOT)\",\"st_endNeed\":\"\(Expense_data[0].st_endNeed)\",\"max_km\":\"\(Expense_data[0].max_km)\",\"fuel_charge\":\"\(Expense_data[0].fuel_charge)\",\"exp_km\":\"0.0\",\"exp_amount\":\"\(Expense_data[0].exp_amount)\",\"TotalAmount\":\"\(Expense_data[0].TotalAmount)\",\"Toworkplace\":\"\(Expense_data[0].Toworkplace)\",\"period_name\":\"\(Expense_data[0].period_name)\",\"period_id\":\"\(Expense_data[0].period_id)\",\"from_date\":\"\(Expense_data[0].from_date)\",\"to_date\":\"\(Expense_data[0].to_date)\",\"srt_km\":\"\(Expense_data[0].srt_km)\",\"end_km\":\"\(Expense_data[0].end_km)\",\"exp_auto\":2,\"exp_process_type\":0}},{\"HotelBillAttachment\":[" + Bill_Det + "]}]"
        
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
                    self.resignFirstResponder()
                    self.navigationController?.popViewController(animated: true)
                    Toast.show(message: "submitted successfully", controller: self)
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
        let apiKey = "\(axnex)&State_Code=\(StateCode)&desig=\(Desig)&divisionCode=\(DivCode)&Type=1&div_code=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)&Dateofexp=2024-3-18"
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
                                            scrol = scrol+65
                                            Needs_Entry.append(Pho_ND(ID: (i["ID"] as? Int)!, Name: (i["Name"] as? String)!, Photo_Mandatory: (i["Photo_Mandatory"] as? Int)!, Photo_Nd: (i["Photo_Nd"] as? Int)!,remark: "",amount: "", image: [], image_name: []))
                                        }
                                        scroll_hig = scroll_hig+scrol
                                        Daily_Expense_TB_hig.constant = Tab_Hig
                                        Scrollview_Height.constant = scroll_hig
                                        print(Needs_Entry)
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
        }else if (To_Text.text == ""){
            Toast.show(message: "Enter To")
            return false
        }else if (Allo_Typ.text == "Allowance Type"){
            Toast.show(message: "Select Allowance Type")
            return false
        }else if (Allo_Typ.text == "OS" || Allo_Typ.text == "EX"){
            if (Stayingtyp.text == "Select Type"){
                Toast.show(message: "Select Staying Type")
                return false
            }else if(Stayingtyp.text == "With Hotel"){
                if (Enter_Bill_Amount.text == "") {
                    Toast.show(message: "Enter the Bill Amount")
                    return false
                }else if (Bill_photo_Ned.count == 0){
                    Toast.show(message: "Please Select Hotel expense Photo")
                    return false
            }
            }
        }
        return true
    }
}
