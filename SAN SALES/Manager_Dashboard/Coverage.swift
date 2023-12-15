//
//  Coverage.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//

import UIKit
import Alamofire

class Coverage: UIViewController {

    @IBOutlet weak var Custom_date: UIView!
    @IBOutlet weak var From_and_to_date: UIView!
    @IBOutlet weak var Retailers_View: UIView!
    @IBOutlet weak var Route_View: UIView!
    @IBOutlet weak var Distributors_View: UIView!
    @IBOutlet weak var From_Date: UILabel!
    @IBOutlet weak var To_Date: UILabel!
    
    @IBOutlet weak var Total_Ret: UILabel!
    @IBOutlet weak var Visited_Ret: UILabel!
    @IBOutlet weak var New_Ret: UILabel!
    @IBOutlet weak var Coverage_Ret: UILabel!
    @IBOutlet weak var Not_Visited_Ret: UILabel!
    
    @IBOutlet weak var Total_Rt: UILabel!
    @IBOutlet weak var Visited_Rt: UILabel!
    @IBOutlet weak var Coverage_Rt: UILabel!
    @IBOutlet weak var Not_Visited_Rt: UILabel!
    
    @IBOutlet weak var Total_Dis: UILabel!
    @IBOutlet weak var Visited_Dis: UILabel!
    @IBOutlet weak var Coverage_Dis: UILabel!
    @IBOutlet weak var Not_Visited_Dis: UILabel!
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    let LocalStoreage = UserDefaults.standard
    var Coverage_Sfcode = ""
    var Fromdate = ""
    var Todate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Custom_date.backgroundColor = .white
        Custom_date.layer.cornerRadius = 10.0
        Custom_date.layer.shadowColor = UIColor.gray.cgColor
        Custom_date.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Custom_date.layer.shadowRadius = 3.0
        Custom_date.layer.shadowOpacity = 0.7
        
        From_and_to_date.backgroundColor = .white
        From_and_to_date.layer.cornerRadius = 10.0
        From_and_to_date.layer.shadowColor = UIColor.gray.cgColor
        From_and_to_date.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        From_and_to_date.layer.shadowRadius = 3.0
        From_and_to_date.layer.shadowOpacity = 0.7
        
        
        Retailers_View.backgroundColor = .white
        Retailers_View.layer.cornerRadius = 10.0
        Retailers_View.layer.shadowColor = UIColor.gray.cgColor
        Retailers_View.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Retailers_View.layer.shadowRadius = 3.0
        Retailers_View.layer.shadowOpacity = 0.7
        
        Route_View.backgroundColor = .white
        Route_View.layer.cornerRadius = 10.0
        Route_View.layer.shadowColor = UIColor.gray.cgColor
        Route_View.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Route_View.layer.shadowRadius = 3.0
        Route_View.layer.shadowOpacity = 0.7
        
        Distributors_View.backgroundColor = .white
        Distributors_View.layer.cornerRadius = 10.0
        Distributors_View.layer.shadowColor = UIColor.gray.cgColor
        Distributors_View.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Distributors_View.layer.shadowRadius = 3.0
        Distributors_View.layer.shadowOpacity = 0.7
        // Do any additional setup after loading the view.
        getUserDetails()
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        Fromdate = formatters.string(from: Date())
        Todate = formatters.string(from: Date())
        Total_Team_Size_List(date:formatters.string(from: Date()))
        
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
    func Total_Team_Size_List(date:String){
        print(date)
       
        let apiKey: String = "get/sfDetails&selected_date=\(date)&sf_code=\(SFCode)&division_code=\(DivCode)"
        
        let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            switch AFdata.result {
                
            case .success(let value):
                print(value)
                if let json = value as? [ AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []),
                       let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
                       var select_Id = [String]()
                        for entry in jsonArray {
                            print(entry)
                            let rtoSF = entry["id"] as? String
                            select_Id.append(rtoSF!)
                        }
                        let encodedData = select_Id.map { element in
                            return "%27\(element)%27"
                        }
                        
                        let joinedString = encodedData.joined(separator: "%2C")
                        print(joinedString)
                        Coverage_Sfcode = joinedString
                        print(Coverage_Sfcode)
                        Get_Coverage_data()
                       
                    } else {
                        print("Error: Unable to parse JSON")
                    }
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    func Get_Coverage_data(){
        print(Coverage_Sfcode)
            let apiKey: String = "get/CoverageDetails&desig=\(Desig)&divisionCode=\(DivCode)&todate=\(Todate)&rSF=\(SFCode)&sfcode=\(Coverage_Sfcode)&sfCode=\(SFCode)&stateCode=\(StateCode)&fromdate=\(Fromdate)"
            
            let apiKeyWithoutCommas = apiKey.replacingOccurrences(of: ",&", with: "&")
        self.ShowLoading(Message: "Get Coverage Data...")
            AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKeyWithoutCommas, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
                AFdata in
                switch AFdata.result {
                    
                case .success(let value):
                    print(value)
                    self.LoadingDismiss()
                    if let json = value as? [String: AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        print(prettyPrintedJson)
                       // let totRetail = prettyPrintedJson["totRetail"] as? [AnyObject]
                        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
                           let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: AnyObject]] {
                       print(jsonArray)
                           // let Total_Ret = prettyPrintedJson["totRetail"] as? [String:Any]
                           
                        } else {
                            print("Error: Unable to parse JSON")
                        }
                    }
                case .failure(let error):
                    Toast.show(message: error.errorDescription!)  //, controller: self
                }
            }
        
    }

}
