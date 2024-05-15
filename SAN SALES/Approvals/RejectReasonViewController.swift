//
//  RejectReasonViewController.swift
//  SAN SALES
//
//  Created by Naga Prasath on 09/05/24.
//

import UIKit
import Alamofire

class RejectReasonViewController<Item>: UIViewController,UITextViewDelegate {
    
    
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    var sfCode: String = "", stateCode: String = "", divCode: String = "",desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    var didSelect : (Item) -> () = { _ in}
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtView.delegate = self
        self.txtView.textColor = .darkGray
        
        btnConfirm.layer.cornerRadius = 5
        btnConfirm.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    
    init() {
        super.init(nibName: "RejectReasonViewController", bundle: Bundle(for: RejectReasonViewController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func confirmAction(_ sender: UIButton) {
        print("ok")
        
        let reason = txtView.textColor == .darkGray ? "" : txtView.text!
        
        if reason.isEmpty {
            Toast.show(message: "Enter the Reason", controller: self)
        }else{
            didSelect(reason as! Item)
           // self.rejectAction(reason: reason)
        }
        
        
        
    }
    
    func getUserDetails(){
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        sfCode = prettyJsonData["sfCode"] as? String ?? ""
        stateCode = prettyJsonData["State_Code"] as? String ?? ""
        divCode = prettyJsonData["divisionCode"] as? String ?? ""
        desig=prettyJsonData["desigCode"] as? String ?? ""
    }
    
    func rejectAction(reason : String) {
        let params : Parameters = ["data" : "[{\"TPReject\":{\"reason\":\"\'\(reason)\'\"}}]"]
        
        
        let month = String(format: "%@", SelectedData.shared.selectedTp["Tour_Month"] as! CVarArg)
        let year = String(format: "%@", SelectedData.shared.selectedTp["Tour_Year"] as! CVarArg)
        let code = String(format: "%@", SelectedData.shared.selectedTp["Sf_Code"] as! CVarArg)
        
        
        print(params)
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"State_Code=" + self.stateCode+"&rSF=" + sfCode+"&month=\(month)" + "&code=\(code)" + "&stateCode=" + stateCode + "&year=\(year)")
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.divCode + "&sfCode="+self.sfCode + "&desig=" + self.desig+"State_Code=" + self.stateCode+"&rSF=" + sfCode+"&month=\(month)" + "&code=\(code)" + "&stateCode=" + stateCode + "&year=\(year)",method: .post,parameters: params,encoding: URLEncoding.httpBody).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result{
                
            case .success(let value):
                print(value)
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                
                print(apiResponse)
                Toast.show(message: "Tour Plan Rejected Successfully", controller: self)
              //  self.dismiss(animated: true)
                
              //  self.navigationController?.popViewController(animated: true)
               // self.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = UIColor(cgColor: CGColor(red: 54/255, green: 53/255, blue: 53/255, alpha: 1.0))
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter the Reason"
            textView.textColor = UIColor.darkGray
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



class SelectedData{
    static var shared = SelectedData()
    
    var selectedTp : AnyObject!
}
