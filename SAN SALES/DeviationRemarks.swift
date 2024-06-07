//
//  DeviationRemarks.swift
//  SAN SALES
//
//  Created by Naga Prasath on 07/06/24.
//

import Foundation
import UIKit
import Alamofire
 
class DeviationRemarks : IViewController {
    
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var txtRemarks: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
    }
    
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        
    }
    
    
    func submitDeviation () {
        
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

