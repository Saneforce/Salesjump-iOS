//
//  End Expense.swift
//  SAN SALES
//
//  Created by San eforce on 28/03/24.
//

import UIKit
import Alamofire

class End_Expense:IViewController {
    
    @IBOutlet weak var Calender_View: UIView!
    
    @IBOutlet weak var BT_Back: UIImageView!
    @IBOutlet weak var End_Expense_Scr: UILabel!
    @IBOutlet weak var Select_Date: LabelSelect!
    @IBOutlet weak var From_plc: UILabel!
    @IBOutlet weak var To_plc: UILabel!
    @IBOutlet weak var Start_KM: UILabel!
    @IBOutlet weak var Mode_OF_Trav: UILabel!
    @IBOutlet weak var Start_Text_KM: EditTextField!
    @IBOutlet weak var Start_Photo: UILabel!
    @IBOutlet weak var Ending_Fare: EditTextField!
    @IBOutlet weak var Ending_fare_Photo: UILabel!
    @IBOutlet weak var Ending_rmk: UITextView!
    @IBOutlet weak var Per_KM: EditTextField!
    
    //views
    @IBOutlet weak var Date_View: UIView!
    @IBOutlet weak var Date_View_Hight: NSLayoutConstraint!
    
    var SelMod:String = ""
    var End_exp_title:String?
    var Date_Nd:Bool?
    var Date:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        End_Expense_Scr.text = End_exp_title
        if Date_Nd == true{
        Date_View.isHidden = true
        Date_View_Hight.constant = 0
        }
        BT_Back.addTarget(target: self, action: #selector(GotoHome))
        Select_Date.addTarget(target: self, action: #selector(Opencalender))
        Start_Photo.addTarget(target: self, action: #selector(openCamera_Km))
        Ending_fare_Photo.addTarget(target: self, action: #selector(openCamera_Ending))
        Start_Photo.layer.cornerRadius = 5
        Start_Photo.layer.masksToBounds = true
        Ending_fare_Photo.layer.cornerRadius = 5
        Ending_fare_Photo.layer.masksToBounds = true
        From_plc.text = "no data"
        To_plc.text = "no data"
        Start_KM.text = "no data"
        Mode_OF_Trav.text = "no data"
        if Date != ""{
            Select_Date.text = Date
        }
    }
    @objc private func GotoHome() {
        if (End_exp_title == "Day End Plan"){
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
            UIApplication.shared.windows.first?.rootViewController = viewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }else{
            GlobalFunc.MovetoMainMenu()
        }
    }
    @objc private func Opencalender(){
        Calender_View.isHidden = false
    }
    @objc private func openCamera_Km(){
        SelMod = "KM"
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "PhotoGallary") as!  PhotoGallary
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @objc private func openCamera_Ending(){
        SelMod = "Ending"
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "PhotoGallary") as!  PhotoGallary
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func Close_Calender_View(_ sender: Any) {
        Calender_View.isHidden = true
    }
    func validate() -> Bool {
        if Select_Date.text == "Select Date"{
            Toast.show(message: "Select Date", controller: self)
            return false
        }
        
        if Start_Text_KM.text == ""{
            Toast.show(message: "Enter Starting KM", controller: self)
            return false
        }
        
        if Ending_Fare.text == "" {
            Toast.show(message: "Enter Ending Fare", controller: self)
            return false
        }
    
        if Ending_rmk.text == ""{
            Toast.show(message: "Enter Ending Remarks", controller: self)
            return false
        }
        
        if Per_KM.text == ""{
            Toast.show(message: "Enter Personal KM", controller: self)
            return false
        }
        
        return true
    }
    @IBAction func Save_Data(_ sender: Any) {
        
        if validate() == false {
            return
        }
        Toast.show(message:"No data" )
    }
    
}
