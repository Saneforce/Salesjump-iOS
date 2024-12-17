//
//  CustomFields.swift
//  SAN SALES
//
//  Created by Anbu j on 17/12/24.
//

import UIKit
import Alamofire
class CustomFields: IViewController {
    
    let customTextField = CustomTextField()
     
     
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
     
     
     override func viewDidLoad() {
         super.viewDidLoad()
         CustomDetails()
   
            }
     
     
     
     func CustomDetails(){
         let formatters = DateFormatter()
         formatters.dateFormat = "yyyy-MM-dd"
         let apiKey1: String = "get/CustomDetails&desig=MR&divisionCode=29&rSF=MR4126&sfCode=MR4126&stateCode=24&moduleId=3"
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
        // Create the scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Set scroll view constraints
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Create the stack view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        // Set stack view constraints within the scroll view
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            // Ensure the stack view matches the scroll view's width
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])
        
        // Populate the stack view with custom fields
        for AddedFields_Title in CustomGroupData {
            for AddedFields in AddedFields_Title.Customdetails_data {
                if AddedFields.Fld_Type == "TAS" {
                    let customTextField = CustomTextField()
                    customTextField.configure(title: AddedFields.Field_Name, placeholder: "Enter the \(AddedFields.Field_Name)")
                    stackView.addArrangedSubview(customTextField)
                } else if AddedFields.Fld_Type == "NP" {
                    let customTextField = CustomTextNumberField()
                    customTextField.configure(title: AddedFields.Field_Name, placeholder: "Enter the \(AddedFields.Field_Name)")
                    stackView.addArrangedSubview(customTextField)
                } else if AddedFields.Fld_Type == "CO" {
                    let customCheckboxView = CustomCheckboxView()
                    customCheckboxView.configure(
                        title: "Select Options:",
                        checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
                    )
                    customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                    customCheckboxView.backgroundColor = .white
                    stackView.addArrangedSubview(customCheckboxView)
                } else if AddedFields.Fld_Type == "SSO" {
                    let customCheckboxView = CustomCheckboxView()
                    customCheckboxView.configure(
                        title: "Select Options 3:",
                        checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 2", "Option 3", "Option 4", "Option 5", "Option 2", "Option 3", "Option 4", "Option 2", "Option 3", "Option 4"]
                    )
                    customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                    customCheckboxView.backgroundColor = .white
                    stackView.addArrangedSubview(customCheckboxView)
                }else if AddedFields.Fld_Type == "RO" {
                    let radioButtonView = CustomRadioButtonView()
                    radioButtonView.configure(title: "Choose an Option", radioButtonTitles: ["Option 1", "Option 2", "Option 3"])

                    // Add to the parent view and set frame or constraints
                    radioButtonView.translatesAutoresizingMaskIntoConstraints = false
                    stackView.addArrangedSubview(radioButtonView)
                    
                }else if AddedFields.Fld_Type == "RM"{
                    let radioButtonView = CustomRadioButtonView()
                    radioButtonView.configure(title: "Choose an Option", radioButtonTitles: ["Option 1 ", "Option 2", "Option 3"])
                    radioButtonView.translatesAutoresizingMaskIntoConstraints = false
                    stackView.addArrangedSubview(radioButtonView)
                    
                }else if AddedFields.Fld_Type == "D"{
                    let customLabel = CustomSelectionLabel()
                    customLabel.configure(title: "Name", value: "John Doe")
                    stackView.addArrangedSubview(customLabel)
                    
                }else if AddedFields.Fld_Type == "SSM"{
                    let customLabel = CustomSelectionLabel()
                    customLabel.configure(title: "Single Selection", value: "Select Data")
                    stackView.addArrangedSubview(customLabel)
                    
                }else if AddedFields.Fld_Type == "FSC"{
                    let customField = CustomFieldUpload()
                    customField.setTitleText("Dynamic Title")
                    customField.setDynamicLabelText("Dynamic Content")
                    stackView.addArrangedSubview(customField)
                }else if AddedFields.Fld_Type == "SMO"{
                    let customCheckboxView = CustomCheckboxView()
                    customCheckboxView.configure(
                        title: "Select Options 3:",
                        checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 2", "Option 3", "Option 4"]
                    )
                    customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                    customCheckboxView.backgroundColor = .white
                    stackView.addArrangedSubview(customCheckboxView)
                    
                }else if AddedFields.Fld_Type == "CM"{
                    let customCheckboxView = CustomCheckboxView()
                    customCheckboxView.configure(
                        title: "Select Options 3:",
                        checkBoxTitles: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 2", "Option 3", "Option 4"]
                    )
                    customCheckboxView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                    customCheckboxView.backgroundColor = .white
                    stackView.addArrangedSubview(customCheckboxView)
                    
                }else{
                    let customTextField = CustomTextNumberField()
                    customTextField.configure(title: AddedFields.Field_Name, placeholder: "Enter the \(AddedFields.Field_Name)")
                    stackView.addArrangedSubview(customTextField)
                }
            }
        }
        print(scrollView.frame.height)
    }


     }
     




