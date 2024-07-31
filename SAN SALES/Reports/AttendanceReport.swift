//
//  AttendanceReport.swift
//  SAN SALES
//
//  Created by Naga Prasath on 29/07/24.
//

import UIKit
import Alamofire

class AttendanceReport : UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    @IBOutlet weak var vwDate: ShadowView!
    
    
    var date = ""
    var sfCode: String = "", stateCode: String = "", divCode: String = "",desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    
    
    var json : JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        imgBack.addTarget(target: self, action: #selector(backVC))
        
        self.lblDate.text = Date().toString(format: "dd MMM yyyy")
        self.date = Date().toString(format: "yyyy-MM-dd")
        
        fetchDate(date: self.date)
        
        vwDate.layer.borderWidth = 2
        vwDate.layer.borderColor = CGColor(red: 54.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 0.6)
        vwDate.layer.masksToBounds = true
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
    
    func fetchDate(date : String) {
        
        let url = APIClient.shared.BaseURL+APIClient.shared.DBURL1+"get/Attendance&sfCode=\(sfCode)&rptDt=\(date)&rSF=\(sfCode)&divisionCode=\(divCode)&State_Code=\(stateCode)"
        
        print(url)
        AF.request(url,method: .get,parameters: nil).validate(statusCode: 200..<209).responseData { AFData in
            
            switch AFData.result {
                
            case .success(let value):
                print(value)
                
                do{
                    let json = try JSON(data: AFData.data!)
                    self.json = json
                    print(json)
                    
                    self.tableView.reloadData()
                }catch{
                    print("Error")
                }
                
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
        
    }
    
    
    @IBAction func dateAction(_ sender: UIButton) {
        
        let alertView = CalendarViewController()
        alertView.didSelect = { date in
            print(date)
            self.date = date
            self.lblDate.text = date.changeFormat(from: "yyyy-MM-dd",to: "dd MMM yyyy")
            self.fetchDate(date: self.date)
            self.dismiss(animated: true)
        }
        alertView.show()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.json?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AttendanceReportcell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AttendanceReportcell
        
        if self.json?[indexPath.row].Desig_Code.int == 2 {
            cell.lblName.textColor = UIColor.systemGreen
        }else {
            cell.lblName.textColor = UIColor.systemBlue
        }
        cell.lblName.text = self.json?[indexPath.row].Sf_Name.string
        cell.lblPhone.text = "( PH : \(self.json?[indexPath.row].MOb.string ?? "") )"
        cell.lblWorkName.text = self.json?[indexPath.row].Worktype_Name_B.string
        cell.lblWorkName.textColor = UIColor.systemRed
        cell.lblRoute.text = self.json?[indexPath.row].ClstrName.string
        cell.lblDist.text = self.json?[indexPath.row].dist_name.string
        cell.lblLogIn.text = self.json?[indexPath.row].Login_Time.string
        cell.lblPlanTime.text = self.json?[indexPath.row].Pln_Time.string
        cell.lblLogOut.text = self.json?[indexPath.row].Logout_Time.string
        cell.lblRemarks.text = self.json?[indexPath.row].Remarks.string
        
        return cell
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}


class AttendanceReportcell : UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblWorkName: UILabel!
    
    
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var lblDist: UILabel!
    
    
    @IBOutlet weak var lblLogIn: UILabel!
    @IBOutlet weak var lblPlanTime: UILabel!
    @IBOutlet weak var lblLogOut: UILabel!
    
    
    @IBOutlet weak var lblRemarksTitle: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
