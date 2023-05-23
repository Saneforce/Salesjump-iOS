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
    
    
    let axn="table/list"
    
    var Order:[String] = [""]
    
    struct mnuItem: Any {
        let MasId: Int
        let MasName: String
        let MasImage: String
    }
    
    var strMasList:[mnuItem]=[]
    
    var isDate: Bool = false
    var lObjSel: [AnyObject] = []
    var eKey: String = ""
    
    //var SFCode: String = "",  DivCode: String = "",StrRptDt: String="",desig: String="",rSF: String=""
    
    var StateCode: String = "",desig: String="",DivCode: String = "",rSF: String="",SFCode: String = "",stateCode: String = ""
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        eKey = String(format: "EK%@-%i", SFCode,Int(Date().timeIntervalSince1970))
        
        SubmittedcallsTB.delegate=self
        SubmittedcallsTB.dataSource=self
        
        BackButton.addTarget(target: self, action: #selector(closeMenuWin))
        
        strMasList.append(mnuItem.init(MasId: 1, MasName: "Secondary Order", MasImage: "SwitchRoute"))
        strMasList.append(mnuItem.init(MasId: 2, MasName: "Primary Order", MasImage: "SwitchRoute"))
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
            SelectSecondaryorder()
           // let SubCalls = storyboard.instantiateViewController(withIdentifier: "SubmittedCalls") as! SubmittedCalls
            let SUBDCR = storyboard.instantiateViewController(withIdentifier: "SubmittedDCR") as! SubmittedDCR
            viewController.setViewControllers([SUBDCR], animated: false)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }
        if lItm.MasId == 2  {
            //let Homevc = storyboard.instantiateViewController(withIdentifier: "SubmittedCalls") as! SubmittedCalls
           // let SubCalls = storyboard.instantiateViewController(withIdentifier: "SubmittedCalls") as! SubmittedCalls
            let PSUBDCR = storyboard.instantiateViewController(withIdentifier: "PrimarySubmittedDCR") as! PrimarySubmittedDCR
            viewController.setViewControllers([PSUBDCR], animated: false)
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
        let apiKey: String = "\(axn)&State_Code=12&desig=MR&divisionCode=\(DivCode)&rSF=MR3533&sfCode=\(SFCode)&stateCode=12"
        
//    data:{"tableName":"vwactivity_report","coloumns":"[\"*\"]","today":1,"wt":1,"orderBy":"[\"activity_date asc\"]","desig":"mgr"}
        
        let aFormData: [String: Any] = [
            "tableName":"vwactivity_report","coloumns":"[\"today\",\"wt\",\"orderBy\":\"[\"activity_date asc\"]\"]","desig":"mgr"]
            
//            let aFormData: [String: Any] = [
//               "tableName":"vwMyDayPlan","coloumns":"[\"worktype\",\"FWFlg\",\"sf_member_code as subordinateid\",\"cluster as clusterid\",\"ClstrName\",\"remarks\",\"stockist as stockistid\",\"worked_with_code\",\"worked_with_name\",\"dcrtype\",\"location\",\"name\",\"Sprstk\",\"Place_Inv\",\"WType_SName\",\"convert(varchar,Pln_date,20) plnDate\"]","desig":"mgr"
//            ]

        
//        let aFormData: [String: Any] = [
//           "tableName":"vwMyDayPlan","coloumns":"[\"today\",\"wt\",\"orderBy\"]","desig":"mgr"]
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]

        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self]
            AFdata in
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
