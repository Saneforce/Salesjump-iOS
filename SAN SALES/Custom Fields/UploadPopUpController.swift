//
//  UploadPopUpController.swift
//  SAN SALES
//
//  Created by Anbu j on 19/12/24.
//

import UIKit

class UploadPopUpController: UIViewController {

    @IBOutlet weak var PopupView: UIView!
    @IBOutlet weak var Closepopup: UIImageView!
    @IBOutlet weak var LiveCamera: UIImageView!
    @IBOutlet weak var SelectFile: UIImageView!
    
     var didSelect : (String) -> () = { _ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        PopupView.layer.cornerRadius = 8
        Closepopup.addTarget(target: self, action: #selector(closeAction))
        SelectFile.addTarget(target: self, action: #selector(selectedfileName))
    }
   @objc func closeAction() {
        self.dismiss(animated: true)
    }
    
    init() {
        super.init(nibName: "UploadPopUpController", bundle: Bundle(for: UploadPopUpController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    @objc func selectedfileName () {
        didSelect("Test")
     }

}
