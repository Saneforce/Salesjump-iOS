//
//  DAY REPORT WITH DATE RANGE.swift
//  SAN SALES
//
//  Created by Anbu j on 21/10/24.
//

import UIKit
import Alamofire




class DAY_REPORT_WITH_DATE_RANGE: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var BtBack: UIImageView!
    @IBOutlet weak var Hq_View: UIView!
    @IBOutlet weak var Date_View: UIView!
    @IBOutlet weak var Table_View: UITableView!
    @IBOutlet weak var Total_Call_View: UIView!
    @IBOutlet weak var Total_Collection: UICollectionView!
    
    let cardViewInstance = CardViewdata()
    
    let data2 = [
        ["TC:", "PC:", "O. Value", "Pri Ord"],
        ["7", "6", "96.82", "0"]
    ]
    
    
    var SFCode: String=""
    var DivCode: String=""
    var StateCode: String = ""
    var sfName:String = ""
    let LocalStoreage = UserDefaults.standard
    var lstHQs: [AnyObject] = []
    var lObjSel: [AnyObject] = []
    var HQ_Id:String = ""
    var From_Date:String = ""
    var To_Date:String = ""
    
    
    struct Day_Report_Detils:Any{
        var Sf_Name:String
        var Date:String
        var Tc:Int
        var pc:Int
        var Order_Value:String
        var Pri_Ord:Int
        var Brd_Wise_Orde:[String:Any]
        
    }
    
    var Report_Detils:[Day_Report_Detils] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        [Hq_View, Date_View, Table_View, Total_Call_View].forEach { view in
            view?.layer.cornerRadius = 10
        }
        Table_View.delegate = self
        Table_View.dataSource = self
        
        Total_Collection.delegate = self
        Total_Collection.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GotoHome))
        BtBack.isUserInteractionEnabled = true
        BtBack.addGestureRecognizer(tapGesture)
        
        
        if let HQData = LocalStoreage.string(forKey: "HQ_Master"),
           let list = GlobalFunc.convertToDictionary(text:  HQData) as? [AnyObject] {
            lstHQs = list;
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Foundation.Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        From_Date = formattedDate
        To_Date = formattedDate
        HQ_Id = SFCode
        DayRangeReport()
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
    sfName = prettyJsonData["sfName"] as? String ?? ""
    }
    
    
    
    
    

    
    func DayRangeReport() {
        Report_Detils.removeAll()
        let axn = "get/DayRangeReport"
        let apiKey: String = "\(axn)&rptDt=\(From_Date)&rptToDt=\(To_Date)&divisionCode=\(DivCode)&rSF=\(HQ_Id)&sfCode=\(SFCode)&State_Code=\(StateCode)"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL1 + apiKey, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { [self] AFdata in
            print(AFdata)
            switch AFdata.result {
            case .success(let value):
                print(value)
                if let json = value as? [String: Any],let dayrepArray = json["dayrep"] as? [[String: Any]]{
                    print(dayrepArray)
                    
                    for Data in dayrepArray{
                        Report_Detils.append(Day_Report_Detils(Sf_Name: Data["SF_Name"] as? String ?? "", Date: Data["Adate"] as? String ?? "", Tc: Data["Drs"] as? Int ?? 0, pc: Data["orders"] as? Int ?? 0, Order_Value:  Data["orderValue"] as? String ?? "", Pri_Ord: Data["Stk"] as? Int ?? 0, Brd_Wise_Orde: [:]))
                    }
                    
                    
                    if let brndwise = json["brndwise"] as? [[String: Any]]{
                        
                        for Brand_Wise in Report_Detils{
                            let Date = Brand_Wise.Date
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
                            
                            let targetFormatter = DateFormatter()
                            targetFormatter.dateFormat = "yyyy-MM-dd"
                            
                            let targetDate = targetFormatter.date(from:Date)
                            print(targetDate)
                            let StringtargetDate = targetFormatter.string(from: targetDate!)
                            print(StringtargetDate)
                            let filteredData = brndwise.filter { item in
                                
                                let dt = item["dt"] as? [String: Any]
                                print(dt)
                                
                                if let dt = item["dt"] as? [String: Any]{
                                    print(dt)
                                   let dateString = dt["date"] as? String
                                    let date = dateFormatter.date(from: dateString!)
                                    return targetFormatter.string(from: date!) == StringtargetDate
                                    
                                }
                                return false
                            }
                            print(filteredData)
                        }
                    }
                    
                }
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.LoadingDismiss()
                }
            }
        }
    }
    
    
    // MARK: - Collection View DataSource & Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data2[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        cell.lblText.text = data2[0][indexPath.row]
        cell.Test.text = data2[1][indexPath.row]
        return cell
    }
    
    // MARK: - Table View DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DAY_REPORT_WITH_DATE_RANGE_CELL
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 535
    }
    
    // MARK: - Navigation
    
    @objc private func GotoHome() {
        let storyboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbReportsmnu") as! ReportMenu
        
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
}

