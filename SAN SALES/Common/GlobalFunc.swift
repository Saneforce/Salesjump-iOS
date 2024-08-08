//
//  GlobalFunc.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 21/03/22.
//

import Foundation
import UIKit
import Alamofire

extension String {
    func sizeOfString(maxWidth: CGFloat, font: UIFont) -> CGSize {
        let tmp = NSMutableAttributedString(string: self, attributes:[NSAttributedString.Key.font: font])
        let limitSize = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
        let contentSize = tmp.boundingRect(with: limitSize, options: .usesLineFragmentOrigin, context: nil)
        return contentSize.size
    }
    
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        return dateformatter.date(from: self) ?? Date()
    }
    
    func changeFormat(from: String = "yyyy-MM-dd HH:mm:ss", to: String = "dd MMM yyyy") -> String{
        let date = self.toDate(format: from)
        let dateString = date.toString(format: to)
        return dateString
    }
}
extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return (string as NSString)
            .boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                      options: .usesLineFragmentOrigin,
                                      attributes: [.font: self],
                          context: nil).size
    }
}
extension UIWindow {
    static func keyWindow() -> UIWindow? {
        UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
    }
}
extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}

class IViewController: UIViewController, UITextFieldDelegate{
    let LITTLE_SPACE: CGFloat = 25
    struct MoveKeyboard {
        static let KEYBOARD_ANIMATION_DURATION : CGFloat = 0.3
        static let MINIMUM_SCROLL_FRACTION : CGFloat = 0.2
        static let MAXIMUM_SCROLL_FRACTION : CGFloat = 0.8
        static let PORTRAIT_KEYBOARD_HEIGHT : CGFloat = 216
        static let LANDSCAPE_KEYBOARD_HEIGHT : CGFloat = 162
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        tap.cancelsTouchesInView=false
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        let myViews = view.subviews.filter{$0 is UITextField}
        for sub in myViews {
            (sub as! UITextField).delegate = self
        }
    }
    private func tagBasedTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1

        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
    @objc func dismissMyKeyboard(){
        self.view.endEditing(true)
    }
    //Old
    /*@objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           return
        }
        do {
            let currFrame: CGRect =  (UIResponder.currentFirstResponder?.globalFrame ?? CGRect.zero)
            let textFieldBottomLine: CGFloat = (currFrame.origin.y) + currFrame.height + LITTLE_SPACE
            let viewRect: CGRect = self.view.bounds //(self.view.window?.convert(self.view.bounds, to: self.view))!
            var isTextFieldHidden: Bool = false
            if textFieldBottomLine > (viewRect.size.height - keyboardSize.height){ isTextFieldHidden = true }else{ isTextFieldHidden = false }
            if (isTextFieldHidden) {
                let animatedDistance: CGFloat = textFieldBottomLine - (viewRect.size.height - keyboardSize.height) ;
                self.view.frame.origin.y = self.view.frame.origin.y - animatedDistance
            }
        }catch{
            print(error.localizedDescription)
        }
        
    }*/
    
    // New
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        guard let responder = UIResponder.currentFirstResponder else {
            print("Current first responder is nil")
            return
        }
        
        let currFrame: CGRect = (responder.globalFrame ?? CGRect.zero)
        let textFieldBottomLine: CGFloat = (currFrame.origin.y) + currFrame.height + LITTLE_SPACE
        let viewRect: CGRect = self.view.bounds
        
        var isTextFieldHidden: Bool = false
        if textFieldBottomLine > (viewRect.size.height - keyboardSize.height) {
            isTextFieldHidden = true
        } else {
            isTextFieldHidden = false
        }
        
        if isTextFieldHidden {
            let animatedDistance: CGFloat = textFieldBottomLine - (viewRect.size.height - keyboardSize.height)
            self.view.frame.origin.y = self.view.frame.origin.y - animatedDistance
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIWindow.keyWindow()?.rootViewController
        }
        
        var presented = rootVC?.presentedViewController
        if rootVC?.presentedViewController == nil {
            if let isTab = rootVC?.isKind(of: UITabBarController.self), let isNav = rootVC?.isKind(of: UINavigationController.self) {
                if !isTab && !isNav {
                    return rootVC
                }
                presented = rootVC
            } else {
                return rootVC
            }
        }
        
        if let presented = presented {
            if presented.isKind(of: UINavigationController.self) {
                if let navigationController = presented as? UINavigationController {
                   return navigationController.viewControllers.last!
                }
            }
            
            if presented.isKind(of: UITabBarController.self) {
                if let tabBarController = presented as? UITabBarController {
                    if let navigationController = tabBarController.selectedViewController! as? UINavigationController {
                        return navigationController.viewControllers.last!
                    } else {
                        return tabBarController.selectedViewController!
                    }
                }
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }

    func dismissedAllAlert(completion: (() -> Void)? = nil) {

        if let alert = self.getVisibleViewController(nil) {

        // If you want to dismiss a specific kind of presented controller then
        // comment upper line and uncomment below one

        // if let alert = UIViewController.getVisibleViewController(nil) as? UIAlertController {

            alert.dismiss(animated: true) {
                self.dismissedAllAlert(completion: completion)
            }

        } else {
            completion?()
        }

    }
}
extension Bundle {
    public var appName: String { getInfo("CFBundleName")  }
    public var displayName: String {getInfo("CFBundleDisplayName")}
    public var language: String {getInfo("CFBundleDevelopmentRegion")}
    public var identifier: String {getInfo("CFBundleIdentifier")}
    public var copyright: String {getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    
    public var appBuild: String { getInfo("CFBundleVersion") }
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    //public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    private static weak var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }

    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}

class GlobalFunc{
    
    //MARK:- Convert it with JsonConverter
    static func convertToDictionary(text: String) -> Any? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Any
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func getCollectionView(view: UIView) -> UICollectionView {
        var tbview=view
        while !tbview.isKind(of: UICollectionView.self) { tbview = tbview.superview! }
        return tbview as! UICollectionView
    }
    static func getCollectionViewCell(view: UIView) -> UICollectionViewCell {
        var tbview=view
        while !tbview.isKind(of: UICollectionViewCell.self) { tbview = tbview.superview! }
        return tbview as! UICollectionViewCell
    }
    
    static func getTableView(view: UIView) -> UITableView {
        var tbview=view
        while !tbview.isKind(of: UITableView.self) { tbview = tbview.superview! }
        return tbview as! UITableView
    }
    static func getTableViewCell(view: UIView) -> UITableViewCell {
        var tbview=view
        while !tbview.isKind(of: UITableViewCell.self) { tbview = tbview.superview! }
        return tbview as! UITableViewCell
    }
    static func getCurrDateAsString() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print(Locale.current.identifier)
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.timeZone = TimeZone(identifier: Locale.current.identifier)
        let date = Date()
        return dateFormatter.string(from: date)
    }
    static func movetoHomePage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    static func MovetoMainMenu(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sbMainmnu") as! MainMenu;()
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    static func FieldMasterSync(SFCode: String,completion: (() -> Void)? = nil){
        
        struct mnuItem: Any {
            let MasId: Int
            let MasName: String
            let MasImage: String
            let StoreKey: String
            let ApiKey: String
            let fromData: [String: Any]
        }
        
        var strMasList:[mnuItem]=[]
        
        let LocalStoreage = UserDefaults.standard
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        var downloadCount: Int = 0
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        strMasList.append(mnuItem.init(MasId: 8, MasName: "Route List", MasImage: "mnuPrimary",StoreKey: "Route_Master_"+SFCode, ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"vwTown_Master_APP","coloumns":"[\"town_code as id\", \"town_name as name\",\"target\",\"min_prod\",\"field_code\",\"stockist_code\",\"Allowance_Type\"]","where":"[\"isnull(Town_Activation_Flag,0)=0\"]","orderBy":"[\"name asc\"]","desig":"mgr"
        ]))
        
        strMasList.append(mnuItem.init(MasId: 9, MasName: "Retailers List", MasImage: "mnuPrimary",StoreKey: "Retail_Master_"+SFCode, ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"vwDoctor_Master_APP","coloumns":"[\"doctor_code as id\", \"doctor_name as name\",\"town_code\",\"town_name\",\"lat\",\"long\",\"addrs\",\"ListedDr_Address1\",\"ListedDr_Sl_No\",\"Mobile_Number\",\"Doc_cat_code\",\"ContactPersion\",\"Doc_Special_Code\",\"Distributor_Code\",\"Doctor_Code\",\"gst\",\"createdDate\",\"Doctor_Active_flag\",\"ListedDr_Email\",\"Spec_Doc_Code\",\"debtor_code\"]","where":"[\"isnull(Doctor_Active_flag,0)=0\"]","orderBy":"[\"name asc\"]","desig":"mgr"
            ]))
        
        strMasList.append(mnuItem.init(MasId: 10, MasName: "Distributors List", MasImage: "mnuPrimary",StoreKey: "Distributors_Master_"+SFCode, ApiKey: "table/list&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "tableName":"vwstockiest_Master_APP","coloumns":"[\"distributor_code as id\", \"stockiest_name as name\",\"town_code\",\"town_name\",\"Addr1\",\"Addr2\",\"City\",\"Pincode\",\"GSTN\",\"lat\",\"long\",\"addrs\",\"Tcode\",\"Dis_Cat_Code\"]","where":"[\"isnull(Stockist_Status,0)=0\"]","orderBy":"[\"name asc\"]","desig":"mgr"
        ]))
        
        strMasList.append(mnuItem.init(MasId: 11, MasName: "Supplier List", MasImage: "mnuPrimary",StoreKey: "Supplier_Master_"+SFCode, ApiKey: "get/SupplierMster&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+SFCode+"&sfCode="+SFCode,fromData: [
            "orderBy":"[\"name asc\"]","desig":"mgr"
        ]))
        
        strMasList.append(mnuItem.init(MasId: 16, MasName: "Jointwork", MasImage: "mnuPrimary",StoreKey: "Jointwork_Master_"+SFCode, ApiKey: "get/jointwork&divisionCode="+(prettyJsonData["divisionCode"] as? String ?? "")+"&rSF="+(prettyJsonData["sfCode"] as? String ?? "")+"&sfCode="+SFCode,fromData: [
           "tableName":"salesforce_master","coloumns":"[\"sf_code as id\", \"sf_name as name\"]","orderBy":"[\"name asc\"]","desig":"mgr"
        ]))
        
        for lItm in strMasList {
            let apiKey: String = lItm.ApiKey
            let aIndex: Any = lItm.MasId
            let aFormData: [String: Any] = lItm.fromData
            let aStoreKey:String = lItm.StoreKey
            
            let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            
            let params: Parameters = [
                "data": jsonString
            ]
            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+apiKey, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                AFdata in
                switch AFdata.result
                {
                    case .success(let json):
                        downloadCount += 1
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
                        LocalStoreage.set(prettyPrintedJson, forKey: aStoreKey)
                    case .failure(let error):
                        downloadCount += 1
                        print(error.errorDescription!)
                }
                if(downloadCount >= strMasList.count){
                    
                    completion?()
                    print("download completed")
                }
            }
        }
    }
}
