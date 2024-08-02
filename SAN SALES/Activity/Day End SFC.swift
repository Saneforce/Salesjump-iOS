//
//  Day End SFC.swift
//  SAN SALES
//
//  Created by Anbu j on 01/08/24.
//

import UIKit
import Alamofire

class Day_End_SFC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    
    @IBOutlet weak var Back_BT: UIImageView!
    @IBOutlet weak var Mod_of_trv_TB: UITableView!
    @IBOutlet weak var Mod_Of_TB_HIG: NSLayoutConstraint!
    @IBOutlet weak var rMK: UITextView!
    @IBOutlet weak var Scroll_View_hig: NSLayoutConstraint!
    @IBOutlet weak var Det_View: UIView!
    struct mode_detils: Any {
        let from: String
        let to: String
        let mode_of_travel: String
    }
    var Mode_of_Travel_Detils:[mode_detils] = []
    let cardViewInstance = CardViewdata()
    let LocalStoreage = UserDefaults.standard
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String = ""
    var Date_Time:String?
    var Get_Date_Time:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        Back_BT.addTarget(target: self, action: #selector(GotoHome))
        Mod_of_trv_TB.dataSource = self
        Mod_of_trv_TB.delegate = self
        cardViewInstance.styleSummaryView(Det_View)
        if let date = Date_Time{
            Get_Date_Time = date
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = dateFormatter.string(from: Date())
            Get_Date_Time = ""
        }
        Exp_Detils()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Mode_of_Travel_Detils.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.Fromlbsfc.text = Mode_of_Travel_Detils[indexPath.row].from
        cell.TolblSFC.text = Mode_of_Travel_Detils[indexPath.row].to
        cell.Mod_of_trv_SFC.text = Mode_of_Travel_Detils[indexPath.row].mode_of_travel
        return cell
    }
    func Exp_Detils(){
        let axn = "get/dayend_details_sfc"
        let apiKey: String = "\(axn)&rSF=\(SFCode)&sfCode=\(SFCode)&date=\(Get_Date_Time)"
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL2 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                if let json = value as? [AnyObject]{
                    print(json)
                    
                    for i in json{
                        let From = i["From_Place"] as? String ?? ""
                        let To = i["To_Place"] as? String ?? ""
                        let Mot = i["MOT_Name"] as? String ?? ""
                        Mode_of_Travel_Detils.append(mode_detils(from: From, to: To, mode_of_travel: Mot))
                    }
                    
                    Mod_Of_TB_HIG.constant = CGFloat(Mode_of_Travel_Detils.count * 40)
                    Scroll_View_hig.constant = CGFloat((Mode_of_Travel_Detils.count*40) + 600)
                    Mod_of_trv_TB.reloadData()
                    
                } else {
                    print("Invalid response format")
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    
    
    
    @IBAction func Sumbit(_ sender: Any) {
        if rMK.text.isEmpty{
            Toast.show(message: "Enter Remark", controller: self)
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        let axn = "post/save_dayend_details_sfc"
        let remark = rMK.text ?? ""
        let encodedRemark = remark.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let apiKey: String = "\(axn)&rSF=\(SFCode)&sfCode=\(SFCode)&date=\(Get_Date_Time)&Enddateand_time=\(formattedDate)&remarks=\(encodedRemark)"
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL2 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                    GlobalFunc.movetoHomePage()
                    Toast.show(message: "Day end submitted successfully", controller: self)
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    @objc private func GotoHome(){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
   
}
