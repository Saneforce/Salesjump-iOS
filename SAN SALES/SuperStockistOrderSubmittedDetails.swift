//
//  SuperStockistOrderSubmittedDetails.swift
//  SAN SALES
//
//  Created by Naga Prasath on 04/04/24.
//

import Foundation
import UIKit
import Alamofire

class SuperStockistOrderSubmittedDetails : UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var ordetListTableView: UITableView!
    
    
    @IBOutlet weak var orderProductListTableView: UITableView!
    
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    
    @IBOutlet weak var vwProductList: UIView!
    
    
    @IBOutlet weak var lblDistributorsName: UILabel!
    
    
    @IBOutlet weak var lblRoute: UILabel!
    
    
    @IBOutlet weak var lblJointWork: UILabel!
    
    
    
    @IBOutlet weak var lblRouteTitle: UILabel!
    
    
    @IBOutlet weak var orderProductListTableViewHeightConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var detailsTableViewHeigthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    
    
    var SFCode: String = "", StateCode: String = "", DivCode: String = "",Desig: String="", rSF: String = ""
    let LocalStoreage = UserDefaults.standard
    
    
    let axn = "table/list"
    
    var lstSuperStockistDetails : [AnyObject] = []
    
    var lstAllRoutes: [AnyObject] = []
    
    var Input:[inputval]=[]
    
    struct inputval: Any {
        let Key: String
        let Value: String
      
    }
    
    struct Viewval: Any {
        let Product : String
        let qty : Int
        let value : Double
    }
    
    var View:[Viewval]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        imgBack.addTarget(target: self, action: #selector(backVC))
        
        getTransSlNo()
        
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == ordetListTableView {
            return lstSuperStockistDetails.count
        }
        if tableView == orderProductListTableView {
            orderProductListTableViewHeightConstraint.constant = CGFloat(View.count * 50)
            return View.count
        }
        if tableView == detailsTableView {
            detailsTableViewHeigthConstraint.constant = CGFloat(Input.count * 50) //detailsTableView.contentSize.height + 20
          //  scrollViewHeightConstraint.constant = 220+CGFloat(View.count * 50)+CGFloat(Input.count * 50)
            
            let height = 280+CGFloat(View.count * 50)+CGFloat(Input.count * 50)
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: height)
            return Input.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        
        
        if tableView == ordetListTableView {
            let item: [String: Any] = lstSuperStockistDetails[indexPath.row] as! [String : Any]
            cell.Disbutor?.text = item["Trans_Detail_Name"] as? String
            cell.rout.text = item["SDP_Name"] as? String
            cell.meettime.text = item["StartOrder_Time"] as? String
            if let order = item["Order_date"] as? String {
                cell.meettime.text = order
                cell.ordertime.text = order
            }
            cell.ViewButton.addTarget(self, action: #selector(vwProductListAction(_:)), for: .touchUpInside)
            
            cell.EditButton.isHidden = true
            cell.DeleteButton.isHidden = true
            
            cell.vwContainer.layer.cornerRadius = 20
            cell.ViewButton.layer.cornerRadius = 12
            cell.EditButton.layer.cornerRadius = 12
            cell.DeleteButton.layer.cornerRadius = 12
        }
        
        if tableView == orderProductListTableView {
            cell.ProductValue?.text = View[indexPath.row].Product
            cell.Qty?.text = String(View[indexPath.row].qty)
            cell.Value?.text = String(View[indexPath.row].value)
        }
        if tableView == detailsTableView {
            cell.InpuKey.text = Input[indexPath.row].Key
            cell.inputvalu.text = Input[indexPath.row].Value
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == ordetListTableView {
            return 210
        } else{
            return UITableView.automaticDimension
        }//
    }
    
    func getTransSlNo(){
        
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)&dcr_activity_date1=\(Date().toString(format: "yyyy-MM-dd"))"
        let aFormData: [String: Any] = [
            "tableName":"vwactivity_report","coloumns":"[\"*\"]","today":2,"wt":1,"orderBy":"[\"activity_date asc\"]","desig":"mgr"
        ]
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseData { AFdata in
            self.LoadingDismiss()
            switch AFdata.result
            {
                
            case .success(let value):
                print(value)
                
                
                let apiResponse = try? JSONSerialization.jsonObject(with: AFdata.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                guard let response = apiResponse as? [[String : Any]] else{
                    return
                }
                
                print(response)
                print(response.first?["Trans_SlNo"] as? String ?? "")
                
                self.getSuperStockistDetails(transSlNo: response.first?["Trans_SlNo"] as? String ?? "")
                
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    func getSuperStockistDetails(transSlNo : String) {
        
        
 //   http://fmcg.salesjump.in/server/native_Db_V13.php?State_Code=24&desig=MR&divisionCode=29%2C&rSF=SEFMR0040&axn=table%2Flist&sfCode=SEFMR0040&stateCode=24
        
        
        let apiKey: String = "\(axn)&divisionCode=\(DivCode)&desig=\(Desig)&rSF=\(SFCode)&sfCode=\(SFCode)&State_Code=\(StateCode)"
        let aFormData: [String: Any] = [
            "tableName":"vwActivity_SuperCSH_Detail","coloumns":"[\"*\"]","where":"[\"Trans_SlNo='\(transSlNo)'\"]","or":8,"orderBy":"[\"stk_meet_time\"]","desig":"mgr"
            
            
        ]
        
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseData { AFdata in
            self.LoadingDismiss()
            switch AFdata.result
            {
                
            case .success(let value):
                
                let apiResponse = try? JSONSerialization.jsonObject(with: AFdata.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                guard let response = apiResponse as? [AnyObject] else{
                    return
                }
                
                self.lstSuperStockistDetails = response
                
                if self.lstSuperStockistDetails.isEmpty {
                    self.ordetListTableView.isHidden = true
                }else{
                    self.ordetListTableView.isHidden = false
                }
                
                self.ordetListTableView.reloadData()
                print(self.lstSuperStockistDetails)
                
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        
        self.vwProductList.isHidden = true
    }
    
    @objc func vwProductListAction(_ sender : UIButton) {
        self.vwProductList.isHidden = false
        Input.removeAll()
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.ordetListTableView)
        guard let indexPath = self.ordetListTableView.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        let product = self.lstSuperStockistDetails[indexPath.row]
        
        print(product)
        
        let Id_For_Route = product["SDP"] as? String
        
        self.lblDistributorsName.text = product["Trans_Detail_Name"] as? String
        self.lblRoute.text = product["SDP_Name"] as? String
        self.lblJointWork.text = product["Worked_with_Name"] as? String
            
        Input.append(inputval(Key: "Meet Time", Value: product["Order_date"] as? String ?? ""))
        Input.append(inputval(Key: "Order Time", Value: product["Order_date"] as? String ?? ""))
        if let pobValue = product["POB_Value"] as? Double {
            Input.append(inputval(Key: "Order Value", Value: String(pobValue)))
        } else {
            Input.append(inputval(Key: "Order Value", Value: ""))
        }

        Input.append(inputval(Key: "Remarks", Value: product["Activity_Remarks"] as? String ?? ""))
        print(Input)
        detailsTableView.reloadData()
        
            let Additional_Prod_Dtls = product["Additional_Prod_Dtls"] as! String
            let productArray = Additional_Prod_Dtls.components(separatedBy: "#")
        print(productArray)
        View.removeAll()
        if (Additional_Prod_Dtls == ""){
            print("No Data")
            orderProductListTableView.reloadData()
        }else{
            for product in productArray {
                let productData = product.components(separatedBy: "@")
                print(productData[0])
                let productData2 = productData[0]
                print(productData2)
                
                let productDatas = productData2.components(separatedBy: "~")
                print(productDatas[0])
                let price = productDatas[1].components(separatedBy: "$")[0]
                let price1 = productDatas[1].components(separatedBy: "$")[1]
                print(price1)
                print(price)
                
                View.append(Viewval(Product:productDatas[0] , qty: Int(price1)!, value: Double(price)!))
                print(View)
                orderProductListTableViewHeightConstraint.constant = CGFloat(View.count * 50)
                orderProductListTableView.reloadData()
                
            }
        }

        detailsTableViewHeigthConstraint.constant = CGFloat(Input.count * 50)
        
        orderProductListTableViewHeightConstraint.constant = CGFloat(View.count * 50)
        let height = 220+CGFloat(View.count * 50)+CGFloat(Input.count * 50)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: height)
        
        print(height)
        print(CGFloat(View.count * 50))
        self.orderProductListTableView.reloadData()
        self.detailsTableView.reloadData()
        self.view.layoutIfNeeded()
        
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
