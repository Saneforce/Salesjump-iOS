//
//  PrecallAnalysis.swift
//  SAN SALES
//
//  Created by Naga Prasath on 26/07/24.
//

import UIKit
import Alamofire


class PrecallAnalysis : UIViewController {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    @IBOutlet weak var lblSvlNo: UILabel!
    @IBOutlet weak var lblSlab: UILabel!
    @IBOutlet weak var lblGiftName: UILabel!
    @IBOutlet weak var lblRetailerChannel: UILabel!
    @IBOutlet weak var lblClass: UILabel!
    @IBOutlet weak var lblLastOrderAmt: UILabel!
    
    var retailer : AnyObject!
    
    var sfCode: String = "", stateCode: String = "", divCode: String = "",desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        getUserDetails()
        fetchPrecall()

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
    
    
    func fetchPrecall() {
        
        let id = String(format: "%@", retailer["id"] as! CVarArg)
        let url = APIClient.shared.BaseURL+APIClient.shared.DBURL1+"get/precall&Msl_No=\(id)&divisionCode=\(divCode)&sfCode=\(sfCode)"
        
        AF.request(url,method: .get,parameters: nil).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                do{
                    let json = try JSON(data: AFData.data!)
                    print(json)
                    
                    
                    self.lblSvlNo.text = ""
                    self.lblSlab.text = ""
                    self.lblGiftName.text = ""
                    self.lblClass.text = ""
                    self.lblRetailerChannel.text = ""
                    self.lblLastOrderAmt.text = json.last_order_remarks.string
                    
                }catch{
                    print("Error")
                }
                
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
        
    }
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
