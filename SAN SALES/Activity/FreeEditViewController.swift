//
//  FreeEditViewController.swift
//  SAN SALES
//
//  Created by Naga Prasath on 09/12/24.
//

import UIKit

class FreeEditViewController<Item>: IViewController {

    
    @IBOutlet weak var txtQty: UITextField!
    
    
    var qty : Int!
    
    var updateFreeQty : (Item) -> () = { _ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtQty.delegate = self
        self.txtQty.text = "\(qty ?? 0)"
        self.txtQty.addTarget(self, action: #selector(changeQty), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    
    @objc private func changeQty (_ txtQty : UITextField) {
        let qty: Int =  integer(from: txtQty)
        self.txtQty.text = "\(qty)"
    }
    
    func integer(from textField: UITextField) -> Int {
        guard let text = textField.text, let number = Int(text) else {
            return 0
        }
        if text.count > 4 {
               let truncatedText = String(text.prefix(4))
                print(truncatedText)
            var ConvInt2 = 0
            if let ConvInt = Int(truncatedText){
                ConvInt2 = ConvInt
            }
            print(ConvInt2)
               Toast.show(message: "Text count cannot be more than 4 characters.")
            return ConvInt2
            
           }
        return number
    }
    
    
    init() {
        super.init(nibName: "FreeEditViewController", bundle: Bundle(for: FreeEditViewController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func updateAction(_ sender: UIButton) {
        updateFreeQty((Int(self.txtQty.text!) ?? 0) as! Item)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String ) -> Bool {
   
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        let maxLength = 3
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return string == numberFiltered && newString.length <= maxLength
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
