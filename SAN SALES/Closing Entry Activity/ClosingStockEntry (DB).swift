//
//  ClosingStockEntry (DB).swift
//  SAN SALES
//
//  Created by Anbu j on 09/09/24.
//

import UIKit
import Foundation
import Alamofire
import MobileCoreServices

class ClosingStockEntry__DB_: IViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate,
                              UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

  @IBOutlet weak var BTback: UIImageView!
  @IBOutlet weak var Date_View: UIView!
  @IBOutlet weak var Date: UILabel!
  let cardViewInstance = CardViewdata()
  @IBOutlet weak var Hq_View: UIView!
  @IBOutlet weak var Stockist_View: UIView!
  @IBOutlet weak var Select_HQ: UILabel!
  @IBOutlet weak var Select_Stockist: UILabel!
  @IBOutlet weak var Collection_View_category: UICollectionView!
  @IBOutlet weak var Entry_table: UITableView!
  @IBOutlet weak var Cam_View: UIView!
  @IBOutlet weak var Cam_View_clos: UIImageView!
  @IBOutlet weak var Photo_List: UITableView!
  @IBOutlet weak var Add_Photo: UIImageView!
  @IBOutlet weak var Vw_Sel: UIView!
  @IBOutlet weak var Save_Bt: UIButton!
  
  // View Select Windo
  
  @IBOutlet weak var Tit_lbl: UILabel!
  @IBOutlet weak var sel_table_view: UITableView!
  @IBOutlet weak var Update_Date: UILabel!
  @IBOutlet weak var Count_Update: UILabel!
  @IBOutlet weak var Stockist_Name: UILabel!
  @IBOutlet weak var Take_Photo: UIImageView!
  @IBOutlet weak var Photo_Save: UIButton!
  @IBOutlet weak var StkCap: UILabel!
  @IBOutlet weak var txSearchSel: UITextField!
  @IBOutlet weak var Pro_txSearchSel: UITextField!
  @IBOutlet weak var Stk_name: UILabel!
  
  let LocalStoreage = UserDefaults.standard
  var SFCode: String=""
  var DivCode: String=""
  var StateCode: String = ""
  
  var lstDist: [AnyObject] = []
  var lstAllDis: [AnyObject] = []
  var lstDis: [AnyObject] = []
  var lstHQs: [AnyObject] = []
  var SelMode: String = ""
  var lObjSel: [AnyObject] = []
  var lstBrands: [AnyObject] = []
  var selBrand: String = ""
  var lstAllProducts: [AnyObject] = []
  var lstProducts: [AnyObject] = []
  var pCatIndexPath = IndexPath()
  var lstRateList: [AnyObject] = []
  var lstAllUnitList: [AnyObject] = []
  var ProductCart: [AnyObject] = []
  var editable:Int = 0
  var update_Save:Int = 0
  var Scode:Int = 0
  var Hq_Id:String = ""
  var lAllObjSel: [AnyObject] = []
  struct Bill_Photo:Any{
      let imgurl:String
      var title:String
      var remarks:String
      let img:UIImage
  }
  var Bill_photo_Ned:[Bill_Photo] = []
  let dispatchGroup = DispatchGroup()
  
  override func viewDidLoad(){
      super.viewDidLoad()
      getUserDetails()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd/MM/yyyy"
      let currentDate = Foundation.Date()
      let formattedDate = dateFormatter.string(from: currentDate)
      Date.text = formattedDate
      
      StkCap.text = UserSetup.shared.StkCap
      Stk_name.text = "\(UserSetup.shared.StkCap) Name:"
      Select_Stockist.text = "Select \(UserSetup.shared.StkCap)"
      cardViewInstance.styleSummaryView(Date_View)
      cardViewInstance.styleSummaryView(Hq_View)
      cardViewInstance.styleSummaryView(Stockist_View)
      BTback.addTarget(target: self, action: #selector(closeMenuWin))
      Cam_View_clos.addTarget(target: self, action: #selector(Came_View_Clos_Func))
      Add_Photo.addTarget(target: self, action: #selector(Came_View_Open_Func))
      Select_HQ.addTarget(target: self, action: #selector(Vw_open))
      Select_Stockist.addTarget(target: self, action: #selector(Vw_open_rou))
      Take_Photo.addTarget(target: self, action: #selector(Camra))
      Photo_Save.addTarget(target: self, action: #selector(Save_Photo))
      
      self.Add_Photo.tintColor = .white
      
      if let DistData = LocalStoreage.string(forKey: "Distributors_Master_"+SFCode),
         let list = GlobalFunc.convertToDictionary(text:  DistData) as? [AnyObject] {
          lstDist = list;
          print(lstDist)
      }
      
      if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
         let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
          lstHQs = list;
          print(lstHQs)
          
          if UserSetup.shared.SF_type == 1 && !lstHQs.isEmpty{
              self.Select_HQ.text = lstHQs[0]["name"] as? String ?? ""
              Hq_Id = lstHQs[0]["id"] as? String ?? SFCode
              
              self.ShowLoading(Message: "       Sync Data Please wait...")
              GlobalFunc.FieldMasterSync(SFCode: Hq_Id){ [self] in
                      if let DistData = LocalStoreage.string(forKey: "Distributors_Master_" + Hq_Id) {
                          if let list = GlobalFunc.convertToDictionary(text: DistData) as? [AnyObject] {
                              lstAllDis = list
                              lstDis = list
                          }
                      }
                  self.LoadingDismiss()
              }
          }
          
      }
      
      let lstCatData: String=LocalStoreage.string(forKey: "Brand_Master")!
      if let list = GlobalFunc.convertToDictionary(text: lstCatData) as? [AnyObject] {
          lstBrands = list;
       
          lstBrands = lstBrands.filter({(product) in
              let Id: String = String(format: "%@", product["id"] as! CVarArg)
              return Bool(Id != "-1")
          })
      }
      
      
      let lstProdData: String = LocalStoreage.string(forKey: "Products_Master")!
      if let list = GlobalFunc.convertToDictionary(text: lstProdData) as? [AnyObject] {
          lstAllProducts = list;
          print(lstProdData)
      }
      
      
      let lstRateData: String = LocalStoreage.string(forKey: "ProductRate_Master")!
      if let list = GlobalFunc.convertToDictionary(text: lstRateData) as? [AnyObject] {
          lstRateList = list;
          print(lstRateList)
      }
      
      let lstUnitData: String = LocalStoreage.string(forKey: "UnitConversion")!
      if let list = GlobalFunc.convertToDictionary(text: lstUnitData) as? [AnyObject] {
          lstAllUnitList = list;
      }
      
      print(lstBrands)
      Count_Update.text = "0"
      
      Collection_View_category.delegate = self
      Collection_View_category.dataSource = self
      Entry_table.delegate = self
      Entry_table.dataSource = self
      Photo_List.delegate = self
      Photo_List.dataSource = self
      sel_table_view.delegate = self
      sel_table_view.dataSource = self
      
      Collection_View_category.isHidden = true
      Entry_table.isHidden = true
      
      if lstBrands.count>0{
          let item: [String: Any]=lstBrands[0] as! [String : Any]
          selBrand=String(format: "%@", item["id"] as! CVarArg)
          autoreleasepool{
          lstProducts = lstAllProducts.filter({(product) in
              let CatId: String = String(format: "%@", product["cateid"] as! CVarArg)
              print(CatId)
              print(selBrand)
              return Bool(CatId == selBrand)
          })
              print(lstProducts.count)
          }
          Entry_table.reloadData()
      }
  }
  
  @objc private func Camra(_ sender: Any) {
      let imagePickerController = UIImagePickerController()
      imagePickerController.delegate = self
      imagePickerController.sourceType = .camera
      present(imagePickerController, animated: true, completion: nil)
      
  }
  
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let compressedImageData = pickedImage.jpegData(compressionQuality: 0.25) {
                if let compressedImage = UIImage(data: compressedImageData) {
                    let fileName: String = String(Int(Foundation.Date().timeIntervalSince1970))
                    let filenameno = "\(fileName).jpg"
                    
                    Bill_photo_Ned.append(Bill_Photo(imgurl: filenameno, title: "", remarks: "", img: compressedImage))
                    Photo_List.reloadData()
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion: nil)
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
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return lstBrands.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
      let item: [String: Any]=lstBrands[indexPath.row] as! [String : Any]
      cell.vwContent.layer.cornerRadius = 10
      cell.vwContent.clipsToBounds = true
      cell.vwContent.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 251/255, alpha: 1)
             
      let id=String(format: "%@", item["id"] as! CVarArg)

      if selBrand == id {
          cell.vwContent.backgroundColor = UIColor(red: 16/255, green: 173/255, blue: 194/255, alpha: 1)
      }
      cell.lblText?.text = item["name"] as? String
      return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      autoreleasepool{
      let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
      let item: [String: Any]=lstBrands[indexPath.row] as! [String : Any]
      selBrand=String(format: "%@", item["id"] as! CVarArg)
      cell.vwContent.backgroundColor = UIColor(red: 16/255, green: 173/255, blue: 194/255, alpha: 1)
      lstProducts = lstAllProducts.filter({(product) in
          let CatId: String = String(format: "%@", product["cateid"] as! CVarArg)
          return Bool(CatId == selBrand)
      })
          print(lstAllProducts)
          print(lstProducts)
      Count_Update.text = String(lstProducts.count)
      pCatIndexPath = indexPath
      Pro_txSearchSel.text = ""
      Entry_table.reloadData()
      Collection_View_category.reloadData()
          // mANI TEST TEST HB
    
  }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
  {
      
      let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
      let item: [String: Any]=lstBrands[indexPath.row] as! [String : Any]
      let tx: String = item["name"] as? String ?? ""
      let rect: CGSize = tx.sizeOfString(maxWidth: 250, font: cell.lblText.font)
      
      return CGSize(width: rect.width+70, height: collectionView.frame.size.height)
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if tableView == Photo_List{return 100}
      if tableView == sel_table_view{return 50}

      if UserSetup.shared.hideClosingStockBatch == 1 &&  UserSetup.shared.hideClosingStockMfg == 1 {
          return 80
      }else{
          return 110
      }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if tableView == Photo_List{return Bill_photo_Ned.count}
      if tableView == sel_table_view{return lObjSel.count}
      
      return lstProducts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
      if tableView == Photo_List{
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
          
      }else if tableView == sel_table_view{
          let item: [String: Any]=lObjSel[indexPath.row] as! [String : Any]
          cell.lblText?.text = item["name"] as? String
          
      }else{
          let item: [String: Any]=lstProducts[indexPath.row] as! [String : Any]
          print(item)
          let id=String(format: "%@", item["id"] as! CVarArg)
          
          cell.lblText?.text = item["name"] as? String
          
          cell.Case_Entry.addTarget(self, action: #selector(self.CaseQty(_:)), for: .editingChanged)
          
          cell.Piece_Entry.addTarget(self, action: #selector(self.PieceQty(_:)), for: .editingChanged)
          
          cell.Batch_No.addTarget(self, action: #selector(self.Update_Batch_No(_:)), for: .editingChanged)
          
          cell.Date_Entry.addTarget(self, action: #selector(self.Upadte_Date(_:)), for: .editingChanged)
          
          cell.Case_Entry.keyboardType = .numberPad
          cell.Piece_Entry.keyboardType = .numberPad
          
          let items: [AnyObject] = ProductCart.filter ({ (Cart) in
              
              if Cart["product"] as! String == id {
                  return true
              }
              return false
          })
          
          cell.DB_Value?.text = "0"
          cell.Case_Entry.text = ""
          cell.Piece_Entry.text = ""
          cell.Batch_No.placeholder = "Batch No."
          cell.Date_Entry.placeholder = "mm/dd/yyy"
          if items.count>0 {
              print(items)
              
              let Total_Amt = String(items[0]["sample_qty"] as? Double ?? 0.0)
              
              cell.DB_Value?.text = Total_Amt
              cell.Case_Entry.text = String(items[0]["cb_qty"] as? Int ?? 0)
              cell.Piece_Entry.text = String(items[0]["pieces"] as? Int ?? 0)
              cell.Batch_No.text = items[0]["batch_no"] as? String ?? ""
              cell.Date_Entry.text = items[0]["Mgf_date"] as? String ?? ""
              
              if items[0]["batch_no"] as? String ?? "" == ""{
                  cell.Batch_No.placeholder = "Batch No."
              }
              if items[0]["Mgf_date"] as? String ?? "" == ""{
                  cell.Date_Entry.placeholder = "mm/dd/yyy"
              }
              
              if items[0]["cb_qty"] as? Int ?? 0 == 0{
                  cell.Case_Entry.text = ""
              }
              if items[0]["pieces"] as? Int ?? 0 == 0{
                  cell.Piece_Entry.text = ""
              }
          }else{
              cell.Batch_No.placeholder = "Batch No."
              cell.Batch_No.text = ""
              cell.Date_Entry.placeholder = "mm/dd/yyy"
              cell.Date_Entry.text = ""
          }
          
          if UserSetup.shared.hideClosingStockBatch == 1{
              cell.Batch_No.isHidden = true
          }
          
          if UserSetup.shared.hideClosingStockMfg == 1 {
              cell.Date_Entry.isHidden = true
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
              
              Hq_Id = Hq_Select_ID
              Select_HQ.text = name
              Select_Stockist.text = "Select \(UserSetup.shared.StkCap)"
              Scode = 0
              Collection_View_category.isHidden = true
              Entry_table.isHidden = true
              Count_Update.text = "0"
              Save_Bt.setTitle("Save", for: .normal)
              self.ShowLoading(Message: "Sync Data Please wait...")
              GlobalFunc.FieldMasterSync(SFCode: Hq_Select_ID){ [self] in
                      if let DistData = LocalStoreage.string(forKey: "Distributors_Master_" + Hq_Select_ID) {
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
              Scode = item["id"] as? Int ?? 0
              Edit_Data{ [self] success in
                  if success {
                      if editable == 1{
                          update_Save = 0
                          Save_Bt.setTitle("Edit", for: .normal)
                          Collection_View_category.isHidden = true
                          Entry_table.isHidden = true
                      }else{
                          Save_Bt.setTitle("Save", for: .normal)
                          Collection_View_category.isHidden = false
                          Entry_table.isHidden = false
                      }
                  } else {
                      print("First function failed, second function won't run.")
                  }
              }
          }
      }
      Vw_Sel.isHidden = true
  }
  
  @objc func Img_Tap(sender: UITapGestureRecognizer) {
      guard let view = sender.view else {
          return
      }
      Bill_photo_Ned.remove(at: view.tag)
      Photo_List.reloadData()
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
  
  func Edit_Data(completion: @escaping (Bool) -> Void){
      self.ShowLoading(Message: "Please Wait...")
      ProductCart.removeAll()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let currentDate = Foundation.Date()
      let formattedDate = dateFormatter.string(from: currentDate)
      print(formattedDate)
      
          let axn = "get/currentStock"
          let apiKey: String = "\(axn)&State_Code=\(StateCode)&divisionCode=\(DivCode)&scode=\(Scode)&rSF=\(SFCode)&cldt=\(formattedDate)&sfCode=\(Hq_Id)&stateCode=\(StateCode)"
          AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
              print(AFdata)
              switch AFdata.result {
              case .success(let value):
                  
                  if let json = value as? [AnyObject]{
                      print(json)
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
                                  } else {
                                      print("Invalid date format")
                                  }
                              }
                          }
                          
                          
                          editable = 1
                          for j in json{
                              let product = j["product"] as? String ?? ""
                              let product_Nm = j["product_Nm"] as? String ?? ""
                              let recv_qty = j["recv_qty"] as? Int ?? 0
                              let cb_qty = j["cb_qty"] as? Int ?? 0
                              let pieces = j["pieces"] as? Int ?? 0
                              let Rate = Double(j["Rate"] as? String ?? "0.0") ?? 0.0
                              let conversionQty = j["conversionQty"] as? Int ?? 0
                              let MRP_Price = "10"
                              let sample_qty = j["sample_qty"] as? Double ?? 0
                              let Mgf_date = j["Mgf_date"] as? String ?? ""
                              let batch_no = j["batch_no"] as? String ?? ""
                              
                              let itm: [String: Any] = ["product":product,"product_Nm":product_Nm,"recv_qty":recv_qty,"cb_qty":cb_qty,"pieces":pieces,"Rate":Rate,"conversionQty":Int(conversionQty),"MRP_Price":"\(MRP_Price)","sample_qty":sample_qty,"Mgf_date":Mgf_date,"batch_no":batch_no]
                              
                              let jitm: AnyObject = itm as AnyObject
                              ProductCart.append(jitm)
                          }
                          Count_Update.text = "0"
                          Entry_table.reloadData()
                      }else{
                      editable = 0
                      ProductCart.removeAll()
                      Update_Date.text = "Last Updation : "
                      Count_Update.text = String(lstProducts.count)
                      Entry_table.reloadData()
                      }
                  } else {
                      print("Invalid response format")
                  }
                  completion(true)
                  self.LoadingDismiss()
              case .failure(let error):
                  Toast.show(message: error.errorDescription ?? "", controller: self)
                  completion(false)
                  self.LoadingDismiss()
              }
          }
      }
  
  @objc private func CaseQty(_ txtQty: UITextField){
      let cell:cellListItem = GlobalFunc.getTableViewCell(view: txtQty) as! cellListItem
      let tbView:UITableView = GlobalFunc.getTableView(view: txtQty) as! UITableView
      let indxPath: IndexPath = tbView.indexPath(for: cell)!
      var sQty: Int =  integer(from: txtQty)
      let id: String
      let lProdItem:[String: Any]
      lProdItem = lstProducts[indxPath.row] as! [String : Any]
      print(lProdItem)
      id=String(format: "%@", lstProducts[indxPath.row]["id"] as! CVarArg)
     let lstUnitList = lstAllUnitList.filter({(product) in
          let ProdId: String = String(format: "%@", product["Product_Code"] as! CVarArg)
          return Bool(ProdId == id)
      })
      print(lstUnitList)
     if let maxItem = lstUnitList.max(by: {
         guard let firstQty = $0["ConQty"] as? Int, let secondQty = $1["ConQty"] as? Int else {
             return false
         }
         return firstQty < secondQty
     }) {
         print(maxItem)
        let sUom = String(format: "%@", maxItem["id"] as! CVarArg)
        let sUomNm = maxItem["name"] as! String
        let sUomConv = String(format: "%@", maxItem["ConQty"] as! CVarArg)
         
         
         updateQty(id: id, sUom: sUom, sUomNm: sUomNm, sUomConv: sUomConv, sNetUnt: "", sQty: String(sQty), ProdItem: lProdItem, SelMod: "CAS", Text_Data: "",row: indxPath[0],section: indxPath[1])
     }
  }
  
  @objc private func PieceQty(_ txtQty: UITextField){
      let cell:cellListItem = GlobalFunc.getTableViewCell(view: txtQty) as! cellListItem
      let tbView:UITableView = GlobalFunc.getTableView(view: txtQty) as! UITableView
      let indxPath: IndexPath = tbView.indexPath(for: cell)!
      print(indxPath)
      var sQty: Int =  integer(from: txtQty)
      let id: String
      let lProdItem:[String: Any]
      lProdItem = lstProducts[indxPath.row] as! [String : Any]
      print(lProdItem)
      id=String(format: "%@", lstProducts[indxPath.row]["id"] as! CVarArg)
     let lstUnitList = lstAllUnitList.filter({(product) in
          let ProdId: String = String(format: "%@", product["Product_Code"] as! CVarArg)
          return Bool(ProdId == id)
      })
      print(lstUnitList)
     if let maxItem = lstUnitList.max(by: {
         guard let firstQty = $0["ConQty"] as? Int, let secondQty = $1["ConQty"] as? Int else {
             return false
         }
         return firstQty < secondQty
     }) {
         print(maxItem)
        let sUom = String(format: "%@", maxItem["id"] as! CVarArg)
        let sUomNm = maxItem["name"] as! String
        let sUomConv = String(format: "%@", maxItem["ConQty"] as! CVarArg)
         updateQty(id: id, sUom: sUom, sUomNm: sUomNm, sUomConv: sUomConv, sNetUnt: "", sQty: String(sQty), ProdItem: lProdItem, SelMod: "PIC", Text_Data: "",row: indxPath[0],section: indxPath[1])
     }
  }
  
  @objc private func Update_Batch_No(_ txtQty: UITextField){
      let cell:cellListItem = GlobalFunc.getTableViewCell(view: txtQty) as! cellListItem
      let tbView:UITableView = GlobalFunc.getTableView(view: txtQty) as! UITableView
      let indxPath: IndexPath = tbView.indexPath(for: cell)!
      
      let Batch_Text = string(from: txtQty)
      
      let id: String
      let lProdItem:[String: Any]
      lProdItem = lstProducts[indxPath.row] as! [String : Any]
      print(lProdItem)
      id=String(format: "%@", lstProducts[indxPath.row]["id"] as! CVarArg)
     let lstUnitList = lstAllUnitList.filter({(product) in
          let ProdId: String = String(format: "%@", product["Product_Code"] as! CVarArg)
          return Bool(ProdId == id)
      })
      print(lstUnitList)
     if let maxItem = lstUnitList.max(by: {
         guard let firstQty = $0["ConQty"] as? Int, let secondQty = $1["ConQty"] as? Int else {
             return false
         }
         return firstQty < secondQty
     }) {
         print(maxItem)
        let sUom = String(format: "%@", maxItem["id"] as! CVarArg)
        let sUomNm = maxItem["name"] as! String
        let sUomConv = String(format: "%@", maxItem["ConQty"] as! CVarArg)
         updateQty(id: id, sUom: sUom, sUomNm: sUomNm, sUomConv: sUomConv, sNetUnt: "", sQty: "0", ProdItem: lProdItem, SelMod: "BAT", Text_Data: Batch_Text,row: indxPath[0],section: indxPath[1])
     }
      
  }
  
  @objc private func Upadte_Date(_ txtQty: UITextField){
      let cell:cellListItem = GlobalFunc.getTableViewCell(view: txtQty) as! cellListItem
      let tbView:UITableView = GlobalFunc.getTableView(view: txtQty) as! UITableView
      let indxPath: IndexPath = tbView.indexPath(for: cell)!
      let Date_Text = string(from: txtQty)
      let id: String
      let lProdItem:[String: Any]
      lProdItem = lstProducts[indxPath.row] as! [String : Any]
      print(lProdItem)
      id=String(format: "%@", lstProducts[indxPath.row]["id"] as! CVarArg)
     let lstUnitList = lstAllUnitList.filter({(product) in
          let ProdId: String = String(format: "%@", product["Product_Code"] as! CVarArg)
          return Bool(ProdId == id)
      })
      print(lstUnitList)
     if let maxItem = lstUnitList.max(by: {
         guard let firstQty = $0["ConQty"] as? Int, let secondQty = $1["ConQty"] as? Int else {
             return false
         }
         return firstQty < secondQty
     }) {
         print(maxItem)
        let sUom = String(format: "%@", maxItem["id"] as! CVarArg)
        let sUomNm = maxItem["name"] as! String
        let sUomConv = String(format: "%@", maxItem["ConQty"] as! CVarArg)
         updateQty(id: id, sUom: sUom, sUomNm: sUomNm, sUomConv: sUomConv, sNetUnt: "", sQty: "0", ProdItem: lProdItem, SelMod: "DAT", Text_Data:Date_Text,row: indxPath[0],section: indxPath[1])
     }
  }
  
  
  func updateQty(id: String,sUom: String,sUomNm: String,sUomConv: String,sNetUnt: String,sQty: String,ProdItem:[String: Any],SelMod:String,Text_Data:String,row:Int,section:Int){
      
      print(row)
      print(section)
      // Get Product Rate
      var Rate: Double = 0
      var MRP_Price:Double = 0
      
      let RateItems: [AnyObject] = lstRateList.filter ({ (Rate) in
          
          if Rate["Product_Detail_Code"] as! String == id {
              return true
          }
          return false
      })
      if(RateItems.count>0){
          Rate = (RateItems[0]["Retailor_Price"] as! NSString).doubleValue
          MRP_Price = (RateItems[0]["MRP_Price"] as! NSString).doubleValue
          print(RateItems)
      }
      
      
      let items: [AnyObject] = ProductCart.filter ({(item) in
          print(item)
          if item["product"] as! String == id {
              return true
          }
          return false
      })
      
      let product_Nm = ProdItem["name"] as? String ?? ""
      if items.count>0 {
          if let i = ProductCart.firstIndex(where: { (item) in
              if item["product"] as! String == id {
                  return true
              }
              return false
          }){
              let Pro_Item = ProductCart[i]
              print(Pro_Item)
              let product = Pro_Item["product"] as? String ?? ""
              let product_Nm = Pro_Item["product_Nm"] as? String ?? ""
              var cb_qty = Pro_Item["cb_qty"] as? Int ?? 0
              var pieces = Pro_Item["pieces"] as? Int ?? 0
              let conversionQty = Pro_Item["conversionQty"] as? Int ?? 0
              let sample_qty = Pro_Item["sample_qty"] as? Float ?? 0.0
              let Mgf_date = Pro_Item["Mgf_date"] as? String ?? ""
              let batch_no = Pro_Item["batch_no"] as? String ?? ""
              
              var Get_String = batch_no
              var Get_String_date = Mgf_date
              print(Text_Data)
              
              if SelMod == "CAS"{
                  cb_qty = Int(sQty) ?? 0
                  
              }else if SelMod == "PIC"{
                  pieces = Int(sQty) ?? 0
              }else if SelMod == "BAT"{
                  Get_String = Text_Data
              }else if SelMod == "DAT"{
                  Get_String_date = Text_Data
              }
              
              
              let Total_Pic = (cb_qty * (Int(sUomConv) ?? 0)) + pieces
              let Sample_Qty = Double(Total_Pic) * Rate
              
              let itm: [String: Any] = ["product":product,"product_Nm":product_Nm,"recv_qty":0,"cb_qty":cb_qty,"pieces":pieces,"Rate":Rate,"conversionQty":Int(sUomConv) ?? 0,"MRP_Price":"\(MRP_Price)","sample_qty":Sample_Qty,"Mgf_date":Get_String_date,"batch_no":Get_String]
              
              let jitm: AnyObject = itm as AnyObject
              ProductCart[i] = jitm
              let indexPath = IndexPath(row: section, section: 0)
              if let cell = Entry_table.cellForRow(at: indexPath) as? cellListItem {
                  cell.DB_Value?.text = String(Sample_Qty)
              }
          }
      }else{
          
          var CasQty = 0
          var PicQty = 0
          var sample_qty = 0
          var Get_String = ""
          var Get_String_date = ""
          if SelMod == "CAS"{
              CasQty = Int(sQty) ?? 0
              PicQty = 0
              
          }else if SelMod == "PIC"{
              CasQty = 0
              PicQty = Int(sQty) ?? 0
          }else if SelMod == "BAT"{
              Get_String = Text_Data
              
          }else if SelMod == "DAT"{
              Get_String_date = Text_Data
          }
          
          let Total_Pic = (CasQty * (Int(sUomConv) ?? 0)) + PicQty
          let Sample_Qty = Double(Total_Pic) * Rate
          
          
          let itm: [String: Any] = ["product":id,"product_Nm":product_Nm,"recv_qty":0,"cb_qty":CasQty,"pieces":PicQty,"Rate":Rate,"conversionQty":Int(sUomConv) ?? 0,"MRP_Price":"\(MRP_Price)","sample_qty":Sample_Qty,"Mgf_date":Get_String_date,"batch_no":Get_String]
          
          let jitm: AnyObject = itm as AnyObject
          ProductCart.append(jitm)
          let indexPath = IndexPath(row: section, section: 0)

          if let cell = Entry_table.cellForRow(at: indexPath) as? cellListItem {
              cell.DB_Value?.text = String(Sample_Qty)
          }
      }
  }
  
  
  func integer(from textField: UITextField) -> Int {
      guard let text = textField.text, let number = Int(text) else {
          return 0
      }
      if text.count > 6 {
             let truncatedText = String(text.prefix(6))
              print(truncatedText)
          var ConvInt2 = 0
          if let ConvInt = Int(truncatedText){
              ConvInt2 = ConvInt
          }
             Toast.show(message: "Text count cannot be more than 6 characters.")
          return ConvInt2
          
         }
      return number
  }
  
  func string(from textField: UITextField) -> String {
      guard let text = textField.text else {
          return "0"
      }
      return text
  }
  
  @IBAction func Save_Data(_ sender: Any) {
      if validateForm() == false {
          return
      }
      if  update_Save == 0 && editable == 1{
          update_Save = 1
          Save_Bt.setTitle("Update", for: .normal)
          Count_Update.text = String(lstProducts.count)
          Collection_View_category.isHidden = false
          Entry_table.isHidden = false
        return
      }
      
      self.ShowLoading(Message: "Data Submitting Please wait...")
      for BillUpload in Bill_photo_Ned {
          dispatchGroup.enter()
          ImageUploade().uploadImage(SFCode:"", image: BillUpload.img, fileName: "\(self.SFCode)__\(BillUpload.imgurl)") { [self] in
              DispatchQueue.main.async {
                  print("Image Uploaded Successfully")
              }
              dispatchGroup.leave()
          }
      }
      dispatchGroup.notify(queue: DispatchQueue.main){
          print("All images uploaded, proceeding to next step")
              self.save_stockUpdation()
      }
      
      if Bill_photo_Ned.count == 0{
          self.save_stockUpdation()
      }
  }
  
  func save_stockUpdation(){
     
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let currentDate = Foundation.Date()
      let formattedDate = dateFormatter.string(from: currentDate)
      

      
      var Bill_Det = ""
      for B in Bill_photo_Ned {
          Bill_Det += "{\"imgurl\": \"_\(B.imgurl)\","
          Bill_Det += " \"title\": \"\(B.title)\","
          Bill_Det += " \"remarks\": \"\(B.remarks)\"},"
      }
      Bill_Det = String(Bill_Det.dropLast())
      
      
       ProductCart = ProductCart.filter { item in
           let cb_qty = item["cb_qty"] as? Int ?? 0
           let pieces = item["pieces"] as? Int ?? 0
           return cb_qty != 0 || pieces != 0
       }
      
      var sPItems:String = ""
      for item in self.ProductCart{
          print(item)
          
          sPItems = sPItems + "{\"product\":\""+(item["product"] as! String)+"\", \"product_Nm\":\""+(item["product_Nm"] as! String)+"\","
          sPItems = sPItems + " \"recv_qty\":" + (String(format: "%.0f", item["recv_qty"] as! Double)) + ","
          sPItems = sPItems + " \"cb_qty\": " + (String(format: "%.0f", item["cb_qty"] as! Double)) + ","
          sPItems = sPItems + " \"pieces\": " + (String(format: "%.0f", item["pieces"] as! Double)) + ","
          sPItems = sPItems + " \"Rate\":" + (String(format: "%.0f", item["Rate"] as! Double)) + ","
          sPItems = sPItems + " \"conversionQty\": " + (String(format: "%.0f", item["conversionQty"] as! Double)) + ","
          sPItems = sPItems + " \"MRP_Price\": \"" + (item["MRP_Price"] as! String) + "\","
          sPItems = sPItems + " \"sample_qty\":" + (String(format: "%.0f", item["sample_qty"] as! Double)) + ","
          sPItems = sPItems + " \"Mgf_date\": \"" + (item["Mgf_date"] as! String) + "\","
          sPItems = sPItems + " \"batch_no\": \"" + (item["batch_no"] as! String) + "\"},"
      }
      var sPItems2:String = ""
      if sPItems.hasSuffix(",") {
          while sPItems.hasSuffix(",") {
              sPItems.removeLast()
          }
          sPItems2 = sPItems
      }
      
      let jsonString = "[{\"stockUpdation\":[" + sPItems2 + "]},{\"Activity_Event_Captures\":[" + Bill_Det + "]}]"
      
      let params: Parameters = [
          "data": jsonString
      ]
      
      print(params)
      let axn = "dcr/save"
      let apiKey: String = "\(axn)&State_Code=\(StateCode)&desig=\(UserSetup.shared.Desig)&divisionCode=\(DivCode)&sCode=\(Scode)&rSF=\(SFCode)&editable=\(editable)&sfCode=\(Hq_Id)&stateCode=\(StateCode)&Selectdate=\(formattedDate)"
      
      print(apiKey)
      
      AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey,method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
          AFdata in
          self.LoadingDismiss()
          PhotosCollection.shared.PhotoList = []
          switch AFdata.result
          {
              
          case .success(let value):
              print(value)
              
              if self.update_Save == 1{
                  Toast.show(message: "Update successfully", controller: self)
              }else{
                  Toast.show(message: "Submitted successfully", controller: self)
              }
              GlobalFunc.movetoHomePage()
              self.LoadingDismiss()
          case .failure(let error):
              
              let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                  return
              })
              self.present(alert, animated: true)
              self.LoadingDismiss()
          }
      }
      
      
      
  }
  
  func validateForm() -> Bool {
      if  Hq_Id == "" {
          Toast.show(message: "Select the Headquarter", controller: self)
          return false
      }
      if  Scode == 0 {
          Toast.show(message: "Select the \(UserSetup.shared.StkCap)", controller: self)
          return false
      }
      
     let ProductCarts = ProductCart.filter { item in
          let cb_qty = item["cb_qty"] as? Int ?? 0
          let pieces = item["pieces"] as? Int ?? 0
          return cb_qty != 0 || pieces != 0
      }
      
      if ProductCarts.isEmpty{
          Toast.show(message: "Please Enter any Product qty", controller: self)
          return false
      }
      
      return true
  }
  
  @objc func closeMenuWin(){
      GlobalFunc.MovetoMainMenu()
  }
  
  @objc func Came_View_Open_Func(){
      if  Hq_Id == "" {
          Toast.show(message: "Select the Headquarter", controller: self)
          return
      }
      if  Scode == 0 {
          Toast.show(message: "Select the \(UserSetup.shared.StkCap)", controller: self)
          return
      }
      
      Cam_View.isHidden = false
  }
  
  @objc func Save_Photo(){
      if Bill_photo_Ned.count == 0 {
          Toast.show(message: "Add Photo", controller: self)
          return
      }
      Cam_View.isHidden = true
  }
  
  @objc func Came_View_Clos_Func(){
      Cam_View.isHidden = true
  }
  
  @objc func Vw_open(){
      SelMode = "HQ"
      lObjSel = lstHQs
      self.Tit_lbl.text = "Select the Headquarter"
      self.txSearchSel.text = ""
      sel_table_view.reloadData()
      Vw_Sel.isHidden = false
  }
  
  @objc func Vw_open_rou(){
      if  Hq_Id == "" {
          Toast.show(message: "Select the Headquarter", controller: self)
          return
      }
      SelMode = "DIS"
      lObjSel = lstDis
      self.Tit_lbl.text = "Select the \(UserSetup.shared.StkCap)"
      self.txSearchSel.text = ""
      sel_table_view.reloadData()
      Vw_Sel.isHidden = false
  }

  @IBAction func Vw_Clos(_ sender: Any) {
      Vw_Sel.isHidden = true
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
  
  
  @IBAction func Pro_searchBytext(_ sender: Any) {
      
      if  Hq_Id == "" {
          Toast.show(message: "Select the Headquarter", controller: self)
          Pro_txSearchSel.text = ""
          return
      }
      if  Scode == 0 {
          Toast.show(message: "Select the \(UserSetup.shared.StkCap)", controller: self)
          Pro_txSearchSel.text = ""
          return
      }
      
      if  update_Save == 0 && editable == 1{
          Toast.show(message: "Edit your order!", controller: self)
          Pro_txSearchSel.text = ""
          return
      }
      
      let txtbx: UITextField = sender as! UITextField
      if txtbx.text!.isEmpty {
          lstProducts = lstAllProducts.filter({(product) in
              let CatId: String = String(format: "%@", product["cateid"] as! CVarArg)
              return Bool(CatId == selBrand)
          })
      }else{
          lstProducts = lstAllProducts.filter({(product) in
              let name: String = String(format: "%@", product["name"] as! CVarArg)
              return name.lowercased().contains(txtbx.text!.lowercased())
          })
      }
      Entry_table.reloadData()
  }
}
