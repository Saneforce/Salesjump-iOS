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
        self.txtQty.text = "\(qty ?? 0)"
        // Do any additional setup after loading the view.
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
