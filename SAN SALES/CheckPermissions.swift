//
//  CheckPermissions.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 21/07/22.
//

import Foundation
import UIKit
import AppTrackingTransparency

class CheckPermissions: UIViewController{
    
    @IBOutlet weak var btnNext: UIButton!
    let LocalStoreage = UserDefaults.standard
    
    override func viewDidLoad() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 16/255, green: 173/255, blue: 194/255, alpha: 1).cgColor, UIColor(red: 51/255, green: 116/255, blue: 130/255, alpha: 1).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        btnNext.layer.cornerRadius = 6
        
    }
    @IBAction func askTrackPermission(){
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                    case .authorized:
                        print("enable tracking")
                    case .denied:
                        print("disable tracking")
                    default:
                        print("disable tracking")
                }
                self.LocalStoreage.set(true, forKey: "TrackPermission")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true, completion: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "sbLogin")

                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                }
            }
        }else{}
    }
}

