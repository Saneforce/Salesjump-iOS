//
//  SubmittedDCR.swift
//  SAN SALES
//
//  Created by San eforce on 23/05/23.
//

import UIKit

class SubmittedDCR: UIViewController {

    @IBOutlet weak var BackButton: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        BackButton.addTarget(target: self, action: #selector(closeMenuWin))
        // Do any additional setup after loading the view.
    }
    @objc func closeMenuWin(){
        GlobalFunc.movetoHomePage()
        
    }
}
