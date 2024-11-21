//
//  OfflineCallSync.swift
//  SAN SALES
//
//  Created by Naga Prasath on 19/11/24.
//

import Foundation
import Reachability
import Alamofire


class OfflineCallSync : NSObject{
    
    static let shared = OfflineCallSync()
    var reachability: Reachability!
    
    override init(){
        super.init()
        self.updateReachability()
    }
    
    func updateReachability(){
        self.reachability = try! Reachability()
        
        self.reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                self.outboxAPI()
            } else {
                print("Reachable via Cellular")
                self.outboxAPI()
                
            }
        }
        self.reachability.whenUnreachable = { _ in
            print("Not reachable")
           // self.topMostViewController().showToast(with: "Internet is disconnected...Now in offline mode")
        }

        do {
            try self.reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopNotification(){
        self.reachability.stopNotifier()
    }
    
    
    func outboxAPI(){
        // self.updateOutboxVC()
        DispatchQueue.global(qos: .background).async {
            let outboxes = UserDefaults.standard.object(forKey: "SecondaryOrderData") as? [[String : Any]]
            guard let outbox = outboxes?.first else{
                return
            }
            self.callOutBox(outbox: outbox) { (_) in
                self.outboxAPI()
            }
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
            }
        }
        
    }
    
    func callOutBox(outbox:[String: Any],callback:@escaping SyncCallBack){
        let params = outbox["params"] as? [String: String] ?? [String: String]()
        
        let LocalStoreage = UserDefaults.standard
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        let SFCode = prettyJsonData["sfCode"] as? String ?? ""
        let StateCode = prettyJsonData["State_Code"] as? String ?? ""
        let DivCode = prettyJsonData["divisionCode"] as? String ?? ""

        
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + DivCode + "&rSF=" + SFCode + "&sfCode=" + SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseData {
            AFdata in
            switch AFdata.result
            {
                
            case .success(let value):
                print(value)
                
                let apiResponse = try? JSONSerialization.jsonObject(with: AFdata.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                print(apiResponse as Any)
//                
//                let outboxes = UserDefaults.standard.object(forKey: "SecondaryOrderData") as? [[String : Any]]
//                
//                var checkInDatas = UserDefaults.standard.object(forKey: "SecondaryOrderData") as? [[String : Any]]
//                if !checkInDatas.isEmpty {
//                    checkInDatas.removeFirst()
//                    UserDefaults.standard.object(forKey: "SecondaryOrderData") as? [[String : Any]]
//                    callback(true)
//                }
                
                var totalCalls = [[String : Any]]()
                if let calls = UserDefaults.standard.object(forKey: "SecondaryOrderData") as? [[String : Any]] {
                    totalCalls = calls
                    
                    if !totalCalls.isEmpty {
                        totalCalls.removeFirst()
                        UserDefaults.standard.set(totalCalls, forKey: "SecondaryOrderData")
                        UserDefaults.standard.synchronize()
                        callback(true)
                    }
                }
                
            case .failure(let error):
                print(error)
    //            let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
    //            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
    //                return
    //            })
    //            self.present(alert, animated: true)
            }
        }
    }
}
