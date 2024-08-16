//
//  Daily Expense Entry SFC.swift
//  SAN SALES
//
//  Created by Anbu j on 16/07/24.
//

import UIKit
import Alamofire

class Daily_Expense_Entry_SFC: IViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    var Needs_Entry:[Pho_ND]=[]
    @IBOutlet weak var BTBack: UIImageView!
    @IBOutlet weak var Daily_Expense_TB: UITableView!
    @IBOutlet var PopUpView2: UIView!
    @IBOutlet var blureView: UIVisualEffectView!
    @IBOutlet var IMG_Scr: UIView!
    @IBOutlet weak var imgs: UICollectionView!
    @IBOutlet weak var Daily_Exp_Cam: UIImageView!
    @IBOutlet weak var Daily_Exp_photos: UIImageView!
    @IBOutlet weak var CloseBt: UILabel!
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    var SelMod = ""
    var Select_index_row:Int = 0
    var Select_index_Del:Int = 0
    var snk:[UIImage] = []
    var images: [UIImage] = []
    var set_Date:String?
    override func viewDidLoad(){
        super.viewDidLoad()
        Daily_Expense_TB.delegate = self
        Daily_Expense_TB.dataSource = self
        imgs.dataSource = self
        imgs.delegate = self
        self.Daily_Expense_TB.showsHorizontalScrollIndicator = false
        self.Daily_Expense_TB.showsVerticalScrollIndicator = false
        blureView.bounds = self.view.bounds
        PopUpView2.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.2)
        PopUpView2.layer.cornerRadius = 10
        BTBack.addTarget(target: self, action: #selector(GotoHome))
        Daily_Exp_Cam.addTarget(target: self, action: #selector(Camra))
        Daily_Exp_photos.addTarget(target: self, action: #selector(Add_Pho))
        CloseBt.addTarget(target: self, action: #selector(CloseImag))
        getUserDetails()
        DAExp_ND()
    }
    @objc private func GotoHome(){
        VisitData.shared.Nav_id = 1
        self.resignFirstResponder()
        
        self.navigationController?.popViewController(animated: true)
        return
        
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
    @objc private func OpenpopUp() {
        animateIn(desiredView:blureView)
        animateIn(desiredView:PopUpView2)
    }
    @objc private func openImag() {
        animateIn(desiredView:blureView)
        animateIn(desiredView:IMG_Scr)
    }
    @IBAction func ClosePopUP(_ sender: Any) {
        animateOut(desiredView:blureView)
        animateOut(desiredView:PopUpView2)
    }
    @objc private func CloseImag() {
        Daily_Expense_TB.reloadData()
        animateOut(desiredView:blureView )
        animateOut(desiredView:IMG_Scr)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == Daily_Expense_TB {return Needs_Entry.count}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        if tableView == Daily_Expense_TB {
            
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
        }else{
            
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
                                        for i in ExpenseWeb{
                                            Needs_Entry.append(Pho_ND(ID: (i["ID"] as? Int)!, Name: (i["Name"] as? String)!, Photo_Mandatory: (i["Photo_Mandatory"] as? Int)!, Photo_Nd: (i["Photo_Nd"] as? Int)!,remark: "",amount: "", image: [], image_name: []))
                                        }
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
    
    @IBAction func SaveData(_ sender: Any) {
        if validateForm() == false {
            Toast.show(message: "Enter valid data")
            return
        }
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want Submit?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [self] _ in
        
            var Activity_img_url2:String = ""
            var CamItem: String = ""
            var Totalamt:Double = 0.0
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
            CamItem = String(CamItem.dropLast())
            print(CamItem)
            let jsonString = "[{\"dailyExpenseSFC\":[" + CamItem + "]}]"
            let params: Parameters = [
                "data": jsonString
            ]
            print(params)
            let axn = "dcr/save"
            let apiKey = "\(axn)&State_Code=\(StateCode)&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)&EntDate=\(set_Date!)"
            let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
            let url = APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas
            AF.request(url, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                AFdata in
                switch AFdata.result {
                case .success(let value):
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
                        Toast.show(message:"Expense Submitted Successfully", controller: self)
                        VisitData.shared.Nav_id = 1
                        let storyboard = UIStoryboard(name: "AdminForms", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "Expense") as! Expense_Entry;()
                        UIApplication.shared.windows.first?.rootViewController = viewController
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)
                }
                
            }
            self.navigationController?.popViewController(animated: true)
            return
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
        
        
       
        
        func validateForm() -> Bool {
            print(Needs_Entry)
            for entry in Needs_Entry {
                if !entry.amount.isEmpty {
                    // Found a non-empty amount
                    return true
                }
            }
            
            return false
        }
    }
    
    
}
