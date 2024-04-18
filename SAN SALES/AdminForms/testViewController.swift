//
//  testViewController.swift
//  SAN SALES
//
//  Created by San eforce on 21/03/24.
//

import UIKit

class testViewController: UIViewController {

    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var traveMod: UIView!
    @IBOutlet weak var trvelheight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideViewAndRemoveSpace()
    }
    
    func hideViewAndRemoveSpace() {
        traveMod.isHidden = true
        trvelheight.constant = 0
       }
    

}
