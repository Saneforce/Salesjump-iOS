//
//  DeviationRemarks.swift
//  SAN SALES
//
//  Created by Naga Prasath on 07/06/24.
//

import Foundation
import UIKit
import Alamofire
 
class DeviationRemarks : IViewController,UITextViewDelegate {
    
    
    var sfCode: String = "", stateCode: String = "", divCode: String = "",desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    
    var isDeviationOn : (Bool) -> () = { _ in}
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var txtRemarks: UITextView!
    
    var tpDatas : JSON!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        
        txtRemarks.delegate = self
        txtRemarks.textColor = .darkGray
        txtRemarks.text = "Enter the Remarks"
        
        getUserDetails()
        
        print(self.tpDatas)
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
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        let remarks = self.txtRemarks.textColor == UIColor.darkGray ? "" : self.txtRemarks.text!
        
        if remarks.isEmpty {
            Toast.show(message: "Enter the Remarks", controller: self)
            return
        }
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to submit Deviation?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.submitDeviation()
            return
        }
                        
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            return
        })
        self.present(alert, animated: true)
    }
    
    
    func submitDeviation () {
        
        
        // http://fmcg.sanfmcg.com/server/native_Db_V13.php?axn=dcr%2Fsave&divisionCode=29%2C&sfCode=SEFMGR0015&desig=MR
        
        // [{"DCRTPDevReason":{"clusterid":"''","ClstrName":"''","reason":"'dcghchg'","status":"3","wtype":"'1308'"}}]
        
        let remarks = self.txtRemarks.textColor == UIColor.darkGray ? "" : self.txtRemarks.text!
        
  //       self.tpDatas.tp.first?.RouteCode.string ?? ""
        
        let workCode = self.tpDatas.tp.first?.worktype_code.int ?? 0
        let clstrName = self.tpDatas.tp.first?.RouteName.string ?? ""
        let clsteCode = self.tpDatas.tp.first?.RouteCode.string ?? ""
        
        let jsonString = "[{\"DCRTPDevReason\":{\"clusterid\":\"\'\(clsteCode)\'\",\"ClstrName\":\"\'\(clstrName)\'\",\"reason\":\"\'\(remarks)\'\",\"status\":\"3\",\"wtype\":\"\'\(workCode)\'\"}}]"
        
        let params: Parameters = [ "data": jsonString ]
        
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=\(divCode)&sfCode=\(sfCode)&desig=\(desig)")
        print(params)
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=\(divCode)&sfCode=\(sfCode)&desig=\(desig)",method: .post,parameters: params).validate(statusCode: 200..<209).responseData { AFData in
            switch AFData.result {
                
            case .success(let value):
                print(value)
                self.isDeviationOn(true)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
        
    }
    
    @objc func backVC() {
        isDeviationOn(false)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter the Remarks"
            textView.textColor = UIColor.darkGray
        }
    }
    
}



