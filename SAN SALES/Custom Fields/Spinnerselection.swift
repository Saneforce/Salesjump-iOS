//
//  Spinnerselection.swift
//  SAN SALES
//
//  Created by Anbu j on 30/12/24.
//

import UIKit

class Spinnerselection: UIViewController{
    @IBOutlet weak var BTBack: UIImageView!
    
    var didSelect: (String) -> () = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add gesture recognizer for back button
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeAction))
        BTBack.isUserInteractionEnabled = true
        BTBack.addGestureRecognizer(tapGesture)
        
   
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true)
    }
    
    init() {
        super.init(nibName: "Spinnerselection", bundle: Bundle(for: Spinnerselection.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
}
