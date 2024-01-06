//
//  SubmittedCalls.swift
//  SAN SALES
//
//  Created by San eforce on 19/05/23.
//

import UIKit
import Alamofire

class SubmittedCalls: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var BackButton: UIImageView!
    @IBOutlet weak var SubmittedcallsTB: UITableView!
    
    let axn="entry/count"

    
    var Order:[String] = [""]
    
    struct mnuItem: Any {
        let MasId: Int
        let MasName: String
        let MasImage: String
        let BTC: String
    }
    
    var strMasList:[mnuItem]=[]
    
    var isDate: Bool = false
    var lObjSel: [AnyObject] = []
    var eKey: String = ""

   var SFCode: String = "", StateCode: String = "", DivCode: String = ""
    let LocalStoreage = UserDefaults.standard
    var objcalls: [AnyObject]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        SelectSecondaryorder()
        self.ShowLoading(Message: "Loading...")
        let LocalStoreage = UserDefaults.standard
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        let Desig: String=prettyJsonData["desigCode"] as? String ?? ""
       // lblDesig.text = Desig
        eKey = String(format: "EK%@-%i", SFCode,Int(Date().timeIntervalSince1970))
        
        SubmittedcallsTB.delegate=self
        SubmittedcallsTB.dataSource=self
        
        BackButton.addTarget(target: self, action: #selector(closeMenuWin))
        
      
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if SubmittedcallsTB == tableView {return strMasList.count}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = strMasList[indexPath.row].MasName
        cell.imgSelect.image = UIImage(named: strMasList[indexPath.row].MasImage)
        cell.Countlbl.text = strMasList[indexPath.row].BTC
        cell.vwContainer.layer.cornerRadius = 5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        let lItm: mnuItem=strMasList[indexPath.row]
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Submittedcalls", bundle: nil)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        if lItm.MasId == 1 {
           // let SubCalls = storyboard.instantiateViewController(withIdentifier: "SubmittedCalls") as! SubmittedCalls
            let SUBDCR = storyboard.instantiateViewController(withIdentifier: "SubmittedDCR") as! SubmittedDCR
            viewController.setViewControllers([SUBDCR], animated: false)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }
        if lItm.MasId == 2  {
     
            let PSUBDCR = storyboard.instantiateViewController(withIdentifier: "PrimarySubmittedDCR") as! PrimarySubmittedDCR
            viewController.pushViewController([PSUBDCR], animated: true)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        print(strMasList[indexPath.row].MasName)
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
    
    func SelectSecondaryorder(){
        //let apiKey: String = "\(axn)&State_Code=12&desig=MR&divisionCode=\(DivCode)&rSF=MR3533&sfCode=\(SFCode)&stateCode=12"
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)"
    
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
            self.LoadingDismiss()
            switch AFdata.result
            {
                
            case .success(let value):
                print(value)
                if let json = value as? [String:AnyObject] {
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                    var Secondary_order_Count = 0
                    var Primary_Order_Count = 0
                   if  let secondary = json["data"] as? [[String: Any]]{
                    
                    for dictionary in secondary {
                        if let doctorCount = dictionary["doctor_count"] as? Int {
                            Secondary_order_Count = doctorCount
                        }
                        
                        if let stockistCount = dictionary["stockist_count"] as? Int {
                            Primary_Order_Count = stockistCount
                        }
                    }
                }

                        strMasList.append(mnuItem.init(MasId: 1, MasName: "Secondary Order", MasImage: "SwitchRoute",BTC: String(Secondary_order_Count)))
                        strMasList.append(mnuItem.init(MasId: 2, MasName: "Primary Order", MasImage: "SwitchRoute",BTC: String(Primary_Order_Count)))

                    self.SubmittedcallsTB.reloadData()
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription!)  //, controller: self
            }
        }
    }
    
    @objc func closeMenuWin(){
        GlobalFunc.movetoHomePage()
        
    }
 
}
