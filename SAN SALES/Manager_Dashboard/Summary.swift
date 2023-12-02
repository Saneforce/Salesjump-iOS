//
//  Summary.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//

import UIKit

class Summary: UIViewController {

    @IBOutlet weak var Date_View: UIView!
    
    @IBOutlet weak var All_Filed: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Date_Card_View
        Date_View.backgroundColor = .white
        Date_View.layer.cornerRadius = 10.0
        Date_View.layer.shadowColor = UIColor.gray.cgColor
        Date_View.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Date_View.layer.shadowRadius = 3.0
        Date_View.layer.shadowOpacity = 0.7
        
        //All_Filed_Card_View
        All_Filed.backgroundColor = .white
        All_Filed.layer.cornerRadius = 10.0
        All_Filed.layer.shadowColor = UIColor.gray.cgColor
        All_Filed.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        All_Filed.layer.shadowRadius = 3.0
        All_Filed.layer.shadowOpacity = 0.7
    }
    

 

}
