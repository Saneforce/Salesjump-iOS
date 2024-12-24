//
//  AddNewCustomer_New.swift
//  SAN SALES
//
//  Created by Anbu j on 23/12/24.
//

import UIKit
import Alamofire

class AddNewCustomer_New: IViewController,CustomCheckboxViewDelegate,CustomFieldUploadViewDelegate,CustomSelectionLabelViewDelegate,CustomTextFieldDelegate{

    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var Outlet_Category_View: UIView!
    // Add dynamic field
    let customTextField = CustomTextField()
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var Scroll_View_Height: NSLayoutConstraint!
    
    @IBOutlet weak var Stack_view_height: NSLayoutConstraint!
    
    struct CustomGroup:Any{
         let FGTableName:String
         let FGroupName:String
         let FieldGroupId:String
         let Customdetails_data:[Customdetails]
     }
     
     struct Customdetails:Any{
         let ModuleId:Int
         let Field_Name:String
         let Fld_Type:String
         let Fld_Symbol:String
         let Field_Col:String
         let Fld_Length:Int
         let Mandate:Int
         let flag:Int
         let Fld_Src_Name:String
         let Fld_Src_Field:String
         let FieldGroupId:Int
         let FGTableName:String
     }
     var CustomGroupData:[CustomGroup] = []
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",attendanceViews = 0,Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        CustomDetails()
        
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
    
    func CustomDetails(){
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        let apiKey1: String = "get/CustomDetails&desig=\(Desig)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&stateCode=\(StateCode)&moduleId=3"
        let apiKeyWithoutCommas = apiKey1.replacingOccurrences(of: ",&", with: "&")
        AF.request(APIClient.shared.BaseURL + APIClient.shared.CustomFieldDB + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
            case .success(let value):
                print(value)
                if let json = value as? [String:AnyObject]{
                    if let  customGrp = json["customGrp"] as? [AnyObject], let customData = json["customData"] as? [AnyObject]{
                        for i in customGrp{
                            let id = i["FieldGroupId"] as? String ?? ""
                            let filterFields = customData.filter { ($0["FieldGroupId"] as? Int ?? 0) == Int(id) }
                            let Custom_fields = CustomGroup_details(Custom_fields: filterFields)
                            
                           CustomGroupData.append(CustomGroup(FGTableName: i["FGTableName"] as? String ?? "", FGroupName: i["FGroupName"] as? String ?? "", FieldGroupId: i["FieldGroupId"] as? String ?? "", Customdetails_data: Custom_fields))
                        }
                    }
                }
                print(CustomGroupData)
                    self.AddCustom_Fields()
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    func CustomGroup_details(Custom_fields:[AnyObject]) ->[Customdetails]{
        
        var CustomdetailsModels: [Customdetails] = []
        for j in Custom_fields{
        let ModuleId:Int = j["ModuleId"] as? Int ?? 0
        let Field_Name:String = j["Field_Name"] as? String ?? ""
        let Fld_Type:String = j["Fld_Type"] as? String ?? ""
        let Fld_Symbol:String = j["Fld_Symbol"] as? String ?? ""
        let Field_Col:String = j["Field_Col"] as? String ?? ""
        let Fld_Length:Int = j["Fld_Length"] as? Int ?? 0
        let Mandate:Int = j["Mandate"] as? Int ?? 0
        let flag:Int = j["flag"] as? Int ?? 0
        let Fld_Src_Name:String = j["Fld_Src_Name"] as? String ?? ""
        let Fld_Src_Field:String = j["Fld_Src_Field"] as? String ?? ""
        let FieldGroupId:Int = j["FieldGroupId"] as? Int ?? 0
        let FGTableName:String = j["FGTableName"] as? String ?? ""
     
        let Custom_Model = Customdetails(ModuleId: ModuleId,
                                         Field_Name: Field_Name,
                                         Fld_Type: Fld_Type,
                                         Fld_Symbol: Fld_Symbol,
                                         Field_Col: Field_Col,
                                         Fld_Length: Fld_Length,
                                         Mandate: Mandate,
                                         flag: flag,
                                         Fld_Src_Name: Fld_Src_Name,
                                         Fld_Src_Field: Fld_Src_Field,
                                         FieldGroupId: FieldGroupId,
                                         FGTableName: FGTableName
        )
        CustomdetailsModels.append(Custom_Model)
    }
        
        return CustomdetailsModels
        
    }
    
    
   func AddCustom_Fields() {
//       let stackView = UIStackView()
//          stackView.axis = .vertical
//          stackView.spacing = 16
//          stackView.translatesAutoresizingMaskIntoConstraints = false
//
//          // Add the stack view to the main view
//          Custom_field_view.addSubview(stackView)
//
//          // Set stack view constraints below Outlet_Category_View
//          NSLayoutConstraint.activate([
//              stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//              stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//              stackView.topAnchor.constraint(equalTo: Outlet_Category_View.bottomAnchor, constant: 20), // Positioned below Outlet_Category_View
//              stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20) // Optional, ensures stackView doesn't overflow
//          ])
       
       // Populate the stack view with custom fields
//       StackView.axis = .vertical
//       StackView.distribution = .fill
//       StackView.alignment = .fill
       StackView.spacing = 10
       var index = 0
       var height:Double = 0
       for AddedFields_Title in CustomGroupData {
           
           if !AddedFields_Title.Customdetails_data.isEmpty{
               let header = HeaderLabel()
               header.configure(title: AddedFields_Title.FGroupName)
               header.layoutIfNeeded()

               // Calculate height
               let fittingSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
               print("Calculated height: \(fittingSize.height)")
               height = height+fittingSize.height + 10
               
               StackView.addArrangedSubview(header)
           }
          
           var index2 = 0
           for AddedFields in AddedFields_Title.Customdetails_data {
               if AddedFields.Fld_Type == "TAS" {
                   let customTextField = CustomTextField()
                   customTextField.configure(title: AddedFields.Field_Name, placeholder: "Enter the \(AddedFields.Field_Name)")
                   
                   customTextField.tag = index
                   customTextField.tags = [index,index2]
                   customTextField.delegate = self
                   customTextField.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customTextField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                
                   StackView.addArrangedSubview(customTextField)
               } else if AddedFields.Fld_Type == "NP" {
                   let customTextField = CustomTextNumberField()
                   customTextField.configure(title: AddedFields.Field_Name, placeholder: "Enter the \(AddedFields.Field_Name)")
                   customTextField.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customTextField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customTextField)
               } else if AddedFields.Fld_Type == "CO" {
                   let customCheckboxView = CustomCheckboxView()
                   customCheckboxView.configure(
                       title: AddedFields.Field_Name,
                       checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
                   )
                   
                   customCheckboxView.tag = index
                   customCheckboxView.tags = [index,index2]
                   
                   customCheckboxView.delegate = self
                   customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                   customCheckboxView.backgroundColor = .white
                   customCheckboxView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customCheckboxView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customCheckboxView)
               } else if AddedFields.Fld_Type == "SSO"{
                   let customCheckboxView = CustomCheckboxView()
                   customCheckboxView.configure(
                       title: AddedFields.Field_Name,
                       checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10", "Option 11", "Option 12", "Option 12", "Option 13", "Option 14"]
                   )
                   customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                   customCheckboxView.backgroundColor = .white
                   customCheckboxView.tag = index
                   customCheckboxView.tags = [index,index2]
                   customCheckboxView.delegate = self
                   customCheckboxView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customCheckboxView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customCheckboxView)
               }else if AddedFields.Fld_Type == "RO"{
                   let radioButtonView = CustomRadioButtonView()
                   radioButtonView.configure(title: AddedFields.Field_Name, radioButtonTitles: ["Option 1", "Option 2", "Option 3"])

                   // Add to the parent view and set frame or constraints
                   radioButtonView.translatesAutoresizingMaskIntoConstraints = false
                   
                   radioButtonView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = radioButtonView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(radioButtonView)
                   
               }else if AddedFields.Fld_Type == "RM"{
                   let radioButtonView = CustomRadioButtonView()
                   radioButtonView.configure(title: AddedFields.Field_Name, radioButtonTitles: ["Option 1 ", "Option 2", "Option 3"])
                   radioButtonView.translatesAutoresizingMaskIntoConstraints = false
                   
                   radioButtonView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = radioButtonView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(radioButtonView)
                   
               }else if AddedFields.Fld_Type == "D"{
                   let customLabel = CustomSelectionLabel()
                   customLabel.configure(title: AddedFields.Field_Name, value: "John Doe")
                   customLabel.tags = [index,index2]
                   customLabel.Typ = AddedFields.Fld_Type
                   customLabel.delegate = self
                   
                   customLabel.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customLabel)
                   
               }else if AddedFields.Fld_Type == "SSM"{
                   let customLabel = CustomSelectionLabel()
                   customLabel.configure(title: AddedFields.Field_Name, value: "Select Data")
                   customLabel.tags = [index,index2]
                   customLabel.Typ = AddedFields.Fld_Type
                   customLabel.delegate = self
                   
                   customLabel.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customLabel)
                   
               }else if AddedFields.Fld_Type == "FSC" || AddedFields.Fld_Type == "FC" {
                   let customField = CustomFieldUpload()
                   customField.setTitleText(AddedFields.Field_Name)
                   customField.setDynamicLabelText("Dynamic Content")
                   customField.hideCheckImage(true)
                   customField.tags = [index,index2]
                   customField.delegate = self
                   customField.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customField)
               }else if AddedFields.Fld_Type == "SMO"{
                   let customCheckboxView = CustomCheckboxView()
                   customCheckboxView.configure(
                       title: AddedFields.Field_Name,
                       checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 2", "Option 3", "Option 4"]
                   )
                   customCheckboxView.tag = index
                   customCheckboxView.delegate = self
                   customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                   customCheckboxView.backgroundColor = .white
                   customCheckboxView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customCheckboxView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customCheckboxView)
                   
               }else if AddedFields.Fld_Type == "CM"{
                   let customCheckboxView = CustomCheckboxView()
                   customCheckboxView.configure(
                       title: AddedFields.Field_Name,
                       checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 2", "Option 3", "Option 4"]
                   )
                   customCheckboxView.tag = index
                   customCheckboxView.delegate = self
                   customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                   customCheckboxView.backgroundColor = .white
                   
                   customCheckboxView.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customCheckboxView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customCheckboxView)
                   
               }else{
                   let customTextField = CustomTextNumberField()
                   customTextField.configure(title: AddedFields.Field_Name, placeholder: "Enter the \(AddedFields.Field_Name)")
                   
                   customTextField.layoutIfNeeded()

                   // Calculate height
                   let fittingSize = customTextField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   print("Calculated height: \(fittingSize.height)")
                   height = height+fittingSize.height + 10
                   StackView.addArrangedSubview(customTextField)
               }
               index2 += 1
           }
           index += 1
       }
      // Scroll_View_Height.constant = Scroll_View_Height.constant + 5000
       
       print(height)
       Stack_view_height.constant = height
      Scroll_View_Height.constant = Scroll_View_Height.constant + Stack_view_height.constant
       StackView.layoutIfNeeded()
   }
    
 

   // MARK: - CustomCheckboxViewDelegate
   func checkboxViewDidSelect(_ title: String, isSelected: Bool, tag: Int, tags: [Int], Selectaheckbox: [String : Bool]) {
       print("Checkbox '\(title)' with tag \(tag) is \(isSelected ? "selected" : "deselected")")
       print(tags)
       print(Selectaheckbox)
   }
   
   func CustomFieldUploadDidSelect(tags: [Int]) {
       print(tags)
       let ShowPopup = UploadPopUpController()
       ShowPopup.didSelect = { data in
           
           print(data)
               self.ChangeText(text: "\(tags)", tags: tags)
       }
       ShowPopup.show()
   }
   
   
   func ChangeText(text:String,tags: [Int]){
       guard let scrollView = view.subviews.compactMap({ $0 as? UIScrollView }).first,
                 let stackView = scrollView.subviews.compactMap({ $0 as? UIStackView }).first else {
               print("StackView or ScrollView not found")
               return
           }
           
           // Iterate through stackView's arrangedSubviews
           for subview in stackView.arrangedSubviews {
               if let customField = subview as? CustomFieldUpload, customField.tags == tags {
                   customField.setDynamicLabelText(text)
                   customField.hideCheckImage(false)
               }
           }
   }
   
   
   func CustomSelectionLabelDidSelect(tags: [Int], typ: String) {
       print(tags,typ)
       let ShowPopup = SelectDatePopUpController()
       ShowPopup.didSelect = { data in
           guard let scrollView = self.view.subviews.compactMap({ $0 as? UIScrollView }).first,
                     let stackView = scrollView.subviews.compactMap({ $0 as? UIStackView }).first else {
                   print("StackView or ScrollView not found")
                   return
               }
               
               // Iterate through stackView's arrangedSubviews
               for subview in stackView.arrangedSubviews {
                   if let customField = subview as? CustomSelectionLabel, customField.tags == tags {
                       customField.SetDatetext(Date:data )
                       
                   }
               }
           
       }
       ShowPopup.show()
       
   }
   
   func customTextField(_ customTextField: CustomTextField, didUpdateText text: String, tags: [Int]) {
       print(tags)
       print(text)
   }
    
    @objc private func GotoHome() {
        self.dismiss(animated: true, completion: nil)
        GlobalFunc.MovetoMainMenu()
    }

}
