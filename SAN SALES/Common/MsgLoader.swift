//
//  MsgLoader.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 04/06/22.
//

import Foundation
import UIKit
struct ProgressDialog {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressDialog.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension UIViewController{
    func ShowLoading(Message: String){
        if let currentAlert = self.presentedViewController as? UIAlertController {
            currentAlert.message =  "\(Message)"
            return
        }
        ProgressDialog.alert = UIAlertController(title: nil, message: Message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        ProgressDialog.alert.view.addSubview(loadingIndicator)
        present(ProgressDialog.alert, animated: true, completion: nil)
        ProgressDialog.alert.message = String(format: "%@",Message)
  }
    func changeMessage(Message: String){
        ProgressDialog.alert.message = Message
    }
  func LoadingDismiss(){
    ProgressDialog.alert.dismiss(animated: true, completion: nil)
  }
}
