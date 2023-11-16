//
//  ManagerDashboard.swift
//  SAN SALES
//
//  Created by San eforce on 16/11/23.
//

import UIKit

class ManagerDashboard: UIViewController {
    
    @IBOutlet weak var BackBT: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackBT.addTarget(target: self, action: #selector(GotoHome))
      
    }
    

    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }
}
