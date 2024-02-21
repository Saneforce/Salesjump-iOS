//
//  ViewController.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 02/03/22.
//

import UIKit
import Alamofire

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

class ViewController: IViewController {
    @IBOutlet weak var txUsrNm: UITextField!
    @IBOutlet weak var txSFName: UITextField!
    @IBOutlet weak var txPwd: UITextField!
    @IBOutlet weak var lblVer: UILabel!
    @IBOutlet weak var btSign: UIButton!
    
    var alert: UIAlertController = UIAlertController()
//
//    struct MoveKeyboard {
//        static let KEYBOARD_ANIMATION_DURATION : CGFloat = 0.3
//        static let MINIMUM_SCROLL_FRACTION : CGFloat = 0.2;
//        static let MAXIMUM_SCROLL_FRACTION : CGFloat = 0.8;
//        static let PORTRAIT_KEYBOARD_HEIGHT : CGFloat = 216;
//        static let LANDSCAPE_KEYBOARD_HEIGHT : CGFloat = 162;
//    }
    
    var lstPlnDets: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblVer.text = "App Version \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild)) "
        txSFName.layer.cornerRadius=20.0
        txSFName.layer.borderWidth=1.0
        txSFName.layer.borderColor=UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0).cgColor
        txSFName.setLeftPaddingPoints(10.0)
        txSFName.setRightPaddingPoints(10.0)
        
        txUsrNm.layer.cornerRadius=20.0
        txUsrNm.layer.borderWidth=1.0
        txUsrNm.layer.borderColor=UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0).cgColor
        txUsrNm.setLeftPaddingPoints(10.0)
        txUsrNm.setRightPaddingPoints(10.0)
        
        txPwd.layer.cornerRadius=20.0
        txPwd.layer.borderWidth=1.0
        txPwd.layer.borderColor=UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0).cgColor
        txPwd.setLeftPaddingPoints(10.0)
        txPwd.setRightPaddingPoints(10.0)
        
        btSign.layer.cornerRadius=20.0
        btSign.layer.borderWidth=0.0
        #if DEBUG
       // txUsrNm.text="SANTNFO2"
       // txPwd.text="SAN"
        
        #endif
        
        
        let LocalStoreage = UserDefaults.standard
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        txUsrNm.isHidden=false
        txSFName.isHidden=true
        if prettyPrintedJson != nil {
            let data = Data(prettyPrintedJson!.utf8)
            
            guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
            else {
                print("Error: Cannot convert JSON object to Pretty JSON data")
                return
            }
            txSFName.text = prettyJsonData["sfName"] as? String
            txUsrNm.text = prettyJsonData["sfCode"] as? String ?? ""
            txUsrNm.isHidden=true
            txSFName.isHidden=false
        }
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//            target: self,
//            action: #selector(dismissMyKeyboard))
//        view.addGestureRecognizer(tap)
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        let formatters = DateFormatter()
        formatters.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatters.string(from: Date())
        let defaults = UserDefaults.standard
        defaults.set(formattedDate, forKey: "storedDate")
        
    }
    @IBAction func signin(_ sender: Any) {
        
        if txUsrNm.text?.isEmpty==true {
           /* let alert = UIAlertController(title: "Information", message: "Enter the User Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                return
            })
            self.present(alert, animated: true)*/
            txUsrNm.becomeFirstResponder()
            return
        }
        if txPwd.text?.isEmpty==true {
            txPwd.becomeFirstResponder()
            return
        }
        let CompDet:[String] = (txUsrNm.text?.components(separatedBy: "-"))!
        let LocalStoreage = UserDefaults.standard
        self.ShowLoading(Message: "Please wait...")
        let Conf=LocalStoreage.string(forKey: "APPConfig")
        if Conf==nil &&  ((txUsrNm.text?.firstIndex(of: "-")) != nil) {
            AF.request("http://fmcg.sanfmcg.com/server/url_config.json", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                AFdata in
                switch AFdata.result
                {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let CompSH: String = CompDet[0] as! String
                        let config:[String:Any] = json[CompSH] as? [String: Any] ?? [:]
                        if config.count > 0 {
                            APIClient.shared.BaseURL = config["base_url"] as! String ?? APIClient.shared.BaseURL
                        }
                        self.userAuth()
                    }
                case .failure(_):
                    print("Using Default Config")
                    self.LoadingDismiss()
                }
            }
        }
        else {
            if Conf != nil{
                let data = Data(Conf!.utf8)
            
                guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
                else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    self.LoadingDismiss()
                    return
                }
                
                APIClient.shared.BaseURL=prettyJsonData["BaseURL"] as? String ?? APIClient.shared.BaseURL
            }
            userAuth()
        }
        
    }
   /* func MsgLoader(){
        alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }*/
    func userAuth() {
        let parmJsonData: [String: Any]=[
            "name": txUsrNm.text! as String,
            "password":txPwd.text! as String,
            "DeviceRegId":""
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parmJsonData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"login", method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            switch AFdata.result
            {
                case .success(let value):
                print(value)
                if let json = value as? [String: Any] {
                    if json["success"] as! Bool == false {
                        Toast.show(message: json["msg"] as! String) //, controller: self
                        self.LoadingDismiss()
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        self.LoadingDismiss()
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        self.LoadingDismiss()
                        return
                    }
                    let LocalStoreage = UserDefaults.standard
                    let AppConfig: [String: Any]=[
                        "BaseURL": APIClient.shared.BaseURL,
                        "DBURL": APIClient.shared.DBURL
                    ]
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: AppConfig, options: [])
                    let jsonString = String(data: jsonData!, encoding: .utf8)!
                    LocalStoreage.set(jsonString, forKey: "APPConfig")
                    LocalStoreage.set(prettyPrintedJson, forKey: "UserDetails")
                    //                        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"login", method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                    //                            AFdata in
                    self.LoadingDismiss()
                    //                            switch AFdata.result
                    //                            {
                    //                            case .success(let value):
                    //                                if let json = value as? [String: Any] {
                    /// checking
                    self.SyncSetup(){
                        let sWTDets=LocalStoreage.string(forKey: "Worktype_Master")
                        LocalStoreage.set(true, forKey: "UserLogged")
                        if sWTDets==nil {
                            let vc=self.storyboard?.instantiateViewController(withIdentifier: "MasterSyncVwControl") as!  MasterSync
                            vc.modalPresentationStyle = .overCurrentContext
                            self.present(vc, animated: true, completion: nil)
                        } else {
                            let sDyPlnDets=LocalStoreage.string(forKey: "Mydayplan")?.replacingOccurrences(of: "\n", with: "")
                            var myDyPlFl:Bool=false
                            /*if sDyPlnDets==nil {
                             myDyPlFl=true
                             }else{
                             let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
                             if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
                             self.lstPlnDets = list;
                             }else{
                             myDyPlFl=true
                             }
                             
                             if( self.lstPlnDets.isEmpty || self.lstPlnDets.count<1){ myDyPlFl=true }
                             
                             }*/
                            if myDyPlFl==true {
                                let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbMydayplan") as!  MydayPlanCtrl
                                vc.modalPresentationStyle = .overCurrentContext
                                self.present(vc, animated: true, completion: nil)
                                
                            } else {
                                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                                UIApplication.shared.windows.first?.rootViewController = viewController
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                            }
                        }
                    }
 //                               }
//                            case .failure(_):
//                                print("Error")
//                            }
                       // }
                        
                    }
                case .failure(let error):
                    self.LoadingDismiss()
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                        return
                    })
                    self.present(alert, animated: true)
            }
        }
    }
    

    
//    @objc func dismissMyKeyboard(){
//        view.endEditing(true)
//    }
//    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//           return
//        }
//        self.view.frame.origin.y = 0 - keyboardSize.height
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        self.view.frame.origin.y = 0
//    }
    
    func SyncSetup(completion: (() -> Void)? = nil) {
        let LocalStoreage = UserDefaults.standard
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        let SFCode: String=prettyJsonData["sfCode"] as? String ?? ""
        let params: Parameters = [
            "data": "[]"
        ]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"get/setup&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
            AFdata in
            switch AFdata.result
            {
                case .success(let json):
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }

                    print(prettyPrintedJson)
                    let LocalStoreage = UserDefaults.standard
                    LocalStoreage.set(prettyPrintedJson, forKey: "UserSetup")
                    UserSetup.shared.initUserSetup()
                
                    completion?()
                case .failure(let error):
                    print(error.errorDescription!)
                    completion?()
                    /*let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                        return
                    })
                    self.present(alert, animated: true)*/
            }
        }
    }
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    func checkIfSessionExpired() -> Bool {
        let defaults = UserDefaults.standard
        let loginTime = defaults.object(forKey: "loginTime") as? Date
        let allowedDuration: TimeInterval = 3600
        let currentTime = Date()
        
        guard let timeSinceLogin = loginTime?.timeIntervalSince(currentTime),
              abs(timeSinceLogin) < allowedDuration else {
           
            return true
        }
        
        defaults.set(currentTime, forKey: "loginTime")
        return false
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        if checkIfSessionExpired() {
        }
    }
}

