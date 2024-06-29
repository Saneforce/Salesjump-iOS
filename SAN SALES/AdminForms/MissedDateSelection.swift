//
//  MissedDateSelection.swift
//  SAN SALES
//
//  Created by Naga Prasath on 13/06/24.
//

import Foundation
import UIKit
import Alamofire

class MissedDateSelection : IViewController{
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var lblDate: LabelSelect!
    @IBOutlet weak var lblWorkType: LabelSelect!
    
    @IBOutlet weak var txtRemarks: UITextView!
    
    @IBOutlet weak var vwOrderList: UIView!
    
    
    @IBOutlet weak var vwOrderListHeightConstraints: NSLayoutConstraint!
    
    var lstWType: [AnyObject] = []
    var lstDates: [AnyObject] = []
    
    var json : JSON!
    
    var sfCode = "",divCode = "",desig = "", sfName = "",stateCode = ""
    let LocalStoreage = UserDefaults.standard
    
    
    var selectedWorktype : AnyObject! {
        didSet {
            self.lblWorkType.text = selectedWorktype["name"] as? String
        }
    }
    
    var selectedDate : AnyObject! {
        didSet {
            self.lblDate.text = selectedDate["name"] as? String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
        getUserDetails()
        fetchMissedDate()
        
        lblDate.addTarget(target: self, action: #selector(dateAction))
        lblWorkType.addTarget(target: self, action: #selector(workTypeAction))
        
        vwOrderListHeightConstraints.constant = 0
        vwOrderList.isHidden = true
        
        txtRemarks.delegate = self
        txtRemarks.text = "Enter the remarks"
        txtRemarks.textColor = .lightGray
        
        if let WorkTypeData = LocalStoreage.string(forKey: "Worktype_Master"),
           let list = GlobalFunc.convertToDictionary(text:  WorkTypeData) as? [AnyObject] {
            lstWType = list
        }
        
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
    
    
    func fetchMissedDate() {
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"get/misseddates&sfCode=\(sfCode)&rSF=\(sfCode)&State_Code=\(stateCode)&divisionCode=\(divCode)").validate(statusCode: 200..<209).responseData { AFData in
            switch AFData.result {
                
            case .success(let value):
                print(value)
                    
                let apiResponse = try? JSONSerialization.jsonObject(with: AFData.data!)
                
                guard let response = apiResponse as? AnyObject else {
                    return
                }
                guard let dateArray = response["data"] as? [AnyObject] else{
                    return
                }
                print(response)
                self.lstDates = dateArray

                
            case .failure(let error):
                Toast.show(message: error.errorDescription ?? "", controller: self)
            }
        }
        
        
    }
    
    
    
    @IBAction func secondaryAction(_ sender: UIButton) {
        
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMissedDateRouteSelection") as!  MissedDateRouteSelection
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func primaryAction(_ sender: UIButton) {
        
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMissedDateRouteSelection") as!  MissedDateRouteSelection
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func finalSubmit(_ sender: UIButton) {
        if self.selectedDate == nil {
            Toast.show(message: "Please Select Missed Date", controller: self)
            return
        }
        
        if self.selectedWorktype == nil {
            Toast.show(message: "Please Select WorkType", controller: self)
            return
        }
        
    }
    
    
    @objc private func dateAction() {
        print(self.lstDates)
        let dateVC = ItemViewController(items: lstDates, configure: { (Cell : SingleSelectionTableViewCell, date) in
            Cell.textLabel?.text = date["name"] as? String
        })
        dateVC.title = "Select the Missed Date"
        dateVC.didSelect = { selectedDate in
            print(selectedDate)
            self.selectedDate = selectedDate
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(dateVC, animated: true)
    }
    
    @objc private func workTypeAction() {
        if self.selectedDate == nil {
            Toast.show(message: "Please Select Missed Date", controller: self)
            return
        }
        let worktypeVC = ItemViewController(items: lstWType, configure: { (Cell : SingleSelectionTableViewCell, worktype) in
            Cell.textLabel?.text = worktype["name"] as? String
        })
        worktypeVC.title = "Select the Worktype"
        worktypeVC.didSelect = { selectedWorktype in
            print(selectedWorktype)
            self.selectedWorktype = selectedWorktype
            
            let fwflg = selectedWorktype["FWFlg"] as? String ?? ""
            
            switch fwflg{
                case "F":
                    self.vwOrderListHeightConstraints.constant = 140
                    self.vwOrderList.isHidden = false
                default:
                    self.vwOrderListHeightConstraints.constant = 0
                    self.vwOrderList.isHidden = true
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(worktypeVC, animated: true)
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}


extension MissedDateSelection: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter the remarks"
            textView.textColor = UIColor.lightGray
        }
    }
}
