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
    @IBOutlet weak var BUS_IMG: UIImageView!
    @IBOutlet weak var FOOD_IMG: UIImageView!
    @IBOutlet weak var SNACKS_IMG: UIImageView!
    @IBOutlet weak var Bus_Cam: UIImageView!
    @IBOutlet weak var Food_cam: UIImageView!
    @IBOutlet weak var Snacks_cam: UIImageView!
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
    @IBOutlet weak var Bus_Far_View: UIView!
    @IBOutlet weak var Food_Allowance_View: UIView!
    @IBOutlet weak var Snacks_Bill_View: UIView!
    struct exData:Codable{
    let id:String
    let name:String
    let newname:String
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
    var set_Date:String?
    var Exp_Data:[exData] = []
    var Exp_Datas:[exData]=[]
    var scroll_hig:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        blureView.bounds = self.view.bounds
        PopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.2)
        PopUpView.layer.cornerRadius = 10
        Photo_List.delegate = self
        Photo_List.dataSource = self
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
        Bus_Cam.addTarget(target: self, action: #selector(Bus_Bill))
        Food_cam.addTarget(target: self, action: #selector(Food_Bill))
       // Snacks_cam.addTarget(target: self, action: #selector(Snacks_Bill))
        SNACKS_IMG.addTarget(target: self, action: #selector(openImag))
        Daily_Exp_photos.addTarget(target: self, action: #selector(Add_Pho))
        Allo_Typ.addTarget(target: self, action: #selector(openAllowance))
        Stayingtyp.addTarget(target: self, action: #selector(openStaying_Typ))
        set_form()
        travel_data(date: set_Date!)
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
        scroll_hig = scroll_hig - (Enter_KM_h + Staying_typ_h + Bill_Amount_view_h + Hotal_Bill_Img_View_h)
        Scrollview_Height.constant = scroll_hig
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
    func calculateTotalVisibleHeight() -> CGFloat {
          var totalHeight: CGFloat = 0.0
          let views: [UIView] = [Travel_Det, Allowance_type, Enter_KM, Staying_typ, Bill_Amount_view, Hotal_Bill_Img_View, Daily_EX_Head, Bus_Far_View, Food_Allowance_View, Snacks_Bill_View]
          
          for view in views {
              if !view.isHidden {
                  totalHeight += view.frame.size.height
              }
          }
          return totalHeight
      }
    func adjustScrollViewContentSize() {
            let totalHeight = calculateTotalVisibleHeight()
        Scrollview.contentSize = CGSize(width: Scrollview.frame.size.width, height: totalHeight)
        }
        func hideView(_ view: UIView) {
            view.isHidden = true
            adjustScrollViewContentSize()
        }
        func showView(_ view: UIView) {
            view.isHidden = false
            adjustScrollViewContentSize()
        }
    
    func set_form(){
        Set_Date.text = set_Date
        if let settyp = day_Plan{
            print(settyp)
            SetWork_Typ.text = settyp[0]["WorkType"] as? String
            Set_work_plc.text = settyp[0]["ClstrName"] as? String
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
            print(pickedImage)
            if(SelMod == "BUS"){
                bus.append(pickedImage)
            }else if (SelMod == "FOOD"){
                food.append(pickedImage)
            }else if (SelMod == "SNACKS"){
                snk.append(pickedImage)
                imgs.reloadData()
            }else{
                images.append(pickedImage)
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
        cell.imgProduct.image = snk[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Photo_List == tableView{
            return 100
        }
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sel_TB == tableView{
            return Exp_Datas.count
        }
        if Photo_List == tableView{
            return images.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if Photo_List == tableView{
            cell.Image_View.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            cell.Image_View.image = images[indexPath.row]
            cell.Enter_Rmk.returnKeyType = .done
            cell.Enter_Title.returnKeyType = .done
            cell.Enter_Rmk.delegate = self
            cell.Enter_Title.delegate = self
        }else if (sel_TB == tableView){
            cell.lblText.text = Exp_Datas[indexPath.row].name
            Search_lbl.returnKeyType = .done
            Search_lbl.delegate = self
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = Exp_Datas[indexPath.row]
        print(item)
        if (SelMod == "Allowance"){
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
    @objc private func Bus_Bill() {
        SelMod = "BUS"
        animateIn(desiredView:blureView)
        animateIn(desiredView:PopUpView2)
    }
    @objc private func Food_Bill() {
        SelMod = "FOOD"
        animateIn(desiredView:blureView)
        animateIn(desiredView:PopUpView2)
    }
    @objc private func Snacks_Bill() {
        SelMod = "SNACKS"
        animateIn(desiredView:blureView)
        animateIn(desiredView:PopUpView2)
    }
    @objc private func openImag() {
        animateIn(desiredView:blureView)
        animateIn(desiredView:IMG_Scr)
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
                                            Travel_Det.isHidden = true
                                            let viewHeight = Travel_Det.frame.size.height
                                            scroll_hig = sub_Scrollview.frame.size.height
                                            Travel_Det_Height.constant = 0
                                            scroll_hig = scroll_hig - viewHeight
                                            Scrollview_Height.constant = scroll_hig
                                        }else{
                                            From_Text.text = travel_data[0]["From_Place"] as? String
                                            To_Text.text = travel_data[0]["To_Place"] as? String
                                            From_Text.isEnabled = false
                                            To_Text.isEnabled = false
                                        }
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
        self.resignFirstResponder()
   
        self.navigationController?.popViewController(animated: true)
        return
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
}
