//
//  Secondary order details view.swift
//  SAN SALES
//
//  Created by Anbu j on 06/12/24.
//

import UIKit

class Secondary_order_details_view: UIViewController {
    @IBOutlet weak var Button_back: UIImageView!
    @IBOutlet weak var Dynamic_Header_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Dynamic_Header_lbl.text = "Secondary Order Details For: 2024-12-06"
        Button_back.addTarget(target: self, action: #selector(GotoHome))
    }
   
    
    
    @objc private func GotoHome() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Reports 2", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "DAY_REPORT_WITH_DATE_RANGE") as! DAY_REPORT_WITH_DATE_RANGE
            let navController = UINavigationController(rootViewController: viewController)
            
            UIApplication.shared.windows.first?.rootViewController = navController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
}
