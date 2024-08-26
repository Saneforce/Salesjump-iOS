//
//  RateEditViewController.swift
//  SAN SALES
//
//  Created by Naga Prasath on 24/08/24.
//

import UIKit

class RateEditViewController<Item>: IViewController {
    
    
    
    @IBOutlet weak var txtRate: UITextField!
    
    var rate : Double!
    
    var updateRate : (Item) -> () = { _ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtRate.text = "\(rate ?? 0)"
        txtRate.addTarget(self, action: #selector(rateEditAction(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func rateEditAction(_ sender : UITextField){
        let value = validateDoubleInput(textField: sender)
        
        print(value)
    }
    
    init() {
        super.init(nibName: "RateEditViewController", bundle: Bundle(for: RateEditViewController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    func validateDoubleInput(textField: UITextField) -> Double? {
      guard let text = textField.text, !text.isEmpty else {
        return nil
      }
      return Double(text)
    }
    
    @IBAction func CloseAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
    @IBAction func updateAction(_ sender: UIButton) {
        updateRate((Double(self.txtRate.text!) ?? 0) as! Item)
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
