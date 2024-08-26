//
//  RejectedAndCancelledLeaveDetails.swift
//  SAN SALES
//
//  Created by Naga Prasath on 09/08/24.
//

import UIKit
import Alamofire

class RejectedAndCancelledLeaveDetails : IViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    
    var sfCode: String = "", stateCode: String = "", divCode: String = "",desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    
    var json : JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        getUserDetails()
        fetchDetails()
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
    
    func fetchDetails () {
        // http://sjqa.salesjump.in/server/native_Db_V13.php?State_Code=24&desig=MR&divisionCode=258%2C&rSF=SJQAMGR0004&axn=vwRejectLeaveDet&sfCode=SJQAMGR0004&stateCode=24
        
        let url = APIClient.shared.BaseURL+APIClient.shared.DBURL1+"vwRejectLeaveDet&sfCode=\(sfCode)&stateCode=\(stateCode)&rSF=\(sfCode)&divisionCode=\(divCode)&desig=\(desig)&State_Code=\(stateCode)"
        
        AF.request(url,method: .get,parameters: nil).validate(statusCode: 200..<209).responseData { AFData in
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                do{
                    let json = try JSON(data: AFData.data!)
                    self.json = json
                    print(json)
                    
                    if self.json?.count == 0 {
                        Toast.show(message: "Empty List", controller: self)
                    }
                    
                    self.detailsTableView.reloadData()
                }catch {
                    print("Error")
                }
                
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.json?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = self.json?[indexPath.row].From_Date.string
        cell.lblText2.text = self.json?[indexPath.row].To_Date.string
        cell.lblremark.text = self.json?[indexPath.row].Rejected_Reason.string
        return cell
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
