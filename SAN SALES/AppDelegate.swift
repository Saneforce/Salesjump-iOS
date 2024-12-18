//
//  AppDelegate.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 02/03/22.
//

import UIKit
import AWSS3
import AWSCore
import AWSCognito

@main

class AppDelegate: UIResponder, UIApplicationDelegate{
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //declare this property where it won't go out of scope relative to your listener
        
        OfflineCallSync.shared
        //declare this inside of viewWillAppear
        NetworkMonitor.Shared.startMonitoring()
        self.initializeS3()
        return true
    }

    // MARK: UISceneSession Lifecycle 

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func initializeS3(){
          let poolId = "ap-south-1:c4c0fc81-118d-43e3-84cf-051f1bd831b9"
          let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .APSouth1, identityPoolId: poolId)
        let configuration = AWSServiceConfiguration(region: .APSouth1, credentialsProvider: credentialsProvider)
          AWSServiceManager.default().defaultServiceConfiguration = configuration
}
    
}
