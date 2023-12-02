//
//  Performance.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//

import UIKit
import Charts

class Performance: UIViewController {

    @IBOutlet weak var OrderTyp: UIView!
    @IBOutlet weak var All_Field_Force: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OrderTyp.backgroundColor = .white
        OrderTyp.layer.cornerRadius = 10.0
        OrderTyp.layer.shadowColor = UIColor.gray.cgColor
        OrderTyp.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        OrderTyp.layer.shadowRadius = 3.0
        OrderTyp.layer.shadowOpacity = 0.7
        
        
        All_Field_Force.backgroundColor = .white
        All_Field_Force.layer.cornerRadius = 10.0
        All_Field_Force.layer.shadowColor = UIColor.gray.cgColor
        All_Field_Force.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        All_Field_Force.layer.shadowRadius = 3.0
        All_Field_Force.layer.shadowOpacity = 0.7
        // Do any additional setup after loading the view.
    }

}
