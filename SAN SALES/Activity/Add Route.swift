//
//  Add Route.swift
//  SAN SALES
//
//  Created by San eforce on 01/03/24.
//

import UIKit

class Add_Route: IViewController {
    @IBOutlet weak var btnback: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnback.addTarget(target: self, action: #selector(GotoHome))
    }
    @objc private func GotoHome() {
        self.dismiss(animated: true, completion: nil)
        GlobalFunc.MovetoMainMenu()
    }
}
