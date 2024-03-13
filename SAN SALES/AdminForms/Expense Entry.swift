//
//  Expense Entry.swift
//  SAN SALES
//
//  Created by San eforce on 13/03/24.
//

import UIKit

class Expense_Entry: UIViewController {
    @IBOutlet weak var BackBT: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        BackBT.addTarget(target: self, action: #selector(GotoHome))
    }
    @objc private func GotoHome() {
        self.resignFirstResponder()
   
        self.navigationController?.popViewController(animated: true)
        return
    }
}
