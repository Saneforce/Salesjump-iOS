//
//  Attendance.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//

import UIKit

class Attendance: UIViewController {

    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var Team_Size: UIView!
    @IBOutlet weak var In_Market: UIView!
    @IBOutlet weak var Not_Logged_in: UIView!
    @IBOutlet weak var Leave: UIView!
    @IBOutlet weak var Other_Work_Type: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Team_Size.layer.cornerRadius = 5
        In_Market.layer.cornerRadius = 5
        Not_Logged_in.layer.cornerRadius = 5
        Leave.layer.cornerRadius = 5
        Other_Work_Type.layer.cornerRadius = 5
        
        
        
        DateView.layer.cornerRadius = 10
        DateView.layer.shadowColor = UIColor.black.cgColor
        DateView.layer.shadowOpacity = 0.5
        DateView.layer.shadowOffset = CGSize(width: 0, height: 2)
        DateView.layer.shadowRadius = 4
        // Do any additional setup after loading the view.
    }
    

 

}
