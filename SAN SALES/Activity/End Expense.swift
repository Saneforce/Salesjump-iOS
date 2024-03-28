//
//  End Expense.swift
//  SAN SALES
//
//  Created by San eforce on 28/03/24.
//

import UIKit
import Alamofire

class End_Expense: UIViewController {
    @IBOutlet weak var BT_Back: UIImageView!
    @IBOutlet weak var End_Expense_Scr: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BT_Back.addTarget(target: self, action: #selector(GotoHome))
    }
    
    @objc private func GotoHome() {
        GlobalFunc.MovetoMainMenu()
    }
}
