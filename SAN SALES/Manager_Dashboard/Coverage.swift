//
//  Coverage.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//

import UIKit

class Coverage: UIViewController {

    @IBOutlet weak var Custom_date: UIView!
    @IBOutlet weak var From_and_to_date: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Custom_date.backgroundColor = .white
        Custom_date.layer.cornerRadius = 10.0
        Custom_date.layer.shadowColor = UIColor.gray.cgColor
        Custom_date.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Custom_date.layer.shadowRadius = 3.0
        Custom_date.layer.shadowOpacity = 0.7
        
        From_and_to_date.backgroundColor = .white
        From_and_to_date.layer.cornerRadius = 10.0
        From_and_to_date.layer.shadowColor = UIColor.gray.cgColor
        From_and_to_date.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        From_and_to_date.layer.shadowRadius = 3.0
        From_and_to_date.layer.shadowOpacity = 0.7
        // Do any additional setup after loading the view.
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
