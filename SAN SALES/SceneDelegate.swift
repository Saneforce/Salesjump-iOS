//
//  SceneDelegate.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 02/03/22.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var LocationTmr: Timer = Timer()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        // add these lines
        let LocalStoreage = UserDefaults.standard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ConfUser=LocalStoreage.string(forKey: "UserLogged")
        let trackPermission = LocalStoreage.bool(forKey: "TrackPermission")
        if trackPermission != true {
            let mainTabBarController = storyboard.instantiateViewController(identifier: "CheckPermission")
            window?.rootViewController = mainTabBarController
        }else if( ConfUser != nil) {
            
            UserSetup.shared.initUserSetup()
            let Conf=LocalStoreage.string(forKey: "APPConfig")
            if Conf != nil{
                let data = Data(Conf!.utf8)
            
                guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
                else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                
                APIClient.shared.BaseURL=prettyJsonData["BaseURL"] as? String ?? APIClient.shared.BaseURL
                
            }
            let mainTabBarController = storyboard.instantiateViewController(identifier: "NavController")
            window?.rootViewController = mainTabBarController
            StartLocationService()
        }
        
        
        // if user is logged in before
        /*if let loggedUsername = UserDefaults.standard.string(forKey: "username") {
            // instantiate the main tab bar controller and set it as root view controller
            // using the storyboard identifier we set earlier
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            window?.rootViewController = mainTabBarController
        } else {*/
            // if user isn't logged in
            // instantiate the navigation controller and set it as root view controller
            // using the storyboard identifier we set earlier
       //     let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
       //     window?.rootViewController = loginNavController
        //}
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    func StartLocationService()
    {
        LocationService.sharedInstance.getNewLocation(location: { location in
        }, error:{ errMsg in
        })
        self.LocationTmr=Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(getCurrLocation), userInfo: nil, repeats: true)
    }
    @objc func getCurrLocation(){
        LocationService.sharedInstance.getNewLocation(location: { location in
        }, error:{ errMsg in
        })
    }
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        // change the root view controller to your specific view controller
        window.rootViewController = vc
    }
    
}

