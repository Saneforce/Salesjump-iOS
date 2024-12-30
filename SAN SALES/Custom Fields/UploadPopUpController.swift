//
//  UploadPopUpController.swift
//  SAN SALES
//
//  Created by Anbu j on 19/12/24.
//

import UIKit

class UploadPopUpController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    @IBOutlet weak var PopupView: UIView!
    @IBOutlet weak var Closepopup: UIImageView!
    @IBOutlet weak var LiveCamera: UIImageView!
    @IBOutlet weak var SelectFile: UIImageView!
    
    var SelectMod:String = ""
    var SFCode: String = ""
    var DivCode: String = ""
    var StateCode:String = ""
    var Desig:String = ""
    let LocalStoreage = UserDefaults.standard
     var didSelect : (String) -> () = { _ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        PopupView.layer.cornerRadius = 8
        Closepopup.addTarget(target: self, action: #selector(closeAction))
        SelectFile.addTarget(target: self, action: #selector(selectedfileName))
        LiveCamera.addTarget(target: self, action: #selector(opencamera))
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
   @objc func closeAction() {
        self.dismiss(animated: true)
    }
    
    init() {
        super.init(nibName: "UploadPopUpController", bundle: Bundle(for: UploadPopUpController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    @objc func selectedfileName () {
       
        SelectMod = "photo"
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Photo library is not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

     }
    
    @objc func opencamera(){
        SelectMod = "camera"
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                  let imagePicker = UIImagePickerController()
                  imagePicker.delegate = self
                  imagePicker.sourceType = .camera
                  imagePicker.allowsEditing = true // Set to false if you don't need editing
                  self.present(imagePicker, animated: true, completion: nil)
              } else {
                  // Alert user if camera is not available
                  let alert = UIAlertController(title: "Error", message: "Camera is not available", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                  self.present(alert, animated: true, completion: nil)
              }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if SelectMod == "photo"{
              if let imageUrl = info[.imageURL] as? URL {
                         let imageName = imageUrl.lastPathComponent // Get the file name
                      let fileName: String = SFCode+"__"+imageName
                     didSelect(fileName)
                  if let image = info[.originalImage] as? UIImage {
                      ImageUploader().uploadImage(SFCode: self.SFCode, image: image, fileName: fileName)
                      self.dismiss(animated: true)
                            print("Image stored successfully!")
                        } else {
                            print("Failed to retrieve the selected image.")
                        }
                  
                     } else {
                         print("Could not retrieve the image name.")
                     }
          }else{
              if let selectedImage = info[.originalImage] as? UIImage {
                  print("Image picked successfully.")
                  let fileName: String = String(Int(Date().timeIntervalSince1970))
                  let filenameno="\(SFCode)__\(fileName).jpg"
                  didSelect(filenameno)
                  
                  ImageUploader().uploadImage(SFCode: self.SFCode, image: selectedImage, fileName: fileName)
                  self.dismiss(animated: true)
              }
          }
          picker.dismiss(animated: true, completion: nil)
      }

      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          picker.dismiss(animated: true, completion: nil)
      }

}
