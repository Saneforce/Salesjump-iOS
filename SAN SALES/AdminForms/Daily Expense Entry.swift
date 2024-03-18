//
//  Daily Expense Entry.swift
//  SAN SALES
//
//  Created by San eforce on 13/03/24.
//

import UIKit

class Daily_Expense_Entry: IViewController {

    @IBOutlet weak var ButtonBack: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ButtonBack.addTarget(target: self, action: #selector(GotoHome))
    }
    @objc private func GotoHome() {
        self.resignFirstResponder()
   
        self.navigationController?.popViewController(animated: true)
        return
       
    }
    @IBAction func Save_Exp(_ sender: Any) {
        self.resignFirstResponder()
   
        self.navigationController?.popViewController(animated: true)
        return
    }
}
