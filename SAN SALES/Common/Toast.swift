//
//  Toast.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 18/03/22.
//

import Foundation
import UIKit

class Toast {
    static var pNotifyView = UILabel()
    static func showToast(message: String){
        DispatchQueue.main.async {
            let toastView = UILabel()
            var keyWindow: UIWindow? {
                    if #available(iOS 13, *) {
                        return UIApplication.shared.windows.first { $0.isKeyWindow }
                    } else {
                        return UIApplication.shared.keyWindow
                    }
                }
            toastView.text = message
            toastView.textColor = UIColor.white
            toastView.backgroundColor = UIColor.red.withAlphaComponent(0.9)
            toastView.textAlignment = .center
            toastView.frame = CGRect(x: 0.0, y: 0.0, width: (keyWindow?.frame.size.width)!, height: 80) //(keyWindow?.frame.size.height)!)
            //toastView.layer.cornerRadius = 10
            toastView.layer.masksToBounds = true
            toastView.isUserInteractionEnabled=true
//            toastView.center = (keyWindow?.center)!
            keyWindow?.addSubview(toastView)
            pNotifyView = toastView
        }
    }
    static func removeNotification(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 3.0, delay: 0, options: .curveEaseOut, animations: {
                pNotifyView.alpha = 0.0;
            }, completion: { _ in
                pNotifyView.removeFromSuperview()
            })
        }
    }
    static func show(message: String, controller: UIViewController? = nil) {   //
        DispatchQueue.main.async {
            var keyWindow: UIWindow? {
                if #available(iOS 13, *) {
                    return UIApplication.shared.windows.first { $0.isKeyWindow }
                } else {
                    return UIApplication.shared.keyWindow
                }
            }
            let toastLabel = UILabel(frame: CGRect())
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font.withSize(12.0)
            toastLabel.text = message
            toastLabel.clipsToBounds  =  true
            toastLabel.numberOfLines = 0
            //let rect: CGSize = UIFont().sizeOfString(string: message, constrainedToWidth: (keyWindow?.frame.size.width)! - 30.0)
            let rect: CGSize = message.sizeOfString(maxWidth: (keyWindow?.frame.size.width)! - 30.0, font:
                                                        toastLabel.font)
            //(string: message, constrainedToWidth: (keyWindow?.frame.size.width)! - 30.0)
            let toastContainer = UIView(frame: CGRect())
            toastContainer.frame = CGRect(x: 0, y: 0, width: rect.width+32, height: rect.height+20)
            toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastContainer.alpha = 0.0
            toastContainer.layer.cornerRadius = 10;
            toastContainer.clipsToBounds  =  true
            toastContainer.center = (keyWindow?.center)!

            
            toastLabel.frame = CGRect(x: 16.0, y: 10.0, width: rect.width, height: rect.height)
        

            toastContainer.addSubview(toastLabel)
        //controller.view.addSubview(toastContainer)
        keyWindow?.addSubview(toastContainer)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
        
       /* UIView.animate(withDuration: 3.0, delay: 0, options: .curveEaseOut, animations: {
        toastContainer.alpha = 0.0;
    }, completion: { _ in
        toastContainer.removeFromSuperview()
    })
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])

            let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: keyWindow?, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .centerY, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })*/
        }
    }
}
