//
//  Start Expense.swift
//  SAN SALES
//
//  Created by San eforce on 28/03/24.
//

import UIKit
import Alamofire

class Start_Expense: UIViewController {

    @IBOutlet weak var BT_Back: UIImageView!
    @IBOutlet weak var Start_Expense_Scr: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BT_Back.addTarget(target: self, action: #selector(GotoHome))
    }
    @objc private func GotoHome() {
        GlobalFunc.MovetoMainMenu()
    }
}
